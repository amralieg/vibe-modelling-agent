-- Schema for Domain: billing | Business: Shipping_Ports | Version: v2_mvm
-- Generated on: 2026-07-13 10:24:15

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`billing` COMMENT 'Manages invoicing, revenue collection, payment processing, accounts receivable, billing disputes, credit management, financial settlements, and revenue recognition for all port services rendered. Covers invoice generation from TOS (NAVIS N4), payment tracking, chargebacks, and EBITDA-level revenue reporting. Integrates with SAP S/4HANA FI. SSOT for all revenue transactions and customer billing.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` (
    `invoice_id` BIGINT COMMENT 'Unique identifier for the invoice record. Primary key for the invoice entity.',
    `agent_appointment_id` BIGINT COMMENT 'Foreign key linking to vessel.agent_appointment. Business justification: Disbursement account (DA) invoices are issued under a specific agent appointment that defines billing authority and commission structure. Linking invoice to agent_appointment supports DA billing recon',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Berth hire invoices for long-term berth leasing to shipping lines or terminal operators are issued at the berth level. A berth hire invoice must reference the specific berth being leased for lease man',
    `facility_id` BIGINT COMMENT 'Foreign key linking to infrastructure.facility. Business justification: Facility lease invoices and terminal concession fee invoices are issued at the facility level. Facility-level revenue reporting and lease management require invoices to directly reference the specific',
    `flag_state_id` BIGINT COMMENT 'Foreign key linking to masterdata.flag_state. Business justification: Vessel flag state determines applicable port charge exemptions, bilateral agreements, and regulatory fee structures. Critical for international maritime billing compliance and tariff application.',
    `participant_account_id` BIGINT COMMENT 'Reference to the port community participant (shipping line, freight forwarder, cargo owner) being invoiced. Links to customer master data.',
    `participant_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.participant_service_agreement. Business justification: Invoices are generated under a specific participant service agreement that governs negotiated rates, payment terms, and discounts. Port billing teams must trace each invoice back to the governing cont',
    `port_call_id` BIGINT COMMENT 'Foreign key linking to vessel.port_call. Business justification: Port call invoices (berth dues, terminal handling charges) are raised against port_call records. port_call carries total_port_charges_amount and call_performance_rating used in billing reconciliation.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Each invoice is generated within a specific billing cycle. The billing_cycle table contains cycle_code, start_date, end_date, fiscal_year, fiscal_period. Adding billing_cycle_id allows JOIN to retriev',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Multi-port operators issue invoices from a specific port entity. Port-level P&L, revenue attribution, and regulatory reporting require invoices to be directly linked to the issuing port, distinct from',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Invoices track which terminal or operational cost center generated revenue. Essential for profitability analysis by berth, terminal, or service line. Management reporting requires cost center attribut',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Invoices must reference the published port tariff schedule under which charges were calculated for regulatory compliance, audit trail, and dispute resolution. Maritime port authorities require invoice',
    `psc_inspection_id` BIGINT COMMENT 'Foreign key linking to vessel.psc_inspection. Business justification: PSC detention and inspection fees are invoiced to the vessel owner/agent. Linking invoice to psc_inspection enables direct traceability from the regulatory inspection to the billing document, supporti',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: When invoicing under negotiated commercial agreements, invoice must reference the applicable rate card for contract compliance, audit trail, and to distinguish negotiated rates from published tariff r',
    `service_id` BIGINT COMMENT 'Foreign key linking to intermodal.intermodal_service. Business justification: Invoices for intermodal service usage (rail shuttle, truck relay contracts) reference the specific service being billed. invoice.service_type is a denormalized string; replacing with intermodal_servic',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Invoices are often addressed to shipping lines as the commercial party responsible for vessel operations charges. Essential for shipping line account management and consolidated billing processes.',
    `sla_profile_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Invoices in maritime ports must reference master service agreements for rate validation, payment terms inheritance, revenue allocation, and contract compliance auditing. Essential for contract-based b',
    `transport_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.transport_order. Business justification: Invoices are raised against transport orders for multimodal logistics billing. Port billing teams require direct traceability from invoice to transport order for revenue recognition, dispute resolutio',
    `call_id` BIGINT COMMENT 'Reference to the vessel call for which services were rendered. Links invoice to specific vessel visit and berth allocation.',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Port dues, pilotage, and towage invoices are calculated directly from vessel GRT/NRT stored in vessel_master. Port billing teams generate vessel-level invoice registers and flag-state revenue reports ',
    `voyage_id` BIGINT COMMENT 'Foreign key linking to vessel.voyage. Business justification: Voyage-level disbursement account (DA) invoices are standard in port agency billing — a single invoice covers all charges for a voyage across multiple calls. Linking invoice to voyage supports DA reco',
    `adjustment_amount` DECIMAL(18,2) COMMENT 'Net adjustment amount for credits, chargebacks, or billing corrections. Can be positive or negative.',
    `baf_amount` DECIMAL(18,2) COMMENT 'Bunker Adjustment Factor surcharge applied to compensate for fuel price fluctuations. Common in maritime billing.',
    `bol_number` STRING COMMENT 'Bill of Lading reference number for cargo-related charges. Links invoice to specific cargo shipment documentation.. Valid values are `^[A-Z0-9]{10,20}$`',
    `caf_amount` DECIMAL(18,2) COMMENT 'Currency Adjustment Factor surcharge applied to compensate for exchange rate fluctuations. Common in international maritime billing.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this invoice record was first created in the billing system. Audit trail for record creation.',
    `credit_note_number` STRING COMMENT 'Credit note number issued against this invoice for refunds, adjustments, or dispute resolutions. Links to credit memo document.. Valid values are `^CN-[0-9]{8,12}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the invoice amount (e.g., USD, EUR, GBP). Defines the monetary unit for all amounts.. Valid values are `^[A-Z]{3}$`',
    `delivery_method` STRING COMMENT 'Channel through which the invoice was delivered to the customer. Supports multi-channel billing communication.. Valid values are `email|postal_mail|edi|portal|fax`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total discount amount applied to the invoice based on volume agreements, early payment terms, or promotional offers.',
    `dispute_date` DATE COMMENT 'Date the invoice was formally disputed by the customer. Triggers dispute resolution workflow.',
    `dispute_reason` STRING COMMENT 'Reason provided by customer for disputing the invoice. Captured when invoice status transitions to disputed.',
    `due_date` DATE COMMENT 'Date by which payment is expected per the agreed payment terms. Used for accounts receivable aging and overdue calculation.',
    `invoice_date` DATE COMMENT 'Date the invoice was officially issued to the customer. Principal business event timestamp for revenue recognition and accounts receivable aging.',
    `invoice_number` STRING COMMENT 'Externally-known unique invoice number issued to port community participants. Generated from NAVIS N4 TOS billing module and synchronized with SAP S/4HANA FI document number.. Valid values are `^INV-[0-9]{8,12}$`',
    `invoice_status` STRING COMMENT 'Current lifecycle status of the invoice in the billing workflow. Tracks progression from draft through payment or dispute resolution. [ENUM-REF-CANDIDATE: draft|issued|paid|partially_paid|disputed|cancelled|overdue — 7 candidates stripped; promote to reference product]',
    `modified_by_user` STRING COMMENT 'User identifier or system account that last modified this invoice record. Audit trail for change tracking.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this invoice record was last modified. Audit trail for record updates and billing adjustments.',
    `payment_method` STRING COMMENT 'Method by which payment is expected or received. Instrument used for settlement of the invoice. [ENUM-REF-CANDIDATE: bank_transfer|wire_transfer|credit_card|debit_card|check|cash|edi_payment|direct_debit — 8 candidates stripped; promote to reference product]',
    `payment_received_date` DATE COMMENT 'Date payment was received and cleared in the port authority bank account. Used for cash flow reporting and revenue recognition.',
    `payment_reference_number` STRING COMMENT 'Bank transaction reference or remittance advice number provided with payment. Used for payment reconciliation.',
    `payment_terms` STRING COMMENT 'Agreed payment terms defining the number of days from invoice date until payment is due. Determines due date calculation. [ENUM-REF-CANDIDATE: net_7|net_15|net_30|net_45|net_60|net_90|due_on_receipt|prepaid — 8 candidates stripped; promote to reference product]',
    `pod_code` STRING COMMENT 'UN/LOCODE five-character code identifying the port of discharge for the cargo. Used for trade lane analysis and tariff determination.. Valid values are `^[A-Z]{5}$`',
    `pol_code` STRING COMMENT 'UN/LOCODE five-character code identifying the port of loading for the cargo. Used for trade lane analysis and tariff determination.. Valid values are `^[A-Z]{5}$`',
    `remarks` STRING COMMENT 'Free-text remarks or special instructions related to this invoice. Used for billing notes, customer communications, or internal annotations.',
    `revenue_recognition_date` DATE COMMENT 'Date on which revenue from this invoice is recognized in financial statements per IFRS 15 criteria. May differ from invoice date.',
    `sap_document_number` STRING COMMENT 'SAP S/4HANA FI accounting document number for this invoice. Links billing record to financial accounting system of record.. Valid values are `^[0-9]{10}$`',
    `subtotal_amount` DECIMAL(18,2) COMMENT 'Total amount of all line items before taxes, adjustments, and discounts. Base amount for revenue calculation.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount applied to the invoice, including VAT, GST, or other applicable taxes per jurisdiction.',
    `tax_exemption_certificate_number` STRING COMMENT 'Reference number of the tax exemption certificate on file justifying tax exemption status. Required for audit compliance.',
    `tax_exemption_flag` BOOLEAN COMMENT 'Indicates whether this invoice is exempt from taxation due to customer status, service type, or regulatory exemption.',
    `tax_jurisdiction_code` STRING COMMENT 'Tax jurisdiction code determining which tax rates and rules apply to this invoice. ISO country code or regional tax authority identifier.. Valid values are `^[A-Z]{2,3}$`',
    `total_amount` DECIMAL(18,2) COMMENT 'Final total amount due including subtotal, taxes, discounts, and adjustments. Net amount payable by customer.',
    CONSTRAINT pk_invoice PRIMARY KEY(`invoice_id`)
) COMMENT 'Core billing document issued to port community participants (shipping lines, freight forwarders, cargo owners) for all port services rendered. Generated from NAVIS N4 TOS and integrated with SAP S/4HANA FI. Captures invoice number, invoice date, due date, billing period, total amount, currency, tax amount, invoice status (draft/issued/paid/disputed/cancelled), payment terms, vessel call reference, BOL reference, service type (THC, wharfage, pilotage, demurrage, detention), port of loading/discharge, and SAP document number. SSOT for all revenue billing documents.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` (
    `invoice_line_id` BIGINT COMMENT 'Unique identifier for the invoice line item. Primary key for the invoice_line product.',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Anchorage occupancy charges (daily fees for vessels waiting at anchorage) must reference which anchorage area was used for accurate billing and anchorage utilization revenue tracking. Standard practic',
    `berth_id` BIGINT COMMENT 'Reference to the berth where the service was rendered. Applicable for berth-related charges and terminal operations.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Channel-dependent charges (pilotage fees varying by channel depth/length, channel maintenance levies) must reference which channel was used. Essential for ports with multiple approach channels having ',
    `charge_event_id` BIGINT COMMENT 'Foreign key linking to billing.charge_event. Business justification: Invoice lines are generated from charge events captured in NAVIS N4 TOS. The invoice_line table has navis_charge_code, and charge_event table has reference and source_system_reference. Adding charge_e',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Container and cargo charges require commodity classification for correct tariff application, hazmat surcharges, and customs compliance reporting. Critical for cargo-specific billing accuracy.',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: Service charges vary by commodity classification (hazmat surcharges, refrigerated cargo fees, special handling for restricted goods). Line items reference HS codes for tariff application, regulatory r',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Individual service line items (container storage, cargo handling, inspection fees) are tied to specific customs declarations. Required for line-level audit trails showing which charges apply to which ',
    `discount_scheme_id` BIGINT COMMENT 'Foreign key linking to tariff.discount_scheme. Business justification: Invoice lines carrying discounts must reference the discount scheme applied. Discount audit trails, approval workflows, and customer entitlement verification all require line-level discount scheme tra',
    `drayage_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.drayage_order. Business justification: Drayage service charge line items on invoices reference the specific drayage order being billed. Port billing requires line-item-to-drayage-order traceability for drayage cost breakdown reports and pr',
    `equipment_id` BIGINT COMMENT 'Reference to the port equipment used to provide the service (crane, RTG, AGV). Enables equipment utilization and cost allocation analysis.',
    `facility_id` BIGINT COMMENT 'Foreign key linking to infrastructure.facility. Business justification: Invoice lines for dry dock, ship repair, passenger terminal, and other port facility services must reference the specific facility. Facility-level revenue reporting and service billing reconciliation ',
    `handling_order_id` BIGINT COMMENT 'Foreign key linking to cargo.handling_order. Business justification: Invoice lines for terminal handling charges (THC, crane, labor, equipment) must reference the specific handling_order that generated them. Essential for operational reconciliation (planned vs actual b',
    `icd_facility_id` BIGINT COMMENT 'Foreign key linking to intermodal.icd_facility. Business justification: ICD storage and handling charges appear as invoice line items referencing the specific ICD facility. invoice_line has warehouse_id for port warehouse charges; icd_facility_id is the equivalent for inl',
    `import_export_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.import_export_permit. Business justification: Invoice lines for controlled goods handling, permit processing fees, and re-inspection charges must reference the specific import/export permit. Port billing teams need this link to validate permit-ba',
    `invoice_id` BIGINT COMMENT 'Reference to the parent invoice header. Links this line item to the invoice transaction.',
    `item_id` BIGINT COMMENT 'Foreign key linking to tariff.tariff_item. Business justification: Each invoice line item must link to the specific tariff item that defines the rate, unit of measure, calculation basis, and terms. Essential for charge validation, dispute resolution, and ensuring inv',
    `marpol_record_id` BIGINT COMMENT 'Foreign key linking to compliance.marpol_record. Business justification: Line items for waste disposal services billed to vessels per MARPOL requirements. Standard port billing practice requiring detailed traceability from invoice line to specific waste reception record fo',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Container handling charges vary by ISO type (20ft/40ft/45ft, standard/reefer/OOG). Container type master linkage ensures correct TEU-based tariff application and equipment-specific billing.',
    `original_invoice_line_id` BIGINT COMMENT 'Reference to the original invoice line if this is an adjustment or correction. Enables audit trail for billing changes and credit notes.',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.participant_account. Business justification: Each invoice line item satisfies a performance obligation per IFRS 15. The performance_obligation table defines revenue_recognition_method and satisfaction_criteria. This FK enables IFRS 15-compliant ',
    `port_dues_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.port_dues_schedule. Business justification: Invoice lines for port dues must reference the port dues schedule. Vessel operators verifying port dues invoices and port authority revenue reporting both require line-level traceability to the dues s',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Each service line may be delivered by different operational units (berth 3 vs berth 5). Operational cost recovery analysis requires line-level cost center attribution to match revenue with operational',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Each invoice line item must trace to contracted rate schedule for tariff audit, regulatory compliance (port authority rate filing), and billing dispute resolution. Core linkage for automated rate appl',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_visit. Business justification: Rail terminal handling charge line items (wagon handling, TEU lift, track usage) are tied to specific rail visits. invoice_line already has vessel_call_id for vessel charges; rail_visit_id mirrors thi',
    `rate_card_line_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card_line. Business justification: Line items invoiced under negotiated rates must link to the specific rate card line that defines the agreed unit rate, volume tiers, and service level. Required for contract compliance verification an',
    `service_id` BIGINT COMMENT 'Foreign key linking to intermodal.intermodal_service. Business justification: Invoice line items for intermodal service charges (rail shuttle fee, truck relay fee) reference the specific contracted service. Enables service-level revenue analysis, rate card compliance checking, ',
    `spare_part_id` BIGINT COMMENT 'Foreign key linking to asset.spare_part. Business justification: Spare parts supplied from port inventory to vessel operators or third-party contractors are billed as invoice line items. Port billing must reference the specific spare_part to validate unit cost, app',
    `storage_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.storage_tariff. Business justification: Invoice lines for storage and demurrage charges must reference the storage tariff. Demurrage disputes require line-level traceability to the storage tariff (free-time days, rate bands) to resolve cust',
    `surcharge_rule_id` BIGINT COMMENT 'Foreign key linking to tariff.surcharge_rule. Business justification: Invoice lines for surcharges (BAF, CAF, ISPS, environmental levy) must reference the surcharge rule applied. Customer invoice queries and regulatory surcharge justification require line-level rule tra',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Container handling and ground slot charges must reference the terminal zone where services occurred for zone-level revenue analysis and operational cost allocation. Critical for multi-terminal port op',
    `thc_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.thc_schedule. Business justification: Invoice lines for THC charges must reference the THC schedule used for pricing. Shipping lines and freight forwarders routinely query THC invoice lines against published schedules; port revenue audito',
    `transport_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.transport_order. Business justification: Individual invoice line items correspond to specific transport order legs (pickup, delivery, handling). Port billing requires line-item traceability to transport orders for charge verification, disput',
    `truck_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.truck_visit. Business justification: Truck gate charges (gate-in/out fees, turnaround penalties) appear as invoice line items tied to specific truck visits. Direct FK enables truck visit charge auditing and gate revenue line-item reporti',
    `call_id` BIGINT COMMENT 'Reference to the vessel call if this line item relates to vessel-specific services (pilotage, towage, berth charges). Links the charge to the vessel visit.',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Individual invoice lines for port dues, light dues, and conservancy charges are rated per GRT/NRT from vessel_master. Auditors and revenue accountants require direct vessel_master linkage at line leve',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Cargo storage charges must reference which warehouse facility provided the service for accurate billing and warehouse-level revenue tracking. Essential for bonded vs non-bonded storage differentiation',
    `wharfage_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.wharfage_schedule. Business justification: Invoice lines for wharfage charges must reference the wharfage schedule applied. Port revenue auditors and cargo owners disputing wharfage charges need direct traceability to the applicable schedule t',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Contractor and maintenance service invoice lines must reference the originating work order for billing validation, dispute resolution, and cost allocation to vessel operators or port customers. Port f',
    `adjustment_flag` BOOLEAN COMMENT 'Indicates whether this line item is a billing adjustment or correction. True for adjustments (credit notes, rebills), False for original charges.',
    `bol_number` STRING COMMENT 'Bill of Lading number associated with this line item. Links the charge to the specific cargo shipment documentation.. Valid values are `^[A-Z0-9]{8,20}$`',
    `charge_category` STRING COMMENT 'Classification of the charge type. THC=Terminal Handling Charge, WHR=Wharfage, DMG=Demurrage, DET=Detention, BAF=Bunker Adjustment Factor, CAF=Currency Adjustment Factor. Enables revenue analysis by charge category. [ENUM-REF-CANDIDATE: THC|WHR|DMG|DET|BAF|CAF|PILOTAGE|TOWAGE|STORAGE|HANDLING|BERTH|SECURITY — 12 candidates stripped; promote to reference product]',
    `container_number` STRING COMMENT 'ISO 6346 container identification number if this line item relates to a specific container. Format: 4 letters (owner code) + 7 digits (serial number + check digit).. Valid values are `^[A-Z]{4}[0-9]{7}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this invoice line record was first created in the system. Audit field for data lineage and compliance.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts on this line (unit rate, line amount, tax amount, net amount).. Valid values are `^[A-Z]{3}$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Monetary value of discount applied to this line item. Reduces the line amount before tax calculation.',
    `dispute_flag` BOOLEAN COMMENT 'Indicates whether this line item is under dispute by the customer. True if disputed, False otherwise. Affects accounts receivable aging and collection processes.',
    `dispute_reason` STRING COMMENT 'Free-text description of the reason for dispute if dispute_flag is True. Captures customer objections and billing discrepancies.',
    `line_amount` DECIMAL(18,2) COMMENT 'Gross amount for this line item before tax. Calculated as quantity multiplied by unit rate, plus any applicable adjustments.',
    `line_number` STRING COMMENT 'Sequential line number within the invoice. Determines the ordering and display sequence of line items on the invoice document.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this invoice line record was last modified. Audit field for change tracking and data governance.',
    `net_amount` DECIMAL(18,2) COMMENT 'Net amount for this line item including tax. Sum of line amount and tax amount. Contributes to the invoice total.',
    `notes` STRING COMMENT 'Free-text notes or comments related to this line item. Captures special instructions, billing clarifications, or operational context.',
    `quantity` DECIMAL(18,2) COMMENT 'Quantity of the service rendered. May represent TEUs, FEUs, CBM, hours, moves, or other units depending on the service type.',
    `revenue_recognition_date` DATE COMMENT 'Date when revenue for this line item is recognized in the financial statements. May differ from invoice date based on revenue recognition policies.',
    `service_end_timestamp` TIMESTAMP COMMENT 'Timestamp when the service was completed. Used to calculate duration-based charges and service level agreement compliance.',
    `service_start_timestamp` TIMESTAMP COMMENT 'Timestamp when the service commenced. Used for time-based charges such as storage, demurrage, and detention calculations.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax amount calculated for this line item. Derived from line amount multiplied by tax rate.',
    `tax_code` STRING COMMENT 'Tax code determining the tax treatment for this line item. References the tax jurisdiction and rate applicable to the service.. Valid values are `^[A-Z0-9]{2,6}$`',
    `tax_rate` DECIMAL(18,2) COMMENT 'Tax rate percentage applied to this line item. Expressed as a percentage (e.g., 10.00 for 10% tax).',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the quantity. TEU=Twenty-foot Equivalent Unit, FEU=Forty-foot Equivalent Unit, CBM=Cubic Meter. Aligns with maritime logistics industry standards. [ENUM-REF-CANDIDATE: TEU|FEU|CBM|HOUR|MOVE|TON|UNIT|DAY — 8 candidates stripped; promote to reference product]',
    `unit_rate` DECIMAL(18,2) COMMENT 'Rate per unit of measure. The price charged for one unit of the service (e.g., rate per TEU, rate per hour).',
    CONSTRAINT pk_invoice_line PRIMARY KEY(`invoice_line_id`)
) COMMENT 'Individual line items on a port services invoice, each representing a discrete chargeable service or tariff component. Captures line number, service code, service description, tariff item reference, quantity (TEUs, FEUs, CBM, hours, moves), unit of measure, unit rate, line amount, tax code, tax amount, net amount, container number, BOL reference, vessel call ID, charge category (THC, WHR, DMG, DET, BAF, CAF, pilotage, towage, storage), and NAVIS N4 charge code. Enables granular revenue analysis at the service level.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`billing`.`payment` (
    `payment_id` BIGINT COMMENT 'Unique identifier for the payment record. Primary key for the payment entity.',
    `invoice_id` BIGINT COMMENT 'Reference to the invoice against which this payment is applied. Links payment to billing document.',
    `participant_account_id` BIGINT COMMENT 'Reference to the port community participant account making the payment. Identifies the payer.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Payments are allocated to billing cycles for period accounting and cash flow reporting. This FK enables cycle-based payment analysis. Keeps fiscal_year and fiscal_period on payment as execution-specif',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Payment cost center attribution enables cash collection performance tracking by operational unit. Port finance teams measure collection efficiency by terminal or service division for working capital m',
    `receivable_account_id` BIGINT COMMENT 'Foreign key linking to billing.receivable_account. Business justification: Payments are received and applied against a customers receivable account — the AR master record. Adding receivable_account_id to payment directly links each payment receipt to the authoritative AR ac',
    `sanctions_screening_id` BIGINT COMMENT 'Foreign key linking to compliance.sanctions_screening. Business justification: Payments received at ports must be screened against sanctions lists (AML/CFT compliance). The payment-level sanctions screening is distinct from cargo/vessel screening and is required by financial reg',
    `allocated_amount` DECIMAL(18,2) COMMENT 'Portion of the payment amount that has been allocated to specific invoices. May be less than amount_paid if payment is partially applied or held on account.',
    `amount_paid` DECIMAL(18,2) COMMENT 'Total amount paid in the transaction currency. Represents the gross payment received before any adjustments or allocations.',
    `bank_reference` STRING COMMENT 'Bank transaction reference or confirmation number provided by the financial institution. Used for payment tracing and dispute resolution.',
    `base_currency_amount` DECIMAL(18,2) COMMENT 'Payment amount converted to the ports base reporting currency using the exchange rate. Used for consolidated financial reporting and EBITDA calculation.',
    `channel` STRING COMMENT 'Channel or interface through which the payment was submitted (online portal, bank transfer, Port Community System, SAP, manual entry, or Electronic Data Interchange).. Valid values are `online_portal|bank_transfer|PCS|SAP|manual_entry|EDI`',
    `clearing_date` DATE COMMENT 'Date when the payment was cleared and funds were confirmed available in the ports bank account. Format: yyyy-MM-dd.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this payment record was first created in the system. Used for audit trail and data lineage. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the payment amount (e.g., USD, EUR, GBP, SGD).. Valid values are `^[A-Z]{3}$`',
    `discount_taken` DECIMAL(18,2) COMMENT 'Early payment discount amount claimed by the customer and deducted from the invoice total. Reflects payment terms incentives.',
    `dispute_reference` STRING COMMENT 'Reference number for payment dispute case if reconciliation status is disputed. Links to dispute resolution workflow.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Exchange rate applied to convert payment currency to port base currency. Used for multi-currency payment reconciliation and financial reporting.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month) within the fiscal year when the payment was received. Used for monthly financial close and reporting.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the payment was received. Used for annual financial reporting and revenue recognition.',
    `is_advance_payment` BOOLEAN COMMENT 'Boolean flag indicating whether this is an advance payment received before services are rendered. True if advance, False otherwise.',
    `method` STRING COMMENT 'Method or instrument used to make the payment. Indicates how funds were transferred (Electronic Funds Transfer, SWIFT wire, cheque, direct debit, letter of credit, or cash).. Valid values are `EFT|SWIFT|cheque|direct_debit|letter_of_credit|cash`',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this payment record was last modified. Used for audit trail and change tracking. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `navis_billing_reference` STRING COMMENT 'Reference to the NAVIS N4 Terminal Operating System billing transaction that generated the invoice. Links payment back to operational billing source.',
    `notes` STRING COMMENT 'Free-text notes or comments related to the payment. May include remittance advice, special instructions, or reconciliation remarks.',
    `payer_account_number` STRING COMMENT 'Bank account number from which the payment originated. Used for payment verification and reconciliation. Business-confidential financial information.',
    `payer_bank_name` STRING COMMENT 'Name of the financial institution from which the payment was sent. Used for payment tracing and reconciliation.',
    `payment_date` DATE COMMENT 'Date when the payment was received or processed by the port authority. Format: yyyy-MM-dd.',
    `payment_status` STRING COMMENT 'Current status of the payment in the accounts receivable lifecycle. Tracks payment from receipt through clearing and application to invoices.. Valid values are `pending|cleared|bounced|reversed|partially_applied|fully_applied`',
    `payment_type` STRING COMMENT 'Classification of payment purpose. Distinguishes between advance payments, payments on account, invoice settlements, refunds, and credit note applications.. Valid values are `advance|on_account|invoice_payment|refund|credit_note_settlement`',
    `received_timestamp` TIMESTAMP COMMENT 'Date and time when the payment was first received or recorded in the system. Principal business event timestamp. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `reconciled_timestamp` TIMESTAMP COMMENT 'Date and time when the payment was reconciled. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `reconciliation_status` STRING COMMENT 'Status of payment reconciliation against bank statements and invoice records. Tracks whether payment has been matched and verified.. Valid values are `unreconciled|reconciled|disputed|under_review`',
    `reference_number` STRING COMMENT 'External payment reference number provided by the payer or payment system. Used for reconciliation and customer inquiries.',
    `remittance_advice_reference` STRING COMMENT 'Reference number from the remittance advice document sent by the payer. Links payment to payers accounts payable records.',
    `reversal_date` DATE COMMENT 'Date when the payment was reversed or bounced. Null if payment has not been reversed. Format: yyyy-MM-dd.',
    `reversal_reason` STRING COMMENT 'Explanation for payment reversal if payment status is reversed. Documents reason for chargeback, NSF (non-sufficient funds), or cancellation.',
    `sap_clearing_document_number` STRING COMMENT 'SAP FI clearing document number generated when payment is applied against open invoice items. Links to SAP accounts receivable clearing process.',
    `sap_payment_document_number` STRING COMMENT 'SAP FI payment document number created during payment posting. Primary reference for financial audit trail in SAP S/4HANA.',
    `unapplied_amount` DECIMAL(18,2) COMMENT 'Portion of the payment amount not yet allocated to invoices. Held on account for future invoice settlement or refund.',
    CONSTRAINT pk_payment PRIMARY KEY(`payment_id`)
) COMMENT 'Records of payments received from port customers against outstanding invoices. Captures payment reference number, payment date, payment method (EFT, SWIFT, cheque, direct debit, letter of credit), amount paid, currency, exchange rate, bank reference, clearing date, SAP clearing document number, payer account, payment status (pending/cleared/bounced/reversed), and allocation to invoices. SSOT for all inbound revenue cash receipts and accounts receivable clearing. Integrates with SAP S/4HANA FI payment clearing.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` (
    `payment_allocation_id` BIGINT COMMENT 'Unique identifier for the payment allocation record. Primary key for the payment allocation entity.',
    `adjustment_id` BIGINT COMMENT 'Foreign key linking to billing.adjustment. Business justification: Payment allocations can be applied against credit adjustments (credit memos) to reduce receivables. This FK enables tracking of payments allocated to credit adjustments, completing the payment allocat',
    `debit_note_id` BIGINT COMMENT 'Foreign key linking to billing.debit_note. Business justification: Payment allocations can be applied against debit notes (additional charges). This FK enables tracking of payments allocated to debit notes, completing the payment allocation model (currently links to ',
    `invoice_id` BIGINT COMMENT 'Reference to the invoice receiving the payment allocation. Links to the invoice record generated from NAVIS N4 billing module.',
    `invoice_line_id` BIGINT COMMENT 'Reference to the specific invoice line item receiving the allocation. Nullable when allocation applies to entire invoice rather than specific line.',
    `payment_id` BIGINT COMMENT 'Reference to the payment transaction being allocated. Links to the payment record in the payment processing system.',
    `accounting_period` STRING COMMENT 'Financial period (YYYY-MM format) to which this allocation is posted. Critical for period-end close, revenue recognition, and financial reporting.. Valid values are `^[0-9]{4}-(0[1-9]|1[0-2])$`',
    `allocated_amount` DECIMAL(18,2) COMMENT 'The monetary amount allocated from the payment to the invoice or invoice line. Represents the portion of payment applied to reduce outstanding balance.',
    `allocation_date` DATE COMMENT 'The date when the payment was allocated to the invoice. Critical for accounts receivable aging and financial period assignment.',
    `allocation_reference` STRING COMMENT 'Business reference number for the payment allocation transaction. Used for tracking and reconciliation purposes across systems.. Valid values are `^[A-Z0-9]{8,20}$`',
    `allocation_source` STRING COMMENT 'System or process that created the allocation. Manual: user-entered; Automated: system-matched; EDI: electronic data interchange; Lockbox: bank lockbox service; API: external system integration.. Valid values are `manual|automated|edi|lockbox|api`',
    `allocation_status` STRING COMMENT 'Current processing status of the allocation. Pending: awaiting confirmation; Confirmed: successfully applied; Reversed: allocation undone; Cancelled: allocation voided; Disputed: under review for billing dispute.. Valid values are `pending|confirmed|reversed|cancelled|disputed`',
    `allocation_timestamp` TIMESTAMP COMMENT 'Precise date and time when the allocation was processed in the system. Used for audit trail and reconciliation timing.',
    `allocation_type` STRING COMMENT 'Classification of the allocation transaction. Full: entire invoice paid; Partial: portion of invoice paid; Advance: payment before invoice; Overpayment: payment exceeds invoice; On-account: unallocated payment held for future invoices; Credit-note: allocation from credit memo.. Valid values are `full|partial|advance|overpayment|on_account|credit_note`',
    `bank_reconciliation_reference` STRING COMMENT 'Reference number from bank statement used to match and reconcile this allocation. Critical for automated cash application and bank reconciliation processes.',
    `business_area` STRING COMMENT 'Business area code for cross-company financial reporting. Enables consolidated financial statements across multiple legal entities.. Valid values are `^[A-Z0-9]{4}$`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity for which the allocation is recorded. Critical for multi-entity financial consolidation.. Valid values are `^[A-Z0-9]{4}$`',
    `cost_center` STRING COMMENT 'Cost center code for internal cost allocation and profitability analysis. Links revenue collection to organizational units.. Valid values are `^[A-Z0-9]{4,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the allocation record was first created in the database. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the allocated amount. Supports multi-currency payment allocation for international trade transactions.. Valid values are `^[A-Z]{3}$`',
    `discount_taken` DECIMAL(18,2) COMMENT 'Early payment discount amount deducted during allocation. Reflects payment terms incentives such as 2/10 net 30. Reduces allocated amount but clears full invoice value.',
    `dispute_flag` BOOLEAN COMMENT 'Indicates whether this allocation is under dispute. True when customer has raised a billing dispute affecting this allocation. Impacts accounts receivable aging classification.',
    `dispute_reference` STRING COMMENT 'Reference to the billing dispute case if allocation is disputed. Links to dispute resolution workflow. Nullable when no dispute exists.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Currency exchange rate applied when payment currency differs from invoice currency. Used for multi-currency allocation and foreign exchange gain/loss calculation.',
    `fiscal_year` STRING COMMENT 'Fiscal year to which the allocation belongs. Supports financial reporting and year-end close processes.',
    `local_currency_amount` DECIMAL(18,2) COMMENT 'Allocated amount converted to the company code local currency using the exchange rate. Used for financial reporting in local GAAP.',
    `modified_by_user` STRING COMMENT 'User ID or system account that last modified the allocation record. Supports audit trail and change tracking.',
    `modified_timestamp` TIMESTAMP COMMENT 'System timestamp when the allocation record was last updated. Tracks changes for audit and reconciliation purposes.',
    `notes` STRING COMMENT 'Free-text notes or comments regarding the allocation. Used for documenting special circumstances, manual adjustments, or reconciliation details.',
    `outstanding_balance` DECIMAL(18,2) COMMENT 'The remaining unpaid balance on the invoice after this allocation is applied. Zero indicates invoice is fully paid. Critical for accounts receivable aging reports.',
    `profit_center` STRING COMMENT 'Profit center code for segment reporting and EBITDA-level revenue analysis. Supports business unit performance measurement.. Valid values are `^[A-Z0-9]{4,10}$`',
    `reversal_date` DATE COMMENT 'Date when the allocation was reversed or cancelled. Nullable for active allocations. Used for audit trail and financial period correction.',
    `reversal_document` STRING COMMENT 'SAP FI document number of the reversal transaction. Links to the offsetting entry that undoes the original allocation. Nullable for non-reversed allocations.. Valid values are `^[0-9]{10}$`',
    `reversal_reason` STRING COMMENT 'Business justification for reversing or cancelling the allocation. Nullable when allocation is not reversed. Examples: payment error, invoice dispute, incorrect amount, duplicate payment.',
    `sap_clearing_document` STRING COMMENT 'SAP S/4HANA FI clearing document number that links the payment and invoice in the financial system. Critical for financial close and reconciliation.. Valid values are `^[0-9]{10}$`',
    `sap_clearing_item` STRING COMMENT 'Line item number within the SAP clearing document. Enables precise traceability to specific line-level clearing entries in SAP FI.. Valid values are `^[0-9]{3}$`',
    `withholding_tax_deducted` DECIMAL(18,2) COMMENT 'Tax amount withheld at source during payment allocation as per jurisdictional tax regulations. Common in international maritime trade transactions.',
    CONSTRAINT pk_payment_allocation PRIMARY KEY(`payment_allocation_id`)
) COMMENT 'Association entity linking individual payments to specific invoices or invoice lines, enabling many-to-many cash application where one payment covers multiple invoices or one invoice receives multiple partial payments. Captures allocation reference, allocation date, allocated amount, allocation type (full/partial/advance/overpayment/on-account), outstanding balance after allocation, discount taken, withholding tax deducted, SAP clearing item reference, allocation status (pending/confirmed/reversed), and reversal reason if applicable. Critical for accurate accounts receivable aging, bank reconciliation, cash application automation, and financial close in SAP S/4HANA FI.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` (
    `adjustment_id` BIGINT COMMENT 'Primary key for adjustment',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.dredging_campaign. Business justification: Credits issued for service disruptions during dredging (berth closures, draft restrictions) must reference the dredging campaign for cost recovery tracking and customer dispute resolution. Links reven',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Credit note adjustments are frequently triggered by customs declaration amendments (re-classification, valuation corrections, duty recalculations). Port billing teams must link adjustments to the orig',
    `delivery_order_id` BIGINT COMMENT 'Foreign key linking to cargo.delivery_order. Business justification: Delivery order disputes (incorrect release fees, demurrage miscalculation, unauthorized charges) generate credit/debit adjustments. Direct DO reference required for audit trail, customer communication',
    `demurrage_detention_id` BIGINT COMMENT 'Foreign key linking to cargo.demurrage_detention. Business justification: Demurrage/detention disputes are among most common port billing disputes. Adjustments (waivers, recalculations, free-time extensions) must reference specific D&D record for regulatory compliance (cust',
    `discount_scheme_id` BIGINT COMMENT 'Foreign key linking to tariff.discount_scheme. Business justification: Adjustments issued to reverse incorrectly applied discounts must reference the discount scheme that caused the error. Discount scheme error analysis and approval audit trails require this link — a rea',
    `dispute_id` BIGINT COMMENT 'Foreign key linking to billing.dispute. Business justification: Credit adjustments are often issued to resolve customer disputes. The adjustment table has dispute_reference_number (STRING), and dispute table has reference_number. Adding dispute_id FK enables direc',
    `drayage_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.drayage_order. Business justification: Credit adjustments for drayage overcharges (incorrect distance, wrong rate applied) reference the specific drayage order. Enables drayage billing correction tracking, haulier credit note management, a',
    `facility_id` BIGINT COMMENT 'Foreign key linking to infrastructure.facility. Business justification: Facility lease adjustments, rent corrections, and concession fee credit notes require referencing the specific facility for audit trail and facility-level revenue reconciliation. Port asset managers t',
    `invoice_id` BIGINT COMMENT 'Reference to the original invoice being credited or adjusted. Links this credit note to the source billing document generated from NAVIS N4 billing module.',
    `invoice_line_id` BIGINT COMMENT 'Foreign key linking to billing.invoice_line. Business justification: Credit adjustments often apply to specific invoice line items (not just invoice headers). This FK enables line-level credit tracking. Keeps invoice_id on adjustment as adjustments can apply to entire ',
    `item_id` BIGINT COMMENT 'Foreign key linking to tariff.tariff_exception. Business justification: Credit notes issued for approved tariff exceptions (waivers, special rates, free time extensions) must reference the exception record for audit trail, revenue variance analysis, and to ensure adjustme',
    `participant_account_id` BIGINT COMMENT 'Reference to the port community participant account receiving the credit adjustment. Identifies the customer or service recipient in the billing relationship.',
    `call_id` BIGINT COMMENT 'Reference to the vessel visit if the credit note relates to vessel-based services. Enables analysis of billing adjustments by vessel operation and service delivery performance.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Credit adjustments are posted to specific billing cycles for period accounting. The billing_cycle table contains fiscal_year and fiscal_period. This FK enables period-based adjustment reporting. Keeps',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Adjustments (credit notes) must reference the port tariff schedule under which the original charge was levied. Port finance reporting requires credit note totals by tariff version for regulatory submi',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_visit. Business justification: Credit adjustments for rail terminal handling overcharges (incorrect TEU count, wrong wagon type rate) reference the specific rail visit. Enables rail terminal billing correction audit trail and rail ',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Credit note adjustments frequently arise because the wrong rate card was applied to an invoice. Linking adjustment to the rate card (original or corrected) supports root cause analysis, rate card erro',
    `receivable_account_id` BIGINT COMMENT 'Foreign key linking to billing.receivable_account. Business justification: Credit adjustments (credit notes) reduce a customers outstanding AR balance. Linking adjustment.receivable_account_id to receivable_account enables the AR master to track all credit documents issued ',
    `reversal_credit_note_adjustment_id` BIGINT COMMENT 'Reference to the reversing credit note if this credit note was subsequently cancelled. Creates bidirectional link for complete reversal audit trail.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Adjustments for terminal zone storage overcharges or zone-based rate corrections require referencing the specific zone for zone-level revenue reconciliation and audit trail. Port finance teams report ',
    `transport_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.transport_order. Business justification: Credit adjustments are issued against transport orders when charges are disputed or corrected (rate errors, service failures). adjustment has no transport_order_id. Direct FK supports transport order ',
    `truck_appointment_id` BIGINT COMMENT 'Foreign key linking to intermodal.truck_appointment. Business justification: Credit adjustments for truck appointment charge reversals (no-show fee waiver, slot fee refund) reference the specific appointment. Enables appointment-based billing correction tracking and haulier go',
    `truck_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.truck_visit. Business justification: Credit adjustments for truck gate charge overcharges (incorrect weight, wrong container type rate) reference the specific truck visit. Enables truck visit billing correction tracking and haulier credi',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Credit notes for vessel charge disputes require vessel master linkage for audit trail and dispute analysis by vessel characteristics. Supports vessel-specific billing adjustment reporting.',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.infrastructure_closure. Business justification: Credits and adjustments for infrastructure outages (berth closure, channel restriction, gate downtime) must reference the specific closure event for revenue impact analysis and SLA-based compensation ',
    `applied_date` DATE COMMENT 'Date when the credit note was applied to the customers accounts receivable balance. Marks the effective date of revenue reversal in financial systems.',
    `approval_authority` STRING COMMENT 'Name or identifier of the authorized person or role who approved the credit note issuance. Provides audit trail for financial control and segregation of duties compliance.',
    `approval_date` DATE COMMENT 'Date when the credit note was formally approved by authorized personnel. Critical for audit trail and financial control compliance.',
    `bill_of_lading_number` STRING COMMENT 'Bill of Lading reference number if the credit note relates to cargo handling or Terminal Handling Charge (THC) adjustments. Links billing adjustment to specific cargo shipment.',
    `container_number` STRING COMMENT 'ISO 6346 standard container identification number if the credit relates to container handling charges. Follows format AAAA1234567 with owner code and serial number.. Valid values are `^[A-Z]{4}[0-9]{7}$`',
    `cost_center` STRING COMMENT 'SAP S/4HANA CO cost center responsible for the service that generated the original charge. Enables operational performance analysis by business unit.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the credit note record was first created in the billing system. Audit trail timestamp for record creation.',
    `credit_amount` DECIMAL(18,2) COMMENT 'Gross monetary value of the credit being issued before tax adjustments. Represents the base revenue reversal amount in the ports operating currency.',
    `credit_note_date` DATE COMMENT 'Official issue date of the credit note document. Determines the accounting period for revenue reversal and financial reporting under IFRS 15 standards.',
    `credit_note_number` STRING COMMENT 'Externally visible business identifier for the credit note document. Follows port billing numbering convention CN-XXXXXXXX for audit trail and customer reference.. Valid values are `^CN-[0-9]{8,12}$`',
    `credit_note_status` STRING COMMENT 'Current lifecycle state of the credit note in the billing adjustment workflow. Tracks progression from draft creation through approval, application to accounts receivable, or cancellation.. Valid values are `draft|pending_approval|approved|applied|cancelled|rejected`',
    `credit_reason_code` STRING COMMENT 'Standardized classification code indicating the business reason for issuing the credit note. Used for revenue adjustment analysis, dispute tracking, and service quality monitoring. [ENUM-REF-CANDIDATE: billing_error|service_failure|tariff_adjustment|commercial_concession|dispute_resolution|overcharge|damaged_cargo|delayed_service|contract_amendment|goodwill — 10 candidates stripped; promote to reference product]',
    `credit_reason_description` STRING COMMENT 'Detailed narrative explanation of the specific circumstances justifying the credit adjustment. Provides business context for audit, dispute resolution, and customer communication.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the credit note transaction. Supports multi-currency billing operations at international port facilities.. Valid values are `^[A-Z]{3}$`',
    `customer_notification_sent` BOOLEAN COMMENT 'Flag indicating whether formal notification of the credit note has been sent to the customer via Port Community System or EDI. Tracks communication compliance.',
    `customer_reference` STRING COMMENT 'Customer-provided reference number or purchase order number associated with the original transaction. Facilitates customer reconciliation and accounts payable matching.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month) within the fiscal year for the credit note. Enables monthly revenue adjustment tracking and variance analysis.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the credit note was issued for financial reporting and EBITDA analysis. Supports period-based revenue adjustment reporting.',
    `internal_notes` STRING COMMENT 'Confidential internal comments and notes regarding the credit note decision, approval rationale, or special handling instructions. Not shared with customer.',
    `modified_by` STRING COMMENT 'User ID or system identifier of the person or process that last modified the credit note record. Maintains complete audit trail of changes to billing adjustments.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when the credit note record was last modified. Tracks the most recent update to the billing adjustment for audit and change management.',
    `notification_sent_timestamp` TIMESTAMP COMMENT 'Date and time when customer notification was transmitted. Provides audit trail for customer communication and Service Level Agreement (SLA) compliance.',
    `original_charge_amount` DECIMAL(18,2) COMMENT 'Original billed amount from the source invoice before credit adjustment. Provides reference for calculating credit percentage and analyzing billing accuracy.',
    `profit_center` STRING COMMENT 'SAP S/4HANA CO profit center for revenue adjustment allocation. Supports segment reporting and EBITDA analysis by terminal or business division.',
    `reversal_indicator` BOOLEAN COMMENT 'Flag indicating whether this credit note itself has been reversed or cancelled. Supports correction of erroneous credit notes and maintains complete audit trail.',
    `sap_credit_memo_number` STRING COMMENT 'SAP S/4HANA FI credit memo document number generated upon posting to the financial accounting system. Provides integration reference between TOS billing and ERP financial records.',
    `sap_posting_date` DATE COMMENT 'Date when the credit memo was posted to SAP S/4HANA FI general ledger. Determines the accounting period for financial statement impact and EBITDA reporting.',
    `service_type` STRING COMMENT 'Classification of the port service category for which the credit is being issued. Enables revenue adjustment analysis by service line and operational performance tracking. [ENUM-REF-CANDIDATE: vessel_services|cargo_handling|storage|equipment_rental|pilotage|towage|mooring|wharfage|terminal_handling|other — 10 candidates stripped; promote to reference product]',
    `tax_credit_amount` DECIMAL(18,2) COMMENT 'Tax component of the credit adjustment, reversing previously charged VAT, GST, or other applicable port service taxes. Ensures compliance with tax authority reporting requirements.',
    `total_credit_amount` DECIMAL(18,2) COMMENT 'Total credit value including base credit amount and tax credit amount. Represents the full accounts receivable reduction applied to the customer account.',
    `created_by` STRING COMMENT 'User ID or system identifier of the person or process that created the credit note record. Supports audit trail and accountability for billing adjustments.',
    CONSTRAINT pk_adjustment PRIMARY KEY(`adjustment_id`)
) COMMENT 'Formal credit documents issued to customers to reverse or reduce previously billed charges, arising from billing disputes, service failures, tariff adjustments, or commercial concessions. Captures credit note number, originating invoice reference, credit reason code, credit amount, tax credit amount, approval authority, approval date, credit status (draft/approved/applied/cancelled), and SAP credit memo document number. SSOT for all revenue reversals and billing adjustments in the port billing cycle.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` (
    `debit_note_id` BIGINT COMMENT 'Unique identifier for the debit note record. Primary key.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Debit notes for extended berth occupancy, berth damage recovery, or additional mooring services must reference the specific berth. Port infrastructure cost recovery and berth-level revenue reporting r',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Additional charges raised post-incident for damage, cleanup, or third-party claims discovered after initial invoicing. Standard maritime claims process requiring traceability from debit note to incide',
    `discount_scheme_id` BIGINT COMMENT 'Foreign key linking to tariff.discount_scheme. Business justification: Debit notes issued when a discount was incorrectly over-applied must reference the discount scheme that caused the undercharge. Revenue recovery from discount misapplication requires traceability to t',
    `dispute_id` BIGINT COMMENT 'Foreign key linking to billing.dispute. Business justification: Debit notes can be disputed by customers. The debit_note table has dispute_flag and dispute_reason. Adding dispute_id FK enables direct linkage to the formal dispute record. Removes dispute_reason str',
    `drayage_order_id` BIGINT COMMENT 'Unique identifier for the EDI message used to transmit this debit note to the customer via Port Community System. Null if not transmitted via EDI.',
    `facility_id` BIGINT COMMENT 'Foreign key linking to infrastructure.facility. Business justification: Debit notes for facility damage, additional facility usage fees, or concession overruns require referencing the specific port facility for infrastructure cost recovery reporting and facility-level rev',
    `import_export_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.import_export_permit. Business justification: Debit notes are raised for additional charges when import/export permit conditions require re-inspection, quantity overages, or controlled goods surcharges. Port billing must reference the specific pe',
    `invoice_id` BIGINT COMMENT 'Reference to the original invoice that this debit note supplements or adjusts. Links to the base billing document.',
    `invoice_line_id` BIGINT COMMENT 'Foreign key linking to billing.invoice_line. Business justification: Debit notes often reference specific invoice line items for additional charges. This FK enables line-level debit tracking. Keeps invoice_id on debit_note as debit notes can reference entire invoices o',
    `item_id` BIGINT COMMENT 'Foreign key linking to tariff.tariff_item. Business justification: Debit notes for additional charges (demurrage, detention, storage escalation) must reference the tariff item that defines the rate and calculation basis. Required for customer dispute resolution and t',
    `marpol_record_id` BIGINT COMMENT 'Foreign key linking to compliance.marpol_record. Business justification: Port authorities issue debit notes for MARPOL non-compliance penalties (e.g., illegal discharge, waste reception shortfalls). Linking debit notes to the specific MARPOL record is required for environm',
    `participant_account_id` BIGINT COMMENT 'Reference to the port community participant account being debited. Identifies the customer or service recipient.',
    `call_id` BIGINT COMMENT 'Reference to the vessel visit associated with this debit note, if applicable. Links debit to specific vessel operations.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Debit notes are issued within billing cycles for additional charges. This FK enables cycle-based debit note tracking and period reporting. No redundant columns - debit_note dates are issuance-specific',
    `port_location_id` BIGINT COMMENT 'Reference to the employee who approved the debit note for issuance. Null if not yet approved or if approval is not required.',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Debit notes reference the port tariff schedule under which the additional charge is levied. Port revenue management reports debit notes by tariff schedule for regulatory submissions and tariff complia',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_visit. Business justification: Debit notes for rail terminal additional charges (excess wagon count, overweight train, track damage recovery) reference the specific rail visit. Enables rail operator additional charge management and',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Debit notes for undercharging must reference the rate card establishing the correct rate. Rate card traceability on debit notes is required for customer dispute resolution and revenue recovery audits ',
    `receivable_account_id` BIGINT COMMENT 'Foreign key linking to billing.receivable_account. Business justification: Debit notes increase a customers outstanding AR balance with additional charges. Linking debit_note.receivable_account_id to receivable_account ensures the AR master reflects all debit documents issu',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Debit notes for additional terminal zone storage charges, reefer plug overages, or zone access fees require referencing the specific terminal zone for zone-level revenue tracking and billing dispute r',
    `transport_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.transport_order. Business justification: Debit notes are raised for additional charges on transport orders (overweight penalties, detention, failed delivery surcharges). debit_note has drayage_order_id but no transport_order_id. Direct FK su',
    `truck_appointment_id` BIGINT COMMENT 'Foreign key linking to intermodal.truck_appointment. Business justification: Debit notes for truck appointment no-show fees and late cancellation penalties reference the specific appointment. Port terminals charge hauliers for missed appointments; direct FK enables appointment',
    `truck_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.truck_visit. Business justification: Debit notes for truck-related additional charges (overweight axle load, extended gate occupancy, damage recovery) reference the specific truck visit. Enables truck visit debit note tracking and haulie',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Debit notes for additional vessel charges (demurrage, extra services) require vessel master reference for charge validation and vessel account reconciliation. Critical for supplementary billing accura',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Debit notes are raised for additional charges arising from emergency repairs, contractor cost overruns, or scope changes on work orders billed to vessel operators. Port billing must reference the orig',
    `acknowledgement_date` DATE COMMENT 'The date when the customer formally acknowledged or responded to the debit note. Null if not yet acknowledged.',
    `approval_required_flag` BOOLEAN COMMENT 'Indicates whether this debit note requires management approval before issuance. True if approval workflow is required, False if auto-approved.',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the debit note was approved. Null if not yet approved or if approval is not required.',
    `bol_number` STRING COMMENT 'Bill of Lading reference number associated with the cargo or shipment related to this debit note. Links debit to specific cargo documentation.',
    `charge_amount` DECIMAL(18,2) COMMENT 'The gross additional charge amount being debited to the customer before tax. Represents the base value of the supplementary billing.',
    `container_number` STRING COMMENT 'ISO 6346 standard container identification number if the debit note relates to a specific container. Format: 4 letters (owner code) + 7 digits (serial number + check digit).. Valid values are `^[A-Z]{4}[0-9]{7}$`',
    `cost_center_code` STRING COMMENT 'The cost center or profit center code associated with the service that generated the debit note. Used for internal management accounting and profitability analysis.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this debit note record was first created in the system. Audit trail for record lifecycle.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the debit note amounts. Indicates the monetary unit for all financial values.. Valid values are `^[A-Z]{3}$`',
    `customer_acknowledgement_status` STRING COMMENT 'Tracks whether the customer has acknowledged receipt and acceptance of the debit note. Values: not_sent (not yet transmitted), sent (transmitted but not acknowledged), acknowledged (customer accepted), rejected (customer disputed), pending_review (under customer review).. Valid values are `not_sent|sent|acknowledged|rejected|pending_review`',
    `debit_note_number` STRING COMMENT 'Externally-known unique business identifier for the debit note, typically formatted as DN- followed by numeric sequence. Used for customer communication and reference.. Valid values are `^DN-[0-9]{8,12}$`',
    `debit_reason_code` STRING COMMENT 'Standardized code indicating the business reason for issuing the debit note. Common values: DMG (Demurrage adjustment), DET (Detention extension), THC_ADJ (Terminal Handling Charge adjustment), BAF_ADJ (Bunker Adjustment Factor correction), SURCHARGE (Additional surcharge), PORT_DUES (Supplementary port dues), LATE_FEE (Late payment fee), PENALTY (Contractual penalty). [ENUM-REF-CANDIDATE: DMG|DET|THC_ADJ|BAF_ADJ|SURCHARGE|PORT_DUES|LATE_FEE|PENALTY — 8 candidates stripped; promote to reference product]',
    `debit_reason_description` STRING COMMENT 'Detailed narrative explanation of why the debit note was issued, providing context beyond the reason code. Includes specific circumstances, dates, and reference information.',
    `debit_status` STRING COMMENT 'Current lifecycle status of the debit note in the billing workflow. Tracks progression from draft through approval, issuance, customer acknowledgement, and potential dispute or reversal. [ENUM-REF-CANDIDATE: draft|pending_approval|approved|issued|acknowledged|disputed|cancelled|reversed — 8 candidates stripped; promote to reference product]',
    `dispute_flag` BOOLEAN COMMENT 'Indicates whether the customer has disputed this debit note. True if disputed, False otherwise. Triggers dispute resolution workflow.',
    `due_date` DATE COMMENT 'The date by which payment of the debit note amount is expected from the customer. Calculated based on payment terms.',
    `issue_date` DATE COMMENT 'The date when the debit note was formally issued to the customer. Represents the principal business event timestamp for this transaction.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this debit note record was last modified. Audit trail for record lifecycle and change management.',
    `notes` STRING COMMENT 'Free-text field for internal notes, comments, or special instructions related to the debit note. Not visible to customer.',
    `payment_terms_code` STRING COMMENT 'Code representing the payment terms applicable to this debit note (e.g., NET30, NET60, COD). Determines due date calculation.',
    `posting_date` DATE COMMENT 'The date when the debit note was posted to the general ledger in SAP S/4HANA FI. Used for financial period assignment and revenue recognition.',
    `reversal_date` DATE COMMENT 'The date when the debit note was reversed or cancelled. Null if not reversed.',
    `reversal_flag` BOOLEAN COMMENT 'Indicates whether this debit note has been reversed or cancelled. True if reversed, False if active. Reversed debit notes do not contribute to accounts receivable.',
    `reversal_reason` STRING COMMENT 'Explanation for why the debit note was reversed. Null if not reversed. Documents the business justification for cancellation.',
    `sap_debit_memo_number` STRING COMMENT 'The SAP S/4HANA FI debit memo document number generated when the debit note is posted to the financial system. Links billing document to accounting records.',
    `service_period_end_date` DATE COMMENT 'The ending date of the service period or event that triggered the additional charge. Used for calculating duration-based fees.',
    `service_period_start_date` DATE COMMENT 'The beginning date of the service period or event that triggered the additional charge. Used for demurrage, detention, and time-based charges.',
    `tax_amount` DECIMAL(18,2) COMMENT 'The total tax amount applicable to the additional charge. Calculated based on applicable tax rates and jurisdictional requirements.',
    `total_debit_amount` DECIMAL(18,2) COMMENT 'The total amount of the debit note including all charges and taxes. Represents the net amount to be collected from the customer.',
    CONSTRAINT pk_debit_note PRIMARY KEY(`debit_note_id`)
) COMMENT 'Formal debit documents issued to customers for additional charges not captured in the original invoice, including demurrage adjustments, detention extensions, surcharge corrections, or supplementary port dues. Captures debit note number, originating invoice reference, debit reason code, additional charge amount, tax amount, approval status, SAP debit memo document number, and customer acknowledgement status. Complements credit_note as the upward billing adjustment mechanism.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` (
    `dispute_id` BIGINT COMMENT 'Unique identifier for the billing dispute record. Primary key.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Billing disputes about berth dues, berth occupancy charges, or berth allocation errors require referencing the specific berth for investigation. Port operations teams require berth-level dispute repor',
    `contact_person_id` BIGINT COMMENT 'Foreign key linking to customer.contact_person. Business justification: Disputes are lodged and managed by a named contact person. The dispute product currently denormalizes customer_contact_email, customer_contact_name, customer_contact_phone. A proper FK to contact_pers',
    `container_id` BIGINT COMMENT 'Foreign key linking to cargo.container. Business justification: Container-specific disputes (damage claims, wrong container delivered, seal discrepancies, condition grade disagreements) require direct container link for investigation workflow, photographic evidenc',
    `service_request_id` BIGINT COMMENT 'Reference to the associated service request record in Microsoft Dynamics 365 CRM. Links the billing dispute to the broader customer service case.',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Billing disputes frequently arise from customs declaration discrepancies (incorrect duty assessment, misclassified HS codes, valuation disputes). Dispute resolution teams must reference the underlying',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Billing disputes frequently arise from customs holds causing demurrage/detention charges. Dispute resolution requires linking to the hold record to verify legitimacy of charges, hold duration, and res',
    `delivery_order_id` BIGINT COMMENT 'Foreign key linking to cargo.delivery_order. Business justification: Delivery order disputes (unauthorized release, incorrect DO terms, missing documentation, wrong consignee) are frequent in port operations. Direct DO reference enables dispute management system to pul',
    `demurrage_detention_id` BIGINT COMMENT 'Foreign key linking to cargo.demurrage_detention. Business justification: Demurrage/detention disputes are among highest-volume billing disputes in ports (free-time disagreements, customs hold claims, force majeure). Direct D&D link enables dispute system to pull calculatio',
    `drayage_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.drayage_order. Business justification: Billing disputes for drayage charges (incorrect distance, unauthorized surcharge) reference the specific drayage order. Enables drayage dispute management, haulier dispute history reporting, and draya',
    `facility_id` BIGINT COMMENT 'Foreign key linking to infrastructure.facility. Business justification: Disputes about facility lease charges, concession fees, or facility-based service billing require referencing the specific facility for investigation. Facility managers need facility-level dispute vis',
    `failure_report_id` BIGINT COMMENT 'Foreign key linking to asset.failure_report. Business justification: Equipment failures causing vessel delays, cargo damage, or operational disruptions frequently trigger billing disputes (demurrage claims, damage compensation). Dispute investigators must reference the',
    `invoice_id` BIGINT COMMENT 'Reference to the invoice that is being disputed. Links to the invoice record in the billing system.',
    `invoice_line_id` BIGINT COMMENT 'Foreign key linking to billing.invoice_line. Business justification: Customer disputes often target specific invoice line items (not just invoice headers). This FK enables line-level dispute tracking and resolution. Keeps invoice_id on dispute as disputes can apply to ',
    `item_id` BIGINT COMMENT 'Foreign key linking to tariff.item. Business justification: Disputes are often raised against a specific tariff charge item (e.g., a specific THC item, storage item). Direct dispute→item link enables item-level dispute frequency analysis and tariff item qualit',
    `participant_account_id` BIGINT COMMENT 'Reference to the customer account that raised the dispute. Links to the port community participant account.',
    `participant_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.participant_service_agreement. Business justification: Billing disputes in port operations frequently arise from disagreements over service agreement terms (negotiated rates, free time, volume commitments). Linking dispute to participant_service_agreement',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_visit. Business justification: Billing disputes for rail terminal handling charges reference the specific rail visit. Enables rail operator dispute management, rail visit charge accuracy reporting, and terminal billing dispute reso',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Disputes frequently arise from rate card misapplication or incorrect rate card assignment. Linking dispute to rate card enables rate card dispute frequency analytics — which commercial agreements gene',
    `receivable_account_id` BIGINT COMMENT 'Foreign key linking to billing.receivable_account. Business justification: Disputes are managed at the receivable account level — the receivable_account already tracks dispute_count_ytd, confirming that disputes are aggregated per account. Adding dispute.receivable_account_i',
    `sanctions_screening_id` BIGINT COMMENT 'Foreign key linking to compliance.sanctions_screening. Business justification: Disputes arise when sanctions screening produces false-positive matches causing wrongful service denial or charge application. Compliance and billing teams must link the dispute to the specific screen',
    `sla_profile_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Billing disputes frequently reference contract terms, rate schedules, SLA commitments, and service scope definitions. Required for dispute resolution workflow, contractual compliance verification, and',
    `storage_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.storage_tariff. Business justification: Storage/demurrage disputes are the most common dispute type in port operations. Pre-invoice demurrage disputes reference the storage tariff directly (before invoice_line exists). Port operations teams',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Disputes about terminal zone storage charges, reefer plug fees, or zone access charges require referencing the specific zone for investigation and resolution. Zone-level dispute reporting is a standar',
    `transport_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.transport_order. Business justification: Billing disputes are raised against transport order charges (incorrect rate, service not rendered). Direct FK enables transport order dispute tracking, dispute resolution workflow, and transport order',
    `truck_appointment_id` BIGINT COMMENT 'Foreign key linking to intermodal.truck_appointment. Business justification: Billing disputes for truck appointment fees (no-show charges, slot booking fees) reference the specific appointment. Enables appointment-based charge dispute management and haulier appointment fee dis',
    `truck_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.truck_visit. Business justification: Billing disputes for truck gate charges reference the specific truck visit. Enables truck visit charge dispute tracking, haulier dispute history analysis, and gate charge accuracy KPI reporting.',
    `vessel_id` BIGINT COMMENT 'Foreign key linking to vessel.vessel. Business justification: Billing disputes for port dues and vessel-specific charges must reference the vessel for flag state reporting, PSC-linked dispute analysis, and vessel risk profiling. Port authorities track dispute hi',
    `assigned_date` DATE COMMENT 'Date when the dispute was assigned to an internal handler for investigation.',
    `dispute_category` STRING COMMENT 'High-level categorization of the disputed charges by port service type. Enables dispute trend analysis by service line.. Valid values are `vessel_charges|cargo_charges|equipment_charges|storage_charges|service_charges|administrative_charges`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the dispute record was first created in the database. Used for audit trail and data lineage.',
    `credit_amount` DECIMAL(18,2) COMMENT 'Actual monetary amount credited to the customer as a result of the dispute resolution. May be equal to or less than the disputed amount.',
    `credit_note_reference` STRING COMMENT 'Reference number of the credit note issued if the dispute was accepted (fully or partially). Links to the credit note record in SAP S/4HANA FI.',
    `customer_satisfaction_rating` STRING COMMENT 'Post-resolution satisfaction rating provided by the customer on a scale of 1-5. Used for service quality monitoring and Key Performance Indicator (KPI) reporting.',
    `dispute_status` STRING COMMENT 'Current lifecycle status of the dispute. Tracks progression from lodgement through investigation to final resolution. [ENUM-REF-CANDIDATE: lodged|under_investigation|pending_customer_response|pending_internal_review|resolved_accepted|resolved_rejected|resolved_partial_credit|withdrawn|escalated — 9 candidates stripped; promote to reference product]',
    `disputed_amount` DECIMAL(18,2) COMMENT 'Total monetary value being disputed by the customer. Represents the portion of the invoice amount that the customer contests.',
    `disputed_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the disputed amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `escalation_date` DATE COMMENT 'Date when the dispute was escalated to a higher management level. Null if no escalation occurred.',
    `escalation_level` STRING COMMENT 'Indicates the management level to which the dispute has been escalated, if applicable. Used for complex or high-value disputes requiring senior review.. Valid values are `none|supervisor|manager|director|executive`',
    `investigation_notes` STRING COMMENT 'Internal notes and findings recorded by the dispute handler during the investigation process. May include references to supporting documentation, system checks, and communication history.',
    `last_modified_by_user` STRING COMMENT 'Username or identifier of the system user who last modified the dispute record. Supports audit and accountability requirements.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when the dispute record was last updated. Tracks the most recent change to any field in the record.',
    `lodged_date` DATE COMMENT 'Date when the customer formally lodged the dispute against the invoice. Represents the business event timestamp for dispute initiation.',
    `lodged_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the dispute was lodged in the system, including time zone. Used for SLA tracking and audit purposes.',
    `preventive_action_taken` STRING COMMENT 'Description of any preventive or corrective actions implemented to prevent recurrence of similar disputes. Supports continuous improvement initiatives.',
    `reason_code` STRING COMMENT 'Categorized reason for the dispute. Includes port-specific charge types such as Terminal Handling Charge (THC), Demurrage (DMG), Detention (DET), and Wharfage (WHR) disputes. [ENUM-REF-CANDIDATE: incorrect_rate|wrong_quantity|service_not_rendered|duplicate_charge|tariff_misapplication|thc_dispute|demurrage_dispute|detention_dispute|wharfage_dispute|other — 10 candidates stripped; promote to reference product]',
    `reason_description` STRING COMMENT 'Detailed free-text explanation provided by the customer describing the nature and basis of the dispute.',
    `reference_number` STRING COMMENT 'Externally-visible unique reference number for the dispute, used in customer communications and tracking. Format: DSP-YYYYNNNN.. Valid values are `^DSP-[0-9]{8}$`',
    `resolution_date` DATE COMMENT 'Date when the dispute was formally resolved and closed. Used for SLA compliance reporting and dispute lifecycle analytics.',
    `resolution_notes` STRING COMMENT 'Detailed explanation of the resolution decision, including rationale, policy references, and any corrective actions taken.',
    `resolution_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the dispute resolution was recorded in the system, including time zone.',
    `resolution_type` STRING COMMENT 'Final outcome classification of the dispute resolution. Indicates whether the dispute was accepted (full credit), rejected (no credit), partially accepted, withdrawn, or escalated.. Valid values are `accepted_full_credit|rejected_no_credit|partial_credit|withdrawn_by_customer|escalated_to_management`',
    `root_cause_code` STRING COMMENT 'Identified root cause of the billing error or dispute. Used for continuous improvement and process optimization. [ENUM-REF-CANDIDATE: data_entry_error|system_error|tariff_interpretation|customer_misunderstanding|process_failure|documentation_missing|other — 7 candidates stripped; promote to reference product]',
    `sla_actual_resolution_days` STRING COMMENT 'Actual number of business days taken to resolve the dispute. Calculated from lodged date to resolution date for SLA compliance reporting.',
    `sla_breach_flag` BOOLEAN COMMENT 'Boolean indicator of whether the dispute resolution exceeded the SLA target resolution time. True indicates an SLA breach.',
    `sla_target_resolution_days` STRING COMMENT 'Number of business days within which the dispute should be resolved according to the applicable SLA. Used for performance tracking.',
    `supporting_documents_reference` STRING COMMENT 'Reference identifiers or file paths to supporting documentation provided by the customer (e.g., Bill of Lading (BOL), Delivery Order (D/O), email correspondence).',
    CONSTRAINT pk_dispute PRIMARY KEY(`dispute_id`)
) COMMENT 'Formal records of customer-raised disputes against invoiced charges, tracking the full dispute lifecycle from lodgement through investigation to resolution. Captures dispute reference number, disputed invoice reference, dispute date, dispute reason (incorrect rate, wrong quantity, service not rendered, duplicate charge, tariff misapplication), disputed amount, customer contact, assigned dispute handler, investigation notes, resolution type (accepted/rejected/partial credit), resolution date, and credit note reference if applicable. Integrates with Microsoft Dynamics 365 CRM service requests.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` (
    `receivable_account_id` BIGINT COMMENT 'Unique identifier for the receivable account. Primary key for the customer billing and accounts receivable master record.',
    `credit_assessment_id` BIGINT COMMENT 'Foreign key linking to customer.credit_assessment. Business justification: The receivable accounts credit_limit and credit_rating are set by the most recent credit assessment. Port AR teams must link the receivable account to the governing credit assessment for credit revie',
    `customs_broker_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_broker. Business justification: Customs brokers are a distinct billing entity type in port operations with their own receivable accounts for declaration processing fees and duty disbursements. Linking receivable accounts to licensed',
    `haulier_id` BIGINT COMMENT 'Foreign key linking to intermodal.haulier. Business justification: Hauliers are billed customers for drayage and gate services. Ports maintain receivable accounts for hauliers to track outstanding balances, credit limits, payment terms, and aging. Essential for credi',
    `parent_account_receivable_account_id` BIGINT COMMENT 'Reference to the parent receivable account if this is a subsidiary or branch account. Enables hierarchical billing and consolidated statements.',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.participant_account. Business justification: A receivable account is the AR ledger record for a participant account. Port finance teams must link the AR account to the commercial participant account for credit utilisation tracking, dunning, and ',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Each customer receivable account has a default billing cycle. The receivable_account table has billing_cycle (STRING), and billing_cycle table has cycle_code. Adding billing_cycle_id FK enables JOIN t',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: In multi-port operators, receivable accounts are scoped to a specific port for port-level AR aging, credit limit management, and financial reporting. Port-level AR reporting is a standard finance and ',
    `port_location_id` BIGINT COMMENT 'Identifier of the employee responsible for managing this customer relationship, credit decisions, and collections activities.',
    `rail_operator_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_operator. Business justification: Rail operators are billed for terminal services (loading, unloading, storage, track usage). Ports maintain receivable accounts to manage rail operator billing, credit terms, payment tracking, and dunn',
    `sanctions_screening_id` BIGINT COMMENT 'Foreign key linking to compliance.sanctions_screening. Business justification: Receivable accounts must undergo KYC/AML sanctions screening before credit is extended. Port finance compliance requires linking each account to its most recent screening result to enforce credit hold',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Shipping lines are primary AR account holders at ports. Port AR teams manage carrier-specific credit limits, dunning levels, and aging buckets in receivable_account. Direct shipping_line_id enables ca',
    `account_classification` STRING COMMENT 'Business classification of the account holder based on their role in the port community ecosystem. Determines applicable tariff structures and service entitlements.. Valid values are `shipping_line|freight_forwarder|cargo_owner|terminal_operator|government|customs_broker`',
    `account_closed_date` DATE COMMENT 'Date when this receivable account was closed or terminated. Null for active accounts.',
    `account_code` STRING COMMENT 'Business-assigned unique alphanumeric code identifying the receivable account. Used for operational reference and reporting.. Valid values are `^[A-Z0-9]{6,12}$`',
    `account_name` STRING COMMENT 'Legal or trading name of the customer organization or individual holding this receivable account.',
    `account_opened_date` DATE COMMENT 'Date when this receivable account was first established and activated in the billing system.',
    `account_status` STRING COMMENT 'Current lifecycle status of the receivable account. Active accounts can transact; suspended/blocked accounts require approval; closed accounts are archived.. Valid values are `active|suspended|credit_hold|blocked|closed`',
    `aging_bucket_0_30_days` DECIMAL(18,2) COMMENT 'Total outstanding balance for invoices aged 0 to 30 days past due date. Used for accounts receivable aging analysis and collections prioritization.',
    `aging_bucket_31_60_days` DECIMAL(18,2) COMMENT 'Total outstanding balance for invoices aged 31 to 60 days past due date. Indicates moderate collection risk.',
    `aging_bucket_61_90_days` DECIMAL(18,2) COMMENT 'Total outstanding balance for invoices aged 61 to 90 days past due date. Indicates elevated collection risk requiring escalation.',
    `aging_bucket_over_90_days` DECIMAL(18,2) COMMENT 'Total outstanding balance for invoices aged over 90 days past due date. Indicates high collection risk; may require legal action or write-off consideration.',
    `auto_payment_flag` BOOLEAN COMMENT 'Indicates whether this account is enrolled in automatic payment via direct debit or standing order. True means invoices are auto-settled on due date.',
    `average_days_to_pay` DECIMAL(18,2) COMMENT 'Rolling average number of days from invoice date to payment receipt over the last 12 months. Key metric for credit risk assessment.',
    `billing_address_line1` STRING COMMENT 'First line of the postal address to which invoices and statements are sent. Typically contains street number and name.',
    `billing_address_line2` STRING COMMENT 'Second line of the billing postal address. Used for suite/floor/building details or additional address information.',
    `billing_city` STRING COMMENT 'City or municipality component of the billing address.',
    `billing_country` STRING COMMENT 'Three-letter ISO country code for the billing address country.. Valid values are `^[A-Z]{3}$`',
    `billing_email` STRING COMMENT 'Primary email address for sending invoices, statements, and billing-related communications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `billing_phone` STRING COMMENT 'Primary phone number for billing inquiries and dispute resolution. Format varies by country.',
    `billing_postal_code` STRING COMMENT 'Postal or ZIP code component of the billing address. Format varies by country.',
    `billing_state_province` STRING COMMENT 'State, province, or region component of the billing address. Format varies by country.',
    `consolidation_flag` BOOLEAN COMMENT 'Indicates whether invoices for this account should be consolidated with parent account for statement purposes. True enables group-level billing.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this receivable account record was first created in the system. Immutable audit field.',
    `credit_hold_flag` BOOLEAN COMMENT 'Indicates whether this account is currently on credit hold. True means no new services can be rendered until outstanding balance is reduced.',
    `credit_limit` DECIMAL(18,2) COMMENT 'Maximum outstanding balance allowed for this account before credit hold is triggered. Expressed in the accounts base currency.',
    `credit_rating` STRING COMMENT 'Internal or external credit rating assessment for this account. Used to determine credit limits and payment terms. D indicates default risk. [ENUM-REF-CANDIDATE: AAA|AA|A|BBB|BB|B|CCC|CC|C|D|unrated — 11 candidates stripped; promote to reference product]',
    `dispute_count_ytd` STRING COMMENT 'Number of billing disputes raised by this account in the current calendar year. High counts indicate service quality or billing accuracy issues.',
    `dunning_level` STRING COMMENT 'Current collections escalation level (0=none, 1=reminder, 2=warning, 3=final notice, 4=legal action). Increments with each overdue period.',
    `invoice_delivery_method` STRING COMMENT 'Preferred channel for delivering invoices to the customer. EDI is common for large shipping lines; email for smaller customers.. Valid values are `email|edi|portal|postal_mail|fax`',
    `last_invoice_date` DATE COMMENT 'Date of the most recent invoice issued to this account. Used to identify dormant accounts.',
    `last_payment_amount` DECIMAL(18,2) COMMENT 'Amount of the most recent payment received from this account in the accounts base currency.',
    `last_payment_date` DATE COMMENT 'Date of the most recent payment received from this account. Used to calculate average days to pay and payment behavior trends.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this receivable account record was last updated. Updated automatically on any field change.',
    `outstanding_balance` DECIMAL(18,2) COMMENT 'Current total amount owed by the customer across all unpaid invoices. Updated in real-time as invoices are issued and payments are received.',
    `payment_terms_code` STRING COMMENT 'Standard payment terms defining the number of days from invoice date until payment is due. Net 7/14/30/60 are common port industry terms. [ENUM-REF-CANDIDATE: net_7|net_14|net_30|net_60|net_90|due_on_receipt|cod — 7 candidates stripped; promote to reference product]',
    `preferred_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for invoicing this account. All invoices will be issued in this currency unless overridden at transaction level.. Valid values are `^[A-Z]{3}$`',
    `sap_customer_number` STRING COMMENT 'SAP S/4HANA customer master number (KNA1/KNB1) linking this receivable account to the ERP financial accounting module. Ten-digit numeric identifier.. Valid values are `^[0-9]{10}$`',
    `statement_frequency` STRING COMMENT 'Frequency at which account statements summarizing all invoices and payments are generated and sent to the customer.. Valid values are `weekly|monthly|quarterly|on_request|none`',
    `tax_jurisdiction` STRING COMMENT 'Three-letter ISO country code representing the primary tax jurisdiction for this account. Determines applicable tax rates and compliance requirements.. Valid values are `^[A-Z]{3}$`',
    `vat_registration_number` STRING COMMENT 'Tax registration identifier for VAT/GST purposes. Required for invoicing and tax compliance reporting. Format varies by jurisdiction.',
    `write_off_amount_ytd` DECIMAL(18,2) COMMENT 'Total amount written off as bad debt for this account in the current calendar year. Impacts credit rating and future credit decisions.',
    CONSTRAINT pk_receivable_account PRIMARY KEY(`receivable_account_id`)
) COMMENT 'The single authoritative customer billing and accounts receivable master for each port community participant — THE unified customer record for all billing, credit management, and collections operations in this domain. Combines billing configuration (invoice delivery method, EDI partner ID, preferred currency, payment terms net 7/14/30/60, billing cycle vessel-call/weekly/monthly, account manager, billing address) with financial position tracking (credit limit, outstanding balance, aging buckets 0-30/31-60/61-90/90+ days, dunning level, credit hold flag, average days to pay). Captures account code, SAP customer account number (KNA1/KNB1), account name, VAT/tax registration, account classification (shipping line/freight forwarder/cargo owner/terminal operator/government), account status (active/suspended/blocked/closed), last payment date, credit rating, and EDI partner configuration. SSOT for customer identity, billing preferences, credit exposure, AR aging, and settlement terms. All invoices, payments, disputes, adjustments, dunning notices, and statements reference this single master.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` (
    `charge_event_id` BIGINT COMMENT 'Unique identifier for the charge event record. Primary key for the charge event entity.',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Anchorage dues are a standard port charge levied when vessels wait at anchor. The charge event for anchorage services must reference the specific anchorage area for anchorage revenue reporting and por',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Berth occupancy, wharfage, and mooring fee charge events must reference the specific berth where the vessel was served. Berth-level revenue reporting and berth dues calculation are core port billing p',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Channel/fairway dues and pilotage charges are levied per navigational channel transit. Billing for channel usage requires linking the charge event to the specific channel for channel revenue reporting',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Charge events for cargo handling require commodity code linkage for hazmat handling fees, special storage charges, and regulatory compliance. Essential for cargo service billing rules.',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: Charge calculation for cargo services depends on commodity classification (dangerous goods handling, CITES-regulated cargo, dual-use items). Charge events reference HS codes for rate determination and',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Charge events for hold-related fees (extended storage during hold, inspection costs, examination fees) directly reference the customs hold. Required for real-time billing of hold-related services and ',
    `equipment_id` BIGINT COMMENT 'Identifier of the port equipment (crane, RTG, forklift, etc.) used to perform the service that generated this charge event.',
    `facility_id` BIGINT COMMENT 'Foreign key linking to infrastructure.facility. Business justification: Dry dock, ship repair, and passenger terminal charge events must reference the specific port facility. Facility-level revenue reporting and utilization-based billing are standard port operations finan',
    `icd_facility_id` BIGINT COMMENT 'Foreign key linking to intermodal.icd_facility. Business justification: ICD facility storage and handling charges generate charge events at the ICD. charge_event has warehouse_id for port warehouse charges; icd_facility_id is the equivalent for ICD-originated charges — a ',
    `import_export_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.import_export_permit. Business justification: Charge events for controlled goods handling, permit inspection fees, and restricted commodity surcharges must reference the authorizing import/export permit. Port tariff systems validate permit existe',
    `inspection_record_id` BIGINT COMMENT 'Foreign key linking to asset.inspection_record. Business justification: Statutory and commercial inspections performed by port authority on vessels or equipment generate billable inspection fee charge events. Port revenue teams must link each inspection fee charge_event t',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: ISPS security surcharges (enhanced security level operations, Declaration of Security activities) are billed as charge events tied to specific facility security records. Port security billing requires',
    `manifest_id` BIGINT COMMENT 'Foreign key linking to cargo.manifest. Business justification: Manifest-level charges (manifest processing fee, customs documentation fee, port authority levy, PCS submission fee) are assessed per manifest submission. Regulatory requirement in many jurisdictions;',
    `marpol_record_id` BIGINT COMMENT 'Foreign key linking to compliance.marpol_record. Business justification: MARPOL waste reception services (oily water, garbage, sewage) generate charge events billed to vessel operators. Linking the charge event to the MARPOL record enables environmental fee reconciliation,',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Charge events for container services require container type classification for accurate tariff lookup and TEU conversion. Essential for container terminal billing automation.',
    `movement_id` BIGINT COMMENT 'Foreign key linking to vessel.movement. Business justification: Pilotage and towage charges are calculated per movement (inbound/outbound/shift). Linking charge_event to movement enables precise pilotage fee calculation based on movement-specific data (number_of_t',
    `participant_account_id` BIGINT COMMENT 'Reference to the port community participant account (customer, shipping line, freight forwarder, etc.) to whom this charge event will be billed.',
    `participant_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.participant_service_agreement. Business justification: Charge events are calculated using terms defined in the participant service agreement (free time allowances, negotiated unit rates, volume tiers). Port billing systems must reference the governing agr',
    `pilot_id` BIGINT COMMENT 'Foreign key linking to marine.pilot. Business justification: Contractor safety induction fees, qualification verification charges, and safety compliance audit fees are billable services in port operations. Real business process: contractor safety service charge',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Port asset usage (crane hire, equipment rental, berth infrastructure) generates billable charge events for vessel operators and terminal customers. Billing teams must link each asset-usage charge_even',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Charge events are accumulated and billed within specific billing cycles. This FK enables period-based charge aggregation and billing cycle reporting. No redundant columns to remove - charge_event.even',
    `port_dues_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.port_dues_schedule. Business justification: Port dues charge events must reference the port dues schedule used for calculation. Port authorities require this linkage for statutory dues reconciliation, regulatory reporting to maritime authoritie',
    `port_gate_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port_gate. Business justification: Gate transaction charges (truck processing fees, RFID/OCR service charges) must reference which gate processed the transaction for gate-level revenue analysis and throughput-based billing validation. ',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Charge approval is a critical authorization control point. Port operations require tracking which supervisor/manager approved each charge event for audit compliance and dispute resolution.',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Charge events (container handling, berth occupancy, pilotage) are priced per contracted rate schedules. Required for real-time tariff application, billing accuracy, and automated charge calculation in',
    `call_id` BIGINT COMMENT 'FK to vessel.call.call_id — Revenue reconciliation requires joining every chargeable event to the vessel call that triggered it. Without this FK, billing disputes cannot be correlated to vessel visits — a daily operational requi',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_visit. Business justification: Rail terminal handling generates billable events (loading, unloading, storage). Linking charge events to rail visits enables service verification, supports billing accuracy audits, and facilitates dis',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Charge events are priced under a negotiated rate card for a specific customer/shipping line. Billing analysts and revenue auditors must trace which rate card governed the unit rate applied at charge g',
    `rate_card_line_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card_line. Business justification: Charge events are generated from specific rate card lines (individual pricing rows). Linking to rate_card_line enables precise rate traceability — which exact line item rate was applied — critical for',
    `service_id` BIGINT COMMENT 'Foreign key linking to intermodal.intermodal_service. Business justification: Charge events for intermodal service usage (rail shuttle, truck relay) reference the specific service being charged. Enables service-level charge aggregation, tariff code validation against the servic',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to cargo.shipment. Business justification: Charge events capture billable activities; linking to shipment enables direct cargo-to-charge traceability for freight charges, surcharges, and ancillary fees. Supports charge validation against shipm',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Charge events for vessel services (berth hire, pilotage, towage) are commercially attributed to the shipping line for carrier-level revenue reporting, credit limit monitoring, and EDI billing. Port co',
    `storage_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.storage_tariff. Business justification: Storage and demurrage charge events must reference the storage tariff governing free-time days and daily rates applied. Demurrage disputes are the most frequent billing dispute type in port operations',
    `surcharge_rule_id` BIGINT COMMENT 'Foreign key linking to tariff.surcharge_rule. Business justification: Surcharge charge events (BAF, CAF, security levy, peak season) must reference the surcharge rule that triggered them. Customers routinely query surcharge justification; regulators require surcharge ru',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Terminal zone storage, reefer plug, and container handling charge events must reference the zone where the service occurred. Zone-level revenue reporting and capacity utilization billing are standard ',
    `thc_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.thc_schedule. Business justification: THC is a primary container terminal charge. Charge events for THC must reference the specific THC schedule used for rate calculation, enabling regulatory tariff filing verification and customer rate q',
    `trade_document_id` BIGINT COMMENT 'Foreign key linking to compliance.trade_document. Business justification: Charge events for document processing fees (certificate issuance, document verification, legalization services) reference specific trade documents. Essential for real-time billing of documentary servi',
    `transport_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.transport_order. Business justification: Charge events are triggered by transport order execution milestones (pickup, delivery, handling). charge_event has drayage_order_id and rail_visit_id but no transport_order_id. Direct FK supports tran',
    `truck_appointment_id` BIGINT COMMENT 'Foreign key linking to intermodal.intermodal_leg. Business justification: Each intermodal leg (rail/truck segment) generates handling and transport charges. Ports track which charges apply to which leg for multi-modal billing, cost allocation across transport modes, and rev',
    `vessel_master_id` BIGINT COMMENT 'Unique seven-digit IMO number assigned to the vessel associated with this charge event, used for statutory charge calculations.',
    `voyage_id` BIGINT COMMENT 'Foreign key linking to vessel.voyage. Business justification: Pilotage, towage, and berth hire charges are aggregated at voyage level for disbursement account preparation. A voyage_id FK on charge_event enables voyage-level cost roll-up and proforma DA generatio',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Hot work permits, confined space entry, and other permitted activities often carry service charges (permit issuance fees, safety supervision charges, gas testing fees). Real port revenue stream requir',
    `wharfage_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.wharfage_schedule. Business justification: Wharfage is a core port revenue charge. Charge events for wharfage must reference the wharfage schedule applied, supporting port revenue reconciliation, regulatory compliance audits, and customer invo',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Billable maintenance and repair services executed via work orders generate charge events billed to vessel operators or terminal customers. Port billing teams must trace each charge_event to its origin',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this charge event was approved for billing by an authorized user or automated workflow.',
    `billing_status` STRING COMMENT 'Current billing status of the charge event indicating whether it has been invoiced, is pending billing, has been disputed, waived, cancelled, or reversed.. Valid values are `unbilled|billed|disputed|waived|cancelled|reversed`',
    `cargo_volume_cbm` DECIMAL(18,2) COMMENT 'Volume of the cargo in cubic meters associated with this charge event, used for volume-based wharfage calculations.',
    `cargo_weight_kg` DECIMAL(18,2) COMMENT 'Weight of the cargo in kilograms associated with this charge event, used for wharfage and weight-based charge calculations.',
    `charge_amount` DECIMAL(18,2) COMMENT 'Calculated charge amount for this event before any adjustments, discounts, or taxes. Represents the base charge value.',
    `container_number` STRING COMMENT 'ISO 6346 standard container identification number associated with this charge event, if applicable. Null for non-container charges.. Valid values are `^[A-Z]{4}[0-9]{7}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this charge event record was first created in the system. Audit trail field.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the charge amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `daily_rate` DECIMAL(18,2) COMMENT 'Daily rate applied for demurrage or detention charges per excess day.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Discount amount applied to this charge event based on customer agreements or promotional tariffs.',
    `dispute_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this charge event is currently under dispute by the customer.',
    `dispute_reason` STRING COMMENT 'Description or code indicating the reason for the billing dispute, if the dispute flag is true.',
    `event_timestamp` TIMESTAMP COMMENT 'Date and time when the chargeable service event occurred in the operational system. This is the business event time, not the record creation time.',
    `event_type` STRING COMMENT 'Classification of the charge event indicating whether it is a commercial service charge, statutory/regulatory charge, demurrage, detention, wharfage, or port dues.. Valid values are `commercial|statutory|demurrage|detention|wharfage|port_dues`',
    `excess_days` STRING COMMENT 'Number of days beyond the free time period for which demurrage or detention charges are calculated.',
    `exemption_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this charge event is exempt from billing due to contractual agreements, regulatory exemptions, or special circumstances.',
    `exemption_reason` STRING COMMENT 'Explanation or code indicating the reason for charge exemption, if the exemption flag is true.',
    `free_time_days` STRING COMMENT 'Number of free days allowed before demurrage or detention charges begin to accrue, as per tariff or customer agreement.',
    `free_time_end_timestamp` TIMESTAMP COMMENT 'Date and time when the free time period ends and chargeable demurrage or detention time begins.',
    `free_time_start_timestamp` TIMESTAMP COMMENT 'Date and time when the free time period begins for demurrage or detention calculation.',
    `hazmat_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this charge event is related to hazardous cargo handling, which may attract additional charges per IMDG Code requirements.',
    `imdg_class` STRING COMMENT 'IMDG classification code for hazardous cargo associated with this charge event, if applicable.. Valid values are `^[1-9](.[1-9])?$`',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this charge event record was last modified. Audit trail field.',
    `net_charge_amount` DECIMAL(18,2) COMMENT 'Net charge amount after applying discounts and adding taxes. This is the final billable amount for this charge event.',
    `quantity` DECIMAL(18,2) COMMENT 'Quantity of the service unit rendered (e.g., number of moves, number of days, number of connections).',
    `reefer_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this charge event is related to a refrigerated (reefer) container requiring power connection and monitoring services.',
    `reference` STRING COMMENT 'Business-facing unique reference number for the charge event, used for tracking and reconciliation across systems.. Valid values are `^CHG-[0-9]{10}$`',
    `source_system_reference` STRING COMMENT 'Unique identifier or reference key from the source operational system that generated this charge event, used for traceability and reconciliation.',
    `statutory_authority_reference` STRING COMMENT 'Reference to the statutory authority, regulation, or legal framework under which statutory charges (wharfage, port dues, pilotage levies, navigation fees) are assessed.',
    `tariff_code` STRING COMMENT 'Applicable tariff code from the port tariff schedule used to calculate the charge amount for this event.. Valid values are `^[A-Z0-9]{4,15}$`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax amount applied to this charge event based on applicable tax regulations and jurisdictions.',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the service quantity (e.g., move, day, hour, TEU, FEU, ton, CBM, connection, lift, each). [ENUM-REF-CANDIDATE: move|day|hour|teu|feu|ton|cbm|connection|lift|each — 10 candidates stripped; promote to reference product]',
    `unit_rate` DECIMAL(18,2) COMMENT 'Rate per unit of measure applied from the tariff schedule to calculate the charge amount.',
    CONSTRAINT pk_charge_event PRIMARY KEY(`charge_event_id`)
) COMMENT 'Granular chargeable service events captured from NAVIS N4 TOS and other operational systems, representing all raw billable activities before invoice consolidation. Covers commercial charges (container moves, gate transactions, crane hire, reefer connections, hazardous handling, storage days) and statutory/regulatory charges (wharfage assessments based on cargo weight/volume, port dues based on vessel GRT/NRT, pilotage levies, navigation fees). Also captures demurrage and detention charge calculations including free time start/end, excess days, and daily rates. Captures charge event reference, event type, event timestamp, container number, vessel call ID, vessel IMO/GRT/NRT, BOL number, cargo weight/volume, equipment ID, quantity, unit of measure, applicable tariff code, calculated charge amount, currency, billing status (unbilled/billed/disputed/waived), exemption flag, free time days allowed, excess days, statutory authority reference, and source system reference. SSOT for all pre-invoice chargeable activity including commercial, statutory, and demurrage/detention charges.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_charge_event_id` FOREIGN KEY (`charge_event_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`charge_event`(`charge_event_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_original_invoice_line_id` FOREIGN KEY (`original_invoice_line_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice_line`(`invoice_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_receivable_account_id` FOREIGN KEY (`receivable_account_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`receivable_account`(`receivable_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_adjustment_id` FOREIGN KEY (`adjustment_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`adjustment`(`adjustment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_debit_note_id` FOREIGN KEY (`debit_note_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`debit_note`(`debit_note_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_invoice_line_id` FOREIGN KEY (`invoice_line_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice_line`(`invoice_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_payment_id` FOREIGN KEY (`payment_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`payment`(`payment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_dispute_id` FOREIGN KEY (`dispute_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`dispute`(`dispute_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_invoice_line_id` FOREIGN KEY (`invoice_line_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice_line`(`invoice_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_receivable_account_id` FOREIGN KEY (`receivable_account_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`receivable_account`(`receivable_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_reversal_credit_note_adjustment_id` FOREIGN KEY (`reversal_credit_note_adjustment_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`adjustment`(`adjustment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_dispute_id` FOREIGN KEY (`dispute_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`dispute`(`dispute_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_invoice_line_id` FOREIGN KEY (`invoice_line_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice_line`(`invoice_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_receivable_account_id` FOREIGN KEY (`receivable_account_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`receivable_account`(`receivable_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_invoice_line_id` FOREIGN KEY (`invoice_line_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice_line`(`invoice_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_receivable_account_id` FOREIGN KEY (`receivable_account_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`receivable_account`(`receivable_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ADD CONSTRAINT `fk_billing_receivable_account_parent_account_receivable_account_id` FOREIGN KEY (`parent_account_receivable_account_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`receivable_account`(`receivable_account_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`billing` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_shipping_ports_v1`.`billing` SET TAGS ('dbx_domain' = 'billing');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` SET TAGS ('dbx_subdomain' = 'revenue_processing');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `agent_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Agent Appointment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `flag_state_id` SET TAGS ('dbx_business_glossary_term' = 'Flag State Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `participant_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Service Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `port_call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Cycle Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `psc_inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Psc Inspection Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `service_id` SET TAGS ('dbx_business_glossary_term' = 'Intermodal Service Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `adjustment_amount` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `baf_amount` SET TAGS ('dbx_business_glossary_term' = 'Bunker Adjustment Factor (BAF) Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `bol_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `bol_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `caf_amount` SET TAGS ('dbx_business_glossary_term' = 'Currency Adjustment Factor (CAF) Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `credit_note_number` SET TAGS ('dbx_business_glossary_term' = 'Credit Note Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `credit_note_number` SET TAGS ('dbx_value_regex' = '^CN-[0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `delivery_method` SET TAGS ('dbx_business_glossary_term' = 'Invoice Delivery Method');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `delivery_method` SET TAGS ('dbx_value_regex' = 'email|postal_mail|edi|portal|fax');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `dispute_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Invoice Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `invoice_number` SET TAGS ('dbx_value_regex' = '^INV-[0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `invoice_status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Status');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `payment_received_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Received Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `payment_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Payment Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `pod_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `pod_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `pol_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Loading (POL) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `pol_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Invoice Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `revenue_recognition_date` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `sap_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `sap_document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `subtotal_amount` SET TAGS ('dbx_business_glossary_term' = 'Invoice Subtotal Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `tax_exemption_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Tax Exemption Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `tax_exemption_flag` SET TAGS ('dbx_business_glossary_term' = 'Tax Exemption Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `tax_jurisdiction_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Jurisdiction Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `tax_jurisdiction_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ALTER COLUMN `total_amount` SET TAGS ('dbx_business_glossary_term' = 'Invoice Total Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` SET TAGS ('dbx_subdomain' = 'revenue_processing');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `invoice_line_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Line Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `charge_event_id` SET TAGS ('dbx_business_glossary_term' = 'Charge Event Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `discount_scheme_id` SET TAGS ('dbx_business_glossary_term' = 'Discount Scheme Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `drayage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Drayage Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `handling_order_id` SET TAGS ('dbx_business_glossary_term' = 'Handling Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `icd_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Icd Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `import_export_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Import Export Permit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `item_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Item Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `marpol_record_id` SET TAGS ('dbx_business_glossary_term' = 'Marpol Waste Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `original_invoice_line_id` SET TAGS ('dbx_business_glossary_term' = 'Original Invoice Line Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Performance Obligation Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `port_dues_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Port Dues Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `rate_card_line_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `service_id` SET TAGS ('dbx_business_glossary_term' = 'Intermodal Service Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `spare_part_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `storage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `surcharge_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Rule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `thc_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Thc Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `truck_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `wharfage_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Wharfage Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `adjustment_flag` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `bol_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `bol_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `charge_category` SET TAGS ('dbx_business_glossary_term' = 'Charge Category');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `container_number` SET TAGS ('dbx_business_glossary_term' = 'Container Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `container_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `line_amount` SET TAGS ('dbx_business_glossary_term' = 'Line Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Line Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Line Item Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `revenue_recognition_date` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `service_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Service End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `service_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Service Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `tax_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `tax_rate` SET TAGS ('dbx_business_glossary_term' = 'Tax Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ALTER COLUMN `unit_rate` SET TAGS ('dbx_business_glossary_term' = 'Unit Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` SET TAGS ('dbx_subdomain' = 'cash_application');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `payment_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Account Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Cycle Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `receivable_account_id` SET TAGS ('dbx_business_glossary_term' = 'Receivable Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `sanctions_screening_id` SET TAGS ('dbx_business_glossary_term' = 'Sanctions Screening Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `allocated_amount` SET TAGS ('dbx_business_glossary_term' = 'Allocated Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `amount_paid` SET TAGS ('dbx_business_glossary_term' = 'Amount Paid');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `bank_reference` SET TAGS ('dbx_business_glossary_term' = 'Bank Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `base_currency_amount` SET TAGS ('dbx_business_glossary_term' = 'Base Currency Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `channel` SET TAGS ('dbx_business_glossary_term' = 'Payment Channel');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `channel` SET TAGS ('dbx_value_regex' = 'online_portal|bank_transfer|PCS|SAP|manual_entry|EDI');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `clearing_date` SET TAGS ('dbx_business_glossary_term' = 'Clearing Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `discount_taken` SET TAGS ('dbx_business_glossary_term' = 'Discount Taken');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `dispute_reference` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `is_advance_payment` SET TAGS ('dbx_business_glossary_term' = 'Is Advance Payment Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `method` SET TAGS ('dbx_value_regex' = 'EFT|SWIFT|cheque|direct_debit|letter_of_credit|cash');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `navis_billing_reference` SET TAGS ('dbx_business_glossary_term' = 'NAVIS Billing Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Payment Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `payer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Payer Bank Account Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `payer_account_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `payer_bank_name` SET TAGS ('dbx_business_glossary_term' = 'Payer Bank Name');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `payment_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `payment_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `payment_status` SET TAGS ('dbx_value_regex' = 'pending|cleared|bounced|reversed|partially_applied|fully_applied');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `payment_type` SET TAGS ('dbx_business_glossary_term' = 'Payment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `payment_type` SET TAGS ('dbx_value_regex' = 'advance|on_account|invoice_payment|refund|credit_note_settlement');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `received_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payment Received Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `reconciled_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Reconciled Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_business_glossary_term' = 'Reconciliation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_value_regex' = 'unreconciled|reconciled|disputed|under_review');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `reference_number` SET TAGS ('dbx_business_glossary_term' = 'Payment Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `remittance_advice_reference` SET TAGS ('dbx_business_glossary_term' = 'Remittance Advice Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `reversal_date` SET TAGS ('dbx_business_glossary_term' = 'Reversal Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `reversal_reason` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `sap_clearing_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Clearing Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `sap_payment_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Payment Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ALTER COLUMN `unapplied_amount` SET TAGS ('dbx_business_glossary_term' = 'Unapplied Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` SET TAGS ('dbx_subdomain' = 'cash_application');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `payment_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Allocation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `debit_note_id` SET TAGS ('dbx_business_glossary_term' = 'Debit Note Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice ID');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `invoice_line_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Line ID');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `payment_id` SET TAGS ('dbx_business_glossary_term' = 'Payment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `accounting_period` SET TAGS ('dbx_business_glossary_term' = 'Accounting Period');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `accounting_period` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-(0[1-9]|1[0-2])$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocated_amount` SET TAGS ('dbx_business_glossary_term' = 'Allocated Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_date` SET TAGS ('dbx_business_glossary_term' = 'Allocation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_reference` SET TAGS ('dbx_business_glossary_term' = 'Allocation Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_reference` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_source` SET TAGS ('dbx_business_glossary_term' = 'Allocation Source System');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_source` SET TAGS ('dbx_value_regex' = 'manual|automated|edi|lockbox|api');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_status` SET TAGS ('dbx_business_glossary_term' = 'Allocation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_status` SET TAGS ('dbx_value_regex' = 'pending|confirmed|reversed|cancelled|disputed');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Allocation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_type` SET TAGS ('dbx_business_glossary_term' = 'Allocation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_type` SET TAGS ('dbx_value_regex' = 'full|partial|advance|overpayment|on_account|credit_note');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `bank_reconciliation_reference` SET TAGS ('dbx_business_glossary_term' = 'Bank Reconciliation Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `business_area` SET TAGS ('dbx_business_glossary_term' = 'Business Area');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `business_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `discount_taken` SET TAGS ('dbx_business_glossary_term' = 'Cash Discount Taken');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `dispute_reference` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `local_currency_amount` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Allocation Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `outstanding_balance` SET TAGS ('dbx_business_glossary_term' = 'Outstanding Balance After Allocation');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `profit_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `reversal_date` SET TAGS ('dbx_business_glossary_term' = 'Reversal Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `reversal_document` SET TAGS ('dbx_business_glossary_term' = 'Reversal Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `reversal_document` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `reversal_reason` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `sap_clearing_document` SET TAGS ('dbx_business_glossary_term' = 'SAP Clearing Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `sap_clearing_document` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `sap_clearing_item` SET TAGS ('dbx_business_glossary_term' = 'SAP Clearing Item Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `sap_clearing_item` SET TAGS ('dbx_value_regex' = '^[0-9]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ALTER COLUMN `withholding_tax_deducted` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax Deducted');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` SET TAGS ('dbx_subdomain' = 'cash_application');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Dredging Campaign Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `demurrage_detention_id` SET TAGS ('dbx_business_glossary_term' = 'Demurrage Detention Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `discount_scheme_id` SET TAGS ('dbx_business_glossary_term' = 'Discount Scheme Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `dispute_id` SET TAGS ('dbx_business_glossary_term' = 'Dispute Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `drayage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Drayage Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice ID');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `invoice_line_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `item_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Exception Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Account ID');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Cycle Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `receivable_account_id` SET TAGS ('dbx_business_glossary_term' = 'Receivable Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `reversal_credit_note_adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Reversal Credit Note ID');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `truck_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Appointment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `truck_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Infrastructure Closure Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `applied_date` SET TAGS ('dbx_business_glossary_term' = 'Applied Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `approval_authority` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `container_number` SET TAGS ('dbx_business_glossary_term' = 'Container Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `container_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `credit_amount` SET TAGS ('dbx_business_glossary_term' = 'Credit Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `credit_note_date` SET TAGS ('dbx_business_glossary_term' = 'Credit Note Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `credit_note_number` SET TAGS ('dbx_business_glossary_term' = 'Credit Note Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `credit_note_number` SET TAGS ('dbx_value_regex' = '^CN-[0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `credit_note_status` SET TAGS ('dbx_business_glossary_term' = 'Credit Note Status');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `credit_note_status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|approved|applied|cancelled|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `credit_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Credit Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `credit_reason_description` SET TAGS ('dbx_business_glossary_term' = 'Credit Reason Description');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `customer_notification_sent` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Sent');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `customer_reference` SET TAGS ('dbx_business_glossary_term' = 'Customer Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `internal_notes` SET TAGS ('dbx_business_glossary_term' = 'Internal Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `internal_notes` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `notification_sent_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Notification Sent Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `original_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Original Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `sap_credit_memo_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Credit Memo Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `sap_posting_date` SET TAGS ('dbx_business_glossary_term' = 'SAP Posting Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `tax_credit_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Credit Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `total_credit_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Credit Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` SET TAGS ('dbx_subdomain' = 'cash_application');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `debit_note_id` SET TAGS ('dbx_business_glossary_term' = 'Debit Note Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Ohs Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `discount_scheme_id` SET TAGS ('dbx_business_glossary_term' = 'Discount Scheme Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `dispute_id` SET TAGS ('dbx_business_glossary_term' = 'Dispute Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `drayage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Message Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `import_export_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Import Export Permit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Originating Invoice Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `invoice_line_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `item_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Item Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `marpol_record_id` SET TAGS ('dbx_business_glossary_term' = 'Marpol Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Account Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Cycle Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By Employee Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `receivable_account_id` SET TAGS ('dbx_business_glossary_term' = 'Receivable Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `truck_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Appointment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `truck_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `acknowledgement_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Acknowledgement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `approval_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Approval Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `bol_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Additional Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `container_number` SET TAGS ('dbx_business_glossary_term' = 'Container Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `container_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `customer_acknowledgement_status` SET TAGS ('dbx_business_glossary_term' = 'Customer Acknowledgement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `customer_acknowledgement_status` SET TAGS ('dbx_value_regex' = 'not_sent|sent|acknowledged|rejected|pending_review');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `debit_note_number` SET TAGS ('dbx_business_glossary_term' = 'Debit Note Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `debit_note_number` SET TAGS ('dbx_value_regex' = '^DN-[0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `debit_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Debit Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `debit_reason_description` SET TAGS ('dbx_business_glossary_term' = 'Debit Reason Description');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `debit_status` SET TAGS ('dbx_business_glossary_term' = 'Debit Note Status');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Debit Note Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modification Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Internal Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Financial Posting Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `reversal_date` SET TAGS ('dbx_business_glossary_term' = 'Reversal Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `reversal_flag` SET TAGS ('dbx_business_glossary_term' = 'Reversal Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `reversal_reason` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `sap_debit_memo_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Debit Memo Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `service_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Service Period End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `service_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Service Period Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ALTER COLUMN `total_debit_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Debit Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` SET TAGS ('dbx_subdomain' = 'cash_application');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `dispute_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Dispute Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `contact_person_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Person Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `service_request_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Relationship Management (CRM) Service Request Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `demurrage_detention_id` SET TAGS ('dbx_business_glossary_term' = 'Demurrage Detention Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `drayage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Drayage Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `failure_report_id` SET TAGS ('dbx_business_glossary_term' = 'Failure Report Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `invoice_line_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `item_id` SET TAGS ('dbx_business_glossary_term' = 'Item Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Account Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `participant_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Service Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `receivable_account_id` SET TAGS ('dbx_business_glossary_term' = 'Receivable Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `sanctions_screening_id` SET TAGS ('dbx_business_glossary_term' = 'Sanctions Screening Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `storage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `truck_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Appointment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `truck_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `assigned_date` SET TAGS ('dbx_business_glossary_term' = 'Assigned Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `dispute_category` SET TAGS ('dbx_business_glossary_term' = 'Dispute Category');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `dispute_category` SET TAGS ('dbx_value_regex' = 'vessel_charges|cargo_charges|equipment_charges|storage_charges|service_charges|administrative_charges');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `credit_amount` SET TAGS ('dbx_business_glossary_term' = 'Credit Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `credit_note_reference` SET TAGS ('dbx_business_glossary_term' = 'Credit Note Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `customer_satisfaction_rating` SET TAGS ('dbx_business_glossary_term' = 'Customer Satisfaction Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `dispute_status` SET TAGS ('dbx_business_glossary_term' = 'Dispute Status');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `disputed_amount` SET TAGS ('dbx_business_glossary_term' = 'Disputed Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `disputed_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Disputed Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `disputed_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `escalation_date` SET TAGS ('dbx_business_glossary_term' = 'Escalation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `escalation_level` SET TAGS ('dbx_business_glossary_term' = 'Escalation Level');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `escalation_level` SET TAGS ('dbx_value_regex' = 'none|supervisor|manager|director|executive');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `investigation_notes` SET TAGS ('dbx_business_glossary_term' = 'Investigation Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `last_modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `lodged_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Lodged Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `lodged_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Dispute Lodged Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `preventive_action_taken` SET TAGS ('dbx_business_glossary_term' = 'Preventive Action Taken');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `reason_code` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `reason_description` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason Description');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `reference_number` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `reference_number` SET TAGS ('dbx_value_regex' = '^DSP-[0-9]{8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Resolution Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `resolution_notes` SET TAGS ('dbx_business_glossary_term' = 'Resolution Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `resolution_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Resolution Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `resolution_type` SET TAGS ('dbx_business_glossary_term' = 'Resolution Type');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `resolution_type` SET TAGS ('dbx_value_regex' = 'accepted_full_credit|rejected_no_credit|partial_credit|withdrawn_by_customer|escalated_to_management');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `root_cause_code` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `sla_actual_resolution_days` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Actual Resolution Days');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `sla_target_resolution_days` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Target Resolution Days');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ALTER COLUMN `supporting_documents_reference` SET TAGS ('dbx_business_glossary_term' = 'Supporting Documents Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` SET TAGS ('dbx_subdomain' = 'cash_application');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `receivable_account_id` SET TAGS ('dbx_business_glossary_term' = 'Receivable Account ID');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `credit_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Assessment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `customs_broker_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `haulier_id` SET TAGS ('dbx_business_glossary_term' = 'Haulier Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `parent_account_receivable_account_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Account ID');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Cycle Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Account Manager ID');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `rail_operator_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Operator Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `sanctions_screening_id` SET TAGS ('dbx_business_glossary_term' = 'Sanctions Screening Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `account_classification` SET TAGS ('dbx_business_glossary_term' = 'Account Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `account_classification` SET TAGS ('dbx_value_regex' = 'shipping_line|freight_forwarder|cargo_owner|terminal_operator|government|customs_broker');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `account_closed_date` SET TAGS ('dbx_business_glossary_term' = 'Account Closed Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `account_code` SET TAGS ('dbx_business_glossary_term' = 'Account Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `account_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `account_name` SET TAGS ('dbx_business_glossary_term' = 'Account Name');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `account_opened_date` SET TAGS ('dbx_business_glossary_term' = 'Account Opened Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `account_status` SET TAGS ('dbx_business_glossary_term' = 'Account Status');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `account_status` SET TAGS ('dbx_value_regex' = 'active|suspended|credit_hold|blocked|closed');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `aging_bucket_0_30_days` SET TAGS ('dbx_business_glossary_term' = 'Aging Bucket 0-30 Days');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `aging_bucket_0_30_days` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `aging_bucket_31_60_days` SET TAGS ('dbx_business_glossary_term' = 'Aging Bucket 31-60 Days');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `aging_bucket_31_60_days` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `aging_bucket_61_90_days` SET TAGS ('dbx_business_glossary_term' = 'Aging Bucket 61-90 Days');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `aging_bucket_61_90_days` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `aging_bucket_over_90_days` SET TAGS ('dbx_business_glossary_term' = 'Aging Bucket Over 90 Days');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `aging_bucket_over_90_days` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `auto_payment_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto Payment Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `average_days_to_pay` SET TAGS ('dbx_business_glossary_term' = 'Average Days to Pay');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_address_line1` SET TAGS ('dbx_business_glossary_term' = 'Billing Address Line 1');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_address_line2` SET TAGS ('dbx_business_glossary_term' = 'Billing Address Line 2');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_city` SET TAGS ('dbx_business_glossary_term' = 'Billing City');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_country` SET TAGS ('dbx_business_glossary_term' = 'Billing Country');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_country` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_email` SET TAGS ('dbx_business_glossary_term' = 'Billing Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_phone` SET TAGS ('dbx_business_glossary_term' = 'Billing Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_postal_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Postal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_state_province` SET TAGS ('dbx_business_glossary_term' = 'Billing State or Province');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_state_province` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `billing_state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `consolidation_flag` SET TAGS ('dbx_business_glossary_term' = 'Consolidation Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `credit_hold_flag` SET TAGS ('dbx_business_glossary_term' = 'Credit Hold Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `credit_limit` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `credit_limit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `credit_rating` SET TAGS ('dbx_business_glossary_term' = 'Credit Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `credit_rating` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `dispute_count_ytd` SET TAGS ('dbx_business_glossary_term' = 'Dispute Count Year-to-Date (YTD)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `dunning_level` SET TAGS ('dbx_business_glossary_term' = 'Dunning Level');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `invoice_delivery_method` SET TAGS ('dbx_business_glossary_term' = 'Invoice Delivery Method');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `invoice_delivery_method` SET TAGS ('dbx_value_regex' = 'email|edi|portal|postal_mail|fax');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `last_invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Last Invoice Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `last_payment_amount` SET TAGS ('dbx_business_glossary_term' = 'Last Payment Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `last_payment_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `last_payment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Payment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `outstanding_balance` SET TAGS ('dbx_business_glossary_term' = 'Outstanding Balance');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `outstanding_balance` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `preferred_currency` SET TAGS ('dbx_business_glossary_term' = 'Preferred Currency');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `preferred_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `sap_customer_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Customer Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `sap_customer_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `statement_frequency` SET TAGS ('dbx_business_glossary_term' = 'Statement Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `statement_frequency` SET TAGS ('dbx_value_regex' = 'weekly|monthly|quarterly|on_request|none');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `tax_jurisdiction` SET TAGS ('dbx_business_glossary_term' = 'Tax Jurisdiction');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `tax_jurisdiction` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `vat_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Value Added Tax (VAT) Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `vat_registration_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `write_off_amount_ytd` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Amount Year-to-Date (YTD)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ALTER COLUMN `write_off_amount_ytd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` SET TAGS ('dbx_subdomain' = 'revenue_processing');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `charge_event_id` SET TAGS ('dbx_business_glossary_term' = 'Charge Event Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `icd_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Icd Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `import_export_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Import Export Permit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `inspection_record_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `manifest_id` SET TAGS ('dbx_business_glossary_term' = 'Manifest Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `marpol_record_id` SET TAGS ('dbx_business_glossary_term' = 'Marpol Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `movement_id` SET TAGS ('dbx_business_glossary_term' = 'Movement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Account Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `participant_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Service Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Contractor Safety Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Cycle Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `port_dues_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Port Dues Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Charge Call Id');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `rate_card_line_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `service_id` SET TAGS ('dbx_business_glossary_term' = 'Intermodal Service Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `storage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `surcharge_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Rule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `thc_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Thc Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `trade_document_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Document Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `truck_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Intermodal Leg Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Organization (IMO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `wharfage_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Wharfage Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Charge Approved Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `billing_status` SET TAGS ('dbx_business_glossary_term' = 'Billing Status');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `billing_status` SET TAGS ('dbx_value_regex' = 'unbilled|billed|disputed|waived|cancelled|reversed');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `cargo_volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Cargo Volume in Cubic Meters (CBM)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `cargo_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Cargo Weight in Kilograms (KG)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `container_number` SET TAGS ('dbx_business_glossary_term' = 'Container Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `container_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `daily_rate` SET TAGS ('dbx_business_glossary_term' = 'Daily Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Charge Event Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `event_type` SET TAGS ('dbx_business_glossary_term' = 'Charge Event Type');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `event_type` SET TAGS ('dbx_value_regex' = 'commercial|statutory|demurrage|detention|wharfage|port_dues');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `excess_days` SET TAGS ('dbx_business_glossary_term' = 'Excess Days');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `exemption_flag` SET TAGS ('dbx_business_glossary_term' = 'Exemption Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `exemption_reason` SET TAGS ('dbx_business_glossary_term' = 'Exemption Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `free_time_days` SET TAGS ('dbx_business_glossary_term' = 'Free Time Days Allowed');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `free_time_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Free Time End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `free_time_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Free Time Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `hazmat_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HAZMAT) Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `imdg_class` SET TAGS ('dbx_value_regex' = '^[1-9](.[1-9])?$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `net_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Service Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `reefer_flag` SET TAGS ('dbx_business_glossary_term' = 'Reefer Container Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `reference` SET TAGS ('dbx_business_glossary_term' = 'Charge Event Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `reference` SET TAGS ('dbx_value_regex' = '^CHG-[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `source_system_reference` SET TAGS ('dbx_business_glossary_term' = 'Source System Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `statutory_authority_reference` SET TAGS ('dbx_business_glossary_term' = 'Statutory Authority Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `tariff_code` SET TAGS ('dbx_business_glossary_term' = 'Tariff Code');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `tariff_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,15}$');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ALTER COLUMN `unit_rate` SET TAGS ('dbx_business_glossary_term' = 'Unit Rate');
