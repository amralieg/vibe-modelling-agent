-- Schema for Domain: contract | Business: Shipping_Ports | Version: v2_ecm
-- Generated on: 2026-07-13 08:38:26

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`contract` COMMENT 'SSOT for all commercial agreements between the port and its stakeholders including shipping line service agreements, stevedoring contracts, concession agreements, SLA definitions, and PIL (Port Infrastructure Levy) arrangements. Tracks contract lifecycle from negotiation to expiry.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` (
    `agreement_id` BIGINT COMMENT 'Unique identifier for the commercial agreement. Primary key.',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Concession agreements may restrict cargo types (e.g., bulk-only terminals, container-only berths, hazmat exclusions). Cargo eligibility is fundamental to port concession terms and terminal specializat',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Terminal operating agreements and concession agreements are budgeted and tracked against specific cost centres for P&L accountability. Required for monthly variance reporting of agreement revenue vs c',
    `customs_broker_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_broker. Business justification: Shipping line agreements designate authorized customs brokers for clearance services, defining broker responsibilities, liability caps, and service standards. Essential for broker authorization manage',
    `equipment_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.equipment_type. Business justification: Infrastructure concession agreements specify licensed equipment (licensed_equipment field denormalizes equipment_type master data). Critical for asset management, maintenance planning, and ensuring co',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Shipping lines are primary customers for port service agreements. Master data provides operational attributes (alliance membership, fleet size, service type) essential for service planning and commerc',
    `participant_account_id` BIGINT COMMENT 'Foreign key reference to the contracting party (shipping line, stevedoring company, terminal operator, concessionaire, freight forwarder, marine service provider) from the port community participant master.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Concession and service agreements specify licensed terminals/berths for service delivery. Terminal assignment is fundamental to port service contracts and operational planning. New attribute needed as',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Concession areas and terminal operations are organized as profit centres for segment reporting. Required for profitability analysis by concession/agreement and management reporting of terminal/berth s',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Contract execution requires tracking which port authority employee signed the agreement for legal accountability and audit compliance. Port authority signatory is an internal employee, not external pa',
    `sla_profile_id` BIGINT COMMENT 'Foreign key reference to the SLA profile defining performance commitments, KPIs, and penalty/bonus structures for this agreement.',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: Port service agreements often depend on underlying procurement contracts (equipment supply, maintenance services) that enable service delivery. Business process: contract dependency tracking, ensuring',
    `trade_restriction_id` BIGINT COMMENT 'Foreign key linking to compliance.trade_restriction. Business justification: Concession and terminal operating agreements must reference applicable trade restrictions (sanctions, embargoes) governing permitted cargo types and trading partners. Critical for contract compliance ',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to procurement.vendor. Business justification: Port terminal operating agreements and service contracts are frequently held by entities who are also procurement vendors. Enables unified vendor performance management, consolidated credit risk asses',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Service agreements often restrict eligible vessel types (e.g., container-only terminals, tanker berths). Vessel type eligibility is core to maritime service contract terms and vessel acceptance decisi',
    `agreement_number` STRING COMMENT 'Externally-known business identifier for the agreement, typically generated by SAP S/4HANA or CRM system. Used in all stakeholder communications and invoicing.. Valid values are `^[A-Z0-9-]{6,20}$`',
    `agreement_status` STRING COMMENT 'Current lifecycle state of the agreement. Draft: initial preparation; Under Negotiation: terms being discussed; Active: in force and binding; Suspended: temporarily inactive; Expired: reached end date; Terminated: ended before expiry.. Valid values are `draft|under_negotiation|active|suspended|expired|terminated`',
    `agreement_type` STRING COMMENT 'Classification of the commercial agreement. Service agreements cover shipping line commitments; concession agreements grant terminal operating rights; stevedoring contracts define cargo handling services; PIL (Port Infrastructure Levy) arrangements establish infrastructure fee structures; lease agreements cover facility/equipment rental; marine services agreements cover pilotage, towage, and mooring services.. Valid values are `service_agreement|concession_agreement|stevedoring_contract|pil_arrangement|lease_agreement|marine_services_agreement`',
    `alliance_membership` STRING COMMENT 'For shipping-line-type agreements: name of the global shipping alliance the line belongs to (e.g., 2M Alliance, THE Alliance, Ocean Alliance). Affects service string coordination and slot allocation.',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the agreement automatically renews for an additional term unless either party provides termination notice within the specified notice period.',
    `concession_term_years` STRING COMMENT 'For concession-type agreements: duration of the concession grant in years. Typical maritime concessions range from 10 to 50 years.',
    `contract_value` DECIMAL(18,2) COMMENT 'Total monetary value of the agreement over its full term. For concession agreements, represents minimum annual guarantee revenue (MAGR) multiplied by term years. For service agreements, represents committed volume multiplied by tariff rates.',
    `created_by_user` STRING COMMENT 'Username or employee identifier of the system user who created this agreement record. Audit trail for accountability.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this agreement record was first created in the system. Audit trail for data lineage and compliance.',
    `credit_limit_amount` DECIMAL(18,2) COMMENT 'Maximum outstanding receivables balance allowed for the contracting party before services are suspended. Managed in conjunction with credit assessment records.',
    `crm_opportunity_reference` STRING COMMENT 'Reference to the originating sales opportunity in Microsoft Dynamics 365 CRM that led to this agreement. Enables tracking from lead to contract.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for contract value and financial terms (e.g., USD, EUR, SGD, AED).. Valid values are `^[A-Z]{3}$`',
    `document_reference` STRING COMMENT 'File path or document management system reference to the signed contract PDF or scanned original. Enables retrieval of the full legal document.',
    `edi_required_flag` BOOLEAN COMMENT 'For shipping-line-type agreements: indicates whether the shipping line is required to exchange cargo manifests, BAPLIE stowage plans, and COPARN pre-announcements via EDI (Electronic Data Interchange) with the port community system.',
    `effective_date` DATE COMMENT 'Date when the agreement becomes legally binding and enforceable. Corresponds to contract commencement date.',
    `expiry_date` DATE COMMENT 'Date when the agreement terminates unless renewed. Nullable for open-ended agreements or those with auto-renewal clauses.',
    `governing_law` STRING COMMENT 'Legal jurisdiction whose laws govern the interpretation and enforcement of the agreement (e.g., Singapore Law, English Law, UAE Federal Law).',
    `insurance_coverage_amount` DECIMAL(18,2) COMMENT 'Minimum insurance coverage amount required from the contracting party. Typical maritime agreements require USD 10M to USD 100M in liability coverage.',
    `insurance_required_flag` BOOLEAN COMMENT 'Indicates whether the contracting party is required to maintain Protection and Indemnity (P&I) insurance or general liability insurance as a condition of the agreement.',
    `investment_commitment_amount` DECIMAL(18,2) COMMENT 'For concession-type agreements: total capital expenditure (CAPEX) the concessionaire commits to invest in port infrastructure and equipment over the concession term.',
    `jurisdiction` STRING COMMENT 'Court or arbitration body with authority to resolve disputes arising from the agreement (e.g., Singapore International Arbitration Centre, London Maritime Arbitrators Association).',
    `magr_amount` DECIMAL(18,2) COMMENT 'For concession-type agreements: minimum annual revenue the concessionaire guarantees to pay the port authority regardless of actual throughput. Key financial metric for concession valuation.',
    `modified_by_user` STRING COMMENT 'Username or employee identifier of the system user who last modified this agreement record. Audit trail for accountability.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this agreement record was last updated. Audit trail for change tracking and compliance.',
    `notes` STRING COMMENT 'Free-text field for additional context, special conditions, or operational notes about the agreement that do not fit structured fields.',
    `payment_terms_days` STRING COMMENT 'Number of days from invoice date within which the contracting party must settle payment. Common maritime terms are Net 30, Net 45, or Net 60 days.',
    `productivity_target_moves_per_hour` STRING COMMENT 'For stevedoring-type agreements: contractual minimum container moves per hour that the stevedoring company must achieve. Typical targets range from 25 to 40 moves/hour for STS cranes.',
    `renewal_notice_period_days` STRING COMMENT 'Number of days before expiry date by which either party must provide written notice to prevent auto-renewal. Typically 90, 180, or 365 days for maritime agreements.',
    `revenue_share_percentage` DECIMAL(18,2) COMMENT 'For concession-type agreements: percentage of gross revenue above MAGR threshold that the concessionaire pays to the port authority. Typically ranges from 10% to 40%.',
    `sap_contract_number` STRING COMMENT 'Source system contract identifier from SAP S/4HANA ERP system. Used for financial integration and billing run generation.. Valid values are `^[0-9]{10}$`',
    `security_deposit_amount` DECIMAL(18,2) COMMENT 'Refundable deposit held by the port authority as security against non-payment or breach of contract terms. Typically equivalent to 1-3 months of estimated charges.',
    `service_strings` STRING COMMENT 'For shipping-line-type agreements: comma-separated list of vessel service routes the shipping line operates through this port (e.g., Asia-Europe Loop 1, Transpacific Express, Middle East Shuttle).',
    `signature_date` DATE COMMENT 'Date when the agreement was formally executed by both parties. May differ from effective_date if the agreement has a future commencement.',
    `signed_by_counterparty` STRING COMMENT 'Name and title of the counterparty signatory who executed the agreement on behalf of the contracting organization.',
    `termination_date` DATE COMMENT 'Actual date when the agreement was terminated before its natural expiry. Populated only for agreements with status = terminated. Null for active, expired, or suspended agreements.',
    `termination_reason` STRING COMMENT 'Business reason for early termination of the agreement (e.g., breach of contract, mutual consent, force majeure, insolvency, regulatory change). Populated only when termination_date is not null.',
    CONSTRAINT pk_agreement PRIMARY KEY(`agreement_id`)
) COMMENT 'Master record for all commercial agreements between the port authority and its stakeholders (shipping lines, stevedoring companies, terminal operators, concessionaires, PIL holders, freight forwarders, marine service providers). Serves as the single authoritative entity for every contract type including service agreements, concessions, stevedoring contracts, PIL arrangements, lease agreements, and marine services agreements. Captures full contract lifecycle from negotiation through execution to expiry/termination, including agreement type, contracting parties, effective and expiry dates, contract value, currency, governing law, jurisdiction, renewal terms (auto-renewal flag, notice period), contract status (draft, under_negotiation, active, suspended, expired, terminated), and originating system reference (SAP S/4HANA contract number, CRM opportunity ID). For concession-type agreements: concession area, term, MAGR, revenue share percentage, investment commitments. For stevedoring-type: licensed berths, equipment, productivity targets. For shipping-line-type: alliance membership, service strings, EDI requirements.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` (
    `agreement_version_id` BIGINT COMMENT 'Unique identifier for each version of a commercial agreement. Primary key for the agreement version entity.',
    `agreement_id` BIGINT COMMENT 'Reference to the parent commercial agreement that this version belongs to. Links to the master agreement record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Contract amendment audit trail requires tracking which employee requested each version change for governance and accountability in contract lifecycle management.',
    `superseded_version_agreement_version_id` BIGINT COMMENT 'Reference to the previous agreement version that this version replaces. Nullable for the initial version of an agreement.',
    `approval_date` DATE COMMENT 'Date when this version received formal approval from the authorized signatory. Precedes the version effective date.',
    `approved_by` STRING COMMENT 'Name or identifier of the authorized signatory or approving authority who approved this version for execution. May be port CEO, commercial director, or board representative.',
    `change_reason` STRING COMMENT 'Business justification or trigger for creating this version. May reference regulatory changes, commercial renegotiation, operational requirements, or dispute resolution.',
    `change_summary` STRING COMMENT 'Brief executive summary of the key changes introduced in this version compared to the previous version. Provides quick reference for stakeholders.',
    `change_type` STRING COMMENT 'Classification of the type of change that created this version. Amendment modifies existing terms, addendum adds new terms, renewal extends duration, novation replaces parties, restatement consolidates prior changes.. Valid values are `amendment|addendum|renewal|novation|restatement|termination`',
    `counterparty_acceptance_date` DATE COMMENT 'Date when the counterparty formally accepted or signed this version. Nullable if acceptance not required or not yet received.',
    `counterparty_acceptance_required` BOOLEAN COMMENT 'Indicates whether this version requires explicit acceptance or signature from the counterparty (shipping line, stevedore, concessionaire). True if bilateral approval needed.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this agreement version record was first created in the contract management system. Audit trail field.',
    `document_format` STRING COMMENT 'Format of the stored agreement version document. Indicates whether the record is digital, scanned, or paper-based.. Valid values are `pdf|docx|scanned_image|electronic_signature|paper_original`',
    `document_reference` STRING COMMENT 'File path, document management system identifier, or URI pointing to the signed version document (PDF, scanned contract, or electronic signature record).',
    `financial_impact_flag` BOOLEAN COMMENT 'Indicates whether this version introduces changes to pricing, tariffs, payment terms, or other financial obligations. True if financial terms changed.',
    `financial_impact_summary` STRING COMMENT 'Description of the financial changes introduced in this version, including revenue impact, cost changes, or payment term modifications. Confidential business information.',
    `legal_review_date` DATE COMMENT 'Date when legal review of this version was completed. Nullable if no legal review was required.',
    `legal_review_required` BOOLEAN COMMENT 'Flag indicating whether this version required formal legal counsel review before approval. True for material changes, false for administrative updates.',
    `legal_reviewer` STRING COMMENT 'Name or identifier of the legal counsel or law firm that reviewed this version. Nullable if no legal review was required.',
    `modified_by` STRING COMMENT 'User identifier or system account that last modified this agreement version record. Audit trail field for accountability.',
    `modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this agreement version record was last updated. Audit trail field for change tracking.',
    `notification_sent_date` DATE COMMENT 'Date when stakeholder notification was distributed to affected parties. Nullable if notification not yet sent.',
    `notification_sent_flag` BOOLEAN COMMENT 'Indicates whether stakeholder notification was sent to all affected parties about this version change. True if notification completed.',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether this version was created to address regulatory changes, compliance requirements, or industry standard updates. True if driven by regulatory mandate.',
    `regulatory_reference` STRING COMMENT 'Citation of the specific regulation, IMO convention, ISPS code requirement, or industry standard that triggered this version change. Nullable if not regulatory-driven.',
    `signed_date` DATE COMMENT 'Date when all parties executed this version of the agreement. Represents the legal commitment date.',
    `sla_changes_flag` BOOLEAN COMMENT 'Indicates whether this version modifies service level commitments, performance targets, or operational obligations. True if SLA terms changed.',
    `sla_changes_summary` STRING COMMENT 'Description of the service level changes introduced in this version, including modified KPIs, performance targets, or operational commitments.',
    `version_effective_date` DATE COMMENT 'Date when this version of the agreement becomes legally binding and operationally effective. Marks the start of this versions validity period.',
    `version_expiry_date` DATE COMMENT 'Date when this version of the agreement ceases to be valid, either due to supersession by a new version or contract termination. Nullable for open-ended versions.',
    `version_notes` STRING COMMENT 'Additional free-text notes, comments, or context about this version. May include negotiation history, special conditions, or implementation instructions.',
    `version_number` STRING COMMENT 'Sequential version identifier for the agreement (e.g., 1.0, 1.1, 2.0). Increments with each amendment, addendum, or renewal.. Valid values are `^[0-9]+.[0-9]+$|^[0-9]+$`',
    `version_status` STRING COMMENT 'Current lifecycle status of this agreement version. Tracks progression from draft through approval to active use and eventual supersession.. Valid values are `draft|pending_approval|approved|active|superseded|terminated`',
    `created_by` STRING COMMENT 'User identifier or system account that created this agreement version record. Audit trail field for accountability.',
    CONSTRAINT pk_agreement_version PRIMARY KEY(`agreement_version_id`)
) COMMENT 'Tracks the full version history of each commercial agreement, capturing every amendment, addendum, or renegotiation as a distinct versioned record. Stores version number, version effective date, version expiry date, change summary, change reason, change type (amendment, addendum, renewal, novation), approved by, approval date, and the document reference for the signed version. Enables full audit trail of contract evolution over its lifecycle.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` (
    `agreement_party_id` BIGINT COMMENT 'Unique identifier for the agreement party association record. Primary key for this entity.',
    `access_credential_id` BIGINT COMMENT 'Foreign key linking to security.access_credential. Business justification: Agreement parties (shipping lines, terminal operators, service providers) receive facility access credentials upon contract execution. Credential lifecycle management requires linking to agreement par',
    `agreement_id` BIGINT COMMENT 'Reference to the commercial agreement to which this party is bound. Links to the parent contract or service agreement.',
    `participant_account_id` BIGINT COMMENT 'Reference to the port community participant account representing the party. Links to the master party entity in the customer domain.',
    `amendment_count` STRING COMMENT 'The number of formal amendments that have modified this partys terms, obligations, or status within the agreement. Incremented with each executed amendment affecting this party.',
    `authorized_representative_email` STRING COMMENT 'The email address of the authorized representative for operational communications and contract administration.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `authorized_representative_name` STRING COMMENT 'The name of the individual authorized to act on behalf of this party for day-to-day contract administration and operational matters. May differ from the signatory.',
    `authorized_representative_phone` STRING COMMENT 'The telephone contact number for the authorized representative. Used for operational escalations and urgent contract matters.',
    `compliance_certifications_required` STRING COMMENT 'Comma-separated list of compliance certifications this party must maintain as a condition of the agreement. Examples: ISO 9001, ISO 14001, ISO 45001, ISPS certification, customs AEO status.',
    `contact_phone` STRING COMMENT 'The primary telephone contact number for this party for operational and contractual matters. Includes country code and extension if applicable.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this agreement party record was first created in the system. Immutable audit field.',
    `credit_limit_amount` DECIMAL(18,2) COMMENT 'The maximum credit exposure allowed for this party under the agreement. Applicable to counterparties receiving services on credit terms. Expressed in the agreement currency.',
    `credit_limit_currency` STRING COMMENT 'The three-letter ISO 4217 currency code for the credit limit amount. Examples: USD, EUR, GBP, SGD.. Valid values are `^[A-Z]{3}$`',
    `dispute_resolution_method` STRING COMMENT 'The agreed method for resolving disputes involving this party. Negotiation is direct discussion, mediation uses neutral facilitator, arbitration is binding third-party decision, litigation is court proceedings, expert determination uses technical specialist.. Valid values are `negotiation|mediation|arbitration|litigation|expert_determination`',
    `governing_law_jurisdiction` STRING COMMENT 'The legal jurisdiction whose laws govern this partys obligations under the agreement. Examples: Singapore, England and Wales, New York, Hong Kong.',
    `guarantee_amount` DECIMAL(18,2) COMMENT 'The financial guarantee or security amount provided by this party to secure performance. Applicable primarily to guarantor role. Expressed in the agreement currency.',
    `guarantee_currency` STRING COMMENT 'The three-letter ISO 4217 currency code for the guarantee amount. Examples: USD, EUR, GBP, SGD.. Valid values are `^[A-Z]{3}$`',
    `guarantee_expiry_date` DATE COMMENT 'The date on which the financial guarantee expires and is no longer enforceable. Typically extends beyond the agreement end date to cover tail liabilities.',
    `guarantee_instrument_type` STRING COMMENT 'The type of financial instrument used to secure the guarantee. Bank guarantee is issued by financial institution, letter of credit is trade finance instrument, performance bond is surety bond, parent company guarantee is corporate backing, cash deposit is held funds, insurance policy is underwritten coverage.. Valid values are `bank_guarantee|letter_of_credit|performance_bond|parent_company_guarantee|cash_deposit|insurance_policy`',
    `indemnity_scope` STRING COMMENT 'Textual description of the scope of indemnity obligations this party has agreed to. Defines what losses, damages, or claims this party will cover for other parties.',
    `insurance_coverage_currency` STRING COMMENT 'The three-letter ISO 4217 currency code for the insurance minimum coverage amount. Examples: USD, EUR, GBP, SGD.. Valid values are `^[A-Z]{3}$`',
    `insurance_coverage_types` STRING COMMENT 'Comma-separated list of required insurance coverage types. Examples: public liability, professional indemnity, marine cargo, hull and machinery, workers compensation, environmental liability.',
    `insurance_minimum_coverage` DECIMAL(18,2) COMMENT 'The minimum insurance coverage amount this party must maintain. Expressed in the agreement currency. Null if no specific minimum is stipulated.',
    `insurance_required_flag` BOOLEAN COMMENT 'Indicates whether this party is contractually required to maintain insurance coverage as a condition of the agreement. True if insurance is mandatory, false otherwise.',
    `last_amendment_date` DATE COMMENT 'The date of the most recent amendment affecting this partys terms or status. Null if no amendments have been executed.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this agreement party record was most recently updated. Updated automatically on any field change.',
    `liability_cap_amount` DECIMAL(18,2) COMMENT 'The maximum financial liability this party has agreed to under the contract terms. Expressed in the agreement currency. Null if unlimited liability or not applicable to this party role.',
    `liability_cap_currency` STRING COMMENT 'The three-letter ISO 4217 currency code for the liability cap amount. Examples: USD, EUR, GBP, SGD.. Valid values are `^[A-Z]{3}$`',
    `notification_address` STRING COMMENT 'The full postal address for sending formal legal notices and registered correspondence to this party. Required for contractual notice provisions.',
    `notification_email` STRING COMMENT 'The primary email address for sending contractual notices, amendments, and communications to this party. Must be monitored regularly per agreement terms.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `party_entry_date` DATE COMMENT 'The date this party became bound by the agreement. May differ from signing date if the agreement has a deferred effective date or if the party was added via amendment.',
    `party_exit_date` DATE COMMENT 'The date this party ceased to be bound by the agreement. Populated when party status changes to terminated, novated, or released. Null for active parties.',
    `party_role` STRING COMMENT 'The functional role this party plays within the agreement. Port authority is the service provider, counterparty is the primary customer or contractor, guarantor provides financial backing, sub-contractor performs delegated work, co-signatory shares obligations, beneficiary receives rights without direct obligations.. Valid values are `port_authority|counterparty|guarantor|sub_contractor|co_signatory|beneficiary`',
    `party_status` STRING COMMENT 'The current lifecycle status of this party within the agreement. Active means obligations are in force, suspended means temporary halt, terminated means party has exited, defaulted means breach of obligations, novated means replaced by another party, released means obligations discharged early.. Valid values are `active|suspended|terminated|defaulted|novated|released`',
    `party_type` STRING COMMENT 'The business classification of the party entity. Shipping line operates vessels, freight forwarder arranges cargo movement, cargo owner holds title to goods, stevedore provides cargo handling services, concessionaire operates terminal facilities under lease, government agency represents regulatory or customs authority.. Valid values are `shipping_line|freight_forwarder|cargo_owner|stevedore|concessionaire|government_agency`',
    `payment_terms_override` STRING COMMENT 'Party-specific payment terms that override the standard agreement payment terms. Examples: net 30 days, advance payment, milestone-based, letter of credit. Null if standard terms apply.',
    `performance_bond_amount` DECIMAL(18,2) COMMENT 'The value of the performance bond required from this party. Typically a percentage of the total contract value. Expressed in the agreement currency.',
    `performance_bond_currency` STRING COMMENT 'The three-letter ISO 4217 currency code for the performance bond amount. Examples: USD, EUR, GBP, SGD.. Valid values are `^[A-Z]{3}$`',
    `performance_bond_required_flag` BOOLEAN COMMENT 'Indicates whether this party is required to provide a performance bond to guarantee fulfillment of contractual obligations. True if bond is mandatory, false otherwise.',
    `remarks` STRING COMMENT 'Free-text field for recording additional notes, special conditions, or contextual information about this partys involvement in the agreement. Used for operational notes and audit trail.',
    `signatory_authority_level` STRING COMMENT 'The hierarchical authority level of the signatory within their organization. Board level requires board resolution, executive is C-suite, senior management is VP or director level, middle management is department head, delegated is authorized representative with power of attorney.. Valid values are `board_level|executive|senior_management|middle_management|delegated`',
    `signatory_name` STRING COMMENT 'The full legal name of the individual who signed the agreement on behalf of this party. Required for contract enforceability and audit trail.',
    `signatory_title` STRING COMMENT 'The official job title or position of the signatory within their organization at the time of signing. Examples: Chief Executive Officer, Managing Director, Port Director, Operations Manager.',
    `signing_date` DATE COMMENT 'The calendar date on which this party executed the agreement. May differ across parties in multi-party agreements with sequential signing. Critical for determining contract formation and effective date.',
    `signing_location` STRING COMMENT 'The city and country where the signatory executed the agreement. Relevant for determining governing law and jurisdiction in international contracts.',
    CONSTRAINT pk_agreement_party PRIMARY KEY(`agreement_party_id`)
) COMMENT 'Association entity capturing all parties bound by a commercial agreement, including the port authority itself, shipping lines, stevedoring contractors, concessionaires, and third-party guarantors. Records party role (port_authority, counterparty, guarantor, sub-contractor), party type (shipping_line, freight_forwarder, cargo_owner, stevedore, concessionaire, government_agency), signatory name, signatory title, signing date, and party status within the agreement. Supports multi-party agreements common in port concession and joint-venture arrangements.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` (
    `service_scope_id` BIGINT COMMENT 'Unique identifier for the service scope line item within a commercial agreement. Primary key.',
    `agreement_id` BIGINT COMMENT 'Reference to the parent commercial agreement under which this service scope is defined. Links to the contract master data.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Service scope approval requires employee accountability for authorizing contractual service commitments and operational parameters in terminal operations.',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Service scope may specify cargo types covered (imdg_handling_authorized, reefer_service_included fields suggest commodity restrictions). Important for cargo acceptance decisions and ensuring terminal ',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: Service scopes specify authorized commodity types by HS code (e.g., IMDG class authorization, reefer handling, prohibited goods exclusions). Essential for validating service authorization against actu',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Specific services (stevedoring, pilotage, towage, reefer) are delivered by operational cost centres. Required for service costing, cost allocation, and operational variance analysis by service type.',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Service scope may specify container types handled (equipment_type_required field present). Container type restrictions (standard, reefer, OOG, hazmat) are common in terminal service agreements and aff',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Service scope often restricts vessel types eligible for contracted services (equipment_type_required field hints at this). Critical for vessel acceptance decisions and ensuring service delivery capabi',
    `material_group_id` BIGINT COMMENT 'Foreign key linking to procurement.material_group. Business justification: Service scopes define cargo/service types handled (containers, bulk, liquid) which directly map to procurement material groups for required equipment, spare parts, consumables. Business process: procu',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Service scope defines WHERE contracted services are delivered. Terminal and berth codes denormalize port_location master data. Essential for berth allocation, operational planning, and service deliver',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Service lines are mapped to profit centres for margin analysis. Required for service line profitability reporting and strategic decisions on service portfolio optimization.',
    `amendment_number` STRING COMMENT 'Sequential number tracking amendments or revisions to this service scope line item. Increments with each modification to the scope terms.',
    `approval_date` DATE COMMENT 'Date on which this service scope line item was formally approved and authorized for execution under the contract.',
    `billing_basis` STRING COMMENT 'Unit basis on which charges for this service scope are calculated and invoiced. Defines the pricing metric for the service.. Valid values are `per_teu|per_move|per_hour|per_vessel_call|per_dwt|flat_rate`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp recording when this service scope record was first created in the system. Supports audit trail and data lineage.',
    `crew_competency_required` STRING COMMENT 'Minimum crew competency level or certification required to perform this service scope, ensuring compliance with safety and operational standards.',
    `customs_clearance_included` BOOLEAN COMMENT 'Indicates whether customs clearance facilitation and documentation services are included in this service scope. True if included, False otherwise.',
    `effective_from_date` DATE COMMENT 'Date from which this service scope becomes active and the port is obligated to provide the specified service under the contract terms.',
    `effective_to_date` DATE COMMENT 'Date on which this service scope expires or terminates. Null indicates an open-ended service commitment aligned with the parent contract term.',
    `environmental_compliance_required` STRING COMMENT 'Specific environmental standards, certifications, or compliance requirements that must be met when delivering this service scope, such as ISO 14001 or MARPOL compliance.',
    `equipment_type_required` STRING COMMENT 'Specific equipment type or class required to deliver this service scope, such as STS crane, RTG, tug class, or pilot boat. Null if not equipment-dependent.',
    `exclusions` STRING COMMENT 'Narrative description of specific activities, conditions, or scenarios explicitly excluded from this service scope. Defines service boundaries and limitations.',
    `imdg_handling_authorized` BOOLEAN COMMENT 'Indicates whether this service scope includes authorization to handle dangerous goods under IMDG Code. True if authorized, False otherwise.',
    `isps_security_level` STRING COMMENT 'Minimum ISPS security level required for service delivery under this scope. Defines security posture and access control requirements.. Valid values are `level_1|level_2|level_3`',
    `last_amended_date` DATE COMMENT 'Date on which this service scope line item was most recently amended or modified. Null if no amendments have been made since original creation.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp recording when this service scope record was most recently updated or modified. Supports audit trail and change tracking.',
    `notes` STRING COMMENT 'Free-text field for capturing additional operational notes, clarifications, or context relevant to this service scope line item.',
    `performance_bonus_applicable` BOOLEAN COMMENT 'Indicates whether performance bonuses or incentive payments apply if SLA targets for this service scope are exceeded. True if bonuses apply, False otherwise.',
    `performance_penalty_applicable` BOOLEAN COMMENT 'Indicates whether performance penalties or liquidated damages apply if SLA targets for this service scope are not met. True if penalties apply, False otherwise.',
    `priority_level` STRING COMMENT 'Service priority tier assigned to this scope line, determining resource allocation and response time commitments.. Valid values are `standard|priority|express|emergency|deferred`',
    `rate_card_reference` STRING COMMENT 'Reference code or identifier linking this service scope to the applicable rate card or pricing schedule in the tariff management system.',
    `reefer_service_included` BOOLEAN COMMENT 'Indicates whether refrigerated container monitoring and power supply services are included in this service scope. True if included, False otherwise.',
    `service_description` STRING COMMENT 'Detailed narrative description of the specific service activities, deliverables, and operational parameters covered under this service scope line item.',
    `service_line_number` STRING COMMENT 'Sequential line number identifying the position of this service scope item within the parent contract. Used for ordering and reference.',
    `service_status` STRING COMMENT 'Current operational status of this service scope line item. Indicates whether the service is currently being delivered under the contract.. Valid values are `active|suspended|terminated|pending_activation|under_review`',
    `service_type` STRING COMMENT 'Category of port service covered by this scope line. Defines the operational service domain. [ENUM-REF-CANDIDATE: pilotage|towage|stevedoring|container_handling|storage|reefer_monitoring|gate_operations|rail_operations|berth_allocation|cargo_inspection|customs_facilitation|waste_disposal — promote to reference product]. Valid values are `pilotage|towage|stevedoring|container_handling|storage|reefer_monitoring`',
    `service_window` STRING COMMENT 'Operational availability window during which the service is committed to be provided under this scope. Defines temporal service boundaries.. Valid values are `24x7|business_hours|daylight_only|tidal_dependent|scheduled_slots`',
    `sla_target_response_minutes` STRING COMMENT 'Contracted target response time in minutes from service request to service commencement. Applicable to time-sensitive services like pilotage and towage.',
    `sla_target_turnaround_hours` DECIMAL(18,2) COMMENT 'Contracted target turnaround time in hours for completing the service from initiation to completion. Null if not applicable to the service type.',
    `special_conditions` STRING COMMENT 'Additional terms, conditions, or operational requirements specific to this service scope line item that modify or supplement standard service delivery terms.',
    `throughput_guarantee_amount` DECIMAL(18,2) COMMENT 'Minimum throughput quantity guaranteed by the port for this service scope, expressed in the applicable unit of measure. Null if no guarantee applies.',
    `throughput_guarantee_flag` BOOLEAN COMMENT 'Indicates whether the port has committed to a minimum throughput guarantee for this service scope. True if guarantee applies, False otherwise.',
    `throughput_guarantee_unit` STRING COMMENT 'Unit of measure for the throughput guarantee amount. Aligns with the service type and volume commitment metrics.. Valid values are `TEU|FEU|DWT|CBM|vessel_calls|moves`',
    `volume_commitment_dwt` DECIMAL(18,2) COMMENT 'Contracted minimum or target cargo volume commitment expressed in deadweight tonnage for bulk or general cargo services. Null if not applicable.',
    `volume_commitment_teu` DECIMAL(18,2) COMMENT 'Contracted minimum or target volume commitment expressed in TEU for container handling services. Null if not applicable to the service type.',
    `volume_commitment_vessel_calls` STRING COMMENT 'Contracted minimum or target number of vessel calls per period for marine services such as pilotage or towage. Null if not applicable.',
    CONSTRAINT pk_service_scope PRIMARY KEY(`service_scope_id`)
) COMMENT 'Defines the specific port services and operational scope covered under each commercial agreement. Each record represents a distinct service line item within a contract, capturing service type (pilotage, towage, stevedoring, container_handling, storage, reefer_monitoring, gate_operations, rail_operations), service description, applicable terminal or berth, volume commitments (TEU, DWT, vessel calls), throughput guarantees, service window (24/7, business_hours), and priority level. Enables granular tracking of what services are contracted versus what is delivered.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` (
    `sla_definition_id` BIGINT COMMENT 'Unique identifier for the SLA definition record. Primary key.',
    `agreement_id` BIGINT COMMENT 'Reference to the commercial agreement (service agreement, concession, stevedoring contract) to which this SLA definition is attached. Links SLA to contractual context.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: SLA ownership assignment requires employee reference for accountability in SLA performance monitoring and breach escalation processes.',
    `service_scope_id` BIGINT COMMENT 'Foreign key linking to contract.service_scope. Business justification: SLA definitions are often service-specific (e.g., vessel turnaround time SLA for container operations, cargo dwell time SLA for bulk terminal). This FK links the SLA definition to the service scope it',
    `sla_rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.sla_rate_card. Business justification: SLA definitions in agreements link to tariff-published SLA rate cards defining performance-based pricing. SLA rate cards specify premiums/penalties for performance levels. Critical for performance-bas',
    `superseded_by_sla_definition_id` BIGINT COMMENT 'Reference to the SLA definition that replaces this one when a new version is created. Null if this is the current version.',
    `approved_by` STRING COMMENT 'Name or identifier of the user who approved this SLA definition for active use.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when this SLA definition was formally approved and activated.',
    `compliance_framework` STRING COMMENT 'Reference to the regulatory or industry compliance framework that mandates or influences this SLA (e.g., ISPS Code, ISO 28000, Port State Control (PSC), IAPH Standards). Null if SLA is purely commercial.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this SLA definition record was first created in the system.',
    `critical_threshold` DECIMAL(18,2) COMMENT 'The threshold value at which performance is considered critically below acceptable levels, triggering escalation and potential penalty application.',
    `customer_segment` STRING COMMENT 'The customer segment or tier to which this SLA definition applies (e.g., Premium Shipping Lines, Standard Carriers, Occasional Users). Allows differentiated service levels by customer importance. [ENUM-REF-CANDIDATE: premium|standard|occasional|strategic_partner|spot_customer|government|military — promote to reference product]',
    `data_source_system` STRING COMMENT 'The operational system from which SLA performance data is sourced (e.g., NAVIS N4, VTMS, TOPS Expert, Port Community System (PCS)). Ensures traceability of measurement data.',
    `sla_definition_description` STRING COMMENT 'Detailed textual description of the SLA definition, including business context, rationale, and any special conditions or exclusions.',
    `effective_from_date` DATE COMMENT 'The date from which this SLA definition becomes active and applicable to agreements.',
    `effective_to_date` DATE COMMENT 'The date on which this SLA definition expires or is superseded. Null indicates the SLA is open-ended.',
    `escalation_required_flag` BOOLEAN COMMENT 'Indicates whether SLA breaches require formal escalation to management or customer relationship teams. True if escalation procedures are defined, False otherwise.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this SLA definition record was last updated.',
    `measurement_frequency` STRING COMMENT 'Frequency at which the SLA metric is measured and evaluated: real_time (continuous monitoring), hourly, daily, weekly, monthly, per_transaction (each gate/cargo transaction), per_vessel_call (each vessel visit). [ENUM-REF-CANDIDATE: real_time|hourly|daily|weekly|monthly|per_transaction|per_vessel_call — 7 candidates stripped; promote to reference product]',
    `measurement_methodology` STRING COMMENT 'Detailed description of how the SLA metric is calculated, including data sources, calculation formula, exclusions, and measurement boundaries. Ensures consistent interpretation between port and customer.',
    `measurement_unit` STRING COMMENT 'Unit of measure for the SLA metric: hours, minutes, moves_per_hour (crane productivity), percentage (availability/uptime), teu_per_day (Twenty-foot Equivalent Unit throughput), documents_per_day (documentation processing), transactions_per_hour (gate processing). [ENUM-REF-CANDIDATE: hours|minutes|moves_per_hour|percentage|teu_per_day|documents_per_day|transactions_per_hour — 7 candidates stripped; promote to reference product]',
    `notes` STRING COMMENT 'Internal notes and comments for operational teams regarding the SLA definition, including implementation guidance, known issues, or historical context.',
    `penalty_applicable_flag` BOOLEAN COMMENT 'Indicates whether financial or service penalties apply when this SLA is breached. True if penalties are defined in the associated agreement, False if SLA is informational only.',
    `penalty_calculation_method` STRING COMMENT 'Method used to calculate penalties for SLA breaches: fixed_amount (flat fee), percentage_of_charge (percentage of service charge), tiered (escalating based on severity), per_unit_deviation (penalty per unit below target), service_credit (future service discount).. Valid values are `fixed_amount|percentage_of_charge|tiered|per_unit_deviation|service_credit`',
    `reporting_frequency` STRING COMMENT 'Frequency at which SLA performance reports are generated and delivered to stakeholders: daily, weekly, monthly, quarterly, on_demand (ad-hoc requests).. Valid values are `daily|weekly|monthly|quarterly|on_demand`',
    `sla_category` STRING COMMENT 'Classification of the SLA by operational domain: vessel_turnaround (time from arrival to departure), crane_productivity (container moves per hour), gate_processing_time (truck processing duration), berth_availability (berth readiness percentage), reefer_uptime (refrigerated container power availability), documentation_turnaround (customs and trade document processing time).. Valid values are `vessel_turnaround|crane_productivity|gate_processing_time|berth_availability|reefer_uptime|documentation_turnaround`',
    `sla_code` STRING COMMENT 'Unique business identifier code for the SLA definition, used for external reference and system integration.. Valid values are `^[A-Z0-9_-]{3,20}$`',
    `sla_definition_status` STRING COMMENT 'Current lifecycle status of the SLA definition: draft (being developed), active (in use), suspended (temporarily inactive), retired (no longer applicable), under_review (being evaluated for changes).. Valid values are `draft|active|suspended|retired|under_review`',
    `sla_name` STRING COMMENT 'Human-readable name of the SLA definition describing the service commitment.',
    `sla_type` STRING COMMENT 'Type of service level commitment: performance (operational efficiency), availability (uptime/readiness), response_time (speed of service), throughput (volume capacity), quality (accuracy/completeness), compliance (regulatory adherence).. Valid values are `performance|availability|response_time|throughput|quality|compliance`',
    `target_metric_name` STRING COMMENT 'Name of the specific performance metric being measured for this SLA (e.g., Vessel Turnaround Time, Quay Crane (QC) Moves Per Hour, Gate Transaction Time).',
    `target_threshold` DECIMAL(18,2) COMMENT 'The committed target value that must be achieved to meet the SLA. Represents the contractual service level commitment.',
    `threshold_operator` STRING COMMENT 'The comparison operator used to evaluate performance against thresholds: less_than (performance must be below target, e.g., turnaround time), greater_than (performance must exceed target, e.g., crane productivity), equal (exact match), between (range-based).. Valid values are `less_than|less_than_or_equal|greater_than|greater_than_or_equal|equal|between`',
    `version_number` STRING COMMENT 'Version number of this SLA definition, incremented when the definition is revised. Supports SLA definition change tracking and historical analysis.',
    `warning_threshold` DECIMAL(18,2) COMMENT 'The threshold value at which performance triggers a warning alert, indicating risk of SLA breach. Typically set between target and critical thresholds.',
    CONSTRAINT pk_sla_definition PRIMARY KEY(`sla_definition_id`)
) COMMENT 'Master catalog of Service Level Agreement definitions associated with port commercial agreements. Captures SLA name, SLA category (vessel_turnaround, crane_productivity, gate_processing_time, berth_availability, reefer_uptime, documentation_turnaround), target metric, measurement unit (hours, moves_per_hour, percentage, TEU_per_day), target threshold, warning threshold, critical threshold, measurement frequency, measurement methodology, penalty applicability flag, and the applicable agreement reference. Serves as the authoritative SLA template library for port service contracts.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` (
    `sla_measurement_id` BIGINT COMMENT 'Unique identifier for the SLA measurement record. Primary key for the sla_measurement product.',
    `agreement_id` BIGINT COMMENT 'Reference to the parent commercial agreement under which this SLA measurement is tracked.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: SLA performance is measured against the delivering cost centre for operational accountability. Required for performance-based cost allocation and linking operational KPIs to financial responsibility.',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: SLA measurements for customs clearance turnaround time directly reference the declaration being measured. Required for performance tracking, penalty assessment, and demonstrating compliance with contr',
    `invoice_id` BIGINT COMMENT 'Reference to the invoice that includes penalties or incentives calculated from this measurement. Null if not yet invoiced.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: SLA measurement validation requires employee sign-off for data quality assurance and dispute resolution in performance reporting and penalty assessment.',
    `participant_account_id` BIGINT COMMENT 'Reference to the port community participant (shipping line, stevedore, terminal operator) whose performance is being measured.',
    `port_location_id` BIGINT COMMENT 'Reference to the specific terminal or berth where the measured activity occurred. Enables terminal-level performance analysis.',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: SLA breaches (vessel turnaround delays, throughput shortfalls) are often caused by security incidents—MARSEC escalations, facility lockdowns, cargo screening delays. Root cause analysis and penalty wa',
    `service_scope_id` BIGINT COMMENT 'Foreign key linking to contract.service_scope. Business justification: SLA measurements are operationally service-specific (e.g., this turnaround measurement was for Terminal 3 container service, this response time measurement was for pilotage). Direct FK provides operat',
    `sla_definition_id` BIGINT COMMENT 'Reference to the specific SLA definition or volume commitment being measured. Links to the contractual SLA terms.',
    `terminal_berth_allocation_id` BIGINT COMMENT 'Foreign key linking to terminal.berth_allocation. Business justification: SLA measurements for vessel turnaround time, berth productivity (moves per hour), and operational KPIs must link to specific berth allocations to attribute performance correctly and validate against b',
    `call_id` BIGINT COMMENT 'Reference to the specific vessel call if this measurement is tied to a single vessel visit (e.g., vessel turnaround time SLA). Nullable for non-vessel-specific measurements.',
    `actual_value` DECIMAL(18,2) COMMENT 'The actual measured performance value achieved during the measurement period. Units depend on measurement category (e.g., TEU for volume, hours for turnaround, moves per hour for crane productivity).',
    `adjusted_actual_value` DECIMAL(18,2) COMMENT 'Revised actual value after dispute resolution or manual adjustment. Null if no adjustment was made. Used for recalculating penalties and performance status.',
    `adjustment_reason` STRING COMMENT 'Explanation for why the actual value was adjusted post-measurement. Captures dispute resolution outcomes or data correction rationale.',
    `billing_period` STRING COMMENT 'The billing period (YYYY-MM format) to which this measurement and any associated penalties or incentives will be applied. Aligns with invoice generation cycles.. Valid values are `^d{4}-d{2}$`',
    `breach_notification_timestamp` TIMESTAMP COMMENT 'Timestamp when the breach notification was sent to contract stakeholders. Null if no notification was triggered.',
    `breach_notification_triggered` BOOLEAN COMMENT 'Indicates whether an automated breach notification was triggered and sent to stakeholders when this measurement recorded an SLA breach.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this measurement record was first created in the system. Audit trail for record creation.',
    `dispute_raised_flag` BOOLEAN COMMENT 'Indicates whether the participant has raised a formal dispute regarding this measurement. Triggers dispute resolution workflow.',
    `dispute_resolution_date` DATE COMMENT 'Date on which a disputed measurement was resolved and finalized. Null if no dispute was raised or dispute is still open.',
    `incentive_amount` DECIMAL(18,2) COMMENT 'Calculated financial incentive or bonus amount due to over-performance or volume surplus, as per contractual incentive clauses. Null if no incentive applies.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this measurement record was last updated. Audit trail for record modification.',
    `measurement_approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the measurement was officially approved and locked for billing. Marks the end of the measurement lifecycle.',
    `measurement_date` DATE COMMENT 'The business date on which the measurement was taken or the performance event occurred. Principal business event timestamp for this transaction.',
    `measurement_notes` STRING COMMENT 'Free-text field for capturing contextual information, exceptions, or explanations related to the measurement (e.g., force majeure events, system outages, disputed measurements).',
    `measurement_period_end_date` DATE COMMENT 'End date of the measurement period window for aggregated metrics.',
    `measurement_period_start_date` DATE COMMENT 'Start date of the measurement period window for aggregated metrics (e.g., monthly or quarterly measurements).',
    `measurement_period_type` STRING COMMENT 'Frequency or granularity at which the SLA measurement is captured and evaluated. Aligns with contractual reporting periods.. Valid values are `daily|weekly|monthly|quarterly|annual|per_call`',
    `measurement_source_system` STRING COMMENT 'The operational system from which the measurement data was extracted. Ensures traceability and auditability of performance data. [ENUM-REF-CANDIDATE: NAVIS_N4|VTMS|TOPS|TOS|PCS|GATE_SYSTEM|MANUAL — 7 candidates stripped; promote to reference product]',
    `measurement_status` STRING COMMENT 'Lifecycle status of the measurement record. Tracks whether the measurement is preliminary, confirmed by both parties, under dispute, or finalized for billing.. Valid values are `draft|confirmed|disputed|adjusted|finalized`',
    `measurement_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the measurement data was captured from the source system. Distinct from measurement_date which represents the business date.',
    `penalty_amount` DECIMAL(18,2) COMMENT 'Calculated financial penalty amount due to SLA breach or volume shortfall, as per contractual penalty clauses. Null if no penalty applies.',
    `penalty_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for penalty and incentive amounts.. Valid values are `^[A-Z]{3}$`',
    `performance_status` STRING COMMENT 'Categorical assessment of whether the SLA or volume commitment was achieved. Met indicates compliance, breached indicates failure, at_risk indicates near-miss, shortfall/surplus apply to volume commitments.. Valid values are `met|breached|at_risk|on_track|shortfall|surplus`',
    `target_value` DECIMAL(18,2) COMMENT 'The contractually committed or target performance value that was expected to be achieved. Baseline for variance calculation.',
    `unit_of_measure` STRING COMMENT 'The unit in which the actual and target values are expressed. Critical for correct interpretation of measurement values. [ENUM-REF-CANDIDATE: TEU|FEU|MOVES|HOURS|MINUTES|TONNES|CBM|PERCENTAGE|COUNT — 9 candidates stripped; promote to reference product]',
    `variance_absolute` DECIMAL(18,2) COMMENT 'Absolute difference between actual and target values (actual minus target). Positive indicates over-performance, negative indicates under-performance.',
    `variance_percentage` DECIMAL(18,2) COMMENT 'Percentage variance between actual and target values, calculated as (actual - target) / target * 100. Enables normalized performance comparison across different metrics.',
    `volume_shortfall` DECIMAL(18,2) COMMENT 'For volume commitment measurements, the amount by which actual throughput fell short of the committed volume. Null if target was met or exceeded.',
    `volume_surplus` DECIMAL(18,2) COMMENT 'For volume commitment measurements, the amount by which actual throughput exceeded the committed volume. May trigger incentive payments per contract terms.',
    CONSTRAINT pk_sla_measurement PRIMARY KEY(`sla_measurement_id`)
) COMMENT 'Transactional records of actual performance measurements against all contracted service levels and volume commitments. Each record captures a single measurement event for a specific SLA definition or volume commitment within a measurement period. Stores measurement category (service_level, volume_throughput, crane_productivity, vessel_turnaround, gate_processing), measurement period (daily, weekly, monthly, quarterly, annual), measurement date, actual metric value, target/committed value, variance (absolute and percentage), performance status (met, breached, at_risk, on_track, shortfall, surplus), measurement source system (NAVIS N4, VTMS, TOS), vessel call reference, terminal reference, shortfall/surplus volume, calculated penalty or incentive amount, and breach notification trigger flag. Serves as the unified measurement entity for all contractual performance tracking — both SLA compliance and volume commitment performance. Feeds SLA breach detection, penalty/incentive calculations, volume shortfall assessments, and commercial performance review dashboards.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` (
    `sla_breach_id` BIGINT COMMENT 'Unique identifier for the SLA breach event. Primary key.',
    `agreement_id` BIGINT COMMENT 'Reference to the parent commercial contract or service agreement under which this SLA breach occurred.',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: SLA breaches for clearance time are often triggered by customs holds. Essential for root cause analysis, determining liability (port vs. customer vs. authority), and justifying penalty waivers when ho',
    `participant_account_id` BIGINT COMMENT 'Reference to the external party (shipping line, stevedore, terminal operator, or other stakeholder) affected by or involved in this SLA breach.',
    `penalty_assessment_id` BIGINT COMMENT 'Foreign key linking to contract.penalty_assessment. Business justification: When an SLA breach results in a financial penalty, a penalty_assessment record is created. This FK links the breach event to the resulting assessment, providing end-to-end traceability from performanc',
    `previous_breach_sla_breach_id` BIGINT COMMENT 'Reference to the prior breach event if this is a recurrence, enabling trend analysis and pattern detection in SLA performance.',
    `sla_definition_id` BIGINT COMMENT 'Reference to the SLA definition that was breached, containing the contracted performance thresholds and measurement criteria.',
    `sla_measurement_id` BIGINT COMMENT 'Reference to the specific SLA measurement event that triggered this breach, linking to the actual performance data that fell outside contracted thresholds.',
    `terminal_berth_allocation_id` BIGINT COMMENT 'Foreign key linking to terminal.berth_allocation. Business justification: When SLA breaches occur (vessel turnaround exceeded, productivity targets missed), linking to the specific berth allocation enables root cause analysis, identifies responsible operational events, and ',
    `actual_value` DECIMAL(18,2) COMMENT 'The actual measured performance value that triggered the breach, enabling calculation of deviation magnitude and penalty amounts.',
    `breach_date` DATE COMMENT 'The calendar date on which the SLA breach was confirmed to have occurred, based on the measurement period end date.',
    `breach_duration_hours` DECIMAL(18,2) COMMENT 'The total duration in hours that the service performance remained outside the contracted SLA threshold, calculated from breach start to resolution or measurement period end.',
    `breach_notification_date` DATE COMMENT 'The date on which the counterparty was formally notified of the SLA breach, as required by contract terms and for compliance with notification timeframes.',
    `breach_number` STRING COMMENT 'Externally-visible unique reference number assigned to this breach event for tracking, communication, and dispute resolution purposes.',
    `breach_severity` STRING COMMENT 'Classification of the breach impact based on the magnitude of deviation from the SLA threshold and business criticality. Minor breaches may trigger warnings, major breaches require remediation plans, and critical breaches may invoke penalty clauses or contract review.. Valid values are `minor|major|critical`',
    `breach_status` STRING COMMENT 'Current lifecycle status of the breach record. Open indicates newly detected breach; under_review indicates investigation in progress; remediated indicates corrective actions completed; disputed indicates counterparty challenge; closed indicates final resolution and record archival.. Valid values are `open|under_review|remediated|disputed|closed`',
    `breach_timestamp` TIMESTAMP COMMENT 'The precise date and time when the SLA breach was detected and recorded in the system, supporting audit trail and notification workflows.',
    `communication_log` STRING COMMENT 'Chronological record of all formal communications with the counterparty regarding this breach, including notifications, acknowledgements, remediation updates, and dispute correspondence.',
    `counterparty_acknowledgement_date` DATE COMMENT 'The date on which the counterparty formally acknowledged receipt and acceptance of the breach notification, establishing the start of any contractual remedy or dispute periods.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this breach record was first created in the database, supporting audit trail and data lineage requirements.',
    `deviation_percentage` DECIMAL(18,2) COMMENT 'The percentage deviation from the contracted SLA threshold, calculated as (deviation_value / threshold_value) * 100, used for severity classification and penalty calculation.',
    `deviation_value` DECIMAL(18,2) COMMENT 'The calculated difference between the actual performance value and the contracted threshold, representing the magnitude of the breach. Positive or negative depending on whether the metric is a minimum or maximum threshold.',
    `dispute_outcome` STRING COMMENT 'Final determination of the dispute resolution process. Upheld confirms the original breach determination; overturned nullifies the breach; partially_upheld adjusts severity or penalty; withdrawn indicates counterparty retraction.. Valid values are `upheld|overturned|partially_upheld|withdrawn`',
    `dispute_raised_flag` BOOLEAN COMMENT 'Boolean indicator of whether the counterparty has formally disputed the breach determination, severity classification, or penalty calculation, triggering dispute resolution workflows.',
    `dispute_reason` STRING COMMENT 'Counterparty-provided explanation or justification for disputing the breach, including claims of force majeure, measurement error, or shared responsibility.',
    `dispute_resolution_date` DATE COMMENT 'The date on which the dispute was formally resolved through negotiation, arbitration, or other contractual dispute resolution mechanism.',
    `escalation_date` DATE COMMENT 'The date on which the breach was escalated to a higher organizational level, supporting SLA breach management governance and audit trails.',
    `escalation_level` STRING COMMENT 'The organizational level to which this breach has been escalated for resolution, reflecting the severity and business impact of the breach.. Valid values are `operational|management|executive|legal`',
    `impact_assessment` STRING COMMENT 'Qualitative or quantitative assessment of the business impact of the breach on port operations, counterparty operations, and broader supply chain, supporting severity classification and remediation prioritization.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent update to this breach record, tracking the evolution of breach status, remediation progress, and dispute resolution.',
    `measurement_unit` STRING COMMENT 'The unit of measure for the threshold and actual values (e.g., hours, minutes, TEU, percentage, moves_per_hour), copied from the SLA definition for clarity in breach reporting.',
    `notes` STRING COMMENT 'Free-text field for additional context, observations, or operational notes related to the breach that do not fit structured fields, supporting comprehensive breach documentation.',
    `penalty_applicable_flag` BOOLEAN COMMENT 'Boolean indicator of whether contractual penalty clauses apply to this breach based on severity, responsible party determination, and contract terms.',
    `recurrence_flag` BOOLEAN COMMENT 'Boolean indicator of whether this breach represents a recurrence of a similar breach for the same SLA definition and counterparty within a defined period, triggering enhanced remediation or contract review.',
    `remediation_deadline` DATE COMMENT 'The target date by which remediation actions must be completed, as agreed with the counterparty or mandated by contract terms.',
    `remediation_plan` STRING COMMENT 'Detailed description of the corrective actions, process improvements, or operational changes planned or implemented to prevent recurrence of similar breaches.',
    `resolution_date` DATE COMMENT 'The date on which the breach was formally resolved, remediation completed, and the breach record closed, marking the end of the breach lifecycle.',
    `responsible_department` STRING COMMENT 'The internal port department or operational unit responsible for the service that breached the SLA (e.g., Terminal Operations, Marine Services, Gate Operations), used for internal accountability and performance management.',
    `responsible_party` STRING COMMENT 'Determination of which party bears responsibility for the breach, critical for penalty application, dispute resolution, and contractual liability assessment.. Valid values are `port|counterparty|third_party|shared|force_majeure`',
    `root_cause_category` STRING COMMENT 'High-level classification of the underlying cause of the SLA breach, used for trend analysis, accountability determination, and continuous improvement initiatives. [ENUM-REF-CANDIDATE: equipment_failure|weather|labour_shortage|vessel_delay|yard_congestion|system_outage|process_error|third_party|force_majeure|other — 10 candidates stripped; promote to reference product]',
    `root_cause_description` STRING COMMENT 'Detailed narrative explanation of the specific circumstances, events, or failures that led to the SLA breach, supporting dispute resolution and process improvement.',
    `threshold_value` DECIMAL(18,2) COMMENT 'The contracted performance threshold value that was breached, copied from the SLA definition for historical reference and breach analysis.',
    CONSTRAINT pk_sla_breach PRIMARY KEY(`sla_breach_id`)
) COMMENT 'Records confirmed SLA breach events arising from SLA measurements that fall outside contracted thresholds. Captures breach date, breach severity (minor, major, critical), breached SLA definition, breach duration, root cause category, root cause description, responsible party, breach notification date, counterparty acknowledgement date, remediation plan, remediation deadline, resolution date, and breach status (open, under_review, remediated, disputed, closed). Drives penalty calculations and formal breach management workflows.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` (
    `rate_schedule_id` BIGINT COMMENT 'Unique identifier for the rate schedule entry. Primary key for this product.',
    `agreement_id` BIGINT COMMENT 'Reference to the parent commercial agreement under which this rate schedule is defined. Links this pricing term to the governing contract.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Rate approval authority tracking requires employee reference for financial governance and authorization control in tariff management.',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Rates vary by commodity (hazmat_surcharge_flag, reefer_temperature_range fields present). Commodity-specific pricing (hazmat surcharges, reefer handling, special cargo rates) is standard in port tarif',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Rate schedules define which GL accounts receive revenue when services are billed. Required for revenue recognition mapping, automated posting rules, and financial statement accuracy.',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Container handling rates are container-type-specific (20ft, 40ft, reefer, OOG, hazmat). ISO type code differentiation is standard in container terminal tariffs and essential for accurate billing.',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Port tariffs are vessel-type-specific (grt_lower_bound, grt_upper_bound fields present). Vessel type determines applicable rate bands and is core to maritime tariff structures and port dues calculatio',
    `material_group_id` BIGINT COMMENT 'Foreign key linking to procurement.material_group. Business justification: Port tariff structures align with procurement material categories for cost recovery modeling (e.g., cargo handling rates informed by material handling equipment costs, pilotage rates by vessel equipme',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Rate schedules in agreements reference published port tariffs as their pricing foundation. Agreements often adopt or modify published tariff structures. Essential for contract pricing structure defini',
    `service_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.service_code. Business justification: Rate schedules reference standardized service definitions from master data. Essential for billing standardization, tariff management, GL account mapping, and ensuring consistent service pricing across',
    `service_scope_id` BIGINT COMMENT 'Foreign key linking to contract.service_scope. Business justification: Rate schedules are typically bound to specific service scopes (e.g., container handling rates for Terminal 3, pilotage rates for vessels 10,000-50,000 GRT). This FK links rate to service, enabling pre',
    `approval_date` DATE COMMENT 'Date on which this rate schedule entry was formally approved. Null if still in draft status.',
    `billing_cycle` STRING COMMENT 'Frequency at which charges under this rate schedule are invoiced to the customer.. Valid values are `per_transaction|daily|weekly|monthly|quarterly|annual`',
    `calculation_basis` STRING COMMENT 'Unit of measure or method by which the rate is applied and calculated in billing transactions. [ENUM-REF-CANDIDATE: per_teu|per_feu|per_move|per_day|per_grt|fixed_amount|percentage_of_contract_value|per_ton|per_cbm|per_hour|per_shift — promote to reference product]. Valid values are `per_teu|per_feu|per_move|per_day|per_grt|fixed_amount`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this rate schedule record was first created in the system. Part of audit trail.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which the rate value is denominated (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Percentage discount applied to the base rate value for this schedule entry. Null if no discount applies. Used for volume discounts or promotional pricing.',
    `effective_date` DATE COMMENT 'Date from which this rate schedule entry becomes active and applicable for billing. Part of the rate validity period.',
    `escalation_clause_flag` BOOLEAN COMMENT 'Indicates whether this rate is subject to automatic escalation based on an index or formula. True if escalation applies, False otherwise.',
    `escalation_frequency` STRING COMMENT 'Frequency at which the rate escalation is reviewed and applied. Null or none if no escalation applies.. Valid values are `monthly|quarterly|semi_annual|annual|none`',
    `escalation_index` STRING COMMENT 'The index or benchmark used for automatic rate escalation (e.g., Consumer Price Index, fuel price index, exchange rate). Null or none if no escalation applies.. Valid values are `cpi|fuel_index|exchange_rate|custom|none`',
    `escalation_percentage` DECIMAL(18,2) COMMENT 'Fixed percentage by which the rate increases at each escalation event. Null if escalation is index-based rather than fixed percentage.',
    `expiry_date` DATE COMMENT 'Date on which this rate schedule entry ceases to be valid. Null indicates an open-ended rate with no defined expiration.',
    `free_time_days` STRING COMMENT 'Number of days of free storage or dwell time included before storage tariff or demurrage charges begin to accrue. Applicable for storage_tariff, dmg_rate, and det_rate types. Null if not applicable.',
    `grace_period_hours` STRING COMMENT 'Additional grace period in hours beyond free time before charges begin. Null if no grace period applies.',
    `grt_lower_bound` DECIMAL(18,2) COMMENT 'Minimum Gross Registered Tonnage for which this rate applies. Used in conjunction with GRT upper bound to define vessel size bands for rate calculation. Null if rate is not GRT-based.',
    `grt_upper_bound` DECIMAL(18,2) COMMENT 'Maximum Gross Registered Tonnage for which this rate applies. Null indicates no upper limit for the band.',
    `hazmat_surcharge_flag` BOOLEAN COMMENT 'Indicates whether an additional surcharge applies for hazardous materials handling under this rate. True if surcharge applies, False otherwise.',
    `imdg_class` STRING COMMENT 'IMDG classification of hazardous cargo to which this rate applies. Null or not_applicable for non-hazardous cargo rates.. Valid values are `^(class_[1-9]|not_applicable)$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this rate schedule record was last updated. Part of audit trail for tracking changes to rate terms.',
    `maximum_charge` DECIMAL(18,2) COMMENT 'Maximum charge amount that caps the calculated rate. Null if no ceiling applies.',
    `minimum_charge` DECIMAL(18,2) COMMENT 'Minimum charge amount that applies regardless of calculated rate. Ensures a floor revenue for the service. Null if no minimum applies.',
    `notes` STRING COMMENT 'Free-text field for additional comments, special conditions, or clarifications related to this rate schedule entry.',
    `payment_terms_days` STRING COMMENT 'Number of days from invoice date within which payment is due for charges under this rate schedule. Null if payment terms are defined at contract level only.',
    `peak_season_surcharge` DECIMAL(18,2) COMMENT 'Additional surcharge amount applied during peak season periods. Null if no peak season surcharge applies.',
    `pil_calculation_basis` STRING COMMENT 'Specific calculation method for Port Infrastructure Levy rates. Applicable only when rate_type is pil_levy. Null or not_applicable for non-PIL rates.. Valid values are `per_teu|per_ton|percentage_of_cargo_value|fixed_per_vessel|not_applicable`',
    `pil_collection_responsibility` STRING COMMENT 'Entity responsible for collecting the PIL from the end customer. Applicable only for PIL-type rates. Null or not_applicable for non-PIL rates.. Valid values are `port_authority|shipping_line|freight_forwarder|terminal_operator|not_applicable`',
    `pil_exemption_flag` BOOLEAN COMMENT 'Indicates whether this rate schedule entry includes an exemption from PIL charges. True if exempt, False otherwise. Applicable for PIL-related rate schedules.',
    `pil_remittance_frequency` STRING COMMENT 'Frequency at which collected PIL amounts must be remitted to the port authority or regulatory body. Applicable only for PIL-type rates.. Valid values are `weekly|monthly|quarterly|per_transaction|not_applicable`',
    `rate_status` STRING COMMENT 'Current lifecycle status of the rate schedule entry. Indicates whether the rate is currently in use, pending approval, or no longer applicable.. Valid values are `draft|active|suspended|expired|superseded`',
    `rate_type` STRING COMMENT 'Classification of the rate according to the type of port service or charge. [ENUM-REF-CANDIDATE: thc|wharfage|pilotage_fee|towage_rate|storage_tariff|reefer_surcharge|baf|caf|pil_levy|dmg_rate|det_rate|berth_hire|quay_crane_rate|rtg_rate|gate_fee|security_fee|customs_processing_fee|bunker_levy|environmental_levy — promote to reference product]. Valid values are `thc|wharfage|pilotage_fee|towage_rate|storage_tariff|reefer_surcharge`',
    `rate_value` DECIMAL(18,2) COMMENT 'Numeric value of the rate charged for the service. Interpretation depends on calculation_basis (e.g., per TEU, per GRT, fixed amount). Positive values only; penalties and incentives are defined in penalty_clause product.',
    `reefer_temperature_range` STRING COMMENT 'Temperature range specification for refrigerated container rates (e.g., -25C to -18C, 2C to 8C). Applicable only for reefer_surcharge rate types. Null for non-reefer rates.',
    `seasonal_flag` BOOLEAN COMMENT 'Indicates whether this rate is subject to seasonal variation or is a seasonal rate. True if seasonal, False otherwise.',
    `tax_applicable_flag` BOOLEAN COMMENT 'Indicates whether tax (VAT, GST, sales tax) applies to this rate. True if taxable, False if tax-exempt.',
    `tax_rate_percentage` DECIMAL(18,2) COMMENT 'Percentage rate of tax applied to this rate schedule entry. Null if tax_applicable_flag is False or if tax rate is defined elsewhere.',
    `volume_threshold` DECIMAL(18,2) COMMENT 'Minimum volume or quantity required to qualify for this rate or discount. Null if no threshold applies. Unit of measure is defined by calculation_basis.',
    CONSTRAINT pk_rate_schedule PRIMARY KEY(`rate_schedule_id`)
) COMMENT 'Contractually agreed pricing and tariff terms embedded within port commercial agreements, defining the financial rates charged for port services. Captures rate type (THC, wharfage, pilotage_fee, towage_rate, storage_tariff, reefer_surcharge, BAF, CAF, PIL_levy, DMG_rate, DET_rate), applicable cargo type, container size, vessel size band, rate value, currency, calculation basis (per_TEU, per_FEU, per_move, per_day, per_GRT, fixed_amount, percentage_of_contract_value), effective date, expiry date, escalation clause, escalation index, and minimum charge. For PIL-type rates: PIL calculation basis, collection responsibility, remittance frequency, exemption flags. Serves as the authoritative catalog of what the port charges under each agreement — positive pricing only. Penalty and incentive financial consequences are defined in penalty_clause.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` (
    `volume_commitment_id` BIGINT COMMENT 'Unique identifier for the volume commitment record. Primary key for this entity.',
    `agreement_id` BIGINT COMMENT 'Reference to the parent commercial agreement or service contract under which this volume commitment is stipulated.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Volume commitments are monitored by operational cost centres responsible for delivery. Required for volume variance analysis by cost centre and linking commercial commitments to operational capacity p',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Volume commitment creation audit trail requires employee reference for accountability in contractual throughput guarantee establishment.',
    `participant_account_id` BIGINT COMMENT 'Reference to the shipping line, cargo owner, or other stakeholder party bound by this volume commitment.',
    `service_scope_id` BIGINT COMMENT 'Foreign key linking to contract.service_scope. Business justification: Volume commitments are service-specific (e.g., minimum 10,000 TEU through container terminal, minimum 50 vessel calls for pilotage services). This FK links the commitment to the specific service scope',
    `actual_volume_to_date` DECIMAL(18,2) COMMENT 'Cumulative actual volume or throughput achieved against this commitment as of the last measurement date. Used for performance tracking and shortfall calculation.',
    `auto_renew_flag` BOOLEAN COMMENT 'Indicates whether this volume commitment automatically renews for subsequent periods upon expiry (True) or requires explicit renegotiation (False).',
    `commitment_period_type` STRING COMMENT 'Frequency or duration basis for measuring the volume commitment (annual, quarterly, monthly, or custom period).. Valid values are `annual|quarterly|monthly|custom`',
    `commitment_reference_number` STRING COMMENT 'Externally-known business identifier for this volume commitment, used in commercial correspondence and billing reconciliation.. Valid values are `^VC-[A-Z0-9]{8,12}$`',
    `commitment_status` STRING COMMENT 'Current lifecycle state of the volume commitment. Indicates whether the commitment is actively enforced, temporarily waived, under dispute, suspended, expired, or terminated.. Valid values are `active|waived|in_dispute|suspended|expired|terminated`',
    `commitment_type` STRING COMMENT 'Classification of the volume commitment metric. Defines what unit of throughput or activity the commitment is measured in (TEU, FEU, vessel calls, DWT, cargo tonnes, or revenue).. Valid values are `minimum_teu|minimum_feu|minimum_vessel_calls|minimum_dwt|minimum_cargo_tonnes|minimum_revenue`',
    `commitment_unit` STRING COMMENT 'Unit of measure for the committed volume. Aligns with commitment_type and defines how the committed_volume is quantified (TEU, FEU, vessel calls, DWT, tonnes, CBM, or revenue in USD). [ENUM-REF-CANDIDATE: TEU|FEU|vessel_calls|DWT|tonnes|CBM|revenue_usd — 7 candidates stripped; promote to reference product]',
    `committed_volume` DECIMAL(18,2) COMMENT 'The minimum volume or throughput quantity that the stakeholder has committed to deliver or utilize during the commitment period. Measured in the unit specified by commitment_unit.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this volume commitment record was first created in the system. Used for audit trail and data lineage.',
    `dispute_raised_date` DATE COMMENT 'The date on which the dispute regarding this commitment was formally raised by the stakeholder or port authority.',
    `dispute_reason` STRING COMMENT 'Free-text explanation of the reason for dispute if commitment_status is in_dispute. Captures stakeholder objections or measurement disagreements.',
    `effective_from_date` DATE COMMENT 'The date from which this volume commitment becomes binding and measurement begins.',
    `effective_to_date` DATE COMMENT 'The date on which this volume commitment expires or ceases to be binding. Nullable for open-ended commitments.',
    `excess_volume` DECIMAL(18,2) COMMENT 'The amount by which actual_volume_to_date exceeds committed_volume. Used to calculate incentive payments or rebates. Nullable if commitment is not exceeded.',
    `incentive_amount_earned` DECIMAL(18,2) COMMENT 'The total monetary incentive or rebate earned for exceeding the commitment in the current or most recent commitment period. Calculated based on incentive_type and incentive_rate. Business-confidential commercial term.',
    `incentive_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the incentive amount (e.g., USD, EUR, SGD).. Valid values are `^[A-Z]{3}$`',
    `incentive_rate` DECIMAL(18,2) COMMENT 'The rate or amount applied to calculate the incentive for exceeding the commitment. Interpretation depends on incentive_type (e.g., USD per TEU, percentage, or fixed USD amount). Business-confidential commercial term.',
    `incentive_type` STRING COMMENT 'Classification of the incentive or rebate structure applied when the commitment is exceeded. Defines whether the incentive is a per-unit rebate, percentage discount, fixed bonus, tiered rebate, or none.. Valid values are `per_unit_rebate|percentage_discount|fixed_bonus|tiered_rebate|none`',
    `last_measurement_date` DATE COMMENT 'The date on which the actual_volume_to_date was last calculated or updated. Used for performance tracking and reporting.',
    `last_modified_by` STRING COMMENT 'Identifier or name of the user or system process that last modified this volume commitment record.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this volume commitment record was last updated. Used for audit trail and change tracking.',
    `measurement_basis` STRING COMMENT 'Defines the operational metric or data source used to measure performance against the commitment (e.g., actual throughput, billed throughput, manifested cargo, vessel arrivals, or gross revenue).. Valid values are `actual_throughput|billed_throughput|manifested_cargo|vessel_arrivals|gross_revenue`',
    `next_review_date` DATE COMMENT 'The scheduled date for the next formal review or reconciliation of this volume commitment against actual performance.',
    `notes` STRING COMMENT 'Free-text field for additional context, special conditions, or operational notes related to this volume commitment.',
    `penalty_amount_assessed` DECIMAL(18,2) COMMENT 'The total monetary penalty assessed for shortfall in the current or most recent commitment period. Calculated based on penalty_type and penalty_rate. Business-confidential commercial term.',
    `penalty_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the penalty amount (e.g., USD, EUR, SGD).. Valid values are `^[A-Z]{3}$`',
    `penalty_rate` DECIMAL(18,2) COMMENT 'The rate or amount applied to calculate the penalty for shortfall. Interpretation depends on penalty_type (e.g., USD per TEU, percentage, or fixed USD amount). Business-confidential commercial term.',
    `penalty_type` STRING COMMENT 'Classification of the penalty structure applied when the commitment is not met. Defines whether the penalty is calculated per unit of shortfall, as a percentage, a fixed amount, tiered based on shortfall magnitude, or none.. Valid values are `per_unit|percentage_of_shortfall|fixed_amount|tiered|none`',
    `renewal_notice_days` STRING COMMENT 'Number of days prior to effective_to_date that either party must provide notice if they wish to terminate or renegotiate the commitment. Nullable if auto-renewal is not applicable.',
    `shortfall_volume` DECIMAL(18,2) COMMENT 'The difference between committed_volume and actual_volume_to_date when actual performance falls below the commitment. Nullable if commitment is met or exceeded.',
    `waiver_approved_by` STRING COMMENT 'Name or identifier of the port authority or commercial manager who approved the waiver or suspension of this commitment.',
    `waiver_approved_date` DATE COMMENT 'The date on which the waiver or suspension of this commitment was formally approved.',
    `waiver_reason` STRING COMMENT 'Free-text explanation for why the commitment was waived or suspended. Captures business context such as force majeure, mutual agreement, or operational disruption.',
    CONSTRAINT pk_volume_commitment PRIMARY KEY(`volume_commitment_id`)
) COMMENT 'Tracks minimum volume commitments and throughput guarantees stipulated in port service agreements with shipping lines and cargo owners. Captures commitment period (annual, quarterly, monthly), commitment type (minimum_TEU, minimum_vessel_calls, minimum_DWT, minimum_cargo_tonnes), committed volume, committed unit, penalty for shortfall (per_TEU, percentage_of_shortfall), incentive for exceeding commitment, measurement basis, and commitment status (active, waived, in_dispute). Critical for revenue assurance and commercial performance management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` (
    `pil_arrangement_id` BIGINT COMMENT 'Unique identifier for the Port Infrastructure Levy arrangement record. Primary key.',
    `agreement_id` BIGINT COMMENT 'Reference to the parent commercial agreement or concession contract to which this PIL arrangement applies.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: PIL arrangement creation audit trail requires employee reference for accountability in port infrastructure levy configuration.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Port Infrastructure Levy (PIL) collections must post to specific statutory GL accounts. Required for PIL accounting, remittance to regulatory authority, and statutory financial reporting compliance.',
    `approved_by` STRING COMMENT 'User ID or name of the authorized person who approved this PIL arrangement. Nullable for draft or unapproved arrangements.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when this PIL arrangement was formally approved and transitioned to active status. Nullable for draft or unapproved arrangements.',
    `arrangement_code` STRING COMMENT 'Business identifier for the PIL arrangement, typically formatted as PIL- followed by alphanumeric code for external reference and reporting.. Valid values are `^PIL-[A-Z0-9]{6,12}$`',
    `arrangement_name` STRING COMMENT 'Descriptive name of the PIL arrangement for business users, typically indicating the counterparty and levy type.',
    `arrangement_status` STRING COMMENT 'Current lifecycle status of the PIL arrangement. Draft indicates pending approval, active indicates in force, suspended indicates temporarily halted, expired indicates past end date, terminated indicates early cancellation, under_review indicates regulatory or compliance review in progress.. Valid values are `draft|active|suspended|expired|terminated|under_review`',
    `audit_trail_required` BOOLEAN COMMENT 'Indicates whether detailed transaction-level audit trail must be maintained for PIL assessments under this arrangement. True indicates audit trail mandatory, False indicates summary reporting sufficient.',
    `calculation_basis` STRING COMMENT 'The underlying metric or measure upon which the PIL is assessed. Cargo_value for ad-valorem levies, vessel tonnage measures for vessel-based levies, throughput measures for container-based levies, berth_hours for time-based levies, cargo_tonnage for weight-based levies. [ENUM-REF-CANDIDATE: cargo_value|vessel_grt|vessel_nrt|vessel_dwt|teu_throughput|feu_throughput|berth_hours|cargo_tonnage — 8 candidates stripped; promote to reference product]',
    `collection_responsibility` STRING COMMENT 'Party responsible for collecting the PIL. Port_collects indicates the port authority directly invoices and collects, operator_remits indicates the terminal operator or concessionaire collects and remits to the port, third_party_collects indicates a customs broker or agent collects, self_assessed indicates the liable party self-reports and pays.. Valid values are `port_collects|operator_remits|third_party_collects|self_assessed`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this PIL arrangement record was first created in the system.',
    `dispute_resolution_mechanism` STRING COMMENT 'Agreed mechanism for resolving disputes related to PIL assessment, calculation, or payment under this arrangement.. Valid values are `internal_review|arbitration|mediation|regulatory_appeal|court_jurisdiction`',
    `effective_from_date` DATE COMMENT 'Date from which the PIL arrangement becomes binding and PIL assessment commences.',
    `effective_to_date` DATE COMMENT 'Date on which the PIL arrangement expires or terminates. Nullable for open-ended arrangements subject to annual review.',
    `escalation_clause` STRING COMMENT 'Method by which the PIL rate may be adjusted over time. None indicates no automatic escalation, cpi_indexed indicates annual adjustment by consumer price index, fixed_annual indicates predetermined percentage increase, negotiated indicates periodic renegotiation, regulatory_review indicates adjustment subject to regulatory approval.. Valid values are `none|cpi_indexed|fixed_annual|negotiated|regulatory_review`',
    `escalation_rate` DECIMAL(18,2) COMMENT 'Annual percentage rate of escalation for fixed_annual escalation clause. Nullable for other escalation types.',
    `exemption_flag` BOOLEAN COMMENT 'Indicates whether this arrangement includes an exemption or waiver from standard PIL obligations. True indicates exemption applies, False indicates standard levy applies.',
    `exemption_percentage` DECIMAL(18,2) COMMENT 'Percentage of PIL exempted or waived under this arrangement. 100.00 indicates full exemption, values less than 100 indicate partial exemption. Nullable when exemption_flag is False.',
    `exemption_reason` STRING COMMENT 'Business justification for PIL exemption or waiver, such as government vessel, humanitarian cargo, strategic national interest, or regulatory exemption. Populated only when exemption_flag is True.',
    `last_escalation_date` DATE COMMENT 'Date on which the PIL rate was last escalated or adjusted. Used to track escalation history and determine next escalation due date.',
    `last_modified_by` STRING COMMENT 'User ID or name of the person who last modified this PIL arrangement record.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this PIL arrangement record was last updated.',
    `maximum_levy_amount` DECIMAL(18,2) COMMENT 'Maximum PIL amount payable per assessment period or transaction, capping the levy for high-value or high-volume transactions. Nullable if no cap applies.',
    `minimum_levy_amount` DECIMAL(18,2) COMMENT 'Minimum PIL amount payable per assessment period or transaction, regardless of calculated amount. Ensures a floor levy for small transactions. Nullable if no minimum applies.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next formal review of the PIL arrangement terms, rates, or compliance. Nullable for arrangements not subject to periodic review.',
    `notes` STRING COMMENT 'Free-text field for additional business context, special conditions, or operational notes related to the PIL arrangement.',
    `rate_currency` STRING COMMENT 'Three-letter ISO 4217 currency code in which the PIL rate is denominated (e.g., USD, EUR, AUD).. Valid values are `^[A-Z]{3}$`',
    `rate_type` STRING COMMENT 'Method by which the PIL is calculated. Fixed indicates a flat fee per transaction or period, ad_valorem indicates percentage of cargo value, per_teu/per_feu indicates per container unit, per_grt/per_nrt/per_dwt indicates per vessel tonnage measure, tiered indicates variable rate based on volume thresholds. [ENUM-REF-CANDIDATE: fixed|ad_valorem|per_teu|per_feu|per_grt|per_nrt|per_dwt|tiered — 8 candidates stripped; promote to reference product]',
    `rate_value` DECIMAL(18,2) COMMENT 'Numeric value of the PIL rate. Interpretation depends on rate_type: for fixed, the flat amount; for ad_valorem, the percentage (e.g., 2.5 for 2.5%); for per-unit rates, the amount per unit.',
    `regulatory_authority` STRING COMMENT 'Government body or regulatory authority that oversees and enforces PIL compliance, such as National Maritime Safety Authority or Port State Control.',
    `regulatory_instrument` STRING COMMENT 'Legal or regulatory instrument under which the PIL is authorized and governed, such as Port Authority Act, Maritime Services Regulation, or specific statutory instrument number.',
    `remittance_due_day` STRING COMMENT 'Day of the period (e.g., day of month for monthly remittance) by which PIL remittance must be completed. Nullable for per-transaction remittance.',
    `remittance_frequency` STRING COMMENT 'Frequency at which collected PIL amounts must be remitted to the port authority or designated account. Per_transaction indicates immediate remittance upon collection. [ENUM-REF-CANDIDATE: daily|weekly|fortnightly|monthly|quarterly|annually|per_transaction — 7 candidates stripped; promote to reference product]',
    `reporting_category` STRING COMMENT 'Classification of the PIL for financial and regulatory reporting purposes. Aligns with statutory reporting requirements and revenue recognition standards.. Valid values are `infrastructure_levy|statutory_charge|concession_fee|regulatory_levy|environmental_levy`',
    `revenue_allocation_code` STRING COMMENT 'General Ledger or financial system code to which collected PIL revenue is allocated for accounting and reporting purposes.. Valid values are `^[A-Z0-9]{4,10}$`',
    CONSTRAINT pk_pil_arrangement PRIMARY KEY(`pil_arrangement_id`)
) COMMENT 'Master records for Port Infrastructure Levy (PIL) arrangements, capturing the specific terms under which PIL is assessed, collected, and remitted for each commercial agreement or concession. Stores PIL rate type (fixed, ad_valorem, per_TEU, per_GRT), PIL rate value, PIL currency, PIL calculation basis (cargo_value, vessel_GRT, TEU_throughput), PIL collection responsibility (port_collects, operator_remits), PIL remittance frequency, PIL exemption flag, PIL exemption reason, applicable regulatory instrument, and PIL arrangement status. PIL is a statutory levy in many port jurisdictions and requires dedicated tracking.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` (
    `contract_document_id` BIGINT COMMENT 'Unique identifier for the contract document record. Primary key for the contract document registry.',
    `agreement_id` BIGINT COMMENT 'Reference to the parent commercial agreement to which this document belongs. Links document to the master contract record.',
    `agreement_version_id` BIGINT COMMENT 'Foreign key linking to contract.agreement_version. Business justification: Contract documents are often version-specific (e.g., signed copy of Amendment 3, addendum to Version 2.1). Currently contract_document links to agreement but not to the specific version. This FK provi',
    `facility_security_plan_id` BIGINT COMMENT 'Foreign key linking to security.facility_security_plan. Business justification: Concession agreements and terminal operating agreements must reference the approved Port Facility Security Plan as a compliance attachment per ISPS Code requirements. Regulatory audits verify that com',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Document management audit trail requires employee reference for accountability in contract document lifecycle and compliance record-keeping.',
    `access_count` STRING COMMENT 'Total number of times the document has been accessed or viewed. Indicates document importance and usage frequency.',
    `checksum_hash` STRING COMMENT 'Cryptographic hash of the document file content, typically SHA-256 or MD5. Ensures document integrity and detects unauthorized modifications.',
    `classification` STRING COMMENT 'Security classification level governing access control, distribution, and handling procedures. Aligns with port authority information security policy and International Ship and Port Facility Security (ISPS) Code requirements.. Valid values are `confidential|restricted|internal|public`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this contract document record was first created in the system. Audit trail field for record lifecycle tracking.',
    `disposal_eligible_date` DATE COMMENT 'Calculated date after which the document may be disposed of in accordance with retention policy. Derived from effective date plus retention period.',
    `document_date` DATE COMMENT 'Official date of the document as recorded on the document itself, typically the execution date, issuance date, or effective date depending on document type.',
    `document_number` STRING COMMENT 'Unique business identifier for the document, typically assigned by the document management system or legal department. Used for external reference and filing.',
    `document_status` STRING COMMENT 'Current state of the document in its lifecycle. Governs access rights, workflow routing, and legal enforceability. Executed status indicates legally binding document.. Valid values are `draft|under_review|executed|superseded|archived|cancelled`',
    `document_type` STRING COMMENT 'Classification of the document based on its legal and business purpose within the contract lifecycle. Determines handling, approval workflow, and retention requirements. [ENUM-REF-CANDIDATE: contract|addendum|annexure|bond_certificate|insurance_certificate|regulatory_approval|correspondence|board_resolution|bank_guarantee|performance_bond — 10 candidates stripped; promote to reference product]',
    `effective_from_date` DATE COMMENT 'Date from which the document becomes legally effective and enforceable. May differ from document date and signature date depending on agreement terms.',
    `expiry_date` DATE COMMENT 'Date on which the document ceases to be effective or valid. Applicable to time-bound instruments such as insurance certificates, performance bonds, and bank guarantees.',
    `file_format` STRING COMMENT 'Digital file format of the stored document. Determines rendering requirements, archival strategy, and long-term accessibility. [ENUM-REF-CANDIDATE: pdf|docx|doc|xlsx|xls|tiff|jpeg|png|msg|eml — 10 candidates stripped; promote to reference product]',
    `file_reference` STRING COMMENT 'Technical reference to the physical or digital storage location of the document. May be a Document Management System (DMS) path, object storage Uniform Resource Identifier (URI), or file system path.',
    `file_size_bytes` BIGINT COMMENT 'Size of the document file in bytes. Used for storage capacity planning, transmission bandwidth estimation, and integrity verification.',
    `issuing_authority` STRING COMMENT 'Name of the government agency, regulatory body, or institution that issued the document. Applicable to certificates, approvals, and official correspondence.',
    `keywords` STRING COMMENT 'Comma-separated list of keywords or tags associated with the document to facilitate search, discovery, and categorization.',
    `language` STRING COMMENT 'Primary language in which the document is written, using ISO 639-1 two-letter language codes. Supports multilingual document management and translation requirements.',
    `last_accessed_timestamp` TIMESTAMP COMMENT 'Date and time when the document was last accessed or viewed by any user. Supports usage analytics and compliance monitoring.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this contract document record was last updated. Audit trail field for change tracking and data lineage.',
    `notarisation_date` DATE COMMENT 'Date on which the document was notarized. Applicable only when notarisation_flag is true.',
    `notarisation_flag` BOOLEAN COMMENT 'Indicates whether the document has been notarized by a licensed notary public or equivalent authority. Required for certain legal instruments and international agreements.',
    `notary_name` STRING COMMENT 'Name of the notary public who notarized the document. Applicable only when notarisation_flag is true.',
    `notary_registration_number` STRING COMMENT 'Official registration or license number of the notary public. Enables verification of notary credentials and authority.',
    `page_count` STRING COMMENT 'Total number of pages in the document. Relevant for printing, scanning, and document completeness verification.',
    `regulatory_approval_number` STRING COMMENT 'Official reference number assigned by the regulatory authority for approved documents. Applicable to regulatory approvals, permits, and compliance certificates.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, comments, or context about the document that do not fit into structured fields. Supports operational annotations and special handling instructions.',
    `retention_period_years` STRING COMMENT 'Number of years the document must be retained to comply with legal, regulatory, and business requirements. Drives archival and disposal scheduling.',
    `signatory_name` STRING COMMENT 'Name of the authorized person who signed or executed the document on behalf of the port authority or counterparty. Critical for legal enforceability and audit trail.',
    `signatory_organization` STRING COMMENT 'Legal name of the organization represented by the signatory. Identifies the party bound by the document.',
    `signatory_title` STRING COMMENT 'Official title or position of the signatory at the time of execution. Establishes authority to bind the organization to the agreement.',
    `signature_date` DATE COMMENT 'Date on which the document was signed or executed by the authorized signatory. May differ from document date and establishes legal effectiveness.',
    `title` STRING COMMENT 'Full descriptive title of the document as it appears on the document itself. Provides human-readable identification of document content and purpose.',
    `translation_required_flag` BOOLEAN COMMENT 'Indicates whether the document requires translation to another language for legal, operational, or regulatory purposes.',
    `upload_timestamp` TIMESTAMP COMMENT 'Date and time when the document was uploaded to the document management system. Establishes audit trail for document receipt and processing.',
    `version` STRING COMMENT 'Version identifier for the document, tracking revisions and amendments over time. Supports version control and audit trail requirements.',
    `witness_contact` STRING COMMENT 'Contact details for the witness, typically phone number or email address. Enables verification and follow-up if required for legal proceedings.',
    `witness_name` STRING COMMENT 'Name of the witness who attested to the signing of the document. Required for certain legal instruments and jurisdictions.',
    CONSTRAINT pk_contract_document PRIMARY KEY(`contract_document_id`)
) COMMENT 'Registry of all formal documents associated with commercial agreements, including signed contracts, addenda, annexures, performance bonds, insurance certificates, regulatory approvals, bank guarantee instruments, and commercial correspondence. Captures document type (contract, addendum, annexure, bond_certificate, insurance_certificate, regulatory_approval, correspondence, board_resolution), document title, document version, document date, document status (draft, under_review, executed, superseded, archived), file reference (DMS path or object storage URI), file format, page count, signatory details, notarisation flag, and document classification (confidential, restricted, internal). Provides the document management layer for the contract domain, supporting audit trail requirements and regulatory evidence retention.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` (
    `penalty_clause_id` BIGINT COMMENT 'Unique identifier for the penalty or incentive clause within a commercial contract. Primary key.',
    `agreement_id` BIGINT COMMENT 'Reference to the parent commercial agreement (service agreement, concession, stevedoring contract) that contains this penalty or incentive clause.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Penalty clause creation audit trail requires employee reference for accountability in contractual penalty framework establishment.',
    `service_scope_id` BIGINT COMMENT 'Foreign key linking to contract.service_scope. Business justification: Penalty clauses often apply to specific service scopes (e.g., penalty for container dwell time exceeding 5 days applies to container terminal services only). Currently penalty_clause has applicable_se',
    `assessment_frequency` STRING COMMENT 'How often the penalty or incentive is calculated and assessed (e.g., per_occurrence for immediate assessment after each trigger event, monthly for aggregated monthly assessment, at_contract_end for final reconciliation).. Valid values are `per_occurrence|monthly|quarterly|annually|at_contract_end`',
    `calculation_method` STRING COMMENT 'The methodology used to compute the penalty or incentive amount: fixed_amount (flat fee), per_unit (rate multiplied by shortfall/excess units), percentage_of_contract_value (proportional to contract value), tiered_schedule (stepped rates based on severity).. Valid values are `fixed_amount|per_unit|percentage_of_contract_value|tiered_schedule`',
    `clause_reference_number` STRING COMMENT 'The externally-known clause identifier or section number within the contract document (e.g., Section 7.3.2, Clause P-04, Annex B Item 5).',
    `clause_status` STRING COMMENT 'Current lifecycle state of the penalty or incentive clause: active (in force), suspended (temporarily not enforced), waived (permanently forgiven by mutual agreement), expired (no longer applicable).. Valid values are `active|suspended|waived|expired`',
    `clause_type` STRING COMMENT 'Classification of the consequence clause: liquidated_damages (pre-agreed compensation for breach), performance_penalty (underperformance charge), shortfall_penalty (volume/commitment shortfall), delay_penalty (time-based penalty), incentive_bonus (reward for exceeding targets), rebate (volume-based discount).. Valid values are `liquidated_damages|performance_penalty|shortfall_penalty|delay_penalty|incentive_bonus|rebate`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this penalty clause record was first created in the system. Audit trail field.',
    `cumulative_trigger_flag` BOOLEAN COMMENT 'Indicates whether the trigger condition is evaluated cumulatively over multiple measurement periods (True) or independently for each period (False). For example, True if three consecutive months of underperformance are required to trigger the penalty.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this clause (penalty rates, caps, incentive amounts).. Valid values are `^[A-Z]{3}$`',
    `dispute_resolution_process` STRING COMMENT 'Description of the agreed process for resolving disputes related to the application or calculation of this penalty or incentive clause (e.g., Escalation to Port Director and Shipping Line VP Operations, Third-party arbitration per ICC rules, Joint review committee within 30 days).',
    `effective_from_date` DATE COMMENT 'The date from which this penalty or incentive clause becomes active and enforceable. Aligns with contract effective date or amendment date.',
    `effective_until_date` DATE COMMENT 'The date on which this penalty or incentive clause ceases to be enforceable. Aligns with contract expiry, renewal, or amendment date. Null for open-ended clauses.',
    `grace_period_unit` STRING COMMENT 'Unit of measure for the grace period (e.g., days, hours, vessel_calls, occurrences). Null if no grace period applies.. Valid values are `days|hours|vessel_calls|occurrences`',
    `grace_period_value` STRING COMMENT 'The number of time units (days, hours, vessel calls) allowed before the penalty or incentive clause becomes enforceable after the trigger condition is first met. Provides a buffer for minor or transient deviations. Null if no grace period applies.',
    `incentive_maximum_cap_amount` DECIMAL(18,2) COMMENT 'The maximum total incentive or bonus amount that can be earned under this clause, regardless of the level of overperformance. Null if no cap applies.',
    `incentive_rate_value` DECIMAL(18,2) COMMENT 'The numeric rate or amount used to calculate the incentive or bonus when the trigger condition is met. For per_unit method, this is the rate per excess unit; for percentage_of_contract_value, this is the percentage; for fixed_amount, this is the flat bonus amount.',
    `last_modified_by_user` STRING COMMENT 'Username or identifier of the system user who last modified this penalty clause record. Audit trail field.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this penalty clause record was last updated. Audit trail field.',
    `measurement_period_type` STRING COMMENT 'The time window or event basis over which performance is measured and the trigger condition is evaluated (e.g., per_vessel_call for individual vessel performance, monthly for aggregate monthly metrics, annually for volume commitments). [ENUM-REF-CANDIDATE: per_vessel_call|daily|weekly|monthly|quarterly|annually|contract_term — 7 candidates stripped; promote to reference product]',
    `notes` STRING COMMENT 'Additional free-text notes, clarifications, or special conditions related to the interpretation or application of this penalty or incentive clause.',
    `penalty_maximum_cap_amount` DECIMAL(18,2) COMMENT 'The maximum total penalty amount that can be assessed under this clause, regardless of the severity of underperformance. Protects against unlimited liability. Null if no cap applies.',
    `penalty_rate_value` DECIMAL(18,2) COMMENT 'The numeric rate or amount used to calculate the penalty when the trigger condition is met. For per_unit method, this is the rate per unit; for percentage_of_contract_value, this is the percentage (e.g., 2.5 for 2.5%); for fixed_amount, this is the flat penalty amount.',
    `trigger_comparison_operator` STRING COMMENT 'The logical operator used to evaluate the trigger condition (e.g., less_than for penalties when performance drops below threshold, greater_than for incentives when performance exceeds target).. Valid values are `less_than|less_than_or_equal|greater_than|greater_than_or_equal|equal|not_equal`',
    `trigger_condition_description` STRING COMMENT 'Detailed narrative of the business condition that activates this penalty or incentive (e.g., Crane productivity falls below 28 moves per hour for three consecutive vessel calls, Annual TEU throughput exceeds committed volume by 10%).',
    `trigger_metric` STRING COMMENT 'The specific Key Performance Indicator (KPI) or measurement that is evaluated to determine if the trigger condition is met (e.g., crane_moves_per_hour, annual_teu_throughput, vessel_turnaround_time_hours, berth_utilization_percent).',
    `trigger_threshold_unit` STRING COMMENT 'Unit of measure for the trigger threshold (e.g., moves_per_hour, TEU, hours, percent, days, vessel_calls).',
    `trigger_threshold_value` DECIMAL(18,2) COMMENT 'The numeric threshold that, when crossed, activates the penalty or incentive clause (e.g., 28.0 for crane moves per hour, 500000 for annual TEU commitment).',
    `waiver_approved_by` STRING COMMENT 'Name or role of the authority who approved the waiver or suspension of this clause (e.g., Chief Commercial Officer, Port Director, Contract Review Board). Populated only when clause_status is waived or suspended.',
    `waiver_approved_date` DATE COMMENT 'Date on which the waiver or suspension of this clause was formally approved. Populated only when clause_status is waived or suspended.',
    `waiver_reason` STRING COMMENT 'Business justification for waiving or suspending this clause (e.g., Force majeure - typhoon disruption, Mutual agreement during COVID-19 pandemic, Equipment failure beyond operator control). Populated only when clause_status is waived or suspended.',
    CONSTRAINT pk_penalty_clause PRIMARY KEY(`penalty_clause_id`)
) COMMENT 'Master catalog of contractual consequence clauses — penalties for underperformance and incentives for exceeding targets — embedded within port commercial agreements. Captures clause type (liquidated_damages, performance_penalty, shortfall_penalty, delay_penalty, incentive_bonus, rebate), trigger condition description, trigger metric (e.g., crane moves/hour below threshold, TEU shortfall vs commitment), trigger threshold, penalty/incentive calculation method (fixed_amount, per_unit, percentage_of_contract_value), penalty rate value, maximum penalty cap, incentive rate value, incentive cap, currency, applicable service scope reference, and clause status (active, suspended, waived). Distinct from rate_schedule (which defines service pricing) and from penalty_assessment (which records actual assessed amounts). This product owns the contractual if-then logic: IF a trigger condition is met, THEN this financial consequence applies.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` (
    `penalty_assessment_id` BIGINT COMMENT 'Unique identifier for the penalty assessment record. Primary key.',
    `agreement_id` BIGINT COMMENT 'Reference to the parent contract or service agreement under which this assessment was raised.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Penalty assessment approval authority requires employee reference for financial governance and authorization control in penalty enforcement.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Penalties are allocated to responsible cost centres for operational accountability. Required for cost centre performance evaluation and linking SLA breaches to operational responsibility.',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Penalties for clearance delays must reference the specific customs hold causing the breach. Required for penalty justification, dispute resolution, and determining whether delays were within ports co',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Penalty revenue/expense must post to specific GL accounts for financial reporting and audit trail. Required for penalty revenue recognition, financial statement preparation, and regulatory compliance ',
    `invoice_id` BIGINT COMMENT 'Reference to the invoice record into which this assessment was incorporated for billing purposes.',
    `item_id` BIGINT COMMENT 'Foreign key linking to tariff.tariff_item. Business justification: Penalty assessments reference specific tariff items for rate application when calculating financial penalties. Tariff items define the charge codes and rates applied to penalty calculations. Essential',
    `participant_account_id` BIGINT COMMENT 'Reference to the port community participant (shipping line, stevedore, terminal operator, or other stakeholder) against whom this assessment is raised.',
    `penalty_clause_id` BIGINT COMMENT 'Foreign key linking to contract.penalty_clause. Business justification: Penalty assessments are triggered by contractual penalty clauses. This FK links the transactional assessment record to the master clause definition, enabling traceability from financial consequence ba',
    `call_id` BIGINT COMMENT 'Foreign key linking to vessel.call. Business justification: Penalty assessments often reference specific port calls as evidence of SLA breaches (e.g., turnaround time violations, productivity failures). Required for dispute resolution, billing verification, an',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Penalty impact on profit centre P&L for segment profitability adjustment. Required for accurate profit centre reporting and management decisions on service quality vs profitability trade-offs.',
    `sla_profile_id` BIGINT COMMENT 'Reference to the SLA profile that defines the performance thresholds and penalty terms applicable to this assessment.',
    `volume_commitment_id` BIGINT COMMENT 'Foreign key linking to contract.volume_commitment. Business justification: Some penalty assessments are triggered by volume commitment shortfalls (e.g., customer failed to meet minimum throughput guarantee). This FK links the assessment to the specific commitment that was br',
    `adjusted_amount` DECIMAL(18,2) COMMENT 'The revised financial amount after dispute resolution, reflecting any negotiated reductions or increases to the net amount.',
    `approved_date` DATE COMMENT 'The date on which the assessment was formally approved for issuance by the authorized manager.',
    `assessed_metric_name` STRING COMMENT 'The name of the performance metric or operational measure that was assessed (e.g., Vessel Turnaround Time, TEU Throughput, Berth Utilization, Gate Processing Time).',
    `assessed_unit_of_measure` STRING COMMENT 'The unit of measure for the assessed value: TEU (Twenty-foot Equivalent Unit), FEU (Forty-foot Equivalent Unit), CBM (Cubic Meter), MT (Metric Ton), hours, days, percent, count, or moves. [ENUM-REF-CANDIDATE: TEU|FEU|CBM|MT|hours|days|percent|count|moves — 9 candidates stripped; promote to reference product]',
    `assessed_value` DECIMAL(18,2) COMMENT 'The actual measured value of the metric or throughput that was assessed (e.g., 1250.5 TEU, 48.75 hours, 85.3 percent).',
    `assessment_date` DATE COMMENT 'The date on which the penalty or incentive assessment was formally raised and recorded in the system.',
    `assessment_number` STRING COMMENT 'Externally visible unique business identifier for the penalty assessment, formatted as PA-YYYYNNNN.. Valid values are `^PA-[0-9]{8}$`',
    `assessment_period_end` DATE COMMENT 'The end date of the billing or performance period to which this assessment applies.',
    `assessment_period_start` DATE COMMENT 'The start date of the billing or performance period to which this assessment applies.',
    `assessment_status` STRING COMMENT 'Current lifecycle status of the penalty assessment: draft (under review), issued (formally communicated to participant), disputed (under dispute resolution), settled (dispute resolved), waived (cancelled by management), or paid (financially settled).. Valid values are `draft|issued|disputed|settled|waived|paid`',
    `assessment_type` STRING COMMENT 'Classification of the financial assessment: penalty (contractual breach), incentive (performance bonus), PIL (Port Infrastructure Levy), liquidated_damages (pre-agreed compensation), demurrage (vessel delay charge), or detention (container overstay charge).. Valid values are `penalty|incentive|pil|liquidated_damages|demurrage|detention`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this penalty assessment record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this assessment (e.g., USD, EUR, GBP, AUD).. Valid values are `^[A-Z]{3}$`',
    `dispute_date` DATE COMMENT 'The date on which the participant formally lodged a dispute against this assessment.',
    `dispute_flag` BOOLEAN COMMENT 'Indicates whether the participant has formally disputed this assessment (True if disputed, False otherwise).',
    `dispute_reason` STRING COMMENT 'Textual explanation provided by the participant for disputing the assessment, including supporting evidence references.',
    `dispute_resolution_date` DATE COMMENT 'The date on which the dispute was formally resolved, either through negotiation, arbitration, or management decision.',
    `exemption_amount` DECIMAL(18,2) COMMENT 'The monetary value of the exemption or waiver applied, reducing the gross amount.',
    `exemption_applied_flag` BOOLEAN COMMENT 'Indicates whether a contractual exemption or waiver clause was applied to reduce or eliminate the assessment (True if exemption applied, False otherwise).',
    `exemption_reason` STRING COMMENT 'Textual explanation of the reason for exemption, such as force majeure, weather delay, port authority directive, or other contractual relief clause.',
    `final_amount` DECIMAL(18,2) COMMENT 'The final confirmed amount payable or receivable, representing the settled value after all exemptions, disputes, and adjustments have been applied.',
    `gross_amount` DECIMAL(18,2) COMMENT 'The gross financial amount of the assessment before any exemptions, adjustments, or disputes are applied.',
    `issued_date` DATE COMMENT 'The date on which the assessment was formally issued to the participant, triggering the payment due date calculation.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this penalty assessment record was last updated or modified.',
    `net_amount` DECIMAL(18,2) COMMENT 'The net financial amount payable after exemptions are applied but before any dispute adjustments (gross amount minus exemption amount).',
    `notes` STRING COMMENT 'Free-text field for additional comments, context, or special instructions related to this assessment, including references to supporting documentation or correspondence.',
    `payment_due_date` DATE COMMENT 'The contractual date by which payment of the final amount is due from the participant.',
    `payment_terms_days` STRING COMMENT 'The number of days from the issued date within which payment is due, as defined in the contract (e.g., 30 days, 60 days).',
    `rate_applied` DECIMAL(18,2) COMMENT 'The penalty or incentive rate applied per unit of variance or per occurrence, as defined in the contract (e.g., USD 50 per TEU shortfall, USD 100 per hour of delay).',
    `rate_unit` STRING COMMENT 'The unit basis for the applied rate: per TEU, per FEU, per hour, per day, per occurrence, per metric ton, per move, or flat fee. [ENUM-REF-CANDIDATE: per_TEU|per_FEU|per_hour|per_day|per_occurrence|per_MT|per_move|flat_fee — 8 candidates stripped; promote to reference product]',
    `settlement_date` DATE COMMENT 'The actual date on which the financial settlement was completed, either through payment receipt or formal waiver.',
    `threshold_value` DECIMAL(18,2) COMMENT 'The contractual threshold or target value that was breached or achieved, triggering the assessment (e.g., minimum throughput commitment, maximum turnaround time).',
    `triggering_event_reference` STRING COMMENT 'Reference identifier to the specific operational event that triggered this assessment, such as an SLA (Service Level Agreement) breach incident number, vessel delay record, or throughput shortfall report.',
    `triggering_event_type` STRING COMMENT 'Classification of the event that triggered the assessment: SLA breach, volume shortfall, delay, throughput target miss, safety violation, environmental breach, or other contractual non-compliance. [ENUM-REF-CANDIDATE: sla_breach|volume_shortfall|delay|throughput_target|safety_violation|environmental_breach|other — 7 candidates stripped; promote to reference product]',
    `variance_value` DECIMAL(18,2) COMMENT 'The calculated variance between the assessed value and the threshold value (assessed minus threshold), indicating the magnitude of over-performance or under-performance.',
    CONSTRAINT pk_penalty_assessment PRIMARY KEY(`penalty_assessment_id`)
) COMMENT 'Transactional records of all contractual financial assessments including penalty assessments, incentive calculations, and PIL (Port Infrastructure Levy) assessments raised against contracted terms for each billing period. Captures assessment type (penalty, incentive, PIL, liquidated_damages), assessment date, assessment period, triggering event reference (SLA breach, volume shortfall, delay, throughput), applicable clause or arrangement reference, assessed throughput or metric, rate applied, gross amount, exemptions applied, net amount payable, currency, dispute flag, dispute reason, adjusted amount (post-dispute), final amount, assessment status (draft, issued, disputed, settled, waived, paid), payment due date, and settlement date. Feeds into the billing domain for invoice generation and provides the transactional audit trail for revenue recognition and regulatory compliance.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` (
    `dispute_record_id` BIGINT COMMENT 'Unique identifier for the commercial dispute record. Primary key for the dispute_record product.',
    `agreement_id` BIGINT COMMENT 'Reference to the contract under which this dispute arose. Links to the contract master data.',
    `violation_id` BIGINT COMMENT 'Foreign key linking to compliance.violation. Business justification: Disputes arise from compliance violations (ISPS breaches, MARPOL violations, dangerous goods handling) affecting service delivery or triggering penalties. Required for liability determination, penalty',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Contract disputes over duty assessments, cargo classification, clearance delays, or penalty charges reference specific customs declarations. Essential for dispute resolution, evidence gathering, and d',
    `invoice_id` BIGINT COMMENT 'Reference to the invoice that is the subject of the dispute, if the dispute is billing-related. Links to the invoice product.',
    `participant_account_id` BIGINT COMMENT 'Reference to the contract counterparty involved in the dispute. Links to the port_community_participant or participant_account master data.',
    `penalty_assessment_id` BIGINT COMMENT 'Foreign key linking to contract.penalty_assessment. Business justification: Commercial disputes often arise from penalty assessments (e.g., customer disputes the penalty calculation or applicability). This FK links the dispute to the assessment that triggered it, providing tr',
    `employee_id` BIGINT COMMENT 'Reference to the port employee responsible for managing and resolving the dispute. Links to the employee product.',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Disputes may arise from procurement delivery failures impacting agreement performance (late equipment delivery causing SLA breach, defective parts causing service disruption). Business process: root c',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Commercial disputes frequently arise from security-related operational disruptions—denied facility access, cargo delays due to enhanced screening, vessel diversions during MARSEC level changes. Disput',
    `sla_breach_id` BIGINT COMMENT 'Foreign key linking to contract.sla_breach. Business justification: Disputes can arise from SLA breach events (e.g., customer disputes whether a breach actually occurred or disputes the root cause). Currently dispute_record links to sla_profile (the definition catalog',
    `sla_profile_id` BIGINT COMMENT 'Reference to the SLA profile that is the subject of the dispute, if the dispute is SLA-related. Links to the sla_profile product.',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to procurement.vendor. Business justification: Disputes in port agreements may involve vendors who are also procurement suppliers (service quality disputes with equipment suppliers). Business process: holistic vendor relationship management, dispu',
    `arbitration_body` STRING COMMENT 'Name of the arbitration institution or body handling the dispute if resolution_method is arbitration (e.g., International Chamber of Commerce (ICC), Singapore International Arbitration Centre (SIAC), London Maritime Arbitrators Association (LMAA)).',
    `confidentiality_flag` BOOLEAN COMMENT 'Indicates whether the dispute and its resolution are subject to confidentiality or non-disclosure obligations. True if confidential, False if not.',
    `corrective_action_taken` STRING COMMENT 'Description of corrective actions implemented by the port to prevent recurrence of similar disputes (e.g., process improvements, system enhancements, staff training, contract clarifications).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this dispute record was first created in the system. Audit trail field.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the disputed amount (e.g., USD, EUR, GBP, SGD).. Valid values are `^[A-Z]{3}$`',
    `dispute_description` STRING COMMENT 'Detailed narrative description of the dispute, including the nature of the disagreement, the facts in contention, and the basis for the claim or defense.',
    `dispute_number` STRING COMMENT 'Externally-known unique business identifier for the dispute, used in correspondence and legal documentation. Format: DSP-YYYYNNNN.. Valid values are `^DSP-[0-9]{8}$`',
    `dispute_status` STRING COMMENT 'Current state of the dispute in its resolution lifecycle: open (newly raised), under_review (being assessed), negotiation (parties discussing), mediation (third-party facilitation), arbitration (formal arbitration process), litigation (court proceedings), resolved (settled), or withdrawn (dispute retracted). [ENUM-REF-CANDIDATE: open|under_review|negotiation|mediation|arbitration|litigation|resolved|withdrawn — 8 candidates stripped; promote to reference product]',
    `dispute_type` STRING COMMENT 'Classification of the dispute by its nature: billing disputes (invoice disagreements), SLA breach disputes (service level violations), penalty disputes (demurrage/detention/wharfage disagreements), interpretation disputes (contractual clause ambiguity), tariff disputes (rate disagreements), or service quality disputes.. Valid values are `billing|sla_breach|penalty|interpretation|tariff|service_quality`',
    `disputed_clause_reference` STRING COMMENT 'Reference to the specific contract clause, section, or schedule that is the subject of the dispute (e.g., Section 5.3 - SLA Performance Metrics, Schedule B - Tariff Rates).',
    `escalation_level` STRING COMMENT 'The organizational level to which the dispute has been escalated within Shipping Ports: operational (handled by operations team), management (middle management involved), executive (senior leadership involved), or board (board of directors notified).. Valid values are `operational|management|executive|board`',
    `final_settled_amount` DECIMAL(18,2) COMMENT 'The final monetary amount agreed upon or awarded as part of the dispute resolution. May differ from disputed_amount. Expressed in the contract currency. Null if no monetary settlement.',
    `governing_law` STRING COMMENT 'The legal jurisdiction and governing law applicable to the dispute resolution, as specified in the contract (e.g., Singapore Law, English Law, New York Law).',
    `impact_on_relationship` STRING COMMENT 'Assessment of the disputes impact on the ongoing commercial relationship between the port and the counterparty: none (no impact), minor (temporary strain), moderate (requires relationship repair), significant (long-term damage), or relationship_terminated (contract ended as result).. Valid values are `none|minor|moderate|significant|relationship_terminated`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this dispute record was last updated in the system. Audit trail field.',
    `legal_representative_counterparty` STRING COMMENT 'Name of the law firm or legal counsel representing the counterparty in the dispute.',
    `legal_representative_port` STRING COMMENT 'Name of the law firm or legal counsel representing Shipping Ports in the dispute.',
    `mediator_name` STRING COMMENT 'Name of the mediator or mediation firm facilitating the dispute resolution if resolution_method is mediation.',
    `notification_sent_date` DATE COMMENT 'The date on which formal written notification of the dispute was sent to the counterparty or received from the counterparty, as required by contract terms.',
    `priority` STRING COMMENT 'Priority level assigned to the dispute based on its urgency, financial impact, and relationship sensitivity: low, medium, high, or critical.. Valid values are `low|medium|high|critical`',
    `raised_by_party` STRING COMMENT 'Indicates which party initiated the dispute: port (Shipping Ports raised the dispute) or counterparty (the contract counterparty raised the dispute).. Valid values are `port|counterparty`',
    `raised_date` DATE COMMENT 'The date on which the dispute was formally raised by either party. This is the principal business event timestamp for the dispute lifecycle.',
    `resolution_date` DATE COMMENT 'The actual date on which the dispute was formally resolved, settled, or a final decision was rendered. Null if dispute is still open.',
    `resolution_method` STRING COMMENT 'The method being used or planned to resolve the dispute: negotiation (direct party-to-party discussion), mediation (facilitated by neutral third party), arbitration (binding decision by arbitrator), or litigation (court proceedings).. Valid values are `negotiation|mediation|arbitration|litigation`',
    `resolution_outcome` STRING COMMENT 'The outcome of the dispute resolution: port_favor (decision in favor of Shipping Ports), counterparty_favor (decision in favor of counterparty), mutual_settlement (negotiated compromise), withdrawn (dispute retracted by raising party), or dismissed (dispute rejected without merit).. Valid values are `port_favor|counterparty_favor|mutual_settlement|withdrawn|dismissed`',
    `resolution_target_date` DATE COMMENT 'The target or expected date by which the dispute is planned to be resolved, based on contractual timelines or resolution process schedules.',
    `response_due_date` DATE COMMENT 'The date by which a formal response to the dispute notification is required, as stipulated in the contract or by the resolution process.',
    `response_received_date` DATE COMMENT 'The date on which a formal response to the dispute was received from the counterparty or sent by the port.',
    `root_cause_category` STRING COMMENT 'Classification of the underlying root cause of the dispute: billing_error (invoicing mistake), service_failure (port failed to deliver), communication_breakdown (misunderstanding between parties), contractual_ambiguity (unclear contract terms), external_factor (force majeure, regulatory change), or system_issue (TOS or ERP system error).. Valid values are `billing_error|service_failure|communication_breakdown|contractual_ambiguity|external_factor|system_issue`',
    `settlement_terms` STRING COMMENT 'Narrative description of the terms and conditions of the settlement or resolution, including any non-monetary remedies, service adjustments, or future commitments agreed upon.',
    `supporting_evidence_references` STRING COMMENT 'Comma-separated list of document references, file paths, or document management system identifiers for evidence supporting the dispute (e.g., invoices, emails, performance reports, vessel logs, gate records).',
    CONSTRAINT pk_dispute_record PRIMARY KEY(`dispute_record_id`)
) COMMENT 'Tracks formal commercial disputes arising from contractual disagreements between the port and its counterparties, including billing disputes, SLA breach disputes, penalty disputes, and interpretation disputes. Captures dispute type, dispute raised date, dispute raised by (port or counterparty), disputed amount, disputed clause reference, dispute description, supporting evidence references, dispute resolution method (negotiation, mediation, arbitration, litigation), arbitration body, resolution date, resolution outcome, and final settled amount. Provides the SSOT for contract dispute management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` (
    `guarantee_bond_id` BIGINT COMMENT 'Unique identifier for the guarantee bond record. Primary key for the guarantee bond entity.',
    `agreement_id` BIGINT COMMENT 'Reference to the commercial agreement that this guarantee bond secures. Links to the parent contract agreement.',
    `agreement_party_id` BIGINT COMMENT 'Foreign key linking to contract.agreement_party. Business justification: Performance bonds and guarantees are provided by specific parties to the agreement (typically the contractor or service provider). This FK links the bond to the party that provided it, enabling retrie',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Guarantee bond creation audit trail requires employee reference for accountability in financial security instrument management.',
    `customs_broker_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_broker. Business justification: Performance bonds and guarantees often cover customs broker liabilities under terminal operating agreements (duty payment guarantees, clearance performance bonds). Essential for financial security man',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Performance bonds and guarantees are recorded as contingent liabilities in specific GL accounts. Required for balance sheet disclosure of guarantees, financial statement notes, and audit compliance.',
    `parent_guarantee_bond_id` BIGINT COMMENT 'Self-referencing FK on guarantee_bond (parent_guarantee_bond_id)',
    `arbitration_body` STRING COMMENT 'Name of the arbitration institution designated to administer disputes (e.g., ICC, LCIA, SIAC). Applicable when arbitration is the chosen dispute resolution method.',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the bond automatically renews upon expiry unless cancelled by either party. True if auto-renewal is enabled, false if manual renewal is required.',
    `beneficiary_name` STRING COMMENT 'Name of the party entitled to claim against the bond. Typically the port authority or terminal operator who is protected by the guarantee.',
    `bond_fee_amount` DECIMAL(18,2) COMMENT 'Fee charged by the bond provider for issuing and maintaining the guarantee. May be a one-time issuance fee or recurring annual premium.',
    `bond_fee_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which the bond fee is denominated. May differ from the bond value currency.',
    `bond_fee_frequency` STRING COMMENT 'Frequency at which bond fees are charged. One-time fees are paid at issuance, while recurring fees are paid periodically throughout the bonds life.. Valid values are `one_time|annual|quarterly|monthly`',
    `bond_number` STRING COMMENT 'Externally-known unique reference number or certificate number assigned by the bond provider (bank, insurer, or parent entity). Used for identification and claim processing.',
    `bond_provider_credit_rating` STRING COMMENT 'Credit rating of the bond provider as assessed by recognized rating agencies (e.g., AAA, AA+, BBB). Used to evaluate the financial strength and reliability of the guarantee.',
    `bond_status` STRING COMMENT 'Current lifecycle status of the guarantee bond. Active bonds are in force, expired bonds have passed their validity period, claimed bonds have had claims submitted, released bonds have been discharged, suspended bonds are temporarily inactive, and cancelled bonds have been terminated before expiry.. Valid values are `active|expired|claimed|released|suspended|cancelled`',
    `bond_type` STRING COMMENT 'Classification of the guarantee instrument type. Performance bonds secure contract performance obligations, bank guarantees provide financial security from banking institutions, parent company guarantees are corporate commitments, bid bonds secure tender participation, advance payment bonds protect advance payments, and retention bonds replace retention money.. Valid values are `performance_bond|bank_guarantee|parent_company_guarantee|bid_bond|advance_payment_bond|retention_bond`',
    `bond_value` DECIMAL(18,2) COMMENT 'The maximum monetary amount that can be claimed under the guarantee bond. Represents the financial exposure covered by the instrument.',
    `claim_conditions` STRING COMMENT 'Detailed description of the conditions and circumstances under which the beneficiary is entitled to make a claim against the bond. Defines triggering events and claim procedures.',
    `claim_notice_period_days` STRING COMMENT 'Number of days advance notice required before submitting a formal claim. Allows the bond provider and principal to respond to potential claims.',
    `claim_procedure` STRING COMMENT 'Step-by-step process and documentation requirements for submitting a claim against the bond. Includes notice periods, required evidence, and submission channels.',
    `compliance_framework` STRING COMMENT 'Regulatory or industry compliance framework that this bond must adhere to (e.g., ISPS Code, IMO Guidelines, local port authority regulations). Defines compliance obligations.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this guarantee bond record was first created in the system. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which the bond value is denominated (e.g., USD, EUR, GBP). Critical for financial reporting and claim settlement.',
    `dispute_resolution_method` STRING COMMENT 'Agreed method for resolving disputes related to the bond. Litigation uses courts, arbitration uses private tribunals, mediation uses facilitated negotiation, and expert determination uses technical specialists.. Valid values are `litigation|arbitration|mediation|expert_determination`',
    `document_format` STRING COMMENT 'Format in which the bond certificate is stored. PDF and DOCX are digital formats, scanned images are digitized paper documents, and original paper indicates physical custody.. Valid values are `pdf|docx|scanned_image|original_paper`',
    `document_reference` STRING COMMENT 'Reference identifier or file path to the physical or digital bond certificate document. Used for document management and audit trail purposes.',
    `effective_date` DATE COMMENT 'Date from which the bond becomes enforceable and claims can be made. May differ from issue date if there is a waiting period.',
    `expiry_date` DATE COMMENT 'Date on which the guarantee bond expires and can no longer be claimed against. After this date, the bond provider is released from obligations unless extended.',
    `governing_law` STRING COMMENT 'Legal jurisdiction and governing law that applies to the bond instrument. Determines which courts have jurisdiction and which legal framework governs disputes.',
    `issue_date` DATE COMMENT 'Date on which the guarantee bond was issued or became effective. Marks the start of the bonds validity period.',
    `last_claim_date` DATE COMMENT 'Date of the most recent claim submitted against this bond. Used to track claim activity and bond performance.',
    `last_modified_by` STRING COMMENT 'Identifier of the user or system process that last modified this guarantee bond record. Used for accountability and change tracking.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this guarantee bond record was last updated. Tracks the most recent change to any field in the record.',
    `notes` STRING COMMENT 'Free-text field for additional comments, special conditions, or operational notes related to the bond. Used for context that does not fit structured fields.',
    `regulatory_approval_required` BOOLEAN COMMENT 'Indicates whether regulatory approval or registration is required for this bond to be valid. True if regulatory oversight applies, false otherwise.',
    `regulatory_authority` STRING COMMENT 'Name of the government agency or regulatory body that oversees or approves this bond. Applicable when regulatory approval is required.',
    `remaining_bond_value` DECIMAL(18,2) COMMENT 'Available bond value remaining after deducting all paid claims. Represents the current financial protection still available under the guarantee.',
    `renewal_notice_period_days` STRING COMMENT 'Number of days advance notice required to either renew or cancel the bond before its expiry date. Ensures timely decision-making and continuity of coverage.',
    `renewal_terms` STRING COMMENT 'Terms and conditions governing the renewal or extension of the bond beyond its original expiry date. Includes renewal notice periods, fee structures, and conditions precedent.',
    `review_date` DATE COMMENT 'Scheduled date for periodic review of the bonds adequacy, provider creditworthiness, and alignment with contract requirements. Ensures ongoing risk management.',
    `risk_assessment_rating` STRING COMMENT 'Internal risk rating assigned to this bond based on provider creditworthiness, claim history, and contract exposure. Used for portfolio risk management.. Valid values are `low|medium|high|critical`',
    `security_registration_number` STRING COMMENT 'Official registration number assigned by regulatory authorities or security registries. Required for certain types of financial guarantees in regulated jurisdictions.',
    `total_claimed_amount` DECIMAL(18,2) COMMENT 'Cumulative monetary amount that has been claimed against this bond across all claims. Tracks the financial exposure realized from the guarantee.',
    `total_claims_count` STRING COMMENT 'Total number of claims that have been submitted against this bond throughout its lifecycle. Used to track claim frequency and bond utilization.',
    `total_paid_amount` DECIMAL(18,2) COMMENT 'Cumulative monetary amount that has been paid out by the bond provider in settlement of claims. May differ from claimed amount due to disputes or partial settlements.',
    CONSTRAINT pk_guarantee_bond PRIMARY KEY(`guarantee_bond_id`)
) COMMENT 'Master records for performance bonds, bank guarantees, parent company guarantees, and insurance instruments securing commercial agreements. Captures bond type (performance_bond, bank_guarantee, parent_company_guarantee, bid_bond), bond provider (bank, insurer, parent_entity), bond beneficiary, bond value, currency, issue date, expiry date, claim conditions, claim history, renewal terms, and bond status (active, expired, claimed, released). Critical for port concession and stevedoring contract risk management.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ADD CONSTRAINT `fk_contract_agreement_version_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ADD CONSTRAINT `fk_contract_agreement_version_superseded_version_agreement_version_id` FOREIGN KEY (`superseded_version_agreement_version_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement_version`(`agreement_version_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ADD CONSTRAINT `fk_contract_agreement_party_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ADD CONSTRAINT `fk_contract_service_scope_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ADD CONSTRAINT `fk_contract_sla_definition_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ADD CONSTRAINT `fk_contract_sla_definition_service_scope_id` FOREIGN KEY (`service_scope_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`service_scope`(`service_scope_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ADD CONSTRAINT `fk_contract_sla_definition_superseded_by_sla_definition_id` FOREIGN KEY (`superseded_by_sla_definition_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`sla_definition`(`sla_definition_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ADD CONSTRAINT `fk_contract_sla_measurement_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ADD CONSTRAINT `fk_contract_sla_measurement_service_scope_id` FOREIGN KEY (`service_scope_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`service_scope`(`service_scope_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ADD CONSTRAINT `fk_contract_sla_measurement_sla_definition_id` FOREIGN KEY (`sla_definition_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`sla_definition`(`sla_definition_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ADD CONSTRAINT `fk_contract_sla_breach_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ADD CONSTRAINT `fk_contract_sla_breach_penalty_assessment_id` FOREIGN KEY (`penalty_assessment_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`penalty_assessment`(`penalty_assessment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ADD CONSTRAINT `fk_contract_sla_breach_previous_breach_sla_breach_id` FOREIGN KEY (`previous_breach_sla_breach_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`sla_breach`(`sla_breach_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ADD CONSTRAINT `fk_contract_sla_breach_sla_definition_id` FOREIGN KEY (`sla_definition_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`sla_definition`(`sla_definition_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ADD CONSTRAINT `fk_contract_sla_breach_sla_measurement_id` FOREIGN KEY (`sla_measurement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`sla_measurement`(`sla_measurement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ADD CONSTRAINT `fk_contract_rate_schedule_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ADD CONSTRAINT `fk_contract_rate_schedule_service_scope_id` FOREIGN KEY (`service_scope_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`service_scope`(`service_scope_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ADD CONSTRAINT `fk_contract_volume_commitment_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ADD CONSTRAINT `fk_contract_volume_commitment_service_scope_id` FOREIGN KEY (`service_scope_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`service_scope`(`service_scope_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ADD CONSTRAINT `fk_contract_pil_arrangement_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ADD CONSTRAINT `fk_contract_contract_document_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ADD CONSTRAINT `fk_contract_contract_document_agreement_version_id` FOREIGN KEY (`agreement_version_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement_version`(`agreement_version_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ADD CONSTRAINT `fk_contract_penalty_clause_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ADD CONSTRAINT `fk_contract_penalty_clause_service_scope_id` FOREIGN KEY (`service_scope_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`service_scope`(`service_scope_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ADD CONSTRAINT `fk_contract_penalty_assessment_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ADD CONSTRAINT `fk_contract_penalty_assessment_penalty_clause_id` FOREIGN KEY (`penalty_clause_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`penalty_clause`(`penalty_clause_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ADD CONSTRAINT `fk_contract_penalty_assessment_volume_commitment_id` FOREIGN KEY (`volume_commitment_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`volume_commitment`(`volume_commitment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ADD CONSTRAINT `fk_contract_dispute_record_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ADD CONSTRAINT `fk_contract_dispute_record_penalty_assessment_id` FOREIGN KEY (`penalty_assessment_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`penalty_assessment`(`penalty_assessment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ADD CONSTRAINT `fk_contract_dispute_record_sla_breach_id` FOREIGN KEY (`sla_breach_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`sla_breach`(`sla_breach_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ADD CONSTRAINT `fk_contract_guarantee_bond_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ADD CONSTRAINT `fk_contract_guarantee_bond_agreement_party_id` FOREIGN KEY (`agreement_party_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement_party`(`agreement_party_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ADD CONSTRAINT `fk_contract_guarantee_bond_parent_guarantee_bond_id` FOREIGN KEY (`parent_guarantee_bond_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`guarantee_bond`(`guarantee_bond_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`contract` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_shipping_ports_v1`.`contract` SET TAGS ('dbx_domain' = 'contract');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` SET TAGS ('dbx_subdomain' = 'agreement_lifecycle');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `customs_broker_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `equipment_type_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Signed By Port Authority Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Profile Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `trade_restriction_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Restriction Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Agreement Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{6,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `agreement_status` SET TAGS ('dbx_business_glossary_term' = 'Agreement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `agreement_status` SET TAGS ('dbx_value_regex' = 'draft|under_negotiation|active|suspended|expired|terminated');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_business_glossary_term' = 'Agreement Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'service_agreement|concession_agreement|stevedoring_contract|pil_arrangement|lease_agreement|marine_services_agreement');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `alliance_membership` SET TAGS ('dbx_business_glossary_term' = 'Alliance Membership');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto-Renewal Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `concession_term_years` SET TAGS ('dbx_business_glossary_term' = 'Concession Term (Years)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `contract_value` SET TAGS ('dbx_business_glossary_term' = 'Contract Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `contract_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `credit_limit_amount` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `credit_limit_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `crm_opportunity_reference` SET TAGS ('dbx_business_glossary_term' = 'CRM Opportunity Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `document_reference` SET TAGS ('dbx_business_glossary_term' = 'Document Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `edi_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `governing_law` SET TAGS ('dbx_business_glossary_term' = 'Governing Law');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `insurance_coverage_amount` SET TAGS ('dbx_business_glossary_term' = 'Insurance Coverage Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `insurance_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Insurance Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `investment_commitment_amount` SET TAGS ('dbx_business_glossary_term' = 'Investment Commitment Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `investment_commitment_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `magr_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Annual Guarantee Revenue (MAGR) Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `magr_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `payment_terms_days` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `productivity_target_moves_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Productivity Target (Moves Per Hour)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `renewal_notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notice Period (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `revenue_share_percentage` SET TAGS ('dbx_business_glossary_term' = 'Revenue Share Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `revenue_share_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `sap_contract_number` SET TAGS ('dbx_business_glossary_term' = 'SAP S/4HANA Contract Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `sap_contract_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `security_deposit_amount` SET TAGS ('dbx_business_glossary_term' = 'Security Deposit Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `security_deposit_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `service_strings` SET TAGS ('dbx_business_glossary_term' = 'Service Strings');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `signature_date` SET TAGS ('dbx_business_glossary_term' = 'Signature Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `signed_by_counterparty` SET TAGS ('dbx_business_glossary_term' = 'Signed By Counterparty');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Termination Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Termination Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` SET TAGS ('dbx_subdomain' = 'agreement_lifecycle');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `agreement_version_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Version Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Change Requested By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `superseded_version_agreement_version_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded Version Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `change_reason` SET TAGS ('dbx_business_glossary_term' = 'Change Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `change_summary` SET TAGS ('dbx_business_glossary_term' = 'Change Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `change_type` SET TAGS ('dbx_business_glossary_term' = 'Change Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `change_type` SET TAGS ('dbx_value_regex' = 'amendment|addendum|renewal|novation|restatement|termination');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `counterparty_acceptance_date` SET TAGS ('dbx_business_glossary_term' = 'Counterparty Acceptance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `counterparty_acceptance_required` SET TAGS ('dbx_business_glossary_term' = 'Counterparty Acceptance Required');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `document_format` SET TAGS ('dbx_business_glossary_term' = 'Document Format');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `document_format` SET TAGS ('dbx_value_regex' = 'pdf|docx|scanned_image|electronic_signature|paper_original');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `document_reference` SET TAGS ('dbx_business_glossary_term' = 'Document Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `financial_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Financial Impact Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `financial_impact_summary` SET TAGS ('dbx_business_glossary_term' = 'Financial Impact Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `financial_impact_summary` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `legal_review_date` SET TAGS ('dbx_business_glossary_term' = 'Legal Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `legal_review_required` SET TAGS ('dbx_business_glossary_term' = 'Legal Review Required');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `legal_reviewer` SET TAGS ('dbx_business_glossary_term' = 'Legal Reviewer');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `notification_sent_date` SET TAGS ('dbx_business_glossary_term' = 'Notification Sent Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `notification_sent_flag` SET TAGS ('dbx_business_glossary_term' = 'Notification Sent Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `regulatory_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `signed_date` SET TAGS ('dbx_business_glossary_term' = 'Signed Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `sla_changes_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Changes Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `sla_changes_summary` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Changes Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `version_effective_date` SET TAGS ('dbx_business_glossary_term' = 'Version Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `version_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Version Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `version_notes` SET TAGS ('dbx_business_glossary_term' = 'Version Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$|^[0-9]+$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `version_status` SET TAGS ('dbx_business_glossary_term' = 'Version Status');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `version_status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|approved|active|superseded|terminated');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` SET TAGS ('dbx_subdomain' = 'agreement_lifecycle');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `agreement_party_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Party Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `access_credential_id` SET TAGS ('dbx_business_glossary_term' = 'Access Credential Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Account Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `amendment_count` SET TAGS ('dbx_business_glossary_term' = 'Party Amendment Count');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `authorized_representative_email` SET TAGS ('dbx_business_glossary_term' = 'Authorized Representative Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `authorized_representative_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `authorized_representative_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `authorized_representative_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `authorized_representative_name` SET TAGS ('dbx_business_glossary_term' = 'Authorized Representative Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `authorized_representative_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `authorized_representative_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `authorized_representative_phone` SET TAGS ('dbx_business_glossary_term' = 'Authorized Representative Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `authorized_representative_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `authorized_representative_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `compliance_certifications_required` SET TAGS ('dbx_business_glossary_term' = 'Compliance Certifications Required');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Party Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `credit_limit_amount` SET TAGS ('dbx_business_glossary_term' = 'Party Credit Limit Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `credit_limit_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `credit_limit_currency` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `credit_limit_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `dispute_resolution_method` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Method');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `dispute_resolution_method` SET TAGS ('dbx_value_regex' = 'negotiation|mediation|arbitration|litigation|expert_determination');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `governing_law_jurisdiction` SET TAGS ('dbx_business_glossary_term' = 'Governing Law Jurisdiction');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `guarantee_amount` SET TAGS ('dbx_business_glossary_term' = 'Guarantee Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `guarantee_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `guarantee_currency` SET TAGS ('dbx_business_glossary_term' = 'Guarantee Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `guarantee_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `guarantee_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Guarantee Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `guarantee_instrument_type` SET TAGS ('dbx_business_glossary_term' = 'Guarantee Instrument Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `guarantee_instrument_type` SET TAGS ('dbx_value_regex' = 'bank_guarantee|letter_of_credit|performance_bond|parent_company_guarantee|cash_deposit|insurance_policy');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `indemnity_scope` SET TAGS ('dbx_business_glossary_term' = 'Indemnity Scope Description');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `insurance_coverage_currency` SET TAGS ('dbx_business_glossary_term' = 'Insurance Coverage Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `insurance_coverage_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `insurance_coverage_types` SET TAGS ('dbx_business_glossary_term' = 'Insurance Coverage Types');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `insurance_minimum_coverage` SET TAGS ('dbx_business_glossary_term' = 'Insurance Minimum Coverage Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `insurance_minimum_coverage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `insurance_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Insurance Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `last_amendment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Amendment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `liability_cap_amount` SET TAGS ('dbx_business_glossary_term' = 'Liability Cap Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `liability_cap_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `liability_cap_currency` SET TAGS ('dbx_business_glossary_term' = 'Liability Cap Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `liability_cap_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `notification_address` SET TAGS ('dbx_business_glossary_term' = 'Party Notification Postal Address');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `notification_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `notification_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `notification_email` SET TAGS ('dbx_business_glossary_term' = 'Party Notification Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `notification_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `notification_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `notification_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `party_entry_date` SET TAGS ('dbx_business_glossary_term' = 'Party Entry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `party_exit_date` SET TAGS ('dbx_business_glossary_term' = 'Party Exit Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `party_role` SET TAGS ('dbx_business_glossary_term' = 'Party Role in Agreement');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `party_role` SET TAGS ('dbx_value_regex' = 'port_authority|counterparty|guarantor|sub_contractor|co_signatory|beneficiary');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `party_status` SET TAGS ('dbx_business_glossary_term' = 'Party Status in Agreement');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `party_status` SET TAGS ('dbx_value_regex' = 'active|suspended|terminated|defaulted|novated|released');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `party_type` SET TAGS ('dbx_business_glossary_term' = 'Party Type Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `party_type` SET TAGS ('dbx_value_regex' = 'shipping_line|freight_forwarder|cargo_owner|stevedore|concessionaire|government_agency');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `payment_terms_override` SET TAGS ('dbx_business_glossary_term' = 'Party-Specific Payment Terms Override');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `payment_terms_override` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `performance_bond_amount` SET TAGS ('dbx_business_glossary_term' = 'Performance Bond Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `performance_bond_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `performance_bond_currency` SET TAGS ('dbx_business_glossary_term' = 'Performance Bond Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `performance_bond_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `performance_bond_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Performance Bond Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Party Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `signatory_authority_level` SET TAGS ('dbx_business_glossary_term' = 'Signatory Authority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `signatory_authority_level` SET TAGS ('dbx_value_regex' = 'board_level|executive|senior_management|middle_management|delegated');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `signatory_name` SET TAGS ('dbx_business_glossary_term' = 'Signatory Full Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `signatory_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `signatory_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `signatory_title` SET TAGS ('dbx_business_glossary_term' = 'Signatory Job Title');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `signing_date` SET TAGS ('dbx_business_glossary_term' = 'Party Signing Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ALTER COLUMN `signing_location` SET TAGS ('dbx_business_glossary_term' = 'Signing Location');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` SET TAGS ('dbx_subdomain' = 'agreement_lifecycle');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `service_scope_id` SET TAGS ('dbx_business_glossary_term' = 'Service Scope ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Contract ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `material_group_id` SET TAGS ('dbx_business_glossary_term' = 'Material Group Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `amendment_number` SET TAGS ('dbx_business_glossary_term' = 'Amendment Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `billing_basis` SET TAGS ('dbx_business_glossary_term' = 'Billing Basis');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `billing_basis` SET TAGS ('dbx_value_regex' = 'per_teu|per_move|per_hour|per_vessel_call|per_dwt|flat_rate');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `crew_competency_required` SET TAGS ('dbx_business_glossary_term' = 'Crew Competency Required');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `customs_clearance_included` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Included');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `environmental_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'Environmental Compliance Required');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `equipment_type_required` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Required');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `exclusions` SET TAGS ('dbx_business_glossary_term' = 'Exclusions');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `imdg_handling_authorized` SET TAGS ('dbx_business_glossary_term' = 'IMDG (International Maritime Dangerous Goods) Handling Authorized');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_business_glossary_term' = 'ISPS (International Ship and Port Facility Security) Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `last_amended_date` SET TAGS ('dbx_business_glossary_term' = 'Last Amended Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `performance_bonus_applicable` SET TAGS ('dbx_business_glossary_term' = 'Performance Bonus Applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `performance_penalty_applicable` SET TAGS ('dbx_business_glossary_term' = 'Performance Penalty Applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'standard|priority|express|emergency|deferred');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `rate_card_reference` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `reefer_service_included` SET TAGS ('dbx_business_glossary_term' = 'Reefer Service Included');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `service_description` SET TAGS ('dbx_business_glossary_term' = 'Service Description');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `service_line_number` SET TAGS ('dbx_business_glossary_term' = 'Service Line Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `service_status` SET TAGS ('dbx_business_glossary_term' = 'Service Status');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `service_status` SET TAGS ('dbx_value_regex' = 'active|suspended|terminated|pending_activation|under_review');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'pilotage|towage|stevedoring|container_handling|storage|reefer_monitoring');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `service_window` SET TAGS ('dbx_business_glossary_term' = 'Service Window');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `service_window` SET TAGS ('dbx_value_regex' = '24x7|business_hours|daylight_only|tidal_dependent|scheduled_slots');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `sla_target_response_minutes` SET TAGS ('dbx_business_glossary_term' = 'SLA (Service Level Agreement) Target Response Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `sla_target_turnaround_hours` SET TAGS ('dbx_business_glossary_term' = 'SLA (Service Level Agreement) Target Turnaround Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `special_conditions` SET TAGS ('dbx_business_glossary_term' = 'Special Conditions');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `throughput_guarantee_amount` SET TAGS ('dbx_business_glossary_term' = 'Throughput Guarantee Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `throughput_guarantee_flag` SET TAGS ('dbx_business_glossary_term' = 'Throughput Guarantee Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `throughput_guarantee_unit` SET TAGS ('dbx_business_glossary_term' = 'Throughput Guarantee Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `throughput_guarantee_unit` SET TAGS ('dbx_value_regex' = 'TEU|FEU|DWT|CBM|vessel_calls|moves');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `volume_commitment_dwt` SET TAGS ('dbx_business_glossary_term' = 'Volume Commitment DWT (Deadweight Tonnage)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `volume_commitment_teu` SET TAGS ('dbx_business_glossary_term' = 'Volume Commitment TEU (Twenty-foot Equivalent Unit)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ALTER COLUMN `volume_commitment_vessel_calls` SET TAGS ('dbx_business_glossary_term' = 'Volume Commitment Vessel Calls');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` SET TAGS ('dbx_subdomain' = 'performance_obligations');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `sla_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Definition Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Business Owner Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `service_scope_id` SET TAGS ('dbx_business_glossary_term' = 'Service Scope Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `sla_rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `superseded_by_sla_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Service Level Agreement (SLA) Definition Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By User Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `compliance_framework` SET TAGS ('dbx_business_glossary_term' = 'Compliance Framework Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `critical_threshold` SET TAGS ('dbx_business_glossary_term' = 'Critical Threshold Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `customer_segment` SET TAGS ('dbx_business_glossary_term' = 'Customer Segment Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `data_source_system` SET TAGS ('dbx_business_glossary_term' = 'Data Source System Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `sla_definition_description` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Definition Description');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `escalation_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Escalation Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `measurement_frequency` SET TAGS ('dbx_business_glossary_term' = 'Measurement Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `measurement_methodology` SET TAGS ('dbx_business_glossary_term' = 'Measurement Methodology Description');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_business_glossary_term' = 'Measurement Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Internal Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `penalty_applicable_flag` SET TAGS ('dbx_business_glossary_term' = 'Penalty Applicable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `penalty_calculation_method` SET TAGS ('dbx_business_glossary_term' = 'Penalty Calculation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `penalty_calculation_method` SET TAGS ('dbx_value_regex' = 'fixed_amount|percentage_of_charge|tiered|per_unit_deviation|service_credit');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `reporting_frequency` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Reporting Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `reporting_frequency` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|quarterly|on_demand');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `sla_category` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Category');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `sla_category` SET TAGS ('dbx_value_regex' = 'vessel_turnaround|crane_productivity|gate_processing_time|berth_availability|reefer_uptime|documentation_turnaround');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `sla_code` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `sla_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `sla_definition_status` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Definition Status');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `sla_definition_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|retired|under_review');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `sla_name` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `sla_type` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `sla_type` SET TAGS ('dbx_value_regex' = 'performance|availability|response_time|throughput|quality|compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `target_metric_name` SET TAGS ('dbx_business_glossary_term' = 'Target Metric Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `target_threshold` SET TAGS ('dbx_business_glossary_term' = 'Target Threshold Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `threshold_operator` SET TAGS ('dbx_business_glossary_term' = 'Threshold Comparison Operator');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `threshold_operator` SET TAGS ('dbx_value_regex' = 'less_than|less_than_or_equal|greater_than|greater_than_or_equal|equal|between');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ALTER COLUMN `warning_threshold` SET TAGS ('dbx_business_glossary_term' = 'Warning Threshold Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` SET TAGS ('dbx_subdomain' = 'performance_obligations');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `sla_measurement_id` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Measurement ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Contract ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Included in Invoice ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Measurement Approved By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Account ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `service_scope_id` SET TAGS ('dbx_business_glossary_term' = 'Service Scope Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `sla_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Definition ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `terminal_berth_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Berth Allocation Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `actual_value` SET TAGS ('dbx_business_glossary_term' = 'Actual Metric Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `adjusted_actual_value` SET TAGS ('dbx_business_glossary_term' = 'Adjusted Actual Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `adjustment_reason` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `billing_period` SET TAGS ('dbx_business_glossary_term' = 'Billing Period');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `billing_period` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `breach_notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Breach Notification Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `breach_notification_triggered` SET TAGS ('dbx_business_glossary_term' = 'Breach Notification Triggered Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `dispute_raised_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Raised Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `dispute_resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `incentive_amount` SET TAGS ('dbx_business_glossary_term' = 'Incentive Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `incentive_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `measurement_approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Measurement Approved Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `measurement_date` SET TAGS ('dbx_business_glossary_term' = 'Measurement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `measurement_notes` SET TAGS ('dbx_business_glossary_term' = 'Measurement Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `measurement_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Measurement Period End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `measurement_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Measurement Period Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `measurement_period_type` SET TAGS ('dbx_business_glossary_term' = 'Measurement Period Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `measurement_period_type` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|quarterly|annual|per_call');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `measurement_source_system` SET TAGS ('dbx_business_glossary_term' = 'Measurement Source System');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `measurement_status` SET TAGS ('dbx_business_glossary_term' = 'Measurement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `measurement_status` SET TAGS ('dbx_value_regex' = 'draft|confirmed|disputed|adjusted|finalized');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `measurement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Measurement Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `penalty_amount` SET TAGS ('dbx_business_glossary_term' = 'Penalty Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `penalty_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `penalty_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Penalty Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `penalty_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `performance_status` SET TAGS ('dbx_business_glossary_term' = 'Performance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `performance_status` SET TAGS ('dbx_value_regex' = 'met|breached|at_risk|on_track|shortfall|surplus');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `target_value` SET TAGS ('dbx_business_glossary_term' = 'Target Metric Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `variance_absolute` SET TAGS ('dbx_business_glossary_term' = 'Variance Absolute');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `variance_percentage` SET TAGS ('dbx_business_glossary_term' = 'Variance Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `volume_shortfall` SET TAGS ('dbx_business_glossary_term' = 'Volume Shortfall');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ALTER COLUMN `volume_surplus` SET TAGS ('dbx_business_glossary_term' = 'Volume Surplus');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` SET TAGS ('dbx_subdomain' = 'performance_obligations');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `sla_breach_id` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Contract ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Counterparty ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `penalty_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Penalty Assessment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `previous_breach_sla_breach_id` SET TAGS ('dbx_business_glossary_term' = 'Previous Breach ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `sla_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Definition ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `sla_measurement_id` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Measurement ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `terminal_berth_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Berth Allocation Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `actual_value` SET TAGS ('dbx_business_glossary_term' = 'Actual Performance Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `breach_date` SET TAGS ('dbx_business_glossary_term' = 'Breach Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `breach_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Breach Duration (Hours)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `breach_notification_date` SET TAGS ('dbx_business_glossary_term' = 'Breach Notification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `breach_number` SET TAGS ('dbx_business_glossary_term' = 'Breach Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `breach_severity` SET TAGS ('dbx_business_glossary_term' = 'Breach Severity Level');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `breach_severity` SET TAGS ('dbx_value_regex' = 'minor|major|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `breach_status` SET TAGS ('dbx_business_glossary_term' = 'Breach Status');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `breach_status` SET TAGS ('dbx_value_regex' = 'open|under_review|remediated|disputed|closed');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `breach_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Breach Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `communication_log` SET TAGS ('dbx_business_glossary_term' = 'Communication Log');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `counterparty_acknowledgement_date` SET TAGS ('dbx_business_glossary_term' = 'Counterparty Acknowledgement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `deviation_percentage` SET TAGS ('dbx_business_glossary_term' = 'Deviation Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `deviation_value` SET TAGS ('dbx_business_glossary_term' = 'Deviation Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `dispute_outcome` SET TAGS ('dbx_business_glossary_term' = 'Dispute Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `dispute_outcome` SET TAGS ('dbx_value_regex' = 'upheld|overturned|partially_upheld|withdrawn');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `dispute_raised_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Raised Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `dispute_resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `escalation_date` SET TAGS ('dbx_business_glossary_term' = 'Escalation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `escalation_level` SET TAGS ('dbx_business_glossary_term' = 'Escalation Level');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `escalation_level` SET TAGS ('dbx_value_regex' = 'operational|management|executive|legal');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `impact_assessment` SET TAGS ('dbx_business_glossary_term' = 'Impact Assessment');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_business_glossary_term' = 'Measurement Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Breach Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `penalty_applicable_flag` SET TAGS ('dbx_business_glossary_term' = 'Penalty Applicable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `recurrence_flag` SET TAGS ('dbx_business_glossary_term' = 'Recurrence Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `remediation_deadline` SET TAGS ('dbx_business_glossary_term' = 'Remediation Deadline Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `remediation_plan` SET TAGS ('dbx_business_glossary_term' = 'Remediation Plan');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Resolution Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `responsible_department` SET TAGS ('dbx_business_glossary_term' = 'Responsible Department');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `responsible_party` SET TAGS ('dbx_business_glossary_term' = 'Responsible Party');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `responsible_party` SET TAGS ('dbx_value_regex' = 'port|counterparty|third_party|shared|force_majeure');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `root_cause_description` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Description');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ALTER COLUMN `threshold_value` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Threshold Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` SET TAGS ('dbx_subdomain' = 'commercial_terms');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `rate_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Contract ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `material_group_id` SET TAGS ('dbx_business_glossary_term' = 'Material Group Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `service_code_id` SET TAGS ('dbx_business_glossary_term' = 'Service Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `service_scope_id` SET TAGS ('dbx_business_glossary_term' = 'Service Scope Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `billing_cycle` SET TAGS ('dbx_business_glossary_term' = 'Billing Cycle');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `billing_cycle` SET TAGS ('dbx_value_regex' = 'per_transaction|daily|weekly|monthly|quarterly|annual');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `calculation_basis` SET TAGS ('dbx_business_glossary_term' = 'Calculation Basis');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `calculation_basis` SET TAGS ('dbx_value_regex' = 'per_teu|per_feu|per_move|per_day|per_grt|fixed_amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `escalation_clause_flag` SET TAGS ('dbx_business_glossary_term' = 'Escalation Clause Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `escalation_frequency` SET TAGS ('dbx_business_glossary_term' = 'Escalation Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `escalation_frequency` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annual|annual|none');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `escalation_index` SET TAGS ('dbx_business_glossary_term' = 'Escalation Index');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `escalation_index` SET TAGS ('dbx_value_regex' = 'cpi|fuel_index|exchange_rate|custom|none');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `escalation_percentage` SET TAGS ('dbx_business_glossary_term' = 'Escalation Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `free_time_days` SET TAGS ('dbx_business_glossary_term' = 'Free Time Days');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `grace_period_hours` SET TAGS ('dbx_business_glossary_term' = 'Grace Period Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `grt_lower_bound` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) Lower Bound');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `grt_upper_bound` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) Upper Bound');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `hazmat_surcharge_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Surcharge Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `imdg_class` SET TAGS ('dbx_value_regex' = '^(class_[1-9]|not_applicable)$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `maximum_charge` SET TAGS ('dbx_business_glossary_term' = 'Maximum Charge');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `minimum_charge` SET TAGS ('dbx_business_glossary_term' = 'Minimum Charge');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `payment_terms_days` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Days');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `peak_season_surcharge` SET TAGS ('dbx_business_glossary_term' = 'Peak Season Surcharge');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `pil_calculation_basis` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Calculation Basis');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `pil_calculation_basis` SET TAGS ('dbx_value_regex' = 'per_teu|per_ton|percentage_of_cargo_value|fixed_per_vessel|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `pil_collection_responsibility` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Collection Responsibility');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `pil_collection_responsibility` SET TAGS ('dbx_value_regex' = 'port_authority|shipping_line|freight_forwarder|terminal_operator|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `pil_exemption_flag` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Exemption Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `pil_remittance_frequency` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Remittance Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `pil_remittance_frequency` SET TAGS ('dbx_value_regex' = 'weekly|monthly|quarterly|per_transaction|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `rate_status` SET TAGS ('dbx_business_glossary_term' = 'Rate Status');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `rate_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|superseded');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `rate_type` SET TAGS ('dbx_business_glossary_term' = 'Rate Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `rate_type` SET TAGS ('dbx_value_regex' = 'thc|wharfage|pilotage_fee|towage_rate|storage_tariff|reefer_surcharge');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `rate_value` SET TAGS ('dbx_business_glossary_term' = 'Rate Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `reefer_temperature_range` SET TAGS ('dbx_business_glossary_term' = 'Reefer Temperature Range');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `seasonal_flag` SET TAGS ('dbx_business_glossary_term' = 'Seasonal Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `tax_applicable_flag` SET TAGS ('dbx_business_glossary_term' = 'Tax Applicable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `tax_rate_percentage` SET TAGS ('dbx_business_glossary_term' = 'Tax Rate Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ALTER COLUMN `volume_threshold` SET TAGS ('dbx_business_glossary_term' = 'Volume Threshold');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` SET TAGS ('dbx_subdomain' = 'commercial_terms');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `volume_commitment_id` SET TAGS ('dbx_business_glossary_term' = 'Volume Commitment Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Account Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `service_scope_id` SET TAGS ('dbx_business_glossary_term' = 'Service Scope Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `actual_volume_to_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Volume To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `auto_renew_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto-Renew Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `commitment_period_type` SET TAGS ('dbx_business_glossary_term' = 'Commitment Period Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `commitment_period_type` SET TAGS ('dbx_value_regex' = 'annual|quarterly|monthly|custom');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `commitment_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Volume Commitment Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `commitment_reference_number` SET TAGS ('dbx_value_regex' = '^VC-[A-Z0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `commitment_status` SET TAGS ('dbx_business_glossary_term' = 'Commitment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `commitment_status` SET TAGS ('dbx_value_regex' = 'active|waived|in_dispute|suspended|expired|terminated');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `commitment_type` SET TAGS ('dbx_business_glossary_term' = 'Commitment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `commitment_type` SET TAGS ('dbx_value_regex' = 'minimum_teu|minimum_feu|minimum_vessel_calls|minimum_dwt|minimum_cargo_tonnes|minimum_revenue');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `commitment_unit` SET TAGS ('dbx_business_glossary_term' = 'Commitment Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `committed_volume` SET TAGS ('dbx_business_glossary_term' = 'Committed Volume');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `dispute_raised_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Raised Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `excess_volume` SET TAGS ('dbx_business_glossary_term' = 'Excess Volume');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `incentive_amount_earned` SET TAGS ('dbx_business_glossary_term' = 'Incentive Amount Earned');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `incentive_amount_earned` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `incentive_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Incentive Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `incentive_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `incentive_rate` SET TAGS ('dbx_business_glossary_term' = 'Incentive Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `incentive_rate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `incentive_type` SET TAGS ('dbx_business_glossary_term' = 'Incentive Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `incentive_type` SET TAGS ('dbx_value_regex' = 'per_unit_rebate|percentage_discount|fixed_bonus|tiered_rebate|none');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `last_measurement_date` SET TAGS ('dbx_business_glossary_term' = 'Last Measurement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified By');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `measurement_basis` SET TAGS ('dbx_business_glossary_term' = 'Measurement Basis');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `measurement_basis` SET TAGS ('dbx_value_regex' = 'actual_throughput|billed_throughput|manifested_cargo|vessel_arrivals|gross_revenue');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Commitment Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `penalty_amount_assessed` SET TAGS ('dbx_business_glossary_term' = 'Penalty Amount Assessed');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `penalty_amount_assessed` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `penalty_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Penalty Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `penalty_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `penalty_rate` SET TAGS ('dbx_business_glossary_term' = 'Penalty Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `penalty_rate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `penalty_type` SET TAGS ('dbx_business_glossary_term' = 'Penalty Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `penalty_type` SET TAGS ('dbx_value_regex' = 'per_unit|percentage_of_shortfall|fixed_amount|tiered|none');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `renewal_notice_days` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notice Days');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `shortfall_volume` SET TAGS ('dbx_business_glossary_term' = 'Shortfall Volume');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `waiver_approved_by` SET TAGS ('dbx_business_glossary_term' = 'Waiver Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `waiver_approved_date` SET TAGS ('dbx_business_glossary_term' = 'Waiver Approved Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ALTER COLUMN `waiver_reason` SET TAGS ('dbx_business_glossary_term' = 'Waiver Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` SET TAGS ('dbx_subdomain' = 'commercial_terms');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `pil_arrangement_id` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Arrangement ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Contract ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `arrangement_code` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Arrangement Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `arrangement_code` SET TAGS ('dbx_value_regex' = '^PIL-[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `arrangement_name` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Arrangement Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `arrangement_status` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Arrangement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `arrangement_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|terminated|under_review');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `audit_trail_required` SET TAGS ('dbx_business_glossary_term' = 'Audit Trail Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `calculation_basis` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Calculation Basis');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `collection_responsibility` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Collection Responsibility');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `collection_responsibility` SET TAGS ('dbx_value_regex' = 'port_collects|operator_remits|third_party_collects|self_assessed');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `dispute_resolution_mechanism` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Mechanism');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `dispute_resolution_mechanism` SET TAGS ('dbx_value_regex' = 'internal_review|arbitration|mediation|regulatory_appeal|court_jurisdiction');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `escalation_clause` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Escalation Clause');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `escalation_clause` SET TAGS ('dbx_value_regex' = 'none|cpi_indexed|fixed_annual|negotiated|regulatory_review');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `escalation_rate` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Escalation Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `exemption_flag` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Exemption Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `exemption_percentage` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Exemption Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `exemption_reason` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Exemption Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `last_escalation_date` SET TAGS ('dbx_business_glossary_term' = 'Last Escalation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `maximum_levy_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Port Infrastructure Levy (PIL) Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `minimum_levy_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Port Infrastructure Levy (PIL) Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Arrangement Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `rate_currency` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Rate Currency');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `rate_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `rate_type` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Rate Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `rate_value` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Rate Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `regulatory_authority` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `regulatory_instrument` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Instrument');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `remittance_due_day` SET TAGS ('dbx_business_glossary_term' = 'Remittance Due Day');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `remittance_frequency` SET TAGS ('dbx_business_glossary_term' = 'Port Infrastructure Levy (PIL) Remittance Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `reporting_category` SET TAGS ('dbx_business_glossary_term' = 'Reporting Category');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `reporting_category` SET TAGS ('dbx_value_regex' = 'infrastructure_levy|statutory_charge|concession_fee|regulatory_levy|environmental_levy');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `revenue_allocation_code` SET TAGS ('dbx_business_glossary_term' = 'Revenue Allocation Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ALTER COLUMN `revenue_allocation_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` SET TAGS ('dbx_subdomain' = 'commercial_terms');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `contract_document_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Document Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `agreement_version_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Version Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `facility_security_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Security Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Uploaded By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `access_count` SET TAGS ('dbx_business_glossary_term' = 'Document Access Count');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `checksum_hash` SET TAGS ('dbx_business_glossary_term' = 'Document Checksum Hash Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `classification` SET TAGS ('dbx_business_glossary_term' = 'Document Security Classification Level');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `classification` SET TAGS ('dbx_value_regex' = 'confidential|restricted|internal|public');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `disposal_eligible_date` SET TAGS ('dbx_business_glossary_term' = 'Document Disposal Eligible Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Document Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `document_status` SET TAGS ('dbx_business_glossary_term' = 'Document Lifecycle Status');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `document_status` SET TAGS ('dbx_value_regex' = 'draft|under_review|executed|superseded|archived|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Document Type Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Document Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Document Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `file_format` SET TAGS ('dbx_business_glossary_term' = 'File Format Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `file_reference` SET TAGS ('dbx_business_glossary_term' = 'File Storage Reference Path');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `file_size_bytes` SET TAGS ('dbx_business_glossary_term' = 'File Size in Bytes');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `keywords` SET TAGS ('dbx_business_glossary_term' = 'Document Keywords');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `language` SET TAGS ('dbx_business_glossary_term' = 'Document Language Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `last_accessed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Document Last Accessed Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `notarisation_date` SET TAGS ('dbx_business_glossary_term' = 'Notarisation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `notarisation_flag` SET TAGS ('dbx_business_glossary_term' = 'Notarisation Indicator Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `notary_name` SET TAGS ('dbx_business_glossary_term' = 'Notary Public Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `notary_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Notary Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `page_count` SET TAGS ('dbx_business_glossary_term' = 'Document Page Count');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `regulatory_approval_number` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Document Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `retention_period_years` SET TAGS ('dbx_business_glossary_term' = 'Document Retention Period in Years');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `signatory_name` SET TAGS ('dbx_business_glossary_term' = 'Signatory Full Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `signatory_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `signatory_organization` SET TAGS ('dbx_business_glossary_term' = 'Signatory Organization Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `signatory_title` SET TAGS ('dbx_business_glossary_term' = 'Signatory Position Title');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `signature_date` SET TAGS ('dbx_business_glossary_term' = 'Document Signature Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Document Title');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `translation_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Translation Required Indicator Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `upload_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Document Upload Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Document Version Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `witness_contact` SET TAGS ('dbx_business_glossary_term' = 'Witness Contact Information');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `witness_contact` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `witness_contact` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `witness_name` SET TAGS ('dbx_business_glossary_term' = 'Witness Full Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `witness_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ALTER COLUMN `witness_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` SET TAGS ('dbx_subdomain' = 'dispute_resolution');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `penalty_clause_id` SET TAGS ('dbx_business_glossary_term' = 'Penalty Clause Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `service_scope_id` SET TAGS ('dbx_business_glossary_term' = 'Service Scope Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `assessment_frequency` SET TAGS ('dbx_business_glossary_term' = 'Assessment Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `assessment_frequency` SET TAGS ('dbx_value_regex' = 'per_occurrence|monthly|quarterly|annually|at_contract_end');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `calculation_method` SET TAGS ('dbx_business_glossary_term' = 'Calculation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `calculation_method` SET TAGS ('dbx_value_regex' = 'fixed_amount|per_unit|percentage_of_contract_value|tiered_schedule');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `clause_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Clause Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `clause_status` SET TAGS ('dbx_business_glossary_term' = 'Clause Status');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `clause_status` SET TAGS ('dbx_value_regex' = 'active|suspended|waived|expired');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `clause_type` SET TAGS ('dbx_business_glossary_term' = 'Clause Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `clause_type` SET TAGS ('dbx_value_regex' = 'liquidated_damages|performance_penalty|shortfall_penalty|delay_penalty|incentive_bonus|rebate');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `cumulative_trigger_flag` SET TAGS ('dbx_business_glossary_term' = 'Cumulative Trigger Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `dispute_resolution_process` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Process');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `effective_until_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `grace_period_unit` SET TAGS ('dbx_business_glossary_term' = 'Grace Period Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `grace_period_unit` SET TAGS ('dbx_value_regex' = 'days|hours|vessel_calls|occurrences');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `grace_period_value` SET TAGS ('dbx_business_glossary_term' = 'Grace Period Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `incentive_maximum_cap_amount` SET TAGS ('dbx_business_glossary_term' = 'Incentive Maximum Cap Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `incentive_rate_value` SET TAGS ('dbx_business_glossary_term' = 'Incentive Rate Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `last_modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `measurement_period_type` SET TAGS ('dbx_business_glossary_term' = 'Measurement Period Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Clause Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `penalty_maximum_cap_amount` SET TAGS ('dbx_business_glossary_term' = 'Penalty Maximum Cap Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `penalty_rate_value` SET TAGS ('dbx_business_glossary_term' = 'Penalty Rate Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `trigger_comparison_operator` SET TAGS ('dbx_business_glossary_term' = 'Trigger Comparison Operator');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `trigger_comparison_operator` SET TAGS ('dbx_value_regex' = 'less_than|less_than_or_equal|greater_than|greater_than_or_equal|equal|not_equal');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `trigger_condition_description` SET TAGS ('dbx_business_glossary_term' = 'Trigger Condition Description');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `trigger_metric` SET TAGS ('dbx_business_glossary_term' = 'Trigger Metric');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `trigger_threshold_unit` SET TAGS ('dbx_business_glossary_term' = 'Trigger Threshold Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `trigger_threshold_value` SET TAGS ('dbx_business_glossary_term' = 'Trigger Threshold Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `waiver_approved_by` SET TAGS ('dbx_business_glossary_term' = 'Waiver Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `waiver_approved_date` SET TAGS ('dbx_business_glossary_term' = 'Waiver Approved Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ALTER COLUMN `waiver_reason` SET TAGS ('dbx_business_glossary_term' = 'Waiver Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` SET TAGS ('dbx_subdomain' = 'dispute_resolution');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `penalty_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Penalty Assessment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Contract ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `item_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Item Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Account ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `penalty_clause_id` SET TAGS ('dbx_business_glossary_term' = 'Penalty Clause Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Profile ID');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `volume_commitment_id` SET TAGS ('dbx_business_glossary_term' = 'Volume Commitment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `adjusted_amount` SET TAGS ('dbx_business_glossary_term' = 'Adjusted Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approved Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `assessed_metric_name` SET TAGS ('dbx_business_glossary_term' = 'Assessed Metric Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `assessed_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Assessed Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `assessed_value` SET TAGS ('dbx_business_glossary_term' = 'Assessed Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Assessment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `assessment_number` SET TAGS ('dbx_business_glossary_term' = 'Assessment Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `assessment_number` SET TAGS ('dbx_value_regex' = '^PA-[0-9]{8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `assessment_period_end` SET TAGS ('dbx_business_glossary_term' = 'Assessment Period End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `assessment_period_start` SET TAGS ('dbx_business_glossary_term' = 'Assessment Period Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `assessment_status` SET TAGS ('dbx_business_glossary_term' = 'Assessment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `assessment_status` SET TAGS ('dbx_value_regex' = 'draft|issued|disputed|settled|waived|paid');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `assessment_type` SET TAGS ('dbx_business_glossary_term' = 'Assessment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `assessment_type` SET TAGS ('dbx_value_regex' = 'penalty|incentive|pil|liquidated_damages|demurrage|detention');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `dispute_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `dispute_resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `exemption_amount` SET TAGS ('dbx_business_glossary_term' = 'Exemption Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `exemption_applied_flag` SET TAGS ('dbx_business_glossary_term' = 'Exemption Applied Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `exemption_reason` SET TAGS ('dbx_business_glossary_term' = 'Exemption Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `final_amount` SET TAGS ('dbx_business_glossary_term' = 'Final Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `issued_date` SET TAGS ('dbx_business_glossary_term' = 'Issued Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `payment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `payment_terms_days` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Days');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `rate_applied` SET TAGS ('dbx_business_glossary_term' = 'Rate Applied');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `rate_unit` SET TAGS ('dbx_business_glossary_term' = 'Rate Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `settlement_date` SET TAGS ('dbx_business_glossary_term' = 'Settlement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `threshold_value` SET TAGS ('dbx_business_glossary_term' = 'Threshold Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `triggering_event_reference` SET TAGS ('dbx_business_glossary_term' = 'Triggering Event Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `triggering_event_type` SET TAGS ('dbx_business_glossary_term' = 'Triggering Event Type');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ALTER COLUMN `variance_value` SET TAGS ('dbx_business_glossary_term' = 'Variance Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` SET TAGS ('dbx_subdomain' = 'dispute_resolution');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `dispute_record_id` SET TAGS ('dbx_business_glossary_term' = 'Dispute Record Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `violation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Violation Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Related Invoice Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Counterparty Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `penalty_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Penalty Assessment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned To Employee Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `sla_breach_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Breach Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Related Service Level Agreement (SLA) Profile Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `arbitration_body` SET TAGS ('dbx_business_glossary_term' = 'Arbitration Body or Institution');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `confidentiality_flag` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `corrective_action_taken` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Taken');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `dispute_description` SET TAGS ('dbx_business_glossary_term' = 'Dispute Description');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `dispute_number` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `dispute_number` SET TAGS ('dbx_value_regex' = '^DSP-[0-9]{8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `dispute_status` SET TAGS ('dbx_business_glossary_term' = 'Dispute Lifecycle Status');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `dispute_type` SET TAGS ('dbx_business_glossary_term' = 'Dispute Type Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `dispute_type` SET TAGS ('dbx_value_regex' = 'billing|sla_breach|penalty|interpretation|tariff|service_quality');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `disputed_clause_reference` SET TAGS ('dbx_business_glossary_term' = 'Disputed Contract Clause Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `escalation_level` SET TAGS ('dbx_business_glossary_term' = 'Dispute Escalation Level');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `escalation_level` SET TAGS ('dbx_value_regex' = 'operational|management|executive|board');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `final_settled_amount` SET TAGS ('dbx_business_glossary_term' = 'Final Settled Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `governing_law` SET TAGS ('dbx_business_glossary_term' = 'Governing Law Jurisdiction');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `impact_on_relationship` SET TAGS ('dbx_business_glossary_term' = 'Impact on Business Relationship');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `impact_on_relationship` SET TAGS ('dbx_value_regex' = 'none|minor|moderate|significant|relationship_terminated');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `legal_representative_counterparty` SET TAGS ('dbx_business_glossary_term' = 'Counterparty Legal Representative');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `legal_representative_port` SET TAGS ('dbx_business_glossary_term' = 'Port Legal Representative');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `mediator_name` SET TAGS ('dbx_business_glossary_term' = 'Mediator Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `notification_sent_date` SET TAGS ('dbx_business_glossary_term' = 'Formal Notification Sent Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Dispute Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `raised_by_party` SET TAGS ('dbx_business_glossary_term' = 'Dispute Raised By Party');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `raised_by_party` SET TAGS ('dbx_value_regex' = 'port|counterparty');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `raised_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Raised Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `resolution_method` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Method');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `resolution_method` SET TAGS ('dbx_value_regex' = 'negotiation|mediation|arbitration|litigation');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `resolution_outcome` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `resolution_outcome` SET TAGS ('dbx_value_regex' = 'port_favor|counterparty_favor|mutual_settlement|withdrawn|dismissed');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `resolution_target_date` SET TAGS ('dbx_business_glossary_term' = 'Resolution Target Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `response_due_date` SET TAGS ('dbx_business_glossary_term' = 'Response Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `response_received_date` SET TAGS ('dbx_business_glossary_term' = 'Response Received Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Dispute Root Cause Category');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'billing_error|service_failure|communication_breakdown|contractual_ambiguity|external_factor|system_issue');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `settlement_terms` SET TAGS ('dbx_business_glossary_term' = 'Settlement Terms and Conditions');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ALTER COLUMN `supporting_evidence_references` SET TAGS ('dbx_business_glossary_term' = 'Supporting Evidence References');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` SET TAGS ('dbx_subdomain' = 'dispute_resolution');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `guarantee_bond_id` SET TAGS ('dbx_business_glossary_term' = 'Guarantee Bond Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `agreement_party_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Party Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `customs_broker_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `parent_guarantee_bond_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Guarantee Bond Id');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `parent_guarantee_bond_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `arbitration_body` SET TAGS ('dbx_business_glossary_term' = 'Arbitration Body Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Automatic Renewal Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `beneficiary_name` SET TAGS ('dbx_business_glossary_term' = 'Bond Beneficiary Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `beneficiary_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `beneficiary_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `bond_fee_amount` SET TAGS ('dbx_business_glossary_term' = 'Bond Fee Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `bond_fee_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Bond Fee Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `bond_fee_frequency` SET TAGS ('dbx_business_glossary_term' = 'Bond Fee Payment Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `bond_fee_frequency` SET TAGS ('dbx_value_regex' = 'one_time|annual|quarterly|monthly');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `bond_number` SET TAGS ('dbx_business_glossary_term' = 'Bond Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `bond_provider_credit_rating` SET TAGS ('dbx_business_glossary_term' = 'Bond Provider Credit Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `bond_status` SET TAGS ('dbx_business_glossary_term' = 'Bond Lifecycle Status');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `bond_status` SET TAGS ('dbx_value_regex' = 'active|expired|claimed|released|suspended|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `bond_type` SET TAGS ('dbx_business_glossary_term' = 'Bond Type Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `bond_type` SET TAGS ('dbx_value_regex' = 'performance_bond|bank_guarantee|parent_company_guarantee|bid_bond|advance_payment_bond|retention_bond');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `bond_value` SET TAGS ('dbx_business_glossary_term' = 'Bond Face Value Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `claim_conditions` SET TAGS ('dbx_business_glossary_term' = 'Bond Claim Conditions');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `claim_notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Claim Notice Period in Days');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `claim_procedure` SET TAGS ('dbx_business_glossary_term' = 'Bond Claim Procedure');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `compliance_framework` SET TAGS ('dbx_business_glossary_term' = 'Compliance Framework Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Bond Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `dispute_resolution_method` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Method');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `dispute_resolution_method` SET TAGS ('dbx_value_regex' = 'litigation|arbitration|mediation|expert_determination');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `document_format` SET TAGS ('dbx_business_glossary_term' = 'Bond Document Format');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `document_format` SET TAGS ('dbx_value_regex' = 'pdf|docx|scanned_image|original_paper');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `document_reference` SET TAGS ('dbx_business_glossary_term' = 'Bond Document Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Bond Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Bond Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `governing_law` SET TAGS ('dbx_business_glossary_term' = 'Governing Law Jurisdiction');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Bond Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `last_claim_date` SET TAGS ('dbx_business_glossary_term' = 'Last Claim Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Bond Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `regulatory_approval_required` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `regulatory_authority` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Authority Name');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `remaining_bond_value` SET TAGS ('dbx_business_glossary_term' = 'Remaining Bond Value');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `renewal_notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notice Period in Days');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `renewal_terms` SET TAGS ('dbx_business_glossary_term' = 'Bond Renewal Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `review_date` SET TAGS ('dbx_business_glossary_term' = 'Bond Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `risk_assessment_rating` SET TAGS ('dbx_business_glossary_term' = 'Bond Risk Assessment Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `risk_assessment_rating` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `security_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Security Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `total_claimed_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Claimed Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `total_claims_count` SET TAGS ('dbx_business_glossary_term' = 'Total Claims Count');
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ALTER COLUMN `total_paid_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Paid Amount');
