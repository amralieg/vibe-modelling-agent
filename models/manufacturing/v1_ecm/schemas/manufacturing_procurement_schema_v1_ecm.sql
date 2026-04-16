-- Schema for Domain: procurement | Business: Manufacturing | Version: v1_ecm
-- Generated on: 2026-04-16 07:42:35

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`procurement` COMMENT 'Governs end-to-end procurement and supply chain planning including supplier master data, MRP/MRP II planning, demand forecasting, strategic sourcing, purchase requisitions, PO lifecycle, GRN processing, supplier performance tracking, vendor qualification, spend analytics, category management, and procurement compliance for direct and indirect materials';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` (
    `procurement_supplier_contact_id` BIGINT COMMENT 'Unique system-generated identifier for the supplier contact record within the procurement domain. Serves as the primary key for all downstream joins and references.',
    `contact_id` BIGINT COMMENT 'External identifier assigned to this contact within SAP Ariba Supplier Management, enabling traceability back to the system of record.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: supplier_contact belongs to a specific supplier organization. The table currently stores supplier_code and supplier_name as denormalized strings. Adding supplier_id FK normalizes this relationship and',
    `ariba_portal_username` STRING COMMENT 'Username or login ID used by the supplier contact to access the SAP Ariba Supplier Portal. Stored for account management and access audit purposes.',
    `contact_role` STRING COMMENT 'Functional role classification of the supplier contact within the procurement relationship, determining which sourcing events, audits, or communications they are engaged in.. Valid values are `account_manager|quality_engineer|logistics_coordinator|executive_sponsor|technical_support|commercial_contact|regulatory_contact|other`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the country where the supplier contact is physically located, used for regional segmentation and compliance with local data privacy regulations.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when the supplier contact record was first created in the system, used for audit trail, data lineage, and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `data_privacy_region` STRING COMMENT 'Regulatory region governing the data privacy obligations applicable to this supplier contact (e.g., EU for GDPR, US for CCPA), used to apply the correct data handling and retention policies.. Valid values are `EU|US|APAC|LATAM|MEA|OTHER`',
    `department` STRING COMMENT 'Organizational department within the supplier company to which this contact belongs (e.g., Sales, Quality, Logistics, Engineering, Finance), supporting targeted communication routing.',
    `effective_end_date` DATE COMMENT 'Date on which this supplier contact record was deactivated or expired. Null for currently active contacts. Used for historical reporting and data retention compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_start_date` DATE COMMENT 'Date from which this supplier contact record became active and eligible for procurement communications and sourcing event participation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `email` STRING COMMENT 'Primary business email address of the supplier contact, used for sourcing event invitations, RFQ/RFP distribution, purchase order notifications, and supplier performance communications via SAP Ariba.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `fax_number` STRING COMMENT 'Fax number for the supplier contact, retained for legacy document exchange requirements in regulated industries and international trade documentation.. Valid values are `^+?[0-9s-().]{7,20}$`',
    `first_name` STRING COMMENT 'Given name of the supplier contact individual, used for personalized communication in sourcing events and supplier relationship management.',
    `gdpr_consent_date` DATE COMMENT 'Date on which the supplier contact provided GDPR consent for personal data processing, required for compliance audit trails under GDPR Article 7.. Valid values are `^d{4}-d{2}-d{2}$`',
    `gdpr_consent_given` BOOLEAN COMMENT 'Indicates whether the supplier contact has provided explicit consent for the processing of their personal data under GDPR Article 6, applicable to contacts located in the European Union.. Valid values are `true|false`',
    `invoice_notification` BOOLEAN COMMENT 'Indicates whether this contact is configured to receive invoice status and payment notifications through SAP Ariba, supporting accounts receivable management on the supplier side.. Valid values are `true|false`',
    `is_ariba_portal_user` BOOLEAN COMMENT 'Indicates whether this supplier contact has an active login account on the SAP Ariba Supplier Portal, enabling self-service participation in sourcing events, PO acknowledgment, and invoice submission.. Valid values are `true|false`',
    `is_primary_contact` BOOLEAN COMMENT 'Indicates whether this contact is the designated primary point of contact for the supplier organization. Only one contact per supplier should be flagged as primary for default communication routing.. Valid values are `true|false`',
    `job_title` STRING COMMENT 'Official job title of the supplier contact (e.g., Account Manager, Quality Engineer, Logistics Coordinator, Executive Sponsor), used to route communications to the appropriate functional role.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the supplier contact record, supporting change tracking, data freshness monitoring, and incremental ETL processing in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_name` STRING COMMENT 'Family name or surname of the supplier contact individual, used in formal correspondence and supplier relationship management workflows.',
    `mobile_phone` STRING COMMENT 'Mobile or cell phone number of the supplier contact, used for urgent communications, on-site coordination, and after-hours escalation during supply disruptions.. Valid values are `^+?[0-9s-().]{7,20}$`',
    `nda_expiry_date` DATE COMMENT 'Date on which the supplier contacts NDA expires. Contacts with expired NDAs must re-sign before participating in restricted sourcing events or receiving confidential technical documentation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `nda_signed` BOOLEAN COMMENT 'Indicates whether this supplier contact has signed a Non-Disclosure Agreement (NDA), required before participation in confidential sourcing events or access to proprietary design specifications.. Valid values are `true|false`',
    `nda_signed_date` DATE COMMENT 'Date on which the supplier contact executed the Non-Disclosure Agreement, used to validate NDA currency and enforce expiry-based re-signing requirements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `notes` STRING COMMENT 'Free-text field for procurement team annotations about the supplier contact, such as communication preferences, relationship history, escalation notes, or special instructions.',
    `phone` STRING COMMENT 'Primary business phone number of the supplier contact including country dialing code, used for direct communication during procurement negotiations, quality escalations, and logistics coordination.. Valid values are `^+?[0-9s-().]{7,20}$`',
    `po_notification` BOOLEAN COMMENT 'Indicates whether this contact is configured to receive automated purchase order transmission notifications from SAP Ariba or SAP S/4HANA MM.. Valid values are `true|false`',
    `preferred_communication_channel` STRING COMMENT 'The supplier contacts preferred method of communication for procurement-related interactions, used to optimize engagement in sourcing events, PO confirmations, and performance reviews.. Valid values are `email|phone|ariba_portal|fax|video_conference|other`',
    `preferred_language` STRING COMMENT 'ISO 639-1 language code representing the supplier contacts preferred language for written and verbal communications (e.g., en, de, zh-CN, fr), supporting multinational supplier engagement.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `sourcing_event_notification` BOOLEAN COMMENT 'Indicates whether this contact has opted in to receive automated notifications for new sourcing events (RFQ/RFP) relevant to their commodity scope, as managed in SAP Ariba.. Valid values are `true|false`',
    `status` STRING COMMENT 'Current operational status of the supplier contact record. Active contacts are eligible for sourcing event invitations and procurement communications. Inactive or do_not_contact statuses suppress outreach.. Valid values are `active|inactive|pending|do_not_contact`',
    `supplier_site_code` STRING COMMENT 'Code identifying the specific supplier facility or site (plant, warehouse, office) that this contact is associated with, enabling site-level communication routing for multi-site suppliers.',
    `time_zone` STRING COMMENT 'IANA time zone identifier for the supplier contacts location (e.g., America/New_York, Europe/Berlin), used to schedule meetings, sourcing events, and deadline communications across global operations.',
    CONSTRAINT pk_procurement_supplier_contact PRIMARY KEY(`procurement_supplier_contact_id`)
) COMMENT 'Contacts associated with supplier organizations including account managers, quality representatives, logistics coordinators, and technical liaisons. Tracks contact roles, communication preferences, and assignment to specific commodity categories or plant locations. Supports supplier relationship management and escalation workflows.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` (
    `procurement_supplier_qualification_id` BIGINT COMMENT 'Unique system-generated identifier for each supplier qualification record within the procurement domain.',
    `certification_audit_id` BIGINT COMMENT 'Foreign key linking to compliance.certification_audit. Business justification: Supplier qualifications often require third-party certification audits (ISO9001, ISO14001, IATF16949). Procurement tracks which audit validated the suppliers qualification status for approved vendor ',
    `ppap_submission_id` BIGINT COMMENT 'Foreign key linking to quality.ppap_submission. Business justification: Supplier qualification requires approved PPAP submissions for new parts. Procurement cannot add suppliers to approved source lists until quality approves PPAP documentation per AIAG standards.',
    `procurement_spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_spend_category. Business justification: Supplier qualification references spend category via commodity_category_code (STRING). Adding FK for referential integrity, removing redundant string field.',
    `procurement_supplier_id` BIGINT COMMENT 'FK to procurement.supplier',
    `safety_audit_id` BIGINT COMMENT 'Foreign key linking to hse.safety_audit. Business justification: Supplier qualification requires HSE safety audits for high-risk suppliers. Procurement cannot approve suppliers without HSE clearance. Standard practice in manufacturing supplier onboarding.',
    `approval_date` DATE COMMENT 'Date on which the supplier was formally approved or the qualification decision was rendered.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approval_status` STRING COMMENT 'Overall approval decision for the supplier qualification, indicating whether the supplier is authorized to supply materials or services.. Valid values are `pending|approved|conditionally_approved|rejected|disqualified|suspended|expired`',
    `approved_by` STRING COMMENT 'Name or employee ID of the authorized approver who granted the final qualification approval decision.',
    `ariba_qualification_reference` STRING COMMENT 'Native qualification record identifier from SAP Ariba Supplier Qualification module, used for system traceability and cross-system reconciliation.',
    `audit_score` DECIMAL(18,2) COMMENT 'Numeric score (0-100) assigned to the supplier following the qualification audit, reflecting overall compliance and capability assessment.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `commodity_category_name` STRING COMMENT 'Human-readable name of the commodity or spend category for which the supplier qualification applies.',
    `conditional_approval_conditions` STRING COMMENT 'Description of conditions or corrective actions the supplier must fulfill to achieve full approval when a conditional approval status has been granted.',
    `conflict_minerals_compliant` BOOLEAN COMMENT 'Indicates whether the supplier has completed conflict minerals due diligence and declared compliance with Dodd-Frank Section 1502 or EU Conflict Minerals Regulation for 3TG minerals.. Valid values are `true|false`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the supplier site being qualified, used for country-of-origin risk assessment and regulatory compliance.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the supplier qualification record was first created in the system.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `disqualification_reason_code` STRING COMMENT 'Standardized reason code explaining why a supplier was disqualified or rejected during the qualification process.. Valid values are `quality_failure|audit_failure|financial_risk|regulatory_non_compliance|capacity_insufficient|ethical_violation|voluntary_withdrawal|strategic_decision|other`',
    `disqualification_reason_text` STRING COMMENT 'Free-text narrative providing detailed explanation of the disqualification decision, supplementing the reason code.',
    `expiry_date` DATE COMMENT 'Date on which the current supplier qualification expires and re-qualification is required to maintain approved supplier status.. Valid values are `^d{4}-d{2}-d{2}$`',
    `initiation_date` DATE COMMENT 'Date on which the supplier qualification process was formally initiated, marking the start of the qualification lifecycle.. Valid values are `^d{4}-d{2}-d{2}$`',
    `is_single_source` BOOLEAN COMMENT 'Indicates whether this supplier is the sole qualified source for the commodity or material category, flagging single-source supply risk.. Valid values are `true|false`',
    `iso_14001_certified` BOOLEAN COMMENT 'Indicates whether the supplier holds a valid ISO 14001 Environmental Management System certification, required for suppliers handling environmentally sensitive materials.. Valid values are `true|false`',
    `iso_14001_expiry_date` DATE COMMENT 'Expiry date of the suppliers ISO 14001 environmental management certification.. Valid values are `^d{4}-d{2}-d{2}$`',
    `iso_9001_certified` BOOLEAN COMMENT 'Indicates whether the supplier holds a valid ISO 9001 Quality Management System certification, a mandatory requirement for most direct material suppliers.. Valid values are `true|false`',
    `iso_9001_expiry_date` DATE COMMENT 'Expiry date of the suppliers ISO 9001 certification. Used to trigger re-certification alerts and assess ongoing compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the supplier qualification record, supporting audit trail and change tracking requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `notes` STRING COMMENT 'Free-text field for additional remarks, observations, or context related to the supplier qualification process not captured in structured fields.',
    `plant_code` STRING COMMENT 'Manufacturing plant or receiving location for which the supplier is being qualified to supply materials or services.',
    `ppap_submission_date` DATE COMMENT 'Date on which the supplier submitted the PPAP documentation package for review and approval.. Valid values are `^d{4}-d{2}-d{2}$`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization responsible for managing and owning this supplier qualification record.',
    `qualification_number` STRING COMMENT 'Business-facing unique reference number for the supplier qualification record, used in correspondence and audit trails.. Valid values are `^SQ-[0-9]{4}-[0-9]{6}$`',
    `qualification_owner` STRING COMMENT 'Name or employee ID of the procurement or supplier quality engineer responsible for managing and driving this qualification to completion.',
    `qualification_stage` STRING COMMENT 'Current stage in the formal supplier qualification lifecycle, tracking progression from initial registration through PPAP submission to final approval or disqualification.. Valid values are `registration|document_review|risk_assessment|audit_scheduled|audit_in_progress|ppap_submission|ppap_review|final_approval|approved|conditionally_approved|disqualified|on_hold|expired`',
    `qualification_type` STRING COMMENT 'Categorizes the nature of the qualification event: initial onboarding, periodic re-qualification, conditional approval, emergency sourcing qualification, or supplier development program.. Valid values are `initial|re_qualification|conditional|emergency|development`',
    `reach_compliant` BOOLEAN COMMENT 'Indicates whether the supplier has confirmed compliance with EU REACH (Registration, Evaluation, Authorization and Restriction of Chemicals) regulations for supplied materials.. Valid values are `true|false`',
    `requalification_due_date` DATE COMMENT 'Scheduled date by which the supplier must complete re-qualification to maintain approved status, typically set before the expiry date to allow processing time.. Valid values are `^d{4}-d{2}-d{2}$`',
    `risk_tier` STRING COMMENT 'Risk classification assigned to the supplier during qualification, reflecting supply continuity, financial, geopolitical, and quality risk exposure.. Valid values are `critical|high|medium|low`',
    `rohs_compliant` BOOLEAN COMMENT 'Indicates whether the suppliers products comply with EU RoHS (Restriction of Hazardous Substances) Directive, restricting use of specific hazardous materials in electrical and electronic equipment.. Valid values are `true|false`',
    `supplier_site_code` STRING COMMENT 'Identifier for the specific supplier manufacturing or delivery site being qualified, as a supplier may have multiple sites with different qualification statuses.',
    CONSTRAINT pk_procurement_supplier_qualification PRIMARY KEY(`procurement_supplier_qualification_id`)
) COMMENT 'Records the formal vendor qualification and approval lifecycle for each supplier including initial assessment, audit results, certification status (ISO 9001, IATF 16949, AS9100), approved commodity scope, plant-level approvals, and disqualification events. Tracks PPAP submissions, FAI approvals, and regulatory compliance (RoHS, REACH). SSOT for supplier approval status.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` (
    `procurement_sourcing_event_id` BIGINT COMMENT 'Unique system-generated identifier for the sourcing event record in the Databricks Silver Layer. Serves as the primary key for all downstream joins and references.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Strategic sourcing events (RFQs, RFPs) require a designated procurement professional to manage vendor communications, evaluation criteria, and award decisions throughout the sourcing lifecycle.',
    `procurement_spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.spend_category. Business justification: Sourcing events are organized and executed within specific spend categories (e.g., Electronic Components, MRO). The table stores category_code and category_name. Adding spend_category_id FK normalizes',
    `approval_status` STRING COMMENT 'Current approval workflow status of the sourcing event. Events above the competitive bid threshold require formal approval before publication. Tracks the authorization state within the procurement governance framework.. Valid values are `Pending|Approved|Rejected|Escalated`',
    `approved_by` STRING COMMENT 'Name or employee ID of the procurement authority who approved the sourcing event for publication. Required for audit trail and delegation-of-authority compliance.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time at which the sourcing event received formal approval to proceed. Supports audit trail requirements and sourcing cycle time analytics.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `ariba_event_reference` STRING COMMENT 'Native event identifier assigned by SAP Ariba Sourcing. Used for cross-system reconciliation between the Databricks Silver Layer and the SAP Ariba source system.',
    `award_basis` STRING COMMENT 'The primary basis on which the sourcing award decision was made. Lowest Price is common for commodity RFQs; Best Value and Weighted Score are used for complex RFPs where quality and service factors are weighted alongside price.. Valid values are `Lowest Price|Best Value|Technical Merit|Weighted Score|Negotiated`',
    `award_decision_date` DATE COMMENT 'Date on which the formal award decision was made and communicated to participating suppliers. Marks the conclusion of the competitive evaluation phase.. Valid values are `^d{4}-d{2}-d{2}$`',
    `awarded_supplier_count` STRING COMMENT 'Number of suppliers who received an award from this sourcing event. A value greater than one indicates a split-award scenario across multiple suppliers.. Valid values are `^[0-9]+$`',
    `awarded_value` DECIMAL(18,2) COMMENT 'Total contract or purchase value awarded to the winning supplier(s) upon completion of the sourcing event. Represents the committed spend resulting from the award decision.',
    `baseline_price_amount` DECIMAL(18,2) COMMENT 'Reference price or incumbent spend amount used as the benchmark for evaluating savings achieved through the sourcing event. Typically derived from the last purchase price or market reference.',
    `bid_close_date` DATE COMMENT 'Deadline date by which all supplier bids or proposals must be submitted. Bids received after this date are typically rejected unless an extension is granted.. Valid values are `^d{4}-d{2}-d{2}$`',
    `bid_close_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone) at which the bidding window closes. Required for reverse auctions and time-sensitive RFQs where exact submission deadlines must be enforced.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `bid_open_date` DATE COMMENT 'Date on which the bidding window opens and suppliers are permitted to submit responses. For reverse auctions, this marks the start of the live auction period.. Valid values are `^d{4}-d{2}-d{2}$`',
    `category_code` STRING COMMENT 'Code identifying the spend category or commodity group targeted by this sourcing event. Aligns with the enterprise spend taxonomy managed in SAP Ariba and the procurement.spend_category reference table.',
    `category_manager_name` STRING COMMENT 'Name of the category manager or procurement lead responsible for designing and executing this sourcing event. Serves as the primary business owner and point of contact for supplier queries.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity on behalf of which the sourcing event is conducted. Required for financial posting, budget commitment, and IFRS/GAAP reporting.',
    `conflict_minerals_applicable` BOOLEAN COMMENT 'Indicates whether the materials covered by this sourcing event are subject to conflict minerals reporting requirements (3TG: tin, tantalum, tungsten, gold). Triggers mandatory supplier disclosure obligations.. Valid values are `true|false`',
    `contract_end_date` DATE COMMENT 'Planned end date of the supply agreement or contract expected to result from this sourcing event. Drives contract renewal planning and re-sourcing cycle initiation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `contract_start_date` DATE COMMENT 'Planned start date of the supply agreement or contract expected to result from this sourcing event. Used for supply continuity planning and contract lifecycle management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the primary delivery or receiving location for this sourcing event. Supports multi-country compliance, trade regulation checks, and regional spend analytics.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time at which the sourcing event record was first created in SAP Ariba. Supports sourcing cycle time measurement and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which bid prices and event values are denominated. Supports multi-currency sourcing events across global operations.. Valid values are `^[A-Z]{3}$`',
    `estimated_spend_amount` DECIMAL(18,2) COMMENT 'Internal estimate of the total spend value expected to result from this sourcing event, expressed in the event currency. Used for budget validation, approval thresholds, and category spend planning.',
    `evaluation_criteria` STRING COMMENT 'Description of the weighted criteria used to evaluate supplier bids, such as price, quality, delivery lead time, technical compliance, sustainability, and financial stability. Supports transparent and auditable award decisions.',
    `event_number` STRING COMMENT 'Business-facing unique identifier for the sourcing event as assigned by SAP Ariba Sourcing. Used for cross-system reference, supplier communication, and audit trail.. Valid values are `^SE-[0-9]{4}-[0-9]{6}$`',
    `event_type` STRING COMMENT 'Classification of the sourcing event format. RFQ (Request for Quotation) is used for price-competitive direct material bids; RFP (Request for Proposal) for complex or service-based sourcing; RFI (Request for Information) for market intelligence; Reverse Auction for real-time competitive bidding.. Valid values are `RFQ|RFP|RFI|Reverse Auction|eAuction|Multi-Round Negotiation`',
    `invited_supplier_count` STRING COMMENT 'Total number of suppliers invited to participate in the sourcing event. Supports competitive bidding compliance checks and category management analytics.. Valid values are `^[0-9]+$`',
    `is_multi_round` BOOLEAN COMMENT 'Indicates whether the sourcing event involves multiple bidding rounds (e.g., initial RFP followed by a best-and-final-offer round). Multi-round events are common for complex or high-value sourcing.. Valid values are `true|false`',
    `is_reverse_auction` BOOLEAN COMMENT 'Indicates whether this sourcing event is conducted as a reverse auction (eAuction) where suppliers compete in real time by lowering their prices. Reverse auctions are used for commodity and price-sensitive categories.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the sourcing event record. Used for incremental data ingestion, change detection, and audit trail in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `notes` STRING COMMENT 'Free-text field for additional context, special instructions, or internal commentary related to the sourcing event. May include rationale for single-source decisions, market conditions, or escalation notes.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or delivery site that will receive the materials or services sourced through this event. Used for MRP alignment and delivery planning.',
    `procurement_type` STRING COMMENT 'Indicates whether the sourcing event covers direct materials (production-critical), indirect materials, capital expenditure (CAPEX), MRO (Maintenance, Repair and Operations), or services. Drives approval workflows and compliance requirements.. Valid values are `Direct|Indirect|Capital|MRO|Services`',
    `publish_date` DATE COMMENT 'Date on which the sourcing event was published and made visible to invited suppliers in SAP Ariba. Marks the official start of the supplier engagement phase.. Valid values are `^d{4}-d{2}-d{2}$`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for executing this sourcing event. Determines the organizational unit with authority to commit spend and issue purchase orders resulting from the event.',
    `reach_compliance_required` BOOLEAN COMMENT 'Indicates whether suppliers must provide REACH (Registration, Evaluation, Authorisation and Restriction of Chemicals) compliance documentation as part of their bid submission.. Valid values are `true|false`',
    `realized_savings_amount` DECIMAL(18,2) COMMENT 'Actual savings achieved through the sourcing event, calculated as the difference between the baseline spend and the awarded value. Reported to finance for COGS and EBITDA impact tracking.',
    `responding_supplier_count` STRING COMMENT 'Number of invited suppliers who submitted a bid or response to the sourcing event. Used to assess market competitiveness and supplier engagement rates.. Valid values are `^[0-9]+$`',
    `rohs_compliance_required` BOOLEAN COMMENT 'Indicates whether suppliers responding to this sourcing event must demonstrate compliance with RoHS (Restriction of Hazardous Substances) Directive. Mandatory for electrical and electronic equipment categories.. Valid values are `true|false`',
    `round_number` STRING COMMENT 'Sequential round number for multi-round sourcing events. Round 1 is the initial bid; subsequent rounds represent negotiation or best-and-final-offer stages.. Valid values are `^[1-9][0-9]*$`',
    `sap_rfq_number` STRING COMMENT 'SAP S/4HANA MM RFQ document number linked to this sourcing event, if the event resulted in or was initiated from an SAP RFQ. Enables traceability between Ariba sourcing events and SAP procurement documents.',
    `source_system` STRING COMMENT 'Name of the operational system of record from which this sourcing event record was ingested into the Databricks Silver Layer. Supports data lineage tracking and multi-system reconciliation.. Valid values are `SAP Ariba|SAP S/4HANA|Manual`',
    `sourcing_strategy` STRING COMMENT 'Strategic approach applied to this sourcing event. Competitive bidding requires multiple supplier responses; single source or sole source require documented justification for compliance and audit purposes.. Valid values are `Competitive Bidding|Single Source Justification|Sole Source|Preferred Supplier|Negotiated|Consortium`',
    `status` STRING COMMENT 'Current lifecycle status of the sourcing event. Tracks progression from initial draft through publication, bidding window, evaluation, award decision, and closure or cancellation.. Valid values are `Draft|Published|Open|Closed|Awarded|Cancelled|On Hold|Pending Approval`',
    `target_savings_amount` DECIMAL(18,2) COMMENT 'Procurement savings target set for this sourcing event relative to the baseline or incumbent price. Used to measure sourcing effectiveness and report cost reduction KPIs to finance.',
    `title` STRING COMMENT 'Descriptive title of the sourcing event as entered by the category manager or procurement team. Provides a human-readable summary of the event scope and purpose.',
    CONSTRAINT pk_procurement_sourcing_event PRIMARY KEY(`procurement_sourcing_event_id`)
) COMMENT 'Manages strategic sourcing events including RFQ (Request for Quotation), RFP (Request for Proposal), reverse auctions, and spot-buy events executed through SAP Ariba Sourcing. Captures event scope, commodity category, participating suppliers, award decisions, savings targets, and actual savings realized. Supports category management and spend optimization.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` (
    `procurement_sourcing_bid_id` BIGINT COMMENT 'Unique system-generated identifier for each supplier bid response submitted during a sourcing event. Serves as the primary key for the sourcing_bid data product.',
    `incoterm_id` BIGINT COMMENT 'Foreign key linking to procurement.incoterm. Business justification: Sourcing bids specify incoterms as part of the commercial terms offered by the supplier. Linking to the incoterm reference table ensures standardized trade term validation and enables reporting on inc',
    `procurement_payment_term_id` BIGINT COMMENT 'Foreign key linking to procurement.payment_term. Business justification: Sourcing bids specify payment terms as part of the commercial offer. Linking to the payment_term reference table ensures standardized payment term validation and enables comparison of payment terms ac',
    `procurement_sourcing_event_id` BIGINT COMMENT 'Foreign key linking to procurement.sourcing_event. Business justification: A sourcing bid is a suppliers response to a specific sourcing event (RFQ/RFP/auction). This is a fundamental parent-child relationship in the sourcing lifecycle. sourcing_event_number is retained as ',
    `procurement_spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_spend_category. Business justification: Sourcing bid references spend category via category_code (STRING). Adding FK for referential integrity, removing redundant string field.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Sourcing bids are submitted by specific supplier organizations. The table stores supplier_code and supplier_name as denormalized strings. Adding supplier_id FK normalizes this relationship and elimina',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Suppliers submit bids for specific SKUs during sourcing events. Procurement evaluates supplier pricing and terms at the SKU level.',
    `ariba_bid_reference` STRING COMMENT 'Native identifier assigned to the bid response within SAP Ariba Sourcing. Enables traceability back to the source system record for audit and reconciliation purposes.',
    `award_timestamp` TIMESTAMP COMMENT 'Date and time when the award decision was finalized and communicated for this bid line. Marks the transition from sourcing to contracting or purchase order creation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `awarded_quantity` DECIMAL(18,2) COMMENT 'Quantity awarded to this supplier for this bid line. May be less than the full bid quantity in split-award scenarios where volume is distributed across multiple suppliers.',
    `bid_number` STRING COMMENT 'Human-readable business identifier for the bid response, typically generated by SAP Ariba upon bid submission. Used for cross-system reference and supplier communication.. Valid values are `^BID-[0-9]{4}-[0-9]{6}$`',
    `bid_quantity` DECIMAL(18,2) COMMENT 'Quantity of material or service units the supplier is offering to supply under this bid line. May differ from the requested quantity if the supplier is offering a partial or alternative quantity.',
    `bid_type` STRING COMMENT 'Classification of the bid response based on the sourcing event type. Determines the evaluation rules and comparison methodology applied during bid analysis.. Valid values are `rfq_response|rfp_response|reverse_auction|sealed_bid|open_bid`',
    `commercial_compliance_status` STRING COMMENT 'Assessment of whether the suppliers bid meets the commercial terms and conditions required by the sourcing event, including pricing format, payment terms, and delivery conditions.. Valid values are `compliant|non_compliant|conditionally_compliant|pending_review`',
    `commercial_score` DECIMAL(18,2) COMMENT 'Score assigned to the bid based on commercial evaluation criteria including unit price, total cost of ownership, payment terms, and pricing competitiveness relative to other bids.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating where the quoted material will be manufactured or sourced from. Used for supply risk assessment, customs duty calculation, and trade compliance.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the bid record was first created in the system, either when the supplier initiated a draft or when the bid was received. Supports data lineage and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the supplier submitted the bid price. Supports multi-currency bid normalization for global sourcing events.. Valid values are `^[A-Z]{3}$`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms code specifying the delivery and risk transfer conditions offered by the supplier in this bid. Affects total landed cost calculation and logistics planning.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `incoterms_location` STRING COMMENT 'Named place or port associated with the Incoterms code, specifying the exact point of delivery or risk transfer. Required for accurate landed cost and logistics cost modeling.',
    `is_awarded` BOOLEAN COMMENT 'Indicates whether this bid line has been selected for award. A True value means the supplier has been chosen as the supply source for this line item in the sourcing event.. Valid values are `true|false`',
    `is_on_time_submission` BOOLEAN COMMENT 'Indicates whether the bid was submitted before the sourcing event submission deadline. Used to enforce bid eligibility rules and track supplier responsiveness.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the bid record, including revisions to pricing, quantities, or evaluation scores. Used for change tracking and incremental data pipeline processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `lead_time_days` STRING COMMENT 'Number of calendar days from purchase order placement to delivery at the specified plant, as quoted by the supplier. Used in supply chain planning and MRP lead time validation.',
    `line_number` STRING COMMENT 'Sequential line item number within the bid response, corresponding to a specific material, service, or lot within the sourcing event. Enables multi-line bid decomposition.. Valid values are `^[0-9]+$`',
    `material_description` STRING COMMENT 'Short description of the material or service being quoted in this bid line. Retained for readability in bid comparison reports without requiring a material master join.',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity the supplier requires per purchase order for this bid line. Critical constraint for award optimization and supply planning feasibility assessment.',
    `notes` STRING COMMENT 'Free-text field for additional supplier comments, clarifications, or conditions attached to the bid response. May include alternative proposals, exceptions to specifications, or supplementary commercial terms.',
    `payment_terms_code` STRING COMMENT 'Supplier-proposed payment terms code for this bid (e.g., NET30, 2/10NET30). Impacts working capital analysis and total cost of ownership evaluation during bid scoring.',
    `price_unit` STRING COMMENT 'Quantity basis for the quoted unit price (e.g., price per 1, per 100, per 1000 units). Required to normalize prices across suppliers quoting at different price unit scales.',
    `quoted_unit_price` DECIMAL(18,2) COMMENT 'Unit price offered by the supplier for the material or service in this bid line. Core commercial attribute used for multi-supplier price comparison and award optimization.',
    `rank` STRING COMMENT 'Ordinal ranking of this bid relative to all other bids received for the same sourcing event line item, based on the total weighted score. Rank 1 indicates the highest-scoring bid.. Valid values are `^[1-9][0-9]*$`',
    `reach_compliant` BOOLEAN COMMENT 'Indicates whether the supplier has confirmed compliance with the EU REACH regulation (Registration, Evaluation, Authorisation and Restriction of Chemicals) for the quoted material.. Valid values are `true|false`',
    `rejection_reason` STRING COMMENT 'Standardized reason code explaining why a bid was not selected for award. Supports supplier feedback processes, sourcing analytics, and continuous improvement of the supplier base.. Valid values are `price_not_competitive|technical_non_compliance|capacity_insufficient|lead_time_unacceptable|financial_risk|qualification_failure|late_submission|incomplete_bid|other`',
    `rohs_compliant` BOOLEAN COMMENT 'Indicates whether the supplier has confirmed that the quoted material complies with the EU Restriction of Hazardous Substances (RoHS) directive. Mandatory for electrical and electronic components.. Valid values are `true|false`',
    `sourcing_event_number` STRING COMMENT 'Reference to the parent sourcing event (RFQ/RFP/auction) for which this bid was submitted. Links the bid to the competitive sourcing process it belongs to.',
    `status` STRING COMMENT 'Current lifecycle status of the bid response. Tracks progression from initial draft through submission, evaluation, and final award or rejection decision.. Valid values are `draft|submitted|under_review|shortlisted|awarded|rejected|withdrawn|disqualified`',
    `submission_timestamp` TIMESTAMP COMMENT 'Exact date and time when the supplier submitted the bid response in SAP Ariba. Used to verify on-time submission against the sourcing event deadline and for audit trail purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `technical_compliance_status` STRING COMMENT 'Assessment of whether the suppliers bid meets the technical specifications and requirements defined in the sourcing event. Determined during the technical evaluation phase before commercial scoring.. Valid values are `compliant|non_compliant|conditionally_compliant|pending_review`',
    `technical_score` DECIMAL(18,2) COMMENT 'Score assigned to the bid based on technical evaluation criteria such as product specifications, quality certifications, manufacturing capability, and compliance with engineering requirements.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `total_bid_value` DECIMAL(18,2) COMMENT 'Total commercial value of this bid line, calculated as quoted unit price multiplied by bid quantity. Used for spend impact analysis and award scenario modeling.',
    `total_score` DECIMAL(18,2) COMMENT 'Weighted composite score assigned to the bid after evaluation across all scoring criteria (technical, commercial, sustainability, etc.). Used for multi-supplier bid ranking and award optimization.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the bid quantity and pricing (e.g., EA, KG, M, L). Ensures consistent quantity and price comparison across supplier bids.',
    `validity_end_date` DATE COMMENT 'Date after which the suppliers quoted prices and terms expire. Procurement teams must complete award decisions before this date to honor the suppliers commercial offer.. Valid values are `^d{4}-d{2}-d{2}$`',
    `validity_start_date` DATE COMMENT 'Date from which the suppliers quoted prices and terms are valid. Defines the start of the commercial commitment window for award and contract execution.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_procurement_sourcing_bid PRIMARY KEY(`procurement_sourcing_bid_id`)
) COMMENT 'Individual supplier bid or quote response submitted during a sourcing event. Captures line-item pricing, lead time commitments, MOQ (Minimum Order Quantity), tooling costs, payment terms offered, and technical compliance declarations. Enables bid comparison, total cost of ownership analysis, and award recommendation documentation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` (
    `procurement_po_line_item_id` BIGINT COMMENT 'Unique surrogate identifier for each purchase order line item record in the lakehouse silver layer. Serves as the primary key for granular PO line tracking, three-way match, and spend analytics at the material level.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: PO line items must reference the engineered component being purchased. Procurement uses this daily to order exact parts defined by engineering with correct specifications and revisions.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Each PO line item posts to a specific GL account (raw materials, MRO, services) for financial reporting. Required for automated three-way match and accrual accounting.',
    `incoterm_id` BIGINT COMMENT 'Foreign key linking to procurement.incoterm. Business justification: PO line item references incoterm via incoterms_code (STRING). Adding FK for referential integrity, removing redundant string field.',
    `inventory_sku_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: PO line items specify which SKUs are being purchased. Links procurement orders to inventory master for material specifications and receiving.',
    `procurement_material_info_record_id` BIGINT COMMENT 'Foreign key linking to procurement.material_info_record. Business justification: PO line items reference the purchasing info record (PIR) that defines the commercial relationship between the material and supplier, including price, lead time, and tolerances. The table has info_reco',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: PO line items are the fundamental child records of a purchase order header. This is the core parent-child relationship in the PO data model. po_number is retained as a business key for SAP integration',
    `procurement_purchase_requisition_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_requisition. Business justification: PO line items are created from purchase requisition lines, establishing the demand-to-fulfillment traceability chain. The table has requisition_number and requisition_line_number. Adding purchase_requ',
    `procurement_spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.spend_category. Business justification: PO line items are classified by material group which maps to spend categories in the procurement taxonomy. Adding spend_category_id FK enables spend analytics by category directly from PO line items. ',
    `procurement_supply_agreement_id` BIGINT COMMENT 'Foreign key linking to procurement.supply_agreement. Business justification: PO line items can be released against supply agreements (blanket orders, scheduling agreements). The table has outline_agreement_number. Adding supply_agreement_id FK enables tracking of released quan',
    `spare_part_id` BIGINT COMMENT 'Foreign key linking to asset.spare_part. Business justification: Purchase order line items for spare parts reference the master spare part catalog. Ensures procurement orders match exact technical specifications required by equipment.',
    `account_assignment_category` STRING COMMENT 'Determines how the procurement cost is assigned in financial accounting. Drives whether the line item is charged to a cost center, WBS element, internal order, or asset, enabling accurate cost allocation and CAPEX/OPEX classification.. Valid values are `cost_center|wbs_element|asset|order|project|sales_order|unknown`',
    `cost_center` STRING COMMENT 'The controlling cost center to which the procurement cost is assigned when the account assignment category is cost center. Enables OPEX tracking and departmental spend reporting.. Valid values are `^[A-Z0-9]{1,10}$`',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the procured material was manufactured or produced. Required for customs declarations, import duty calculation, and RoHS/REACH compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this PO line item was created in the source system. Used for audit trail, procurement cycle time analysis, and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the PO line item pricing and value fields. Supports multi-currency procurement in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `customs_tariff_number` STRING COMMENT 'Harmonized System (HS) tariff classification number for the procured material. Required for import/export customs declarations, duty rate determination, and trade compliance reporting.. Valid values are `^[0-9]{6,10}$`',
    `deletion_indicator` BOOLEAN COMMENT 'Flag indicating that this PO line item has been marked for deletion and should be excluded from active procurement processing. Supports soft-delete patterns for audit trail preservation.. Valid values are `true|false`',
    `final_delivery_indicator` BOOLEAN COMMENT 'Flag set to indicate that the final delivery has been made for this PO line item, closing it for further goods receipts even if the full ordered quantity has not been received.. Valid values are `true|false`',
    `goods_receipt_indicator` BOOLEAN COMMENT 'Flag indicating whether a goods receipt is required for this PO line item before invoice payment can be processed. Controls the three-way match requirement in accounts payable.. Valid values are `true|false`',
    `goods_receipt_quantity` DECIMAL(18,2) COMMENT 'The cumulative quantity of goods received against this PO line item across all goods receipt postings. Used for open order quantity calculation, delivery completeness assessment, and three-way match.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `goods_receipt_status` STRING COMMENT 'Indicates the goods receipt fulfillment status for this PO line item based on comparison of ordered versus received quantities. Drives open order reporting and supplier delivery performance tracking.. Valid values are `not_started|partial|complete|over_delivered`',
    `info_record_number` STRING COMMENT 'Reference to the SAP purchasing info record that defines the supplier-material relationship and provides default pricing and delivery conditions for this PO line item.. Valid values are `^[0-9]{10}$`',
    `invoice_status` STRING COMMENT 'Indicates the invoicing status for this PO line item reflecting whether supplier invoices have been received and processed. Used for accounts payable accruals and three-way match monitoring.. Valid values are `not_invoiced|partially_invoiced|fully_invoiced|blocked`',
    `invoice_verification_indicator` BOOLEAN COMMENT 'Flag indicating whether invoice-based verification is required for this PO line item. When combined with the GR indicator, determines whether two-way or three-way match applies.. Valid values are `true|false`',
    `invoiced_quantity` DECIMAL(18,2) COMMENT 'The cumulative quantity invoiced by the supplier against this PO line item. Used in three-way match (PO-GR-Invoice) to detect billing discrepancies and manage invoice verification.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `item_category` STRING COMMENT 'SAP item category controlling the procurement process for the line item. Determines whether the item follows standard goods receipt, service entry, subcontracting, or consignment processing.. Valid values are `standard|consignment|subcontracting|stock_transfer|service|third_party|blanket`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this PO line item was last updated in the source system. Supports change detection for incremental data loads and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `line_number` STRING COMMENT 'Sequential line item number within the purchase order, typically in increments of 10 (e.g., 10, 20, 30) following SAP MM convention. Uniquely identifies a line within the PO document.. Valid values are `^[0-9]{1,5}$`',
    `material_group` STRING COMMENT 'SAP material group code classifying the procured item into a commodity category for spend analytics, sourcing strategy alignment, and category management reporting.. Valid values are `^[A-Z0-9]{1,9}$`',
    `net_order_value` DECIMAL(18,2) COMMENT 'The total net value of the PO line item calculated as ordered quantity multiplied by net price divided by price unit. Used for spend commitment reporting, budget consumption, and financial accruals.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `net_price` DECIMAL(18,2) COMMENT 'The agreed net unit price for the material or service on this PO line item, excluding taxes. Used for invoice verification, three-way match, and spend analytics. Expressed in the PO currency.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `ordered_quantity` DECIMAL(18,2) COMMENT 'The quantity of material or service ordered on this PO line item in the order unit of measure. Used for goods receipt matching, delivery tracking, and open order quantity calculations.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `outline_agreement_number` STRING COMMENT 'Reference to the supply agreement (scheduling agreement or contract) against which this PO line item is released. Enables spend tracking against committed contract values and volume compliance.. Valid values are `^[A-Z0-9]{10}$`',
    `overdelivery_tolerance_pct` DECIMAL(18,2) COMMENT 'The maximum percentage by which the supplier may exceed the ordered quantity during goods receipt without triggering a delivery variance exception. Supports flexible receiving for bulk materials.. Valid values are `^[0-9]{1,3}(.[0-9]{1,2})?$`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the receiving plant or manufacturing facility for this PO line item. Determines the inventory posting location and links to production planning and MRP.. Valid values are `^[A-Z0-9]{4}$`',
    `po_number` STRING COMMENT 'The business document number of the parent purchase order to which this line item belongs. Used to group all line items under a single procurement transaction and for supplier communication.. Valid values are `^[A-Z0-9]{10}$`',
    `price_unit` DECIMAL(18,2) COMMENT 'The quantity basis for the net unit price (e.g., price per 1, per 100, per 1000 units). Required to correctly calculate the line item value when pricing is expressed per multiple units.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `requisition_line_number` STRING COMMENT 'The specific line item number on the originating purchase requisition that corresponds to this PO line item. Together with requisition_number, provides full traceability to the demand source.. Valid values are `^[0-9]{1,5}$`',
    `requisition_number` STRING COMMENT 'Reference to the originating purchase requisition document number that triggered the creation of this PO line item. Enables traceability from demand signal through procurement execution.. Valid values are `^[A-Z0-9]{10}$`',
    `scheduled_delivery_date` DATE COMMENT 'The agreed delivery date by which the supplier must deliver the goods or services for this PO line item. Used for delivery performance tracking, on-time delivery KPI calculation, and production scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `short_text` STRING COMMENT 'Free-text description entered on the PO line item, particularly relevant for service or non-stock items where no material master exists. Supplements or replaces the material description for procurement communication.',
    `status` STRING COMMENT 'Current processing status of the purchase order line item reflecting its position in the procurement lifecycle from creation through goods receipt, invoicing, and closure.. Valid values are `open|partially_delivered|fully_delivered|invoiced|closed|blocked|cancelled`',
    `storage_location` STRING COMMENT 'SAP storage location within the plant where the received goods will be placed into stock. Enables granular inventory tracking and warehouse management integration.. Valid values are `^[A-Z0-9]{4}$`',
    `tax_code` STRING COMMENT 'SAP tax code determining the applicable tax rate and tax jurisdiction for this PO line item. Drives VAT/GST calculation during invoice verification and financial posting.. Valid values are `^[A-Z0-9]{2}$`',
    `underdelivery_tolerance_pct` DECIMAL(18,2) COMMENT 'The maximum percentage by which the supplier may fall short of the ordered quantity and still have the delivery accepted as complete. Prevents unnecessary open order carryover for minor shortfalls.. Valid values are `^[0-9]{1,3}(.[0-9]{1,2})?$`',
    `wbs_element` STRING COMMENT 'The project WBS element to which the procurement cost is assigned when the account assignment category is project. Enables CAPEX project cost tracking and project budget consumption monitoring.. Valid values are `^[A-Z0-9-.]{1,24}$`',
    CONSTRAINT pk_procurement_po_line_item PRIMARY KEY(`procurement_po_line_item_id`)
) COMMENT 'Individual line items within a purchase order capturing material number, ordered quantity, unit of measure, agreed unit price, delivery date, storage location, cost center, WBS element, and line-level status. Supports partial deliveries, over/under-delivery tolerances, and invoice verification at line level. Aligned with SAP MM PO Item (EKPO).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` (
    `procurement_purchase_requisition_id` BIGINT COMMENT 'Unique surrogate identifier for the purchase requisition record in the lakehouse silver layer. Serves as the primary key for this entity.',
    `budget_id` BIGINT COMMENT 'Foreign key linking to finance.budget. Business justification: Purchase requisitions check against approved budgets before approval. Procurement and finance jointly enforce budget compliance to prevent overspending on capital and operational purchases.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Purchase requisitions originate from BOM requirements. MRP systems generate requisitions for specific engineered components needed for production, linking material planning directly to engineering def',
    `maintenance_plan_id` BIGINT COMMENT 'Foreign key linking to asset.maintenance_plan. Business justification: Preventive maintenance plans generate recurring purchase requisitions for consumables and services. MRP systems auto-create PRs based on maintenance schedules to ensure material availability.',
    `order_id` BIGINT COMMENT 'Foreign key linking to production.production_order. Business justification: Purchase requisitions for production materials must reference the specific production order driving the demand. MRP and procurement teams use this to prioritize purchasing based on production urgency.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Purchase requisitions are converted into purchase orders as part of the procure-to-pay lifecycle. The table has a converted_to_po_flag and po_number field indicating this conversion. Adding purchase_o',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supplier. Business justification: Purchase requisition references preferred supplier via preferred_supplier_code (STRING). Adding FK for referential integrity, removing redundant supplier code and name fields.',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Purchase requisitions request specific SKUs for procurement. Requestors specify exact product variants needed, which procurement then sources from suppliers.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the person who created the purchase requisition. Used for approval workflow routing, delegation of authority enforcement, and spend analytics by requestor.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Purchase requisitions for project-specific or make-to-order materials directly reference the sales order driving the demand. Procurement uses this for cost allocation and order-specific sourcing.',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Maintenance work orders trigger purchase requisitions for parts and services. Planners create PRs directly from work orders to procure materials needed for equipment repairs.',
    `account_assignment_category` STRING COMMENT 'SAP account assignment category defining how the procurement cost is allocated in financial accounting. Determines whether cost flows to a cost center, WBS element, sales order, or fixed asset.. Valid values are `cost_center|project|sales_order|asset|network|unknown`',
    `approval_status` STRING COMMENT 'Current status of the requisition within the release strategy (approval workflow). Tracks whether the requisition is awaiting approval, has been approved, rejected, or escalated based on value thresholds and organizational rules.. Valid values are `pending|approved|rejected|escalated|withdrawn`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity responsible for the procurement transaction. Used for financial accounting, cost allocation, and intercompany procurement scenarios.. Valid values are `^[A-Z0-9]{4}$`',
    `converted_to_po_flag` BOOLEAN COMMENT 'Indicates whether this requisition line has been converted into a purchase order. Used to track requisition-to-order conversion rates and identify open, unprocessed requisitions.. Valid values are `true|false`',
    `cost_center` STRING COMMENT 'SAP cost center to which the procurement cost will be charged. Used for internal cost allocation, budget control, and management accounting reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the purchase requisition record was created in the source system (SAP S/4HANA). Used for audit trail, cycle time analysis, and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the requisition valuation. Supports multi-currency operations across global manufacturing plants and purchasing organizations.. Valid values are `^[A-Z]{3}$`',
    `estimated_value` DECIMAL(18,2) COMMENT 'Total estimated monetary value of the requisition line (requested_quantity × valuation_price). Used for budget commitment, approval threshold routing, and spend analytics.',
    `fixed_source_indicator` BOOLEAN COMMENT 'Indicates whether the preferred supplier is a fixed, mandatory source that cannot be changed during purchase order creation. Typically set for single-source or contractually obligated suppliers.. Valid values are `true|false`',
    `gl_account` STRING COMMENT 'General ledger account code for the financial posting of the procurement cost. Determines whether the spend is classified as COGS, OPEX, or CAPEX in financial reporting.',
    `item_category` STRING COMMENT 'SAP item category classifying the nature of the requisition line. Determines the procurement process, goods receipt requirements, and invoice verification rules applicable to the line.. Valid values are `standard|consignment|subcontracting|stock_transfer|service|limit`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the purchase requisition record in the source system. Used for change detection, incremental data loading, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `line_number` STRING COMMENT 'Sequential line item number within the purchase requisition document. Each line represents a distinct material or service being requested.. Valid values are `^[0-9]{1,5}$`',
    `material_group` STRING COMMENT 'SAP material group code classifying the requested material or service into a commodity category for spend analytics, sourcing strategy alignment, and category management.',
    `mrp_controller` STRING COMMENT 'MRP controller code responsible for the material planning that generated this requisition. Used for exception management, workload distribution, and MRP performance analytics.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or operational site where the requested material or service is needed. Determines the applicable purchasing organization and storage location.. Valid values are `^[A-Z0-9]{4}$`',
    `po_number` STRING COMMENT 'Purchase order number to which this requisition line was converted. Enables traceability from demand origination through procurement execution and goods receipt.',
    `procurement_type` STRING COMMENT 'Indicates whether the requisition is for external procurement from a supplier, internal stock transfer between plants, subcontracting, or consignment. Drives the sourcing and order creation logic.. Valid values are `external|internal|subcontracting|consignment`',
    `purchasing_group` STRING COMMENT 'SAP purchasing group code identifying the buyer or team of buyers responsible for processing this requisition and converting it to a purchase order.',
    `purchasing_org` STRING COMMENT 'SAP purchasing organization code responsible for procuring the requested material or service. Defines the legal and commercial framework for the resulting purchase order.',
    `release_date` DATE COMMENT 'Date on which the purchase requisition was fully approved and released for conversion to a purchase order. Marks the completion of the internal approval workflow.. Valid values are `^d{4}-d{2}-d{2}$`',
    `release_strategy_code` STRING COMMENT 'SAP release strategy code determining the approval workflow path for this requisition based on value thresholds, material group, plant, and account assignment. Enforces delegation of authority policies.',
    `requested_quantity` DECIMAL(18,2) COMMENT 'Quantity of the material or service requested by the business unit or planning system. Expressed in the base unit of measure defined in the material master.',
    `requestor_name` STRING COMMENT 'Full name of the employee or system user who created the purchase requisition. Used for accountability, approval routing, and audit trail purposes.',
    `required_delivery_date` DATE COMMENT 'Date by which the requested material or service must be delivered to the requesting plant or location. Drives purchase order scheduling, supplier lead time evaluation, and production planning alignment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `requisition_date` DATE COMMENT 'Date on which the purchase requisition was created in SAP S/4HANA. Used for aging analysis, cycle time measurement, and procurement performance reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `requisition_number` STRING COMMENT 'Business-facing document number assigned by SAP S/4HANA MM module (ME51N) to uniquely identify the purchase requisition. Used for cross-system referencing and communication with requestors and approvers.. Valid values are `^[A-Z0-9]{10}$`',
    `requisition_type` STRING COMMENT 'Classification of the requisition by procurement type. Distinguishes between standard material procurement, MRO (Maintenance, Repair and Operations) requests, capital expenditure (CAPEX) items, service requests, and subcontracting requirements.. Valid values are `standard|subcontracting|consignment|stock_transfer|service|blanket|mro|capital`',
    `short_text` STRING COMMENT 'Free-text description of the requested item or service, particularly used for non-stock, service, or text-based requisition lines where no material master exists.',
    `source_of_demand` STRING COMMENT 'Identifies the originating business process or system that triggered the purchase requisition. MRP/MRP II-generated requisitions originate from SAP S/4HANA planning runs; manual requisitions are created directly by business users.. Valid values are `mrp|mrp_ii|manual|maintenance|project|sales_order|kanban|forecast`',
    `status` STRING COMMENT 'Current processing status of the purchase requisition line, tracking its lifecycle from initial creation through approval, ordering, and closure.. Valid values are `draft|submitted|in_review|approved|rejected|partially_ordered|fully_ordered|closed|cancelled`',
    `storage_location` STRING COMMENT 'SAP storage location code within the plant where the received material will be stored. Used for inventory management and goods receipt routing.',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the requested quantity, aligned with the SAP material master base unit. Examples include EA (each), KG (kilogram), M (meter), HR (hour) for services.. Valid values are `EA|KG|LB|M|M2|M3|L|PC|SET|HR|DAY|BOX|PAL|ROL|TON`',
    `valuation_price` DECIMAL(18,2) COMMENT 'Estimated or standard unit price used to value the requisition line for budget checking and spend commitment purposes. May be sourced from the purchasing info record, last purchase order, or manually entered.',
    `wbs_element` STRING COMMENT 'SAP Work Breakdown Structure element for project-based procurement. Used when the requisition is associated with a capital project or engineering change order (ECO), enabling project cost tracking.',
    CONSTRAINT pk_procurement_purchase_requisition PRIMARY KEY(`procurement_purchase_requisition_id`)
) COMMENT 'Internal procurement request generated manually or automatically via MRP/MRP II to trigger purchasing activity. Captures requesting plant, material, required quantity, required delivery date, cost assignment (cost center, WBS, order), and approval chain. Tracks conversion to RFQ or PO. Aligned with SAP MM Purchase Requisition (ME51N/EBAN).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` (
    `procurement_goods_receipt_id` BIGINT COMMENT 'Unique surrogate identifier for each goods receipt header record in the lakehouse silver layer. Serves as the primary key for the goods_receipt data product.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Goods receipts post inventory value to receiving cost centers for consumption tracking. Manufacturing plants allocate material costs to production cost centers upon receipt.',
    `procurement_inbound_delivery_id` BIGINT COMMENT 'Foreign key linking to procurement.inbound_delivery. Business justification: Goods receipts are triggered by inbound deliveries from suppliers. The table has inbound_delivery_number. Adding inbound_delivery_id FK formalizes the relationship between the physical shipment tracki',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Goods receipts are posted against specific purchase orders as part of the three-way match process. This is a core relationship in the procure-to-pay lifecycle. purchase_order_number is retained as a b',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Goods receipts are associated with the specific supplier who delivered the materials. The table stores supplier_number and supplier_name. Adding supplier_id FK normalizes this relationship; supplier_n',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Warehouse/receiving personnel must be recorded for each goods receipt for accountability, quality control traceability, and resolving discrepancies with suppliers or internal stakeholders.',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to inventory.warehouse. Business justification: Goods receipts post inventory to specific warehouses. Increases on-hand stock at receiving location for inventory availability and putaway processing.',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Goods receipts for maintenance materials are linked to specific work orders. Warehouse receives parts and directly assigns them to open maintenance jobs for cost tracking.',
    `bill_of_lading_number` STRING COMMENT 'Carrier-issued bill of lading number for the inbound shipment. Used for freight audit, customs clearance, and logistics dispute resolution.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity for which the goods receipt is posted. Determines the financial accounting ledger, currency, and fiscal year variant for inventory valuation.. Valid values are `^[A-Z0-9]{4}$`',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the received goods were manufactured or produced. Required for customs declarations, import duty calculation, RoHS/REACH compliance, and conflict minerals reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the goods receipt record was first created in the source system (SAP S/4HANA). Used for audit trail, data lineage, and SLA compliance tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the purchase order and goods receipt valuation. Used for multi-currency financial reporting and GR/IR account clearing.. Valid values are `^[A-Z]{3}$`',
    `customs_declaration_number` STRING COMMENT 'Import customs declaration or entry number associated with the inbound shipment. Required for cross-border receipts to evidence customs clearance and duty payment for regulatory compliance.',
    `delivery_note_number` STRING COMMENT 'Supplier-provided delivery note or packing slip number accompanying the physical shipment. Used for three-way match, dispute resolution, and proof of delivery.',
    `document_date` DATE COMMENT 'The date of the physical goods receipt document (e.g., delivery note date). Represents the actual date goods arrived at the facility, which may differ from the posting date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign exchange rate applied at the time of goods receipt posting to convert document currency to local currency. Critical for multinational financial reporting and GR/IR reconciliation.',
    `gr_ir_clearing_status` STRING COMMENT 'Status of the GR/IR clearing account in SAP FI. Tracks whether the financial liability created by the goods receipt has been offset by a corresponding supplier invoice. Critical for period-end accruals and balance sheet accuracy.. Valid values are `open|partially_cleared|fully_cleared`',
    `grn_number` STRING COMMENT 'Business-facing Goods Receipt Note number assigned by SAP S/4HANA MM upon posting of the goods receipt. This is the primary external reference used in three-way match, invoice verification, and supplier communications.. Valid values are `^GRN-[0-9]{10}$`',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether any line item in this goods receipt contains hazardous materials subject to special handling, storage, and regulatory reporting requirements under OSHA, EPA, REACH, or RoHS.. Valid values are `true|false`',
    `inbound_delivery_number` STRING COMMENT 'Reference to the inbound delivery document (ASN-based or warehouse-managed) associated with this goods receipt. Links the GRN to the suppliers advance shipping notice and Infor WMS receiving process.',
    `inspection_lot_number` STRING COMMENT 'SAP QM inspection lot number created upon goods receipt when quality inspection is required. Links the GRN to the quality inspection results, usage decision, and non-conformance records.',
    `is_return_delivery` BOOLEAN COMMENT 'Indicates whether this goods receipt document represents a return of goods to the vendor (e.g., SAP movement type 122 or 161). Used to distinguish inbound receipts from outbound returns in inventory and spend reporting.. Valid values are `true|false`',
    `is_reversal` BOOLEAN COMMENT 'Indicates whether this goods receipt document is a reversal (cancellation) of a previously posted GRN. Reversals negate the original inventory movement and financial posting.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the goods receipt record in the source system or lakehouse. Used for incremental data loading, change detection, and audit trail.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `local_currency_code` STRING COMMENT 'ISO 4217 currency code of the company codes local (functional) currency. Used for financial reporting and currency translation in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `material_document_number` STRING COMMENT 'SAP material document number generated upon goods receipt posting in MIGO. Uniquely identifies the inventory movement document in SAP S/4HANA MM and is used for reversal, audit trail, and three-way match.. Valid values are `^[0-9]{10}$`',
    `material_document_year` STRING COMMENT 'Fiscal year in which the material document was posted in SAP S/4HANA. Required in combination with material_document_number to uniquely identify the document in SAP.. Valid values are `^[0-9]{4}$`',
    `movement_type` STRING COMMENT 'SAP inventory movement type code governing how the goods receipt affects stock. 101 = GR against PO to unrestricted stock; 103 = GR to blocked stock; 105 = Release from blocked to unrestricted; 122 = Return to vendor; 161 = GR for returns PO; 501 = Receipt without PO.. Valid values are `101|103|105|122|161|501|502`',
    `on_time_delivery_flag` BOOLEAN COMMENT 'Indicates whether the goods were received on or before the scheduled delivery date from the purchase order. Used directly in supplier on-time delivery (OTD) rate calculations and performance scorecards.. Valid values are `true|false`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or warehouse facility where goods are physically received. Drives inventory posting, valuation area, and MRP planning.. Valid values are `^[A-Z0-9]{4}$`',
    `posting_date` DATE COMMENT 'The accounting date on which the goods receipt is posted in SAP S/4HANA. Determines the fiscal period for inventory valuation and financial accounting entries. May differ from the physical receipt date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `purchase_order_number` STRING COMMENT 'Reference to the SAP Purchase Order against which goods are being received. Central linkage for three-way match (PO, GRN, Invoice) and procurement lifecycle tracking.. Valid values are `^[0-9]{10}$`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization responsible for the purchase order against which goods are received. Used for procurement analytics, spend reporting, and organizational accountability.',
    `quality_inspection_required` BOOLEAN COMMENT 'Indicates whether the goods receipt triggers a quality inspection lot in SAP QM. When true, received goods are placed in quality inspection stock and cannot be consumed until inspection is released. Driven by material master QM settings.. Valid values are `true|false`',
    `quality_inspection_status` STRING COMMENT 'Current status of the quality inspection associated with this goods receipt. Drives stock availability: accepted releases to unrestricted stock; rejected triggers return to vendor; conditionally_accepted may require CAPA.. Valid values are `not_required|pending|in_progress|accepted|rejected|conditionally_accepted`',
    `reversed_document_number` STRING COMMENT 'Material document number of the original GRN that this document reverses. Populated only when is_reversal is true. Enables audit trail linkage between original and reversal documents.',
    `scheduled_delivery_date` DATE COMMENT 'The originally scheduled delivery date from the purchase order or delivery schedule. Used to calculate on-time delivery performance and delivery variance for supplier scorecards.. Valid values are `^d{4}-d{2}-d{2}$`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this goods receipt record originated. Supports data lineage, reconciliation, and multi-system integration in the Databricks lakehouse.. Valid values are `SAP_S4HANA|INFOR_WMS|MANUAL`',
    `status` STRING COMMENT 'Current processing status of the goods receipt document. posted indicates inventory has been updated; reversed indicates the GRN has been cancelled; blocked indicates a hold pending resolution; in_quality_inspection indicates goods are under QM inspection; completed indicates all downstream processes (invoice, QI) are closed.. Valid values are `posted|reversed|blocked|in_quality_inspection|completed`',
    `storage_location_code` STRING COMMENT 'SAP storage location within the receiving plant where goods are physically placed upon receipt. Determines the inventory bin assignment and WMS putaway strategy in Infor WMS.. Valid values are `^[A-Z0-9]{4}$`',
    `supplier_number` STRING COMMENT 'SAP vendor number of the supplier from whom goods were received. Used for supplier performance tracking, three-way match, and spend analytics.',
    `three_way_match_status` STRING COMMENT 'Status of the three-way match process between the Purchase Order, Goods Receipt Note, and Supplier Invoice in SAP S/4HANA MM. matched enables automatic invoice payment; exception requires manual review.. Valid values are `pending|matched|partially_matched|exception|cleared`',
    `timestamp` TIMESTAMP COMMENT 'Precise date and time when the goods receipt was physically recorded and posted in SAP S/4HANA MIGO. Used for on-time delivery measurement, dock-to-stock cycle time analysis, and audit trail.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `total_gr_value` DECIMAL(18,2) COMMENT 'Total inventory value of all line items received in this goods receipt, calculated at the purchase order price or moving average price. Used for financial accruals, GR/IR clearing, and spend analytics.',
    `total_item_count` STRING COMMENT 'Total number of line items (material positions) included in this goods receipt document. Used for receiving workload analysis and completeness validation.. Valid values are `^[0-9]+$`',
    CONSTRAINT pk_procurement_goods_receipt PRIMARY KEY(`procurement_goods_receipt_id`)
) COMMENT 'Records the physical receipt of materials against a purchase order at a plant or warehouse location. Captures GRN (Goods Receipt Note) number, received quantity, actual delivery date, storage location, batch number, quality inspection lot trigger, and movement type. SSOT for inbound material flow aligned with SAP MM Goods Receipt (MIGO/MIGO_GR). Feeds inventory and accounts payable.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` (
    `goods_receipt_line_id` BIGINT COMMENT 'Unique surrogate identifier for each goods receipt line item in the silver layer lakehouse. Serves as the primary key for this entity, enabling precise referencing of individual material receipt line records.',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: Goods receipt lines trigger inspection lot creation for quality-controlled materials. Warehouse cannot post goods to unrestricted stock until quality releases the inspection lot with usage decision.',
    `inventory_sku_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Receipt lines record which SKU was physically received. Updates inventory balances and triggers putaway for specific materials.',
    `logistics_inbound_delivery_id` BIGINT COMMENT 'Foreign key linking to logistics.inbound_delivery. Business justification: Each goods receipt line references the inbound delivery for traceability - quality control uses this to track lot numbers, inspection results, and supplier delivery performance.',
    `procurement_goods_receipt_id` BIGINT COMMENT 'Foreign key linking to procurement.goods_receipt. Business justification: Goods receipt lines are the item-level detail records of a goods receipt header. This is the fundamental parent-child relationship in the GRN data model. material_document_number is retained as a busi',
    `procurement_po_line_item_id` BIGINT COMMENT 'Foreign key linking to procurement.po_line_item. Business justification: Goods receipt lines record the receipt of materials against specific PO line items, enabling quantity tracking and three-way match. The table has purchase_order_number and purchase_order_line_number. ',
    `batch_number` STRING COMMENT 'Batch or lot number (CHARG) assigned to the received material at the time of goods receipt. Mandatory for batch-managed materials. Enables full batch traceability from supplier through production to customer delivery, supporting regulatory compliance for regulated materials.',
    `bill_of_lading_number` STRING COMMENT 'Carriers bill of lading number associated with the inbound shipment. Enables linkage between the goods receipt and the transportation document for logistics tracking, customs compliance, and freight audit.',
    `cost_center` STRING COMMENT 'SAP cost center (KOSTL) associated with the goods receipt, applicable for non-stock or direct consumption receipts. Enables cost allocation to the responsible organizational unit for management accounting.',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the received material was manufactured or produced. Required for customs declarations, import compliance, REACH/RoHS regulatory reporting, and trade preference determination.. Valid values are `^[A-Z]{3}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the valuation amount (e.g., USD, EUR, GBP). Supports multi-currency operations across global manufacturing sites and enables currency conversion for consolidated financial reporting.. Valid values are `^[A-Z]{3}$`',
    `delivery_note_number` STRING COMMENT 'Suppliers delivery note or packing slip number (LIEFN) accompanying the physical shipment. Used for three-way matching (PO, GR, Invoice), goods receipt verification, and dispute resolution with suppliers.',
    `delivery_variance_percent` DECIMAL(18,2) COMMENT 'Delivery variance expressed as a percentage of the PO ordered quantity. Enables standardized supplier performance benchmarking and tolerance threshold monitoring across different materials and units.. Valid values are `^-?[0-9]+(.[0-9]{1,4})?$`',
    `delivery_variance_quantity` DECIMAL(18,2) COMMENT 'Difference between the received quantity and the PO ordered quantity (received_quantity minus po_ordered_quantity). Negative values indicate under-delivery; positive values indicate over-delivery. Critical for supplier performance measurement and procurement compliance.. Valid values are `^-?[0-9]+(.[0-9]{1,4})?$`',
    `document_date` DATE COMMENT 'Date of the physical goods receipt or the date on the suppliers delivery document (BLDAT). Represents the actual date goods were received at the facility, which may differ from the posting date.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `excise_duty_indicator` BOOLEAN COMMENT 'Indicates whether the received material is subject to excise duty or customs duty. Triggers excise duty postings and customs compliance workflows in the ERP system for applicable jurisdictions.. Valid values are `true|false`',
    `goods_receipt_timestamp` TIMESTAMP COMMENT 'Precise date and time when the goods receipt was physically recorded or system-posted. Supports time-stamped audit trails, SLA measurement, and intraday inventory visibility.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}[+-][0-9]{2}:[0-9]{2}$`',
    `gr_ir_account_code` STRING COMMENT 'General ledger account code for the GR/IR clearing account (WRX) used in the financial posting of this goods receipt line. Supports three-way match reconciliation between PO, GR, and supplier invoice.',
    `hazardous_material_indicator` BOOLEAN COMMENT 'Indicates whether the received material is classified as hazardous (GEFST). Triggers special handling, storage, and documentation requirements including MSDS/SDS compliance, OSHA HazCom, and EPA reporting obligations.. Valid values are `true|false`',
    `inspection_lot_number` STRING COMMENT 'SAP QM inspection lot number (PRUEFLOS) created automatically upon goods receipt for quality-relevant materials. Links the GR line to the quality inspection record for usage decision tracking and results recording.',
    `is_final_delivery` BOOLEAN COMMENT 'Indicates whether this goods receipt line represents the final delivery against the PO line (ELIKZ). When true, no further deliveries are expected and the PO line is closed for further GR posting.. Valid values are `true|false`',
    `is_partial_delivery` BOOLEAN COMMENT 'Indicates whether this goods receipt line represents a partial delivery against the PO line (received quantity is less than the total ordered quantity). Supports open PO quantity tracking and expediting workflows.. Valid values are `true|false`',
    `line_item_number` STRING COMMENT 'Sequential line item number (ZEILE) within the material document identifying this specific receipt line. Used to distinguish multiple material lines within the same GR document.. Valid values are `^[0-9]{1,4}$`',
    `material_document_number` STRING COMMENT 'SAP MM material document number (MBLNR) assigned upon goods receipt posting. Uniquely identifies the parent goods receipt document in the source ERP system. Used for audit trails and document traceability.. Valid values are `^[0-9]{10}$`',
    `material_document_year` STRING COMMENT 'Fiscal year (MJAHR) in which the material document was posted in SAP MM. Combined with material_document_number, uniquely identifies the GR document in the source system.. Valid values are `^[0-9]{4}$`',
    `material_group` STRING COMMENT 'SAP material group code (MATKL) classifying the received material into a commodity or spend category. Supports category management, spend analytics, and procurement reporting by material group.. Valid values are `^[A-Z0-9]{1,9}$`',
    `movement_type` STRING COMMENT 'SAP inventory movement type code (BWART) classifying the nature of the goods movement (e.g., 101=GR for PO, 122=Return to Vendor, 161=GR for Returns). Determines stock account postings and inventory impact.. Valid values are `^[0-9]{3}$`',
    `over_delivery_tolerance_percent` DECIMAL(18,2) COMMENT 'Maximum allowable over-delivery percentage defined on the PO line (UEBTO). Receipts exceeding this tolerance trigger system warnings or blocks. Sourced from SAP PO item conditions.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `plant_code` STRING COMMENT 'SAP plant code (WERKS) identifying the manufacturing or storage facility where the goods were received. Determines inventory valuation area, storage locations, and MRP planning scope.. Valid values are `^[A-Z0-9]{4}$`',
    `po_ordered_quantity` DECIMAL(18,2) COMMENT 'Original quantity ordered on the referenced PO line item. Used to calculate delivery variance and determine whether the receipt constitutes a partial, exact, or over-delivery against the PO.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `posting_date` DATE COMMENT 'Accounting date (BUDAT) on which the goods receipt was posted in the ERP system. Determines the fiscal period for inventory and financial account postings. May differ from the physical receipt date.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `profit_center` STRING COMMENT 'SAP profit center (PRCTR) to which the inventory value of the received goods is assigned. Enables cost allocation, profitability analysis, and segment reporting by business unit.',
    `purchase_order_line_number` STRING COMMENT 'Line item number (EBELP) of the referenced Purchase Order line against which this GR line is posted. Enables precise PO line-level matching and open quantity tracking.. Valid values are `^[0-9]{1,5}$`',
    `purchase_order_number` STRING COMMENT 'Reference to the Purchase Order (EBELN) against which this goods receipt line was posted. Enables PO-to-GR matching, three-way invoice verification, and procurement lifecycle tracking.. Valid values are `^[0-9]{10}$`',
    `purchasing_group` STRING COMMENT 'SAP purchasing group code (EKGRP) identifying the buyer or buyer group responsible for the PO. Used for workload distribution, spend reporting by buyer, and procurement accountability.. Valid values are `^[A-Z0-9]{3}$`',
    `purchasing_organization` STRING COMMENT 'SAP purchasing organization code (EKORG) responsible for the procurement of the material. Defines the organizational unit for procurement activities, pricing conditions, and supplier contracts.. Valid values are `^[A-Z0-9]{4}$`',
    `quality_inspection_status` STRING COMMENT 'Current quality inspection status of the received goods line. Drives stock posting to quality inspection stock, unrestricted stock, or blocked stock. Aligned with SAP QM inspection lot status and AQL-based acceptance criteria.. Valid values are `not_required|pending|in_inspection|accepted|rejected|conditionally_accepted|blocked`',
    `received_quantity` DECIMAL(18,2) COMMENT 'Actual quantity of material received and posted in the goods receipt line (MENGE). Expressed in the base unit of measure. Used for inventory updates, PO open quantity calculation, and delivery variance analysis.. Valid values are `^-?[0-9]+(.[0-9]{1,4})?$`',
    `reversal_document_number` STRING COMMENT 'Material document number of the reversal posting that cancelled this goods receipt line. Populated only when reversal_indicator is true. Enables complete audit trail linking original and reversal documents.. Valid values are `^[0-9]{10}$`',
    `reversal_indicator` BOOLEAN COMMENT 'Indicates whether this goods receipt line has been reversed or cancelled (STORNO). Reversed lines negate the original inventory and financial postings. Critical for audit trail integrity and accurate open PO quantity calculation.. Valid values are `true|false`',
    `scheduled_delivery_date` DATE COMMENT 'Planned delivery date from the Purchase Order line (EINDT) against which the actual receipt date is compared. Used to calculate on-time delivery performance for supplier KPI reporting.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `serial_number` STRING COMMENT 'Unique serial number assigned to a serialized material received. Applicable for high-value or regulated components requiring individual unit traceability throughout the asset lifecycle.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this goods receipt line was extracted. Supports data lineage tracking, multi-system reconciliation, and silver layer data provenance in the lakehouse.. Valid values are `SAP_S4HANA|LEGACY_ERP|MANUAL`',
    `stock_type` STRING COMMENT 'Type of stock into which the received material was posted (SOBKZ/INSMK). Determines material availability for production planning and MRP. Quality inspection stock is unavailable for consumption until released.. Valid values are `unrestricted|quality_inspection|blocked|restricted|returns`',
    `storage_bin` STRING COMMENT 'Specific warehouse storage bin (LGPLA) assigned to the received material within the warehouse management system. Enables precise bin-level inventory tracking and putaway confirmation.',
    `storage_location_code` STRING COMMENT 'SAP storage location code (LGORT) where the received material was physically placed within the plant. Drives inventory stock updates at the storage location level and supports warehouse management.. Valid values are `^[A-Z0-9]{4}$`',
    `supplier_batch_number` STRING COMMENT 'Vendors own batch or lot number as provided on the delivery documentation. Enables cross-referencing between internal batch numbers and supplier batch identifiers for traceability and quality investigations.',
    `under_delivery_tolerance_percent` DECIMAL(18,2) COMMENT 'Maximum allowable under-delivery percentage defined on the PO line (UNTTO). Receipts below this tolerance may be treated as final delivery. Sourced from SAP PO item conditions.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `unit_of_measure` STRING COMMENT 'Base unit of measure (MEINS) in which the received quantity is expressed (e.g., EA, KG, L, M, PC). Aligns with the material master unit of measure for inventory consistency.. Valid values are `^[A-Z]{2,5}$`',
    `valuation_amount` DECIMAL(18,2) COMMENT 'Total monetary value of the goods receipt line (DMBTR) posted to inventory and the GR/IR clearing account. Calculated as received quantity multiplied by valuation price. Used for financial reporting and three-way match.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `valuation_price` DECIMAL(18,2) COMMENT 'Price per unit used for inventory valuation of the received material (DMBTR/MENGE). Derived from the PO price or standard cost depending on the materials price control setting. Used for financial postings to the GR/IR clearing account.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `vendor_number` STRING COMMENT 'SAP vendor master number (LIFNR) identifying the supplier from whom the goods were received. Enables supplier performance tracking, spend analytics, and GR-to-invoice matching at the vendor level.. Valid values are `^[0-9]{1,10}$`',
    CONSTRAINT pk_goods_receipt_line PRIMARY KEY(`goods_receipt_line_id`)
) COMMENT 'Line-level detail of a goods receipt capturing individual material quantities received, batch assignments, quality inspection status, storage bin allocation, and variance from PO quantity. Supports partial deliveries, over-delivery handling, and batch traceability for regulated materials. Aligned with SAP MM GR Item (MSEG).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` (
    `procurement_supplier_invoice_id` BIGINT COMMENT 'Unique surrogate identifier for the supplier invoice record in the Databricks Silver Layer. Primary key for this data product.',
    `ap_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ap_invoice. Business justification: Supplier invoices are recorded as AP invoices in finance for payment processing and GL posting. Accounts payable team reconciles procurement invoices against financial records daily.',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Supplier invoices received in procurement are recorded as formal billing documents. This links procurements receipt of supplier invoice to the billing systems invoice master record for payment proce',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: Suppliers invoice against service contracts for maintenance agreements, calibration services, and equipment support. Procurement matches invoices to service contracts for three-way matching and paymen',
    `procurement_goods_receipt_id` BIGINT COMMENT 'Foreign key linking to procurement.goods_receipt. Business justification: Supplier invoices reference the goods receipt for three-way match validation (PO quantity, GRN quantity, invoice quantity). The table has grn_number. Adding goods_receipt_id FK formalizes this critica',
    `procurement_payment_term_id` BIGINT COMMENT 'Foreign key linking to procurement.payment_term. Business justification: Supplier invoices specify payment terms that govern the payment due date calculation. Linking to the payment_term reference table ensures standardized payment term validation and enables cash flow for',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Supplier invoices are submitted against specific purchase orders as part of the three-way match process. This is a core relationship in the accounts payable lifecycle. po_number is retained as a busin',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Supplier invoices are submitted by specific supplier organizations. The table stores supplier_code and supplier_name. Adding supplier_id FK normalizes this relationship; supplier_name is redundant onc',
    `tax_code_id` BIGINT COMMENT 'Foreign key linking to finance.tax_code. Business justification: Supplier invoices apply tax codes for VAT/GST calculation and compliance. Tax teams use this for tax return preparation and input tax reclaim.',
    `baseline_date` DATE COMMENT 'The baseline date used in SAP S/4HANA for calculating payment due dates based on payment terms. Typically the invoice date or goods receipt date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `company_code` STRING COMMENT 'The SAP company code representing the legal entity responsible for paying the invoice. Used for financial reporting and intercompany reconciliation.',
    `cost_center` STRING COMMENT 'The SAP cost center to which the invoice cost is allocated. Used for internal cost reporting and budget control.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the invoice record was first created in the source system (SAP S/4HANA MIRO). Used for audit trail and data lineage.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `early_payment_discount_amount` DECIMAL(18,2) COMMENT 'The cash discount amount available if payment is made within the early payment discount period as per agreed payment terms (e.g., 2% if paid within 10 days).',
    `early_payment_discount_date` DATE COMMENT 'The last date by which payment must be made to qualify for the early payment cash discount. Supports dynamic discounting and working capital optimization.. Valid values are `^d{4}-d{2}-d{2}$`',
    `entry_date` DATE COMMENT 'The date the invoice was entered/received into the SAP S/4HANA system. Used for aging analysis and processing SLA measurement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `fiscal_period` STRING COMMENT 'The fiscal period (accounting period) within the fiscal year in which the invoice is posted. Used for month-end close and accrual management.. Valid values are `^(0[1-9]|1[0-6])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the invoice is posted. Used for period-end financial reporting and audit.. Valid values are `^d{4}$`',
    `gl_account_code` STRING COMMENT 'The general ledger account code to which the invoice expense is posted in SAP FI. Determines financial statement classification.',
    `grn_number` STRING COMMENT 'The goods receipt note number associated with the delivery against which this invoice is raised. Central to three-way match verification.',
    `gross_amount` DECIMAL(18,2) COMMENT 'The total gross amount of the invoice including all taxes and charges. Represents the total liability to the supplier.',
    `invoice_type` STRING COMMENT 'Classification of the invoice document type. Determines accounting treatment and processing workflow in SAP S/4HANA.. Valid values are `standard|credit_memo|debit_memo|subsequent_debit|subsequent_credit|evaluated_receipt_settlement`',
    `is_duplicate` BOOLEAN COMMENT 'Indicates whether the invoice has been identified as a potential duplicate of a previously processed invoice. SAP MIRO performs duplicate check on invoice number, supplier, date, and amount.. Valid values are `true|false`',
    `is_payment_blocked` BOOLEAN COMMENT 'Indicates whether the invoice has been blocked for payment in SAP S/4HANA. A blocked invoice cannot be included in payment runs until the block is resolved.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent modification to the invoice record in the source system. Supports change tracking and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `net_amount` DECIMAL(18,2) COMMENT 'The net invoiced amount before tax, as stated on the supplier invoice. Represents the value of goods or services invoiced.',
    `payment_block_reason` STRING COMMENT 'The reason code explaining why the invoice has been blocked for payment. Used for exception management and resolution workflow.. Valid values are `price_variance|quantity_variance|quality_hold|missing_grn|duplicate_invoice|manual_block|tolerance_exceeded|pending_approval|disputed`',
    `payment_method` STRING COMMENT 'The method by which the invoice will be settled (e.g., bank transfer, ACH, virtual card). Determines payment run processing in SAP FI-AP.. Valid values are `bank_transfer|check|ach|wire|virtual_card|dynamic_discounting|supply_chain_finance`',
    `payment_terms_code` STRING COMMENT 'The payment terms code (e.g., NET30, 2/10NET30) applicable to this invoice as agreed with the supplier. Determines due date and early payment discount eligibility.',
    `plant_code` STRING COMMENT 'The SAP plant code identifying the receiving plant or manufacturing facility for which goods/services were procured.',
    `po_number` STRING COMMENT 'The purchase order number referenced on the supplier invoice. Used as the primary linkage for three-way match (PO-GRN-Invoice) validation.',
    `posting_date` DATE COMMENT 'The date on which the invoice was posted in SAP S/4HANA FI. Determines the fiscal period for accounting and accrual purposes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `price_variance_amount` DECIMAL(18,2) COMMENT 'The monetary difference between the invoiced unit price and the purchase order price. A non-zero value triggers discrepancy review and may result in payment block.',
    `purchasing_org_code` STRING COMMENT 'The SAP purchasing organization code responsible for the underlying purchase order. Used for spend reporting and procurement governance.',
    `quantity_variance_amount` DECIMAL(18,2) COMMENT 'The difference between the quantity invoiced by the supplier and the quantity confirmed on the goods receipt. Used to identify overbilling or underbilling.',
    `sap_document_number` STRING COMMENT 'The internal SAP FI accounting document number generated upon posting of the invoice in SAP S/4HANA MIRO. Used for financial reconciliation and audit trail.',
    `status` STRING COMMENT 'Current processing status of the supplier invoice in the accounts payable lifecycle. Drives workflow routing and payment execution.. Valid values are `received|under_review|matched|approved|payment_blocked|posted|scheduled_for_payment|paid|cancelled|disputed|parked`',
    `supplier_code` STRING COMMENT 'The unique vendor/supplier code as maintained in SAP S/4HANA vendor master (LFA1). Identifies the invoicing supplier.',
    `tax_amount` DECIMAL(18,2) COMMENT 'The total tax amount (VAT/GST/sales tax) charged on the invoice. Captured separately for tax reporting and compliance.',
    `tax_code` STRING COMMENT 'The SAP tax code applied to the invoice for VAT/GST determination. Drives tax calculation and tax reporting obligations.',
    `three_way_match_status` STRING COMMENT 'Result of the three-way match validation comparing the Purchase Order (PO), Goods Receipt Note (GRN), and supplier invoice. Core control in SAP MIRO invoice verification.. Valid values are `matched|price_variance|quantity_variance|grn_missing|po_missing|tolerance_exceeded|pending`',
    `withholding_tax_amount` DECIMAL(18,2) COMMENT 'The amount of withholding tax deducted from the invoice payment, applicable in jurisdictions requiring tax withholding on supplier payments.',
    CONSTRAINT pk_procurement_supplier_invoice PRIMARY KEY(`procurement_supplier_invoice_id`)
) COMMENT 'Supplier-submitted invoice for goods or services delivered against a purchase order. Captures invoice number, invoice date, gross amount, tax amount, currency, payment due date, three-way match status (PO-GRN-Invoice), and payment block reasons. Aligned with SAP MM Invoice Verification (MIRO/MIR7). Feeds accounts payable in the finance domain.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`mrp_run` (
    `mrp_run_id` BIGINT COMMENT 'Unique system-generated identifier for each MRP or MRP II planning run execution record in the Silver Layer lakehouse.',
    `supply_network_node_id` BIGINT COMMENT 'Foreign key linking to procurement.supply_network_node. Business justification: MRP runs are executed for specific plants/supply network nodes. The table stores plant_code and plant_name. Adding supply_network_node_id FK normalizes this relationship; plant_name is redundant once ',
    `bom_explosion_level` STRING COMMENT 'Maximum number of BOM levels exploded during the MRP run. Indicates the depth of the product structure traversed to derive dependent requirements for sub-assemblies and raw materials.. Valid values are `^[0-9]+$`',
    `capacity_check_performed` BOOLEAN COMMENT 'Indicates whether a capacity requirements planning (CRP) check was executed as part of this MRP II run to validate work center availability against planned production orders.. Valid values are `true|false`',
    `capacity_overload_count` STRING COMMENT 'Number of work centers identified as overloaded (capacity demand exceeds available capacity) during the MRP II capacity check. Requires production scheduling intervention.. Valid values are `^[0-9]+$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant location where the MRP run was executed. Supports multi-country reporting and regional supply planning analytics.. Valid values are `^[A-Z]{3}$`',
    `coverage_shortfall_count` STRING COMMENT 'Number of materials with identified supply shortfalls (demand exceeds available supply within the planning horizon) after the MRP run. Critical KPI for supply risk management.. Valid values are `^[0-9]+$`',
    `exception_cancel_count` STRING COMMENT 'Count of MRP exception messages recommending cancellation of existing planned receipts (purchase orders or production orders) due to excess supply or demand cancellation.. Valid values are `^[0-9]+$`',
    `exception_messages_total` STRING COMMENT 'Total count of MRP exception messages generated during the run across all materials. Exception messages flag planning anomalies requiring MRP controller review and action.. Valid values are `^[0-9]+$`',
    `exception_new_requirement_count` STRING COMMENT 'Count of MRP exception messages indicating new demand requirements that have been identified and for which new planned orders or purchase requisitions have been created.. Valid values are `^[0-9]+$`',
    `exception_reschedule_in_count` STRING COMMENT 'Count of MRP exception messages recommending that existing receipts (purchase orders, production orders) be rescheduled to an earlier date to cover demand shortfalls.. Valid values are `^[0-9]+$`',
    `exception_reschedule_out_count` STRING COMMENT 'Count of MRP exception messages recommending that existing receipts be rescheduled to a later date due to excess supply or demand postponement.. Valid values are `^[0-9]+$`',
    `fiscal_period` STRING COMMENT 'Fiscal period (month) within the fiscal year in which the MRP run was executed. Enables period-over-period comparison of planning run outputs and exception trends.. Valid values are `^(0[1-9]|1[0-2])$`',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the MRP planning run was executed. Used for financial period alignment in procurement spend analytics and supply planning reporting.. Valid values are `^[0-9]{4}$`',
    `horizon_end_date` DATE COMMENT 'The end date of the planning horizon window for this MRP run. Marks the latest date for which planned orders and procurement proposals are generated.. Valid values are `^d{4}-d{2}-d{2}$`',
    `horizon_start_date` DATE COMMENT 'The start date of the planning horizon window for this MRP run. Marks the earliest date for which planned orders and procurement proposals are generated.. Valid values are `^d{4}-d{2}-d{2}$`',
    `initiated_by` STRING COMMENT 'SAP user ID or system job name that triggered the MRP planning run. Distinguishes between manually initiated runs by MRP controllers and automated scheduled batch jobs.',
    `material_range_from` STRING COMMENT 'Starting material number of the material range included in the MRP run when run_scope is material_range. Enables targeted replanning of specific material groups.',
    `material_range_to` STRING COMMENT 'Ending material number of the material range included in the MRP run when run_scope is material_range. Defines the upper boundary of the material selection.',
    `mrp_area` STRING COMMENT 'SAP MRP area within the plant that scopes the planning run. An MRP area can represent a storage location, subcontractor, or the entire plant, enabling granular supply planning.',
    `mrp_controller_group` STRING COMMENT 'SAP MRP controller group code responsible for reviewing and acting on the exception messages and planned orders generated by this MRP run.',
    `planned_orders_created` STRING COMMENT 'Number of new planned production orders generated by the MRP run. Planned orders represent internal manufacturing proposals that MRP controllers review and convert to production orders.. Valid values are `^[0-9]+$`',
    `planning_date` DATE COMMENT 'The business date used as the reference point for the MRP planning run. All requirements, receipts, and planned orders are evaluated relative to this date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planning_horizon_days` STRING COMMENT 'Number of calendar days forward from the planning date that the MRP run covers. Defines the time fence within which planned orders and procurement proposals are generated.. Valid values are `^[0-9]+$`',
    `planning_mode` STRING COMMENT 'Indicates the planning methodology applied during the run: standard MRP (Material Requirements Planning), MRP II (Manufacturing Resource Planning including capacity), consumption-based, reorder point, or forecast-based planning.. Valid values are `mrp|mrp_ii|consumption_based|reorder_point|forecast_based`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility for which the MRP run was executed. Aligns with the organizational unit in SAP S/4HANA.. Valid values are `^[A-Z0-9]{4}$`',
    `purchase_requisitions_created` STRING COMMENT 'Number of purchase requisitions automatically generated by the MRP run for externally procured materials. PRs are subsequently converted to purchase orders by the procurement team.. Valid values are `^[0-9]+$`',
    `run_duration_seconds` STRING COMMENT 'Total elapsed time in seconds for the MRP planning run to complete. Used to monitor system performance, identify degradation trends, and plan batch scheduling windows.. Valid values are `^[0-9]+$`',
    `run_end_timestamp` TIMESTAMP COMMENT 'Date and time when the MRP planning run completed in SAP S/4HANA. Combined with run_start_timestamp to calculate run duration for performance benchmarking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `run_number` STRING COMMENT 'Business-facing alphanumeric identifier for the MRP planning run, used for cross-referencing in SAP S/4HANA PP/MM and audit trail documentation.. Valid values are `^MRP-[0-9]{4}-[0-9]{6}$`',
    `run_scope` STRING COMMENT 'Defines the breadth of materials included in the MRP run: a single material, a defined material range, all materials in the MRP area, or the entire plant.. Valid values are `single_material|material_range|all_materials|mrp_area|plant_wide`',
    `run_start_timestamp` TIMESTAMP COMMENT 'Date and time when the MRP planning run was initiated in SAP S/4HANA. Used for performance monitoring, audit trail, and scheduling conflict detection.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `run_trigger_type` STRING COMMENT 'Indicates how the MRP run was initiated: manually by an MRP controller, via a scheduled batch job, triggered by a business event (e.g., large sales order), or via API integration.. Valid values are `manual|scheduled_batch|event_driven|api_triggered`',
    `run_type` STRING COMMENT 'Classification of the MRP planning run scope: regenerative replans all materials, net_change replans only materials with changes since last run, net_change_planning_horizon limits net change to the planning horizon window.. Valid values are `regenerative|net_change|net_change_planning_horizon`',
    `schedule_lines_created` STRING COMMENT 'Number of delivery schedule lines generated by the MRP run for scheduling agreement-based procurement. Represents firm or forecast delivery commitments to suppliers.. Valid values are `^[0-9]+$`',
    `scheduling_type` STRING COMMENT 'Defines the scheduling logic applied during the MRP run: basic date calculation, lead time scheduling using routing data, or capacity planning with work center load leveling.. Valid values are `basic_dates|lead_time_scheduling|capacity_planning`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which the MRP run data was extracted. Supports data lineage tracking in the Databricks Silver Layer lakehouse.. Valid values are `SAP_S4HANA|SAP_ECC|OPCENTER|OTHER`',
    `source_system_run_reference` STRING COMMENT 'The native identifier of the MRP run in the source operational system (e.g., SAP S/4HANA internal run key). Enables traceability and reconciliation between the lakehouse and the system of record.',
    `status` STRING COMMENT 'Current execution status of the MRP planning run. Supports MRP controller workflow management and exception handling processes.. Valid values are `initiated|in_progress|completed|completed_with_exceptions|failed|cancelled`',
    `total_materials_planned` STRING COMMENT 'Count of distinct material numbers processed during the MRP run. Used to assess run scope, compare against prior runs, and validate completeness of planning coverage.. Valid values are `^[0-9]+$`',
    CONSTRAINT pk_mrp_run PRIMARY KEY(`mrp_run_id`)
) COMMENT 'Records each MRP (Material Requirements Planning) or MRP II planning run executed in SAP PP/MM. Captures planning scope (plant, MRP area, material range), run type (regenerative, net change, net change in planning horizon), run timestamp, planning horizon, and exception message counts. Provides audit trail for supply planning decisions and supports MRP controller review workflows.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` (
    `mrp_planned_order_id` BIGINT COMMENT 'Unique surrogate identifier for each MRP/MRP II planned order record in the lakehouse silver layer. Serves as the primary key for this entity.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: MRP planned orders are generated for specific components from BOM explosions. Production planning creates these for engineered parts needed to fulfill manufacturing schedules.',
    `forecast_id` BIGINT COMMENT 'Foreign key linking to sales.sales_forecast. Business justification: MRP systems convert sales forecasts into planned production orders. Manufacturing planners trace planned orders back to originating sales forecasts to validate material requirements against actual cus',
    `inventory_sku_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: MRP planned orders propose procurement or production for specific SKUs. Generated by material requirements planning to meet demand forecasts.',
    `mrp_run_id` BIGINT COMMENT 'Foreign key linking to procurement.mrp_run. Business justification: MRP planned orders are generated by specific MRP/MRP II planning runs. This is a fundamental parent-child relationship in the MRP data model. mrp_run_date is retained as a date field (not a business k',
    `order_id` BIGINT COMMENT 'Foreign key linking to production.production_order. Business justification: MRP planned order converts to production order - critical cross-domain link for production planning. No visible redundant columns in truncated attribute list.',
    `procurement_purchase_requisition_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_requisition. Business justification: MRP planned orders are converted into purchase requisitions when firmed. The table has converted_document_number tracking this conversion. Adding purchase_requisition_id FK formalizes the MRP-to-PR co',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supplier. Business justification: MRP planned order references preferred supplier via preferred_vendor_number (STRING). Adding FK for referential integrity, removing redundant string field.',
    `production_plant_id` BIGINT COMMENT 'Foreign key linking to production.production_plant. Business justification: MRP planned orders are plant-specific as each plant has different inventory, capacity, and supply chains. MRP runs separately per plant to generate location-specific procurement recommendations.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: MRP planned orders are generated from sales order demand in make-to-order manufacturing. Production planning uses this to trace material requirements back to customer orders for pegging.',
    `bom_explosion_indicator` BOOLEAN COMMENT 'Indicates whether the MRP run performed a BOM explosion for this planned order to generate dependent requirements for lower-level components. True for production orders; typically false for externally procured materials.. Valid values are `true|false`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity or subsidiary for which this planned order is generated. Supports multi-company-code MRP planning in a multinational enterprise context and financial reporting alignment.. Valid values are `^[A-Z0-9]{1,10}$`',
    `conversion_timestamp` TIMESTAMP COMMENT 'The date and time at which the planned order was converted to a purchase requisition or production order. Supports lead time analysis and MRP controller performance tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `converted_document_number` STRING COMMENT 'The purchase requisition number or production order number to which this planned order was converted upon firming and release. Populated after conversion; null for unconverted planned orders. Enables traceability from planned to actual procurement.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or facility for which this planned order was generated. Supports regional compliance, cross-border procurement regulations, and multinational reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time at which the planned order record was created in the source system (SAP S/4HANA) by the MRP run. Used for audit trail, data lineage, and MRP run frequency analysis.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the planned order value (e.g., USD, EUR, GBP). Supports multi-currency procurement planning and spend analytics in a multinational manufacturing environment.. Valid values are `^[A-Z]{3}$`',
    `demand_source_type` STRING COMMENT 'The type of demand element that triggered the generation of this planned order by MRP (e.g., sales order, planned independent requirement/forecast, safety stock replenishment, dependent demand from BOM explosion, manual reservation, project requirement, service order).. Valid values are `sales_order|forecast|safety_stock|dependent_demand|manual_reservation|project|service_order`',
    `exception_message_code` STRING COMMENT 'SAP MRP exception message code indicating an action required by the MRP controller (e.g., reschedule in, reschedule out, cancel, bring forward, push back). Exception messages highlight planning deviations requiring manual intervention.. Valid values are `^[0-9]{1,5}$`',
    `exception_message_text` STRING COMMENT 'Descriptive text of the MRP exception message associated with this planned order, providing the MRP controller with actionable guidance on the planning deviation (e.g., Reschedule order to earlier date, Order quantity exceeds maximum lot size).',
    `goods_receipt_processing_days` STRING COMMENT 'The number of workdays required for goods receipt inspection and posting after physical delivery, as maintained in the SAP material master. Included in MRP lead time calculation to determine the planned start date.. Valid values are `^[0-9]{1,3}$`',
    `is_firmed` BOOLEAN COMMENT 'Boolean flag indicating whether the planned order has been firmed (fixed) by the MRP controller to prevent automatic rescheduling or deletion by subsequent MRP runs. Firmed orders are protected from MRP changes.. Valid values are `true|false`',
    `lot_size_key` STRING COMMENT 'The lot-sizing procedure applied by MRP to calculate the planned order quantity (e.g., EX=exact lot size, FX=fixed lot size, MB=monthly lot size, HB=replenish to maximum stock level). Determines how demand is aggregated into order quantities.. Valid values are `^[A-Z0-9]{1,4}$`',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time at which the planned order record was last updated in the source system, capturing manual changes by MRP controllers or automatic updates from subsequent MRP runs.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `mrp_area` STRING COMMENT 'MRP area within the plant for which the planned order was generated. Enables sub-plant level planning segmentation such as storage locations or subcontractor areas in SAP S/4HANA.. Valid values are `^[A-Z0-9]{1,10}$`',
    `mrp_controller_code` STRING COMMENT 'Code identifying the MRP controller (planner) responsible for reviewing, firming, and converting this planned order. Corresponds to the MRP controller field in the SAP material master MRP 1 view.. Valid values are `^[A-Z0-9]{1,10}$`',
    `mrp_run_date` DATE COMMENT 'The date on which the MRP/MRP II planning run was executed that generated or last updated this planned order. Used for audit, traceability, and identifying stale planned orders.. Valid values are `^d{4}-d{2}-d{2}$`',
    `mrp_type` STRING COMMENT 'The MRP procedure used to plan this material (e.g., MRP, MPS, consumption-based planning, reorder point planning). Corresponds to the MRP type field in the SAP material master MRP 1 view.. Valid values are `^[A-Z0-9]{1,4}$`',
    `opening_date` DATE COMMENT 'The date on which the planned order should be released or converted to an actionable order (purchase requisition or production order), calculated by subtracting the float before production from the planned start date in SAP MRP.. Valid values are `^d{4}-d{2}-d{2}$`',
    `order_type` STRING COMMENT 'Classification of the planned order indicating the intended conversion target: purchase requisition (external procurement), production order (in-house manufacturing), transfer order (stock transfer), subcontracting, or consignment. Drives MRP controller firming decisions.. Valid values are `purchase_requisition|production_order|transfer_order|subcontracting|consignment`',
    `planned_delivery_days` STRING COMMENT 'The planned delivery time in calendar days for external procurement of this material, as maintained in the SAP material master or purchasing info record. Used by MRP to calculate planned start date from requirements date.. Valid values are `^[0-9]{1,5}$`',
    `planned_finish_date` DATE COMMENT 'The date by which the planned order must be completed (goods receipt or production completion) to satisfy the dependent or independent demand requirement. Derived from MRP scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_order_number` STRING COMMENT 'Business-facing alphanumeric identifier for the planned order as assigned by the MRP/MRP II run in SAP S/4HANA (MD04/MD06). Used by MRP controllers to reference, review, and firm planned orders.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `planned_order_value` DECIMAL(18,2) COMMENT 'Estimated monetary value of the planned order calculated as planned quantity multiplied by the standard or moving average price of the material. Used for spend analytics, budget planning, and procurement commitment reporting.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `planned_quantity` DECIMAL(18,2) COMMENT 'The quantity of material to be procured or produced as determined by the MRP/MRP II run, expressed in the base unit of measure. Reflects lot-sizing rules, safety stock, and demand requirements.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `planned_start_date` DATE COMMENT 'The date on which procurement or production activities for this planned order are scheduled to begin, as calculated by the MRP/MRP II backward scheduling logic. Used for capacity and supplier lead time planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `procurement_type` STRING COMMENT 'Indicates whether the material is procured externally (E), produced in-house (F), or both (X), as defined in the SAP material master MRP 2 view. Determines the planned order conversion path.. Valid values are `external|in_house|both|subcontracting`',
    `purchasing_group_code` STRING COMMENT 'SAP purchasing group (buyer group) responsible for the procurement activity associated with this planned order. Used for workload distribution and spend analytics by buyer.. Valid values are `^[A-Z0-9]{1,10}$`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization responsible for converting this planned order into a purchase requisition or purchase order. Relevant for externally procured planned orders.. Valid values are `^[A-Z0-9]{1,10}$`',
    `requirements_date` DATE COMMENT 'The date on which the material is required to be available in stock to fulfill the demand element (sales order, production order, forecast, safety stock). Drives MRP scheduling backward to determine planned start date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `safety_stock_quantity` DECIMAL(18,2) COMMENT 'The minimum stock level maintained as a buffer against demand variability and supply uncertainty, as defined in the SAP material master MRP 2 view. Influences MRP net requirements calculation and planned order quantities.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `source_plant_code` STRING COMMENT 'For stock transfer planned orders, the supplying plant from which the material will be transferred. Relevant for multi-plant and cross-company-code MRP scenarios in multinational manufacturing environments.. Valid values are `^[A-Z0-9]{1,10}$`',
    `special_procurement_key` STRING COMMENT 'SAP special procurement type key indicating non-standard procurement scenarios such as subcontracting, consignment, stock transfer from another plant, or phantom assembly. Influences planned order type and conversion behavior.. Valid values are `^[A-Z0-9]{1,4}$`',
    `status` STRING COMMENT 'Current lifecycle status of the planned order. Created indicates a system-generated order awaiting review; Firmed indicates the MRP controller has locked the order to prevent MRP rescheduling; Converted indicates the order has been converted to a purchase requisition or production order; Cancelled indicates the order is no longer required; Exception indicates an MRP exception message is pending resolution.. Valid values are `created|firmed|converted|cancelled|exception`',
    `storage_location_code` STRING COMMENT 'The storage location within the plant where the planned goods receipt will be posted upon conversion and execution of the planned order. Supports warehouse and inventory management integration.. Valid values are `^[A-Z0-9]{1,10}$`',
    `unit_of_measure` STRING COMMENT 'Base unit of measure for the planned quantity (e.g., EA for each, KG for kilogram, L for liter, M for meter, PC for piece). Aligned with SAP material master base UoM.. Valid values are `^[A-Z]{1,6}$`',
    CONSTRAINT pk_mrp_planned_order PRIMARY KEY(`mrp_planned_order_id`)
) COMMENT 'Planned orders generated by MRP/MRP II runs representing future procurement or production requirements. Captures material, plant, planned quantity, planned start date, planned finish date, order type (purchase requisition, production order, transfer order), and firming status. Supports MRP controller review, firming decisions, and conversion to purchase requisitions or production orders.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` (
    `demand_forecast_id` BIGINT COMMENT 'Unique surrogate identifier for each demand forecast record in the silver layer lakehouse. Serves as the primary key for all downstream joins and lineage tracking.',
    `blanket_order_id` BIGINT COMMENT 'Foreign key linking to order.blanket_order. Business justification: Demand forecasts are based on blanket orders (framework agreements) with committed volumes. Supply planning uses this to align procurement with contracted customer demand over planning horizons.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Demand forecasts predict future requirements for specific engineered components. Supply planning uses this to communicate long-term needs to suppliers for capacity planning.',
    `forecast_id` BIGINT COMMENT 'Foreign key linking to sales.sales_forecast. Business justification: Manufacturing procurement uses sales forecasts to drive MRP demand planning and material requirements. Production planning teams reference sales projections daily to determine raw material purchasing ',
    `inventory_sku_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Demand forecasts predict future requirements for specific SKUs. Drives MRP planning and supplier capacity commitments for material availability.',
    `production_plant_id` BIGINT COMMENT 'Foreign key linking to production.production_plant. Business justification: Demand forecasts are plant-specific to drive local procurement planning. Each plant forecasts its production needs to ensure materials arrive at the correct manufacturing location.',
    `supply_network_node_id` BIGINT COMMENT 'Foreign key linking to procurement.supply_network_node. Business justification: Demand forecasts are generated for specific plants/supply network nodes to drive supply planning. The table has plant_code. Adding supply_network_node_id FK formalizes this relationship and enables ne',
    `abc_classification` STRING COMMENT 'ABC inventory classification of the forecasted material based on consumption value: A (high value/high attention), B (medium), C (low value/low attention). Drives differentiated forecasting and safety stock policies.. Valid values are `A|B|C`',
    `approved_by` STRING COMMENT 'Name or user ID of the demand planner or S&OP manager who approved and locked the consensus forecast for MRP consumption. Supports audit trail and accountability in the S&OP governance process.',
    `approved_date` DATE COMMENT 'Date on which the forecast was formally approved and locked for MRP input. Used for S&OP cycle governance, audit compliance, and measuring planning cycle time.. Valid values are `^d{4}-d{2}-d{2}$`',
    `consensus_adjustment_quantity` DECIMAL(18,2) COMMENT 'Manual quantity adjustment applied to the statistical baseline during the S&OP consensus process. Positive values indicate upward revision; negative values indicate downward revision. Captures commercial intelligence not reflected in historical data.. Valid values are `^-?[0-9]+(.[0-9]{1,4})?$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or demand origin location. Supports regional demand aggregation, cross-border supply planning, and regulatory compliance reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the demand forecast record was first created in the source system or ingested into the lakehouse silver layer. Supports data lineage, audit trail, and SCD (Slowly Changing Dimension) processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for any monetary values associated with the forecast (e.g., forecasted spend, standard cost valuation). Supports multi-currency reporting in global operations.. Valid values are `^[A-Z]{3}$`',
    `demand_category` STRING COMMENT 'Classification of the demand type: independent (end-customer driven), dependent (derived from parent BOM), spare parts (aftermarket service), promotional (campaign-driven), new product introduction, or phase-out. Drives appropriate forecasting methodology selection.. Valid values are `independent|dependent|spare_parts|service|promotional|new_product|phase_out`',
    `forecast_algorithm` STRING COMMENT 'Statistical or algorithmic method used to generate the baseline forecast. Supports model governance, accuracy benchmarking, and algorithm selection optimization within the S&OP process.. Valid values are `exponential_smoothing|moving_average|holt_winters|arima|causal|machine_learning|manual`',
    `forecast_bias` DECIMAL(18,2) COMMENT 'Systematic directional error in the forecast, calculated as the average of (forecast minus actual) over the evaluation period. Positive bias indicates consistent over-forecasting; negative bias indicates under-forecasting. Used to detect and correct systemic forecast errors.. Valid values are `^-?[0-9]+(.[0-9]{1,4})?$`',
    `forecast_end_date` DATE COMMENT 'End date of the forecast time bucket. Together with forecast_start_date, defines the discrete planning period for which the forecasted quantity applies.. Valid values are `^d{4}-d{2}-d{2}$`',
    `forecast_number` STRING COMMENT 'Business-facing alphanumeric identifier for the forecast record, used in S&OP meetings, planning reports, and cross-functional communications. Typically sourced from SAP MRP or APO planning run identifiers.. Valid values are `^FC-[0-9]{4}-[0-9]{6}$`',
    `forecast_period_type` STRING COMMENT 'Granularity of the forecast time bucket: weekly (for near-term operational planning), monthly (for mid-term S&OP), or quarterly (for strategic capacity planning and supplier reservation).. Valid values are `weekly|monthly|quarterly`',
    `forecast_start_date` DATE COMMENT 'Start date of the forecast time bucket (week, month, or quarter). Combined with forecast_end_date, defines the planning horizon window for this forecast record.. Valid values are `^d{4}-d{2}-d{2}$`',
    `forecasted_quantity` DECIMAL(18,2) COMMENT 'Final consensus demand quantity for the forecast period after all adjustments. This is the primary demand signal consumed by MRP planning runs to generate planned orders and purchase requisitions.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `forecasted_spend_amount` DECIMAL(18,2) COMMENT 'Estimated procurement spend for the forecasted quantity, calculated using the standard or moving average price. Used for budget planning, spend analytics, and supplier capacity reservation negotiations.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `is_mrp_relevant` BOOLEAN COMMENT 'Indicates whether this forecast record is active and eligible to be consumed as a demand signal in the next MRP planning run. False records are excluded from MRP net requirements calculation.. Valid values are `true|false`',
    `is_supplier_shared` BOOLEAN COMMENT 'Indicates whether this forecast has been shared with the supplier for capacity reservation purposes. Supports collaborative planning (CPFR) and supplier capacity commitment tracking.. Valid values are `true|false`',
    `lot_size_procedure` STRING COMMENT 'SAP lot-sizing procedure used when converting forecast demand into planned orders or purchase requisitions: exact (lot-for-lot), fixed quantity, economic order quantity (EOQ), period-based, or min/max. Affects procurement cost and inventory levels.. Valid values are `exact|fixed|economic_order_quantity|period|minimum_maximum`',
    `mape` DECIMAL(18,2) COMMENT 'Mean Absolute Percentage Error measuring forecast accuracy as a percentage deviation between forecasted and actual demand over the trailing evaluation period. Lower values indicate higher forecast accuracy. Key KPI for S&OP performance management.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the demand forecast record, whether from a consensus adjustment, status change, or MRP parameter update. Enables incremental data processing and change detection in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `mrp_area` STRING COMMENT 'SAP MRP area within the plant that further segments planning for sub-plant locations such as storage locations or subcontractor areas. Enables granular supply planning below plant level.',
    `mrp_type` STRING COMMENT 'SAP MRP type assigned to the material, determining the planning logic applied: standard MRP (deterministic), consumption-based, reorder point, forecast-based, or manual. Directly impacts how the forecast drives procurement signals.. Valid values are `MRP|consumption_based|reorder_point|forecast_based|manual`',
    `planning_horizon_months` STRING COMMENT 'Number of months into the future this forecast record covers, measured from the forecast creation date. Determines how far out the demand signal extends for supplier capacity reservation and long-lead procurement.. Valid values are `^[0-9]+$`',
    `plant_code` STRING COMMENT 'SAP plant code representing the manufacturing or distribution facility for which the demand forecast is generated. Drives MRP planning at the plant level.. Valid values are `^[A-Z0-9]{4}$`',
    `procurement_type` STRING COMMENT 'SAP MRP procurement type indicator specifying how the material is sourced: externally purchased, produced in-house, subcontracted, on consignment, or via stock transfer order. Determines which planning elements MRP generates.. Valid values are `external|in_house|subcontracting|consignment|stock_transfer`',
    `product_category_code` STRING COMMENT 'Procurement category or commodity code classifying the forecasted material (e.g., raw materials, electronic components, MRO). Enables category-level demand aggregation for strategic sourcing and spend analytics.',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization responsible for procuring the forecasted material. Links demand signals to sourcing and supplier capacity reservation activities.',
    `reorder_point` DECIMAL(18,2) COMMENT 'Inventory level at which a replenishment order should be triggered, calculated from the forecast demand rate and supplier lead time. Directly fed into SAP MRP reorder point planning.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `safety_stock_quantity` DECIMAL(18,2) COMMENT 'Recommended safety stock level derived from this forecast, accounting for demand variability and supply lead time uncertainty. Used to set reorder points and buffer stock targets in SAP MRP.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `sop_cycle` STRING COMMENT 'The S&OP planning cycle (YYYY-MM) in which this forecast was generated or last reviewed. Links the forecast to the specific monthly S&OP process iteration for governance and audit purposes.. Valid values are `^[0-9]{4}-(0[1-9]|1[0-2])$`',
    `source_system` STRING COMMENT 'Operational system of record from which this forecast record originated (e.g., SAP S/4HANA PP-MRP, SAP APO, manual Excel upload). Supports data lineage tracking and reconciliation in the lakehouse silver layer.. Valid values are `SAP_S4HANA|SAP_APO|EXCEL|MANUAL|EXTERNAL`',
    `statistical_forecast_quantity` DECIMAL(18,2) COMMENT 'System-generated statistical forecast quantity produced by the forecasting algorithm (e.g., exponential smoothing, moving average) before any manual consensus adjustments. Serves as the baseline for S&OP review.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `status` STRING COMMENT 'Current lifecycle status of the demand forecast record. Locked forecasts are consumed by MRP planning runs. Superseded records are replaced by newer versions.. Valid values are `draft|in_review|approved|locked|superseded|cancelled`',
    `supplier_lead_time_days` STRING COMMENT 'Planned replenishment lead time in calendar days from purchase order placement to goods receipt, as used in MRP net requirements calculation. Drives the timing of procurement signals relative to the forecast period.. Valid values are `^[0-9]+$`',
    `unit_of_measure` STRING COMMENT 'Base unit of measure for the forecasted quantity as defined in the SAP material master (e.g., EA for each, KG for kilogram, PC for piece). Ensures consistent quantity interpretation across planning systems.. Valid values are `EA|KG|LB|M|M2|M3|L|PC|SET|BOX|PAL`',
    `version_number` STRING COMMENT 'Sequential version number of the forecast for a given material, plant, and period combination. Enables tracking of forecast revisions across S&OP cycles and consensus planning rounds.. Valid values are `^[0-9]+$`',
    `version_type` STRING COMMENT 'Classifies the nature of the forecast version: baseline (initial statistical run), statistical (algorithm-generated), consensus (cross-functional agreed), final (locked for MRP input), adjusted (manually overridden), or simulation (what-if scenario).. Valid values are `baseline|statistical|consensus|final|adjusted|simulation`',
    `xyz_classification` STRING COMMENT 'XYZ demand variability classification: X (stable/predictable demand), Y (variable demand), Z (irregular/sporadic demand). Combined with ABC classification to determine optimal forecasting strategy and safety stock levels.. Valid values are `X|Y|Z`',
    CONSTRAINT pk_demand_forecast PRIMARY KEY(`demand_forecast_id`)
) COMMENT 'Forward-looking demand signals used to drive supply planning and MRP inputs. Captures forecast version, material, plant, forecast period (weekly/monthly), forecasted quantity, statistical forecast baseline, consensus forecast adjustments, and forecast accuracy metrics (MAPE, bias). Supports S&OP (Sales and Operations Planning), safety stock optimization, and supplier capacity reservation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` (
    `procurement_supply_agreement_id` BIGINT COMMENT 'Unique system-generated identifier for the supply agreement record in the procurement data platform. Serves as the primary key for all downstream joins and references.',
    `incoterm_id` BIGINT COMMENT 'Foreign key linking to procurement.incoterm. Business justification: Supply agreements specify incoterms governing risk and cost transfer for deliveries under the agreement. Linking to the incoterm reference table ensures standardized trade term validation. incoterms_c',
    `procurement_payment_term_id` BIGINT COMMENT 'Foreign key linking to procurement.payment_term. Business justification: Supply agreements specify payment terms governing supplier payment. Linking to the payment_term reference table ensures standardized payment term validation and enables cash flow forecasting. payment_',
    `procurement_sourcing_event_id` BIGINT COMMENT 'Foreign key linking to procurement.sourcing_event. Business justification: Supply agreements result from strategic sourcing events. The table has sourcing_event_reference. Adding sourcing_event_id FK enables end-to-end sourcing-to-agreement traceability and savings realizati',
    `procurement_spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.spend_category. Business justification: Supply agreements are negotiated for specific spend categories. The table stores category_code and category_name. Adding spend_category_id FK normalizes this relationship; category_name is redundant o',
    `procurement_supplier_id` BIGINT COMMENT 'FK to procurement.supplier',
    `agreement_number` STRING COMMENT 'Business-facing document number assigned to the supply agreement, corresponding to the SAP MM Outline Agreement document number (e.g., scheduling agreement or contract number). Used for cross-system reference and supplier communication.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `agreement_type` STRING COMMENT 'Classification of the supply agreement by its commercial and operational structure. Scheduling agreements govern delivery schedules; blanket orders allow multiple releases up to a committed value; framework contracts define terms for future individual orders; master supply agreements set overarching terms across multiple categories.. Valid values are `scheduling_agreement|blanket_order|framework_contract|master_supply_agreement|call_off_contract`',
    `approval_status` STRING COMMENT 'Current status of the internal approval workflow for this supply agreement. Tracks progression through the procurement authorization hierarchy before the agreement becomes active and releases are permitted.. Valid values are `not_submitted|pending|approved|rejected|revision_required`',
    `approved_by` STRING COMMENT 'Name or user ID of the procurement authority who granted final approval for this supply agreement. Required for audit trail and segregation of duties compliance.',
    `approved_date` DATE COMMENT 'Date on which the supply agreement received final internal approval and was authorized for release. Used for procurement cycle time analysis and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `ariba_contract_reference` STRING COMMENT 'Unique contract identifier assigned by SAP Ariba Contract Management for this supply agreement. Enables cross-system reconciliation between the Ariba contract repository and SAP MM Outline Agreement.. Valid values are `^[A-Z0-9-]{3,50}$`',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether this supply agreement automatically renews upon expiry unless formally terminated by either party within the notice period. Drives contract lifecycle management alerts and renewal workflows.. Valid values are `true|false`',
    `category_code` STRING COMMENT 'Procurement commodity or spend category code (e.g., UNSPSC or internal taxonomy) classifying the goods or services covered by this supply agreement. Enables spend analytics, category management, and strategic sourcing alignment.. Valid values are `^[A-Z0-9-.]{2,20}$`',
    `country_of_supply` STRING COMMENT 'ISO 3166-1 alpha-3 country code identifying the primary country from which goods or services are supplied under this agreement. Used for supply chain risk assessment, import/export compliance, and REACH/RoHS regulatory tracking.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the supply agreement record was first created in the procurement system. Used for data lineage, audit trail, and SLA compliance tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which all monetary values within this supply agreement are denominated (e.g., USD, EUR, GBP). Supports multi-currency procurement operations across global manufacturing sites.. Valid values are `^[A-Z]{3}$`',
    `effective_end_date` DATE COMMENT 'Date on which the supply agreement expires and no further releases are permitted without renewal. Corresponds to the validity end date in SAP MM Outline Agreement. Used for contract renewal alerts and compliance monitoring.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_start_date` DATE COMMENT 'Date from which the supply agreement becomes legally effective and purchase order releases are permitted. Corresponds to the validity start date in SAP MM Outline Agreement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the delivery obligations, risk transfer point, and cost responsibilities between buyer and supplier under this supply agreement.. Valid values are `^(EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF)$`',
    `incoterms_location` STRING COMMENT 'Named place or port associated with the Incoterms code, specifying the exact location where risk and cost transfer between supplier and buyer (e.g., Port of Hamburg for FOB, Buyer Warehouse, Detroit for DDP).',
    `minimum_call_off_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity that must be ordered per release or call-off against this supply agreement, as contractually agreed with the supplier. Violations may trigger penalty clauses or supplier non-compliance flags.. Valid values are `^d+(.d{1,3})?$`',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the supply agreement record. Used for change detection, data synchronization, and audit trail maintenance in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `payment_terms_code` STRING COMMENT 'SAP payment terms key defining the payment conditions negotiated under this supply agreement (e.g., net 30, 2/10 net 30, immediate payment). Drives accounts payable processing and cash flow planning.. Valid values are `^[A-Z0-9]{2,10}$`',
    `penalty_clause_description` STRING COMMENT 'Textual description of the penalty terms applicable under this supply agreement, including trigger conditions, penalty calculation method, and maximum liability caps. Populated when penalty_clause_flag is true.',
    `penalty_clause_flag` BOOLEAN COMMENT 'Indicates whether this supply agreement contains contractual penalty clauses for supplier non-performance, late delivery, quality failures, or minimum volume shortfalls. When true, penalty terms are documented in the agreement.. Valid values are `true|false`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility that is the primary recipient of goods or services under this supply agreement. Relevant for scheduling agreements tied to specific production sites.. Valid values are `^[A-Z0-9]{2,10}$`',
    `pricing_condition_type` STRING COMMENT 'Type of pricing mechanism agreed with the supplier. Fixed price locks unit cost for the agreement duration; tiered volume pricing adjusts price based on quantity thresholds; index-linked pricing ties price to a commodity index; cost-plus adds a margin to supplier cost.. Valid values are `fixed_price|tiered_volume|index_linked|cost_plus|time_and_material|frame_rate`',
    `procurement_type` STRING COMMENT 'Classification of the procurement scope as direct materials (used in production), indirect materials (operational supplies), MRO (Maintenance Repair and Operations), services, or capital expenditure. Drives accounting treatment, approval workflows, and spend reporting.. Valid values are `direct|indirect|mro|services|capital`',
    `purchasing_group_code` STRING COMMENT 'SAP purchasing group code identifying the buyer or buyer team responsible for day-to-day management of this supply agreement, including release creation and supplier communication.. Valid values are `^[A-Z0-9]{2,10}$`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for negotiating and managing this supply agreement. Determines the organizational unit with procurement authority and defines the scope of the agreement within the enterprise hierarchy.. Valid values are `^[A-Z0-9]{2,10}$`',
    `released_quantity` DECIMAL(18,2) COMMENT 'Cumulative quantity of goods or services released against this supply agreement through purchase order releases or delivery schedule lines. Used to track agreement consumption against committed volume.. Valid values are `^d+(.d{1,3})?$`',
    `released_value` DECIMAL(18,2) COMMENT 'Cumulative monetary value of all purchase order releases issued against this supply agreement to date. Compared against total_committed_value to monitor agreement utilization and remaining open commitment.. Valid values are `^d+(.d{1,2})?$`',
    `renewal_notice_days` STRING COMMENT 'Number of calendar days prior to agreement expiry by which either party must provide written notice of intent not to renew. Used to trigger contract renewal review workflows and supplier negotiation planning.. Valid values are `^d{1,4}$`',
    `sap_outline_agreement_number` STRING COMMENT 'SAP MM document number for the Outline Agreement (scheduling agreement or contract) created via transaction ME31L or ME31K. Primary cross-reference key for integration with SAP S/4HANA procurement and finance modules.. Valid values are `^[0-9]{10}$`',
    `sourcing_event_reference` STRING COMMENT 'Reference number of the SAP Ariba sourcing event (RFQ/RFP/auction) that resulted in the award of this supply agreement. Provides traceability from competitive sourcing to contracted agreement for audit and compliance purposes.. Valid values are `^[A-Z0-9-]{3,30}$`',
    `status` STRING COMMENT 'Current lifecycle status of the supply agreement. Drives procurement workflow, release authorization, and reporting. Active agreements permit purchase order releases; suspended agreements are temporarily blocked; terminated agreements are closed before natural expiry.. Valid values are `draft|pending_approval|active|suspended|expired|terminated|closed`',
    `supplier_code` STRING COMMENT 'Unique vendor/supplier identifier as maintained in the SAP MM vendor master. Links the supply agreement to the qualified supplier record for spend analytics, performance tracking, and compliance reporting.. Valid values are `^[A-Z0-9-]{3,20}$`',
    `termination_date` DATE COMMENT 'Actual date on which the supply agreement was terminated prior to its natural expiry, if applicable. Populated only for agreements with status terminated. Used for supplier relationship analysis and spend impact assessment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `termination_reason` STRING COMMENT 'Reason code for early termination of the supply agreement. Supports supplier performance analysis, sourcing strategy reviews, and risk management reporting.. Valid values are `supplier_default|mutual_agreement|strategic_sourcing_change|regulatory_non_compliance|financial_insolvency|force_majeure|other`',
    `title` STRING COMMENT 'Short descriptive title of the supply agreement used for identification in procurement systems, dashboards, and supplier communications. Typically includes supplier name, commodity category, and agreement year.',
    `total_committed_quantity` DECIMAL(18,2) COMMENT 'Total volume of goods or services committed under this supply agreement over its validity period, expressed in the agreement unit of measure. Applicable primarily to scheduling agreements and volume-based contracts.. Valid values are `^d+(.d{1,3})?$`',
    `total_committed_value` DECIMAL(18,2) COMMENT 'Total monetary value committed under this supply agreement over its validity period, as negotiated with the supplier. For blanket orders, this is the maximum release value. For scheduling agreements, this is the total planned spend. Used for spend commitment reporting and budget planning.. Valid values are `^d+(.d{1,2})?$`',
    `unit_of_measure` STRING COMMENT 'Standard unit of measure for quantity-based terms in this supply agreement (e.g., EA for each, KG for kilogram, M for meter, L for liter). Aligns with SAP base unit of measure and ISO 80000 standards.. Valid values are `^[A-Z]{1,6}$`',
    `unit_price` DECIMAL(18,2) COMMENT 'Negotiated unit price for the primary material or service covered by this supply agreement, expressed in the agreement currency. For tiered or index-linked agreements, this represents the base or reference price.. Valid values are `^d+(.d{1,4})?$`',
    CONSTRAINT pk_procurement_supply_agreement PRIMARY KEY(`procurement_supply_agreement_id`)
) COMMENT 'Long-term supply agreements and blanket purchase agreements negotiated with strategic suppliers. Captures agreement type (scheduling agreement, blanket order, framework contract), validity period, total committed volume, pricing conditions, release schedule, minimum call-off quantities, and penalty clauses. Aligned with SAP MM Outline Agreement (ME31L/ME31K). Distinct from individual POs which are releases against agreements.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` (
    `delivery_schedule_id` BIGINT COMMENT 'Unique system-generated identifier for each delivery schedule line released against a supply agreement or blanket Purchase Order (PO). Serves as the primary key for the delivery_schedule data product.',
    `incoterm_id` BIGINT COMMENT 'Foreign key linking to procurement.incoterm. Business justification: Delivery schedules specify incoterms governing risk transfer for each scheduled delivery. Linking to the incoterm reference table ensures standardized trade term validation. incoterms_code is retained',
    `line_id` BIGINT COMMENT 'Foreign key linking to production.production_line. Business justification: JIT and line-side delivery schedules specify exact production line for material delivery. Logistics coordinates supplier deliveries directly to specific lines to minimize handling and support lean man',
    `procurement_goods_receipt_id` BIGINT COMMENT 'Foreign key linking to procurement.goods_receipt. Business justification: Delivery schedule lines are fulfilled by goods receipts. The table has grn_number. Adding goods_receipt_id FK enables schedule adherence tracking and on-time delivery measurement. grn_number is retain',
    `procurement_po_line_item_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_po_line_item. Business justification: Delivery schedules can be released against specific PO line items in addition to supply agreements. In JIT and scheduling agreement scenarios, delivery schedules reference both the blanket agreement (',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Delivery schedules are associated with specific supplier organizations. The table stores supplier_code and supplier_name. Adding supplier_id FK normalizes this relationship; supplier_name is redundant',
    `procurement_supply_agreement_id` BIGINT COMMENT 'Foreign key linking to procurement.supply_agreement. Business justification: Delivery schedules are released against supply agreements (scheduling agreements in SAP). This is a fundamental parent-child relationship in the scheduling agreement lifecycle. agreement_number is ret',
    `actual_delivery_date` DATE COMMENT 'Calendar date on which the supplier actually delivered the material and the Goods Receipt Note (GRN) was posted. Compared against scheduled_delivery_date to calculate on-time delivery performance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `agreement_number` STRING COMMENT 'Reference number of the parent supply agreement or blanket Purchase Order (PO) against which this delivery schedule line is released. Links the schedule to its governing contractual instrument.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `confirmed_quantity` DECIMAL(18,2) COMMENT 'Quantity confirmed by the supplier as committed for delivery on the scheduled date. May differ from scheduled quantity due to supplier capacity constraints or partial confirmations.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the delivery schedule line was first created in the source system, recorded in ISO 8601 format with timezone offset. Supports audit trail and data lineage requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `cumulative_delivered_quantity` DECIMAL(18,2) COMMENT 'Running cumulative total of all quantities actually received against this scheduling agreement line from the start of the agreement period. Enables cumulative quantity reconciliation and supplier delivery performance analysis.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `cumulative_scheduled_quantity` DECIMAL(18,2) COMMENT 'Running cumulative total of all scheduled quantities from the beginning of the scheduling agreement period to the current schedule line. Used in automotive and lean manufacturing for cumulative quantity reconciliation with suppliers.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the unit price and schedule value (e.g., USD, EUR, GBP, JPY). Supports multi-currency procurement operations across global manufacturing sites.. Valid values are `^[A-Z]{3}$`',
    `days_early_late` STRING COMMENT 'Number of calendar days the actual delivery was early (negative value) or late (positive value) relative to the scheduled delivery date. Key metric for supplier delivery performance scorecards.. Valid values are `^-?[0-9]{1,4}$`',
    `delivered_quantity` DECIMAL(18,2) COMMENT 'Quantity actually received and posted via Goods Receipt Note (GRN) processing against this schedule line. Used to calculate delivery completeness and schedule adherence.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `delivery_address_line1` STRING COMMENT 'Primary street address line of the delivery destination, used for logistics coordination and carrier routing.',
    `delivery_city` STRING COMMENT 'City of the delivery destination address, used for logistics planning and transportation management.',
    `delivery_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code of the delivery destination, supporting multinational logistics, customs compliance, and cross-border trade documentation.. Valid values are `^[A-Z]{3}$`',
    `delivery_note_number` STRING COMMENT 'Supplier-provided delivery note or packing slip number accompanying the physical shipment. Used for three-way matching (PO, GRN, invoice) and discrepancy resolution.. Valid values are `^[A-Z0-9-]{1,35}$`',
    `grn_number` STRING COMMENT 'Reference number of the Goods Receipt Note (GRN) document posted in SAP S/4HANA upon physical receipt of the delivery. Links the schedule line to the inventory posting and financial accrual.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the transfer of risk, cost responsibility, and delivery obligations between buyer and supplier for this schedule line.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `is_on_time` BOOLEAN COMMENT 'Boolean flag indicating whether the actual delivery date fell within the scheduled delivery window (true) or was late/early (false). Populated upon GRN posting and used for supplier on-time delivery (OTD) performance KPI reporting.. Valid values are `true|false`',
    `jit_delivery_window_end` TIMESTAMP COMMENT 'Latest acceptable timestamp for supplier delivery under JIT (Just-In-Time) replenishment rules. Deliveries after this timestamp are considered late and trigger schedule adherence exceptions.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `jit_delivery_window_start` TIMESTAMP COMMENT 'Earliest acceptable timestamp for supplier delivery under JIT (Just-In-Time) replenishment rules. Deliveries before this timestamp are considered early and may be rejected or incur storage costs.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `kanban_signal_number` STRING COMMENT 'Unique identifier of the Kanban replenishment signal that triggered this delivery schedule line. Applicable for Kanban-managed materials where pull signals drive supplier delivery requests.. Valid values are `^[A-Z0-9-]{1,30}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the delivery schedule line in the source system. Used for incremental data loading, change detection, and audit trail maintenance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `line_number` STRING COMMENT 'Sequential line item number within the delivery schedule document, distinguishing individual delivery date/quantity combinations within the same schedule release.. Valid values are `^[0-9]{1,5}$`',
    `material_description` STRING COMMENT 'Short description of the material or component to be delivered, providing human-readable context for the material number in reports and supplier communications.',
    `material_number` STRING COMMENT 'SAP material number or internal part number identifying the specific raw material, component, or indirect material to be delivered. Used for MRP (Material Requirements Planning) reconciliation and inventory management.. Valid values are `^[A-Z0-9-.]{1,40}$`',
    `mrp_element_type` STRING COMMENT 'Type of MRP (Material Requirements Planning) planning element that generated or is associated with this delivery schedule line, indicating whether it originated from a planned order, purchase requisition, or scheduling agreement release.. Valid values are `planned_order|purchase_requisition|scheduling_agreement|purchase_order|stock_transfer`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or distribution center that is the destination for the scheduled delivery. Drives MRP planning and inventory posting.. Valid values are `^[A-Z0-9]{4}$`',
    `purchasing_group_code` STRING COMMENT 'SAP purchasing group (buyer group) code identifying the individual buyer or team responsible for managing this delivery schedule and supplier relationship.. Valid values are `^[A-Z0-9]{3}$`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for managing the supply agreement and releasing delivery schedules. Represents the organizational unit with procurement authority.. Valid values are `^[A-Z0-9]{4}$`',
    `release_type` STRING COMMENT 'Indicates whether this schedule line is a forecast release (planning horizon, non-binding), a JIT (Just-In-Time) release (firm, short-term), an immediate release, or a manually created release.. Valid values are `forecast|jit|immediate|manual`',
    `sap_scheduling_agreement_number` STRING COMMENT 'SAP S/4HANA internal 10-digit document number for the scheduling agreement (Outline Agreement) from which this delivery schedule line was released. Enables direct traceability to the source system record.. Valid values are `^[0-9]{10}$`',
    `schedule_adherence_status` STRING COMMENT 'Categorical assessment of supplier delivery adherence for this schedule line: on_time (within window), early (before JIT window start), late (after scheduled date), partial (quantity shortfall), missed (no delivery), or pending (not yet due).. Valid values are `on_time|early|late|partial|missed|pending`',
    `schedule_number` STRING COMMENT 'Business-facing alphanumeric identifier for the delivery schedule document, used for cross-system reference and supplier communication. Corresponds to the scheduling agreement release number in SAP S/4HANA MM.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `schedule_type` STRING COMMENT 'Classification of the delivery schedule indicating the replenishment strategy: JIT (Just-In-Time) for time-critical lean deliveries, forecast for planning horizon releases, firm for committed quantities, or Kanban for pull-based replenishment signals.. Valid values are `jit|forecast|firm|kanban|blanket_release|spot`',
    `scheduled_delivery_date` DATE COMMENT 'Planned calendar date on which the supplier is required to deliver the material to the specified plant or delivery location. Core field for JIT delivery window management and supplier on-time delivery (OTD) performance tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `scheduled_delivery_time` STRING COMMENT 'Specific time of day (HH:MM, 24-hour format) within the scheduled delivery date by which the supplier must deliver, supporting JIT (Just-In-Time) delivery window precision and dock scheduling.. Valid values are `^([01]d|2[0-3]):[0-5]d$`',
    `scheduled_quantity` DECIMAL(18,2) COMMENT 'Quantity of material scheduled for delivery on the specified date, expressed in the base unit of measure. Drives MRP (Material Requirements Planning) supply coverage calculations and Kanban replenishment signal sizing.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `sku_code` STRING COMMENT 'Stock Keeping Unit (SKU) code used for warehouse and inventory tracking of the scheduled material, aligning with Infor WMS inventory records.. Valid values are `^[A-Z0-9-.]{1,50}$`',
    `status` STRING COMMENT 'Current lifecycle status of the delivery schedule line, tracking progression from initial release through supplier confirmation, shipment, receipt, and closure. Supports schedule adherence monitoring and exception management.. Valid values are `draft|released|confirmed|in_transit|partially_delivered|delivered|cancelled|overdue|closed`',
    `storage_location_code` STRING COMMENT 'SAP storage location within the receiving plant where the delivered material will be physically stored upon Goods Receipt Note (GRN) processing.. Valid values are `^[A-Z0-9]{4}$`',
    `supplier_code` STRING COMMENT 'Unique identifier for the supplier responsible for fulfilling the delivery schedule. Corresponds to the vendor number in SAP S/4HANA and the supplier record in SAP Ariba.. Valid values are `^[A-Z0-9-]{3,20}$`',
    `tolerance_over_percent` DECIMAL(18,2) COMMENT 'Maximum percentage by which the supplier may over-deliver against the scheduled quantity without triggering a rejection or return. Defined in the supply agreement and enforced during GRN processing.. Valid values are `^[0-9]{1,3}(.[0-9]{1,2})?$`',
    `tolerance_under_percent` DECIMAL(18,2) COMMENT 'Maximum percentage by which the supplier may under-deliver against the scheduled quantity and still have the delivery accepted as complete. Defined in the supply agreement.. Valid values are `^[0-9]{1,3}(.[0-9]{1,2})?$`',
    `unit_of_measure` STRING COMMENT 'Base unit of measure for the scheduled, confirmed, and delivered quantities (e.g., EA for each, KG for kilogram, M for meter, L for liter, PC for piece). Aligns with SAP material master UoM configuration.. Valid values are `^[A-Z]{2,5}$`',
    `unit_price` DECIMAL(18,2) COMMENT 'Agreed price per unit of measure for the material as specified in the supply agreement or blanket PO. Used for financial accruals, goods receipt valuation, and spend analytics.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    CONSTRAINT pk_delivery_schedule PRIMARY KEY(`delivery_schedule_id`)
) COMMENT 'Scheduled delivery lines released against a supply agreement or blanket PO specifying exact delivery dates, quantities, and delivery locations. Captures JIT (Just-In-Time) delivery windows, Kanban replenishment signals, cumulative quantities, and schedule adherence tracking. Supports lean manufacturing replenishment and supplier delivery performance monitoring.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` (
    `procurement_supplier_performance_id` BIGINT COMMENT 'Unique surrogate identifier for each supplier performance scorecard record in the Databricks Silver Layer.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Supplier scorecards require tracking which procurement or quality employee performed the evaluation for accountability, bias detection, and ensuring qualified personnel assess supplier performance.',
    `procurement_spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_spend_category. Business justification: Supplier performance scorecard references spend category via category_code (STRING). Adding FK for referential integrity, removing redundant string field.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Supplier performance scorecards are evaluated for specific supplier organizations. The table currently stores supplier_code and supplier_name as denormalized strings. Adding supplier_id FK normalizes ',
    `procurement_supplier_qualification_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supplier_qualification. Business justification: Supplier performance tracking should reference the active qualification record. Performance metrics (OTD, PPM, fill rate) are evaluated against qualification standards. The requalification_required_fl',
    `acknowledgment_date` DATE COMMENT 'Date on which the supplier formally acknowledged the performance scorecard in the SAP Ariba supplier portal.. Valid values are `^d{4}-d{2}-d{2}$`',
    `ariba_scorecard_reference` STRING COMMENT 'Native scorecard identifier from SAP Ariba Supplier Performance Management, used for cross-system traceability and reconciliation between the Silver Layer and the source system.',
    `capa_open_count` STRING COMMENT 'Number of open Corrective and Preventive Actions (CAPAs) outstanding against the supplier at the time of scorecard generation, indicating unresolved quality or delivery issues.',
    `category_name` STRING COMMENT 'Human-readable name of the commodity or spend category associated with this performance scorecard.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the supplier site being evaluated, supporting regional performance analysis and supply risk management.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the supplier performance scorecard record was first created in the source system or ingested into the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the spend amount reported in this scorecard record.. Valid values are `^[A-Z]{3}$`',
    `evaluation_period_end_date` DATE COMMENT 'Last calendar date of the performance measurement window covered by this scorecard record.. Valid values are `^d{4}-d{2}-d{2}$`',
    `evaluation_period_start_date` DATE COMMENT 'First calendar date of the performance measurement window covered by this scorecard record.. Valid values are `^d{4}-d{2}-d{2}$`',
    `evaluation_period_type` STRING COMMENT 'Frequency classification of the scorecard evaluation cycle — monthly, quarterly, semi-annual, or annual — used to align performance reviews with strategic supplier relationship management cadences.. Valid values are `monthly|quarterly|semi_annual|annual`',
    `fill_rate` DECIMAL(18,2) COMMENT 'Percentage of ordered quantity fulfilled by the supplier in a single shipment without backorders or partial deliveries during the evaluation period. Measures supply availability and order completeness.. Valid values are `^(100(.00)?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `fill_rate_target` DECIMAL(18,2) COMMENT 'Contractual or internally agreed minimum acceptable fill rate percentage for the supplier.. Valid values are `^(100(.00)?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `improvement_plan_required_flag` BOOLEAN COMMENT 'Indicates whether a formal Supplier Improvement Plan (SIP) has been mandated as a result of this scorecard evaluation, typically triggered when performance falls below defined thresholds.. Valid values are `true|false`',
    `invoice_accuracy_rate` DECIMAL(18,2) COMMENT 'Percentage of supplier invoices that matched the corresponding purchase order and goods receipt without discrepancies during the evaluation period. Supports three-way match compliance and accounts payable efficiency.. Valid values are `^(100(.00)?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the supplier performance scorecard record, used for change tracking and incremental data pipeline processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `late_delivery_count` STRING COMMENT 'Number of deliveries received after the confirmed delivery date during the evaluation period, used to compute OTD rate and identify delivery reliability issues.',
    `ncr_count` STRING COMMENT 'Number of Non-Conformance Reports (NCRs) raised against the supplier during the evaluation period, reflecting the frequency of quality escapes and non-conforming material events.',
    `on_time_delivery_rate` DECIMAL(18,2) COMMENT 'Percentage of purchase order line items delivered on or before the confirmed delivery date during the evaluation period. Core KPI for OTD (On-Time Delivery) performance measurement. Calculated as (on-time deliveries / total deliveries) × 100.. Valid values are `^(100(.00)?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `on_time_delivery_target` DECIMAL(18,2) COMMENT 'Contractual or internally agreed target percentage for on-time delivery against which the suppliers actual OTD rate is benchmarked.. Valid values are `^(100(.00)?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `overall_rating` DECIMAL(18,2) COMMENT 'Composite weighted performance score (0–100 scale) aggregating OTD, quality PPM, fill rate, invoice accuracy, and responsiveness dimensions. Used for preferred supplier list maintenance and re-qualification decisions.. Valid values are `^(100(.00)?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `performance_tier` STRING COMMENT 'Categorical performance classification assigned based on the overall rating, used to drive preferred supplier list (PSL) decisions, sourcing strategy, and re-qualification triggers.. Valid values are `preferred|approved|conditional|probation|disqualified`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or receiving facility whose procurement transactions are included in this performance evaluation.',
    `preferred_supplier_flag` BOOLEAN COMMENT 'Indicates whether the supplier holds preferred supplier status on the Preferred Supplier List (PSL) as of the scorecard evaluation period, used to guide sourcing decisions.. Valid values are `true|false`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for managing the supplier relationship and issuing the performance scorecard.',
    `quality_ppm` DECIMAL(18,2) COMMENT 'Number of defective parts received per one million parts delivered during the evaluation period. Industry-standard PPM (Parts Per Million) metric for incoming quality performance measurement.',
    `quality_ppm_target` DECIMAL(18,2) COMMENT 'Contractual or internally agreed maximum acceptable PPM defect rate for the supplier, used as the benchmark threshold for quality performance evaluation.',
    `rejected_quantity` DECIMAL(18,2) COMMENT 'Total quantity of parts or materials rejected during incoming quality inspection (IQC) in the evaluation period, used as the numerator for PPM defect rate calculation.',
    `requalification_required_flag` BOOLEAN COMMENT 'Indicates whether the suppliers performance results have triggered a mandatory re-qualification review based on defined performance thresholds or tier demotion.. Valid values are `true|false`',
    `responsiveness_score` DECIMAL(18,2) COMMENT 'Scored rating (0–10 scale) reflecting the suppliers speed and quality of response to inquiries, change requests, non-conformance reports (NCRs), and corrective action requests during the evaluation period.. Valid values are `^(10(.00)?|[0-9](.d{1,2})?)$`',
    `scorecard_date` DATE COMMENT 'Date on which the performance scorecard was formally issued or published to the supplier and internal stakeholders.. Valid values are `^d{4}-d{2}-d{2}$`',
    `scorecard_number` STRING COMMENT 'Business-facing unique reference number for the supplier performance scorecard record, used for cross-system traceability and communication with suppliers.. Valid values are `^SP-[0-9]{4}-[0-9]{6}$`',
    `scorecard_type` STRING COMMENT 'Classification of the scorecard purpose — standard periodic review, strategic supplier deep-dive, corrective action follow-up, re-qualification assessment, or ad-hoc evaluation.. Valid values are `standard|strategic|corrective_action|re_qualification|ad_hoc`',
    `spend_amount` DECIMAL(18,2) COMMENT 'Total procurement spend with the supplier during the evaluation period in the transaction currency, used for spend analytics, category management, and strategic supplier segmentation.',
    `status` STRING COMMENT 'Current lifecycle status of the supplier performance scorecard, from initial draft through supplier acknowledgment or dispute resolution to closure.. Valid values are `draft|pending_review|published|acknowledged|disputed|closed`',
    `supplier_acknowledged_flag` BOOLEAN COMMENT 'Indicates whether the supplier has formally acknowledged receipt and acceptance of the performance scorecard through the SAP Ariba supplier portal.. Valid values are `true|false`',
    `total_delivery_count` STRING COMMENT 'Total number of inbound deliveries or goods receipt events from the supplier during the evaluation period, used as the denominator for OTD and fill rate calculations.',
    `total_po_count` STRING COMMENT 'Total number of purchase orders issued to the supplier during the evaluation period, providing the transaction volume basis for performance rate calculations.',
    `total_received_quantity` DECIMAL(18,2) COMMENT 'Total quantity of parts or materials received from the supplier during the evaluation period, used as the denominator for PPM defect rate and fill rate calculations.',
    CONSTRAINT pk_procurement_supplier_performance PRIMARY KEY(`procurement_supplier_performance_id`)
) COMMENT 'Periodic supplier performance scorecard capturing KPIs across quality (PPM defect rate, NCR count, CAPA closure rate), delivery (on-time delivery rate, schedule adherence), commercial (invoice accuracy, pricing compliance), and responsiveness dimensions. Supports supplier segmentation (strategic, preferred, approved, conditional), development programs, and disqualification triggers. Aligned with SAP Ariba Supplier Performance Management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supply_risk` (
    `supply_risk_id` BIGINT COMMENT 'Unique system-generated identifier for each supply chain risk record within the procurement domain.',
    `procurement_material_info_record_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_material_info_record. Business justification: Supply risks are often tied to specific material-supplier combinations tracked in purchasing info records. The affected_material_number and affected_material_description can be retrieved via JOIN to m',
    `procurement_spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.spend_category. Business justification: Supply risks are associated with specific material groups/spend categories. The table has affected_material_group which maps to spend categories. Adding spend_category_id FK enables risk analysis by s',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Supply risks are associated with specific suppliers in the supply network. The table stores affected_supplier_code and affected_supplier_name. Adding supplier_id FK normalizes this relationship; affec',
    `actual_resolution_date` DATE COMMENT 'Actual date on which the supply risk was resolved, closed, or formally accepted, enabling cycle time analysis and mitigation effectiveness measurement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `affected_material_group` STRING COMMENT 'SAP material group or commodity category code classifying the type of material affected, enabling category-level risk aggregation and spend analytics.',
    `affected_supplier_code` STRING COMMENT 'Vendor/supplier identifier from SAP S/4HANA or SAP Ariba identifying the primary supplier associated with this supply risk. Enables supplier-level risk aggregation and performance correlation.',
    `ariba_risk_reference` STRING COMMENT 'External reference identifier from SAP Ariba Supplier Risk module, enabling bidirectional traceability between the lakehouse silver layer and the operational procurement system of record.',
    `assessment_date` DATE COMMENT 'Date on which the formal risk assessment (probability, impact, and scoring) was completed or last updated, supporting assessment currency tracking and review scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `business_impact_description` STRING COMMENT 'Narrative description of the specific business consequences if the risk materializes, including potential production stoppages, delivery delays, quality failures, financial losses, or regulatory penalties.',
    `contingency_plan` STRING COMMENT 'Description of the contingency or business continuity plan to be activated if the supply risk materializes, including alternative sourcing options, emergency procurement procedures, and production adjustment strategies.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the supply risk record was first created in the system, supporting audit trail requirements and data lineage tracking in the Databricks Lakehouse Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the estimated financial impact amount, supporting multi-currency reporting in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Detailed narrative describing the supply chain risk, including context, root cause indicators, and potential consequences for procurement and production continuity.',
    `escalation_date` DATE COMMENT 'Date on which the supply risk was formally escalated to senior management, enabling escalation response time tracking and governance reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `estimated_financial_impact` DECIMAL(18,2) COMMENT 'Estimated monetary value of the business impact if the supply risk materializes, expressed in the designated currency. Supports financial exposure quantification and business continuity planning.',
    `identification_date` DATE COMMENT 'Date on which the supply risk was first identified and formally recorded, establishing the start of the risk lifecycle and enabling aging analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `impact_score` DECIMAL(18,2) COMMENT 'Quantitative score (1.00–10.00) representing the assessed business impact magnitude if the risk materializes, covering financial, operational, quality, and reputational dimensions.. Valid values are `^([1-9]|10)(.d{1,2})?$`',
    `is_escalated` BOOLEAN COMMENT 'Indicates whether this supply risk has been formally escalated to senior management or executive leadership due to its severity, probability, or lack of mitigation progress.. Valid values are `true|false`',
    `is_single_source` BOOLEAN COMMENT 'Indicates whether the affected material or component is sourced exclusively from a single supplier, representing a critical single-source dependency risk that requires priority attention in supply network resilience planning.. Valid values are `true|false`',
    `mitigation_actions` STRING COMMENT 'Detailed description of specific actions being taken or planned to mitigate the supply risk, such as qualifying alternative suppliers, increasing safety stock, dual-sourcing, renegotiating contracts, or engaging logistics alternatives.',
    `mitigation_strategy` STRING COMMENT 'High-level risk response strategy selected for this supply risk: avoid (eliminate the risk source), transfer (shift risk to another party), reduce (implement controls to lower probability/impact), accept (acknowledge and monitor), or contingency (prepare response plan for if risk materializes).. Valid values are `avoid|transfer|reduce|accept|contingency`',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the supply risk record, enabling change detection, incremental processing in the lakehouse pipeline, and audit trail maintenance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `next_review_date` DATE COMMENT 'Scheduled date for the next formal review and reassessment of the supply risk, ensuring risks are periodically re-evaluated as conditions evolve.. Valid values are `^d{4}-d{2}-d{2}$`',
    `origin_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code for the country of origin of the affected supply, used for geopolitical risk assessment, trade compliance, and REACH/RoHS regulatory analysis.. Valid values are `^[A-Z]{3}$`',
    `plant_code` STRING COMMENT 'SAP S/4HANA plant code identifying the manufacturing facility or site most directly impacted by this supply risk, enabling plant-level risk exposure reporting.',
    `probability` STRING COMMENT 'Qualitative assessment of the likelihood that the supply risk will materialize within the defined assessment horizon, used in conjunction with severity to determine overall risk exposure.. Valid values are `very_high|high|medium|low|very_low`',
    `probability_score` DECIMAL(18,2) COMMENT 'Quantitative probability score expressed as a decimal between 0.00 and 1.00, representing the estimated likelihood of the risk event occurring. Enables quantitative risk modeling and portfolio-level risk aggregation.. Valid values are `^(0(.d{1,2})?|1(.0{1,2})?)$`',
    `purchasing_org_code` STRING COMMENT 'SAP S/4HANA purchasing organization code responsible for managing the affected supply relationship, used for organizational risk attribution and escalation routing.',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether this supply risk involves a regulatory compliance dimension, such as REACH, RoHS, CE Marking, OSHA, EPA, or export control violations, triggering mandatory compliance reporting and legal review.. Valid values are `true|false`',
    `risk_category` STRING COMMENT 'Classification of the supply chain risk type, enabling category-level analysis and targeted mitigation strategies. Covers single-source dependency, geopolitical instability, supplier financial distress, capacity constraints, regulatory non-compliance, natural disasters, and other supply disruption categories.. Valid values are `single_source_dependency|geopolitical|financial_distress|capacity_constraint|regulatory_non_compliance|natural_disaster|logistics_disruption|quality_failure|cybersecurity|raw_material_shortage|currency_volatility|labor_dispute|intellectual_property|environmental`',
    `risk_number` STRING COMMENT 'Human-readable business reference number for the supply risk record, used in communications, reports, and cross-functional tracking (e.g., SR-2024-000123).. Valid values are `^SR-[0-9]{4}-[0-9]{6}$`',
    `risk_owner` STRING COMMENT 'Name or employee identifier of the individual accountable for managing and mitigating this supply risk, ensuring clear ownership and accountability in the risk management process.',
    `risk_owner_department` STRING COMMENT 'Organizational department or business unit of the risk owner, supporting departmental risk reporting and escalation path determination.',
    `risk_score` DECIMAL(18,2) COMMENT 'Composite risk score derived from probability and impact assessments, used for risk prioritization, heat map positioning, and portfolio-level supply risk reporting.',
    `risk_subcategory` STRING COMMENT 'More granular classification within the primary risk category, enabling detailed drill-down analysis (e.g., within geopolitical: trade_war, sanctions, export_controls; within financial_distress: bankruptcy, credit_downgrade).',
    `severity` STRING COMMENT 'Assessed severity level of the supply risk, reflecting the magnitude of potential business impact if the risk materializes. Used to prioritize mitigation resources and escalation decisions.. Valid values are `critical|high|medium|low`',
    `status` STRING COMMENT 'Current lifecycle status of the supply risk record, tracking progression from initial identification through assessment, active management, mitigation, and closure.. Valid values are `identified|under_assessment|active|mitigating|escalated|resolved|closed|accepted`',
    `supply_lane` STRING COMMENT 'Identifier or description of the supply lane (origin-destination pair or trade route) affected by this risk, supporting logistics disruption analysis and alternative routing planning.',
    `target_resolution_date` DATE COMMENT 'Target date by which the supply risk is expected to be resolved, mitigated to an acceptable level, or formally accepted, used for tracking mitigation progress and SLA adherence.. Valid values are `^d{4}-d{2}-d{2}$`',
    `title` STRING COMMENT 'Short, descriptive title summarizing the nature of the supply chain risk for quick identification in dashboards and reports.',
    CONSTRAINT pk_supply_risk PRIMARY KEY(`supply_risk_id`)
) COMMENT 'Tracks identified supply chain risks associated with specific suppliers, materials, or supply lanes. Captures risk category (single-source dependency, geopolitical, financial distress, capacity constraint, regulatory non-compliance, natural disaster), risk severity, probability, business impact, mitigation actions, and risk owner. Supports supply network resilience planning and business continuity management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` (
    `procurement_material_info_record_id` BIGINT COMMENT 'Unique surrogate identifier for the purchasing info record in the Databricks Silver Layer. Serves as the primary key for this entity.',
    `compliance_reach_substance_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.reach_substance_declaration. Business justification: Material info records must include REACH substance declarations for EU compliance. Procurement verifies SVHC content before material approval - critical for product compliance and regulatory reporting',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Material info records store procurement data for specific engineered components. Buyers maintain supplier-specific pricing and lead times for each component defined by engineering.',
    `incoterm_id` BIGINT COMMENT 'Foreign key linking to procurement.incoterm. Business justification: Material info record references incoterm via incoterms_code (STRING). Adding FK for referential integrity, removing redundant string field.',
    `inventory_sku_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Material info records store supplier-specific data for SKUs. Links procurement terms (price, lead time) to material master for sourcing.',
    `procurement_payment_term_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_payment_term. Business justification: Material info record references payment term via payment_terms_code (STRING). Adding FK for referential integrity, removing redundant string field.',
    `procurement_supplier_id` BIGINT COMMENT 'FK to procurement.supplier',
    `rohs_compliance_record_id` BIGINT COMMENT 'Foreign key linking to compliance.rohs_compliance_record. Business justification: Materials require RoHS compliance records for electronics manufacturing. Procurement validates restricted substance compliance before material release - mandatory for EU market access and customer req',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the material is manufactured or substantially transformed by this supplier. Required for customs declarations, import duty calculation, and REACH/RoHS compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the purchasing info record was originally created in the source system (SAP). Used for data lineage, audit trail, and master data governance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the unit price and order value are expressed (e.g., USD, EUR, CNY). Supports multi-currency procurement in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `customs_tariff_number` STRING COMMENT 'Harmonized System (HS) tariff classification number for the material as supplied by this vendor. Used for import/export customs declarations, duty rate determination, and trade compliance reporting in multinational procurement.',
    `goods_receipt_required` BOOLEAN COMMENT 'Indicates whether a goods receipt (GRN) must be posted in SAP before invoice verification can proceed for purchase orders created from this info record. Controls the three-way match process (PO-GR-Invoice).. Valid values are `true|false`',
    `info_record_category` STRING COMMENT 'Business classification of the procurement category for this info record. Distinguishes direct materials (used in production BOM), indirect materials (MRO, facilities), services, and capital expenditure items for spend analytics and category management.. Valid values are `direct_material|indirect_material|mro|services|capital`',
    `info_record_number` STRING COMMENT 'SAP-assigned 10-digit purchasing info record number (EINE-INFNR) that uniquely identifies the material-supplier commercial relationship in the source system.. Valid values are `^[0-9]{10}$`',
    `info_record_type` STRING COMMENT 'Category of the purchasing info record defining the procurement scenario. Standard covers normal PO-based procurement; subcontracting covers externally processed materials; pipeline covers continuous supply (e.g., utilities); consignment covers supplier-owned stock held at plant.. Valid values are `standard|subcontracting|pipeline|consignment`',
    `invoice_verification_required` BOOLEAN COMMENT 'Indicates whether invoice-based verification is required for purchase orders created from this info record (EINE-REPOS). When False, evaluated receipt settlement (ERS) may be used for automatic invoice posting.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the purchasing info record in the source system. Used to detect changes during incremental data loads and to support master data change management processes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_po_date` DATE COMMENT 'Document date of the most recent purchase order created from this info record. Used to assess supplier activity recency and identify dormant info records during periodic master data cleansing.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_po_number` STRING COMMENT 'Document number of the most recent purchase order created referencing this info record (EINE-LBNUM). Provides a quick reference to the last procurement transaction for this material-supplier combination.',
    `material_group` STRING COMMENT 'SAP material group code (MATKL) classifying the material into a commodity or spend category. Used for spend analytics, category management, and sourcing strategy alignment.',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity of the material that must be ordered from this supplier per purchase order line (EINE-MINBM). Enforced during MRP-generated PO creation and manual PO entry to comply with supplier commercial terms.',
    `net_price_confirmed_date` DATE COMMENT 'Date on which the current net unit price was last confirmed or updated by the procurement team following supplier negotiation or price review. Supports audit trails for pricing governance and spend analytics.. Valid values are `^d{4}-d{2}-d{2}$`',
    `order_unit` STRING COMMENT 'Unit of measure (BESTELLEINHEIT) in which the material is ordered from this supplier (e.g., EA, KG, M, BOX). May differ from the materials base unit of measure and drives quantity conversion in MRP and GRN processing.',
    `overdelivery_tolerance_pct` DECIMAL(18,2) COMMENT 'Maximum percentage by which the supplier may deliver in excess of the ordered quantity without triggering a goods receipt rejection (EINE-UEBTO). Expressed as a percentage of the PO quantity. Used in GRN processing to auto-accept minor overdeliveries.',
    `planned_delivery_days` STRING COMMENT 'Total planned delivery time in workdays used by MRP for scheduling purposes (EINE-PLIFZ). May differ from standard_delivery_days when MRP uses a workday calendar. Drives MRP order proposal dates.',
    `plant_code` STRING COMMENT 'SAP plant code (WERKS) for plant-level purchasing info records. When populated, the pricing and conditions apply specifically to this plant. Null indicates org-level applicability across all plants.',
    `price_unit` DECIMAL(18,2) COMMENT 'The quantity basis for the unit price (EINE-PEINH), e.g., price per 1, per 100, or per 1000 units. Required to correctly compute the per-unit cost in MRP and PO line item valuation.',
    `price_valid_from_date` DATE COMMENT 'Start date from which the agreed unit price is commercially valid (EINE-DATAB). Purchase orders created before this date must use alternative pricing. Critical for time-bound contract pricing and annual price negotiations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `price_valid_to_date` DATE COMMENT 'End date after which the agreed unit price expires (EINE-DATBI). MRP and PO creation will flag or block orders if the price validity has lapsed. Triggers procurement team to renegotiate pricing with the supplier.. Valid values are `^d{4}-d{2}-d{2}$`',
    `purchasing_group_code` STRING COMMENT 'SAP purchasing group (EKGRP) responsible for managing this info record and the associated material-supplier relationship. Identifies the buyer or commodity team accountable for the commercial terms.',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization (EKORG) responsible for negotiating and managing the commercial terms captured in this info record. Determines the organizational scope of the pricing and conditions.',
    `regular_vendor_flag` BOOLEAN COMMENT 'Indicates whether this supplier is designated as the regular (preferred) vendor for this material in automatic source determination during MRP and purchase requisition processing (EINE-RESWK indicator).. Valid values are `true|false`',
    `rounding_profile` STRING COMMENT 'SAP rounding profile key (EINE-RDPRF) that defines quantity rounding rules applied during MRP order proposal generation. Ensures order quantities align with supplier packaging units, pallet quantities, or lot sizes.',
    `standard_delivery_days` STRING COMMENT 'Agreed standard lead time in calendar days from purchase order placement to goods receipt at the receiving plant (EINE-WEBAZ). Used by MRP to calculate order release dates and available-to-promise (ATP) calculations.',
    `status` STRING COMMENT 'Current operational status of the purchasing info record. Active records are used in MRP and PO creation. Blocked records are excluded from automatic source determination. Records flagged for deletion are pending archival.. Valid values are `active|blocked|flagged_for_deletion`',
    `underdelivery_tolerance_pct` DECIMAL(18,2) COMMENT 'Maximum percentage by which the supplier may deliver below the ordered quantity and still have the delivery considered complete (EINE-UNTTO). Prevents open PO lines from remaining active for minor shortfalls.',
    `unit_price` DECIMAL(18,2) COMMENT 'Negotiated net unit price for the material from this supplier as agreed in the purchasing info record. Used as the default price in MRP cost calculations and purchase order creation. Expressed in the info record currency.',
    `unlimited_overdelivery_allowed` BOOLEAN COMMENT 'Indicates whether the supplier is permitted to deliver any quantity above the ordered amount without restriction (EINE-KZUEB). When True, the overdelivery tolerance percentage is ignored. Typically used for bulk commodity materials.. Valid values are `true|false`',
    `vendor_material_description` STRING COMMENT 'The suppliers own description or product name for this material. Printed on purchase orders to align with supplier documentation and reduce order fulfillment errors.',
    `vendor_material_number` STRING COMMENT 'The suppliers own part number or catalog number for this material (EINE-IDNLF). Used on purchase orders and supplier communications to ensure unambiguous identification of the ordered item from the suppliers perspective.',
    CONSTRAINT pk_procurement_material_info_record PRIMARY KEY(`procurement_material_info_record_id`)
) COMMENT 'Purchasing info record defining the commercial relationship between a specific material and a specific supplier. Captures agreed unit price, price validity period, standard lead time, minimum order quantity (MOQ), order unit, tolerance limits, and last purchase order reference. SSOT for material-supplier pricing and lead time data used in MRP and PO creation. Aligned with SAP MM Purchasing Info Record (ME11/EINE).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`source_list` (
    `source_list_id` BIGINT COMMENT 'Unique surrogate identifier for each source list record in the Databricks Silver Layer. Serves as the primary key for the source_list data product.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Source lists define approved suppliers for specific engineered components. Procurement maintains which suppliers can provide each component per engineering specifications and approved manufacturer lis',
    `incoterm_id` BIGINT COMMENT 'Foreign key linking to procurement.incoterm. Business justification: Source list references incoterm via incoterms_code (STRING). Adding FK for referential integrity, removing redundant string field.',
    `inventory_sku_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Source lists define approved suppliers for specific SKUs. Controls which suppliers can be used for automatic PO creation in MRP.',
    `procurement_material_info_record_id` BIGINT COMMENT 'Foreign key linking to procurement.material_info_record. Business justification: Source list entries reference the purchasing info record that defines the commercial terms for the material-supplier combination. The table has info_record_number. Adding material_info_record_id FK fo',
    `procurement_supplier_id` BIGINT COMMENT 'FK to procurement.supplier',
    `procurement_supply_agreement_id` BIGINT COMMENT 'Foreign key linking to procurement.supply_agreement. Business justification: Source list entries can reference supply agreements as the approved source of supply for a material. The table has outline_agreement_number. Adding supply_agreement_id FK formalizes this relationship ',
    `quota_arrangement_id` BIGINT COMMENT 'Foreign key linking to procurement.quota_arrangement. Business justification: Source list entries can reference quota arrangements that define the volume split across multiple approved suppliers. The table has quota_arrangement_number. Adding quota_arrangement_id FK formalizes ',
    `agreement_type` STRING COMMENT 'Type of supply agreement referenced by this source list entry. Scheduling agreement = delivery schedule-based; Contract = quantity/value contract; Blanket PO = open purchase order; None = spot/info record-based sourcing.. Valid values are `scheduling_agreement|contract|blanket_po|none`',
    `approved_by` STRING COMMENT 'Name or user ID of the procurement professional or category manager who approved this source list entry. Supports audit trail and procurement governance requirements.',
    `country_of_origin` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code indicating the country where the material is manufactured or sourced from. Used for trade compliance, import/export controls, REACH/RoHS compliance, and supply chain risk assessment.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this source list record was first created in the source system (SAP MM). Used for audit trail, data lineage, and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the pricing currency agreed with this supplier for this material. Used for multi-currency procurement and spend analytics in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `info_record_number` STRING COMMENT 'Reference to the SAP purchasing info record that holds the negotiated price and conditions for this material-supplier-plant combination. Used when no outline agreement exists.',
    `is_blocked` BOOLEAN COMMENT 'Indicates whether this source of supply is explicitly blocked from being used for procurement. A blocked source cannot be selected for purchase requisitions or purchase orders, even if within the validity period.. Valid values are `true|false`',
    `is_fixed_source` BOOLEAN COMMENT 'Indicates whether this supplier is designated as the fixed (mandatory) source of supply for the material-plant combination. When true, MRP will exclusively generate purchase requisitions for this supplier, overriding other approved sources.. Valid values are `true|false`',
    `is_mrp_source_list_required` BOOLEAN COMMENT 'Indicates whether the source list is mandatory for MRP to generate purchase requisitions for this material-plant combination. When true, MRP will only create purchase requisitions for sources listed in the source list.. Valid values are `true|false`',
    `is_preferred_source` BOOLEAN COMMENT 'Indicates whether this supplier is the preferred (but not mandatory) source of supply. When multiple approved sources exist, the preferred source is prioritized during manual and automatic sourcing decisions.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this source list record in the source system. Supports change tracking, data freshness monitoring, and incremental data loading in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_reviewed_date` DATE COMMENT 'Date when this source list entry was last reviewed and validated by the procurement or category management team. Supports supplier qualification governance and periodic source list maintenance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `material_description` STRING COMMENT 'Short descriptive text for the material as maintained in the material master. Provides human-readable context for the source list entry without requiring a join to the material master.',
    `material_group` STRING COMMENT 'SAP material group (commodity category) classifying the material for spend analytics, category management, and sourcing strategy alignment. Used in procurement reporting and supplier segmentation.',
    `maximum_order_quantity` DECIMAL(18,2) COMMENT 'Maximum quantity that can be ordered from this supplier in a single purchase order. Used to enforce supply capacity constraints and split large requirements across multiple sources.',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity that must be ordered from this supplier in a single purchase order. MRP considers this constraint when generating purchase requisitions for this source.',
    `mrp_relevance_indicator` STRING COMMENT 'Controls how MRP uses this source list entry when generating purchase requisitions. 0 = Not relevant for MRP (manual sourcing only); 1 = MRP can generate purchase requisitions for this source; 2 = Source is blocked for MRP (MRP must not use this source). Directly maps to SAP EORD-MODUS field.. Valid values are `0|1|2`',
    `notes` STRING COMMENT 'Free-text field for additional context, sourcing rationale, exceptions, or special instructions related to this source list entry. Used by procurement teams to document sourcing decisions.',
    `number` STRING COMMENT 'Business-facing identifier for the source list entry as assigned in SAP MM (EORD table key). Used for cross-referencing with procurement documents and MRP outputs.',
    `order_unit` STRING COMMENT 'Unit of measure in which the material is ordered from this supplier (e.g., EA, KG, M, L, PC). May differ from the materials base unit of measure and is specific to this supplier relationship.',
    `outline_agreement_item` STRING COMMENT 'Line item number within the referenced outline agreement (scheduling agreement or contract) that corresponds to this source list entry. Required when the agreement covers multiple materials.',
    `outline_agreement_number` STRING COMMENT 'Reference to the SAP scheduling agreement or contract (outline agreement) that governs the supply relationship for this source list entry. Links the source list to a binding supply agreement.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility for which this source of supply is valid. Source list entries are plant-specific in SAP MM.',
    `plant_of_supply` STRING COMMENT 'For internal/inter-plant supply types, identifies the supplying plant (internal manufacturing or distribution center) that will fulfill the demand. Applicable when supply_type is internal_plant or stock_transfer.',
    `procurement_type` STRING COMMENT 'Classifies whether the material is procured as direct material (used in production, part of BOM) or indirect material (MRO, services, overhead). Drives different procurement workflows and spend analytics.. Valid values are `direct|indirect`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization responsible for negotiating and managing the supply agreement with the supplier for this material-plant combination.',
    `quota_arrangement_number` STRING COMMENT 'Reference to the SAP quota arrangement that governs the percentage split of procurement volume across multiple approved sources for this material-plant combination. Enables multi-source supply strategies.',
    `quota_percentage` DECIMAL(18,2) COMMENT 'Percentage of total procurement volume for this material-plant combination allocated to this supplier source. Used in multi-source supply strategies to distribute demand across approved suppliers.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this source list record was ingested into the Databricks Silver Layer. Supports data lineage and multi-system reconciliation in the lakehouse architecture.. Valid values are `SAP_S4HANA|SAP_ECC|ARIBA|MANUAL`',
    `special_procurement_type` STRING COMMENT 'SAP special procurement type code indicating non-standard procurement scenarios such as subcontracting (supplier processes company-owned components), consignment (supplier-owned stock), third-party (direct shipment to customer), or pipeline (continuous supply).. Valid values are `standard|subcontracting|consignment|third_party|pipeline`',
    `standard_lead_time_days` STRING COMMENT 'Standard procurement lead time in calendar days from purchase order placement to goods receipt for this material-supplier-plant combination. Used by MRP for scheduling and delivery date calculation.. Valid values are `^[0-9]+$`',
    `status` STRING COMMENT 'Current operational status of the source list entry. Indicates whether the source is currently active and usable for procurement, expired due to validity period lapse, blocked, or pending approval.. Valid values are `active|inactive|expired|blocked|pending_approval`',
    `sub_range` STRING COMMENT 'Supplier sub-range code identifying a specific product line, manufacturing site, or division within the suppliers organization that is the approved source. Relevant for large suppliers with multiple production facilities.',
    `supply_type` STRING COMMENT 'Categorizes the type of supply relationship for this source list entry. External supplier = standard third-party procurement; Internal plant = inter-plant stock transfer; Subcontracting = supplier processes company-owned materials; Consignment = supplier-owned stock at company premises; Stock transfer = intra-company movement.. Valid values are `external_supplier|internal_plant|subcontracting|consignment|stock_transfer`',
    `usage` STRING COMMENT 'Defines whether the source list is mandatory (procurement must use only listed sources) or optional (source list is advisory). Controlled at the material master level but captured here for analytical context.. Valid values are `mandatory|optional`',
    `valid_from_date` DATE COMMENT 'Start date of the validity period during which this source of supply is approved and active. MRP will only consider this source for automatic purchase requisition generation within the validity window.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'End date of the validity period for this source of supply. After this date, the source is no longer considered by MRP for automatic purchase requisition generation.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_source_list PRIMARY KEY(`source_list_id`)
) COMMENT 'Defines the approved and preferred sources of supply for each material at each plant. Captures valid supplier sources, supply agreement references, fixed/preferred source indicators, MRP relevance flags, and validity periods. Controls which suppliers MRP can automatically generate purchase requisitions for. Aligned with SAP MM Source List (ME01/EORD).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` (
    `quota_arrangement_id` BIGINT COMMENT 'Unique surrogate identifier for the quota arrangement record in the Databricks Silver Layer. Serves as the primary key for this entity.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Quota arrangements allocate purchase volumes across suppliers for specific components. Procurement uses this to split orders for engineered parts based on capacity and strategic sourcing.',
    `inventory_sku_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Quota arrangements split procurement volumes across suppliers for specific SKUs. Manages multi-sourcing strategies and supplier capacity allocation.',
    `procurement_material_info_record_id` BIGINT COMMENT 'Foreign key linking to procurement.material_info_record. Business justification: Quota arrangements reference the purchasing info record for the material-supplier combination to determine pricing and commercial terms. The table has info_record_number. Adding material_info_record_i',
    `procurement_supplier_id` BIGINT COMMENT 'FK to procurement.supplier',
    `procurement_supply_agreement_id` BIGINT COMMENT 'Foreign key linking to procurement.supply_agreement. Business justification: Quota arrangements can reference supply agreements (outline agreements) that govern the sourcing split. The table has outline_agreement_number. Adding supply_agreement_id FK formalizes this relationsh',
    `allocated_quantity` DECIMAL(18,2) COMMENT 'Cumulative quantity already allocated to this supplier under the quota arrangement (EQUK-ZUGMG). Used by MRP to determine which supplier should receive the next procurement order based on quota ratios.',
    `approval_date` DATE COMMENT 'Date on which the quota arrangement was formally approved by the authorized procurement authority. Required for compliance with procurement governance policies.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by` STRING COMMENT 'Name or user ID of the procurement manager or category manager who approved the quota arrangement. Supports audit trail and procurement governance requirements.',
    `arrangement_number` STRING COMMENT 'Business key identifying the quota arrangement in the source system (SAP MM EQUK table key). Used for cross-system traceability and reconciliation.. Valid values are `^[A-Z0-9]{1,10}$`',
    `category_code` STRING COMMENT 'Procurement category or material group code classifying the material under the quota arrangement (e.g., raw materials, MRO, packaging). Supports spend analytics and category management.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country from which the supplier sources or manufactures the material. Relevant for trade compliance, REACH/RoHS, and supply chain risk management.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the quota arrangement record was originally created in the source system. Used for audit trail, data lineage, and change history tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code applicable to pricing and value fields within this quota arrangement. Supports multi-currency procurement in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `info_record_number` STRING COMMENT 'Reference to the SAP purchasing info record (EINE/EINA) that defines the price and conditions for this supplier-material combination. Links quota to negotiated pricing.. Valid values are `^[0-9]{10}$`',
    `is_blocked` BOOLEAN COMMENT 'Indicates whether this quota line is blocked from being used in automatic source determination. A blocked line is excluded from MRP source selection without being deleted.. Valid values are `true|false`',
    `is_fixed_source` BOOLEAN COMMENT 'Indicates whether this quota line is designated as a fixed source of supply, bypassing quota ratio calculations and always directing procurement to this supplier. Supports sole-source or preferred-supplier strategies.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the quota arrangement record in the source system. Supports incremental data loading, change detection, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_reset_date` DATE COMMENT 'Date on which the quota base quantity and allocated quantity counters were last reset. Quota resets are performed periodically to rebalance supplier allocations and reflect updated volume agreements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `line_number` STRING COMMENT 'Sequential line number within the quota arrangement identifying each suppliers quota item (EQUK-ZEILE). Multiple lines exist per arrangement, one per approved supplier.. Valid values are `^[0-9]{1,5}$`',
    `material_description` STRING COMMENT 'Short descriptive text for the material subject to the quota arrangement, supporting readability in reports and analytics without requiring a join to the material master.',
    `maximum_lot_size` DECIMAL(18,2) COMMENT 'Maximum order quantity that can be placed with this supplier in a single procurement order under the quota arrangement. Supports capacity and risk management.',
    `minimum_lot_size` DECIMAL(18,2) COMMENT 'Minimum order quantity that must be placed with this supplier under the quota arrangement. Prevents splitting orders below economically viable quantities.',
    `notes` STRING COMMENT 'Free-text field for capturing business rationale, strategic sourcing decisions, risk diversification justifications, or other contextual information related to the quota arrangement.',
    `outline_agreement_line` STRING COMMENT 'Line item number within the outline agreement referenced by this quota arrangement line. Required when the agreement contains multiple material lines.',
    `outline_agreement_number` STRING COMMENT 'Reference to the SAP scheduling agreement or contract (EKKO) associated with this quota line. Enables procurement to be executed against pre-negotiated framework agreements.. Valid values are `^[0-9]{10}$`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility for which the quota arrangement governs supplier volume allocation. Quota arrangements are plant-specific.. Valid values are `^[A-Z0-9]{1,4}$`',
    `priority` STRING COMMENT 'Numeric priority rank assigned to this quota line relative to other suppliers for the same material and plant. Lower values indicate higher priority for source selection when quota ratios are equal.. Valid values are `^[1-9][0-9]?$`',
    `procurement_type` STRING COMMENT 'Indicates the procurement method for this quota line — external procurement from a supplier, subcontracting, consignment, or internal stock transfer. Drives MRP planning logic.. Valid values are `external|subcontracting|consignment|stock_transfer`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization responsible for negotiating and managing the quota arrangement. Determines the procurement authority and supplier contracts applicable.. Valid values are `^[A-Z0-9]{1,4}$`',
    `quota_base_quantity` DECIMAL(18,2) COMMENT 'Base quantity used as the starting point for quota usage calculation (EQUK-QUOGR). Resets periodically and is used in conjunction with allocated quantity to determine the next source of supply.',
    `quota_percentage` DECIMAL(18,2) COMMENT 'Percentage of total procurement volume allocated to this supplier for the material and plant. All active quota lines for a material/plant must sum to 100%. Core field for multi-source supply strategy.. Valid values are `^(100(.00?)?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `quota_usage_count` STRING COMMENT 'Number of times this quota line has been selected during automatic source determination (EQUK-QUNUM). Used alongside allocated quantity to track supplier selection frequency.',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this quota arrangement record was extracted. Supports data lineage and reconciliation in the Databricks Silver Layer.. Valid values are `SAP_S4HANA|SAP_ECC|MANUAL`',
    `source_type` STRING COMMENT 'Type of procurement source assigned to this quota line. Indicates whether the quota directs procurement to a vendor directly, a contract, or a scheduling agreement.. Valid values are `vendor|outline_agreement|scheduling_agreement`',
    `special_procurement_key` STRING COMMENT 'SAP special procurement key (EQUK-SOBSL) that refines the procurement type, e.g., subcontracting (30), consignment (10), or stock transfer from another plant. Used in MRP source determination.. Valid values are `^[A-Z0-9]{1,2}$`',
    `status` STRING COMMENT 'Current lifecycle status of the quota arrangement line. Drives whether the line is considered during MRP/MRP II source determination and purchase order creation.. Valid values are `active|inactive|expired|suspended|pending_approval`',
    `supplier_code` STRING COMMENT 'Vendor/supplier number assigned to the supplier receiving a quota share for this material and plant. Corresponds to the SAP vendor master (LFA1).. Valid values are `^[A-Z0-9]{1,10}$`',
    `supplying_plant_code` STRING COMMENT 'For stock transfer quota lines, identifies the SAP plant that supplies the material. Applicable when procurement type is internal stock transfer between plants.. Valid values are `^[A-Z0-9]{1,4}$`',
    `unit_of_measure` STRING COMMENT 'Unit of measure for quota base quantity and allocated quantity (e.g., EA, KG, PC, M). Aligns with the material master base unit of measure.. Valid values are `^[A-Z]{2,3}$`',
    `valid_from_date` DATE COMMENT 'Date from which the quota arrangement line becomes effective and eligible for automatic source determination during MRP runs and purchase order creation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'Date on which the quota arrangement line expires and is no longer used for source determination. Supports contract and supplier agreement lifecycle management.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_quota_arrangement PRIMARY KEY(`quota_arrangement_id`)
) COMMENT 'Defines the split of procurement volume across multiple approved suppliers for a given material and plant. Captures quota percentages per supplier, quota base quantity, cumulative allocated quantities, and validity period. Supports multi-source supply strategies, risk diversification, and competitive supplier management. Aligned with SAP MM Quota Arrangement (MEQ1/EQUK).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` (
    `procurement_inbound_delivery_id` BIGINT COMMENT 'Unique surrogate identifier for the inbound delivery record in the lakehouse silver layer. Serves as the primary key for this entity.',
    `export_classification_id` BIGINT COMMENT 'Foreign key linking to compliance.export_classification. Business justification: Inbound deliveries from international suppliers require export classification for customs clearance and trade compliance. Logistics teams verify classification codes match regulatory requirements for ',
    `incoterm_id` BIGINT COMMENT 'Foreign key linking to procurement.incoterm. Business justification: Inbound deliveries specify incoterms governing risk and cost transfer for the shipment. Linking to the incoterm reference table ensures standardized trade term validation. incoterms_code is retained a',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Inbound deliveries are dispatched by suppliers against specific purchase orders. This is a core relationship in the inbound logistics process. purchase_order_number is retained as a business key.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Inbound deliveries originate from specific supplier organizations. The table stores supplier_number and supplier_name. Adding supplier_id FK normalizes this relationship; supplier_name is redundant on',
    `supply_network_node_id` BIGINT COMMENT 'Foreign key linking to procurement.supply_network_node. Business justification: Inbound deliveries arrive at specific plants/supply network nodes. The table has plant_code. Adding supply_network_node_id FK formalizes this relationship and enables network-level inbound logistics a',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to inventory.warehouse. Business justification: Inbound deliveries arrive at specific warehouses. Coordinates receiving dock scheduling and goods receipt processing at destination sites.',
    `actual_arrival_date` DATE COMMENT 'Date on which the inbound delivery physically arrived at the plant gate. Compared against planned arrival date to calculate delivery punctuality and supplier on-time delivery performance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Precise date and time when the inbound delivery arrived at the plant gate. Enables dock scheduling optimization and inbound logistics lead time analysis at sub-day granularity.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `asn_number` STRING COMMENT 'Supplier-provided Advance Shipping Notice (ASN) reference number transmitted prior to shipment dispatch. Used to pre-receive and plan dock scheduling and receiving resources.',
    `carrier_code` STRING COMMENT 'Identifier of the freight carrier or logistics service provider responsible for transporting the inbound delivery. Used for carrier performance tracking and freight cost allocation.',
    `carrier_name` STRING COMMENT 'Name of the freight carrier or logistics service provider transporting the inbound delivery. Denormalized for reporting without requiring a join to the carrier master.',
    `company_code` STRING COMMENT 'SAP company code of the legal entity receiving the inbound delivery. Determines the accounting entity for goods receipt posting and financial reporting under IFRS/GAAP.. Valid values are `^[A-Z0-9]{4}$`',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the shipped goods were manufactured or substantially transformed. Required for customs tariff determination and REACH/RoHS compliance.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the inbound delivery document was created in the source system (SAP MM). Used for audit trail, data lineage, and SLA compliance tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `customs_clearance_status` STRING COMMENT 'Current status of customs clearance processing for the inbound delivery. Applicable for cross-border shipments. Drives release-to-receive workflow and compliance with import regulations.. Valid values are `not_required|pending|in_progress|cleared|held|rejected`',
    `customs_declaration_number` STRING COMMENT 'Official customs entry or import declaration number issued by customs authorities for cross-border inbound deliveries. Required for regulatory compliance and audit trail.',
    `delivery_number` STRING COMMENT 'SAP-assigned 10-digit inbound delivery document number (VL31N / LIKP-VBELN). Serves as the primary business identifier for the inbound delivery across procurement and warehouse operations.. Valid values are `^[0-9]{10}$`',
    `delivery_priority` STRING COMMENT 'Business priority level assigned to the inbound delivery, influencing dock scheduling sequence and receiving resource allocation. Urgent deliveries may be linked to production line stoppage risk.. Valid values are `urgent|high|normal|low`',
    `delivery_type` STRING COMMENT 'Classification of the inbound delivery by procurement scenario. Determines processing rules, movement types, and accounting treatment in SAP MM.. Valid values are `standard|return|subcontracting|consignment|intercompany|third_party`',
    `dock_door_number` STRING COMMENT 'Assigned receiving dock door number at the plant for unloading the inbound delivery. Used for dock scheduling, yard management, and receiving resource coordination.',
    `document_date` DATE COMMENT 'Date on which the inbound delivery document was created in SAP MM. Represents the official document creation date for audit and compliance purposes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `goods_receipt_date` DATE COMMENT 'Date on which the Goods Receipt Note (GRN) was posted in SAP MM, confirming physical receipt and stock update. Triggers invoice verification and payment terms clock.. Valid values are `^d{4}-d{2}-d{2}$`',
    `grn_number` STRING COMMENT 'SAP material document number (GRN) generated upon posting of goods receipt against this inbound delivery. Confirms physical receipt and triggers inventory and financial postings.',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether the inbound delivery contains hazardous materials (HAZMAT) requiring special handling, storage, or regulatory documentation. Triggers EHS compliance workflows.. Valid values are `true|false`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms) code defining the transfer of risk and responsibility between supplier and buyer for this shipment. Impacts customs and freight cost allocation.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `incoterms_location` STRING COMMENT 'Named place or port associated with the Incoterms code, specifying the exact point of risk transfer (e.g., Hamburg Port for FOB Hamburg). Required for customs and freight cost allocation.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the inbound delivery document in the source system. Used for change tracking, delta processing in the lakehouse pipeline, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `origin_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country from which the shipment was dispatched (supplier location). May differ from country of origin for re-export scenarios. Used for trade compliance and logistics routing.. Valid values are `^[A-Z]{3}$`',
    `planned_arrival_date` DATE COMMENT 'Expected date on which the inbound delivery is scheduled to arrive at the receiving plant gate. Used for dock scheduling, receiving resource planning, and on-time delivery KPI measurement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility where the inbound delivery is to be received. Determines storage location assignment and MRP area.. Valid values are `^[A-Z0-9]{4}$`',
    `purchase_order_number` STRING COMMENT 'Reference to the originating Purchase Order (PO) document number against which this inbound delivery is being made. Links delivery to procurement commitment.',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for the procurement transaction underlying this inbound delivery. Used for spend analytics and procurement governance reporting.. Valid values are `^[A-Z0-9]{4}$`',
    `shipment_number` STRING COMMENT 'SAP Transportation Management shipment document number grouping one or more inbound deliveries into a single physical transport. Enables multi-delivery shipment tracking.',
    `shipping_point` STRING COMMENT 'SAP shipping point or receiving point at the plant where the inbound delivery is processed. Used for dock door assignment and resource scheduling.',
    `status` STRING COMMENT 'Current processing status of the inbound delivery document, tracking its lifecycle from creation through full goods receipt. Drives dock scheduling and receiving workflow in SAP MM and Infor WMS.. Valid values are `created|in_transit|arrived|partially_received|fully_received|cancelled|on_hold`',
    `storage_location_code` STRING COMMENT 'SAP storage location within the receiving plant designated for putaway of the inbound delivery. Used by Infor WMS for dock-to-stock routing.. Valid values are `^[A-Z0-9]{4}$`',
    `supplier_number` STRING COMMENT 'SAP vendor master number identifying the supplying party for this inbound delivery. Aligns with the supplier master record in SAP MM (LFA1-LIFNR).',
    `total_gross_weight_kg` DECIMAL(18,2) COMMENT 'Total gross weight of the inbound delivery in kilograms, including packaging. Used for dock capacity planning, freight cost verification, and customs declarations.. Valid values are `^d+(.d{1,3})?$`',
    `total_item_count` STRING COMMENT 'Total number of line items (SKUs) included in the inbound delivery document. Used for receiving workload estimation and completeness verification.. Valid values are `^[1-9][0-9]*$`',
    `total_net_weight_kg` DECIMAL(18,2) COMMENT 'Total net weight of the inbound delivery in kilograms, excluding packaging. Used for material valuation, customs tariff calculation, and inventory management.. Valid values are `^d+(.d{1,3})?$`',
    `total_volume_m3` DECIMAL(18,2) COMMENT 'Total volumetric measurement of the inbound delivery in cubic meters. Used for dock space allocation, truck utilization analysis, and warehouse receiving capacity planning.. Valid values are `^d+(.d{1,3})?$`',
    `transport_document_number` STRING COMMENT 'Bill of lading, waybill, or carrier transport document number accompanying the shipment. Used for customs clearance, carrier tracking, and proof of delivery.',
    `unloading_point` STRING COMMENT 'Specific unloading point or goods receiving area within the plant designated for this inbound delivery. Corresponds to SAP MM unloading point field for dock-to-stock routing.',
    `warehouse_number` STRING COMMENT 'SAP Warehouse Management (WM) warehouse number associated with the receiving storage location. Enables transfer order creation and bin assignment in Infor WMS.',
    CONSTRAINT pk_procurement_inbound_delivery PRIMARY KEY(`procurement_inbound_delivery_id`)
) COMMENT 'Tracks inbound shipments from suppliers from dispatch through receipt at the plant gate. Captures ASN (Advance Shipping Notice) reference, expected arrival date, actual arrival date, carrier, transport document number, total weight, volume, and customs clearance status. Supports dock scheduling, receiving resource planning, and inbound logistics coordination. Aligned with SAP MM Inbound Delivery (VL31N/LIKP).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` (
    `supplier_audit_id` BIGINT COMMENT 'Unique system-generated identifier for each supplier audit record in the procurement domain.',
    `ariba_audit_id` BIGINT COMMENT 'Reference identifier for the corresponding audit record in SAP Ariba Supplier Management module, enabling cross-system traceability.',
    `audit_id` BIGINT COMMENT 'Foreign key linking to quality.quality_audit. Business justification: Supplier audits are a type of quality audit conducted at supplier facilities. Quality audit master record contains audit protocol, findings, and scores referenced by procurement for supplier qualifica',
    `internal_audit_id` BIGINT COMMENT 'Foreign key linking to compliance.internal_audit. Business justification: Supplier audits conducted by internal audit teams are tracked as part of enterprise audit programs. Procurement uses audit results for supplier performance evaluation and corrective action tracking.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the lead auditor from the internal HR or workforce system, enabling traceability of auditor qualifications and assignments.',
    `spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_spend_category. Business justification: Supplier audit references spend category via commodity_category_code (STRING). Adding FK for referential integrity, removing redundant string field.',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Supplier audits are conducted against specific supplier organizations. The table currently stores supplier_code and supplier_name as denormalized strings. Adding supplier_id FK normalizes this relatio',
    `supplier_performance_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supplier_performance. Business justification: Supplier audits directly inform and validate supplier performance scorecards. Audit results (quality_systems_score, manufacturing_capability_score, overall_score) feed into the performance evaluation ',
    `actual_date` DATE COMMENT 'Actual date on which the supplier audit was conducted. May differ from planned date due to rescheduling.',
    `audit_end_date` DATE COMMENT 'Date on which the on-site or remote audit activities concluded. For multi-day audits, this captures the final day of audit execution.',
    `audit_method` STRING COMMENT 'Indicates whether the audit was conducted on-site at the supplier facility, remotely via virtual means, as a hybrid combination, or as a document-only review.. Valid values are `on_site|remote|hybrid|document_review`',
    `audit_number` STRING COMMENT 'Business-facing unique reference number assigned to the supplier audit, used for tracking and cross-referencing in SAP Ariba and QMS systems.. Valid values are `^AUD-[0-9]{4}-[0-9]{6}$`',
    `audit_result` STRING COMMENT 'Overall outcome of the supplier audit determining the suppliers qualification status: approved for continued or new business, conditionally approved pending corrective actions, or not approved.. Valid values are `approved|conditionally_approved|not_approved|suspended|pending_review`',
    `audit_team_members` STRING COMMENT 'Comma-separated list of names or employee IDs of additional auditors and technical experts participating in the audit beyond the lead auditor.',
    `capa_closure_date` DATE COMMENT 'Date on which all CAPA items were verified as effectively implemented and the corrective action process was formally closed.',
    `capa_due_date` DATE COMMENT 'Deadline by which the supplier must submit and implement the CAPA plan for all critical and major findings identified during the audit.',
    `capa_required` BOOLEAN COMMENT 'Indicates whether the audit findings require the supplier to submit a formal CAPA (Corrective and Preventive Action) plan addressing identified non-conformances.. Valid values are `true|false`',
    `capa_submission_date` DATE COMMENT 'Actual date on which the supplier submitted their CAPA plan in response to audit findings, used to track supplier responsiveness.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the supplier audit record was first created in the system, supporting data lineage and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `critical_finding_count` STRING COMMENT 'Number of critical (severity level 1) audit findings that represent immediate risk to product quality, safety, regulatory compliance, or business continuity and require urgent corrective action.. Valid values are `^[0-9]+$`',
    `cybersecurity_score` DECIMAL(18,2) COMMENT 'Audit sub-score (0-100) evaluating the suppliers industrial cybersecurity controls, IT/OT convergence security practices, and compliance with IEC 62443 standards for industrial automation and control systems.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `environmental_compliance_score` DECIMAL(18,2) COMMENT 'Audit sub-score (0-100) assessing the suppliers environmental management system compliance including ISO 14001 certification status, REACH/RoHS adherence, waste management, and emissions controls.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the supplier audit record, used for change tracking, data freshness monitoring, and incremental ETL processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lead_auditor_name` STRING COMMENT 'Full name of the lead auditor responsible for planning, executing, and reporting the supplier audit.',
    `major_finding_count` STRING COMMENT 'Number of major (severity level 2) audit findings representing significant non-conformances to quality, environmental, or regulatory requirements that require formal corrective action plans.. Valid values are `^[0-9]+$`',
    `manufacturing_capability_score` DECIMAL(18,2) COMMENT 'Audit sub-score (0-100) evaluating the suppliers production capacity, process capability (Cp/Cpk), equipment condition, OEE, and ability to meet volume and quality requirements.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `minor_finding_count` STRING COMMENT 'Number of minor (severity level 3) audit findings representing isolated or low-risk non-conformances that require corrective action but do not immediately jeopardize supplier qualification.. Valid values are `^[0-9]+$`',
    `next_scheduled_audit_date` DATE COMMENT 'Date of the next routine surveillance or re-qualification audit as determined by the audit program schedule and supplier risk tier.',
    `notes` STRING COMMENT 'Free-text field for additional auditor observations, executive summary of key findings, supplier context, or special circumstances not captured in structured fields.',
    `observation_count` STRING COMMENT 'Number of audit observations (opportunities for improvement) noted that are not formal non-conformances but represent areas where the supplier could strengthen their systems.. Valid values are `^[0-9]+$`',
    `overall_score` DECIMAL(18,2) COMMENT 'Numeric score (0-100) representing the suppliers overall performance across all audit criteria, used for supplier ranking, qualification decisions, and trend analysis.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `planned_date` DATE COMMENT 'Scheduled date on which the supplier audit was planned to commence, used for audit program scheduling and resource planning.',
    `plant_code` STRING COMMENT 'SAP plant code of the manufacturing facility that relies on this supplier, linking the audit to the specific production site impacted by the suppliers qualification status.',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for managing the supplier relationship and initiating the audit, enabling spend and compliance reporting by organizational unit.',
    `quality_systems_score` DECIMAL(18,2) COMMENT 'Audit sub-score (0-100) for the suppliers quality management system maturity, covering ISO 9001 compliance, SPC implementation, FMEA, PPAP, and quality control processes.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `re_audit_required` BOOLEAN COMMENT 'Indicates whether a follow-up re-audit is required to verify CAPA effectiveness or to re-assess areas where the supplier did not meet qualification thresholds.. Valid values are `true|false`',
    `re_audit_scheduled_date` DATE COMMENT 'Planned date for the follow-up re-audit to verify corrective action effectiveness or re-qualify the supplier after remediation.',
    `report_issue_date` DATE COMMENT 'Date on which the formal audit report was issued to the supplier and internal stakeholders.',
    `status` STRING COMMENT 'Current lifecycle status of the supplier audit record, from planning through completion and closure including CAPA (Corrective and Preventive Action) resolution.. Valid values are `planned|in_progress|completed|cancelled|pending_capa|closed`',
    `supplier_site_code` STRING COMMENT 'Identifier for the specific supplier manufacturing or operational site being audited, as the supplier may have multiple facilities.',
    `supplier_site_country` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the supplier site location where the audit was conducted, supporting multi-country regulatory compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `total_finding_count` STRING COMMENT 'Total number of audit findings identified across all severity levels during the audit, providing an overall measure of supplier compliance gaps.. Valid values are `^[0-9]+$`',
    CONSTRAINT pk_supplier_audit PRIMARY KEY(`supplier_audit_id`)
) COMMENT 'Records formal supplier audits conducted on-site or remotely covering quality systems, manufacturing capability, financial stability, environmental compliance (ISO 14001), and cybersecurity posture (IEC 62443). Captures audit type, audit date, lead auditor, findings count by severity, corrective action requirements, and re-audit schedule. Supports supplier development and qualification maintenance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` (
    `procurement_spend_category_id` BIGINT COMMENT 'Unique surrogate identifier for each spend category record in the procurement taxonomy. Used as the primary key for all downstream joins and references.',
    `category_id` BIGINT COMMENT 'Unique identifier for this spend category as maintained in SAP Ariba. Enables reconciliation between the lakehouse taxonomy and the Ariba sourcing and procurement platform.',
    `annual_spend_budget` DECIMAL(18,2) COMMENT 'Approved annual procurement spend budget allocated to this spend category for the current fiscal year. Used for spend tracking, variance analysis, and category planning.',
    `category_code` STRING COMMENT 'Unique alphanumeric code identifying the spend category within the procurement taxonomy. Used as the business key for cross-system referencing in SAP Ariba and SAP S/4HANA.. Valid values are `^[A-Z0-9-]{2,20}$`',
    `category_description` STRING COMMENT 'Detailed description of the spend category including scope, typical commodities covered, and intended use in procurement planning and sourcing.',
    `category_level` STRING COMMENT 'Numeric level within the spend category hierarchy (e.g., 1=Segment, 2=Family, 3=Class, 4=Commodity, 5=Sub-commodity). Supports hierarchical spend analytics and category management.. Valid values are `^[1-5]$`',
    `category_manager_email` STRING COMMENT 'Corporate email address of the category manager responsible for this spend category. Used for workflow notifications, sourcing event assignments, and supplier communication routing.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `category_manager_name` STRING COMMENT 'Full name of the procurement category manager responsible for strategic sourcing, supplier management, and spend optimization for this category.',
    `category_name` STRING COMMENT 'Human-readable name of the spend category as used in procurement operations, sourcing events, and spend analytics reporting.',
    `company_code` STRING COMMENT 'SAP company code associated with this spend category for financial accounting and spend reporting purposes. Supports multi-entity financial consolidation under IFRS/GAAP.. Valid values are `^[A-Z0-9]{2,10}$`',
    `conflict_minerals_applicable` BOOLEAN COMMENT 'Indicates whether materials in this spend category may contain conflict minerals (3TG: tantalum, tin, tungsten, gold) subject to Dodd-Frank Section 1502 and EU Conflict Minerals Regulation reporting requirements.. Valid values are `true|false`',
    `cost_element_code` STRING COMMENT 'SAP controlling cost element code associated with this spend category. Used for internal cost allocation, profitability analysis, and management accounting reporting.. Valid values are `^[0-9A-Z]{4,12}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the spend category record was first created in the system. Used for data lineage, audit trail, and change management tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code representing the default transaction currency for spend reporting and budgeting within this category.. Valid values are `^[A-Z]{3}$`',
    `effective_end_date` DATE COMMENT 'Date after which this spend category is no longer valid for new procurement transactions. Supports category lifecycle management and taxonomy versioning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_start_date` DATE COMMENT 'Date from which this spend category is valid and available for use in procurement transactions, sourcing events, and spend analytics.. Valid values are `^d{4}-d{2}-d{2}$`',
    `gl_account_code` STRING COMMENT 'Default general ledger account code mapped to this spend category for financial posting and cost allocation. Ensures consistent COGS and OPEX classification in financial reporting.. Valid values are `^[0-9]{6,10}$`',
    `hazmat_applicable` BOOLEAN COMMENT 'Indicates whether items in this spend category are classified as hazardous materials requiring special handling, storage, transportation, and regulatory compliance under OSHA and EPA regulations.. Valid values are `true|false`',
    `incoterms_code` STRING COMMENT 'Default Incoterms 2020 code defining the standard delivery and risk transfer terms for suppliers in this spend category. Used as a default in purchase orders and supply agreements.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `is_direct_material` BOOLEAN COMMENT 'Indicates whether this spend category covers direct materials (raw materials, components, subassemblies) that are consumed in the manufacturing process and included in COGS.. Valid values are `true|false`',
    `is_mro` BOOLEAN COMMENT 'Indicates whether this spend category covers MRO items (maintenance, repair, and operations supplies) used to support manufacturing equipment and facilities without being incorporated into finished goods.. Valid values are `true|false`',
    `is_strategic` BOOLEAN COMMENT 'Indicates whether this spend category is classified as strategic, requiring dedicated category management, long-term supplier relationships, and executive-level oversight.. Valid values are `true|false`',
    `kraljic_position` STRING COMMENT 'Positioning of the spend category within the Kraljic procurement portfolio matrix based on supply risk and spend impact. Drives differentiated sourcing strategies: strategic (high risk/high impact), leverage (low risk/high impact), bottleneck (high risk/low impact), non-critical (low risk/low impact).. Valid values are `strategic|leverage|bottleneck|non_critical`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the spend category record was last updated. Supports incremental data loading, change detection, and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_reviewed_date` DATE COMMENT 'Date when the spend category definition, sourcing strategy, and supplier base were last formally reviewed by the category manager as part of the annual category management cycle.. Valid values are `^d{4}-d{2}-d{2}$`',
    `lead_time_days` STRING COMMENT 'Standard procurement lead time in calendar days for this spend category, representing the typical elapsed time from purchase order issuance to goods receipt. Used in MRP/MRP II planning and safety stock calculations.. Valid values are `^[0-9]{1,4}$`',
    `material_group_code` STRING COMMENT 'SAP S/4HANA material group code that maps to this spend category. Enables integration between the procurement taxonomy and SAP MM material master for purchase requisitions and PO processing.. Valid values are `^[A-Z0-9]{2,9}$`',
    `parent_category_code` STRING COMMENT 'Category code of the immediate parent node in the spend category hierarchy. Enables hierarchical rollup of spend data from commodity level to segment level for category management reporting.. Valid values are `^[A-Z0-9-]{2,20}$`',
    `payment_terms_code` STRING COMMENT 'Default payment terms code applicable to suppliers in this spend category (e.g., NET30, NET60). Used as a default in purchase orders and supplier contracts.. Valid values are `^[A-Z0-9]{2,10}$`',
    `procurement_type` STRING COMMENT 'Classification of the spend category by procurement type: direct (raw materials, components, subassemblies used in production), indirect (MRO, facilities, IT), services (contract manufacturing, logistics), or capex (capital expenditure).. Valid values are `direct|indirect|services|capex`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for procurement activities within this spend category. Defines the organizational unit that negotiates and manages supplier contracts.. Valid values are `^[A-Z0-9]{2,10}$`',
    `reach_applicable` BOOLEAN COMMENT 'Indicates whether materials in this spend category are subject to EU REACH regulation compliance requirements. Drives chemical substance tracking, supplier declarations, and regulatory reporting.. Valid values are `true|false`',
    `risk_level` STRING COMMENT 'Assessed supply risk level for this spend category based on factors such as single-source dependency, geopolitical exposure, regulatory constraints, and market volatility. Supports supply risk management and contingency planning.. Valid values are `critical|high|medium|low`',
    `rohs_applicable` BOOLEAN COMMENT 'Indicates whether materials in this spend category are subject to EU RoHS (Restriction of Hazardous Substances) Directive compliance requirements. Drives supplier qualification and material compliance tracking.. Valid values are `true|false`',
    `savings_target_percent` DECIMAL(18,2) COMMENT 'Annual procurement savings target expressed as a percentage of the category spend budget. Set by the category manager and used to measure sourcing effectiveness and ROI.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `sourcing_strategy` STRING COMMENT 'Defined strategic sourcing approach for this spend category as determined by the category manager. Drives supplier selection, RFQ/RFP processes, and supply risk management decisions.. Valid values are `competitive_bidding|single_source|dual_source|multi_source|preferred_supplier|spot_buy|framework_agreement|consortium_buying|make_vs_buy`',
    `spend_type` STRING COMMENT 'Granular classification of the nature of spend within the category. Supports detailed spend analytics, COGS allocation, and OPEX/CAPEX reporting aligned with IFRS and GAAP standards.. Valid values are `raw_material|component|subassembly|mro|facilities|it|logistics|contract_manufacturing|professional_services|utilities|packaging|tooling|other`',
    `status` STRING COMMENT 'Current operational status of the spend category. Controls whether the category is available for use in purchase requisitions, sourcing events, and spend analytics.. Valid values are `active|inactive|under_review|deprecated`',
    `supply_market_complexity` STRING COMMENT 'Assessment of the complexity of the supply market for this category based on number of qualified suppliers, switching costs, technical barriers, and regulatory requirements. Used in Kraljic matrix positioning.. Valid values are `simple|moderate|complex|highly_complex`',
    `unspsc_code` STRING COMMENT 'Eight-digit UNSPSC commodity code aligned to the United Nations Standard Products and Services Code taxonomy. Enables cross-industry spend benchmarking, supplier classification, and regulatory reporting.. Valid values are `^[0-9]{8}$`',
    CONSTRAINT pk_procurement_spend_category PRIMARY KEY(`procurement_spend_category_id`)
) COMMENT 'Hierarchical commodity and spend category taxonomy used to classify procurement spend across direct materials, indirect materials, MRO, capital equipment, and services. Captures category code, category name, parent category, commodity group, spend classification (direct/indirect/capex), and assigned category manager. Enables spend analytics, category strategy management, and sourcing prioritization.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` (
    `supply_network_node_id` BIGINT COMMENT 'Unique system-generated identifier for each node in the supply network, serving as the primary key for this entity.',
    `incoterm_id` BIGINT COMMENT 'Foreign key linking to procurement.incoterm. Business justification: Supply network nodes specify default incoterms for deliveries to/from that node. Linking to the incoterm reference table ensures standardized trade term validation and enables network-level incoterm a',
    `city` STRING COMMENT 'City where the supply network node is physically located. Used for logistics routing, carrier assignment, and geographic clustering in supply chain resilience analysis.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity that owns or operates this supply network node. Used for financial reporting, intercompany transactions, and regulatory compliance.. Valid values are `^[A-Z0-9]{1,10}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the supply network node is physically located. Used for trade compliance, customs, regulatory reporting, and geographic network analysis.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this supply network node record was first created in the system. Used for data lineage, audit trail, and change management tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the local operating currency of the supply network node. Used for cost valuation, intercompany pricing, and financial consolidation.. Valid values are `^[A-Z]{3}$`',
    `customs_office_code` STRING COMMENT 'Code of the customs office responsible for import/export clearance at or nearest to this supply network node. Required for cross-border trade compliance, customs documentation, and REACH/RoHS regulatory reporting.',
    `effective_end_date` DATE COMMENT 'Date on which this supply network node is planned to be decommissioned or removed from active supply network planning. Used for network transition planning and supply chain resilience modeling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_start_date` DATE COMMENT 'Date from which this supply network node became or is planned to become operationally active in the supply network. Used for time-phased planning, network change management, and historical analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `handling_capacity_kg_per_day` DECIMAL(18,2) COMMENT 'Maximum weight in kilograms the node can receive, process, or dispatch per day. Used for logistics planning, carrier capacity matching, and supply chain constraint analysis.. Valid values are `^d+(.d{1,3})?$`',
    `inbound_lead_time_days` STRING COMMENT 'Standard number of calendar days required for inbound shipments to arrive at this node from upstream supply sources. Used in MRP/MRP II planning, safety stock calculations, and demand-supply synchronization.. Valid values are `^d+$`',
    `incoterms_code` STRING COMMENT 'Default International Commercial Terms (Incoterms) applicable to shipments at this node, defining the transfer of risk and responsibility between buyer and seller. Used in purchase order and logistics documentation.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `is_bonded_warehouse` BOOLEAN COMMENT 'Indicates whether this node operates as a customs bonded warehouse, allowing storage of imported goods without immediate payment of customs duties. Relevant for international trade and customs compliance.. Valid values are `true|false`',
    `is_free_trade_zone` BOOLEAN COMMENT 'Indicates whether this node is located within a designated Free Trade Zone (FTZ) or Special Economic Zone (SEZ), enabling preferential customs and tax treatment for imported/exported goods.. Valid values are `true|false`',
    `is_hazmat_certified` BOOLEAN COMMENT 'Indicates whether this node is certified to handle, store, or process hazardous materials. Relevant for REACH, RoHS, and OSHA compliance, and for routing decisions involving dangerous goods.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this supply network node record. Used for change tracking, data freshness monitoring, and incremental data pipeline processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate (decimal degrees, WGS84) of the supply network node. Used for geospatial network optimization, distance calculations, transportation routing, and supply chain resilience mapping.. Valid values are `^-?(90(.0+)?|[1-8]?d(.d+)?)$`',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate (decimal degrees, WGS84) of the supply network node. Used alongside latitude for geospatial network optimization, distance calculations, and supply chain resilience modeling.. Valid values are `^-?(180(.0+)?|1[0-7]d(.d+)?|[1-9]?d(.d+)?)$`',
    `mrp_area_code` STRING COMMENT 'SAP MRP area code associated with this supply network node. Defines the planning scope for Material Requirements Planning (MRP) and MRP II runs, enabling sub-plant level planning granularity.. Valid values are `^[A-Z0-9_-]{1,20}$`',
    `network_role` STRING COMMENT 'Defines the nodes structural role in the supply network topology: source (origin of supply), intermediate (transit or transformation point), or sink (final consumption or delivery point). Used in multi-echelon inventory planning and network optimization.. Valid values are `source|intermediate|sink`',
    `node_code` STRING COMMENT 'Business-facing alphanumeric code uniquely identifying the supply network node, used in planning systems, reports, and cross-system references (e.g., plant code, DC code, supplier site code).. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `node_name` STRING COMMENT 'Descriptive name of the supply network node (e.g., Frankfurt Distribution Center, Supplier Site - Bosch Stuttgart).',
    `node_owner_type` STRING COMMENT 'Indicates the ownership or operational arrangement of the supply network node: company-owned, leased, operated by a third-party logistics (3PL) provider, consignment, or joint venture. Impacts cost accounting, CAPEX/OPEX classification, and risk management.. Valid values are `owned|leased|third_party_logistics|consignment|joint_venture`',
    `node_type` STRING COMMENT 'Classification of the nodes role in the supply network. Determines planning logic, inventory policies, and network optimization rules applied to the node.. Valid values are `plant|distribution_center|supplier_location|customer_delivery_point|cross_dock|warehouse|port|transit_hub|third_party_logistics`',
    `operating_hours_description` STRING COMMENT 'Description of the nodes standard operating hours (e.g., 24/7, Mon-Fri 06:00-22:00 CET). Used for scheduling inbound/outbound shipments, appointment booking, and lead time calculations.',
    `outbound_lead_time_days` STRING COMMENT 'Standard number of calendar days required for outbound shipments to depart from this node and reach downstream destinations. Used in Available-to-Promise (ATP) and Capable-to-Promise (CTP) calculations.. Valid values are `^d+$`',
    `planning_calendar_code` STRING COMMENT 'Factory or planning calendar code assigned to this node, defining working days, shifts, and holidays used in production scheduling and MRP lead time calculations.',
    `plant_code` STRING COMMENT 'SAP plant code associated with this supply network node, where applicable. Links the node to the manufacturing or storage plant in the ERP system for MRP/MRP II planning and inventory management.. Valid values are `^[A-Z0-9]{1,10}$`',
    `postal_code` STRING COMMENT 'Postal or ZIP code of the supply network nodes physical location. Used for last-mile logistics optimization, carrier rate determination, and geographic analysis.',
    `region_code` STRING COMMENT 'ISO 3166-2 subdivision code (state, province, or region) where the supply network node is located. Supports regional planning, tax jurisdiction determination, and logistics zone assignment.',
    `replenishment_strategy` STRING COMMENT 'Inventory replenishment strategy applied at this node. Determines how stock is triggered and managed: Make to Stock (MTS), Make to Order (MTO), Assemble to Order (ATO), Engineer to Order (ETO), Just-In-Time (JIT), Kanban, Vendor Managed Inventory (VMI), or Consignment.. Valid values are `make_to_stock|make_to_order|assemble_to_order|engineer_to_order|just_in_time|kanban|vendor_managed_inventory|consignment`',
    `safety_stock_days_of_supply` DECIMAL(18,2) COMMENT 'Target safety stock expressed as days of supply to be maintained at this node to buffer against demand variability and supply disruptions. Used in multi-echelon inventory planning and supply chain resilience modeling.. Valid values are `^d+(.d{1,2})?$`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this supply network node record originates (e.g., SAP S/4HANA, SAP APO/SNP, Infor WMS). Used for data lineage, reconciliation, and master data governance.. Valid values are `SAP_S4HANA|SAP_APO|INFOR_WMS|MANUAL|OTHER`',
    `status` STRING COMMENT 'Current operational status of the supply network node. Controls whether the node is available for planning, sourcing, and fulfillment processes.. Valid values are `active|inactive|planned|decommissioned|suspended`',
    `storage_capacity_m3` DECIMAL(18,2) COMMENT 'Maximum physical storage capacity of the node expressed in cubic meters. Used for multi-echelon inventory planning, capacity constraint modeling, and warehouse network optimization.. Valid values are `^d+(.d{1,3})?$`',
    `street_address` STRING COMMENT 'Full street address of the supply network node. Used for shipment routing, carrier pickup/delivery instructions, and regulatory documentation.',
    `third_party_operator_name` STRING COMMENT 'Name of the third-party logistics (3PL) or contract logistics provider operating this node, if applicable. Used for SLA management, performance tracking, and contract administration.',
    `throughput_capacity_units_per_day` DECIMAL(18,2) COMMENT 'Maximum number of units the node can process or handle per day under normal operating conditions. Used for production planning, supply network optimization, and bottleneck identification.. Valid values are `^d+(.d{1,3})?$`',
    `time_zone` STRING COMMENT 'IANA time zone identifier for the supply network nodes location (e.g., Europe/Berlin, America/Chicago). Used for scheduling, lead time calculations, and cross-timezone coordination in global supply chain planning.',
    `transportation_zone_code` STRING COMMENT 'Transportation zone identifier assigned to this node for freight rate determination, carrier assignment, and logistics network optimization. Aligns with Transportation Management System (TMS) zone definitions.',
    CONSTRAINT pk_supply_network_node PRIMARY KEY(`supply_network_node_id`)
) COMMENT 'Defines the nodes in the supply network including plants, distribution centers, supplier locations, and customer delivery points. Captures node type, geographic coordinates, country, region, plant code, capacity constraints, and network role (source, intermediate, sink). Supports supply network optimization, multi-echelon inventory planning, and supply chain resilience modeling.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`po_change_record` (
    `po_change_record_id` BIGINT COMMENT 'Unique surrogate identifier for each purchase order change record in the silver layer lakehouse. Serves as the primary key for this audit trail entity.',
    `employee_id` BIGINT COMMENT 'Employee or system identifier of the person or process that initiated the purchase order change. Aligns with SAP CDHDR-USERNAME. Supports accountability and governance.',
    `procurement_po_line_item_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_po_line_item. Business justification: PO change record references PO line item via po_line_number (STRING). Adding FK for referential integrity, removing redundant string field.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: PO change records are the audit trail of all changes made to a specific purchase order. This is a fundamental parent-child relationship for PO change management. po_number is retained as a business ke',
    `approval_status` STRING COMMENT 'Current approval workflow status of the purchase order change. Drives procurement governance controls and determines whether the change is effective in the source system.. Valid values are `pending|approved|rejected|not_required|escalated|withdrawn`',
    `approved_by` STRING COMMENT 'Name or ID of the approver who authorized the purchase order change. Populated when approval_status is approved. Supports segregation of duties and audit compliance.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the purchase order change was formally approved. Used for approval cycle time analysis and procurement SLA compliance reporting.',
    `change_document_number` STRING COMMENT 'SAP change document number (CDHDR-CHANGENR) uniquely identifying the change event in the source system. Used for traceability and reconciliation with SAP MM.',
    `change_level` STRING COMMENT 'Indicates whether the change was made at the PO header level, line item level, or schedule line level. Determines the scope and impact of the amendment.. Valid values are `header|line_item|schedule_line`',
    `change_number` STRING COMMENT 'Sequential change order number assigned to this amendment, used for external communication with suppliers and internal tracking of revision history.',
    `change_reason_code` STRING COMMENT 'Standardized reason code explaining why the purchase order change was initiated. Supports spend analytics, supplier performance analysis, and procurement governance reporting.. Valid values are `supplier_request|internal_requirement_change|price_negotiation|forecast_revision|quality_issue|capacity_constraint|engineering_change|budget_adjustment|force_majeure|error_correction|cancellation_request|other`',
    `change_reason_text` STRING COMMENT 'Free-text narrative description providing additional context for the change reason beyond the standardized code. Supports supplier dispute resolution and procurement audit trails.',
    `change_requestor_department` STRING COMMENT 'Organizational department of the employee who requested the change (e.g., Procurement, Engineering, Production Planning). Enables departmental spend change analytics.',
    `change_requestor_name` STRING COMMENT 'Full name of the employee who requested the purchase order change. Supports human-readable audit trail reporting and supplier dispute resolution documentation.',
    `change_timestamp` TIMESTAMP COMMENT 'Date and time when the purchase order change was recorded in the source system (SAP CDHDR-UDATE + CDHDR-UTIME). Primary temporal reference for the change event.',
    `change_type` STRING COMMENT 'Classification of the type of change made to the purchase order. Drives downstream processing, supplier notification requirements, and approval routing.. Valid values are `quantity_amendment|price_revision|delivery_date_change|payment_terms_change|supplier_change|line_addition|line_deletion|cancellation|incoterms_change|account_assignment_change|header_text_change|other`',
    `changed_field_description` STRING COMMENT 'Human-readable business description of the field that was changed (e.g., Order Quantity, Net Price, Delivery Date). Supports business-friendly reporting and supplier dispute resolution.',
    `changed_field_name` STRING COMMENT 'The technical or business name of the specific field that was modified (e.g., MENGE for quantity, NETPR for net price, EINDT for delivery date). Aligns with SAP CDPOS-FNAME.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity for which the purchase order change is recorded. Supports multi-entity financial reporting and IFRS/GAAP compliance.. Valid values are `^[A-Z0-9]{4}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this change record was first created in the silver layer lakehouse. Supports data lineage, audit trail completeness, and ETL reconciliation.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the price values in this change record (e.g., USD, EUR, GBP). Supports multi-currency procurement in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `ecn_reference` STRING COMMENT 'Reference to the Engineering Change Notice (ECN) or Engineering Change Order (ECO) that triggered this purchase order change. Links procurement changes to product engineering events in PLM.',
    `effective_date` DATE COMMENT 'The business date from which the change becomes effective in procurement operations. May differ from change_timestamp when changes are backdated or future-dated.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this change record in the silver layer. Supports incremental data processing, SCD tracking, and audit trail maintenance.',
    `new_delivery_date` DATE COMMENT 'The revised scheduled delivery date on the PO line after the delivery date change. Populated when change_type is delivery_date_change. Drives MRP rescheduling and production planning updates.',
    `new_net_price` DECIMAL(18,2) COMMENT 'The revised net unit price on the PO line after the price revision. Populated when change_type is price_revision. Drives updated PO value calculations.',
    `new_quantity` DECIMAL(18,2) COMMENT 'The revised ordered quantity on the PO line after the quantity amendment. Populated only when change_type is quantity_amendment.',
    `new_value` STRING COMMENT 'The value of the changed field after the amendment was applied (CDPOS-VALUE_NEW). Stored as STRING to accommodate all field types. Represents the current authoritative value post-change.',
    `original_delivery_date` DATE COMMENT 'The scheduled delivery date on the PO line before the delivery date change. Populated when change_type is delivery_date_change. Used for on-time delivery performance tracking.',
    `original_net_price` DECIMAL(18,2) COMMENT 'The net unit price on the PO line before the price revision. Populated when change_type is price_revision. Used for spend variance analysis and supplier negotiation audit.',
    `original_quantity` DECIMAL(18,2) COMMENT 'The ordered quantity on the PO line before the quantity amendment. Populated only when change_type is quantity_amendment. Enables precise variance analysis and supplier communication.',
    `original_value` STRING COMMENT 'The value of the changed field before the amendment was applied (CDPOS-VALUE_OLD). Stored as STRING to accommodate all field types (quantity, price, date, text). Essential for audit trail and supplier dispute resolution.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility associated with the purchase order being changed. Supports plant-level procurement analytics.',
    `po_number` STRING COMMENT 'The purchase order number to which this change record applies. Identifies the parent PO that was amended, revised, or cancelled.. Valid values are `^[0-9]{10}$`',
    `price_unit` DECIMAL(18,2) COMMENT 'The quantity basis for the net price (e.g., price per 1, per 100, per 1000 units). Aligns with SAP EKPO-PEINH. Required for accurate price comparison between original and new values.',
    `purchasing_group` STRING COMMENT 'SAP purchasing group (buyer group) code responsible for managing the purchase order change. Enables buyer-level performance analytics and workload reporting.',
    `purchasing_org` STRING COMMENT 'SAP purchasing organization code responsible for the purchase order being changed. Supports organizational reporting and procurement governance across multinational entities.',
    `quantity_uom` STRING COMMENT 'Unit of measure applicable to original_quantity and new_quantity fields (e.g., EA, KG, M, L, PC). Aligns with SAP MEINS and ISO 80000 measurement standards.',
    `rejection_reason` STRING COMMENT 'Explanation provided by the approver when a change request is rejected. Populated when approval_status is rejected. Supports process improvement and governance reporting.',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this change record originated (e.g., SAP S/4HANA, SAP Ariba). Supports data lineage and reconciliation in the lakehouse.. Valid values are `SAP_S4HANA|SAP_ARIBA|MANUAL|INTERFACE`',
    `supplier_acknowledgment_status` STRING COMMENT 'Status of the suppliers acknowledgment of the purchase order change. Tracks whether the supplier has accepted, disputed, or rejected the amendment. Supports supplier dispute resolution.. Valid values are `pending|acknowledged|disputed|accepted|rejected`',
    `supplier_notification_date` DATE COMMENT 'Date on which the supplier was formally notified of the purchase order change. Populated when supplier_notified_flag is true. Supports SLA compliance and dispute resolution.',
    `supplier_notified_flag` BOOLEAN COMMENT 'Indicates whether the supplier has been formally notified of the purchase order change. Critical for supplier relationship management and contractual obligation tracking.. Valid values are `true|false`',
    CONSTRAINT pk_po_change_record PRIMARY KEY(`po_change_record_id`)
) COMMENT 'Audit trail of all changes made to purchase orders after initial creation including quantity amendments, price revisions, delivery date changes, and cancellations. Captures change type, original value, new value, change reason, change requestor, and approval status. Supports procurement governance, supplier dispute resolution, and change order management. Aligned with SAP MM PO Change History (ME22N/CDHDR).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supplier` (
    `supplier_id` BIGINT COMMENT 'Primary key for supplier',
    CONSTRAINT pk_supplier PRIMARY KEY(`supplier_id`)
) COMMENT 'Master record for all suppliers, vendors, and sub-contractors engaged in sourcing raw materials, components, subassemblies, and MRO supplies. Captures supplier identity, classification, qualification status, risk tier, payment terms, diversity classification, and global registration details as managed in SAP Ariba Supplier Management. Serves as the SSOT for supplier identity within the procurement domain.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supplier_qualification` (
    `supplier_qualification_id` BIGINT COMMENT 'Primary key for supplier_qualification',
    CONSTRAINT pk_supplier_qualification PRIMARY KEY(`supplier_qualification_id`)
) COMMENT 'Tracks the formal qualification and onboarding lifecycle of suppliers including qualification stage, audit results, certifications required (ISO 9001, ISO 14001, REACH, RoHS), approval status, disqualification reasons, and re-qualification schedules. Supports APQP and PPAP supplier approval workflows managed via SAP Ariba Supplier Qualification.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`sourcing_event` (
    `sourcing_event_id` BIGINT COMMENT 'Primary key for sourcing_event',
    CONSTRAINT pk_sourcing_event PRIMARY KEY(`sourcing_event_id`)
) COMMENT 'Represents a formal strategic sourcing event such as an RFQ (Request for Quotation), RFP (Request for Proposal), or reverse auction initiated through SAP Ariba Sourcing. Captures event type, spend category, target commodity, invited suppliers, evaluation criteria, award decision, and sourcing cycle timeline. Supports category management and competitive bidding processes.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`sourcing_bid` (
    `sourcing_bid_id` BIGINT COMMENT 'Primary key for sourcing_bid',
    CONSTRAINT pk_sourcing_bid PRIMARY KEY(`sourcing_bid_id`)
) COMMENT 'Captures individual supplier bid responses submitted during a sourcing event (RFQ/RFP/auction). Includes bid line items, quoted unit price, lead time, MOQ (Minimum Order Quantity), delivery terms, technical compliance flags, and bid scoring results. Enables multi-supplier bid comparison and award optimization within SAP Ariba.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` (
    `procurement_contract_id` BIGINT COMMENT 'Unique surrogate identifier for each procurement contract record in the lakehouse silver layer. Serves as the primary key for all downstream joins and lineage tracking.',
    `incoterm_id` BIGINT COMMENT 'Foreign key linking to procurement.incoterm. Business justification: Procurement contracts specify incoterms governing risk and cost transfer for deliveries under the contract. Linking to the incoterm reference table ensures standardized trade term validation. incoterm',
    `it_contract_id` BIGINT COMMENT 'Foreign key linking to technology.it_contract. Business justification: IT service and software contracts managed by procurement reference IT contract records for SLA tracking, license compliance, and renewal management. Both teams access this relationship for vendor mana',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: Procurement contracts are signed by specific legal entities for liability and tax purposes. Required for intercompany transactions and statutory reporting in multi-entity manufacturing organizations.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Long-term procurement contracts require a designated employee to manage renewals, amendments, compliance monitoring, and vendor relationship throughout the contract lifecycle.',
    `procurement_payment_term_id` BIGINT COMMENT 'Foreign key linking to procurement.payment_term. Business justification: Procurement contracts specify payment terms governing supplier payment. Linking to the payment_term reference table ensures standardized payment term validation and enables cash flow forecasting. paym',
    `procurement_sourcing_event_id` BIGINT COMMENT 'Foreign key linking to procurement.sourcing_event. Business justification: Procurement contracts result from strategic sourcing events. The table has sourcing_event_reference. Adding sourcing_event_id FK enables end-to-end sourcing-to-contract traceability. sourcing_event_re',
    `procurement_spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.spend_category. Business justification: Procurement contracts are negotiated for specific spend categories. The table stores category_code and category_name. Adding spend_category_id FK normalizes this relationship; category_name is redunda',
    `procurement_supplier_id` BIGINT COMMENT 'FK to procurement.supplier',
    `procurement_supply_agreement_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supply_agreement. Business justification: Procurement contracts often formalize and supersede supply agreements. A contract may reference the underlying scheduling agreement or blanket PO it governs. This link enables tracking the evolution f',
    `approval_status` STRING COMMENT 'Current approval workflow status of the contract in SAP Ariba. Determines whether the contract is authorized for purchase order release.. Valid values are `pending|approved|rejected|withdrawn`',
    `approved_by` STRING COMMENT 'Name or employee ID of the authorized approver who granted final approval for this contract in the procurement approval workflow.',
    `approved_date` DATE COMMENT 'Date on which the contract received final approval from the authorized approver, enabling it to become active for purchase order release.. Valid values are `^d{4}-d{2}-d{2}$`',
    `ariba_contract_reference` STRING COMMENT 'Native contract identifier from SAP Ariba Contract Management system, used for system-of-record traceability and integration reconciliation.',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the contract automatically renews upon expiry unless a termination notice is issued within the notice period. Drives contract expiry alert workflows.. Valid values are `true|false`',
    `category_code` STRING COMMENT 'Spend category code classifying the goods or services covered by this contract. Aligns with the procurement spend taxonomy for category management and analytics.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the primary country from which goods or services are supplied under this contract. Used for trade compliance and risk assessment.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the procurement contract record was first created in SAP Ariba Contract Management. Used for audit trail and data lineage.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the contract value and pricing conditions are denominated. Supports multi-currency global procurement operations.. Valid values are `^[A-Z]{3}$`',
    `effective_end_date` DATE COMMENT 'Date on which the contract expires and is no longer valid for purchase order release. Triggers renewal workflow or re-sourcing event if not renewed.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_start_date` DATE COMMENT 'Date on which the contract becomes legally effective and purchase orders may be released against it. Used for MRP source list validity and compliance checks.. Valid values are `^d{4}-d{2}-d{2}$`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the transfer of risk, cost, and responsibility between buyer and supplier for deliveries under this contract.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `incoterms_location` STRING COMMENT 'Named place or port associated with the Incoterms code, specifying the exact point of risk and cost transfer (e.g., Hamburg Port for FOB Hamburg).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the contract record in SAP Ariba. Used for change detection, incremental ETL processing, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `minimum_order_value` DECIMAL(18,2) COMMENT 'Minimum monetary value that must be ordered per release or call-off under this contract. Enforced during purchase order creation to comply with supplier commercial terms.',
    `number` STRING COMMENT 'Business-facing unique contract identifier as assigned in SAP Ariba Contract Management. Used for cross-system reference and supplier communication.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `owner` STRING COMMENT 'Name or employee ID of the procurement professional responsible for managing this contract, including renewals, compliance monitoring, and supplier performance.',
    `payment_terms_code` STRING COMMENT 'SAP payment terms key defining the payment schedule, discount periods, and due date calculation for invoices issued under this contract (e.g., NET30, 2/10NET30).',
    `penalty_clause_description` STRING COMMENT 'Textual description of the penalty terms, including trigger conditions, calculation method, and maximum liability cap as negotiated with the supplier.',
    `penalty_clause_flag` BOOLEAN COMMENT 'Indicates whether the contract contains penalty clauses for supplier non-performance, late delivery, or quality failures. Triggers penalty tracking and enforcement workflows.. Valid values are `true|false`',
    `procurement_type` STRING COMMENT 'Indicates whether the contract covers direct materials (production-related), indirect materials, services, capital expenditure (CAPEX), or maintenance repair and operations (MRO).. Valid values are `direct|indirect|services|capex|mro`',
    `purchasing_group_code` STRING COMMENT 'SAP purchasing group (buyer group) responsible for day-to-day management and release of purchase orders against this contract.',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization responsible for negotiating and managing this contract. Defines the organizational scope and authority for contract execution.',
    `reach_compliance_required` BOOLEAN COMMENT 'Indicates whether the contract mandates supplier compliance with the EU REACH regulation (Registration, Evaluation, Authorisation and Restriction of Chemicals).. Valid values are `true|false`',
    `released_value` DECIMAL(18,2) COMMENT 'Cumulative monetary value of purchase orders released against this contract to date. Compared against total contract value to monitor consumption and remaining commitment.',
    `renewal_notice_days` STRING COMMENT 'Number of calendar days prior to contract expiry by which a renewal or termination notice must be issued. Used to trigger automated renewal reminders.. Valid values are `^[0-9]+$`',
    `rohs_compliance_required` BOOLEAN COMMENT 'Indicates whether the contract mandates supplier compliance with the EU Restriction of Hazardous Substances (RoHS) directive for all delivered materials.. Valid values are `true|false`',
    `sap_outline_agreement_number` STRING COMMENT 'Corresponding SAP S/4HANA MM outline agreement number (scheduling agreement or contract) linked to this procurement contract for purchase order release.. Valid values are `^[0-9]{10}$`',
    `sourcing_event_reference` STRING COMMENT 'Reference to the SAP Ariba sourcing event (RFQ/RFP) that resulted in the award of this contract. Provides traceability from sourcing to contract.',
    `status` STRING COMMENT 'Current lifecycle status of the procurement contract. Drives procurement eligibility, MRP source list activation, and compliance reporting.. Valid values are `draft|pending_approval|active|expired|terminated|suspended|under_renewal|closed`',
    `supplier_code` STRING COMMENT 'Unique identifier of the contracted supplier as registered in SAP Ariba and SAP S/4HANA vendor master. Links to the supplier master record.',
    `termination_date` DATE COMMENT 'Actual date on which the contract was terminated prior to its scheduled expiry, if applicable. Populated only for contracts with status terminated.. Valid values are `^d{4}-d{2}-d{2}$`',
    `termination_reason` STRING COMMENT 'Reason code explaining why the contract was terminated before its scheduled end date. Used for supplier performance analysis and sourcing strategy review.. Valid values are `supplier_non_performance|mutual_agreement|business_need_change|regulatory_compliance|cost_reduction|supplier_disqualification|other`',
    `title` STRING COMMENT 'Descriptive title of the procurement contract summarizing the scope of supply or service covered by the agreement.',
    `total_contract_value` DECIMAL(18,2) COMMENT 'Maximum total monetary value committed under this contract over its full validity period, in the contract currency. Used for spend commitment tracking and financial planning.',
    `type` STRING COMMENT 'Classification of the procurement contract by its commercial structure. Determines release mechanism, pricing model, and SAP outline agreement category.. Valid values are `blanket_purchase_agreement|long_term_supply_agreement|frame_contract|spot_buy|scheduling_agreement|master_supply_agreement|service_agreement`',
    CONSTRAINT pk_procurement_contract PRIMARY KEY(`procurement_contract_id`)
) COMMENT 'Master record for all procurement contracts and supplier agreements including blanket purchase agreements, long-term supply agreements, frame contracts, and spot buy contracts. Captures contract type, spend category, contracted value, validity period, payment terms, Incoterms, penalty clauses, renewal options, and compliance obligations. Managed via SAP Ariba Contract Management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` (
    `contract_line_item_id` BIGINT COMMENT 'Unique surrogate identifier for each individual line item within a procurement contract in the Databricks Silver Layer lakehouse.',
    `contract_line_id` BIGINT COMMENT 'External reference identifier for this contract line item in SAP Ariba Contract Management, enabling cross-system traceability between the ERP and procurement platform.',
    `incoterm_id` BIGINT COMMENT 'Foreign key linking to procurement.incoterm. Business justification: Contract line items specify incoterms at the line level, which may differ from the contract header incoterms. Linking to the incoterm reference table ensures standardized trade term validation. incote',
    `inventory_sku_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Contract lines specify SKUs covered under procurement agreements. Links contracted pricing and terms to specific materials for release orders.',
    `procurement_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_contract. Business justification: Contract line items are the fundamental child records of a procurement contract header. This is the core parent-child relationship in the contract data model. contract_number is retained as a business',
    `account_assignment_category` STRING COMMENT 'SAP account assignment category determining how the procurement cost is allocated (e.g., K=Cost Center, F=Order, P=Project/WBS, A=Asset), used for financial posting.. Valid values are `K|F|P|A|C|U|blank`',
    `contract_number` STRING COMMENT 'The business-facing contract document number from the source system (e.g., SAP outline agreement number or Ariba contract ID) that this line item belongs to.',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the contracted material is manufactured or the service is provided, used for customs, trade compliance, and RoHS/REACH assessments.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this contract line item record was first created in the source system, used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the contract line item price is denominated, supporting multi-currency procurement in global operations.. Valid values are `^[A-Z]{3}$`',
    `delivery_lead_time_days` STRING COMMENT 'Agreed supplier lead time in calendar days from purchase order release to goods receipt for this contract line item, used in Material Requirements Planning (MRP) scheduling.',
    `effective_end_date` DATE COMMENT 'Date after which this contract line item expires and no further purchase orders can be released against it without contract renewal.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_start_date` DATE COMMENT 'Date from which this contract line item becomes valid and purchase orders can be released against it.. Valid values are `^d{4}-d{2}-d{2}$`',
    `escalation_index_reference` STRING COMMENT 'Name or code of the external price index (e.g., steel index, CPI, PPI) used as the reference for price escalation calculations on this contract line item.',
    `escalation_rate_pct` DECIMAL(18,2) COMMENT 'Fixed annual or periodic price escalation rate percentage applicable to this contract line item when the escalation clause type is fixed or annual review.',
    `gl_account_code` STRING COMMENT 'General Ledger account code to which the procurement cost for this contract line item is posted, supporting financial reporting and cost of goods sold (COGS) tracking.',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms) code defining the delivery obligations, risk transfer point, and cost responsibilities between buyer and supplier for this line item.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `item_category` STRING COMMENT 'SAP item category classifying the procurement type for this line item, determining the procurement and goods receipt process flow.. Valid values are `standard|consignment|subcontracting|third_party|service|limit`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this contract line item record in the source system, supporting change tracking and data freshness monitoring.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `line_number` STRING COMMENT 'Sequential line number identifying this item within the contract document, used for referencing in purchase orders and delivery schedules.. Valid values are `^[0-9]{1,5}$`',
    `material_group` STRING COMMENT 'Material group or commodity classification code grouping the material for spend analytics, category management, and sourcing strategy alignment.',
    `maximum_order_quantity` DECIMAL(18,2) COMMENT 'Maximum quantity allowed per individual release order against this contract line item, used to enforce order size constraints.',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity that must be ordered per release order against this contract line item, as negotiated with the supplier.',
    `net_price` DECIMAL(18,2) COMMENT 'The negotiated net unit price for the material or service on this contract line item, excluding taxes and surcharges, used as the baseline for purchase order pricing.',
    `over_delivery_tolerance_pct` DECIMAL(18,2) COMMENT 'Maximum percentage by which the delivered quantity may exceed the ordered quantity for a release order against this line item without triggering a goods receipt block.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility designated to receive deliveries against this contract line item.',
    `price_escalation_clause` STRING COMMENT 'Type of price escalation or adjustment mechanism agreed for this contract line item, governing how the unit price may change over the contract period (e.g., CPI-linked, raw material index).. Valid values are `none|fixed|index_linked|annual_review|formula_based|cpi_linked|raw_material_index`',
    `price_unit` DECIMAL(18,2) COMMENT 'The quantity basis for the net price (e.g., price per 1 EA, per 100 KG), used to correctly calculate the line item value when ordering.',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for negotiating and managing this contract line item, used for spend analytics and organizational reporting.',
    `reach_compliant` BOOLEAN COMMENT 'Indicates whether the material covered by this contract line item is compliant with the EU REACH regulation, ensuring no restricted substances are present above threshold levels.. Valid values are `true|false`',
    `released_quantity` DECIMAL(18,2) COMMENT 'Cumulative quantity released against this contract line item through purchase orders or scheduling agreements, used to track contract utilization.',
    `released_value` DECIMAL(18,2) COMMENT 'Cumulative monetary value released against this contract line item through purchase orders, used for contract compliance monitoring and spend analytics.',
    `rohs_compliant` BOOLEAN COMMENT 'Indicates whether the material covered by this contract line item is compliant with the EU Restriction of Hazardous Substances (RoHS) Directive, required for CE-marked products.. Valid values are `true|false`',
    `short_text` STRING COMMENT 'Free-text description of the contracted material or service when no material master number exists, used for indirect procurement or service line items.',
    `status` STRING COMMENT 'Current lifecycle status of the contract line item, controlling whether it can be referenced in purchase orders or delivery schedules.. Valid values are `active|closed|blocked|cancelled|pending_approval|expired`',
    `storage_location_code` STRING COMMENT 'SAP storage location within the receiving plant where goods delivered against this contract line item are to be placed into stock.',
    `target_quantity` DECIMAL(18,2) COMMENT 'The total contracted quantity agreed for this line item over the contract validity period, used for release order tracking and commitment monitoring.',
    `target_value` DECIMAL(18,2) COMMENT 'Total committed monetary value for this contract line item (target quantity × net price / price unit), used for spend commitment tracking and budget planning.',
    `tax_code` STRING COMMENT 'Tax determination code applied to this contract line item for VAT/GST calculation during invoice verification, aligned with the applicable tax jurisdiction.',
    `under_delivery_tolerance_pct` DECIMAL(18,2) COMMENT 'Maximum percentage by which the delivered quantity may fall short of the ordered quantity for a release order against this line item before it is flagged as a delivery shortfall.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `unit_of_measure` STRING COMMENT 'The base unit of measure for the contracted quantity and pricing (e.g., EA, KG, M, L, HR), aligned with the material master order unit.',
    CONSTRAINT pk_contract_line_item PRIMARY KEY(`contract_line_item_id`)
) COMMENT 'Individual line items within a procurement contract specifying the material or service, contracted quantity, unit price, price escalation clauses, delivery schedule, and tolerance limits. Supports contract compliance monitoring and price variance tracking against actual PO spend.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` (
    `purchase_requisition_id` BIGINT COMMENT 'Primary key for purchase_requisition',
    `spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.spend_category. Business justification: purchase_requisition should be categorized by spend_category for approval routing and spend analytics. Adding spend_category_id FK enables category-based requisition management.',
    CONSTRAINT pk_purchase_requisition PRIMARY KEY(`purchase_requisition_id`)
) COMMENT 'Internal procurement request generated by production planning (MRP), maintenance (MRO), or business units requesting materials, components, or services. Captures requestor, cost center, material/service description, required quantity, required delivery date, preferred supplier, and approval workflow status. Sourced from SAP S/4HANA MM module (ME51N).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`purchase_order` (
    `purchase_order_id` BIGINT COMMENT 'Primary key for purchase_order',
    `procurement_supplier_id` BIGINT COMMENT 'Auto-generated FK linking siloed purchase_order to procurement_supplier',
    CONSTRAINT pk_purchase_order PRIMARY KEY(`purchase_order_id`)
) COMMENT 'Formal PO issued to a supplier authorizing the supply of materials, components, subassemblies, or MRO items at agreed terms. Captures PO type (standard, blanket release, subcontracting), supplier, plant, delivery address, payment terms, Incoterms, total PO value, currency, and approval status. Core transactional entity in SAP S/4HANA MM (ME21N).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`po_line_item` (
    `po_line_item_id` BIGINT COMMENT 'Primary key for po_line_item',
    `procurement_payment_term_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_payment_term. Business justification: po_line_item may have line-specific payment terms. Adding payment_term_id FK enables line-level payment term specification for complex POs.',
    CONSTRAINT pk_po_line_item PRIMARY KEY(`po_line_item_id`)
) COMMENT 'Individual line items on a purchase order specifying material number, ordered quantity, unit of measure, agreed unit price, delivery date, storage location, account assignment (cost center or WBS element), and goods receipt status. Enables granular PO tracking, three-way match, and spend analytics at the material level.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`goods_receipt` (
    `goods_receipt_id` BIGINT COMMENT 'Primary key for goods_receipt',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: goods_receipt should directly reference supplier master. Adding supplier_id FK eliminates redundant supplier_number string and enables direct supplier lookup.',
    CONSTRAINT pk_goods_receipt PRIMARY KEY(`goods_receipt_id`)
) COMMENT 'Records the physical receipt of goods against a purchase order at a plant or warehouse location. Captures GRN (Goods Receipt Note) number, received quantity, receiving plant, storage location, batch number, quality inspection flag, and posting date. Triggers inventory update and initiates three-way match for invoice verification in SAP S/4HANA MM (MIGO).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` (
    `supplier_invoice_id` BIGINT COMMENT 'Primary key for supplier_invoice',
    `procurement_payment_term_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_payment_term. Business justification: supplier_invoice should reference payment_term master. Adding payment_term_id FK eliminates redundant payment_terms_code string and enables payment term lookup.',
    CONSTRAINT pk_supplier_invoice PRIMARY KEY(`supplier_invoice_id`)
) COMMENT 'Supplier-submitted invoice for goods or services delivered against a PO. Captures invoice number, invoice date, invoiced amount, tax amount, currency, payment due date, three-way match status (PO-GRN-Invoice), discrepancy flags, and payment block reasons. Processed via SAP S/4HANA MM Invoice Verification (MIRO) and linked to accounts payable in Finance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`spend_category` (
    `spend_category_id` BIGINT COMMENT 'Primary key for spend_category',
    CONSTRAINT pk_spend_category PRIMARY KEY(`spend_category_id`)
) COMMENT 'Hierarchical classification taxonomy for all procurement spend categories including direct materials (raw materials, components, subassemblies), indirect materials (MRO, facilities), and services (contract manufacturing, logistics). Captures category code, category level, parent category, commodity code (UNSPSC), responsible category manager, and strategic sourcing strategy. Supports category management and spend analytics.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` (
    `preferred_supplier_list_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each preferred supplier list entry in the Databricks Silver Layer.',
    `procurement_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_contract. Business justification: Preferred supplier list entries reference the procurement contract that governs the preferred supplier relationship. The table has contract_reference. Adding procurement_contract_id FK formalizes this',
    `sourcing_event_id` BIGINT COMMENT 'Foreign key linking to procurement.sourcing_event. Business justification: Preferred supplier list entries can reference the sourcing event that established the preferred supplier status. The table has sourcing_event_reference. Adding sourcing_event_id FK enables traceabilit',
    `spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.spend_category. Business justification: Preferred supplier list entries are organized by spend category. The table stores category_code and category_name. Adding spend_category_id FK normalizes this relationship; category_name is redundant ',
    `supplier_id` BIGINT COMMENT 'FK to procurement.supplier',
    `supplier_qualification_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supplier_qualification. Business justification: PSL designation should reference the formal qualification record. The qualification_status and qualification_expiry_date in PSL are redundant with the authoritative data in procurement_supplier_qualif',
    `approval_status` STRING COMMENT 'Workflow approval status of this PSL entry, tracking whether the preferred designation has been reviewed and authorized by the appropriate procurement authority.. Valid values are `pending|approved|rejected|withdrawn`',
    `approved_by` STRING COMMENT 'Name or employee ID of the procurement authority (e.g., Category Manager, CPO) who approved this preferred supplier designation.',
    `approved_date` DATE COMMENT 'Date on which the preferred supplier designation was formally approved by the authorized procurement stakeholder.. Valid values are `^d{4}-d{2}-d{2}$`',
    `ariba_psl_reference` STRING COMMENT 'External identifier from SAP Ariba Supplier Management module corresponding to this preferred supplier list entry, enabling cross-system traceability.',
    `category_code` STRING COMMENT 'Procurement spend category code (aligned to UNSPSC or internal taxonomy) defining the scope of goods or services for which the supplier is preferred.',
    `category_manager_name` STRING COMMENT 'Name of the category manager responsible for managing the supplier relationship and preferred status within this spend category.',
    `conflict_minerals_compliant` BOOLEAN COMMENT 'Indicates whether the supplier has provided conflict minerals compliance documentation (3TG: tin, tantalum, tungsten, gold) per Dodd-Frank Section 1502 requirements.. Valid values are `true|false`',
    `contract_reference` STRING COMMENT 'Reference to the supply agreement, outline agreement, or blanket purchase order number in SAP S/4HANA or SAP Ariba that underpins this preferred supplier designation.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country scope of this preferred supplier designation. Null indicates multi-country or global applicability.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp recording when this preferred supplier list entry was first created in the system, supporting audit trail and data lineage requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `designation_reason` STRING COMMENT 'Business rationale documenting why this supplier was designated at the specified preference tier, including strategic alignment, competitive sourcing outcome, or qualification result.',
    `is_diversity_supplier` BOOLEAN COMMENT 'Flag indicating whether this supplier qualifies as a diversity supplier (e.g., minority-owned, women-owned, veteran-owned), supporting supplier diversity program compliance and reporting.. Valid values are `true|false`',
    `is_single_source` BOOLEAN COMMENT 'Flag indicating that this supplier is the sole approved source for the designated category and plant, requiring documented single-source justification per procurement policy.. Valid values are `true|false`',
    `is_strategic_supplier` BOOLEAN COMMENT 'Flag indicating whether this supplier is classified as a strategic partner, warranting executive-level relationship management, joint development programs, and enhanced collaboration.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this preferred supplier list entry, used for change tracking, incremental data loads, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `next_review_date` DATE COMMENT 'Scheduled date for the periodic review of this preferred supplier designation to assess continued alignment with procurement strategy, supplier performance, and qualification status.. Valid values are `^d{4}-d{2}-d{2}$`',
    `notes` STRING COMMENT 'Free-text field for additional context, conditions, or exceptions associated with this preferred supplier designation, such as volume thresholds, geographic restrictions, or transition plans.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility for which this supplier preference applies. Null indicates enterprise-wide applicability.',
    `preference_tier` STRING COMMENT 'Procurement policy designation indicating the level of preference for this supplier within the category. Preferred directs buyers to use this supplier first; Approved allows use without restriction; Conditional requires additional justification; Restricted limits use to specific circumstances.. Valid values are `preferred|approved|conditional|restricted`',
    `priority_rank` STRING COMMENT 'Numeric rank indicating the order of preference among multiple approved suppliers within the same category and plant scope. Rank 1 indicates the highest-priority preferred supplier.. Valid values are `^[1-9][0-9]*$`',
    `procurement_type` STRING COMMENT 'Classification of the procurement spend type: direct materials (production-related), indirect materials, services, capital expenditure (CAPEX), or maintenance, repair, and operations (MRO).. Valid values are `direct|indirect|services|capex|mro`',
    `psl_number` STRING COMMENT 'Business-facing alphanumeric identifier for the preferred supplier list entry, used in procurement communications and audit trails.. Valid values are `^PSL-[0-9]{4}-[0-9]{6}$`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code representing the procurement entity responsible for managing this supplier preference, enabling multi-org governance.',
    `reach_compliant` BOOLEAN COMMENT 'Indicates whether the supplier has confirmed compliance with EU REACH Regulation for the designated category, required for chemical and material procurement.. Valid values are `true|false`',
    `region_code` STRING COMMENT 'Geographic region code (e.g., EMEA, APAC, AMER) for which this supplier preference is valid, supporting multinational procurement governance.',
    `rohs_compliant` BOOLEAN COMMENT 'Indicates whether the supplier has confirmed compliance with EU RoHS Directive for the designated category, required for electronics and electrical equipment procurement.. Valid values are `true|false`',
    `single_source_justification` STRING COMMENT 'Documented business justification for sole-source designation, required when is_single_source is true. Captures technical, commercial, or regulatory reasons for limiting to one supplier.',
    `sourcing_event_reference` STRING COMMENT 'Reference to the SAP Ariba sourcing event (RFQ/RFP) that resulted in this supplier being designated as preferred, providing traceability to the competitive sourcing process.',
    `sourcing_strategy` STRING COMMENT 'Procurement sourcing strategy alignment for this supplier-category combination, indicating whether the supplier is a sole source, one of multiple approved sources, or part of a strategic partnership.. Valid values are `single_source|dual_source|multi_source|preferred_with_backup|strategic_partnership`',
    `spend_allocation_percent` DECIMAL(18,2) COMMENT 'Target percentage of category spend to be directed to this supplier as part of a multi-source or quota-based sourcing strategy. Supports spend distribution governance.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `status` STRING COMMENT 'Current lifecycle status of the preferred supplier list entry, controlling whether buyers may use this supplier for the designated category.. Valid values are `active|inactive|under_review|suspended|expired`',
    `supplier_code` STRING COMMENT 'Unique vendor identifier from the supplier master, referencing the approved supplier in SAP S/4HANA or SAP Ariba.',
    `valid_from_date` DATE COMMENT 'Start date from which this preferred supplier designation is effective and buyers may direct spend to this supplier for the designated category.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'Expiry date after which this preferred supplier designation is no longer valid and must be renewed or replaced through the qualification and sourcing process.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_preferred_supplier_list PRIMARY KEY(`preferred_supplier_list_id`)
) COMMENT 'Maintains the approved and preferred supplier registry per spend category, plant, and region. Captures supplier preference tier (preferred, approved, conditional, restricted), valid period, category scope, sourcing strategy alignment, and the business rationale for preference designation. Enforces procurement policy by directing buyers to qualified, strategically aligned suppliers.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supplier_performance` (
    `supplier_performance_id` BIGINT COMMENT 'Primary key for supplier_performance',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: supplier_performance scorecard should directly reference supplier master. Adding supplier_id FK enables direct supplier lookup (note: this may already exist but not visible in attribute list).',
    CONSTRAINT pk_supplier_performance PRIMARY KEY(`supplier_performance_id`)
) COMMENT 'Periodic supplier performance scorecard capturing OTD (On-Time Delivery), quality PPM (Parts Per Million defect rate), fill rate, invoice accuracy, responsiveness score, and overall supplier rating. Supports strategic supplier relationship management, re-qualification decisions, and preferred supplier list maintenance. Sourced from SAP Ariba and cross-referenced with quality and logistics data.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` (
    `supplier_risk_id` BIGINT COMMENT 'Unique system-generated identifier for each supplier risk assessment record in the procurement domain.',
    `supplier_id` BIGINT COMMENT 'FK to procurement.supplier',
    `supplier_qualification_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supplier_qualification. Business justification: Supplier risk assessments should reference the qualification record to understand approval status, compliance certifications (ISO, REACH, RoHS), and qualification stage. Risk tier and severity in supp',
    `third_party_risk_id` BIGINT COMMENT 'Foreign key linking to compliance.third_party_risk. Business justification: Supplier risk assessments include compliance-related third-party risks (financial, ethical, regulatory). Procurement uses these assessments for supplier selection and ongoing monitoring per enterprise',
    `actual_resolution_date` DATE COMMENT 'Actual date on which the supplier risk was resolved, closed, or reduced to an acceptable residual risk level, used for risk management performance reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `affected_material_group` STRING COMMENT 'SAP material group or commodity category code identifying the materials or components affected by this supplier risk, used for impact scoping and MRP/MRP II planning adjustments.',
    `affected_plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or site most exposed to this supplier risk, used for localized supply chain resilience planning and production impact assessment.',
    `annual_spend_amount` DECIMAL(18,2) COMMENT 'Total annual procurement spend with this supplier in the reporting currency, used to contextualize the financial exposure and prioritize risk mitigation investment.',
    `ariba_risk_reference` STRING COMMENT 'External reference identifier for this supplier risk record in SAP Ariba Supplier Risk Management module, enabling cross-system traceability and data lineage.',
    `assessment_date` DATE COMMENT 'Date on which the formal risk assessment (scoring, categorization, and impact analysis) was completed for this supplier risk record.. Valid values are `^d{4}-d{2}-d{2}$`',
    `business_continuity_plan_status` STRING COMMENT 'Status of the suppliers Business Continuity Plan (BCP) submission and verification, indicating preparedness for supply disruption events such as natural disasters, pandemics, or facility outages.. Valid values are `verified|submitted|not_submitted|expired|not_required`',
    `conflict_minerals_status` STRING COMMENT 'Supplier compliance status with conflict minerals regulations (3TG: tantalum, tin, tungsten, gold) under Dodd-Frank Section 1502 and EU Conflict Minerals Regulation, requiring responsible sourcing declarations.. Valid values are `compliant|non_compliant|not_applicable|under_review|pending_declaration`',
    `contingency_plan` STRING COMMENT 'Documented fallback plan to be activated if the supplier risk materializes, including alternative supply sources, emergency procurement procedures, and production adjustment protocols.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the supplier risk record was first created in the system, used for audit trail, data lineage, and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the estimated financial impact amount, supporting multi-currency reporting in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `escalation_date` DATE COMMENT 'Date on which the supplier risk was formally escalated to senior management or executive leadership, used for escalation tracking and SLA compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `estimated_financial_impact` DECIMAL(18,2) COMMENT 'Estimated monetary value of the potential financial impact to the business if the supplier risk materializes, including production downtime costs, expediting costs, and revenue loss.',
    `financial_risk_rating` STRING COMMENT 'Credit or financial health rating assigned to the supplier (e.g., Dun & Bradstreet PAYDEX, Moodys, S&P rating), reflecting solvency and creditworthiness risk to supply continuity.',
    `financial_risk_score` DECIMAL(18,2) COMMENT 'Numeric financial risk score (e.g., 0–100) derived from credit rating, payment history, and solvency indicators, used to assess supplier financial stability and procurement exposure.',
    `geopolitical_risk_score` DECIMAL(18,2) COMMENT 'Numeric score quantifying geopolitical risk associated with the suppliers country of operation, including trade sanctions, political instability, export controls, and tariff exposure.',
    `identification_date` DATE COMMENT 'Date on which the supplier risk was first identified and formally recorded, used for risk aging analysis and compliance audit trails.. Valid values are `^d{4}-d{2}-d{2}$`',
    `impact_score` DECIMAL(18,2) COMMENT 'Quantitative score (1.00 to 10.00) representing the magnitude of business impact if the supplier risk materializes, covering supply disruption, financial loss, and compliance exposure.. Valid values are `^([1-9]|10)(.d{1,2})?$`',
    `is_escalated` BOOLEAN COMMENT 'Indicates whether this supplier risk has been escalated to senior management or executive leadership due to severity, urgency, or lack of mitigation progress.. Valid values are `true|false`',
    `is_single_source` BOOLEAN COMMENT 'Indicates whether this supplier is the sole qualified source for one or more critical materials or components, representing a single-source dependency risk to production continuity.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the supplier risk record, used for change tracking, data freshness monitoring, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `mitigation_actions` STRING COMMENT 'Detailed description of specific corrective and preventive actions (CAPA) being taken to mitigate the supplier risk, including timelines, responsible parties, and expected outcomes.',
    `mitigation_strategy` STRING COMMENT 'Primary strategic approach selected to mitigate the identified supplier risk, such as dual sourcing, safety stock increase, alternative supplier qualification, or contractual protection clauses.. Valid values are `dual_sourcing|safety_stock_increase|alternative_supplier_qualification|supplier_development|contractual_protection|geographic_diversification|vertical_integration|demand_reduction|insurance|monitoring_only|no_action`',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of this supplier risk assessment, ensuring risk scores and mitigation actions remain current and relevant.. Valid values are `^d{4}-d{2}-d{2}$`',
    `origin_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the suppliers primary manufacturing or supply origin, used for geopolitical risk assessment, trade compliance, and supply chain diversification analysis.. Valid values are `^[A-Z]{3}$`',
    `probability_score` DECIMAL(18,2) COMMENT 'Quantitative likelihood score (0.00 to 1.00) representing the probability that the supplier risk event will occur within the assessment horizon, used in risk scoring models.. Valid values are `^(0(.d{1,2})?|1(.0{1,2})?)$`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for managing the supplier relationship and procurement activities associated with this risk, used for organizational scoping and reporting.',
    `reach_compliance_status` STRING COMMENT 'Supplier compliance status with EU REACH (Registration, Evaluation, Authorisation and Restriction of Chemicals) regulation, critical for direct materials used in industrial manufacturing products.. Valid values are `compliant|non_compliant|not_applicable|under_review`',
    `regulatory_compliance_status` STRING COMMENT 'Overall regulatory compliance status of the supplier covering applicable regulations including REACH, RoHS, conflict minerals (Dodd-Frank Section 1502), CE Marking, and GDPR.. Valid values are `compliant|non_compliant|under_review|not_assessed|exempted`',
    `risk_description` STRING COMMENT 'Detailed narrative describing the supplier risk, its root cause, potential triggers, and context relevant to supply chain resilience planning.',
    `risk_number` STRING COMMENT 'Human-readable business reference number for the supplier risk record, used for tracking and communication across procurement and supply chain teams.. Valid values are `^SR-[0-9]{4}-[0-9]{6}$`',
    `risk_owner` STRING COMMENT 'Name or employee ID of the procurement or supply chain professional accountable for managing and monitoring this supplier risk through to resolution.',
    `risk_owner_department` STRING COMMENT 'Organizational department of the risk owner (e.g., Strategic Sourcing, Supply Chain, Procurement Compliance), used for accountability reporting and escalation routing.',
    `risk_score` DECIMAL(18,2) COMMENT 'Composite risk score derived from probability and impact scores, used to rank and prioritize supplier risks for supply chain resilience planning and executive reporting.',
    `risk_subcategory` STRING COMMENT 'Secondary classification providing granular detail within the risk category (e.g., within financial: credit_rating, insolvency, liquidity; within regulatory: reach, rohs, conflict_minerals, sanctions).',
    `risk_tier` STRING COMMENT 'Supplier risk tier classification indicating the overall risk exposure level of the supplier (Tier 1: highest risk, Tier 3: lowest risk), used for portfolio-level supply chain risk management.. Valid values are `tier_1|tier_2|tier_3`',
    `risk_title` STRING COMMENT 'Short descriptive title summarizing the nature of the supplier risk, used in dashboards, escalation reports, and executive summaries.',
    `rohs_compliance_status` STRING COMMENT 'Supplier compliance status with EU RoHS (Restriction of Hazardous Substances) Directive, applicable to electrical and electronic components supplied for automation and electrification products.. Valid values are `compliant|non_compliant|not_applicable|under_review`',
    `sanctions_screening_status` STRING COMMENT 'Result of sanctions and export control screening for the supplier against OFAC SDN list, EU restrictive measures, and other applicable trade compliance watchlists.. Valid values are `cleared|flagged|pending|not_screened`',
    `severity` STRING COMMENT 'Qualitative severity rating of the supplier risk based on potential business impact if the risk materializes, used for prioritization and escalation decisions.. Valid values are `critical|high|medium|low`',
    `single_source_material_count` STRING COMMENT 'Number of distinct materials or components for which this supplier is the only qualified source, used to quantify the breadth of single-source dependency risk.',
    `spend_concentration_percent` DECIMAL(18,2) COMMENT 'Percentage of total category or commodity spend concentrated with this supplier, used to assess over-reliance and diversification risk in strategic sourcing.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.d{1,2})?)$`',
    `status` STRING COMMENT 'Current lifecycle status of the supplier risk assessment record, governing workflow and visibility in supply chain resilience planning.. Valid values are `draft|active|under_review|escalated|closed|superseded`',
    `target_resolution_date` DATE COMMENT 'Target date by which the supplier risk is expected to be mitigated, resolved, or reduced to an acceptable level through the defined mitigation strategy.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_supplier_risk PRIMARY KEY(`supplier_risk_id`)
) COMMENT 'Tracks procurement and supply chain risk assessments for individual suppliers including financial risk (credit rating, solvency), geopolitical risk, single-source dependency risk, regulatory compliance risk (REACH, RoHS, conflict minerals), and business continuity risk. Captures risk category, risk score, mitigation actions, and review dates. Supports supply chain resilience planning.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` (
    `sourcing_award_id` BIGINT COMMENT 'Unique system-generated identifier for the sourcing award record. Serves as the primary key for this entity in the procurement data lakehouse.',
    `incoterm_id` BIGINT COMMENT 'Foreign key linking to procurement.incoterm. Business justification: Sourcing awards specify incoterms as part of the awarded commercial terms. Linking to the incoterm reference table ensures standardized trade term validation. incoterms_code is retained as a natural k',
    `procurement_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_contract. Business justification: Sourcing award outcomes often result in formal procurement contracts. The outcome_document_type and outcome_document_number indicate contract creation, but the FK enables direct linkage. This link ena',
    `procurement_payment_term_id` BIGINT COMMENT 'Foreign key linking to procurement.payment_term. Business justification: Sourcing awards specify payment terms as part of the awarded commercial terms. Linking to the payment_term reference table ensures standardized payment term validation. payment_terms_code is retained ',
    `sourcing_bid_id` BIGINT COMMENT 'Foreign key linking to procurement.sourcing_bid. Business justification: A sourcing award references the specific winning bid that was selected. This traceability is critical for procurement audit trails and savings validation. bid_number is retained as a business key.',
    `sourcing_event_id` BIGINT COMMENT 'Foreign key linking to procurement.sourcing_event. Business justification: A sourcing award is the formal outcome decision of a sourcing event. This is a fundamental relationship in the sourcing lifecycle — awards cannot exist without a parent sourcing event. sourcing_event_',
    `spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_spend_category. Business justification: Sourcing award references spend category via category_code (STRING). Adding FK for referential integrity, removing redundant string field.',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Sourcing awards are made to specific supplier organizations. The table stores supplier_code and supplier_name. Adding supplier_id FK normalizes this relationship; supplier_name is redundant once the F',
    `approval_status` STRING COMMENT 'Status of the internal approval workflow for the sourcing award. Reflects whether the award has been reviewed and authorized by the required procurement approvers per the release strategy.. Valid values are `pending|approved|rejected|escalated|withdrawn`',
    `approved_by` STRING COMMENT 'Name or employee ID of the procurement authority who formally approved the sourcing award. Required for audit trail and segregation of duties compliance.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the sourcing award received final internal approval. Provides a precise audit timestamp for compliance reporting and procurement cycle time analysis.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `ariba_award_reference` STRING COMMENT 'Native award document identifier from SAP Ariba Sourcing. Used for cross-system reconciliation between the data lakehouse and the SAP Ariba source system.',
    `award_basis` STRING COMMENT 'The primary criterion or rationale used to select the winning supplier. Supports audit compliance and sourcing strategy documentation required under procurement governance policies.. Valid values are `lowest_price|best_value|technical_merit|strategic_fit|incumbent_retention|sole_source|negotiated`',
    `award_date` DATE COMMENT 'The business date on which the sourcing award decision was formally made and recorded. Used as the reference date for contract start, PO creation, and savings realization tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `award_number` STRING COMMENT 'Business-facing unique identifier for the sourcing award, used in procurement communications, contract initiation, and audit trails. Typically generated by SAP Ariba at the conclusion of a sourcing event.. Valid values are `^AWD-[0-9]{4}-[0-9]{6}$`',
    `award_rationale` STRING COMMENT 'Free-text narrative documenting the business justification for the award decision, including evaluation criteria weighting, supplier differentiators, and any deviations from standard sourcing policy. Required for audit compliance.',
    `award_split_percent` DECIMAL(18,2) COMMENT 'For multi-source (split) awards, the percentage of total business volume allocated to this supplier. All award records for the same sourcing event line item must sum to 100%. Null for single-source awards.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `award_type` STRING COMMENT 'Classifies the nature of the award decision. Full award grants all business to one supplier; split award distributes across multiple suppliers; conditional award is subject to further negotiation or compliance verification.. Valid values are `full_award|partial_award|split_award|conditional_award|no_award`',
    `award_valid_from_date` DATE COMMENT 'The start date from which the awarded pricing and terms are commercially effective. Defines the beginning of the award validity period for contract or PO creation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `award_valid_to_date` DATE COMMENT 'The expiry date of the awards commercial terms. After this date, the awarded pricing is no longer valid and a new sourcing event or renegotiation may be required.. Valid values are `^d{4}-d{2}-d{2}$`',
    `awarded_quantity` DECIMAL(18,2) COMMENT 'The quantity of material or service formally awarded to the supplier in this award record. For split awards, this represents the portion allocated to this specific supplier.',
    `awarded_total_value` DECIMAL(18,2) COMMENT 'Total monetary value of the award, calculated as awarded quantity multiplied by awarded unit price. Used for spend commitment tracking, savings reporting, and contract value initialization.',
    `awarded_unit_price` DECIMAL(18,2) COMMENT 'The negotiated unit price agreed upon in the award decision. This is the commercially sensitive price that will be used as the basis for the resulting purchase order or contract.',
    `baseline_unit_price` DECIMAL(18,2) COMMENT 'The reference unit price used as the cost baseline prior to the sourcing event (e.g., incumbent price, market benchmark, or last purchase price). Used to calculate realized savings from the award.',
    `bid_number` STRING COMMENT 'Reference to the specific supplier bid that was selected for this award. Provides traceability from the award decision back to the evaluated bid submission.',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the awarded material is manufactured or the service is delivered. Required for customs, import duty calculation, and RoHS/REACH compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the sourcing award record was first created in the source system. Supports data lineage, audit compliance, and procurement cycle time measurement.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the awarded price and value (e.g., USD, EUR, CNY). Supports multi-currency operations across global manufacturing sites.. Valid values are `^[A-Z]{3}$`',
    `evaluation_score` DECIMAL(18,2) COMMENT 'The composite evaluation score assigned to the awarded suppliers bid during the sourcing event evaluation process. Reflects weighted scoring across price, quality, delivery, and technical criteria.',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the delivery obligations, risk transfer point, and cost responsibilities between buyer and supplier as agreed in the award.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the sourcing award record. Used for incremental data loading, change detection, and audit trail maintenance in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lead_time_days` STRING COMMENT 'The supplier-committed lead time in calendar days from purchase order placement to goods receipt, as agreed in the award. Used to update the SAP material info record and drive MRP planning.',
    `line_item_number` STRING COMMENT 'Identifies the specific line item within the sourcing event to which this award applies. A single sourcing event may produce multiple award records, one per line item or lot.',
    `material_description` STRING COMMENT 'Short description of the material or service being awarded, as defined in the SAP material master or sourcing event line item. Supports readability in reports and award notifications.',
    `material_number` STRING COMMENT 'SAP material number identifying the direct or indirect material being sourced. Links the award to the material master for MRP and inventory planning purposes.',
    `outcome_document_type` STRING COMMENT 'Specifies the type of downstream procurement document to be created as a result of this award (e.g., standard PO, blanket PO, supply agreement). Drives the post-award workflow in SAP S/4HANA.. Valid values are `purchase_order|blanket_po|supply_agreement|scheduling_agreement|info_record_update|no_document`',
    `payment_terms_code` STRING COMMENT 'SAP payment terms code agreed as part of the award (e.g., NT30, 2/10NET30). Defines the payment schedule and any early payment discount conditions to be applied to resulting invoices.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility that will receive the awarded materials. Used for MRP planning, inventory management, and delivery scheduling.',
    `price_unit` DECIMAL(18,2) COMMENT 'The quantity basis for the awarded unit price (e.g., price per 1, per 100, per 1000 units). Aligns with SAP pricing condition logic in MM purchasing.',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for executing this award. Defines the organizational unit with commercial authority and supplier relationship ownership.',
    `quantity_uom` STRING COMMENT 'Unit of measure for the awarded quantity (e.g., EA, KG, M, L, HR). Aligns with the SAP base unit of measure defined in the material master.',
    `savings_amount` DECIMAL(18,2) COMMENT 'Monetary savings realized through the award compared to the baseline price, expressed in the award currency. Calculated as (baseline unit price - awarded unit price) × awarded quantity. Key KPI for procurement performance reporting.',
    `savings_percent` DECIMAL(18,2) COMMENT 'Percentage savings achieved through the award relative to the baseline spend. Expressed as (savings_amount / baseline_total_value) × 100. Used in procurement KPI dashboards and executive reporting.',
    `sourcing_event_number` STRING COMMENT 'Reference to the sourcing event (RFQ/RFP/auction) from which this award was generated. Links the award back to the competitive bidding process.',
    `status` STRING COMMENT 'Current lifecycle status of the sourcing award. Tracks progression from internal draft through supplier acceptance or rejection, supporting procurement workflow governance.. Valid values are `draft|pending_approval|approved|published|accepted|rejected|cancelled|superseded`',
    `supplier_acceptance_date` DATE COMMENT 'The date on which the supplier formally accepted the award terms. Marks the point of mutual agreement and triggers downstream contract or PO creation activities.. Valid values are `^d{4}-d{2}-d{2}$`',
    `supplier_acceptance_status` STRING COMMENT 'Tracks whether the awarded supplier has formally accepted, rejected, or counter-proposed the award terms. Required for contract formation and procurement workflow completion.. Valid values are `pending|accepted|rejected|counter_proposed|expired`',
    `supplier_code` STRING COMMENT 'Unique identifier for the supplier receiving this award, as registered in SAP S/4HANA MM and SAP Ariba. Used to link the award to the supplier master record.',
    `supplier_notification_date` DATE COMMENT 'The date on which the supplier was formally notified of the award decision. Supports SLA tracking for award communication and supplier relationship management.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_sourcing_award PRIMARY KEY(`sourcing_award_id`)
) COMMENT 'Records the formal award decision made at the conclusion of a sourcing event, specifying which supplier(s) received the business, awarded quantities, awarded unit prices, award split percentages (for multi-source awards), and the rationale for the award decision. Links sourcing events to resulting procurement contracts or purchase orders.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` (
    `spend_transaction_id` BIGINT COMMENT 'Unique surrogate identifier for each spend transaction record in the Silver layer lakehouse. Serves as the primary key for all downstream analytics and reporting joins.',
    `it_cost_allocation_id` BIGINT COMMENT 'Foreign key linking to technology.it_cost_allocation. Business justification: IT-related procurement spend transactions link to IT cost allocation for chargeback, budget tracking, and financial reporting. Finance and IT use this daily to reconcile IT spending against department',
    `journal_entry_id` BIGINT COMMENT 'Foreign key linking to finance.journal_entry. Business justification: Spend transactions generate journal entries for financial recording. Finance teams trace procurement spend to GL postings for audit trails and financial statement preparation.',
    `procurement_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_contract. Business justification: Spend transaction references contract via contract_number (STRING). Adding FK for referential integrity, removing redundant string field.',
    `procurement_goods_receipt_id` BIGINT COMMENT 'Foreign key linking to procurement.goods_receipt. Business justification: Spend transactions reference goods receipts for three-way match validation. The table has grn_number. Adding goods_receipt_id FK enables spend analytics to be traced back to the physical receipt event',
    `procurement_material_info_record_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_material_info_record. Business justification: Spend transactions should reference the purchasing info record that defines the material-supplier pricing relationship. This link enables variance analysis (contracted_unit_price vs invoiced_unit_pric',
    `procurement_payment_term_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_payment_term. Business justification: Spend transaction references payment term via payment_terms_code (STRING). Adding FK for referential integrity, removing redundant string field.',
    `procurement_po_line_item_id` BIGINT COMMENT 'Foreign key linking to procurement.po_line_item. Business justification: Spend transactions are derived from specific PO line items and represent the actual spend against each line. The table has po_number and po_line_number. Adding po_line_item_id FK enables granular spen',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Spend transactions are derived from posted purchase orders and represent actual procurement spend. The table has po_number. Adding purchase_order_id FK enables spend analytics to be traced back to the',
    `procurement_supplier_invoice_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_invoice. Business justification: Spend transactions are also derived from posted supplier invoices. The table has invoice_number. Adding supplier_invoice_id FK enables spend analytics to be traced back to the originating invoice for ',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Procurement spend allocates to profit centers for segment profitability analysis. Controllers use this for product line P&L and business unit performance measurement.',
    `spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.spend_category. Business justification: Spend transactions are classified by spend category for spend analytics and reporting. The table stores category_code and category_name. Adding spend_category_id FK normalizes this relationship; categ',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Spend transactions are associated with specific supplier organizations. The table stores supplier_code and supplier_name. Adding supplier_id FK normalizes this relationship; supplier_name is redundant',
    `category_code` STRING COMMENT 'The procurement spend category code from the SAP Ariba category taxonomy assigned to this transaction. Enables category-level spend analytics, savings tracking, and strategic sourcing alignment.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity within the corporate group to which this spend transaction is financially attributed. Required for entity-level financial reporting, intercompany elimination, and IFRS/GAAP consolidation.',
    `contracted_unit_price` DECIMAL(18,2) COMMENT 'The agreed contracted unit price from the supply agreement or purchase order info record at the time of the transaction. Used as the baseline for savings tracking and price compliance analysis against actual invoiced price.',
    `cost_center` STRING COMMENT 'SAP CO cost center to which the spend transaction is charged. Enables departmental spend allocation, budget vs. actuals reporting, and internal cost management.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the suppliers country of origin for this transaction. Supports geographic spend analysis, import duty assessment, trade compliance, and supply risk monitoring.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this spend transaction record was first created in the Silver layer lakehouse. Used for data lineage, audit trail, and incremental load processing.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the transaction currency in which the spend was originally recorded (e.g., USD, EUR, CNY). Required for multi-currency spend normalization and FX analysis.. Valid values are `^[A-Z]{3}$`',
    `document_date` DATE COMMENT 'The date on the originating source document (e.g., supplier invoice date or goods receipt note date). May differ from posting date and is used for payment terms calculation and audit trails.. Valid values are `d{4}-d{2}-d{2}`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign exchange rate applied at posting date to convert the transaction currency amount to the local currency. Required for FX impact analysis and currency risk reporting.',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this spend transaction belongs, as determined by the company code fiscal year variant in SAP S/4HANA. Used for annual spend reporting, budget vs. actuals, and EBITDA analysis.. Valid values are `^d{4}$`',
    `gl_account_code` STRING COMMENT 'The General Ledger (GL) account code in SAP S/4HANA to which the spend transaction is posted. Enables financial statement mapping, COGS vs. OPEX vs. CAPEX classification, and audit trail.',
    `grn_number` STRING COMMENT 'Reference to the Goods Receipt Note (GRN) material document number from SAP S/4HANA that triggered or is matched to this spend transaction. Essential for three-way match and accrual accuracy.',
    `gross_amount` DECIMAL(18,2) COMMENT 'The total gross spend amount including taxes in the transaction currency. Used for total cost of ownership analysis and accounts payable reconciliation.',
    `invoice_number` STRING COMMENT 'The supplier-issued invoice number associated with this spend transaction. Used for three-way match (PO–Goods Receipt Note–Invoice), duplicate invoice detection, and accounts payable reconciliation.',
    `invoiced_unit_price` DECIMAL(18,2) COMMENT 'The actual unit price as invoiced by the supplier for this transaction. Compared against the contracted unit price to identify price variances, maverick spend, and savings realization.',
    `is_contract_backed` BOOLEAN COMMENT 'Flag indicating whether this spend transaction is backed by an active supply agreement or procurement contract. Used to calculate spend under management (SUM) rate and contract compliance metrics.. Valid values are `true|false`',
    `is_maverick_spend` BOOLEAN COMMENT 'Flag indicating whether this spend transaction was executed outside of approved contracts, preferred suppliers, or established procurement channels. Key metric for procurement compliance reporting and spend under management tracking.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this spend transaction record in the Silver layer. Supports change data capture, audit compliance, and data freshness monitoring.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}`',
    `local_currency_amount` DECIMAL(18,2) COMMENT 'The net spend amount converted to the company code local currency using the exchange rate at posting date. Enables consistent spend reporting across multi-currency multinational operations.',
    `local_currency_code` STRING COMMENT 'ISO 4217 three-letter code for the company code local currency to which the spend amount has been converted. Supports multi-currency consolidation and regional financial reporting.. Valid values are `^[A-Z]{3}$`',
    `material_description` STRING COMMENT 'Short text description of the material or service procured, as maintained in the SAP material master. Provides human-readable context in spend reports without requiring a join to the material master table.',
    `material_group` STRING COMMENT 'SAP material group code classifying the procured material or service into a commodity grouping. Used for spend categorization, sourcing strategy alignment, and category management reporting.',
    `material_number` STRING COMMENT 'The SAP material master number identifying the direct or indirect material/service procured in this transaction. Enables material-level spend analysis, COGS attribution, and Bill of Materials (BOM) cost rollup.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility where the procured goods or services are consumed. Enables plant-level spend analysis, cost allocation, and regional procurement reporting.',
    `po_line_number` STRING COMMENT 'The specific line item number on the originating Purchase Order (PO) to which this spend transaction is attributed. Enables granular spend analysis at the material/service line level.',
    `po_number` STRING COMMENT 'Reference to the originating Purchase Order (PO) number from SAP S/4HANA MM. Links spend transactions back to the approved procurement commitment for three-way match validation and contract compliance tracking.',
    `procurement_type` STRING COMMENT 'Classifies the spend transaction as direct material (production-related), indirect (non-production), capital expenditure (CAPEX), services, or Maintenance Repair and Operations (MRO). Fundamental for spend cube segmentation and P&L attribution.. Valid values are `direct|indirect|capex|services|mro`',
    `profit_center` STRING COMMENT 'SAP CO profit center to which the spend transaction is attributed for internal profitability reporting. Enables segment-level P&L analysis and management accounting.',
    `purchasing_group_code` STRING COMMENT 'SAP purchasing group (buyer group) code identifying the individual buyer or team responsible for this spend transaction. Enables buyer-level spend reporting and workload analysis.',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for negotiating and managing the procurement contract under which this spend transaction was executed. Used for organizational spend reporting and procurement KPI tracking.',
    `quantity` DECIMAL(18,2) COMMENT 'The quantity of material or service units covered by this spend transaction. Combined with unit price to derive spend amount and used for volume-based spend analysis.',
    `savings_amount` DECIMAL(18,2) COMMENT 'The calculated savings amount for this transaction, derived as the difference between the baseline/contracted price and the actual invoiced price multiplied by quantity. Foundational metric for procurement savings reporting and category management performance tracking.',
    `savings_type` STRING COMMENT 'Classification of the savings associated with this spend transaction. Distinguishes between hard savings (realized P&L impact), soft savings (efficiency gains), cost avoidance, supplier rebates, and early payment discounts for accurate procurement value reporting.. Valid values are `hard_savings|soft_savings|cost_avoidance|rebate|early_payment_discount`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this spend transaction was sourced (e.g., SAP S/4HANA, SAP Ariba). Required for data lineage, reconciliation, and multi-system spend consolidation.. Valid values are `SAP_S4HANA|SAP_ARIBA|MANUAL`',
    `spend_amount` DECIMAL(18,2) COMMENT 'The net spend amount of the transaction in the transaction currency, excluding taxes. Core metric for spend analytics, category management reporting, and savings tracking against contracted prices.',
    `status` STRING COMMENT 'Current processing status of the spend transaction in the financial ledger. Drives inclusion/exclusion in spend analytics and savings tracking reports.. Valid values are `posted|reversed|parked|blocked|cleared|disputed`',
    `supplier_code` STRING COMMENT 'The vendor account number from SAP S/4HANA identifying the supplier associated with this spend transaction. Used for supplier-level spend aggregation, performance correlation, and category management.',
    `tax_amount` DECIMAL(18,2) COMMENT 'The tax amount (e.g., VAT, GST, sales tax) associated with this spend transaction in the transaction currency. Required for tax reporting, recoverable input tax analysis, and compliance with local tax regulations.',
    `transaction_number` STRING COMMENT 'Business-facing unique transaction reference number derived from the source ERP system (SAP S/4HANA FI/CO). Used for reconciliation between procurement and finance.',
    `transaction_type` STRING COMMENT 'Classification of the spend transaction by its originating document type. Distinguishes between standard Purchase Order (PO)-based spend, blanket order releases, Evaluated Receipt Settlement (ERS), credit/debit memos, and intercompany transactions.. Valid values are `purchase_order|blanket_order_release|evaluated_receipt_settlement|credit_memo|debit_memo|invoice_adjustment|intercompany`',
    `unit_of_measure` STRING COMMENT 'The unit of measure (UoM) for the transaction quantity (e.g., EA, KG, L, M, HR). Required for quantity normalization across spend analytics and supplier performance benchmarking.',
    `wbs_element` STRING COMMENT 'SAP Project System Work Breakdown Structure (WBS) element to which the spend is allocated when the purchase is project-related (e.g., CAPEX projects, R&D programs). Enables project-level spend tracking and CAPEX reporting.',
    CONSTRAINT pk_spend_transaction PRIMARY KEY(`spend_transaction_id`)
) COMMENT 'Granular record of actual procurement spend transactions derived from posted purchase orders and invoices. Captures supplier, spend category, material, plant, cost center, WBS element, spend amount, currency, fiscal period, and PO reference. Serves as the foundational dataset for spend analytics, category management reporting, and savings tracking against contracted prices.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` (
    `savings_initiative_id` BIGINT COMMENT 'Unique system-generated identifier for each procurement savings or cost avoidance initiative record in the lakehouse silver layer.',
    `procurement_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_contract. Business justification: Savings initiatives are tracked against specific procurement contracts that formalize the negotiated savings. The table has contract_reference. Adding procurement_contract_id FK enables savings realiz',
    `sourcing_event_id` BIGINT COMMENT 'Foreign key linking to procurement.sourcing_event. Business justification: Savings initiatives are often tied to specific sourcing events that generated the savings opportunity. The table has sourcing_event_reference. Adding sourcing_event_id FK enables savings tracking back',
    `spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.spend_category. Business justification: Savings initiatives are organized by spend category for category management reporting. The table stores category_code and category_name. Adding spend_category_id FK normalizes this relationship; categ',
    `supplier_id` BIGINT COMMENT 'FK to procurement.supplier',
    `supplier_performance_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supplier_performance. Business justification: Savings initiatives should track their impact on supplier performance metrics. Cost reduction initiatives may affect OTD, quality PPM, or responsiveness. This link enables analysis of whether savings ',
    `approval_date` DATE COMMENT 'Date on which the savings initiative was formally approved by the authorized approver (e.g., CPO, Finance Controller), enabling it to be counted in the approved savings pipeline.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `approved_by` STRING COMMENT 'Name or employee ID of the authorized approver (e.g., CPO, Finance Controller, Procurement Director) who validated and approved the savings initiative.',
    `ariba_initiative_reference` STRING COMMENT 'Native identifier of the savings initiative record in SAP Ariba Savings Management module, used for system-of-record traceability and data lineage in the lakehouse.',
    `baseline_price` DECIMAL(18,2) COMMENT 'The reference unit price or total spend amount used as the starting point for calculating savings. Typically the prior-year price, market benchmark, or should-cost model output.',
    `baseline_spend_amount` DECIMAL(18,2) COMMENT 'Total annualized or period spend at the baseline price, representing the reference spend level before the savings initiative is applied. Used to compute total savings value.',
    `category_code` STRING COMMENT 'Procurement spend category code associated with the savings initiative, aligned to the internal category taxonomy (e.g., direct materials, MRO, logistics, IT services).',
    `company_code` STRING COMMENT 'SAP company code of the legal entity to which the savings initiative is attributed for financial reporting and IFRS/GAAP compliance.',
    `contract_reference` STRING COMMENT 'Reference to the procurement contract or outline agreement in SAP S/4HANA or SAP Ariba that formalizes the negotiated savings terms.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the primary geography where the savings initiative is executed, supporting regional CPO reporting and multi-country spend analytics.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the savings initiative record was first created in the source system (SAP Ariba), used for audit trail and data lineage in the lakehouse silver layer.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which all monetary amounts for this savings initiative are denominated (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Detailed narrative describing the scope, approach, and expected outcomes of the savings initiative, including levers applied (e.g., demand reduction, specification change, supplier consolidation).',
    `finance_validated` BOOLEAN COMMENT 'Indicates whether the savings amount has been independently validated by the Finance Controller or CFO organization, a prerequisite for counting savings in official financial reporting.. Valid values are `true|false`',
    `fiscal_period` STRING COMMENT 'The specific fiscal period (year-month) within the fiscal year to which the savings are attributed, enabling monthly CPO reporting and period-over-period variance analysis.. Valid values are `^[0-9]{4}-(0[1-9]|1[0-2])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year to which the savings initiative is attributed for CPO KPI reporting, budget planning, and financial performance tracking.. Valid values are `^[0-9]{4}$`',
    `identification_date` DATE COMMENT 'Date on which the savings opportunity was first identified and logged, used for pipeline age analysis and procurement funnel reporting.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `initiative_number` STRING COMMENT 'Business-facing unique reference number for the savings initiative, used in CPO reporting, procurement KPI dashboards, and cross-functional communications.. Valid values are `^SI-[0-9]{4}-[0-9]{6}$`',
    `initiative_owner` STRING COMMENT 'Name of the procurement professional or category manager responsible for driving and delivering the savings initiative.',
    `initiative_type` STRING COMMENT 'Classification of the savings initiative by type. Hard savings represent realized reductions in actual spend. Soft savings represent efficiency gains or avoided costs not directly reflected in budget. Cost avoidance captures spend prevented from increasing. Other types reflect specific procurement levers applied.. Valid values are `hard_savings|soft_savings|cost_avoidance|demand_reduction|process_efficiency|specification_change|supplier_consolidation|payment_terms_improvement`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the savings initiative record in the source system, used for incremental data loading, change detection, and audit trail in the lakehouse.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `measurement_period_end_date` DATE COMMENT 'End date of the period over which savings are measured and validated, typically aligned to contract expiry date or fiscal year end.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `measurement_period_start_date` DATE COMMENT 'Start date of the period over which savings are measured and validated, typically aligned to contract effective date or fiscal year start.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `negotiated_price` DECIMAL(18,2) COMMENT 'The unit price or total spend amount agreed upon after negotiation or sourcing event, used to calculate the savings delta against the baseline price.',
    `notes` STRING COMMENT 'Free-text field for capturing additional context, assumptions, constraints, or commentary related to the savings initiative, such as volume assumptions, risk factors, or negotiation background.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or operational site that benefits from the savings initiative, used for site-level procurement KPI reporting.',
    `procurement_type` STRING COMMENT 'Indicates whether the savings initiative applies to direct materials (production-related), indirect spend (non-production), services, capital expenditure (CAPEX), or maintenance, repair, and operations (MRO) categories.. Valid values are `direct|indirect|services|capex|mro`',
    `projected_savings_amount` DECIMAL(18,2) COMMENT 'Estimated total savings value expected from the initiative over the measurement period, calculated as (baseline price - negotiated price) × projected volume. Used for CPO pipeline reporting.',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for the savings initiative, enabling organizational attribution of savings in multi-entity or regional CPO reporting.',
    `realization_date` DATE COMMENT 'Date on which the savings were confirmed as realized in actual spend data, marking the transition from projected to realized savings in CPO reporting.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `realization_status` STRING COMMENT 'Indicates the degree to which the projected savings have been confirmed and captured in actual spend data. Distinct from initiative status — an initiative may be approved but savings not yet realized.. Valid values are `not_started|in_progress|fully_realized|partially_realized|not_realized|cancelled`',
    `realized_savings_amount` DECIMAL(18,2) COMMENT 'Actual confirmed savings amount captured in the period based on actual purchase volumes at the negotiated price versus the baseline. Validated against SAP S/4HANA actual spend data.',
    `savings_percent` DECIMAL(18,2) COMMENT 'Percentage reduction in price or spend achieved by the initiative, calculated as ((baseline - negotiated) / baseline) × 100. Key KPI for CPO value delivery reporting.. Valid values are `^-?[0-9]{1,3}.[0-9]{1,4}$`',
    `sourcing_event_reference` STRING COMMENT 'Reference number of the associated sourcing event (RFQ, RFP, or reverse auction) in SAP Ariba that generated or validated the savings initiative.',
    `sourcing_strategy` STRING COMMENT 'The primary procurement lever or sourcing strategy applied to achieve the savings, such as competitive bidding via RFQ/RFP, supplier consolidation, should-cost analysis, or low-cost country sourcing.. Valid values are `competitive_bidding|sole_source_negotiation|supplier_consolidation|demand_management|specification_change|should_cost_analysis|global_sourcing|low_cost_country_sourcing|rebate_negotiation|payment_terms_optimization`',
    `status` STRING COMMENT 'Current lifecycle status of the savings initiative, tracking progression from identification through approval, execution, and realization confirmation.. Valid values are `draft|submitted|under_review|approved|in_progress|realized|partially_realized|cancelled|on_hold`',
    `title` STRING COMMENT 'Short descriptive title of the savings initiative, such as Global Steel Category Renegotiation FY2025 or Indirect MRO Consolidation Program.',
    CONSTRAINT pk_savings_initiative PRIMARY KEY(`savings_initiative_id`)
) COMMENT 'Tracks procurement cost savings and cost avoidance initiatives by category, sourcing event, or supplier negotiation. Captures initiative type (hard savings, soft savings, cost avoidance), baseline price, negotiated price, savings amount, savings percentage, realization status, and fiscal year attribution. Supports procurement KPI reporting and CPO (Chief Procurement Officer) value delivery tracking.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` (
    `purchase_requisition_approval_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each purchase requisition approval record in the multi-level approval workflow.',
    `employee_id` BIGINT COMMENT 'The employee identifier of the individual who performed or is assigned to perform the approval action. Used for accountability tracking, delegation of authority compliance, and SOX audit trail.',
    `delegated_by_employee_id` BIGINT COMMENT 'Employee ID of the original approver who delegated their approval authority to another individual. Populated only when is_delegated is True. Critical for SOX audit trail to trace the chain of authority.',
    `escalated_to_employee_id` BIGINT COMMENT 'Employee ID of the individual to whom the approval was escalated when the original approver did not act within the SLA window. Populated when escalation_level > 0.',
    `procurement_purchase_requisition_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_requisition. Business justification: Purchase requisition approval records are the multi-level approval workflow entries for specific purchase requisitions. This is a fundamental parent-child relationship in the PR approval lifecycle. re',
    `approval_action` STRING COMMENT 'The decision or action taken by the approver on the purchase requisition at this approval level. Returned indicates the PR is sent back to the requester for revision; Delegated indicates the approver forwarded to another authority.. Valid values are `approved|rejected|returned|delegated|pending|escalated|cancelled`',
    `approval_channel` STRING COMMENT 'The system or interface through which the approver submitted their approval decision (e.g., SAP Workflow inbox, SAP Ariba portal, email notification, mobile app, or manual paper-based). Supports digital transformation analytics and audit trail completeness.. Valid values are `sap_workflow|ariba_portal|email|mobile_app|manual`',
    `approval_cycle_time_hours` DECIMAL(18,2) COMMENT 'Elapsed time in hours between the approval assignment timestamp and the approval action timestamp. Used for procurement cycle time analytics, bottleneck identification, and SLA performance reporting.',
    `approval_level` STRING COMMENT 'Numeric sequence indicating the position of this approval step within the multi-level approval hierarchy (e.g., Level 1 = Supervisor, Level 2 = Manager, Level 3 = Director, Level 4 = VP/CFO). Supports spend authorization controls and escalation tracking.. Valid values are `^[1-9][0-9]?$`',
    `approval_level_description` STRING COMMENT 'Human-readable label for the approval level (e.g., Supervisor Approval, Department Manager Approval, Finance Director Approval, CFO Approval). Used in workflow notifications and audit reports.',
    `approval_record_number` STRING COMMENT 'Business-facing unique identifier for the approval record, used for referencing in audit trails, SOX compliance documentation, and procurement governance reports.. Valid values are `^PRA-[0-9]{4}-[0-9]{8}$`',
    `approval_timestamp` TIMESTAMP COMMENT 'Exact date and time when the approver performed the approval action (approved, rejected, returned, etc.). Core field for audit trail, SLA compliance measurement, and procurement cycle time analytics.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `approver_department` STRING COMMENT 'Organizational department of the approver (e.g., Procurement, Finance, Operations). Used for spend authorization analysis and organizational compliance reporting.',
    `approver_job_title` STRING COMMENT 'Job title or role of the approver at the time of the approval action (e.g., Procurement Manager, Finance Director, VP Operations). Supports delegation of authority validation and audit compliance.',
    `approver_name` STRING COMMENT 'Full name of the approver assigned to or who completed this approval step. Retained for audit trail readability and procurement governance reporting without requiring a join to HR master data.',
    `assigned_timestamp` TIMESTAMP COMMENT 'Date and time when this approval task was assigned or routed to the approver. Used to calculate approval cycle time, identify bottlenecks, and measure SLA adherence for procurement governance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `comments` STRING COMMENT 'Free-text comments or justification provided by the approver when taking an action, particularly for rejections or returns. Required for audit trail completeness and CAPA (Corrective and Preventive Action) follow-up.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity for which the purchase requisition is raised. Determines the applicable financial authorization limits and approval hierarchy in multinational operations.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this approval record was created in the system, typically when the PR was submitted for approval or when the workflow step was initiated. Foundational audit trail field.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the requisition value and spend authorization limit (e.g., USD, EUR, GBP). Supports multi-currency operations across global manufacturing sites.. Valid values are `^[A-Z]{3}$`',
    `delegated_by_name` STRING COMMENT 'Full name of the original approver who delegated their authority. Retained for audit trail readability. Populated only when is_delegated is True.',
    `delegation_reason` STRING COMMENT 'Reason provided for delegating approval authority (e.g., Annual Leave, Business Travel, Temporary Absence). Required for SOX compliance and internal audit documentation of delegation events.',
    `due_date` DATE COMMENT 'Target date by which the approver must complete their approval action, as defined by the procurement SLA policy. Used for escalation triggering and SLA compliance reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `escalation_level` STRING COMMENT 'Number of times this approval task has been escalated due to non-response or SLA breach. Zero indicates no escalation; higher values indicate repeated escalations to senior management.. Valid values are `^[0-9]$`',
    `is_delegated` BOOLEAN COMMENT 'Indicates whether this approval was performed by a delegate acting on behalf of the primary approver. True when the approval authority was formally delegated; False when the primary approver acted directly.. Valid values are `true|false`',
    `is_overdue` BOOLEAN COMMENT 'Indicates whether the approval action was not completed by the due date. True when the approval timestamp exceeds the due date or the record remains pending past the due date. Supports escalation management and SLA reporting.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to this approval record. Used for change data capture in the Databricks Silver Layer pipeline and for detecting unauthorized modifications in SOX audit reviews.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `notification_sent_flag` BOOLEAN COMMENT 'Indicates whether an approval request notification was successfully sent to the approver via the configured workflow channel. Used to diagnose workflow failures and ensure approvers are properly notified.. Valid values are `true|false`',
    `notification_timestamp` TIMESTAMP COMMENT 'Date and time when the approval request notification was dispatched to the approver. Used to measure notification-to-action cycle time and validate SLA compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or operational facility for which the purchase requisition is raised. Used to route approvals to the correct plant-level authority and for spend analytics by site.',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for the procurement activity. Determines the applicable approval hierarchy and spend authorization rules for the requisition.',
    `rejection_reason_code` STRING COMMENT 'Standardized code categorizing the reason for rejection or return of the purchase requisition (e.g., BUDGET_EXCEEDED, WRONG_VENDOR, MISSING_JUSTIFICATION, POLICY_VIOLATION). Enables spend control analytics and process improvement.',
    `release_code` STRING COMMENT 'The specific release code within the release strategy representing this approval level (e.g., Z1, Z2, Z3). Each release code corresponds to a distinct approval authority level in the procurement authorization hierarchy.',
    `release_strategy_code` STRING COMMENT 'SAP release strategy code that governs the multi-level approval workflow for this purchase requisition, determined by characteristics such as spend value, plant, purchasing group, and account assignment.',
    `requisition_line_number` STRING COMMENT 'Line item number within the purchase requisition subject to this approval action. Supports line-level approval workflows where individual line items may require separate authorization.. Valid values are `^[0-9]{1,5}$`',
    `requisition_number` STRING COMMENT 'The business document number of the purchase requisition being approved, as assigned by SAP S/4HANA MM. Links this approval record to the originating PR document.',
    `requisition_value` DECIMAL(18,2) COMMENT 'Total estimated monetary value of the purchase requisition (or line item) subject to this approval, in the document currency. Captured at the time of approval for audit trail and spend authorization compliance.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this approval record was sourced (e.g., SAP S/4HANA MM, SAP Ariba). Supports data lineage tracking and Silver Layer reconciliation in the Databricks Lakehouse.. Valid values are `SAP_S4HANA|SAP_ARIBA|MANUAL`',
    `sox_control_reference` STRING COMMENT 'Reference to the specific SOX internal control identifier that this approval record satisfies (e.g., PC-PROC-001). Enables direct linkage between approval audit trail records and SOX control testing evidence.',
    `spend_authorization_limit` DECIMAL(18,2) COMMENT 'Maximum monetary value the approver is authorized to approve at this level, as defined in the Delegation of Authority policy. Used to validate that the PR value does not exceed the approvers authorization threshold.',
    `status` STRING COMMENT 'Current processing status of this approval record within the workflow lifecycle. Distinguishes between records awaiting action, actively under review, and those with a final disposition.. Valid values are `pending|in_review|approved|rejected|returned|delegated|escalated|cancelled|expired`',
    CONSTRAINT pk_purchase_requisition_approval PRIMARY KEY(`purchase_requisition_approval_id`)
) COMMENT 'Tracks the multi-level approval workflow for purchase requisitions including approver identity, approval level, approval action (approved, rejected, returned), approval timestamp, delegation details, and comments. Supports procurement governance, spend authorization controls, and audit trail requirements for SOX and internal audit compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supplier_contact` (
    `supplier_contact_id` BIGINT COMMENT 'Primary key for supplier_contact',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: supplier_contact should directly reference supplier master. Adding supplier_id FK enables direct supplier lookup (note: this may already exist but not visible in attribute list).',
    CONSTRAINT pk_supplier_contact PRIMARY KEY(`supplier_contact_id`)
) COMMENT 'Master record for key contacts at supplier organizations including account managers, quality engineers, logistics coordinators, and executive sponsors. Captures contact name, role, department, phone, email, preferred communication channel, and active status. Supports supplier relationship management and sourcing event communication within SAP Ariba.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`incoterm` (
    `incoterm_id` BIGINT COMMENT 'Unique surrogate identifier for each Incoterm reference record in the lakehouse silver layer.',
    `applicable_transport_modes` STRING COMMENT 'Pipe-delimited list of specific transport modes for which this Incoterm is suitable (e.g., road|rail|air|sea|multimodal or sea|inland_waterway). Supports logistics planning and carrier selection in the Transportation Management System (TMS).',
    `ariba_incoterm_code` STRING COMMENT 'The Incoterm code as configured in SAP Ariba Procurement and Sourcing modules. Used for cross-referencing between the lakehouse reference table and Ariba purchase orders, contracts, and sourcing events.',
    `buyer_arranges_import_clearance` BOOLEAN COMMENT 'Indicates whether the buyer (Manufacturing) is responsible for import customs clearance, duties, and taxes at the destination country. False for DDP where the seller bears full import duty responsibility.. Valid values are `true|false`',
    `buyer_cost_responsibility_summary` STRING COMMENT 'Summary of cost elements the buyer (Manufacturing) must bear under this Incoterm, including import duties, destination freight, unloading, and insurance as applicable. Used in procurement cost modeling and total landed cost analysis.',
    `buyer_obligation_summary` STRING COMMENT 'Concise summary of the buyers (Manufacturings) primary obligations under this Incoterm, including import clearance responsibility, onward freight costs, and unloading duties. Used in procurement planning and landed cost calculations.',
    `code` STRING COMMENT 'Standardized three-letter Incoterm code as defined by the International Chamber of Commerce (ICC) Incoterms 2020 rules (e.g., EXW, FCA, DAP, DDP, FOB, CIF). Used as the primary business key on purchase orders, procurement contracts, and inbound deliveries.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `cost_transfer_point` STRING COMMENT 'The point at which freight and associated costs transfer from seller to buyer. May differ from the risk transfer point (e.g., under CIF/CIP the seller pays freight to destination but risk transfers at origin port). Used in landed cost and total cost of ownership calculations.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this Incoterm reference record was first created in the lakehouse silver layer. Used for data lineage, audit trail, and reference data governance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customs_duty_payer` STRING COMMENT 'Identifies which party (seller or buyer) is responsible for paying import customs duties and taxes at the destination country under this Incoterm. DDP assigns full duty responsibility to the seller; all other terms assign it to the buyer.. Valid values are `seller|buyer|not_applicable`',
    `delivery_location_type` STRING COMMENT 'Classification of the type of delivery location applicable to this Incoterm, used to guide procurement teams in specifying the correct named place on purchase orders and contracts.. Valid values are `seller_premises|origin_port|destination_port|destination_place|carrier_named_place|border_crossing|any_mode_named_place`',
    `description` STRING COMMENT 'Detailed plain-language description of the Incoterms obligations, covering seller and buyer responsibilities for delivery, risk transfer, insurance, export/import clearance, and freight costs as defined by ICC Incoterms 2020.',
    `effective_end_date` DATE COMMENT 'The date after which this Incoterm record is no longer valid for use on new purchase orders or contracts. Null indicates the record is currently active with no planned expiry.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_start_date` DATE COMMENT 'The date from which this Incoterm record is valid and available for use on purchase orders and contracts. Supports temporal validity management for reference data governance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `group` STRING COMMENT 'ICC classification group of the Incoterm: E (Departure — seller makes goods available at own premises), F (Main carriage unpaid — seller delivers to carrier nominated by buyer), C (Main carriage paid — seller contracts carriage but risk transfers at origin), D (Arrival — seller bears all costs and risks to destination).. Valid values are `E|F|C|D`',
    `insurance_minimum_coverage` STRING COMMENT 'Specifies the minimum cargo insurance coverage standard required of the seller under this Incoterm. Applicable only to CIF (Clauses C) and CIP (Clauses A per Incoterms 2020 update). Null or not_required for all other terms.. Valid values are `not_required|institute_cargo_clauses_c|institute_cargo_clauses_a|`',
    `inventory_ownership_transfer_point` STRING COMMENT 'Describes the point at which legal title and inventory ownership transfers from seller to buyer under this Incoterm. Used for inventory valuation, in-transit stock accounting, and balance sheet reporting under IFRS and GAAP.',
    `is_recommended_for_manufacturing` BOOLEAN COMMENT 'Indicates whether this Incoterm is on the companys approved/preferred list for use in industrial manufacturing procurement contracts and purchase orders. Supports category management and sourcing strategy governance.. Valid values are `true|false`',
    `iso_country_scope` STRING COMMENT 'Indicates any country-specific restrictions or applicability notes for this Incoterm (e.g., DDP may not be applicable in certain jurisdictions due to import licensing restrictions). Null indicates globally applicable.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this Incoterm reference record was most recently updated in the lakehouse silver layer. Used for change tracking, data freshness monitoring, and reference data governance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `name` STRING COMMENT 'Full official name of the Incoterm as published by the ICC (e.g., Ex Works, Free Carrier, Delivered Duty Paid). Used in contract documentation, supplier communications, and regulatory filings.',
    `named_place_guidance` STRING COMMENT 'Instructional guidance for procurement teams on how to specify the named place for this Incoterm on purchase orders (e.g., Specify the port of loading, Specify the buyers warehouse address, Specify the border crossing point). Reduces errors in PO creation.',
    `named_place_required` BOOLEAN COMMENT 'Indicates whether a specific named place or port must be designated on the purchase order or contract when using this Incoterm. All Incoterms 2020 terms require a named place; this flag supports validation rules in SAP S/4HANA MM and SAP Ariba.. Valid values are `true|false`',
    `notes` STRING COMMENT 'Free-text field for additional procurement-specific notes, internal policy clarifications, or legal annotations related to the use of this Incoterm within Manufacturings procurement operations.',
    `preferred_procurement_types` STRING COMMENT 'Pipe-delimited list of procurement types for which this Incoterm is most commonly or preferably used (e.g., direct_material|capital_equipment or indirect|mro). Supports spend category management and sourcing strategy alignment.',
    `revenue_recognition_trigger` STRING COMMENT 'The point in the delivery process at which revenue recognition is triggered for the seller under this Incoterm, aligned with IFRS 15 performance obligation satisfaction. Used by Finance for revenue accrual and accounts payable timing.. Valid values are `at_seller_premises|at_origin_port_loading|at_named_place_destination|at_destination_port_unloading|at_buyer_premises`',
    `risk_transfer_point` STRING COMMENT 'The precise geographic or logistical point at which risk of loss or damage to goods transfers from seller to buyer under this Incoterm (e.g., Sellers premises, Named port of shipment, Named place of destination). Critical for insurance coverage determination and claims management.',
    `sap_incoterm_code` STRING COMMENT 'The Incoterm code as configured in SAP S/4HANA MM/SD condition type INCO1. Used for system integration and cross-referencing between the lakehouse reference table and SAP purchase orders, contracts, and delivery documents.',
    `seller_arranges_export_clearance` BOOLEAN COMMENT 'Indicates whether the seller is responsible for obtaining export licenses and completing export customs clearance formalities under this Incoterm. False for EXW where the buyer bears full export responsibility.. Valid values are `true|false`',
    `seller_arranges_insurance` BOOLEAN COMMENT 'Indicates whether the seller is obligated to procure cargo insurance under this Incoterm. Mandatory only for CIF (minimum Institute Cargo Clauses C) and CIP (minimum Institute Cargo Clauses A per Incoterms 2020). Used to determine insurance procurement responsibility.. Valid values are `true|false`',
    `seller_arranges_main_carriage` BOOLEAN COMMENT 'Indicates whether the seller is responsible for contracting and paying for the main carriage (primary freight leg) to the named destination. True for C-group and D-group terms; False for E-group and F-group terms.. Valid values are `true|false`',
    `seller_cost_responsibility_summary` STRING COMMENT 'Summary of cost elements the seller must bear under this Incoterm, including packing, loading, export duties, freight, and insurance as applicable. Used in procurement cost modeling and total landed cost analysis.',
    `seller_obligation_summary` STRING COMMENT 'Concise summary of the sellers (suppliers) primary obligations under this Incoterm, including delivery point, export clearance responsibility, and freight/insurance cost coverage. Used in supplier contract negotiations and procurement training.',
    `status` STRING COMMENT 'Operational status of the Incoterm record indicating whether it is currently approved for use on new purchase orders and contracts. deprecated indicates the term was valid in a prior ICC version but is no longer recommended.. Valid values are `active|inactive|deprecated`',
    `transport_mode_applicability` STRING COMMENT 'Indicates whether the Incoterm applies to any mode of transport (road, rail, air, sea, multimodal) or is restricted to sea and inland waterway transport only. Sea-only terms (FAS, FOB, CFR, CIF) must not be used for containerized or multimodal shipments per ICC guidance.. Valid values are `any_mode|sea_and_inland_waterway_only`',
    `use_case_guidance` STRING COMMENT 'Practical guidance for procurement and sourcing teams on when to use this Incoterm, including recommended scenarios, common pitfalls, and industry best practices. For example, advising against FOB for containerized shipments or recommending FCA over EXW for export compliance.',
    `version_year` STRING COMMENT 'Publication year of the ICC Incoterms ruleset to which this record belongs (e.g., 2020 for Incoterms 2020). Enables coexistence of multiple Incoterm versions in the reference table to support legacy contracts.. Valid values are `1936|1953|1967|1976|1980|1990|2000|2010|2020`',
    CONSTRAINT pk_incoterm PRIMARY KEY(`incoterm_id`)
) COMMENT 'Reference data for internationally recognized trade terms (Incoterms 2020) used in purchase orders and procurement contracts to define delivery obligations, risk transfer points, and cost responsibilities between buyer and supplier. Captures Incoterm code (EXW, FCA, DAP, DDP, etc.), full name, description, risk transfer point, and applicable transport modes.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` (
    `procurement_payment_term_id` BIGINT COMMENT 'Unique surrogate identifier for each payment term record in the procurement domain. Used as the primary key for referencing payment terms across purchase orders, contracts, and supplier invoices.',
    `applicable_region` STRING COMMENT 'Geographic region or country scope for which this payment term is applicable (e.g., GLOBAL, EMEA, APAC, AMERICAS, or a specific ISO 3166-1 alpha-3 country code). Supports regional payment term governance in multinational procurement operations.',
    `ariba_term_reference` STRING COMMENT 'Unique identifier for this payment term as defined in SAP Ariba procurement platform. Enables cross-system reconciliation between SAP Ariba sourcing/contracting and SAP S/4HANA accounts payable processing.',
    `baseline_date_type` STRING COMMENT 'Defines the reference date from which the payment due date and discount periods are calculated. invoice_date uses the supplier invoice date; posting_date uses the accounting posting date; goods_receipt_date uses the GRN date; delivery_date uses the actual delivery date; end_of_month and end_of_next_month are period-end conventions. Directly maps to SAP ZTERM baseline date field.. Valid values are `invoice_date|posting_date|goods_receipt_date|delivery_date|end_of_month|end_of_next_month|custom`',
    `company_code` STRING COMMENT 'SAP company code to which this payment term is assigned, representing a legal entity within the multinational enterprise. Supports multi-entity financial reporting and accounts payable processing. Null if the term is globally applicable across all company codes.. Valid values are `^[A-Z0-9]{1,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this payment term record was first created in the system. Used for audit trail, data lineage tracking, and compliance with internal controls over financial reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for which this payment term is applicable (e.g., USD, EUR, CNY). Supports multi-currency procurement operations across global manufacturing sites. Null if the term is currency-agnostic.. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Full business description of the payment term including conditions, discount eligibility, and any special instructions. Supports accounts payable processing and supplier onboarding documentation.',
    `discount_days_1` STRING COMMENT 'Number of days from the baseline date within which payment must be made to qualify for the first-tier early payment discount (discount_percent_1). For example, in 2/10 Net 30, this value is 10. Used in accounts payable to determine discount eligibility.. Valid values are `^[0-9]{1,4}$`',
    `discount_days_2` STRING COMMENT 'Number of days from the baseline date within which payment must be made to qualify for the second-tier early payment discount (discount_percent_2). Null if no second discount tier applies.. Valid values are `^[0-9]{1,4}$`',
    `discount_percent_1` DECIMAL(18,2) COMMENT 'Percentage discount offered to the buyer if payment is made within the first discount period (discount_days_1). For example, in 2/10 Net 30, this value is 2.00 (2%). Supports dynamic discounting and working capital optimization programs.. Valid values are `^[0-9]{1,2}(.[0-9]{1,4})?$`',
    `discount_percent_2` DECIMAL(18,2) COMMENT 'Percentage discount offered if payment is made within the second discount period (discount_days_2). Supports tiered early payment incentive structures common in multinational procurement contracts. Null if no second discount tier applies.. Valid values are `^[0-9]{1,2}(.[0-9]{1,4})?$`',
    `dynamic_discounting_eligible` BOOLEAN COMMENT 'Indicates whether this payment term is eligible for dynamic discounting programs where suppliers can request early payment at a sliding discount rate. Supports working capital optimization and supply chain finance initiatives managed through SAP Ariba.. Valid values are `true|false`',
    `effective_end_date` DATE COMMENT 'Date after which this payment term is no longer valid for new assignments. Existing purchase orders and contracts referencing this term remain unaffected. Supports lifecycle management of procurement reference data.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_start_date` DATE COMMENT 'Date from which this payment term becomes valid and available for assignment to purchase orders, contracts, and supplier master records. Supports temporal validity management of reference data in the procurement domain.. Valid values are `^d{4}-d{2}-d{2}$`',
    `installment_count` STRING COMMENT 'Total number of installment payments defined for installment-type payment terms. For example, a 3-installment term would have a value of 3. Applicable only when term_type is installment. Used in accounts payable scheduling and cash flow forecasting.. Valid values are `^[0-9]{1,3}$`',
    `installment_days_1` STRING COMMENT 'Number of days from the baseline date by which the first installment payment (installment_percent_1) is due. Used in accounts payable to generate the first partial payment due date for installment-type terms.. Valid values are `^[0-9]{1,4}$`',
    `installment_days_2` STRING COMMENT 'Number of days from the baseline date by which the second installment payment (installment_percent_2) is due. Null if installment_count is less than 2.. Valid values are `^[0-9]{1,4}$`',
    `installment_days_3` STRING COMMENT 'Number of days from the baseline date by which the third installment payment (installment_percent_3) is due. Null if installment_count is less than 3.. Valid values are `^[0-9]{1,4}$`',
    `installment_percent_1` DECIMAL(18,2) COMMENT 'Percentage of the total invoice amount due in the first installment tranche. For example, 30.00 represents 30% of the invoice value. Used in conjunction with installment_days_1 to schedule the first payment. Applicable only for installment-type terms.. Valid values are `^[0-9]{1,3}(.[0-9]{1,2})?$`',
    `installment_percent_2` DECIMAL(18,2) COMMENT 'Percentage of the total invoice amount due in the second installment tranche. Null if installment_count is less than 2. Used with installment_days_2 to schedule the second partial payment.. Valid values are `^[0-9]{1,3}(.[0-9]{1,2})?$`',
    `installment_percent_3` DECIMAL(18,2) COMMENT 'Percentage of the total invoice amount due in the third installment tranche. Null if installment_count is less than 3. The sum of all installment percentages must equal 100%.. Valid values are `^[0-9]{1,3}(.[0-9]{1,2})?$`',
    `is_default_for_new_suppliers` BOOLEAN COMMENT 'Indicates whether this payment term is automatically assigned as the default when onboarding new suppliers in the procurement system. Supports standardized supplier onboarding and accounts payable configuration.. Valid values are `true|false`',
    `is_early_payment_discount_eligible` BOOLEAN COMMENT 'Indicates whether this payment term includes an early payment discount incentive (e.g., 2/10 Net 30). Used to filter eligible terms for dynamic discounting programs and working capital optimization initiatives.. Valid values are `true|false`',
    `is_intercompany` BOOLEAN COMMENT 'Indicates whether this payment term is designated for intercompany transactions between legal entities within the same corporate group. Intercompany terms may have different net days and discount structures governed by transfer pricing policies.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this payment term record. Supports change tracking, data governance, and audit compliance for procurement reference data.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `late_payment_grace_days` STRING COMMENT 'Number of additional calendar days beyond the net due date before late payment penalties are applied. Provides a buffer for processing delays and banking holidays. Supports accounts payable dispute management.. Valid values are `^[0-9]{1,3}$`',
    `late_payment_penalty_percent` DECIMAL(18,2) COMMENT 'Annual percentage rate charged on overdue invoice amounts when payment is not made by the due date. Used in accounts payable to calculate penalty accruals and supports compliance with EU Late Payment Directive and similar regulations.. Valid values are `^[0-9]{1,2}(.[0-9]{1,4})?$`',
    `net_days` STRING COMMENT 'Number of calendar days from the baseline date by which the full invoice amount must be paid without penalty. For example, Net 30 has a net_days value of 30. Core field for accounts payable due date calculation and working capital management.. Valid values are `^[0-9]{1,4}$`',
    `payment_method` STRING COMMENT 'Preferred or required payment instrument associated with this payment term. Determines how funds are transferred to the supplier. dynamic_discounting and supply_chain_finance support working capital optimization programs. Aligns with SAP FI payment method (ZLSCH).. Valid values are `bank_transfer|check|ach|wire_transfer|letter_of_credit|dynamic_discounting|supply_chain_finance|virtual_card|direct_debit`',
    `procurement_category_scope` STRING COMMENT 'Spend category or commodity group for which this payment term is specifically applicable (e.g., Direct Materials, MRO, Capital Equipment, Services). Enables category-specific payment term governance aligned with strategic sourcing policies.',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code to which this payment term is scoped. Enables differentiated payment terms by procurement organization in a global enterprise. Null if the term applies across all purchasing organizations.. Valid values are `^[A-Z0-9]{1,10}$`',
    `sap_zterm_code` STRING COMMENT 'Native SAP S/4HANA payment term key (ZTERM field) used in vendor master, purchase orders, and invoice documents. Enables direct traceability and reconciliation between the data lakehouse silver layer and the SAP ERP system of record.. Valid values are `^[A-Z0-9]{1,4}$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this payment term was originated or last updated. Supports data lineage, reconciliation, and master data governance across the enterprise data lakehouse.. Valid values are `SAP_S4HANA|SAP_ARIBA|MANUAL|MIGRATION`',
    `status` STRING COMMENT 'Current operational status of the payment term. active terms are available for assignment to new purchase orders and contracts; inactive terms are retired; blocked terms are temporarily suspended; under_review terms are pending approval for modification.. Valid values are `active|inactive|blocked|under_review`',
    `supply_chain_finance_eligible` BOOLEAN COMMENT 'Indicates whether this payment term is eligible for supply chain finance (reverse factoring) programs, where a financial institution pays the supplier early and the buyer repays the bank at the original due date. Supports working capital and supplier liquidity programs.. Valid values are `true|false`',
    `term_code` STRING COMMENT 'Alphanumeric business key identifying the payment term, aligned with SAP S/4HANA ZTERM code (e.g., NT30, 2/10N30, INST60). Used as the natural key in ERP and procurement systems for lookup and assignment to purchase orders and contracts.. Valid values are `^[A-Z0-9_]{1,30}$`',
    `term_name` STRING COMMENT 'Short descriptive name of the payment term (e.g., Net 30, 2/10 Net 30, Immediate Payment). Used in user interfaces, purchase orders, and supplier communications.',
    `term_type` STRING COMMENT 'Classification of the payment term structure. standard indicates simple net-day terms; early_payment_discount includes discount incentives; installment defines multiple scheduled payments; milestone ties payments to project deliverables; prepayment requires advance payment; consignment defers payment until goods are sold; cash_on_delivery requires payment at receipt; letter_of_credit uses documentary credit instruments.. Valid values are `standard|early_payment_discount|installment|milestone|prepayment|consignment|cash_on_delivery|letter_of_credit`',
    CONSTRAINT pk_procurement_payment_term PRIMARY KEY(`procurement_payment_term_id`)
) COMMENT 'Reference data defining standard payment terms used in procurement contracts and purchase orders including net days, early payment discount terms (e.g., 2/10 Net 30), installment schedules, and milestone-based payment structures. Captures term code, description, baseline date calculation, discount percentage, and discount period. Supports accounts payable processing and working capital optimization.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` (
    `supplier_certificate_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a supplier compliance certificate or regulatory documentation record in the procurement domain.',
    `ariba_certificate_id` BIGINT COMMENT 'Native certificate record identifier from SAP Ariba Supplier Management module, used for cross-system reconciliation and data lineage tracing between the lakehouse silver layer and the source procurement system.',
    `certificate_id` BIGINT COMMENT 'Foreign key linking to quality.quality_certificate. Business justification: Supplier certificates (ISO9001, AS9100, IATF16949) are quality certifications tracked in quality systems. Procurement references these certificates for supplier qualification and audit planning.',
    `environmental_permit_id` BIGINT COMMENT 'Foreign key linking to hse.environmental_permit. Business justification: Suppliers must provide environmental permits (ISO 14001, waste handling licenses) as part of qualification. Procurement tracks these certificates linked to HSE permit records for compliance verificati',
    `product_certification_id` BIGINT COMMENT 'Foreign key linking to compliance.product_certification. Business justification: Suppliers provide certificates proving product certifications (UL, CE, CSA). Procurement maintains these certificates linked to compliance records for regulatory traceability and supplier performance ',
    `spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_spend_category. Business justification: Supplier certificate references spend category via commodity_category_code (STRING). Adding FK for referential integrity, removing redundant string field.',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Compliance certificates are issued to and held by specific supplier organizations. The table currently stores supplier_code and supplier_name as denormalized strings. Adding supplier_id FK normalizes ',
    `applicable_material_group` STRING COMMENT 'SAP material group or product family to which this certificates compliance scope applies, enabling material-level compliance gating during procurement and goods receipt.',
    `ce_notified_body_number` STRING COMMENT 'Four-digit EU notified body identification number affixed to the CE marking declaration, identifying the third-party conformity assessment body involved in the CE certification process. Applicable when certificate_type is CE_MARKING.. Valid values are `^d{4}$`',
    `certificate_title` STRING COMMENT 'Full descriptive title of the certificate or regulatory document as stated by the issuing body, providing human-readable identification beyond the type code.',
    `conflict_minerals_reporting_template_version` STRING COMMENT 'Version of the Responsible Minerals Initiative (RMI) Conflict Minerals Reporting Template (CMRT) used for conflict minerals declarations. Applicable only when certificate_type is CONFLICT_MINERALS_CMRT.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the supplier site or jurisdiction where the certificate was issued and is applicable, supporting multi-country regulatory compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the supplier certificate record was first created in the source system or ingested into the data lakehouse, supporting audit trail and data lineage requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `days_to_expiry` STRING COMMENT 'Number of calendar days remaining until the certificate expires, calculated from the current date to the expiry_date. Used for proactive renewal alerting and compliance dashboards. Negative values indicate the certificate has already expired.',
    `document_reference` STRING COMMENT 'Internal document management reference number or external URL/path to the scanned certificate document stored in the document management system (e.g., Siemens Teamcenter PLM or SAP DMS).',
    `document_version` STRING COMMENT 'Version number of the certificate document as managed in the document management system, supporting document revision control and audit trail.',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether this certificate type is mandatory for supplier qualification or procurement approval in the applicable spend category or regulatory jurisdiction. Mandatory certificates block procurement activities if expired.. Valid values are `true|false`',
    `is_self_declared` BOOLEAN COMMENT 'Indicates whether the certificate or compliance declaration was self-declared by the supplier (e.g., RoHS self-declaration, REACH declaration of conformity) rather than issued by an independent third-party certification body.. Valid values are `true|false`',
    `issuing_body_accreditation_number` STRING COMMENT 'Accreditation number of the certification body issued by a national accreditation authority (e.g., UKAS, DAkkS, ANAB), used to verify the legitimacy and authority of the issuing body.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the supplier certificate record in the source system or data lakehouse, used for change detection, incremental loading, and audit trail.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_surveillance_date` DATE COMMENT 'Date of the most recent surveillance or recertification audit conducted by the certification body to maintain the certificates validity between full recertification cycles.. Valid values are `^d{4}-d{2}-d{2}$`',
    `next_surveillance_date` DATE COMMENT 'Scheduled date for the next surveillance or recertification audit. Used for proactive compliance monitoring and supplier engagement planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `notes` STRING COMMENT 'Free-text field for additional remarks, conditions, limitations, or context related to the certificate, such as scope exclusions, conditional approvals, or follow-up actions required.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or receiving location for which this supplier certificate is relevant, supporting plant-level compliance gating.',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for managing the supplier relationship and procurement activities covered by this certificate.',
    `reach_svhc_declaration_date` DATE COMMENT 'Date of the most recent REACH Substances of Very High Concern (SVHC) declaration submitted by the supplier. Applicable when certificate_type is REACH_DECLARATION, supporting EU REACH Article 33 compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `renewal_reminder_sent_flag` BOOLEAN COMMENT 'Indicates whether an automated renewal reminder notification has been sent to the supplier for this certificate, supporting proactive compliance management workflows.. Valid values are `true|false`',
    `rohs_exemption_codes` STRING COMMENT 'Comma-separated list of applicable RoHS Directive exemption codes claimed by the supplier for restricted substances that exceed threshold limits under specific technical conditions (e.g., Annex III or Annex IV exemptions).',
    `scope` STRING COMMENT 'Detailed description of the activities, processes, products, or services covered by the certificate as defined by the issuing body. For example, Design and manufacture of electromechanical assemblies and automation components.',
    `source_system` STRING COMMENT 'Operational system of record from which this certificate record was ingested into the data lakehouse (e.g., SAP Ariba Supplier Management, SAP S/4HANA QM, Siemens Teamcenter PLM).. Valid values are `SAP_ARIBA|SAP_S4HANA|TEAMCENTER|MANUAL|OTHER`',
    `standard_version` STRING COMMENT 'Version or revision of the standard to which the certificate was issued (e.g., ISO 9001:2015, ISO 14001:2015, RoHS Directive 2011/65/EU as amended by 2015/863/EU). Ensures compliance with the current applicable revision.',
    `status` STRING COMMENT 'Current lifecycle status of the supplier certificate. Active indicates the certificate is valid and in force; expired indicates the validity period has lapsed; suspended indicates temporary withdrawal by the issuing body; revoked indicates permanent cancellation.. Valid values are `active|expired|suspended|withdrawn|pending_renewal|under_review|revoked`',
    `supplier_site_code` STRING COMMENT 'Code identifying the specific supplier manufacturing site or facility to which this certificate applies, supporting multi-site supplier qualification.',
    `ul_file_number` STRING COMMENT 'Underwriters Laboratories (UL) file number assigned to the suppliers product or component certification, used to verify UL listing status in the UL Product iQ database. Applicable when certificate_type is UL_CERTIFICATION.',
    `verification_date` DATE COMMENT 'Date on which the certificate was last verified by the internal procurement or quality team against the issuing bodys public registry or direct confirmation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `verified_by` STRING COMMENT 'Name or employee ID of the procurement or quality professional who verified the authenticity and validity of the certificate against the issuing bodys records.',
    CONSTRAINT pk_supplier_certificate PRIMARY KEY(`supplier_certificate_id`)
) COMMENT 'Tracks compliance certificates and regulatory documentation held by suppliers including ISO 9001, ISO 14001, ISO 45001, REACH declarations, RoHS compliance certificates, conflict minerals declarations (CMRT), UL certifications, and CE marking authorizations. Captures certificate type, issuing body, issue date, expiry date, scope, and document reference. Supports supplier qualification and regulatory compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` (
    `purchase_order_amendment_id` BIGINT COMMENT 'Unique surrogate identifier for each purchase order amendment record in the lakehouse silver layer.',
    `procurement_po_line_item_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_po_line_item. Business justification: PO amendment references PO line item via po_line_number (STRING). Adding FK for referential integrity, removing redundant string field.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Purchase order amendments are formal change orders applied to specific purchase orders. This is a fundamental parent-child relationship for PO amendment management. po_number is retained as a business',
    `employee_id` BIGINT COMMENT 'Employee identifier of the individual who initiated the amendment request. Enables linkage to HR and workforce systems for organizational reporting and access control auditing.',
    `amendment_number` STRING COMMENT 'Business-facing unique identifier for the purchase order amendment, used for tracking and referencing the change across procurement systems and supplier communications.. Valid values are `^AMD-[0-9]{4}-[0-9]{6}$`',
    `amendment_type` STRING COMMENT 'Classification of the type of change being applied to the purchase order. Drives workflow routing, approval requirements, and supplier notification obligations.. Valid values are `quantity_change|price_adjustment|delivery_date_revision|scope_change|payment_terms_change|incoterms_change|supplier_change|cancellation|line_item_addition|line_item_deletion|currency_change|other`',
    `amendment_version` STRING COMMENT 'Sequential version number of the amendment applied to the purchase order. Increments with each successive change to the same PO, enabling full revision history tracking.. Valid values are `^[1-9][0-9]*$`',
    `approval_status` STRING COMMENT 'Current status of the internal approval workflow for the purchase order amendment. Reflects whether the change has been authorized per the release strategy and delegation of authority.. Valid values are `not_required|pending|approved|rejected|escalated`',
    `approved_by` STRING COMMENT 'Name or employee ID of the individual who approved the purchase order amendment per the applicable release strategy and delegation of authority policy.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the purchase order amendment was formally approved by the authorized approver. Critical for audit trail, SLA compliance, and procurement cycle time analytics.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `change_level` STRING COMMENT 'Indicates whether the amendment applies at the purchase order header level (e.g., payment terms, incoterms) or at a specific line item level (e.g., quantity, price, delivery date).. Valid values are `header|line_item`',
    `changed_field_description` STRING COMMENT 'Human-readable business description of the field that was changed, providing context for non-technical users reviewing the amendment audit trail.',
    `changed_field_name` STRING COMMENT 'Technical or business name of the specific field that was modified by this amendment (e.g., MENGE for quantity, NETPR for net price, EINDT for delivery date). Supports granular audit trail.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity under which the purchase order and amendment are recorded. Supports multi-entity financial reporting and intercompany reconciliation.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the purchase order amendment record was created in the source system. Establishes the start of the amendment lifecycle for audit trail and SLA measurement.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary values in this amendment record (e.g., USD, EUR, GBP). Supports multi-currency procurement in global operations.. Valid values are `^[A-Z]{3}$`',
    `ecn_reference` STRING COMMENT 'Reference to the Engineering Change Notice (ECN) or Engineering Change Order (ECO) that triggered this purchase order amendment. Links procurement changes to engineering design changes managed in PLM.',
    `effective_date` DATE COMMENT 'The date from which the amendment changes take legal and operational effect. May differ from the approval date when changes are scheduled for future implementation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the purchase order amendment record. Supports incremental data loading, change detection, and audit trail completeness.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `original_delivery_date` DATE COMMENT 'The delivery date committed on the purchase order line before the delivery date revision amendment. Used for on-time delivery performance measurement and supply chain impact analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `original_net_price` DECIMAL(18,2) COMMENT 'The net unit price on the purchase order line before the price adjustment amendment. Used for spend variance analysis, savings tracking, and supplier negotiation benchmarking.',
    `original_po_value` DECIMAL(18,2) COMMENT 'The total net value of the purchase order (or affected line) before the amendment was applied. Used for financial commitment tracking, budget variance analysis, and spend reporting.',
    `original_quantity` DECIMAL(18,2) COMMENT 'The ordered quantity on the purchase order line before the amendment. Captured explicitly for quantity change amendments to support procurement analytics and MRP reconciliation.',
    `original_value` STRING COMMENT 'The value of the changed field before the amendment was applied. Stored as STRING to accommodate various field types (quantity, price, date, text). Enables before/after comparison for audit purposes.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility receiving the goods or services covered by the amended purchase order.',
    `po_number` STRING COMMENT 'The business document number of the purchase order to which this amendment applies. References the original PO issued to the supplier.',
    `price_unit` DECIMAL(18,2) COMMENT 'The quantity basis for the net price (e.g., price per 1, per 100, per 1000 units). Required for accurate unit cost calculations when price is expressed per multiple units.',
    `purchasing_group_code` STRING COMMENT 'SAP purchasing group code identifying the buyer or buyer team responsible for managing the amendment. Used for workload distribution and procurement performance reporting.',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for the purchase order being amended. Defines the organizational unit with procurement authority and supplier contract ownership.',
    `quantity_uom` STRING COMMENT 'Unit of measure applicable to the original and revised quantity fields (e.g., EA, KG, M, L, PC). Ensures consistent interpretation of quantity values across procurement and inventory systems.',
    `reason_code` STRING COMMENT 'Standardized reason code classifying the business driver for the purchase order amendment. Supports root cause analysis, procurement process improvement, and compliance reporting.. Valid values are `supplier_request|engineering_change|demand_change|price_negotiation|delivery_constraint|quality_issue|budget_adjustment|contract_alignment|regulatory_compliance|force_majeure|error_correction|other`',
    `reason_text` STRING COMMENT 'Free-text narrative providing detailed justification for the purchase order amendment, supplementing the reason code with context for audit trail and procurement review purposes.',
    `requester_department` STRING COMMENT 'Organizational department of the amendment requester (e.g., Procurement, Engineering, Production Planning). Supports departmental spend analysis and change frequency reporting.',
    `requester_name` STRING COMMENT 'Full name of the individual who initiated the purchase order amendment request. Used for accountability tracking and workflow routing.',
    `revised_delivery_date` DATE COMMENT 'The new delivery date after the delivery date revision amendment. Triggers downstream updates to production scheduling, MRP planning, and warehouse receiving plans.. Valid values are `^d{4}-d{2}-d{2}$`',
    `revised_net_price` DECIMAL(18,2) COMMENT 'The new net unit price on the purchase order line after the price adjustment amendment. Drives updated PO value calculations and supplier invoice matching.',
    `revised_po_value` DECIMAL(18,2) COMMENT 'The total net value of the purchase order (or affected line) after the amendment is applied. Drives updated financial commitments, budget consumption, and accounts payable forecasting.',
    `revised_quantity` DECIMAL(18,2) COMMENT 'The new ordered quantity on the purchase order line after the amendment. Used for supply planning, goods receipt reconciliation, and supplier capacity coordination.',
    `revised_value` STRING COMMENT 'The new value of the changed field after the amendment is applied. Stored as STRING to accommodate various field types. Represents the authoritative post-amendment state.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this amendment record originated (e.g., SAP S/4HANA, SAP Ariba). Supports data lineage tracking and reconciliation in the lakehouse.. Valid values are `SAP_S4HANA|SAP_ARIBA|MANUAL|OTHER`',
    `status` STRING COMMENT 'Current lifecycle status of the purchase order amendment, tracking its progression from creation through supplier acknowledgment or rejection.. Valid values are `draft|pending_approval|approved|rejected|sent_to_supplier|supplier_acknowledged|supplier_rejected|cancelled|superseded`',
    `supplier_acknowledgment_date` DATE COMMENT 'Date on which the supplier formally acknowledged or responded to the purchase order amendment. Used for supplier responsiveness measurement and SLA compliance tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `supplier_acknowledgment_status` STRING COMMENT 'Status of the suppliers formal acknowledgment of the purchase order amendment. Tracks whether the supplier has accepted, rejected, or partially accepted the proposed changes.. Valid values are `not_sent|pending|acknowledged|rejected|partially_accepted|overdue`',
    `supplier_notification_date` DATE COMMENT 'Date on which the approved amendment was formally communicated to the supplier. Used to measure supplier notification lead time and track contractual notification obligations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `supplier_rejection_reason` STRING COMMENT 'Free-text reason provided by the supplier when rejecting or partially accepting the purchase order amendment. Supports supplier negotiation, dispute resolution, and procurement process improvement.',
    `value_change_amount` DECIMAL(18,2) COMMENT 'The net monetary impact of the amendment (revised_po_value minus original_po_value). Positive values indicate cost increases; negative values indicate savings or reductions. Used for spend analytics and savings reporting.',
    CONSTRAINT pk_purchase_order_amendment PRIMARY KEY(`purchase_order_amendment_id`)
) COMMENT 'Records formal amendments and change orders applied to issued purchase orders including quantity changes, price adjustments, delivery date revisions, and scope changes. Captures amendment number, amendment type, original value, revised value, reason code, requester, and supplier acknowledgment status. Supports PO change management and audit trail requirements.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` (
    `mro_catalog_id` BIGINT COMMENT 'Unique surrogate identifier for each MRO catalog item in the Databricks Silver Layer. Serves as the primary key for the mro_catalog data product.',
    `catalog_item_id` BIGINT COMMENT 'Native item identifier assigned by SAP Ariba Catalog for the MRO item. Enables direct traceability to the source procurement catalog system.',
    `procurement_spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.spend_category. Business justification: MRO catalog items are classified by spend category for procurement analytics and category management. The table has spend_category_code. Adding spend_category_id FK formalizes this relationship and en',
    `spare_part_id` BIGINT COMMENT 'Foreign key linking to asset.spare_part. Business justification: MRO catalogs reference master spare part data from asset management. Procurement uses this link to ensure catalog items match approved technical specifications for equipment.',
    `spare_parts_catalog_id` BIGINT COMMENT 'Foreign key linking to service.spare_parts_catalog. Business justification: MRO procurement catalogs reference service spare parts catalogs to ensure correct parts ordering. Procurement maintains pricing while service defines technical specifications and compatibility.',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supplier. Business justification: MRO catalog references approved supplier via approved_supplier_code (STRING). Adding FK for referential integrity, removing redundant supplier code and name fields.',
    `abc_classification` STRING COMMENT 'ABC inventory classification of the MRO item based on annual consumption value. A=high value/high priority, B=medium, C=low value. Drives inventory control policies and cycle count frequency.. Valid values are `A|B|C`',
    `catalog_item_number` STRING COMMENT 'Business-facing unique identifier for the MRO catalog item as maintained in SAP Ariba Catalog or SAP MM. Used for cross-system referencing and procurement transactions.. Valid values are `^MRO-[A-Z0-9]{4,20}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the MRO catalog item record was first created in the source system. Provides audit trail for catalog item lifecycle management.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `criticality_classification` STRING COMMENT 'Criticality rating of the MRO item based on its impact on production continuity and equipment availability. Critical items require higher safety stock and expedited procurement. Supports Total Productive Maintenance (TPM) and asset reliability programs.. Valid values are `critical|important|standard|non_critical`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the standard price (e.g., USD, EUR, GBP). Supports multi-currency operations across global manufacturing sites.. Valid values are `^[A-Z]{3}$`',
    `effective_end_date` DATE COMMENT 'Date after which this MRO catalog item is no longer valid for procurement. Triggers item review or obsolescence workflow. Null indicates no planned expiry.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_start_date` DATE COMMENT 'Date from which this MRO catalog item is valid and available for procurement. Supports catalog lifecycle management and time-bound item availability.. Valid values are `^d{4}-d{2}-d{2}$`',
    `equipment_compatibility` STRING COMMENT 'Description or list of equipment models, asset classes, or functional locations for which this MRO item is approved and compatible. Supports maintenance planning and spare parts management in Maximo EAM.',
    `gl_account_code` STRING COMMENT 'General ledger account code for financial posting of MRO procurement costs. Ensures correct cost allocation between OPEX maintenance accounts and CAPEX asset accounts.',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether the MRO item is classified as a hazardous material requiring special handling, storage, and disposal procedures. Triggers compliance workflows under OSHA, EPA, and REACH regulations.. Valid values are `true|false`',
    `item_category` STRING COMMENT 'High-level classification of the MRO item type. Drives procurement routing, spend analytics, and category management strategies within the MRO program.. Valid values are `spare_part|consumable|tooling|facility_supply|safety_item|lubricant|electrical|instrumentation|hydraulic|pneumatic|fastener|chemical|ppe|other`',
    `item_description` STRING COMMENT 'Detailed technical description of the MRO item including specifications, dimensions, material composition, and application context. Supports accurate identification and maverick spend reduction.',
    `item_name` STRING COMMENT 'Short descriptive name of the MRO catalog item (e.g., Bearing SKF 6205, Hydraulic Filter 10 Micron). Used for display in procurement portals and purchase requisitions.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the MRO catalog item record. Used for change tracking, delta processing in the Databricks Silver Layer, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_reviewed_date` DATE COMMENT 'Date when the MRO catalog item was last reviewed for accuracy, pricing validity, supplier approval status, and compliance. Supports catalog governance and data quality management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `lead_time_days` STRING COMMENT 'Standard supplier lead time in calendar days from purchase order placement to goods receipt at the plant. Used for MRP/MRP II planning, reorder point calculation, and delivery scheduling.. Valid values are `^[0-9]+$`',
    `manufacturer_name` STRING COMMENT 'Name of the original equipment manufacturer (OEM) or brand owner of the MRO item. Critical for approved manufacturer list (AML) compliance and warranty validation.',
    `manufacturer_part_number` STRING COMMENT 'The original part number assigned by the manufacturer. Enables cross-referencing across suppliers, ensures correct part identification, and supports interchangeability analysis.',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity that must be ordered per purchase order line for this MRO item, as stipulated by the supplier. Enforced during purchase requisition and PO creation.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or maintenance facility for which this MRO catalog item is approved and stocked. Supports plant-specific catalog views and procurement routing.',
    `price_valid_from_date` DATE COMMENT 'Start date from which the standard price is effective. Used to manage price validity periods and ensure accurate procurement cost estimation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `price_valid_to_date` DATE COMMENT 'End date after which the standard price expires and must be renegotiated or updated. Triggers price review workflows in SAP Ariba.. Valid values are `^d{4}-d{2}-d{2}$`',
    `purchasing_group_code` STRING COMMENT 'SAP purchasing group code responsible for procuring this MRO item. Determines the buyer/team accountable for sourcing, ordering, and supplier management for this item.',
    `reach_compliant` BOOLEAN COMMENT 'Indicates whether the MRO item complies with EU REACH regulation governing chemical substances. Required for chemical, lubricant, and material items used in manufacturing operations.. Valid values are `true|false`',
    `reorder_point` DECIMAL(18,2) COMMENT 'Minimum stock level (in the items unit of measure) at which a replenishment purchase requisition should be triggered. Calculated based on lead time, safety stock, and average consumption rate.',
    `rohs_compliant` BOOLEAN COMMENT 'Indicates whether the MRO item complies with the EU RoHS Directive restricting the use of specific hazardous substances in electrical and electronic equipment.. Valid values are `true|false`',
    `safety_stock_quantity` DECIMAL(18,2) COMMENT 'Buffer stock quantity maintained to protect against demand variability and supply disruptions. Expressed in the items unit of measure and used in MRP planning calculations.',
    `sap_material_number` STRING COMMENT 'Material master number assigned in SAP S/4HANA MM module for the MRO item. Links the catalog entry to the SAP material master record for inventory and procurement processing.',
    `spend_category_code` STRING COMMENT 'Internal procurement spend category code assigned to the MRO item. Aligns with the enterprise spend taxonomy for category management, budget allocation, and sourcing strategy.',
    `standard_price` DECIMAL(18,2) COMMENT 'Standard unit price for the MRO item used for purchase requisition valuation, budget planning, and spend analytics. Represents the approved catalog price per unit of measure.',
    `status` STRING COMMENT 'Current lifecycle status of the MRO catalog item. Controls whether the item is available for procurement requisitioning. Blocked prevents ordering; obsolete indicates superseded items.. Valid values are `active|inactive|pending_approval|obsolete|under_review|blocked`',
    `storage_location_code` STRING COMMENT 'SAP storage location code within the plant where this MRO item is physically stored. Used for inventory management, goods receipt posting, and stock replenishment.',
    `supplier_part_number` STRING COMMENT 'The part number used by the approved supplier to identify this MRO item in their catalog. Required for accurate purchase order line item creation and supplier communication.',
    `unit_of_measure` STRING COMMENT 'Standard unit of measure for ordering and inventory management of the MRO item (e.g., EA=Each, PK=Pack, KG=Kilogram). Aligns with SAP MM base unit of measure.. Valid values are `EA|PK|BX|KG|LT|MT|M|M2|M3|SET|ROL|PAL|DZ|HR|PR`',
    `unspsc_code` STRING COMMENT 'Standardized 8-digit UNSPSC commodity classification code for the MRO item. Enables global spend analytics, benchmarking, and category management alignment.. Valid values are `^[0-9]{8}$`',
    CONSTRAINT pk_mro_catalog PRIMARY KEY(`mro_catalog_id`)
) COMMENT 'Catalog of approved MRO (Maintenance, Repair, and Operations) items available for procurement including spare parts, consumables, tooling, and facility supplies. Captures item description, manufacturer part number, approved supplier(s), unit of measure, standard price, lead time, and reorder point. Supports MRO procurement efficiency and maverick spend reduction via SAP Ariba Catalog.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` (
    `procurement_policy_id` BIGINT COMMENT 'Unique system-generated identifier for each procurement governance policy record in the lakehouse silver layer.',
    `compliance_policy_id` BIGINT COMMENT 'External reference identifier for this policy record in SAP Ariba, enabling cross-system traceability between the lakehouse silver layer and the operational procurement system.',
    `applicability_scope` STRING COMMENT 'Organizational level at which the procurement policy applies, ranging from global enterprise-wide enforcement to specific plants, purchasing organizations, or cost centers.. Valid values are `global|regional|country|company_code|purchasing_org|plant|cost_center|business_unit`',
    `applicable_company_code` STRING COMMENT 'SAP company code identifying the legal entity to which this procurement policy applies. Supports multi-entity governance in multinational operations.',
    `applicable_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code identifying the specific country to which this policy applies. Null if the policy applies globally or regionally.. Valid values are `^[A-Z]{3}$`',
    `applicable_purchasing_org` STRING COMMENT 'SAP purchasing organization code scoping the policy to a specific procurement unit. Null if the policy applies across all purchasing organizations.',
    `applicable_region_code` STRING COMMENT 'Geographic region code to which this policy applies (e.g., EMEA, APAC, AMER). Used for multinational policy scoping where rules differ by region.',
    `approval_level` STRING COMMENT 'Hierarchical approval tier required for procurement actions subject to this policy, aligned to the companys delegation of authority matrix.. Valid values are `level_1|level_2|level_3|level_4|board`',
    `approval_role` STRING COMMENT 'Job role or organizational role required to authorize procurement actions governed by this policy (e.g., Category Manager, CFO, VP Procurement, Plant Manager).',
    `approved_by` STRING COMMENT 'Name or employee identifier of the individual who formally approved this procurement policy for active enforcement.',
    `approved_date` DATE COMMENT 'Date on which the procurement policy was formally approved by the designated authority.. Valid values are `^d{4}-d{2}-d{2}$`',
    `category` STRING COMMENT 'Spend category classification to which this policy applies, distinguishing between direct materials, indirect materials, services, capital expenditure (CAPEX), or maintenance repair and operations (MRO).. Valid values are `direct_material|indirect_material|services|capital_expenditure|mro|it_and_software|logistics|all`',
    `conflict_minerals_applicable` BOOLEAN COMMENT 'Indicates whether this policy requires suppliers to provide conflict minerals compliance declarations (3TG: tin, tantalum, tungsten, gold) under Dodd-Frank Section 1502.. Valid values are `true|false`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the procurement policy record was first created in the system, used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `description` STRING COMMENT 'Detailed narrative describing the purpose, scope, and intent of the procurement policy, including the business rationale and compliance objectives.',
    `effective_end_date` DATE COMMENT 'Date on which the procurement policy expires or is superseded. Null indicates the policy is open-ended with no planned expiry.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_start_date` DATE COMMENT 'Date from which the procurement policy becomes enforceable across the applicable organizational scope.. Valid values are `^d{4}-d{2}-d{2}$`',
    `enforcement_mechanism` STRING COMMENT 'Method by which the policy is enforced in procurement systems. Hard blocks prevent non-compliant transactions; soft warnings alert users; approval_required routes to an approver; audit_only logs violations for review.. Valid values are `hard_block|soft_warning|approval_required|audit_only|system_enforced|manual_review`',
    `exception_allowed` BOOLEAN COMMENT 'Indicates whether formal exceptions to this policy are permitted. When true, buyers may request a documented exception with appropriate approvals.. Valid values are `true|false`',
    `exception_approval_role` STRING COMMENT 'Job role authorized to approve exceptions to this procurement policy. Typically a senior procurement leader or CFO depending on the policy type and spend level.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the procurement policy record, supporting change tracking and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_review_date` DATE COMMENT 'Date on which the procurement policy was most recently reviewed for continued relevance, accuracy, and compliance alignment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `max_spend_threshold` DECIMAL(18,2) COMMENT 'Maximum spend value (in the policy currency) up to which this policy rule applies. Null indicates no upper bound, meaning the policy applies to all spend above the minimum threshold.',
    `min_competitive_bids_required` STRING COMMENT 'Minimum number of supplier bids or quotes required for a sourcing event governed by this policy. Typically 3 for standard competitive sourcing events (RFQ/RFP).. Valid values are `^[0-9]+$`',
    `min_spend_threshold` DECIMAL(18,2) COMMENT 'Minimum spend value (in the policy currency) at or above which this policy rule is triggered. For example, the lower bound of a spend band requiring competitive bidding.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of this procurement policy to ensure it remains current with regulatory requirements and business needs.. Valid values are `^d{4}-d{2}-d{2}$`',
    `number` STRING COMMENT 'Human-readable business identifier for the procurement policy, used for referencing in sourcing events, purchase orders, and audit documentation.. Valid values are `^POL-[A-Z]{2,6}-[0-9]{4}-[0-9]{4}$`',
    `owner_department` STRING COMMENT 'Organizational department responsible for this procurement policy, such as Strategic Sourcing, Category Management, or Procurement Compliance.',
    `owner_name` STRING COMMENT 'Name of the business owner responsible for maintaining, reviewing, and enforcing this procurement policy. Typically a Category Manager or Chief Procurement Officer.',
    `preferred_supplier_enforcement` BOOLEAN COMMENT 'Indicates whether this policy mandates procurement from the approved Preferred Supplier List (PSL). When true, buyers must select from PSL-approved suppliers or obtain a documented exception.. Valid values are `true|false`',
    `reach_compliance_required` BOOLEAN COMMENT 'Indicates whether this policy mandates supplier compliance with EU REACH regulation for chemical substance registration and restriction.. Valid values are `true|false`',
    `rohs_compliance_required` BOOLEAN COMMENT 'Indicates whether this policy mandates that procured materials and components comply with the EU Restriction of Hazardous Substances (RoHS) Directive.. Valid values are `true|false`',
    `single_source_justification_required` BOOLEAN COMMENT 'Indicates whether a formal single-source justification document is required when procuring from a sole supplier without competitive bidding under this policy.. Valid values are `true|false`',
    `sourcing_event_type_required` STRING COMMENT 'Type of sourcing event mandated by this policy for qualifying spend. For example, spend above a threshold may require a formal Request for Proposal (RFP) or reverse auction.. Valid values are `rfq|rfp|reverse_auction|sole_source|framework_agreement|none`',
    `spend_threshold_currency` STRING COMMENT 'ISO 4217 three-letter currency code in which spend authorization thresholds and sourcing event trigger amounts are denominated.. Valid values are `^[A-Z]{3}$`',
    `status` STRING COMMENT 'Current lifecycle status of the procurement policy, governing whether it is enforceable, under revision, or retired from active use.. Valid values are `draft|under_review|approved|active|suspended|superseded|retired`',
    `supplier_diversity_required` BOOLEAN COMMENT 'Indicates whether this policy mandates consideration of diverse suppliers (minority-owned, women-owned, veteran-owned, small business) in the sourcing process.. Valid values are `true|false`',
    `sustainability_mandate` BOOLEAN COMMENT 'Indicates whether this policy includes mandatory sustainability requirements such as supplier environmental certifications, carbon footprint reporting, or RoHS/REACH compliance.. Valid values are `true|false`',
    `title` STRING COMMENT 'Short descriptive title of the procurement policy, such as Competitive Bidding Threshold Policy or Single-Source Justification Requirement.',
    `type` STRING COMMENT 'Classification of the procurement policy by its governance function, such as spend authorization thresholds, mandatory sourcing event requirements, or sustainability mandates.. Valid values are `spend_authorization|sourcing_event_requirement|preferred_supplier_enforcement|single_source_justification|sustainability_mandate|supplier_diversity|conflict_of_interest|payment_terms|contract_compliance|data_privacy|ethics_and_conduct|import_export_control`',
    `version_number` STRING COMMENT 'Version identifier for the procurement policy document, enabling tracking of revisions and ensuring users reference the current approved version.. Valid values are `^[0-9]+.[0-9]+$`',
    CONSTRAINT pk_procurement_policy PRIMARY KEY(`procurement_policy_id`)
) COMMENT 'Defines procurement governance policies and compliance rules including spend authorization thresholds by role and cost center, mandatory sourcing event requirements by spend value, preferred supplier enforcement rules, single-source justification requirements, and sustainability procurement mandates. Captures policy type, applicability scope, effective date, and enforcement mechanism.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` (
    `supplier_collaboration_id` BIGINT COMMENT 'Unique system-generated identifier for each supplier collaboration record',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to the supplier participating in this R&D collaboration',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to the R&D project participating in this supplier collaboration',
    `collaboration_type` STRING COMMENT 'Classification of the nature of supplier participation in the R&D project. Identified in detection phase as relationship-specific data.',
    `contribution_area` STRING COMMENT 'Specific technical domain or component area where the supplier is contributing expertise or materials. Identified in detection phase as relationship-specific data.',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this collaboration record was created in the system.',
    `end_date` DATE COMMENT 'Date when the supplier collaboration concluded or is planned to conclude. Identified in detection phase as relationship-specific data.',
    `funding_amount` DECIMAL(18,2) COMMENT 'Financial value of supplier contribution or funding allocated to this specific collaboration. Identified in detection phase as relationship-specific data.',
    `funding_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the funding amount in this collaboration.',
    `ip_ownership_terms` STRING COMMENT 'Contractual terms defining intellectual property ownership and licensing rights resulting from this collaboration. Identified in detection phase as relationship-specific data.',
    `modified_date` TIMESTAMP COMMENT 'Timestamp when this collaboration record was last modified.',
    `nda_reference` STRING COMMENT 'Reference to the Non-Disclosure Agreement governing confidential information sharing in this collaboration.',
    `start_date` DATE COMMENT 'Date when the supplier formally began participation in the R&D project. Identified in detection phase as relationship-specific data.',
    `status` STRING COMMENT 'Current lifecycle status of the supplier collaboration within the R&D project.',
    CONSTRAINT pk_supplier_collaboration PRIMARY KEY(`supplier_collaboration_id`)
) COMMENT 'This association product represents the collaboration contract between R&D projects and suppliers for co-development initiatives. It captures supplier participation in innovation projects including technical contributions, funding arrangements, and intellectual property terms. Each record links one R&D project to one supplier with attributes that exist only in the context of this collaborative relationship.. Existence Justification: In industrial manufacturing R&D operations, projects routinely engage multiple suppliers for co-development of automation systems, electrification components, and smart infrastructure technologies. Each supplier may participate in multiple R&D initiatives across different technology domains. The collaboration itself is a managed business entity with contractual terms, funding arrangements, technical contribution areas, and IP ownership agreements that belong to neither the project nor the supplier alone.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` (
    `supplier_service_contract_id` BIGINT COMMENT 'Unique system-generated identifier for this supplier-service contract association record',
    `contract_id` BIGINT COMMENT 'Foreign key linking to the customer service contract under which this supplier is engaged',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to the supplier engaged to provide services or parts under this customer service contract',
    `service_contract_id` BIGINT COMMENT 'Foreign key to service.service_contract.service_contract_id',
    `annual_value` DECIMAL(18,2) COMMENT 'The annualized monetary value allocated to this supplier for their portion of service delivery under this customer contract. Used for supplier performance tracking and cost allocation.',
    `coverage_scope` STRING COMMENT 'Description of the specific equipment types, geographic regions, or service categories that this supplier is responsible for under this customer service contract. Defines the suppliers bounded scope within the overall contract.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this supplier-service contract association record was created',
    `end_date` DATE COMMENT 'The date on which this suppliers engagement under this specific customer service contract ends. May differ from the overall service contract end date if suppliers are rotated or removed.',
    `primary_supplier_flag` BOOLEAN COMMENT 'Indicates whether this supplier is designated as the primary or lead supplier for this service contract, with overall coordination responsibility when multiple suppliers are engaged.',
    `response_time_sla` DECIMAL(18,2) COMMENT 'Maximum number of hours within which this specific supplier must respond to service requests under this contract. May differ from the overall contract SLA if multiple suppliers have different response commitments.',
    `service_level` STRING COMMENT 'The service level tier or classification assigned to this supplier for this specific contract, defining their performance expectations and priority level within the multi-supplier service delivery model.',
    `start_date` DATE COMMENT 'The date on which this suppliers engagement under this specific customer service contract becomes effective. May differ from the overall service contract start date if suppliers are added mid-contract.',
    `status` STRING COMMENT 'Current status of this suppliers engagement under this specific service contract. Tracks whether the supplier is actively delivering services, temporarily suspended, or terminated from this contract.',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp when this supplier-service contract association record was last updated',
    CONSTRAINT pk_supplier_service_contract PRIMARY KEY(`supplier_service_contract_id`)
) COMMENT 'This association product represents the contractual relationship between suppliers and outbound customer service contracts. It captures which suppliers are engaged to fulfill service obligations under customer service agreements, including their specific scope, SLA commitments, and commercial terms. Each record links one supplier to one service_contract with attributes that exist only in the context of this suppliers participation in delivering that specific customer service contract.. Existence Justification: In industrial manufacturing after-sales service operations, customer service contracts frequently require engagement of multiple suppliers (OEM parts suppliers, specialized service providers, regional maintenance contractors, calibration labs) to fulfill comprehensive service obligations. Each supplier participates with specific scope boundaries (geographic coverage, equipment types, service categories), distinct SLA commitments, and allocated contract value. Conversely, a single supplier may be engaged across multiple customer service contracts with varying terms. This is an operational relationship actively managed by service delivery teams.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` (
    `supplier_compliance_id` BIGINT COMMENT 'Unique system-generated identifier for this supplier-obligation compliance record',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to the supplier master record',
    `regulatory_obligation_id` BIGINT COMMENT 'Foreign key linking to the regulatory obligation master record',
    `employee_id` BIGINT COMMENT 'Employee identifier of the procurement or HSE professional responsible for managing and verifying this suppliers compliance with this specific obligation.',
    `audit_score` DECIMAL(18,2) COMMENT 'Numerical score assigned to the supplier during compliance audit or assessment for this specific regulatory obligation. Used to quantify compliance quality and identify risk areas.',
    `certification_date` DATE COMMENT 'Date on which the supplier achieved certification or demonstrated compliance with this regulatory obligation. Used to track when compliance was established.',
    `compliance_status` STRING COMMENT 'Current compliance status of this specific supplier against this specific regulatory obligation. Tracks whether the supplier has met the requirement, is working toward it, or has failed to comply.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this supplier compliance record was created in the system.',
    `evidence_document_reference` STRING COMMENT 'Reference to the document management system location where compliance evidence (certificates, test reports, declarations) for this supplier-obligation combination is stored.',
    `expiry_date` DATE COMMENT 'Date on which the suppliers certification or compliance status for this obligation expires and requires renewal or re-verification. Supplier-specific expiry may differ from the general obligation expiry.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'System timestamp when this supplier compliance record was most recently updated.',
    `last_verification_date` DATE COMMENT 'Date on which the suppliers compliance with this regulatory obligation was most recently verified through audit, inspection, or documentation review. Used to track verification currency.',
    `next_verification_due_date` DATE COMMENT 'Scheduled date for the next verification or audit of this suppliers compliance with this regulatory obligation. Drives compliance monitoring workflows.',
    `non_conformance_count` BIGINT COMMENT 'Number of non-conformances or violations identified for this supplier against this specific regulatory obligation during audits or inspections. Tracks compliance quality.',
    `notes` STRING COMMENT 'Free-text notes capturing additional context, exceptions, corrective actions, or special conditions related to this suppliers compliance with this regulatory obligation.',
    CONSTRAINT pk_supplier_compliance PRIMARY KEY(`supplier_compliance_id`)
) COMMENT 'This association product represents the compliance relationship between a supplier and a regulatory obligation. It captures supplier-specific compliance status, certification dates, audit results, and non-conformance tracking for each regulatory requirement. Each record links one supplier to one regulatory obligation with attributes that exist only in the context of this specific compliance relationship.. Existence Justification: In industrial manufacturing, suppliers must comply with multiple regulatory obligations (REACH, RoHS, conflict minerals, ISO certifications, OSHA requirements), and each regulatory obligation applies to multiple suppliers across the supply network. Procurement and HSE jointly manage supplier-specific compliance status, tracking certification dates, audit scores, non-conformances, and verification schedules for each supplier-obligation combination. This is an operational compliance management process, not an analytical correlation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` (
    `supplier_certification_id` BIGINT COMMENT 'Primary key for the supplier_certification association',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to the supplier who holds this certification',
    `product_certification_id` BIGINT COMMENT 'Foreign key linking to the product certification held by the supplier',
    `audit_date` DATE COMMENT 'Date of the most recent audit or assessment conducted for this supplier-certification combination.',
    `certificate_number` STRING COMMENT 'Unique certificate number or reference code assigned to this supplier for this specific certification.',
    `certification_date` DATE COMMENT 'Date on which this specific supplier obtained this product certification. Tracks when the supplier-certification relationship was established.',
    `certification_scope` STRING COMMENT 'Specific scope of certification for this supplier, detailing which products, processes, or facilities are covered under this certification.',
    `expiry_date` DATE COMMENT 'Date on which this suppliers certification expires. Drives renewal workflows and qualified supplier list eligibility.',
    `issuing_body` STRING COMMENT 'Name of the certification body or auditing organization that issued this certification to the supplier.',
    `next_audit_date` DATE COMMENT 'Scheduled date for the next surveillance audit or recertification audit for this supplier-certification.',
    `renewal_status` STRING COMMENT 'Current status of the certification renewal process for this supplier-certification combination. Tracks whether renewal is not due, pending, in progress, completed, expired, or suspended.',
    `status` STRING COMMENT 'Current operational status of this supplier certification record. Controls whether the supplier is considered qualified under this certification for procurement purposes.',
    CONSTRAINT pk_supplier_certification PRIMARY KEY(`supplier_certification_id`)
) COMMENT 'This association product represents the certification relationship between suppliers and product certifications. It captures which suppliers hold which product-level certifications, tracking the certification validity period, scope, issuing body, and renewal status specific to each supplier-certification combination. Each record links one supplier to one product certification with attributes that exist only in the context of this relationship.. Existence Justification: In industrial manufacturing supply chain operations, suppliers hold multiple product certifications (ISO9001, ISO14001, IATF16949, UL, CE marking) to qualify for different product categories and markets, and each certification standard applies to multiple suppliers across the supply network. The business actively manages supplier-certification relationships as operational records with certification dates, expiry tracking, renewal workflows, and qualified supplier list eligibility determination.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` (
    `supplier_control_plan_approval_id` BIGINT COMMENT 'Unique system-generated identifier for this supplier-control plan approval record',
    `control_plan_id` BIGINT COMMENT 'Foreign key linking to the quality control plan being approved and executed',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to the supplier responsible for executing the control plan',
    `approval_date` DATE COMMENT 'Date on which the supplier was approved to execute this control plan. Used for PPAP submission tracking and audit trail.',
    `approval_status` STRING COMMENT 'Current approval status of the control plan for this specific supplier. Tracks whether the supplier has been approved to execute this control plan.',
    `approved_by` STRING COMMENT 'Identifier of the quality engineer or manager who approved this supplier for this control plan. Supports audit trail and accountability.',
    `audit_frequency` STRING COMMENT 'Frequency at which this suppliers execution of this control plan is audited (e.g., MONTHLY, QUARTERLY, ANNUALLY). May vary by supplier risk tier and compliance history.',
    `compliance_level` STRING COMMENT 'Assessment of the suppliers compliance with the control plan requirements. Tracks how well the supplier is executing the control plan in practice.',
    `effective_date` DATE COMMENT 'Date on which this supplier-specific control plan approval became effective. May differ from the control plans overall effective date if supplier approval occurred later.',
    `expiration_date` DATE COMMENT 'Date on which this supplier approval expires and requires renewal. Common in industries with periodic re-qualification requirements.',
    `last_audit_date` DATE COMMENT 'Date of the most recent audit of this suppliers execution of this control plan. Used to schedule next audit based on audit_frequency.',
    `next_audit_date` DATE COMMENT 'Scheduled date for the next audit of this suppliers execution of this control plan. Calculated based on last_audit_date and audit_frequency.',
    `notes` STRING COMMENT 'Free-text notes capturing supplier-specific considerations, conditions, or exceptions related to this control plan approval.',
    `revision_number` STRING COMMENT 'Supplier-specific revision number tracking the version of the control plan that this supplier has been approved for. Enables tracking when suppliers are on different revision levels.',
    `supplier_code` STRING COMMENT 'Code identifying the supplier responsible for the controlled process, applicable when the control plan governs a supplier-managed or outsourced manufacturing step. [Moved from control_plan: This attribute in control_plan currently stores a single supplier code, but in reality, a control plan may be approved for multiple suppliers (e.g., in a multi-source supply chain or when a process spans multiple suppliers). Moving this to the association allows tracking which suppliers are approved for each control plan with supplier-specific approval details.]',
    CONSTRAINT pk_supplier_control_plan_approval PRIMARY KEY(`supplier_control_plan_approval_id`)
) COMMENT 'This association product represents the approval and compliance relationship between a supplier and a control plan. It captures the supplier-specific approval status, revision tracking, compliance level, and audit frequency for each control plan that a supplier is responsible for executing. Each record links one control plan to one supplier with attributes that exist only in the context of this supplier-plan relationship.. Existence Justification: In industrial manufacturing, control plans are jointly developed and approved between customers and suppliers for critical manufacturing processes. A single control plan may cover processes executed by multiple suppliers in a multi-tier supply chain (e.g., a stamping process control plan approved for both primary and backup suppliers). Conversely, a supplier typically has multiple control plans covering different parts, processes, or customer programs they manufacture. The approval relationship itself carries critical data: approval status, effective dates, revision tracking, compliance assessments, and audit schedules that are specific to each supplier-control plan combination.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` (
    `po_compliance_verification_id` BIGINT COMMENT 'Unique surrogate identifier for each purchase order compliance verification record',
    `compliance_obligation_id` BIGINT COMMENT 'Foreign key to compliance.compliance_obligation',
    `obligation_id` BIGINT COMMENT 'Foreign key linking to the specific compliance obligation being verified',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to the purchase order being verified for compliance',
    `compliance_notes` STRING COMMENT 'Free-text notes documenting the verification process, any issues encountered, waiver justifications, or additional context specific to this PO-obligation verification. Explicitly identified in detection phase relationship data.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this compliance verification record was created, typically when the PO was submitted for approval and compliance checks were initiated.',
    `evidence_document` STRING COMMENT 'Reference path, URL, or document ID pointing to the evidence documentation that supports compliance verification for this PO-obligation pair (e.g., export license, safety certificate, supplier audit report). Explicitly identified in detection phase relationship data.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent update to this verification record, supporting audit trail and change tracking.',
    `obligation_status` STRING COMMENT 'Current verification status of this specific compliance obligation for this purchase order. Indicates whether the obligation has been verified, is pending review, or has failed verification. Explicitly identified in detection phase relationship data.',
    `responsible_buyer` STRING COMMENT 'Name or employee ID of the procurement buyer responsible for verifying this compliance obligation for this purchase order. May differ from the PO creator if compliance verification is delegated. Explicitly identified in detection phase relationship data.',
    `verification_date` DATE COMMENT 'Date on which this compliance obligation was verified as fulfilled for this purchase order. Used to track compliance timeline and audit trail. Explicitly identified in detection phase relationship data.',
    `verification_method` STRING COMMENT 'Method used to verify compliance for this specific PO-obligation pair. Supports audit trail and process improvement analysis.',
    CONSTRAINT pk_po_compliance_verification PRIMARY KEY(`po_compliance_verification_id`)
) COMMENT 'This association product represents the operational verification event between purchase_order and compliance_obligation. It captures the specific compliance obligations that must be verified and fulfilled before a purchase order can be released, transmitted, or paid. Each record links one purchase order to one compliance obligation with verification status, evidence, and responsible party. This is an active operational control point in the procurement-to-pay process, not a derived analytical correlation.. Existence Justification: In industrial manufacturing procurement, a single purchase order can trigger multiple compliance obligations simultaneously (export controls, environmental regulations, labor standards, product safety certifications, conflict minerals disclosure), and each compliance obligation applies to many purchase orders over time. Procurement teams actively manage compliance verification as an operational control point before PO release, transmission, and payment approval. This is not an analytical correlation but an operational business process where buyers verify specific obligations, document evidence, and track verification status for each PO-obligation pair.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ADD CONSTRAINT `fk_procurement_procurement_supplier_qualification_procurement_spend_category_id` FOREIGN KEY (`procurement_spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_spend_category`(`procurement_spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ADD CONSTRAINT `fk_procurement_procurement_sourcing_event_procurement_spend_category_id` FOREIGN KEY (`procurement_spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_spend_category`(`procurement_spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ADD CONSTRAINT `fk_procurement_procurement_sourcing_bid_incoterm_id` FOREIGN KEY (`incoterm_id`) REFERENCES `manufacturing_ecm`.`procurement`.`incoterm`(`incoterm_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ADD CONSTRAINT `fk_procurement_procurement_sourcing_bid_procurement_payment_term_id` FOREIGN KEY (`procurement_payment_term_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_payment_term`(`procurement_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ADD CONSTRAINT `fk_procurement_procurement_sourcing_bid_procurement_sourcing_event_id` FOREIGN KEY (`procurement_sourcing_event_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_sourcing_event`(`procurement_sourcing_event_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ADD CONSTRAINT `fk_procurement_procurement_sourcing_bid_procurement_spend_category_id` FOREIGN KEY (`procurement_spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_spend_category`(`procurement_spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ADD CONSTRAINT `fk_procurement_procurement_po_line_item_incoterm_id` FOREIGN KEY (`incoterm_id`) REFERENCES `manufacturing_ecm`.`procurement`.`incoterm`(`incoterm_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ADD CONSTRAINT `fk_procurement_procurement_po_line_item_procurement_material_info_record_id` FOREIGN KEY (`procurement_material_info_record_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_material_info_record`(`procurement_material_info_record_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ADD CONSTRAINT `fk_procurement_procurement_po_line_item_procurement_purchase_requisition_id` FOREIGN KEY (`procurement_purchase_requisition_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition`(`procurement_purchase_requisition_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ADD CONSTRAINT `fk_procurement_procurement_po_line_item_procurement_spend_category_id` FOREIGN KEY (`procurement_spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_spend_category`(`procurement_spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ADD CONSTRAINT `fk_procurement_procurement_po_line_item_procurement_supply_agreement_id` FOREIGN KEY (`procurement_supply_agreement_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_supply_agreement`(`procurement_supply_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ADD CONSTRAINT `fk_procurement_procurement_goods_receipt_procurement_inbound_delivery_id` FOREIGN KEY (`procurement_inbound_delivery_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery`(`procurement_inbound_delivery_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ADD CONSTRAINT `fk_procurement_goods_receipt_line_procurement_goods_receipt_id` FOREIGN KEY (`procurement_goods_receipt_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_goods_receipt`(`procurement_goods_receipt_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ADD CONSTRAINT `fk_procurement_goods_receipt_line_procurement_po_line_item_id` FOREIGN KEY (`procurement_po_line_item_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_po_line_item`(`procurement_po_line_item_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ADD CONSTRAINT `fk_procurement_procurement_supplier_invoice_procurement_goods_receipt_id` FOREIGN KEY (`procurement_goods_receipt_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_goods_receipt`(`procurement_goods_receipt_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ADD CONSTRAINT `fk_procurement_procurement_supplier_invoice_procurement_payment_term_id` FOREIGN KEY (`procurement_payment_term_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_payment_term`(`procurement_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ADD CONSTRAINT `fk_procurement_mrp_run_supply_network_node_id` FOREIGN KEY (`supply_network_node_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supply_network_node`(`supply_network_node_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_mrp_run_id` FOREIGN KEY (`mrp_run_id`) REFERENCES `manufacturing_ecm`.`procurement`.`mrp_run`(`mrp_run_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_procurement_purchase_requisition_id` FOREIGN KEY (`procurement_purchase_requisition_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition`(`procurement_purchase_requisition_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ADD CONSTRAINT `fk_procurement_demand_forecast_supply_network_node_id` FOREIGN KEY (`supply_network_node_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supply_network_node`(`supply_network_node_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ADD CONSTRAINT `fk_procurement_procurement_supply_agreement_incoterm_id` FOREIGN KEY (`incoterm_id`) REFERENCES `manufacturing_ecm`.`procurement`.`incoterm`(`incoterm_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ADD CONSTRAINT `fk_procurement_procurement_supply_agreement_procurement_payment_term_id` FOREIGN KEY (`procurement_payment_term_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_payment_term`(`procurement_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ADD CONSTRAINT `fk_procurement_procurement_supply_agreement_procurement_sourcing_event_id` FOREIGN KEY (`procurement_sourcing_event_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_sourcing_event`(`procurement_sourcing_event_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ADD CONSTRAINT `fk_procurement_procurement_supply_agreement_procurement_spend_category_id` FOREIGN KEY (`procurement_spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_spend_category`(`procurement_spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ADD CONSTRAINT `fk_procurement_delivery_schedule_incoterm_id` FOREIGN KEY (`incoterm_id`) REFERENCES `manufacturing_ecm`.`procurement`.`incoterm`(`incoterm_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ADD CONSTRAINT `fk_procurement_delivery_schedule_procurement_goods_receipt_id` FOREIGN KEY (`procurement_goods_receipt_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_goods_receipt`(`procurement_goods_receipt_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ADD CONSTRAINT `fk_procurement_delivery_schedule_procurement_po_line_item_id` FOREIGN KEY (`procurement_po_line_item_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_po_line_item`(`procurement_po_line_item_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ADD CONSTRAINT `fk_procurement_delivery_schedule_procurement_supply_agreement_id` FOREIGN KEY (`procurement_supply_agreement_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_supply_agreement`(`procurement_supply_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ADD CONSTRAINT `fk_procurement_procurement_supplier_performance_procurement_spend_category_id` FOREIGN KEY (`procurement_spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_spend_category`(`procurement_spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ADD CONSTRAINT `fk_procurement_procurement_supplier_performance_procurement_supplier_qualification_id` FOREIGN KEY (`procurement_supplier_qualification_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification`(`procurement_supplier_qualification_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ADD CONSTRAINT `fk_procurement_supply_risk_procurement_material_info_record_id` FOREIGN KEY (`procurement_material_info_record_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_material_info_record`(`procurement_material_info_record_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ADD CONSTRAINT `fk_procurement_supply_risk_procurement_spend_category_id` FOREIGN KEY (`procurement_spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_spend_category`(`procurement_spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ADD CONSTRAINT `fk_procurement_procurement_material_info_record_incoterm_id` FOREIGN KEY (`incoterm_id`) REFERENCES `manufacturing_ecm`.`procurement`.`incoterm`(`incoterm_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ADD CONSTRAINT `fk_procurement_procurement_material_info_record_procurement_payment_term_id` FOREIGN KEY (`procurement_payment_term_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_payment_term`(`procurement_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ADD CONSTRAINT `fk_procurement_source_list_incoterm_id` FOREIGN KEY (`incoterm_id`) REFERENCES `manufacturing_ecm`.`procurement`.`incoterm`(`incoterm_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ADD CONSTRAINT `fk_procurement_source_list_procurement_material_info_record_id` FOREIGN KEY (`procurement_material_info_record_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_material_info_record`(`procurement_material_info_record_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ADD CONSTRAINT `fk_procurement_source_list_procurement_supply_agreement_id` FOREIGN KEY (`procurement_supply_agreement_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_supply_agreement`(`procurement_supply_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ADD CONSTRAINT `fk_procurement_source_list_quota_arrangement_id` FOREIGN KEY (`quota_arrangement_id`) REFERENCES `manufacturing_ecm`.`procurement`.`quota_arrangement`(`quota_arrangement_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ADD CONSTRAINT `fk_procurement_quota_arrangement_procurement_material_info_record_id` FOREIGN KEY (`procurement_material_info_record_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_material_info_record`(`procurement_material_info_record_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ADD CONSTRAINT `fk_procurement_quota_arrangement_procurement_supply_agreement_id` FOREIGN KEY (`procurement_supply_agreement_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_supply_agreement`(`procurement_supply_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ADD CONSTRAINT `fk_procurement_procurement_inbound_delivery_incoterm_id` FOREIGN KEY (`incoterm_id`) REFERENCES `manufacturing_ecm`.`procurement`.`incoterm`(`incoterm_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ADD CONSTRAINT `fk_procurement_procurement_inbound_delivery_supply_network_node_id` FOREIGN KEY (`supply_network_node_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supply_network_node`(`supply_network_node_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ADD CONSTRAINT `fk_procurement_supplier_audit_spend_category_id` FOREIGN KEY (`spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`spend_category`(`spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ADD CONSTRAINT `fk_procurement_supplier_audit_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ADD CONSTRAINT `fk_procurement_supplier_audit_supplier_performance_id` FOREIGN KEY (`supplier_performance_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier_performance`(`supplier_performance_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ADD CONSTRAINT `fk_procurement_supply_network_node_incoterm_id` FOREIGN KEY (`incoterm_id`) REFERENCES `manufacturing_ecm`.`procurement`.`incoterm`(`incoterm_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ADD CONSTRAINT `fk_procurement_po_change_record_procurement_po_line_item_id` FOREIGN KEY (`procurement_po_line_item_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_po_line_item`(`procurement_po_line_item_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ADD CONSTRAINT `fk_procurement_procurement_contract_incoterm_id` FOREIGN KEY (`incoterm_id`) REFERENCES `manufacturing_ecm`.`procurement`.`incoterm`(`incoterm_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ADD CONSTRAINT `fk_procurement_procurement_contract_procurement_payment_term_id` FOREIGN KEY (`procurement_payment_term_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_payment_term`(`procurement_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ADD CONSTRAINT `fk_procurement_procurement_contract_procurement_sourcing_event_id` FOREIGN KEY (`procurement_sourcing_event_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_sourcing_event`(`procurement_sourcing_event_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ADD CONSTRAINT `fk_procurement_procurement_contract_procurement_spend_category_id` FOREIGN KEY (`procurement_spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_spend_category`(`procurement_spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ADD CONSTRAINT `fk_procurement_procurement_contract_procurement_supply_agreement_id` FOREIGN KEY (`procurement_supply_agreement_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_supply_agreement`(`procurement_supply_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ADD CONSTRAINT `fk_procurement_contract_line_item_incoterm_id` FOREIGN KEY (`incoterm_id`) REFERENCES `manufacturing_ecm`.`procurement`.`incoterm`(`incoterm_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ADD CONSTRAINT `fk_procurement_contract_line_item_procurement_contract_id` FOREIGN KEY (`procurement_contract_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_contract`(`procurement_contract_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_spend_category_id` FOREIGN KEY (`spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`spend_category`(`spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_line_item` ADD CONSTRAINT `fk_procurement_po_line_item_procurement_payment_term_id` FOREIGN KEY (`procurement_payment_term_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_payment_term`(`procurement_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_procurement_payment_term_id` FOREIGN KEY (`procurement_payment_term_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_payment_term`(`procurement_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ADD CONSTRAINT `fk_procurement_preferred_supplier_list_procurement_contract_id` FOREIGN KEY (`procurement_contract_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_contract`(`procurement_contract_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ADD CONSTRAINT `fk_procurement_preferred_supplier_list_sourcing_event_id` FOREIGN KEY (`sourcing_event_id`) REFERENCES `manufacturing_ecm`.`procurement`.`sourcing_event`(`sourcing_event_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ADD CONSTRAINT `fk_procurement_preferred_supplier_list_spend_category_id` FOREIGN KEY (`spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`spend_category`(`spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ADD CONSTRAINT `fk_procurement_preferred_supplier_list_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ADD CONSTRAINT `fk_procurement_preferred_supplier_list_supplier_qualification_id` FOREIGN KEY (`supplier_qualification_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier_qualification`(`supplier_qualification_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_performance` ADD CONSTRAINT `fk_procurement_supplier_performance_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ADD CONSTRAINT `fk_procurement_supplier_risk_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ADD CONSTRAINT `fk_procurement_supplier_risk_supplier_qualification_id` FOREIGN KEY (`supplier_qualification_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier_qualification`(`supplier_qualification_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ADD CONSTRAINT `fk_procurement_sourcing_award_incoterm_id` FOREIGN KEY (`incoterm_id`) REFERENCES `manufacturing_ecm`.`procurement`.`incoterm`(`incoterm_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ADD CONSTRAINT `fk_procurement_sourcing_award_procurement_contract_id` FOREIGN KEY (`procurement_contract_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_contract`(`procurement_contract_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ADD CONSTRAINT `fk_procurement_sourcing_award_procurement_payment_term_id` FOREIGN KEY (`procurement_payment_term_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_payment_term`(`procurement_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ADD CONSTRAINT `fk_procurement_sourcing_award_sourcing_bid_id` FOREIGN KEY (`sourcing_bid_id`) REFERENCES `manufacturing_ecm`.`procurement`.`sourcing_bid`(`sourcing_bid_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ADD CONSTRAINT `fk_procurement_sourcing_award_sourcing_event_id` FOREIGN KEY (`sourcing_event_id`) REFERENCES `manufacturing_ecm`.`procurement`.`sourcing_event`(`sourcing_event_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ADD CONSTRAINT `fk_procurement_sourcing_award_spend_category_id` FOREIGN KEY (`spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`spend_category`(`spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ADD CONSTRAINT `fk_procurement_sourcing_award_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_procurement_contract_id` FOREIGN KEY (`procurement_contract_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_contract`(`procurement_contract_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_procurement_goods_receipt_id` FOREIGN KEY (`procurement_goods_receipt_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_goods_receipt`(`procurement_goods_receipt_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_procurement_material_info_record_id` FOREIGN KEY (`procurement_material_info_record_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_material_info_record`(`procurement_material_info_record_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_procurement_payment_term_id` FOREIGN KEY (`procurement_payment_term_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_payment_term`(`procurement_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_procurement_po_line_item_id` FOREIGN KEY (`procurement_po_line_item_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_po_line_item`(`procurement_po_line_item_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_procurement_supplier_invoice_id` FOREIGN KEY (`procurement_supplier_invoice_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice`(`procurement_supplier_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_spend_category_id` FOREIGN KEY (`spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`spend_category`(`spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ADD CONSTRAINT `fk_procurement_savings_initiative_procurement_contract_id` FOREIGN KEY (`procurement_contract_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_contract`(`procurement_contract_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ADD CONSTRAINT `fk_procurement_savings_initiative_sourcing_event_id` FOREIGN KEY (`sourcing_event_id`) REFERENCES `manufacturing_ecm`.`procurement`.`sourcing_event`(`sourcing_event_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ADD CONSTRAINT `fk_procurement_savings_initiative_spend_category_id` FOREIGN KEY (`spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`spend_category`(`spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ADD CONSTRAINT `fk_procurement_savings_initiative_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ADD CONSTRAINT `fk_procurement_savings_initiative_supplier_performance_id` FOREIGN KEY (`supplier_performance_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier_performance`(`supplier_performance_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ADD CONSTRAINT `fk_procurement_purchase_requisition_approval_procurement_purchase_requisition_id` FOREIGN KEY (`procurement_purchase_requisition_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition`(`procurement_purchase_requisition_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_contact` ADD CONSTRAINT `fk_procurement_supplier_contact_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ADD CONSTRAINT `fk_procurement_supplier_certificate_spend_category_id` FOREIGN KEY (`spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`spend_category`(`spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ADD CONSTRAINT `fk_procurement_supplier_certificate_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ADD CONSTRAINT `fk_procurement_purchase_order_amendment_procurement_po_line_item_id` FOREIGN KEY (`procurement_po_line_item_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_po_line_item`(`procurement_po_line_item_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ADD CONSTRAINT `fk_procurement_mro_catalog_procurement_spend_category_id` FOREIGN KEY (`procurement_spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_spend_category`(`procurement_spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ADD CONSTRAINT `fk_procurement_mro_catalog_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier`(`supplier_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`procurement` SET TAGS ('dbx_division' = 'corporate');
ALTER SCHEMA `manufacturing_ecm`.`procurement` SET TAGS ('dbx_domain' = 'procurement');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `procurement_supplier_contact_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contact ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Contact ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `ariba_portal_username` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Portal Username');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `ariba_portal_username` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `contact_role` SET TAGS ('dbx_business_glossary_term' = 'Contact Role');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `contact_role` SET TAGS ('dbx_value_regex' = 'account_manager|quality_engineer|logistics_coordinator|executive_sponsor|technical_support|commercial_contact|regulatory_contact|other');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Contact Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `data_privacy_region` SET TAGS ('dbx_business_glossary_term' = 'Data Privacy Regulatory Region');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `data_privacy_region` SET TAGS ('dbx_value_regex' = 'EU|US|APAC|LATAM|MEA|OTHER');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `department` SET TAGS ('dbx_business_glossary_term' = 'Contact Department');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Contact Effective End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Contact Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `email` SET TAGS ('dbx_business_glossary_term' = 'Contact Email Address');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `fax_number` SET TAGS ('dbx_business_glossary_term' = 'Contact Fax Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `fax_number` SET TAGS ('dbx_value_regex' = '^+?[0-9s-().]{7,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `fax_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `fax_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `first_name` SET TAGS ('dbx_business_glossary_term' = 'Contact First Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `first_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `first_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `gdpr_consent_date` SET TAGS ('dbx_business_glossary_term' = 'General Data Protection Regulation (GDPR) Consent Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `gdpr_consent_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `gdpr_consent_given` SET TAGS ('dbx_business_glossary_term' = 'General Data Protection Regulation (GDPR) Consent Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `gdpr_consent_given` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `invoice_notification` SET TAGS ('dbx_business_glossary_term' = 'Invoice Notification Opt-In');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `invoice_notification` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `is_ariba_portal_user` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Portal User Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `is_ariba_portal_user` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `is_primary_contact` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `is_primary_contact` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `job_title` SET TAGS ('dbx_business_glossary_term' = 'Contact Job Title');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `last_name` SET TAGS ('dbx_business_glossary_term' = 'Contact Last Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `last_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `last_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `mobile_phone` SET TAGS ('dbx_business_glossary_term' = 'Contact Mobile Phone Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `mobile_phone` SET TAGS ('dbx_value_regex' = '^+?[0-9s-().]{7,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `mobile_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `mobile_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `nda_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Non-Disclosure Agreement (NDA) Expiry Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `nda_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `nda_signed` SET TAGS ('dbx_business_glossary_term' = 'Non-Disclosure Agreement (NDA) Signed Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `nda_signed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `nda_signed_date` SET TAGS ('dbx_business_glossary_term' = 'Non-Disclosure Agreement (NDA) Signed Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `nda_signed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Contact Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `phone` SET TAGS ('dbx_business_glossary_term' = 'Contact Phone Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `phone` SET TAGS ('dbx_value_regex' = '^+?[0-9s-().]{7,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `po_notification` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Notification Opt-In');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `po_notification` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `preferred_communication_channel` SET TAGS ('dbx_business_glossary_term' = 'Preferred Communication Channel');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `preferred_communication_channel` SET TAGS ('dbx_value_regex' = 'email|phone|ariba_portal|fax|video_conference|other');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `preferred_language` SET TAGS ('dbx_business_glossary_term' = 'Preferred Language');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `preferred_language` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `sourcing_event_notification` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Notification Opt-In');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `sourcing_event_notification` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Contact Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|do_not_contact');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `supplier_site_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Site Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ALTER COLUMN `time_zone` SET TAGS ('dbx_business_glossary_term' = 'Contact Time Zone');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `procurement_supplier_qualification_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Qualification ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `certification_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Certification Audit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `ppap_submission_id` SET TAGS ('dbx_business_glossary_term' = 'Ppap Submission Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `procurement_spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `safety_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Hse Audit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Qualification Approval Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|conditionally_approved|rejected|disqualified|suspended|expired');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `ariba_qualification_reference` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Qualification ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `audit_score` SET TAGS ('dbx_business_glossary_term' = 'Qualification Audit Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `audit_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `commodity_category_name` SET TAGS ('dbx_business_glossary_term' = 'Commodity Category Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `conditional_approval_conditions` SET TAGS ('dbx_business_glossary_term' = 'Conditional Approval Conditions');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `conflict_minerals_compliant` SET TAGS ('dbx_business_glossary_term' = 'Conflict Minerals Compliance Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `conflict_minerals_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `disqualification_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Disqualification Reason Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `disqualification_reason_code` SET TAGS ('dbx_value_regex' = 'quality_failure|audit_failure|financial_risk|regulatory_non_compliance|capacity_insufficient|ethical_violation|voluntary_withdrawal|strategic_decision|other');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `disqualification_reason_text` SET TAGS ('dbx_business_glossary_term' = 'Disqualification Reason Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Qualification Expiry Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `initiation_date` SET TAGS ('dbx_business_glossary_term' = 'Qualification Initiation Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `initiation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `is_single_source` SET TAGS ('dbx_business_glossary_term' = 'Single Source Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `is_single_source` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `iso_14001_certified` SET TAGS ('dbx_business_glossary_term' = 'ISO 14001 Environmental Management Certification');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `iso_14001_certified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `iso_14001_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'ISO 14001 Certification Expiry Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `iso_14001_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `iso_9001_certified` SET TAGS ('dbx_business_glossary_term' = 'ISO 9001 Quality Management Certification');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `iso_9001_certified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `iso_9001_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'ISO 9001 Certification Expiry Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `iso_9001_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Qualification Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `ppap_submission_date` SET TAGS ('dbx_business_glossary_term' = 'PPAP Submission Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `ppap_submission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `qualification_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Qualification Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `qualification_number` SET TAGS ('dbx_value_regex' = '^SQ-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `qualification_owner` SET TAGS ('dbx_business_glossary_term' = 'Qualification Owner');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `qualification_stage` SET TAGS ('dbx_business_glossary_term' = 'Qualification Stage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `qualification_stage` SET TAGS ('dbx_value_regex' = 'registration|document_review|risk_assessment|audit_scheduled|audit_in_progress|ppap_submission|ppap_review|final_approval|approved|conditionally_approved|disqualified|on_hold|expired');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `qualification_type` SET TAGS ('dbx_business_glossary_term' = 'Qualification Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `qualification_type` SET TAGS ('dbx_value_regex' = 'initial|re_qualification|conditional|emergency|development');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'REACH Compliance Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `requalification_due_date` SET TAGS ('dbx_business_glossary_term' = 'Re-Qualification Due Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `requalification_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `risk_tier` SET TAGS ('dbx_business_glossary_term' = 'Supplier Risk Tier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `risk_tier` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'RoHS Compliance Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ALTER COLUMN `supplier_site_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Site Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` SET TAGS ('dbx_subdomain' = 'strategic_sourcing');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `procurement_sourcing_event_id` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Event Owner Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `procurement_spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'Pending|Approved|Rejected|Escalated');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `ariba_event_reference` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Event ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `award_basis` SET TAGS ('dbx_business_glossary_term' = 'Award Basis');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `award_basis` SET TAGS ('dbx_value_regex' = 'Lowest Price|Best Value|Technical Merit|Weighted Score|Negotiated');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `award_decision_date` SET TAGS ('dbx_business_glossary_term' = 'Award Decision Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `award_decision_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `awarded_supplier_count` SET TAGS ('dbx_business_glossary_term' = 'Awarded Supplier Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `awarded_supplier_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `awarded_value` SET TAGS ('dbx_business_glossary_term' = 'Awarded Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `awarded_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `baseline_price_amount` SET TAGS ('dbx_business_glossary_term' = 'Baseline Price Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `baseline_price_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `bid_close_date` SET TAGS ('dbx_business_glossary_term' = 'Bid Close Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `bid_close_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `bid_close_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Bid Close Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `bid_close_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `bid_open_date` SET TAGS ('dbx_business_glossary_term' = 'Bid Open Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `bid_open_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `category_code` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `category_manager_name` SET TAGS ('dbx_business_glossary_term' = 'Category Manager Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `conflict_minerals_applicable` SET TAGS ('dbx_business_glossary_term' = 'Conflict Minerals Applicable Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `conflict_minerals_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `estimated_spend_amount` SET TAGS ('dbx_business_glossary_term' = 'Estimated Spend Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `estimated_spend_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `evaluation_criteria` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Criteria');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `event_number` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `event_number` SET TAGS ('dbx_value_regex' = '^SE-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `event_type` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `event_type` SET TAGS ('dbx_value_regex' = 'RFQ|RFP|RFI|Reverse Auction|eAuction|Multi-Round Negotiation');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `invited_supplier_count` SET TAGS ('dbx_business_glossary_term' = 'Invited Supplier Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `invited_supplier_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `is_multi_round` SET TAGS ('dbx_business_glossary_term' = 'Multi-Round Event Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `is_multi_round` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `is_reverse_auction` SET TAGS ('dbx_business_glossary_term' = 'Reverse Auction Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `is_reverse_auction` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'Direct|Indirect|Capital|MRO|Services');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `publish_date` SET TAGS ('dbx_business_glossary_term' = 'Event Publish Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `publish_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `reach_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'REACH Compliance Required Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `reach_compliance_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `realized_savings_amount` SET TAGS ('dbx_business_glossary_term' = 'Realized Savings Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `realized_savings_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `responding_supplier_count` SET TAGS ('dbx_business_glossary_term' = 'Responding Supplier Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `responding_supplier_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `rohs_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'RoHS Compliance Required Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `rohs_compliance_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `round_number` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Round Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `round_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `sap_rfq_number` SET TAGS ('dbx_business_glossary_term' = 'SAP RFQ (Request for Quotation) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP Ariba|SAP S/4HANA|Manual');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `sourcing_strategy` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Strategy');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `sourcing_strategy` SET TAGS ('dbx_value_regex' = 'Competitive Bidding|Single Source Justification|Sole Source|Preferred Supplier|Negotiated|Consortium');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'Draft|Published|Open|Closed|Awarded|Cancelled|On Hold|Pending Approval');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `target_savings_amount` SET TAGS ('dbx_business_glossary_term' = 'Target Savings Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `target_savings_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Title');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` SET TAGS ('dbx_subdomain' = 'strategic_sourcing');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `procurement_sourcing_bid_id` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Bid ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `incoterm_id` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `procurement_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `procurement_sourcing_event_id` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `procurement_spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `ariba_bid_reference` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Bid ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `award_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Award Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `award_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `awarded_quantity` SET TAGS ('dbx_business_glossary_term' = 'Awarded Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `bid_number` SET TAGS ('dbx_business_glossary_term' = 'Bid Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `bid_number` SET TAGS ('dbx_value_regex' = '^BID-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `bid_quantity` SET TAGS ('dbx_business_glossary_term' = 'Bid Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `bid_type` SET TAGS ('dbx_business_glossary_term' = 'Bid Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `bid_type` SET TAGS ('dbx_value_regex' = 'rfq_response|rfp_response|reverse_auction|sealed_bid|open_bid');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `commercial_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Commercial Compliance Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `commercial_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|conditionally_compliant|pending_review');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `commercial_score` SET TAGS ('dbx_business_glossary_term' = 'Commercial Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `commercial_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Location');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `is_awarded` SET TAGS ('dbx_business_glossary_term' = 'Awarded Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `is_awarded` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `is_on_time_submission` SET TAGS ('dbx_business_glossary_term' = 'On-Time Submission Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `is_on_time_submission` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Bid Line Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `line_number` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Bid Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `price_unit` SET TAGS ('dbx_business_glossary_term' = 'Price Unit');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `quoted_unit_price` SET TAGS ('dbx_business_glossary_term' = 'Quoted Unit Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `quoted_unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `rank` SET TAGS ('dbx_business_glossary_term' = 'Bid Rank');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `rank` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'REACH Compliance Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Bid Rejection Reason');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_value_regex' = 'price_not_competitive|technical_non_compliance|capacity_insufficient|lead_time_unacceptable|financial_risk|qualification_failure|late_submission|incomplete_bid|other');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'RoHS Compliance Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `sourcing_event_number` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Bid Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|shortlisted|awarded|rejected|withdrawn|disqualified');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Bid Submission Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `technical_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Technical Compliance Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `technical_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|conditionally_compliant|pending_review');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `technical_score` SET TAGS ('dbx_business_glossary_term' = 'Technical Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `technical_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `total_bid_value` SET TAGS ('dbx_business_glossary_term' = 'Total Bid Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `total_bid_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `total_score` SET TAGS ('dbx_business_glossary_term' = 'Total Bid Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `total_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Bid Validity End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Bid Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `procurement_po_line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Line Item ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `incoterm_id` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `inventory_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `procurement_material_info_record_id` SET TAGS ('dbx_business_glossary_term' = 'Material Info Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `procurement_purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `procurement_spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `procurement_supply_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `spare_part_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_business_glossary_term' = 'Account Assignment Category');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_value_regex' = 'cost_center|wbs_element|asset|order|project|sales_order|unknown');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `customs_tariff_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Tariff Number (HS Code)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `customs_tariff_number` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `deletion_indicator` SET TAGS ('dbx_business_glossary_term' = 'Deletion Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `deletion_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `final_delivery_indicator` SET TAGS ('dbx_business_glossary_term' = 'Final Delivery Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `final_delivery_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `goods_receipt_indicator` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt (GR) Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `goods_receipt_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `goods_receipt_quantity` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt (GR) Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `goods_receipt_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `goods_receipt_status` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt (GR) Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `goods_receipt_status` SET TAGS ('dbx_value_regex' = 'not_started|partial|complete|over_delivered');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `info_record_number` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Info Record Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `info_record_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `invoice_status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `invoice_status` SET TAGS ('dbx_value_regex' = 'not_invoiced|partially_invoiced|fully_invoiced|blocked');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `invoice_verification_indicator` SET TAGS ('dbx_business_glossary_term' = 'Invoice Verification Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `invoice_verification_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `invoiced_quantity` SET TAGS ('dbx_business_glossary_term' = 'Invoiced Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `invoiced_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `item_category` SET TAGS ('dbx_business_glossary_term' = 'PO Line Item Category');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `item_category` SET TAGS ('dbx_value_regex' = 'standard|consignment|subcontracting|stock_transfer|service|third_party|blanket');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Line Item Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `line_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `material_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,9}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `net_order_value` SET TAGS ('dbx_business_glossary_term' = 'Net Order Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `net_order_value` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `net_order_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `net_price` SET TAGS ('dbx_business_glossary_term' = 'Net Unit Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `net_price` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `net_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `ordered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Ordered Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `ordered_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `outline_agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Outline Agreement Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `outline_agreement_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `overdelivery_tolerance_pct` SET TAGS ('dbx_business_glossary_term' = 'Over-Delivery Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `overdelivery_tolerance_pct` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `po_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `po_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `price_unit` SET TAGS ('dbx_business_glossary_term' = 'Price Unit Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `price_unit` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `requisition_line_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition (PR) Line Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `requisition_line_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `requisition_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition (PR) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `requisition_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `scheduled_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `scheduled_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `short_text` SET TAGS ('dbx_business_glossary_term' = 'PO Line Item Short Text');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'PO Line Item Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|partially_delivered|fully_delivered|invoiced|closed|blocked|cancelled');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `storage_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `tax_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `underdelivery_tolerance_pct` SET TAGS ('dbx_business_glossary_term' = 'Under-Delivery Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `underdelivery_tolerance_pct` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ALTER COLUMN `wbs_element` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-.]{1,24}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `procurement_purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `budget_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `maintenance_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Requestor Employee ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Source Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_business_glossary_term' = 'Account Assignment Category');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_value_regex' = 'cost_center|project|sales_order|asset|network|unknown');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|escalated|withdrawn');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `converted_to_po_flag` SET TAGS ('dbx_business_glossary_term' = 'Converted to Purchase Order (PO) Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `converted_to_po_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `estimated_value` SET TAGS ('dbx_business_glossary_term' = 'Estimated Requisition Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `estimated_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `fixed_source_indicator` SET TAGS ('dbx_business_glossary_term' = 'Fixed Source Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `fixed_source_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `gl_account` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `item_category` SET TAGS ('dbx_business_glossary_term' = 'Item Category');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `item_category` SET TAGS ('dbx_value_regex' = 'standard|consignment|subcontracting|stock_transfer|service|limit');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Requisition Line Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `line_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `mrp_controller` SET TAGS ('dbx_business_glossary_term' = 'MRP (Material Requirements Planning) Controller');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `po_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'external|internal|subcontracting|consignment');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `purchasing_org` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `release_date` SET TAGS ('dbx_business_glossary_term' = 'Requisition Release Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `release_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `release_strategy_code` SET TAGS ('dbx_business_glossary_term' = 'Release Strategy Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `requested_quantity` SET TAGS ('dbx_business_glossary_term' = 'Requested Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `requestor_name` SET TAGS ('dbx_business_glossary_term' = 'Requestor Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `requestor_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `required_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Required Delivery Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `required_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `requisition_date` SET TAGS ('dbx_business_glossary_term' = 'Requisition Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `requisition_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `requisition_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `requisition_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `requisition_type` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `requisition_type` SET TAGS ('dbx_value_regex' = 'standard|subcontracting|consignment|stock_transfer|service|blanket|mro|capital');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `short_text` SET TAGS ('dbx_business_glossary_term' = 'Requisition Short Text');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `source_of_demand` SET TAGS ('dbx_business_glossary_term' = 'Source of Demand');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `source_of_demand` SET TAGS ('dbx_value_regex' = 'mrp|mrp_ii|manual|maintenance|project|sales_order|kanban|forecast');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|in_review|approved|rejected|partially_ordered|fully_ordered|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|LB|M|M2|M3|L|PC|SET|HR|DAY|BOX|PAL|ROL|TON');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `valuation_price` SET TAGS ('dbx_business_glossary_term' = 'Valuation Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `valuation_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_inbound_delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Received By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Document Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `customs_declaration_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `delivery_note_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Note Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Document Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `document_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `gr_ir_clearing_status` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt / Invoice Receipt (GR/IR) Clearing Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `gr_ir_clearing_status` SET TAGS ('dbx_value_regex' = 'open|partially_cleared|fully_cleared');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `grn_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Note (GRN) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `grn_number` SET TAGS ('dbx_value_regex' = '^GRN-[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `inbound_delivery_number` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `inspection_lot_number` SET TAGS ('dbx_business_glossary_term' = 'Quality Management (QM) Inspection Lot Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `is_return_delivery` SET TAGS ('dbx_business_glossary_term' = 'Return Delivery Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `is_return_delivery` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `is_reversal` SET TAGS ('dbx_business_glossary_term' = 'GRN Reversal Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `is_reversal` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `material_document_number` SET TAGS ('dbx_business_glossary_term' = 'Material Document Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `material_document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `material_document_year` SET TAGS ('dbx_business_glossary_term' = 'Material Document Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `material_document_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `movement_type` SET TAGS ('dbx_business_glossary_term' = 'SAP Movement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `movement_type` SET TAGS ('dbx_value_regex' = '101|103|105|122|161|501|502');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `on_time_delivery_flag` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `on_time_delivery_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Receiving Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Posting Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization (Purchasing Org) Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `quality_inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Required Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `quality_inspection_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `quality_inspection_status` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `quality_inspection_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|in_progress|accepted|rejected|conditionally_accepted');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `reversed_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reversed Material Document Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `scheduled_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `scheduled_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|INFOR_WMS|MANUAL');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'posted|reversed|blocked|in_quality_inspection|completed');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `supplier_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Vendor Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `three_way_match_status` SET TAGS ('dbx_business_glossary_term' = 'Three-Way Match Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `three_way_match_status` SET TAGS ('dbx_value_regex' = 'pending|matched|partially_matched|exception|cleared');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `timestamp` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `total_gr_value` SET TAGS ('dbx_business_glossary_term' = 'Total Goods Receipt Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `total_gr_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `total_item_count` SET TAGS ('dbx_business_glossary_term' = 'Total GRN Line Item Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ALTER COLUMN `total_item_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `goods_receipt_line_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt (GR) Line ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `inventory_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `logistics_inbound_delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `procurement_goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `procurement_po_line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Po Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `delivery_note_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Note Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `delivery_variance_percent` SET TAGS ('dbx_business_glossary_term' = 'Delivery Variance Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `delivery_variance_percent` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `delivery_variance_quantity` SET TAGS ('dbx_business_glossary_term' = 'Delivery Variance Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `delivery_variance_quantity` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Material Document Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `document_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `excise_duty_indicator` SET TAGS ('dbx_business_glossary_term' = 'Excise Duty Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `excise_duty_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `goods_receipt_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `goods_receipt_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}[+-][0-9]{2}:[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `gr_ir_account_code` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt / Invoice Receipt (GR/IR) Account Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `hazardous_material_indicator` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `hazardous_material_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `inspection_lot_number` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Lot Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `is_final_delivery` SET TAGS ('dbx_business_glossary_term' = 'Final Delivery Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `is_final_delivery` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `is_partial_delivery` SET TAGS ('dbx_business_glossary_term' = 'Partial Delivery Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `is_partial_delivery` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `line_item_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt (GR) Line Item Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `line_item_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `material_document_number` SET TAGS ('dbx_business_glossary_term' = 'Material Document Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `material_document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `material_document_year` SET TAGS ('dbx_business_glossary_term' = 'Material Document Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `material_document_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `material_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,9}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `movement_type` SET TAGS ('dbx_business_glossary_term' = 'Movement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `movement_type` SET TAGS ('dbx_value_regex' = '^[0-9]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `over_delivery_tolerance_percent` SET TAGS ('dbx_business_glossary_term' = 'Over-Delivery Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `over_delivery_tolerance_percent` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `po_ordered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Ordered Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `po_ordered_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Posting Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `purchase_order_line_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Line Item Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `purchase_order_line_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `purchasing_organization` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `purchasing_organization` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `quality_inspection_status` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `quality_inspection_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|in_inspection|accepted|rejected|conditionally_accepted|blocked');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `received_quantity` SET TAGS ('dbx_business_glossary_term' = 'Received Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `received_quantity` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `reversal_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reversal Material Document Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `reversal_document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `scheduled_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `scheduled_delivery_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|LEGACY_ERP|MANUAL');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `stock_type` SET TAGS ('dbx_business_glossary_term' = 'Stock Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `stock_type` SET TAGS ('dbx_value_regex' = 'unrestricted|quality_inspection|blocked|restricted|returns');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `storage_bin` SET TAGS ('dbx_business_glossary_term' = 'Storage Bin');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `supplier_batch_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Batch Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `under_delivery_tolerance_percent` SET TAGS ('dbx_business_glossary_term' = 'Under-Delivery Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `under_delivery_tolerance_percent` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `valuation_amount` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Valuation Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `valuation_amount` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `valuation_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `valuation_price` SET TAGS ('dbx_business_glossary_term' = 'Valuation Price per Unit');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `valuation_price` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `valuation_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `vendor_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ALTER COLUMN `vendor_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `procurement_supplier_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Invoice ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `ap_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ap Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `procurement_goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `procurement_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `tax_code_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `baseline_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Baseline Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `baseline_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Invoice Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `early_payment_discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Early Payment Discount Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `early_payment_discount_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `early_payment_discount_date` SET TAGS ('dbx_business_glossary_term' = 'Early Payment Discount Deadline Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `early_payment_discount_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `entry_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Entry Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `entry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-6])$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `grn_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Note (GRN) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Invoice Gross Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `invoice_type` SET TAGS ('dbx_business_glossary_term' = 'Invoice Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `invoice_type` SET TAGS ('dbx_value_regex' = 'standard|credit_memo|debit_memo|subsequent_debit|subsequent_credit|evaluated_receipt_settlement');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `is_duplicate` SET TAGS ('dbx_business_glossary_term' = 'Duplicate Invoice Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `is_duplicate` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `is_payment_blocked` SET TAGS ('dbx_business_glossary_term' = 'Payment Block Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `is_payment_blocked` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Invoice Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Invoice Net Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `payment_block_reason` SET TAGS ('dbx_business_glossary_term' = 'Payment Block Reason');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `payment_block_reason` SET TAGS ('dbx_value_regex' = 'price_variance|quantity_variance|quality_hold|missing_grn|duplicate_invoice|manual_block|tolerance_exceeded|pending_approval|disputed');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'bank_transfer|check|ach|wire|virtual_card|dynamic_discounting|supply_chain_finance');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `po_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `price_variance_amount` SET TAGS ('dbx_business_glossary_term' = 'Invoice Price Variance Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `price_variance_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `quantity_variance_amount` SET TAGS ('dbx_business_glossary_term' = 'Invoice Quantity Variance');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `sap_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Accounting Document Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'received|under_review|matched|approved|payment_blocked|posted|scheduled_for_payment|paid|cancelled|disputed|parked');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Invoice Tax Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `three_way_match_status` SET TAGS ('dbx_business_glossary_term' = 'Three-Way Match Status (PO-GRN-Invoice)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `three_way_match_status` SET TAGS ('dbx_value_regex' = 'matched|price_variance|quantity_variance|grn_missing|po_missing|tolerance_exceeded|pending');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` SET TAGS ('dbx_subdomain' = 'demand_planning');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `mrp_run_id` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Run ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `supply_network_node_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Network Node Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `bom_explosion_level` SET TAGS ('dbx_business_glossary_term' = 'Bill of Materials (BOM) Explosion Level');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `bom_explosion_level` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `capacity_check_performed` SET TAGS ('dbx_business_glossary_term' = 'Capacity Check Performed');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `capacity_check_performed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `capacity_overload_count` SET TAGS ('dbx_business_glossary_term' = 'Capacity Overload Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `capacity_overload_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `coverage_shortfall_count` SET TAGS ('dbx_business_glossary_term' = 'Coverage Shortfall Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `coverage_shortfall_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_cancel_count` SET TAGS ('dbx_business_glossary_term' = 'Exception: Cancel Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_cancel_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_messages_total` SET TAGS ('dbx_business_glossary_term' = 'Total Exception Messages');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_messages_total` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_new_requirement_count` SET TAGS ('dbx_business_glossary_term' = 'Exception: New Requirement Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_new_requirement_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_reschedule_in_count` SET TAGS ('dbx_business_glossary_term' = 'Exception: Reschedule In Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_reschedule_in_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_reschedule_out_count` SET TAGS ('dbx_business_glossary_term' = 'Exception: Reschedule Out Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_reschedule_out_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-2])$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `horizon_end_date` SET TAGS ('dbx_business_glossary_term' = 'Planning Horizon End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `horizon_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `horizon_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planning Horizon Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `horizon_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `initiated_by` SET TAGS ('dbx_business_glossary_term' = 'MRP Run Initiated By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `material_range_from` SET TAGS ('dbx_business_glossary_term' = 'Material Range From');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `material_range_to` SET TAGS ('dbx_business_glossary_term' = 'Material Range To');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `mrp_area` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Area');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `mrp_controller_group` SET TAGS ('dbx_business_glossary_term' = 'MRP Controller Group');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `planned_orders_created` SET TAGS ('dbx_business_glossary_term' = 'Planned Orders Created');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `planned_orders_created` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `planning_date` SET TAGS ('dbx_business_glossary_term' = 'MRP Planning Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `planning_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `planning_horizon_days` SET TAGS ('dbx_business_glossary_term' = 'Planning Horizon (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `planning_horizon_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `planning_mode` SET TAGS ('dbx_business_glossary_term' = 'Planning Mode');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `planning_mode` SET TAGS ('dbx_value_regex' = 'mrp|mrp_ii|consumption_based|reorder_point|forecast_based');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `purchase_requisitions_created` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisitions (PR) Created');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `purchase_requisitions_created` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_duration_seconds` SET TAGS ('dbx_business_glossary_term' = 'MRP Run Duration (Seconds)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_duration_seconds` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'MRP Run End Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_end_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_number` SET TAGS ('dbx_business_glossary_term' = 'MRP Run Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_number` SET TAGS ('dbx_value_regex' = '^MRP-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_scope` SET TAGS ('dbx_business_glossary_term' = 'MRP Run Scope');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_scope` SET TAGS ('dbx_value_regex' = 'single_material|material_range|all_materials|mrp_area|plant_wide');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'MRP Run Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_trigger_type` SET TAGS ('dbx_business_glossary_term' = 'MRP Run Trigger Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_trigger_type` SET TAGS ('dbx_value_regex' = 'manual|scheduled_batch|event_driven|api_triggered');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_type` SET TAGS ('dbx_business_glossary_term' = 'MRP Run Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_type` SET TAGS ('dbx_value_regex' = 'regenerative|net_change|net_change_planning_horizon');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `schedule_lines_created` SET TAGS ('dbx_business_glossary_term' = 'Schedule Lines Created');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `schedule_lines_created` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `scheduling_type` SET TAGS ('dbx_business_glossary_term' = 'Scheduling Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `scheduling_type` SET TAGS ('dbx_value_regex' = 'basic_dates|lead_time_scheduling|capacity_planning');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ECC|OPCENTER|OTHER');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `source_system_run_reference` SET TAGS ('dbx_business_glossary_term' = 'Source System MRP Run ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'MRP Run Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'initiated|in_progress|completed|completed_with_exceptions|failed|cancelled');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `total_materials_planned` SET TAGS ('dbx_business_glossary_term' = 'Total Materials Planned');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `total_materials_planned` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` SET TAGS ('dbx_subdomain' = 'demand_planning');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_planned_order_id` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Planned Order ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Forecast Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `inventory_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_run_id` SET TAGS ('dbx_business_glossary_term' = 'Mrp Run Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `procurement_purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `production_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Source Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `bom_explosion_indicator` SET TAGS ('dbx_business_glossary_term' = 'Bill of Materials (BOM) Explosion Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `bom_explosion_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `conversion_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Conversion Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `conversion_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `converted_document_number` SET TAGS ('dbx_business_glossary_term' = 'Converted Document Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `converted_document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `demand_source_type` SET TAGS ('dbx_business_glossary_term' = 'Demand Source Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `demand_source_type` SET TAGS ('dbx_value_regex' = 'sales_order|forecast|safety_stock|dependent_demand|manual_reservation|project|service_order');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `exception_message_code` SET TAGS ('dbx_business_glossary_term' = 'MRP Exception Message Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `exception_message_code` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `exception_message_text` SET TAGS ('dbx_business_glossary_term' = 'MRP Exception Message Text');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `goods_receipt_processing_days` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt (GR) Processing Days');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `goods_receipt_processing_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `is_firmed` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Firmed Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `is_firmed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `lot_size_key` SET TAGS ('dbx_business_glossary_term' = 'Lot Size Key');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `lot_size_key` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_area` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Area');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_controller_code` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Controller Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_controller_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_run_date` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Run Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_run_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_type` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_type` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `opening_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Opening Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `opening_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `order_type` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `order_type` SET TAGS ('dbx_value_regex' = 'purchase_requisition|production_order|transfer_order|subcontracting|consignment');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_delivery_days` SET TAGS ('dbx_business_glossary_term' = 'Planned Delivery Days');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_delivery_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_finish_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Finish Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_finish_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_order_number` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_order_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_order_value` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_order_value` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_order_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_quantity` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'external|in_house|both|subcontracting');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `requirements_date` SET TAGS ('dbx_business_glossary_term' = 'Requirements Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `requirements_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `safety_stock_quantity` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `safety_stock_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `source_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Source Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `source_plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `special_procurement_key` SET TAGS ('dbx_business_glossary_term' = 'Special Procurement Key');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `special_procurement_key` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'created|firmed|converted|cancelled|exception');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` SET TAGS ('dbx_subdomain' = 'demand_planning');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `demand_forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Demand Forecast ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `blanket_order_id` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Forecast Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `inventory_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `production_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `supply_network_node_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Network Node Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `abc_classification` SET TAGS ('dbx_business_glossary_term' = 'ABC Classification');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `abc_classification` SET TAGS ('dbx_value_regex' = 'A|B|C');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Forecast Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Forecast Approval Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `consensus_adjustment_quantity` SET TAGS ('dbx_business_glossary_term' = 'Consensus Forecast Adjustment Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `consensus_adjustment_quantity` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `demand_category` SET TAGS ('dbx_business_glossary_term' = 'Demand Category');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `demand_category` SET TAGS ('dbx_value_regex' = 'independent|dependent|spare_parts|service|promotional|new_product|phase_out');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_algorithm` SET TAGS ('dbx_business_glossary_term' = 'Forecast Algorithm');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_algorithm` SET TAGS ('dbx_value_regex' = 'exponential_smoothing|moving_average|holt_winters|arima|causal|machine_learning|manual');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_bias` SET TAGS ('dbx_business_glossary_term' = 'Forecast Bias');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_bias` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_end_date` SET TAGS ('dbx_business_glossary_term' = 'Forecast Period End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_number` SET TAGS ('dbx_business_glossary_term' = 'Forecast Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_number` SET TAGS ('dbx_value_regex' = '^FC-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_period_type` SET TAGS ('dbx_business_glossary_term' = 'Forecast Period Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_period_type` SET TAGS ('dbx_value_regex' = 'weekly|monthly|quarterly');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_start_date` SET TAGS ('dbx_business_glossary_term' = 'Forecast Period Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecasted_quantity` SET TAGS ('dbx_business_glossary_term' = 'Forecasted Demand Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecasted_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecasted_spend_amount` SET TAGS ('dbx_business_glossary_term' = 'Forecasted Procurement Spend Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecasted_spend_amount` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecasted_spend_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `is_mrp_relevant` SET TAGS ('dbx_business_glossary_term' = 'MRP Relevance Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `is_mrp_relevant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `is_supplier_shared` SET TAGS ('dbx_business_glossary_term' = 'Supplier Shared Forecast Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `is_supplier_shared` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `lot_size_procedure` SET TAGS ('dbx_business_glossary_term' = 'Lot Size Procedure');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `lot_size_procedure` SET TAGS ('dbx_value_regex' = 'exact|fixed|economic_order_quantity|period|minimum_maximum');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `mape` SET TAGS ('dbx_business_glossary_term' = 'Mean Absolute Percentage Error (MAPE)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `mape` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `mrp_area` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Area');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `mrp_type` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `mrp_type` SET TAGS ('dbx_value_regex' = 'MRP|consumption_based|reorder_point|forecast_based|manual');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `planning_horizon_months` SET TAGS ('dbx_business_glossary_term' = 'Planning Horizon (Months)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `planning_horizon_months` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'external|in_house|subcontracting|consignment|stock_transfer');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `product_category_code` SET TAGS ('dbx_business_glossary_term' = 'Product Category Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `reorder_point` SET TAGS ('dbx_business_glossary_term' = 'Reorder Point');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `reorder_point` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `safety_stock_quantity` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `safety_stock_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `sop_cycle` SET TAGS ('dbx_business_glossary_term' = 'Sales and Operations Planning (S&OP) Cycle');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `sop_cycle` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-(0[1-9]|1[0-2])$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_APO|EXCEL|MANUAL|EXTERNAL');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `statistical_forecast_quantity` SET TAGS ('dbx_business_glossary_term' = 'Statistical Forecast Baseline Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `statistical_forecast_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Forecast Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|in_review|approved|locked|superseded|cancelled');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `supplier_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Supplier Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `supplier_lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|LB|M|M2|M3|L|PC|SET|BOX|PAL');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Forecast Version Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `version_type` SET TAGS ('dbx_business_glossary_term' = 'Forecast Version Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `version_type` SET TAGS ('dbx_value_regex' = 'baseline|statistical|consensus|final|adjusted|simulation');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `xyz_classification` SET TAGS ('dbx_business_glossary_term' = 'XYZ Classification');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `xyz_classification` SET TAGS ('dbx_value_regex' = 'X|Y|Z');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` SET TAGS ('dbx_subdomain' = 'strategic_sourcing');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `procurement_supply_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `incoterm_id` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `procurement_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `procurement_sourcing_event_id` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `procurement_spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'scheduling_agreement|blanket_order|framework_contract|master_supply_agreement|call_off_contract');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Agreement Approval Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'not_submitted|pending|approved|rejected|revision_required');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Approval Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `ariba_contract_reference` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Contract ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `ariba_contract_reference` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,50}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto-Renewal Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `category_code` SET TAGS ('dbx_business_glossary_term' = 'Commodity Category Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `category_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-.]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `country_of_supply` SET TAGS ('dbx_business_glossary_term' = 'Country of Supply');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `country_of_supply` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Agreement Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Effective End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = '^(EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Location');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `minimum_call_off_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Call-Off Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `minimum_call_off_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `penalty_clause_description` SET TAGS ('dbx_business_glossary_term' = 'Penalty Clause Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `penalty_clause_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `penalty_clause_flag` SET TAGS ('dbx_business_glossary_term' = 'Penalty Clause Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `penalty_clause_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `pricing_condition_type` SET TAGS ('dbx_business_glossary_term' = 'Pricing Condition Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `pricing_condition_type` SET TAGS ('dbx_value_regex' = 'fixed_price|tiered_volume|index_linked|cost_plus|time_and_material|frame_rate');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `pricing_condition_type` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'direct|indirect|mro|services|capital');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization (PO) Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `released_quantity` SET TAGS ('dbx_business_glossary_term' = 'Released Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `released_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `released_value` SET TAGS ('dbx_business_glossary_term' = 'Released Agreement Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `released_value` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `released_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `renewal_notice_days` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notice Period (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `renewal_notice_days` SET TAGS ('dbx_value_regex' = '^d{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `sap_outline_agreement_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Outline Agreement Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `sap_outline_agreement_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `sourcing_event_reference` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Reference Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `sourcing_event_reference` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|active|suspended|expired|terminated|closed');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `supplier_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Termination Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `termination_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Agreement Termination Reason');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `termination_reason` SET TAGS ('dbx_value_regex' = 'supplier_default|mutual_agreement|strategic_sourcing_change|regulatory_non_compliance|financial_insolvency|force_majeure|other');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Title');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `title` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `total_committed_quantity` SET TAGS ('dbx_business_glossary_term' = 'Total Committed Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `total_committed_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `total_committed_value` SET TAGS ('dbx_business_glossary_term' = 'Total Committed Agreement Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `total_committed_value` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `total_committed_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Agreed Unit Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `unit_price` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ALTER COLUMN `unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivery_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Schedule ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `incoterm_id` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `procurement_goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `procurement_po_line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Po Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `procurement_supply_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement / Blanket Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `agreement_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_business_glossary_term' = 'Supplier Confirmed Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `cumulative_delivered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Cumulative Delivered Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `cumulative_delivered_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `cumulative_scheduled_quantity` SET TAGS ('dbx_business_glossary_term' = 'Cumulative Scheduled Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `cumulative_scheduled_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `days_early_late` SET TAGS ('dbx_business_glossary_term' = 'Days Early or Late');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `days_early_late` SET TAGS ('dbx_value_regex' = '^-?[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivered Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivered_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivery_address_line1` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address Line 1');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivery_address_line1` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivery_address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivery_city` SET TAGS ('dbx_business_glossary_term' = 'Delivery City');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivery_country_code` SET TAGS ('dbx_business_glossary_term' = 'Delivery Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivery_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivery_note_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Delivery Note Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivery_note_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,35}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `grn_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Note (GRN) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `grn_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `is_on_time` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `is_on_time` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `jit_delivery_window_end` SET TAGS ('dbx_business_glossary_term' = 'Just-In-Time (JIT) Delivery Window End');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `jit_delivery_window_end` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `jit_delivery_window_start` SET TAGS ('dbx_business_glossary_term' = 'Just-In-Time (JIT) Delivery Window Start');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `jit_delivery_window_start` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `kanban_signal_number` SET TAGS ('dbx_business_glossary_term' = 'Kanban Signal Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `kanban_signal_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,30}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Schedule Line Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `line_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-.]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `mrp_element_type` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Element Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `mrp_element_type` SET TAGS ('dbx_value_regex' = 'planned_order|purchase_requisition|scheduling_agreement|purchase_order|stock_transfer');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `release_type` SET TAGS ('dbx_business_glossary_term' = 'Schedule Release Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `release_type` SET TAGS ('dbx_value_regex' = 'forecast|jit|immediate|manual');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `sap_scheduling_agreement_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Scheduling Agreement Document ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `sap_scheduling_agreement_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `schedule_adherence_status` SET TAGS ('dbx_business_glossary_term' = 'Schedule Adherence Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `schedule_adherence_status` SET TAGS ('dbx_value_regex' = 'on_time|early|late|partial|missed|pending');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `schedule_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Schedule Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `schedule_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `schedule_type` SET TAGS ('dbx_business_glossary_term' = 'Delivery Schedule Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `schedule_type` SET TAGS ('dbx_value_regex' = 'jit|forecast|firm|kanban|blanket_release|spot');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `scheduled_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `scheduled_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `scheduled_delivery_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Time (HH:MM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `scheduled_delivery_time` SET TAGS ('dbx_value_regex' = '^([01]d|2[0-3]):[0-5]d$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `scheduled_quantity` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `scheduled_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `sku_code` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `sku_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-.]{1,50}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Delivery Schedule Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|released|confirmed|in_transit|partially_delivered|delivered|cancelled|overdue|closed');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `supplier_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `tolerance_over_percent` SET TAGS ('dbx_business_glossary_term' = 'Over-Delivery Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `tolerance_over_percent` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `tolerance_under_percent` SET TAGS ('dbx_business_glossary_term' = 'Under-Delivery Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `tolerance_under_percent` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Unit Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `unit_price` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` SET TAGS ('dbx_subdomain' = 'performance_analytics');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `procurement_supplier_performance_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Performance ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Evaluated By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `procurement_spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `procurement_supplier_qualification_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Qualification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `acknowledgment_date` SET TAGS ('dbx_business_glossary_term' = 'Supplier Acknowledgment Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `acknowledgment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `ariba_scorecard_reference` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Scorecard ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `capa_open_count` SET TAGS ('dbx_business_glossary_term' = 'Open Corrective and Preventive Action (CAPA) Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `category_name` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `evaluation_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Period End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `evaluation_period_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `evaluation_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Period Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `evaluation_period_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `evaluation_period_type` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Period Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `evaluation_period_type` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annual|annual');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `fill_rate` SET TAGS ('dbx_business_glossary_term' = 'Fill Rate');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `fill_rate` SET TAGS ('dbx_value_regex' = '^(100(.00)?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `fill_rate_target` SET TAGS ('dbx_business_glossary_term' = 'Fill Rate Target');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `fill_rate_target` SET TAGS ('dbx_value_regex' = '^(100(.00)?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `improvement_plan_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Supplier Improvement Plan Required Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `improvement_plan_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `invoice_accuracy_rate` SET TAGS ('dbx_business_glossary_term' = 'Invoice Accuracy Rate');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `invoice_accuracy_rate` SET TAGS ('dbx_value_regex' = '^(100(.00)?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `late_delivery_count` SET TAGS ('dbx_business_glossary_term' = 'Late Delivery Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `ncr_count` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Report (NCR) Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `on_time_delivery_rate` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery (OTD) Rate');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `on_time_delivery_rate` SET TAGS ('dbx_value_regex' = '^(100(.00)?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `on_time_delivery_target` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery (OTD) Target Rate');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `on_time_delivery_target` SET TAGS ('dbx_value_regex' = '^(100(.00)?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `overall_rating` SET TAGS ('dbx_business_glossary_term' = 'Overall Supplier Rating');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `overall_rating` SET TAGS ('dbx_value_regex' = '^(100(.00)?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `performance_tier` SET TAGS ('dbx_business_glossary_term' = 'Supplier Performance Tier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `performance_tier` SET TAGS ('dbx_value_regex' = 'preferred|approved|conditional|probation|disqualified');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `preferred_supplier_flag` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `preferred_supplier_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization (PO) Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `quality_ppm` SET TAGS ('dbx_business_glossary_term' = 'Quality Parts Per Million (PPM) Defect Rate');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `quality_ppm_target` SET TAGS ('dbx_business_glossary_term' = 'Quality Parts Per Million (PPM) Target');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `rejected_quantity` SET TAGS ('dbx_business_glossary_term' = 'Rejected Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `requalification_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Re-Qualification Required Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `requalification_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `responsiveness_score` SET TAGS ('dbx_business_glossary_term' = 'Supplier Responsiveness Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `responsiveness_score` SET TAGS ('dbx_value_regex' = '^(10(.00)?|[0-9](.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `scorecard_date` SET TAGS ('dbx_business_glossary_term' = 'Scorecard Issue Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `scorecard_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `scorecard_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Performance Scorecard Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `scorecard_number` SET TAGS ('dbx_value_regex' = '^SP-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `scorecard_type` SET TAGS ('dbx_business_glossary_term' = 'Scorecard Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `scorecard_type` SET TAGS ('dbx_value_regex' = 'standard|strategic|corrective_action|re_qualification|ad_hoc');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `spend_amount` SET TAGS ('dbx_business_glossary_term' = 'Supplier Spend Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `spend_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Scorecard Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_review|published|acknowledged|disputed|closed');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `supplier_acknowledged_flag` SET TAGS ('dbx_business_glossary_term' = 'Supplier Acknowledged Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `supplier_acknowledged_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `total_delivery_count` SET TAGS ('dbx_business_glossary_term' = 'Total Delivery Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `total_po_count` SET TAGS ('dbx_business_glossary_term' = 'Total Purchase Order (PO) Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ALTER COLUMN `total_received_quantity` SET TAGS ('dbx_business_glossary_term' = 'Total Received Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` SET TAGS ('dbx_subdomain' = 'performance_analytics');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `supply_risk_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Risk ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `procurement_material_info_record_id` SET TAGS ('dbx_business_glossary_term' = 'Material Info Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `procurement_spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `actual_resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Resolution Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `actual_resolution_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `affected_material_group` SET TAGS ('dbx_business_glossary_term' = 'Affected Material Group');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `affected_supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Affected Supplier Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `ariba_risk_reference` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Risk ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Risk Assessment Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `assessment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `business_impact_description` SET TAGS ('dbx_business_glossary_term' = 'Business Impact Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `contingency_plan` SET TAGS ('dbx_business_glossary_term' = 'Contingency Plan');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Risk Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `escalation_date` SET TAGS ('dbx_business_glossary_term' = 'Escalation Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `escalation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `estimated_financial_impact` SET TAGS ('dbx_business_glossary_term' = 'Estimated Financial Impact');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `estimated_financial_impact` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `identification_date` SET TAGS ('dbx_business_glossary_term' = 'Risk Identification Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `identification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `impact_score` SET TAGS ('dbx_business_glossary_term' = 'Risk Impact Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `impact_score` SET TAGS ('dbx_value_regex' = '^([1-9]|10)(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `is_escalated` SET TAGS ('dbx_business_glossary_term' = 'Escalation Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `is_escalated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `is_single_source` SET TAGS ('dbx_business_glossary_term' = 'Single Source Dependency Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `is_single_source` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `mitigation_actions` SET TAGS ('dbx_business_glossary_term' = 'Mitigation Actions');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `mitigation_strategy` SET TAGS ('dbx_business_glossary_term' = 'Mitigation Strategy');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `mitigation_strategy` SET TAGS ('dbx_value_regex' = 'avoid|transfer|reduce|accept|contingency');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `probability` SET TAGS ('dbx_business_glossary_term' = 'Risk Probability');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `probability` SET TAGS ('dbx_value_regex' = 'very_high|high|medium|low|very_low');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `probability_score` SET TAGS ('dbx_business_glossary_term' = 'Risk Probability Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `probability_score` SET TAGS ('dbx_value_regex' = '^(0(.d{1,2})?|1(.0{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Risk Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `risk_category` SET TAGS ('dbx_business_glossary_term' = 'Risk Category');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `risk_category` SET TAGS ('dbx_value_regex' = 'single_source_dependency|geopolitical|financial_distress|capacity_constraint|regulatory_non_compliance|natural_disaster|logistics_disruption|quality_failure|cybersecurity|raw_material_shortage|currency_volatility|labor_dispute|intellectual_propert...');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `risk_number` SET TAGS ('dbx_business_glossary_term' = 'Supply Risk Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `risk_number` SET TAGS ('dbx_value_regex' = '^SR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `risk_owner` SET TAGS ('dbx_business_glossary_term' = 'Risk Owner');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `risk_owner_department` SET TAGS ('dbx_business_glossary_term' = 'Risk Owner Department');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `risk_score` SET TAGS ('dbx_business_glossary_term' = 'Risk Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `risk_subcategory` SET TAGS ('dbx_business_glossary_term' = 'Risk Sub-Category');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `severity` SET TAGS ('dbx_business_glossary_term' = 'Risk Severity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `severity` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Risk Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'identified|under_assessment|active|mitigating|escalated|resolved|closed|accepted');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `supply_lane` SET TAGS ('dbx_business_glossary_term' = 'Supply Lane');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `target_resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Target Resolution Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `target_resolution_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Risk Title');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` SET TAGS ('dbx_subdomain' = 'strategic_sourcing');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `procurement_material_info_record_id` SET TAGS ('dbx_business_glossary_term' = 'Material Info Record ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `compliance_reach_substance_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Reach Substance Declaration Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `incoterm_id` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `inventory_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `procurement_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `rohs_compliance_record_id` SET TAGS ('dbx_business_glossary_term' = 'Rohs Compliance Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `customs_tariff_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Tariff Number (HS Code)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `goods_receipt_required` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt (GR) Required Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `goods_receipt_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `info_record_category` SET TAGS ('dbx_business_glossary_term' = 'Info Record Procurement Category');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `info_record_category` SET TAGS ('dbx_value_regex' = 'direct_material|indirect_material|mro|services|capital');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `info_record_number` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Info Record Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `info_record_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `info_record_type` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Info Record Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `info_record_type` SET TAGS ('dbx_value_regex' = 'standard|subcontracting|pipeline|consignment');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `invoice_verification_required` SET TAGS ('dbx_business_glossary_term' = 'Invoice Verification (IV) Required Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `invoice_verification_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `last_po_date` SET TAGS ('dbx_business_glossary_term' = 'Last Purchase Order (PO) Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `last_po_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `last_po_number` SET TAGS ('dbx_business_glossary_term' = 'Last Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `net_price_confirmed_date` SET TAGS ('dbx_business_glossary_term' = 'Net Price Confirmed Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `net_price_confirmed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `order_unit` SET TAGS ('dbx_business_glossary_term' = 'Order Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `overdelivery_tolerance_pct` SET TAGS ('dbx_business_glossary_term' = 'Overdelivery Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `planned_delivery_days` SET TAGS ('dbx_business_glossary_term' = 'Planned Delivery Time (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `price_unit` SET TAGS ('dbx_business_glossary_term' = 'Price Unit Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `price_valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Price Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `price_valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `price_valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Price Validity End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `price_valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `regular_vendor_flag` SET TAGS ('dbx_business_glossary_term' = 'Regular Vendor Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `regular_vendor_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `rounding_profile` SET TAGS ('dbx_business_glossary_term' = 'Rounding Profile');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `standard_delivery_days` SET TAGS ('dbx_business_glossary_term' = 'Standard Delivery Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Info Record Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|blocked|flagged_for_deletion');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `underdelivery_tolerance_pct` SET TAGS ('dbx_business_glossary_term' = 'Underdelivery Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Agreed Unit Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `unlimited_overdelivery_allowed` SET TAGS ('dbx_business_glossary_term' = 'Unlimited Overdelivery Allowed Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `unlimited_overdelivery_allowed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `vendor_material_description` SET TAGS ('dbx_business_glossary_term' = 'Vendor Material Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ALTER COLUMN `vendor_material_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Material Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` SET TAGS ('dbx_subdomain' = 'strategic_sourcing');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `source_list_id` SET TAGS ('dbx_business_glossary_term' = 'Source List ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `incoterm_id` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `inventory_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `procurement_material_info_record_id` SET TAGS ('dbx_business_glossary_term' = 'Material Info Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `procurement_supply_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `quota_arrangement_id` SET TAGS ('dbx_business_glossary_term' = 'Quota Arrangement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `agreement_type` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'scheduling_agreement|contract|blanket_po|none');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `info_record_number` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Info Record Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `is_blocked` SET TAGS ('dbx_business_glossary_term' = 'Source Blocked Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `is_blocked` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `is_fixed_source` SET TAGS ('dbx_business_glossary_term' = 'Fixed Source Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `is_fixed_source` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `is_mrp_source_list_required` SET TAGS ('dbx_business_glossary_term' = 'MRP Source List Required Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `is_mrp_source_list_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `is_preferred_source` SET TAGS ('dbx_business_glossary_term' = 'Preferred Source Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `is_preferred_source` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_business_glossary_term' = 'Last Reviewed Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `maximum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Maximum Order Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `mrp_relevance_indicator` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Relevance Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `mrp_relevance_indicator` SET TAGS ('dbx_value_regex' = '0|1|2');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Source List Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Source List Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `order_unit` SET TAGS ('dbx_business_glossary_term' = 'Order Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `outline_agreement_item` SET TAGS ('dbx_business_glossary_term' = 'Outline Agreement Item Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `outline_agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Outline Agreement Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `plant_of_supply` SET TAGS ('dbx_business_glossary_term' = 'Plant of Supply');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'direct|indirect');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization (PO) Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `quota_arrangement_number` SET TAGS ('dbx_business_glossary_term' = 'Quota Arrangement Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `quota_percentage` SET TAGS ('dbx_business_glossary_term' = 'Quota Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `quota_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ECC|ARIBA|MANUAL');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `special_procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Special Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `special_procurement_type` SET TAGS ('dbx_value_regex' = 'standard|subcontracting|consignment|third_party|pipeline');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `standard_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Standard Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `standard_lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Source List Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|expired|blocked|pending_approval');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `sub_range` SET TAGS ('dbx_business_glossary_term' = 'Supplier Sub-Range');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `supply_type` SET TAGS ('dbx_business_glossary_term' = 'Supply Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `supply_type` SET TAGS ('dbx_value_regex' = 'external_supplier|internal_plant|subcontracting|consignment|stock_transfer');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `usage` SET TAGS ('dbx_business_glossary_term' = 'Source List Usage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `usage` SET TAGS ('dbx_value_regex' = 'mandatory|optional');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Source List Valid From Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Source List Valid To Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` SET TAGS ('dbx_subdomain' = 'strategic_sourcing');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `quota_arrangement_id` SET TAGS ('dbx_business_glossary_term' = 'Quota Arrangement ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `inventory_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `procurement_material_info_record_id` SET TAGS ('dbx_business_glossary_term' = 'Material Info Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `procurement_supply_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `allocated_quantity` SET TAGS ('dbx_business_glossary_term' = 'Allocated Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `arrangement_number` SET TAGS ('dbx_business_glossary_term' = 'Quota Arrangement Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `arrangement_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `category_code` SET TAGS ('dbx_business_glossary_term' = 'Material Group / Category Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `category_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `info_record_number` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Info Record Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `info_record_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `is_blocked` SET TAGS ('dbx_business_glossary_term' = 'Blocked Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `is_blocked` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `is_fixed_source` SET TAGS ('dbx_business_glossary_term' = 'Fixed Source Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `is_fixed_source` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `last_reset_date` SET TAGS ('dbx_business_glossary_term' = 'Last Quota Reset Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `last_reset_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Quota Arrangement Line Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `line_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `maximum_lot_size` SET TAGS ('dbx_business_glossary_term' = 'Maximum Lot Size');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `minimum_lot_size` SET TAGS ('dbx_business_glossary_term' = 'Minimum Lot Size');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Quota Arrangement Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `outline_agreement_line` SET TAGS ('dbx_business_glossary_term' = 'Outline Agreement Line Item');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `outline_agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Outline Agreement Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `outline_agreement_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Quota Priority');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'external|subcontracting|consignment|stock_transfer');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization (PO) Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `quota_base_quantity` SET TAGS ('dbx_business_glossary_term' = 'Quota Base Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `quota_percentage` SET TAGS ('dbx_business_glossary_term' = 'Quota Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `quota_percentage` SET TAGS ('dbx_value_regex' = '^(100(.00?)?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `quota_usage_count` SET TAGS ('dbx_business_glossary_term' = 'Quota Usage Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ECC|MANUAL');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `source_type` SET TAGS ('dbx_business_glossary_term' = 'Source Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `source_type` SET TAGS ('dbx_value_regex' = 'vendor|outline_agreement|scheduling_agreement');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `special_procurement_key` SET TAGS ('dbx_business_glossary_term' = 'Special Procurement Key');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `special_procurement_key` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Quota Arrangement Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|expired|suspended|pending_approval');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `supplier_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `supplying_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Supplying Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `supplying_plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Validity End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `procurement_inbound_delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `export_classification_id` SET TAGS ('dbx_business_glossary_term' = 'Export Classification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `incoterm_id` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `supply_network_node_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Network Node Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `actual_arrival_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `actual_arrival_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `asn_number` SET TAGS ('dbx_business_glossary_term' = 'Advance Shipping Notice (ASN) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `carrier_code` SET TAGS ('dbx_business_glossary_term' = 'Carrier Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `carrier_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `customs_clearance_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `customs_clearance_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|in_progress|cleared|held|rejected');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `customs_declaration_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `delivery_number` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `delivery_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `delivery_priority` SET TAGS ('dbx_business_glossary_term' = 'Delivery Priority');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `delivery_priority` SET TAGS ('dbx_value_regex' = 'urgent|high|normal|low');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `delivery_type` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `delivery_type` SET TAGS ('dbx_value_regex' = 'standard|return|subcontracting|consignment|intercompany|third_party');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `dock_door_number` SET TAGS ('dbx_business_glossary_term' = 'Dock Door Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Document Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `document_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `goods_receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt (GR) Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `goods_receipt_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `grn_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Note (GRN) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Location');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `planned_arrival_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Arrival Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `planned_arrival_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Receiving Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `shipment_number` SET TAGS ('dbx_business_glossary_term' = 'Shipment Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `shipping_point` SET TAGS ('dbx_business_glossary_term' = 'Shipping Point');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'created|in_transit|arrived|partially_received|fully_received|cancelled|on_hold');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `supplier_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `total_gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Total Gross Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `total_gross_weight_kg` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `total_item_count` SET TAGS ('dbx_business_glossary_term' = 'Total Line Item Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `total_item_count` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `total_net_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Total Net Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `total_net_weight_kg` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `total_volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Total Volume (m³)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `total_volume_m3` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `transport_document_number` SET TAGS ('dbx_business_glossary_term' = 'Transport Document Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `unloading_point` SET TAGS ('dbx_business_glossary_term' = 'Unloading Point');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ALTER COLUMN `warehouse_number` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `supplier_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Audit ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `ariba_audit_id` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Audit ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `audit_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Audit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `internal_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Audit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Auditor Employee ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `supplier_performance_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Performance Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `actual_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Audit Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `audit_end_date` SET TAGS ('dbx_business_glossary_term' = 'Audit End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `audit_method` SET TAGS ('dbx_business_glossary_term' = 'Audit Method');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `audit_method` SET TAGS ('dbx_value_regex' = 'on_site|remote|hybrid|document_review');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `audit_number` SET TAGS ('dbx_business_glossary_term' = 'Audit Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `audit_number` SET TAGS ('dbx_value_regex' = '^AUD-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `audit_result` SET TAGS ('dbx_business_glossary_term' = 'Audit Result');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `audit_result` SET TAGS ('dbx_value_regex' = 'approved|conditionally_approved|not_approved|suspended|pending_review');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `audit_team_members` SET TAGS ('dbx_business_glossary_term' = 'Audit Team Members');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `capa_closure_date` SET TAGS ('dbx_business_glossary_term' = 'CAPA Closure Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `capa_due_date` SET TAGS ('dbx_business_glossary_term' = 'CAPA Due Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `capa_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Required');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `capa_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `capa_submission_date` SET TAGS ('dbx_business_glossary_term' = 'CAPA Submission Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `critical_finding_count` SET TAGS ('dbx_business_glossary_term' = 'Critical Finding Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `critical_finding_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `cybersecurity_score` SET TAGS ('dbx_business_glossary_term' = 'Cybersecurity Posture Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `cybersecurity_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `environmental_compliance_score` SET TAGS ('dbx_business_glossary_term' = 'Environmental Compliance Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `environmental_compliance_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `lead_auditor_name` SET TAGS ('dbx_business_glossary_term' = 'Lead Auditor Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `major_finding_count` SET TAGS ('dbx_business_glossary_term' = 'Major Finding Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `major_finding_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `manufacturing_capability_score` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Capability Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `manufacturing_capability_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `minor_finding_count` SET TAGS ('dbx_business_glossary_term' = 'Minor Finding Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `minor_finding_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `next_scheduled_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Audit Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Audit Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `observation_count` SET TAGS ('dbx_business_glossary_term' = 'Observation Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `observation_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `overall_score` SET TAGS ('dbx_business_glossary_term' = 'Overall Audit Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `overall_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `planned_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Audit Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `quality_systems_score` SET TAGS ('dbx_business_glossary_term' = 'Quality Management System (QMS) Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `quality_systems_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `re_audit_required` SET TAGS ('dbx_business_glossary_term' = 'Re-Audit Required');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `re_audit_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `re_audit_scheduled_date` SET TAGS ('dbx_business_glossary_term' = 'Re-Audit Scheduled Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `report_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Audit Report Issue Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Audit Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'planned|in_progress|completed|cancelled|pending_capa|closed');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `supplier_site_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Site Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `supplier_site_country` SET TAGS ('dbx_business_glossary_term' = 'Supplier Site Country');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `supplier_site_country` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `total_finding_count` SET TAGS ('dbx_business_glossary_term' = 'Total Finding Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ALTER COLUMN `total_finding_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` SET TAGS ('dbx_subdomain' = 'performance_analytics');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `procurement_spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Category ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `annual_spend_budget` SET TAGS ('dbx_business_glossary_term' = 'Annual Spend Budget');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `annual_spend_budget` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `category_code` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `category_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `category_description` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `category_level` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Hierarchy Level');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `category_level` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `category_manager_email` SET TAGS ('dbx_business_glossary_term' = 'Category Manager Email Address');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `category_manager_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `category_manager_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `category_manager_name` SET TAGS ('dbx_business_glossary_term' = 'Category Manager Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `category_name` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `conflict_minerals_applicable` SET TAGS ('dbx_business_glossary_term' = 'Conflict Minerals Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `conflict_minerals_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `cost_element_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Element Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `cost_element_code` SET TAGS ('dbx_value_regex' = '^[0-9A-Z]{4,12}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Default Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `hazmat_applicable` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HAZMAT) Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `hazmat_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Default Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `is_direct_material` SET TAGS ('dbx_business_glossary_term' = 'Direct Material Category Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `is_direct_material` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `is_mro` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Repair and Operations (MRO) Category Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `is_mro` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `is_strategic` SET TAGS ('dbx_business_glossary_term' = 'Strategic Category Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `is_strategic` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `kraljic_position` SET TAGS ('dbx_business_glossary_term' = 'Kraljic Matrix Position');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `kraljic_position` SET TAGS ('dbx_value_regex' = 'strategic|leverage|bottleneck|non_critical');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_business_glossary_term' = 'Last Category Review Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Standard Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `material_group_code` SET TAGS ('dbx_business_glossary_term' = 'Material Group (SAP) Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `material_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,9}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `parent_category_code` SET TAGS ('dbx_business_glossary_term' = 'Parent Spend Category Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `parent_category_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Default Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'direct|indirect|services|capex');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `reach_applicable` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `reach_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Supply Risk Level');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `rohs_applicable` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `rohs_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `savings_target_percent` SET TAGS ('dbx_business_glossary_term' = 'Savings Target Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `savings_target_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `savings_target_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `sourcing_strategy` SET TAGS ('dbx_business_glossary_term' = 'Strategic Sourcing Strategy');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `sourcing_strategy` SET TAGS ('dbx_value_regex' = 'competitive_bidding|single_source|dual_source|multi_source|preferred_supplier|spot_buy|framework_agreement|consortium_buying|make_vs_buy');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `spend_type` SET TAGS ('dbx_business_glossary_term' = 'Spend Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `spend_type` SET TAGS ('dbx_value_regex' = 'raw_material|component|subassembly|mro|facilities|it|logistics|contract_manufacturing|professional_services|utilities|packaging|tooling|other');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|under_review|deprecated');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `supply_market_complexity` SET TAGS ('dbx_business_glossary_term' = 'Supply Market Complexity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `supply_market_complexity` SET TAGS ('dbx_value_regex' = 'simple|moderate|complex|highly_complex');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `unspsc_code` SET TAGS ('dbx_business_glossary_term' = 'United Nations Standard Products and Services Code (UNSPSC)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ALTER COLUMN `unspsc_code` SET TAGS ('dbx_value_regex' = '^[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` SET TAGS ('dbx_subdomain' = 'demand_planning');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `supply_network_node_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Network Node ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `incoterm_id` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `customs_office_code` SET TAGS ('dbx_business_glossary_term' = 'Customs Office Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `handling_capacity_kg_per_day` SET TAGS ('dbx_business_glossary_term' = 'Handling Capacity (Kilograms Per Day)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `handling_capacity_kg_per_day` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `inbound_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Inbound Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `inbound_lead_time_days` SET TAGS ('dbx_value_regex' = '^d+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `is_bonded_warehouse` SET TAGS ('dbx_business_glossary_term' = 'Bonded Warehouse Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `is_bonded_warehouse` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `is_free_trade_zone` SET TAGS ('dbx_business_glossary_term' = 'Free Trade Zone (FTZ) Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `is_free_trade_zone` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `is_hazmat_certified` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (Hazmat) Certified Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `is_hazmat_certified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Geographic Latitude');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `latitude` SET TAGS ('dbx_value_regex' = '^-?(90(.0+)?|[1-8]?d(.d+)?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Geographic Longitude');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `longitude` SET TAGS ('dbx_value_regex' = '^-?(180(.0+)?|1[0-7]d(.d+)?|[1-9]?d(.d+)?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `mrp_area_code` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Area Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `mrp_area_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `network_role` SET TAGS ('dbx_business_glossary_term' = 'Supply Network Node Role');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `network_role` SET TAGS ('dbx_value_regex' = 'source|intermediate|sink');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `node_code` SET TAGS ('dbx_business_glossary_term' = 'Supply Network Node Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `node_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `node_name` SET TAGS ('dbx_business_glossary_term' = 'Supply Network Node Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `node_owner_type` SET TAGS ('dbx_business_glossary_term' = 'Node Owner Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `node_owner_type` SET TAGS ('dbx_value_regex' = 'owned|leased|third_party_logistics|consignment|joint_venture');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `node_type` SET TAGS ('dbx_business_glossary_term' = 'Supply Network Node Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `node_type` SET TAGS ('dbx_value_regex' = 'plant|distribution_center|supplier_location|customer_delivery_point|cross_dock|warehouse|port|transit_hub|third_party_logistics');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `operating_hours_description` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `outbound_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Outbound Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `outbound_lead_time_days` SET TAGS ('dbx_value_regex' = '^d+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `planning_calendar_code` SET TAGS ('dbx_business_glossary_term' = 'Planning Calendar Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `postal_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `replenishment_strategy` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Strategy');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `replenishment_strategy` SET TAGS ('dbx_value_regex' = 'make_to_stock|make_to_order|assemble_to_order|engineer_to_order|just_in_time|kanban|vendor_managed_inventory|consignment');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `safety_stock_days_of_supply` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock Days of Supply');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `safety_stock_days_of_supply` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_APO|INFOR_WMS|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Supply Network Node Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|planned|decommissioned|suspended');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `storage_capacity_m3` SET TAGS ('dbx_business_glossary_term' = 'Storage Capacity (Cubic Meters)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `storage_capacity_m3` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `street_address` SET TAGS ('dbx_business_glossary_term' = 'Street Address');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `street_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `street_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `third_party_operator_name` SET TAGS ('dbx_business_glossary_term' = 'Third-Party Logistics (3PL) Operator Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `third_party_operator_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `third_party_operator_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `throughput_capacity_units_per_day` SET TAGS ('dbx_business_glossary_term' = 'Throughput Capacity (Units Per Day)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `throughput_capacity_units_per_day` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `time_zone` SET TAGS ('dbx_business_glossary_term' = 'Time Zone');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_network_node` ALTER COLUMN `transportation_zone_code` SET TAGS ('dbx_business_glossary_term' = 'Transportation Zone Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `po_change_record_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Change Record ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Change Requestor ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `procurement_po_line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Po Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|not_required|escalated|withdrawn');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `change_document_number` SET TAGS ('dbx_business_glossary_term' = 'Change Document Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `change_level` SET TAGS ('dbx_business_glossary_term' = 'Change Level');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `change_level` SET TAGS ('dbx_value_regex' = 'header|line_item|schedule_line');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `change_number` SET TAGS ('dbx_business_glossary_term' = 'Change Order Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `change_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Change Reason Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `change_reason_code` SET TAGS ('dbx_value_regex' = 'supplier_request|internal_requirement_change|price_negotiation|forecast_revision|quality_issue|capacity_constraint|engineering_change|budget_adjustment|force_majeure|error_correction|cancellation_request|other');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `change_reason_text` SET TAGS ('dbx_business_glossary_term' = 'Change Reason Text');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `change_requestor_department` SET TAGS ('dbx_business_glossary_term' = 'Change Requestor Department');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `change_requestor_name` SET TAGS ('dbx_business_glossary_term' = 'Change Requestor Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `change_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Change Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `change_type` SET TAGS ('dbx_business_glossary_term' = 'Change Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `change_type` SET TAGS ('dbx_value_regex' = 'quantity_amendment|price_revision|delivery_date_change|payment_terms_change|supplier_change|line_addition|line_deletion|cancellation|incoterms_change|account_assignment_change|header_text_change|other');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `changed_field_description` SET TAGS ('dbx_business_glossary_term' = 'Changed Field Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `changed_field_name` SET TAGS ('dbx_business_glossary_term' = 'Changed Field Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `ecn_reference` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Reference');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `new_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'New Delivery Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `new_net_price` SET TAGS ('dbx_business_glossary_term' = 'New Net Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `new_net_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `new_quantity` SET TAGS ('dbx_business_glossary_term' = 'New Order Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `new_value` SET TAGS ('dbx_business_glossary_term' = 'New Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `original_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Original Delivery Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `original_net_price` SET TAGS ('dbx_business_glossary_term' = 'Original Net Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `original_net_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `original_quantity` SET TAGS ('dbx_business_glossary_term' = 'Original Order Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `original_value` SET TAGS ('dbx_business_glossary_term' = 'Original Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `po_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `po_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `price_unit` SET TAGS ('dbx_business_glossary_term' = 'Price Unit');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `purchasing_org` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `quantity_uom` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure (UOM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ARIBA|MANUAL|INTERFACE');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `supplier_acknowledgment_status` SET TAGS ('dbx_business_glossary_term' = 'Supplier Acknowledgment Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `supplier_acknowledgment_status` SET TAGS ('dbx_value_regex' = 'pending|acknowledged|disputed|accepted|rejected');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `supplier_notification_date` SET TAGS ('dbx_business_glossary_term' = 'Supplier Notification Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `supplier_notified_flag` SET TAGS ('dbx_business_glossary_term' = 'Supplier Notified Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ALTER COLUMN `supplier_notified_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'supplier Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_qualification` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_qualification` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_qualification` ALTER COLUMN `supplier_qualification_id` SET TAGS ('dbx_business_glossary_term' = 'supplier_qualification Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_event` SET TAGS ('dbx_subdomain' = 'strategic_sourcing');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_event` ALTER COLUMN `sourcing_event_id` SET TAGS ('dbx_business_glossary_term' = 'sourcing_event Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_bid` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_bid` SET TAGS ('dbx_subdomain' = 'strategic_sourcing');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_bid` ALTER COLUMN `sourcing_bid_id` SET TAGS ('dbx_business_glossary_term' = 'sourcing_bid Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` SET TAGS ('dbx_subdomain' = 'strategic_sourcing');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` SET TAGS ('dbx_original_name' = 'procurement_contract');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `procurement_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Contract ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `incoterm_id` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `it_contract_id` SET TAGS ('dbx_business_glossary_term' = 'It Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Manager Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `procurement_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `procurement_sourcing_event_id` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `procurement_spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `procurement_supply_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Contract Approval Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|withdrawn');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Contract Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Approval Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `ariba_contract_reference` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Contract ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto-Renewal Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `category_code` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country of Supply Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Contract Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Contract Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Effective End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Location');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Contract Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `minimum_order_value` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `minimum_order_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `owner` SET TAGS ('dbx_business_glossary_term' = 'Contract Owner');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `penalty_clause_description` SET TAGS ('dbx_business_glossary_term' = 'Penalty Clause Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `penalty_clause_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `penalty_clause_flag` SET TAGS ('dbx_business_glossary_term' = 'Penalty Clause Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `penalty_clause_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'direct|indirect|services|capex|mro');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `reach_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'REACH Compliance Required Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `reach_compliance_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `released_value` SET TAGS ('dbx_business_glossary_term' = 'Released Contract Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `released_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `renewal_notice_days` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notice Period (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `renewal_notice_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `rohs_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'RoHS Compliance Required Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `rohs_compliance_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `sap_outline_agreement_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Outline Agreement Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `sap_outline_agreement_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `sourcing_event_reference` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Reference Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Contract Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|active|expired|terminated|suspended|under_renewal|closed');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Termination Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `termination_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Contract Termination Reason');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `termination_reason` SET TAGS ('dbx_value_regex' = 'supplier_non_performance|mutual_agreement|business_need_change|regulatory_compliance|cost_reduction|supplier_disqualification|other');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Contract Title');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `total_contract_value` SET TAGS ('dbx_business_glossary_term' = 'Total Contract Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `total_contract_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Contract Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'blanket_purchase_agreement|long_term_supply_agreement|frame_contract|spot_buy|scheduling_agreement|master_supply_agreement|service_agreement');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` SET TAGS ('dbx_subdomain' = 'strategic_sourcing');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `contract_line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Line Item ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `contract_line_id` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Contract Line Item ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `incoterm_id` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `inventory_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `procurement_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_business_glossary_term' = 'Account Assignment Category');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_value_regex' = 'K|F|P|A|C|U|blank');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Contract Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `delivery_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Contracted Delivery Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Line Item Effective End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Line Item Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `escalation_index_reference` SET TAGS ('dbx_business_glossary_term' = 'Price Escalation Index Reference');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `escalation_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Price Escalation Rate Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `escalation_rate_pct` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `item_category` SET TAGS ('dbx_business_glossary_term' = 'Contract Line Item Category');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `item_category` SET TAGS ('dbx_value_regex' = 'standard|consignment|subcontracting|third_party|service|limit');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Line Item Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `line_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `maximum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Maximum Order Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `net_price` SET TAGS ('dbx_business_glossary_term' = 'Net Contract Unit Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `net_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `over_delivery_tolerance_pct` SET TAGS ('dbx_business_glossary_term' = 'Over-Delivery Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `over_delivery_tolerance_pct` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Receiving Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `price_escalation_clause` SET TAGS ('dbx_business_glossary_term' = 'Price Escalation Clause Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `price_escalation_clause` SET TAGS ('dbx_value_regex' = 'none|fixed|index_linked|annual_review|formula_based|cpi_linked|raw_material_index');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `price_escalation_clause` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `price_unit` SET TAGS ('dbx_business_glossary_term' = 'Price Unit Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Compliant');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `released_quantity` SET TAGS ('dbx_business_glossary_term' = 'Released Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `released_value` SET TAGS ('dbx_business_glossary_term' = 'Released Contract Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `released_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Compliant');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `short_text` SET TAGS ('dbx_business_glossary_term' = 'Contract Line Item Short Text');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Contract Line Item Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|closed|blocked|cancelled|pending_approval|expired');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `target_quantity` SET TAGS ('dbx_business_glossary_term' = 'Target Contracted Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `target_value` SET TAGS ('dbx_business_glossary_term' = 'Target Contract Line Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `target_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `under_delivery_tolerance_pct` SET TAGS ('dbx_business_glossary_term' = 'Under-Delivery Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `under_delivery_tolerance_pct` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'purchase_requisition Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ALTER COLUMN `spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'purchase_order Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Reference to procurement_supplier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_line_item` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_line_item` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_line_item` ALTER COLUMN `po_line_item_id` SET TAGS ('dbx_business_glossary_term' = 'po_line_item Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_line_item` ALTER COLUMN `procurement_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt` ALTER COLUMN `goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'goods_receipt Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'supplier_invoice Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ALTER COLUMN `procurement_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_category` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_category` SET TAGS ('dbx_subdomain' = 'performance_analytics');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_category` ALTER COLUMN `spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'spend_category Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `preferred_supplier_list_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier List (PSL) ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `procurement_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `sourcing_event_id` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `supplier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `supplier_qualification_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Qualification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|withdrawn');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `ariba_psl_reference` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Preferred Supplier List (PSL) ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `category_code` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `category_manager_name` SET TAGS ('dbx_business_glossary_term' = 'Category Manager Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `conflict_minerals_compliant` SET TAGS ('dbx_business_glossary_term' = 'Conflict Minerals Compliant');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `conflict_minerals_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `designation_reason` SET TAGS ('dbx_business_glossary_term' = 'Preference Designation Reason');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `is_diversity_supplier` SET TAGS ('dbx_business_glossary_term' = 'Diversity Supplier Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `is_diversity_supplier` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `is_single_source` SET TAGS ('dbx_business_glossary_term' = 'Single Source Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `is_single_source` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `is_strategic_supplier` SET TAGS ('dbx_business_glossary_term' = 'Strategic Supplier Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `is_strategic_supplier` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `preference_tier` SET TAGS ('dbx_business_glossary_term' = 'Supplier Preference Tier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `preference_tier` SET TAGS ('dbx_value_regex' = 'preferred|approved|conditional|restricted');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `priority_rank` SET TAGS ('dbx_business_glossary_term' = 'Supplier Priority Rank');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `priority_rank` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'direct|indirect|services|capex|mro');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `psl_number` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier List (PSL) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `psl_number` SET TAGS ('dbx_value_regex' = '^PSL-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization (Purchasing Org) Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Compliant');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Compliant');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `single_source_justification` SET TAGS ('dbx_business_glossary_term' = 'Single Source Justification');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `sourcing_event_reference` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Reference Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `sourcing_strategy` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Strategy');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `sourcing_strategy` SET TAGS ('dbx_value_regex' = 'single_source|dual_source|multi_source|preferred_with_backup|strategic_partnership');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `spend_allocation_percent` SET TAGS ('dbx_business_glossary_term' = 'Spend Allocation Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `spend_allocation_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'PSL Entry Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|under_review|suspended|expired');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_performance` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_performance` SET TAGS ('dbx_subdomain' = 'performance_analytics');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_performance` ALTER COLUMN `supplier_performance_id` SET TAGS ('dbx_business_glossary_term' = 'supplier_performance Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_performance` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` SET TAGS ('dbx_subdomain' = 'performance_analytics');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `supplier_risk_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Risk ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `supplier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `supplier_qualification_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Qualification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `third_party_risk_id` SET TAGS ('dbx_business_glossary_term' = 'Third Party Risk Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `actual_resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Resolution Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `actual_resolution_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `affected_material_group` SET TAGS ('dbx_business_glossary_term' = 'Affected Material Group');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `affected_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Affected Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `annual_spend_amount` SET TAGS ('dbx_business_glossary_term' = 'Annual Spend Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `annual_spend_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `ariba_risk_reference` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Risk ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Risk Assessment Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `assessment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `business_continuity_plan_status` SET TAGS ('dbx_business_glossary_term' = 'Business Continuity Plan (BCP) Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `business_continuity_plan_status` SET TAGS ('dbx_value_regex' = 'verified|submitted|not_submitted|expired|not_required');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `conflict_minerals_status` SET TAGS ('dbx_business_glossary_term' = 'Conflict Minerals Compliance Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `conflict_minerals_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|not_applicable|under_review|pending_declaration');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `contingency_plan` SET TAGS ('dbx_business_glossary_term' = 'Contingency Plan');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `escalation_date` SET TAGS ('dbx_business_glossary_term' = 'Escalation Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `escalation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `estimated_financial_impact` SET TAGS ('dbx_business_glossary_term' = 'Estimated Financial Impact');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `estimated_financial_impact` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `financial_risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Financial Risk Rating');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `financial_risk_rating` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `financial_risk_score` SET TAGS ('dbx_business_glossary_term' = 'Financial Risk Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `financial_risk_score` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `geopolitical_risk_score` SET TAGS ('dbx_business_glossary_term' = 'Geopolitical Risk Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `identification_date` SET TAGS ('dbx_business_glossary_term' = 'Risk Identification Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `identification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `impact_score` SET TAGS ('dbx_business_glossary_term' = 'Risk Impact Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `impact_score` SET TAGS ('dbx_value_regex' = '^([1-9]|10)(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `is_escalated` SET TAGS ('dbx_business_glossary_term' = 'Escalation Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `is_escalated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `is_single_source` SET TAGS ('dbx_business_glossary_term' = 'Single Source Dependency Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `is_single_source` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `mitigation_actions` SET TAGS ('dbx_business_glossary_term' = 'Risk Mitigation Actions');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `mitigation_strategy` SET TAGS ('dbx_business_glossary_term' = 'Risk Mitigation Strategy');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `mitigation_strategy` SET TAGS ('dbx_value_regex' = 'dual_sourcing|safety_stock_increase|alternative_supplier_qualification|supplier_development|contractual_protection|geographic_diversification|vertical_integration|demand_reduction|insurance|monitoring_only|no_action');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Origin Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `probability_score` SET TAGS ('dbx_business_glossary_term' = 'Risk Probability Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `probability_score` SET TAGS ('dbx_value_regex' = '^(0(.d{1,2})?|1(.0{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `reach_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'REACH Compliance Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `reach_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|not_applicable|under_review');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `regulatory_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `regulatory_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|under_review|not_assessed|exempted');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `risk_description` SET TAGS ('dbx_business_glossary_term' = 'Risk Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `risk_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Risk Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `risk_number` SET TAGS ('dbx_value_regex' = '^SR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `risk_owner` SET TAGS ('dbx_business_glossary_term' = 'Risk Owner');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `risk_owner_department` SET TAGS ('dbx_business_glossary_term' = 'Risk Owner Department');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `risk_score` SET TAGS ('dbx_business_glossary_term' = 'Composite Risk Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `risk_subcategory` SET TAGS ('dbx_business_glossary_term' = 'Risk Subcategory');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `risk_tier` SET TAGS ('dbx_business_glossary_term' = 'Risk Tier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `risk_tier` SET TAGS ('dbx_value_regex' = 'tier_1|tier_2|tier_3');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `risk_title` SET TAGS ('dbx_business_glossary_term' = 'Risk Title');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `rohs_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'RoHS Compliance Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `rohs_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|not_applicable|under_review');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `sanctions_screening_status` SET TAGS ('dbx_business_glossary_term' = 'Sanctions Screening Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `sanctions_screening_status` SET TAGS ('dbx_value_regex' = 'cleared|flagged|pending|not_screened');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `severity` SET TAGS ('dbx_business_glossary_term' = 'Risk Severity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `severity` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `single_source_material_count` SET TAGS ('dbx_business_glossary_term' = 'Single Source Material Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `spend_concentration_percent` SET TAGS ('dbx_business_glossary_term' = 'Spend Concentration Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `spend_concentration_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `spend_concentration_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Risk Record Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|under_review|escalated|closed|superseded');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `target_resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Target Resolution Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ALTER COLUMN `target_resolution_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` SET TAGS ('dbx_subdomain' = 'strategic_sourcing');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `sourcing_award_id` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Award ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `incoterm_id` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `procurement_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `procurement_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `sourcing_bid_id` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Bid Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `sourcing_event_id` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|escalated|withdrawn');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `ariba_award_reference` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Award ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `award_basis` SET TAGS ('dbx_business_glossary_term' = 'Award Basis');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `award_basis` SET TAGS ('dbx_value_regex' = 'lowest_price|best_value|technical_merit|strategic_fit|incumbent_retention|sole_source|negotiated');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `award_date` SET TAGS ('dbx_business_glossary_term' = 'Award Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `award_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `award_number` SET TAGS ('dbx_business_glossary_term' = 'Award Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `award_number` SET TAGS ('dbx_value_regex' = '^AWD-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `award_rationale` SET TAGS ('dbx_business_glossary_term' = 'Award Rationale');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `award_split_percent` SET TAGS ('dbx_business_glossary_term' = 'Award Split Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `award_split_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `award_type` SET TAGS ('dbx_business_glossary_term' = 'Award Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `award_type` SET TAGS ('dbx_value_regex' = 'full_award|partial_award|split_award|conditional_award|no_award');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `award_valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Award Valid From Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `award_valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `award_valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Award Valid To Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `award_valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `awarded_quantity` SET TAGS ('dbx_business_glossary_term' = 'Awarded Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `awarded_total_value` SET TAGS ('dbx_business_glossary_term' = 'Awarded Total Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `awarded_total_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `awarded_unit_price` SET TAGS ('dbx_business_glossary_term' = 'Awarded Unit Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `awarded_unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `baseline_unit_price` SET TAGS ('dbx_business_glossary_term' = 'Baseline Unit Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `baseline_unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `bid_number` SET TAGS ('dbx_business_glossary_term' = 'Bid Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `evaluation_score` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time Days');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `line_item_number` SET TAGS ('dbx_business_glossary_term' = 'Line Item Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `outcome_document_type` SET TAGS ('dbx_business_glossary_term' = 'Outcome Document Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `outcome_document_type` SET TAGS ('dbx_value_regex' = 'purchase_order|blanket_po|supply_agreement|scheduling_agreement|info_record_update|no_document');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `price_unit` SET TAGS ('dbx_business_glossary_term' = 'Price Unit');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `quantity_uom` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure (UOM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `savings_amount` SET TAGS ('dbx_business_glossary_term' = 'Savings Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `savings_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `savings_percent` SET TAGS ('dbx_business_glossary_term' = 'Savings Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `sourcing_event_number` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Award Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|approved|published|accepted|rejected|cancelled|superseded');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `supplier_acceptance_date` SET TAGS ('dbx_business_glossary_term' = 'Supplier Acceptance Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `supplier_acceptance_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `supplier_acceptance_status` SET TAGS ('dbx_business_glossary_term' = 'Supplier Acceptance Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `supplier_acceptance_status` SET TAGS ('dbx_value_regex' = 'pending|accepted|rejected|counter_proposed|expired');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `supplier_notification_date` SET TAGS ('dbx_business_glossary_term' = 'Supplier Notification Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`sourcing_award` ALTER COLUMN `supplier_notification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` SET TAGS ('dbx_subdomain' = 'performance_analytics');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `spend_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Transaction ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `it_cost_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'It Cost Allocation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `procurement_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `procurement_goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `procurement_material_info_record_id` SET TAGS ('dbx_business_glossary_term' = 'Material Info Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `procurement_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `procurement_po_line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Po Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `procurement_supplier_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `category_code` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `contracted_unit_price` SET TAGS ('dbx_business_glossary_term' = 'Contracted Unit Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `contracted_unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `document_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `grn_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Note (GRN) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Spend Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `gross_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Invoice Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `invoiced_unit_price` SET TAGS ('dbx_business_glossary_term' = 'Invoiced Unit Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `invoiced_unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `is_contract_backed` SET TAGS ('dbx_business_glossary_term' = 'Contract-Backed Spend Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `is_contract_backed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `is_maverick_spend` SET TAGS ('dbx_business_glossary_term' = 'Maverick Spend Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `is_maverick_spend` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `local_currency_amount` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Spend Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `local_currency_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `po_line_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Line Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `po_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'direct|indirect|capex|services|mro');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Transaction Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `savings_amount` SET TAGS ('dbx_business_glossary_term' = 'Savings Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `savings_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `savings_type` SET TAGS ('dbx_business_glossary_term' = 'Savings Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `savings_type` SET TAGS ('dbx_value_regex' = 'hard_savings|soft_savings|cost_avoidance|rebate|early_payment_discount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ARIBA|MANUAL');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `spend_amount` SET TAGS ('dbx_business_glossary_term' = 'Spend Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `spend_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Spend Transaction Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'posted|reversed|parked|blocked|cleared|disputed');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `transaction_number` SET TAGS ('dbx_business_glossary_term' = 'Spend Transaction Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `transaction_type` SET TAGS ('dbx_business_glossary_term' = 'Spend Transaction Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `transaction_type` SET TAGS ('dbx_value_regex' = 'purchase_order|blanket_order_release|evaluated_receipt_settlement|credit_memo|debit_memo|invoice_adjustment|intercompany');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` SET TAGS ('dbx_subdomain' = 'performance_analytics');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `savings_initiative_id` SET TAGS ('dbx_business_glossary_term' = 'Savings Initiative ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `procurement_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `sourcing_event_id` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `supplier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `supplier_performance_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Performance Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Initiative Approval Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `ariba_initiative_reference` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Initiative ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `baseline_price` SET TAGS ('dbx_business_glossary_term' = 'Baseline Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `baseline_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `baseline_spend_amount` SET TAGS ('dbx_business_glossary_term' = 'Baseline Spend Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `baseline_spend_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `category_code` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Initiative Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `finance_validated` SET TAGS ('dbx_business_glossary_term' = 'Finance Validated Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `finance_validated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-(0[1-9]|1[0-2])$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `identification_date` SET TAGS ('dbx_business_glossary_term' = 'Initiative Identification Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `identification_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `initiative_number` SET TAGS ('dbx_business_glossary_term' = 'Savings Initiative Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `initiative_number` SET TAGS ('dbx_value_regex' = '^SI-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `initiative_owner` SET TAGS ('dbx_business_glossary_term' = 'Initiative Owner Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `initiative_type` SET TAGS ('dbx_business_glossary_term' = 'Savings Initiative Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `initiative_type` SET TAGS ('dbx_value_regex' = 'hard_savings|soft_savings|cost_avoidance|demand_reduction|process_efficiency|specification_change|supplier_consolidation|payment_terms_improvement');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `measurement_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Measurement Period End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `measurement_period_end_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `measurement_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Measurement Period Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `measurement_period_start_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `negotiated_price` SET TAGS ('dbx_business_glossary_term' = 'Negotiated Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `negotiated_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Initiative Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'direct|indirect|services|capex|mro');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `projected_savings_amount` SET TAGS ('dbx_business_glossary_term' = 'Projected Savings Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `projected_savings_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `realization_date` SET TAGS ('dbx_business_glossary_term' = 'Savings Realization Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `realization_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `realization_status` SET TAGS ('dbx_business_glossary_term' = 'Savings Realization Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `realization_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|fully_realized|partially_realized|not_realized|cancelled');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `realized_savings_amount` SET TAGS ('dbx_business_glossary_term' = 'Realized Savings Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `realized_savings_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `savings_percent` SET TAGS ('dbx_business_glossary_term' = 'Savings Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `savings_percent` SET TAGS ('dbx_value_regex' = '^-?[0-9]{1,3}.[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `sourcing_event_reference` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Reference Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `sourcing_strategy` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Strategy');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `sourcing_strategy` SET TAGS ('dbx_value_regex' = 'competitive_bidding|sole_source_negotiation|supplier_consolidation|demand_management|specification_change|should_cost_analysis|global_sourcing|low_cost_country_sourcing|rebate_negotiation|payment_terms_optimization');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Initiative Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|approved|in_progress|realized|partially_realized|cancelled|on_hold');
ALTER TABLE `manufacturing_ecm`.`procurement`.`savings_initiative` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Initiative Title');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `purchase_requisition_approval_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Approval ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver Employee ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `delegated_by_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Delegated By Employee ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `escalated_to_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Escalated To Employee ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `procurement_purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `approval_action` SET TAGS ('dbx_business_glossary_term' = 'Approval Action');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `approval_action` SET TAGS ('dbx_value_regex' = 'approved|rejected|returned|delegated|pending|escalated|cancelled');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `approval_channel` SET TAGS ('dbx_business_glossary_term' = 'Approval Channel');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `approval_channel` SET TAGS ('dbx_value_regex' = 'sap_workflow|ariba_portal|email|mobile_app|manual');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `approval_cycle_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Approval Cycle Time (Hours)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `approval_level` SET TAGS ('dbx_business_glossary_term' = 'Approval Level');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `approval_level` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `approval_level_description` SET TAGS ('dbx_business_glossary_term' = 'Approval Level Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `approval_record_number` SET TAGS ('dbx_business_glossary_term' = 'Approval Record Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `approval_record_number` SET TAGS ('dbx_value_regex' = '^PRA-[0-9]{4}-[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Action Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `approver_department` SET TAGS ('dbx_business_glossary_term' = 'Approver Department');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `approver_job_title` SET TAGS ('dbx_business_glossary_term' = 'Approver Job Title');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `approver_name` SET TAGS ('dbx_business_glossary_term' = 'Approver Full Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `approver_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `assigned_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Assignment Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `assigned_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Approver Comments');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `delegated_by_name` SET TAGS ('dbx_business_glossary_term' = 'Delegated By Full Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `delegated_by_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `delegation_reason` SET TAGS ('dbx_business_glossary_term' = 'Delegation Reason');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Due Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `escalation_level` SET TAGS ('dbx_business_glossary_term' = 'Escalation Level');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `escalation_level` SET TAGS ('dbx_value_regex' = '^[0-9]$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `is_delegated` SET TAGS ('dbx_business_glossary_term' = 'Is Delegated Approval Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `is_delegated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `is_overdue` SET TAGS ('dbx_business_glossary_term' = 'Is Overdue Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `is_overdue` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `notification_sent_flag` SET TAGS ('dbx_business_glossary_term' = 'Approval Notification Sent Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `notification_sent_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Notification Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `notification_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization (Purchasing Org) Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `rejection_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `release_code` SET TAGS ('dbx_business_glossary_term' = 'Release Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `release_strategy_code` SET TAGS ('dbx_business_glossary_term' = 'Release Strategy Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `requisition_line_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition (PR) Line Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `requisition_line_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `requisition_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition (PR) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `requisition_value` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition (PR) Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `requisition_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ARIBA|MANUAL');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `sox_control_reference` SET TAGS ('dbx_business_glossary_term' = 'Sarbanes-Oxley (SOX) Control Reference');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `spend_authorization_limit` SET TAGS ('dbx_business_glossary_term' = 'Spend Authorization Limit');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `spend_authorization_limit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Approval Record Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'pending|in_review|approved|rejected|returned|delegated|escalated|cancelled|expired');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_contact` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_contact` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_contact` ALTER COLUMN `supplier_contact_id` SET TAGS ('dbx_business_glossary_term' = 'supplier_contact Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_contact` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `incoterm_id` SET TAGS ('dbx_business_glossary_term' = 'Incoterm ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `applicable_transport_modes` SET TAGS ('dbx_business_glossary_term' = 'Applicable Transport Modes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `ariba_incoterm_code` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Incoterm Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `buyer_arranges_import_clearance` SET TAGS ('dbx_business_glossary_term' = 'Buyer Arranges Import Clearance');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `buyer_arranges_import_clearance` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `buyer_cost_responsibility_summary` SET TAGS ('dbx_business_glossary_term' = 'Buyer Cost Responsibility Summary');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `buyer_obligation_summary` SET TAGS ('dbx_business_glossary_term' = 'Buyer Obligation Summary');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `cost_transfer_point` SET TAGS ('dbx_business_glossary_term' = 'Cost Transfer Point');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `customs_duty_payer` SET TAGS ('dbx_business_glossary_term' = 'Customs Duty Payer');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `customs_duty_payer` SET TAGS ('dbx_value_regex' = 'seller|buyer|not_applicable');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `delivery_location_type` SET TAGS ('dbx_business_glossary_term' = 'Delivery Location Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `delivery_location_type` SET TAGS ('dbx_value_regex' = 'seller_premises|origin_port|destination_port|destination_place|carrier_named_place|border_crossing|any_mode_named_place');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `group` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Group');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `group` SET TAGS ('dbx_value_regex' = 'E|F|C|D');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `insurance_minimum_coverage` SET TAGS ('dbx_business_glossary_term' = 'Minimum Insurance Coverage Requirement');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `insurance_minimum_coverage` SET TAGS ('dbx_value_regex' = 'not_required|institute_cargo_clauses_c|institute_cargo_clauses_a|');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `inventory_ownership_transfer_point` SET TAGS ('dbx_business_glossary_term' = 'Inventory Ownership Transfer Point');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `is_recommended_for_manufacturing` SET TAGS ('dbx_business_glossary_term' = 'Recommended for Manufacturing Procurement');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `is_recommended_for_manufacturing` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `iso_country_scope` SET TAGS ('dbx_business_glossary_term' = 'ISO Country Scope');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Full Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `named_place_guidance` SET TAGS ('dbx_business_glossary_term' = 'Named Place Guidance');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `named_place_required` SET TAGS ('dbx_business_glossary_term' = 'Named Place Required');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `named_place_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `preferred_procurement_types` SET TAGS ('dbx_business_glossary_term' = 'Preferred Procurement Types');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `revenue_recognition_trigger` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Trigger Point');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `revenue_recognition_trigger` SET TAGS ('dbx_value_regex' = 'at_seller_premises|at_origin_port_loading|at_named_place_destination|at_destination_port_unloading|at_buyer_premises');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `risk_transfer_point` SET TAGS ('dbx_business_glossary_term' = 'Risk Transfer Point');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `sap_incoterm_code` SET TAGS ('dbx_business_glossary_term' = 'SAP Incoterm Code (INCO1)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `seller_arranges_export_clearance` SET TAGS ('dbx_business_glossary_term' = 'Seller Arranges Export Clearance');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `seller_arranges_export_clearance` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `seller_arranges_insurance` SET TAGS ('dbx_business_glossary_term' = 'Seller Arranges Insurance');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `seller_arranges_insurance` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `seller_arranges_main_carriage` SET TAGS ('dbx_business_glossary_term' = 'Seller Arranges Main Carriage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `seller_arranges_main_carriage` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `seller_cost_responsibility_summary` SET TAGS ('dbx_business_glossary_term' = 'Seller Cost Responsibility Summary');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `seller_obligation_summary` SET TAGS ('dbx_business_glossary_term' = 'Seller Obligation Summary');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `transport_mode_applicability` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode Applicability');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `transport_mode_applicability` SET TAGS ('dbx_value_regex' = 'any_mode|sea_and_inland_waterway_only');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `use_case_guidance` SET TAGS ('dbx_business_glossary_term' = 'Incoterm Use Case Guidance');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `version_year` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Version Year');
ALTER TABLE `manufacturing_ecm`.`procurement`.`incoterm` ALTER COLUMN `version_year` SET TAGS ('dbx_value_regex' = '1936|1953|1967|1976|1980|1990|2000|2010|2020');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `procurement_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `applicable_region` SET TAGS ('dbx_business_glossary_term' = 'Applicable Geographic Region');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `ariba_term_reference` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Payment Term Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `baseline_date_type` SET TAGS ('dbx_business_glossary_term' = 'Baseline Date Calculation Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `baseline_date_type` SET TAGS ('dbx_value_regex' = 'invoice_date|posting_date|goods_receipt_date|delivery_date|end_of_month|end_of_next_month|custom');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `discount_days_1` SET TAGS ('dbx_business_glossary_term' = 'Early Payment Discount Period Days (Tier 1)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `discount_days_1` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `discount_days_2` SET TAGS ('dbx_business_glossary_term' = 'Early Payment Discount Period Days (Tier 2)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `discount_days_2` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `discount_percent_1` SET TAGS ('dbx_business_glossary_term' = 'Early Payment Discount Percentage (Tier 1)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `discount_percent_1` SET TAGS ('dbx_value_regex' = '^[0-9]{1,2}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `discount_percent_2` SET TAGS ('dbx_business_glossary_term' = 'Early Payment Discount Percentage (Tier 2)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `discount_percent_2` SET TAGS ('dbx_value_regex' = '^[0-9]{1,2}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `dynamic_discounting_eligible` SET TAGS ('dbx_business_glossary_term' = 'Dynamic Discounting Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `dynamic_discounting_eligible` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `installment_count` SET TAGS ('dbx_business_glossary_term' = 'Installment Payment Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `installment_count` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `installment_days_1` SET TAGS ('dbx_business_glossary_term' = 'Installment Payment Due Days (Tranche 1)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `installment_days_1` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `installment_days_2` SET TAGS ('dbx_business_glossary_term' = 'Installment Payment Due Days (Tranche 2)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `installment_days_2` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `installment_days_3` SET TAGS ('dbx_business_glossary_term' = 'Installment Payment Due Days (Tranche 3)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `installment_days_3` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `installment_percent_1` SET TAGS ('dbx_business_glossary_term' = 'Installment Payment Percentage (Tranche 1)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `installment_percent_1` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `installment_percent_2` SET TAGS ('dbx_business_glossary_term' = 'Installment Payment Percentage (Tranche 2)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `installment_percent_2` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `installment_percent_3` SET TAGS ('dbx_business_glossary_term' = 'Installment Payment Percentage (Tranche 3)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `installment_percent_3` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `is_default_for_new_suppliers` SET TAGS ('dbx_business_glossary_term' = 'Default Payment Term for New Suppliers Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `is_default_for_new_suppliers` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `is_early_payment_discount_eligible` SET TAGS ('dbx_business_glossary_term' = 'Early Payment Discount Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `is_early_payment_discount_eligible` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Payment Term Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `late_payment_grace_days` SET TAGS ('dbx_business_glossary_term' = 'Late Payment Grace Period Days');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `late_payment_grace_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `late_payment_penalty_percent` SET TAGS ('dbx_business_glossary_term' = 'Late Payment Penalty Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `late_payment_penalty_percent` SET TAGS ('dbx_value_regex' = '^[0-9]{1,2}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `net_days` SET TAGS ('dbx_business_glossary_term' = 'Net Payment Days');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `net_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'bank_transfer|check|ach|wire_transfer|letter_of_credit|dynamic_discounting|supply_chain_finance|virtual_card|direct_debit');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `procurement_category_scope` SET TAGS ('dbx_business_glossary_term' = 'Procurement Category Scope');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `sap_zterm_code` SET TAGS ('dbx_business_glossary_term' = 'SAP Payment Term Key (ZTERM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `sap_zterm_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ARIBA|MANUAL|MIGRATION');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked|under_review');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `supply_chain_finance_eligible` SET TAGS ('dbx_business_glossary_term' = 'Supply Chain Finance Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `supply_chain_finance_eligible` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `term_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `term_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{1,30}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `term_name` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `term_type` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_payment_term` ALTER COLUMN `term_type` SET TAGS ('dbx_value_regex' = 'standard|early_payment_discount|installment|milestone|prepayment|consignment|cash_on_delivery|letter_of_credit');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `supplier_certificate_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Certificate ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `ariba_certificate_id` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Certificate ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `certificate_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Certificate Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `environmental_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Environmental Permit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `product_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Certification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `applicable_material_group` SET TAGS ('dbx_business_glossary_term' = 'Applicable Material Group');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `ce_notified_body_number` SET TAGS ('dbx_business_glossary_term' = 'CE Marking Notified Body Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `ce_notified_body_number` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `certificate_title` SET TAGS ('dbx_business_glossary_term' = 'Certificate Title');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `conflict_minerals_reporting_template_version` SET TAGS ('dbx_business_glossary_term' = 'Conflict Minerals Reporting Template (CMRT) Version');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `days_to_expiry` SET TAGS ('dbx_business_glossary_term' = 'Days to Certificate Expiry');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `document_reference` SET TAGS ('dbx_business_glossary_term' = 'Document Reference');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `document_version` SET TAGS ('dbx_business_glossary_term' = 'Document Version');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Mandatory Certificate Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `is_self_declared` SET TAGS ('dbx_business_glossary_term' = 'Self-Declaration Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `is_self_declared` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `issuing_body_accreditation_number` SET TAGS ('dbx_business_glossary_term' = 'Issuing Body Accreditation Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `last_surveillance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Surveillance Audit Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `last_surveillance_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `next_surveillance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Surveillance Audit Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `next_surveillance_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Certificate Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `reach_svhc_declaration_date` SET TAGS ('dbx_business_glossary_term' = 'REACH Substances of Very High Concern (SVHC) Declaration Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `reach_svhc_declaration_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `renewal_reminder_sent_flag` SET TAGS ('dbx_business_glossary_term' = 'Renewal Reminder Sent Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `renewal_reminder_sent_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `rohs_exemption_codes` SET TAGS ('dbx_business_glossary_term' = 'RoHS Exemption Codes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `scope` SET TAGS ('dbx_business_glossary_term' = 'Certificate Scope');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_ARIBA|SAP_S4HANA|TEAMCENTER|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `standard_version` SET TAGS ('dbx_business_glossary_term' = 'Standard Version');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Certificate Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|expired|suspended|withdrawn|pending_renewal|under_review|revoked');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `supplier_site_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Site Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `ul_file_number` SET TAGS ('dbx_business_glossary_term' = 'UL File Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Verification Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `verification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ALTER COLUMN `verified_by` SET TAGS ('dbx_business_glossary_term' = 'Verified By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `purchase_order_amendment_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Amendment ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `procurement_po_line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Po Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Amendment Requester Employee ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `amendment_number` SET TAGS ('dbx_business_glossary_term' = 'Amendment Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `amendment_number` SET TAGS ('dbx_value_regex' = '^AMD-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `amendment_type` SET TAGS ('dbx_business_glossary_term' = 'Amendment Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `amendment_type` SET TAGS ('dbx_value_regex' = 'quantity_change|price_adjustment|delivery_date_revision|scope_change|payment_terms_change|incoterms_change|supplier_change|cancellation|line_item_addition|line_item_deletion|currency_change|other');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `amendment_version` SET TAGS ('dbx_business_glossary_term' = 'Amendment Version Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `amendment_version` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|approved|rejected|escalated');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `change_level` SET TAGS ('dbx_business_glossary_term' = 'Change Level');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `change_level` SET TAGS ('dbx_value_regex' = 'header|line_item');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `changed_field_description` SET TAGS ('dbx_business_glossary_term' = 'Changed Field Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `changed_field_name` SET TAGS ('dbx_business_glossary_term' = 'Changed Field Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Amendment Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `ecn_reference` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Reference');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Amendment Effective Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `original_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Original Scheduled Delivery Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `original_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `original_net_price` SET TAGS ('dbx_business_glossary_term' = 'Original Net Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `original_net_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `original_po_value` SET TAGS ('dbx_business_glossary_term' = 'Original Purchase Order (PO) Net Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `original_po_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `original_quantity` SET TAGS ('dbx_business_glossary_term' = 'Original Ordered Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `original_value` SET TAGS ('dbx_business_glossary_term' = 'Original Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `po_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `price_unit` SET TAGS ('dbx_business_glossary_term' = 'Price Unit');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `quantity_uom` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure (UOM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `reason_code` SET TAGS ('dbx_business_glossary_term' = 'Amendment Reason Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `reason_code` SET TAGS ('dbx_value_regex' = 'supplier_request|engineering_change|demand_change|price_negotiation|delivery_constraint|quality_issue|budget_adjustment|contract_alignment|regulatory_compliance|force_majeure|error_correction|other');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `reason_text` SET TAGS ('dbx_business_glossary_term' = 'Amendment Reason Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `requester_department` SET TAGS ('dbx_business_glossary_term' = 'Requester Department');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `requester_name` SET TAGS ('dbx_business_glossary_term' = 'Amendment Requester Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `revised_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Revised Scheduled Delivery Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `revised_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `revised_net_price` SET TAGS ('dbx_business_glossary_term' = 'Revised Net Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `revised_net_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `revised_po_value` SET TAGS ('dbx_business_glossary_term' = 'Revised Purchase Order (PO) Net Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `revised_po_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `revised_quantity` SET TAGS ('dbx_business_glossary_term' = 'Revised Ordered Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `revised_value` SET TAGS ('dbx_business_glossary_term' = 'Revised Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ARIBA|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Amendment Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|approved|rejected|sent_to_supplier|supplier_acknowledged|supplier_rejected|cancelled|superseded');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `supplier_acknowledgment_date` SET TAGS ('dbx_business_glossary_term' = 'Supplier Acknowledgment Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `supplier_acknowledgment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `supplier_acknowledgment_status` SET TAGS ('dbx_business_glossary_term' = 'Supplier Acknowledgment Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `supplier_acknowledgment_status` SET TAGS ('dbx_value_regex' = 'not_sent|pending|acknowledged|rejected|partially_accepted|overdue');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `supplier_notification_date` SET TAGS ('dbx_business_glossary_term' = 'Supplier Notification Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `supplier_notification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `supplier_rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Supplier Rejection Reason');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `value_change_amount` SET TAGS ('dbx_business_glossary_term' = 'Value Change Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ALTER COLUMN `value_change_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` SET TAGS ('dbx_subdomain' = 'strategic_sourcing');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `mro_catalog_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance, Repair, and Operations (MRO) Catalog ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Catalog Item ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `procurement_spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `spare_part_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `spare_parts_catalog_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Catalog Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `abc_classification` SET TAGS ('dbx_business_glossary_term' = 'ABC Classification');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `abc_classification` SET TAGS ('dbx_value_regex' = 'A|B|C');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `catalog_item_number` SET TAGS ('dbx_business_glossary_term' = 'MRO Catalog Item Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `catalog_item_number` SET TAGS ('dbx_value_regex' = '^MRO-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `criticality_classification` SET TAGS ('dbx_business_glossary_term' = 'MRO Item Criticality Classification');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `criticality_classification` SET TAGS ('dbx_value_regex' = 'critical|important|standard|non_critical');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `equipment_compatibility` SET TAGS ('dbx_business_glossary_term' = 'Equipment Compatibility');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `item_category` SET TAGS ('dbx_business_glossary_term' = 'MRO Item Category');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `item_category` SET TAGS ('dbx_value_regex' = 'spare_part|consumable|tooling|facility_supply|safety_item|lubricant|electrical|instrumentation|hydraulic|pneumatic|fastener|chemical|ppe|other');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `item_description` SET TAGS ('dbx_business_glossary_term' = 'MRO Item Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `item_name` SET TAGS ('dbx_business_glossary_term' = 'MRO Item Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_business_glossary_term' = 'Last Reviewed Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `manufacturer_name` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `manufacturer_part_number` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Part Number (MPN)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `price_valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Price Valid From Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `price_valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `price_valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Price Valid To Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `price_valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'Registration, Evaluation, Authorization and Restriction of Chemicals (REACH) Compliant');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `reorder_point` SET TAGS ('dbx_business_glossary_term' = 'Reorder Point');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Compliant');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `safety_stock_quantity` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `sap_material_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Material Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `spend_category_code` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `standard_price` SET TAGS ('dbx_business_glossary_term' = 'Standard Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `standard_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'MRO Catalog Item Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_approval|obsolete|under_review|blocked');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `supplier_part_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Part Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|PK|BX|KG|LT|MT|M|M2|M3|SET|ROL|PAL|DZ|HR|PR');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `unspsc_code` SET TAGS ('dbx_business_glossary_term' = 'United Nations Standard Products and Services Code (UNSPSC)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ALTER COLUMN `unspsc_code` SET TAGS ('dbx_value_regex' = '^[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` SET TAGS ('dbx_subdomain' = 'performance_analytics');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` SET TAGS ('dbx_original_name' = 'procurement_policy');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `procurement_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Policy ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `compliance_policy_id` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Policy ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `applicability_scope` SET TAGS ('dbx_business_glossary_term' = 'Policy Applicability Scope');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `applicability_scope` SET TAGS ('dbx_value_regex' = 'global|regional|country|company_code|purchasing_org|plant|cost_center|business_unit');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `applicable_company_code` SET TAGS ('dbx_business_glossary_term' = 'Applicable Company Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `applicable_country_code` SET TAGS ('dbx_business_glossary_term' = 'Applicable Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `applicable_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `applicable_purchasing_org` SET TAGS ('dbx_business_glossary_term' = 'Applicable Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `applicable_region_code` SET TAGS ('dbx_business_glossary_term' = 'Applicable Region Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `approval_level` SET TAGS ('dbx_business_glossary_term' = 'Policy Approval Level');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `approval_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3|level_4|board');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `approval_role` SET TAGS ('dbx_business_glossary_term' = 'Required Approval Role');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Policy Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Policy Approval Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Procurement Policy Category');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'direct_material|indirect_material|services|capital_expenditure|mro|it_and_software|logistics|all');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `conflict_minerals_applicable` SET TAGS ('dbx_business_glossary_term' = 'Conflict Minerals Applicability Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `conflict_minerals_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Policy Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Policy Effective End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Policy Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `enforcement_mechanism` SET TAGS ('dbx_business_glossary_term' = 'Policy Enforcement Mechanism');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `enforcement_mechanism` SET TAGS ('dbx_value_regex' = 'hard_block|soft_warning|approval_required|audit_only|system_enforced|manual_review');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `exception_allowed` SET TAGS ('dbx_business_glossary_term' = 'Policy Exception Allowed Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `exception_allowed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `exception_approval_role` SET TAGS ('dbx_business_glossary_term' = 'Exception Approval Role');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Policy Last Review Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `last_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `max_spend_threshold` SET TAGS ('dbx_business_glossary_term' = 'Maximum Spend Threshold Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `max_spend_threshold` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `min_competitive_bids_required` SET TAGS ('dbx_business_glossary_term' = 'Minimum Competitive Bids Required');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `min_competitive_bids_required` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `min_spend_threshold` SET TAGS ('dbx_business_glossary_term' = 'Minimum Spend Threshold Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `min_spend_threshold` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Policy Next Scheduled Review Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Procurement Policy Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^POL-[A-Z]{2,6}-[0-9]{4}-[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `owner_department` SET TAGS ('dbx_business_glossary_term' = 'Policy Owner Department');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `owner_name` SET TAGS ('dbx_business_glossary_term' = 'Policy Owner Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `preferred_supplier_enforcement` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier Enforcement Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `preferred_supplier_enforcement` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `reach_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Compliance Required Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `reach_compliance_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `rohs_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Compliance Required Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `rohs_compliance_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `single_source_justification_required` SET TAGS ('dbx_business_glossary_term' = 'Single-Source Justification Required Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `single_source_justification_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `sourcing_event_type_required` SET TAGS ('dbx_business_glossary_term' = 'Required Sourcing Event Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `sourcing_event_type_required` SET TAGS ('dbx_value_regex' = 'rfq|rfp|reverse_auction|sole_source|framework_agreement|none');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `spend_threshold_currency` SET TAGS ('dbx_business_glossary_term' = 'Spend Threshold Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `spend_threshold_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Policy Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|under_review|approved|active|suspended|superseded|retired');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `supplier_diversity_required` SET TAGS ('dbx_business_glossary_term' = 'Supplier Diversity Requirement Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `supplier_diversity_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `sustainability_mandate` SET TAGS ('dbx_business_glossary_term' = 'Sustainability Procurement Mandate Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `sustainability_mandate` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Policy Title');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Policy Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'spend_authorization|sourcing_event_requirement|preferred_supplier_enforcement|single_source_justification|sustainability_mandate|supplier_diversity|conflict_of_interest|payment_terms|contract_compliance|data_privacy|ethics_and_conduct|import_expor...');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Policy Version Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` SET TAGS ('dbx_association_edges' = 'research.rd_project,procurement.supplier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ALTER COLUMN `supplier_collaboration_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Collaboration ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Collaboration - Supplier Id');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Collaboration - Rd Project Id');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ALTER COLUMN `collaboration_type` SET TAGS ('dbx_business_glossary_term' = 'Collaboration Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ALTER COLUMN `contribution_area` SET TAGS ('dbx_business_glossary_term' = 'Technical Contribution Area');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Record Created Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Collaboration End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ALTER COLUMN `funding_amount` SET TAGS ('dbx_business_glossary_term' = 'Collaboration Funding Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ALTER COLUMN `funding_currency` SET TAGS ('dbx_business_glossary_term' = 'Funding Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ALTER COLUMN `ip_ownership_terms` SET TAGS ('dbx_business_glossary_term' = 'IP Ownership Terms');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ALTER COLUMN `ip_ownership_terms` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ALTER COLUMN `modified_date` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ALTER COLUMN `nda_reference` SET TAGS ('dbx_business_glossary_term' = 'NDA Reference Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ALTER COLUMN `nda_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Collaboration Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Collaboration Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` SET TAGS ('dbx_association_edges' = 'procurement.supplier,service.service_contract');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ALTER COLUMN `supplier_service_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Service Contract ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Service Contract - Service Contract Id');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Service Contract - Supplier Id');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ALTER COLUMN `service_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ALTER COLUMN `annual_value` SET TAGS ('dbx_business_glossary_term' = 'Supplier Annual Contract Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ALTER COLUMN `coverage_scope` SET TAGS ('dbx_business_glossary_term' = 'Supplier Coverage Scope');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Supplier Engagement End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ALTER COLUMN `primary_supplier_flag` SET TAGS ('dbx_business_glossary_term' = 'Primary Supplier Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ALTER COLUMN `response_time_sla` SET TAGS ('dbx_business_glossary_term' = 'Supplier Response Time SLA');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ALTER COLUMN `service_level` SET TAGS ('dbx_business_glossary_term' = 'Supplier Service Level');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Supplier Engagement Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Supplier Engagement Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` SET TAGS ('dbx_association_edges' = 'procurement.supplier,hse.regulatory_obligation');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ALTER COLUMN `supplier_compliance_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Compliance Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Compliance - Supplier Id');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ALTER COLUMN `regulatory_obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Compliance - Regulatory Obligation Id');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Contact Employee');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ALTER COLUMN `audit_score` SET TAGS ('dbx_business_glossary_term' = 'Compliance Audit Score');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ALTER COLUMN `certification_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Supplier-Specific Compliance Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ALTER COLUMN `evidence_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Evidence Document Reference');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Compliance Expiry Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Update Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ALTER COLUMN `last_verification_date` SET TAGS ('dbx_business_glossary_term' = 'Last Verification Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ALTER COLUMN `next_verification_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Verification Due Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ALTER COLUMN `non_conformance_count` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Compliance Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` SET TAGS ('dbx_association_edges' = 'procurement.supplier,compliance.product_certification');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` ALTER COLUMN `supplier_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Certification - Supplier Certification Id');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Certification - Supplier Id');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` ALTER COLUMN `product_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Certification - Product Certification Id');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` ALTER COLUMN `audit_date` SET TAGS ('dbx_business_glossary_term' = 'Audit Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` ALTER COLUMN `certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Certificate Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` ALTER COLUMN `certification_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` ALTER COLUMN `certification_scope` SET TAGS ('dbx_business_glossary_term' = 'Certification Scope');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` ALTER COLUMN `issuing_body` SET TAGS ('dbx_business_glossary_term' = 'Issuing Body');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` ALTER COLUMN `next_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Next Audit Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` ALTER COLUMN `renewal_status` SET TAGS ('dbx_business_glossary_term' = 'Renewal Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` SET TAGS ('dbx_association_edges' = 'quality.control_plan,procurement.supplier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ALTER COLUMN `supplier_control_plan_approval_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Control Plan Approval ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Control Plan Approval - Control Plan Id');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Control Plan Approval - Supplier Id');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ALTER COLUMN `audit_frequency` SET TAGS ('dbx_business_glossary_term' = 'Audit Frequency');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ALTER COLUMN `compliance_level` SET TAGS ('dbx_business_glossary_term' = 'Compliance Level');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Last Audit Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ALTER COLUMN `next_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Next Audit Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Revision Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` SET TAGS ('dbx_association_edges' = 'procurement.purchase_order,compliance.compliance_obligation');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` ALTER COLUMN `po_compliance_verification_id` SET TAGS ('dbx_business_glossary_term' = 'PO Compliance Verification ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` ALTER COLUMN `compliance_obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Obligation ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` ALTER COLUMN `obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Po Compliance Verification - Compliance Obligation Id');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Po Compliance Verification - Purchase Order Id');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` ALTER COLUMN `compliance_notes` SET TAGS ('dbx_business_glossary_term' = 'Compliance Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` ALTER COLUMN `evidence_document` SET TAGS ('dbx_business_glossary_term' = 'Evidence Document');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` ALTER COLUMN `obligation_status` SET TAGS ('dbx_business_glossary_term' = 'Obligation Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` ALTER COLUMN `responsible_buyer` SET TAGS ('dbx_business_glossary_term' = 'Responsible Buyer');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Verification Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` ALTER COLUMN `verification_method` SET TAGS ('dbx_business_glossary_term' = 'Verification Method');
