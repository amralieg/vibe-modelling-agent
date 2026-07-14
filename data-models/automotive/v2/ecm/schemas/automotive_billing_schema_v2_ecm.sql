-- Schema for Domain: billing | Business:  | Version: v2_ecm
-- Generated on: 2026-07-14 02:32:19

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`billing` COMMENT 'SSOT for all revenue transactions and receivables. Owns dealer invoices, retail customer billing, fleet account statements, parts and service charges, payment records, credit notes, and dispute management. Handles invoicing, payment receipt, credit memos, and financial settlement for vehicle sales and services. Integrates with SAP SD/FI and supports MSRP-based and negotiated pricing models.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`invoice` (
    `invoice_id` BIGINT COMMENT 'Unique identifier for the invoice record. Primary key.',
    `account_id` BIGINT COMMENT 'Foreign key linking to billing.billing_account. Business justification: Invoicing is performed per billing account; needed for account‑level revenue reporting and statement generation.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier. Business justification: Invoice includes carrier charges; linking to carrier enables carrier performance reporting and compliance with freight cost audits.',
    `compliance_emissions_certification_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_emissions_certification. Business justification: Needed to associate each sold vehicle invoice with its emissions certification for mandatory emissions reporting.',
    `employee_id` BIGINT COMMENT 'Reference to the salesperson or account manager responsible for this sale, used for commission and performance tracking.',
    `homologation_record_id` BIGINT COMMENT 'Foreign key linking to compliance.homologation_record. Business justification: Required for sales invoicing to verify each vehicle model is homologated for the market, supporting the Homologation Compliance Report.',
    `party_id` BIGINT COMMENT 'Reference to the customer (dealer, retail buyer, fleet account, or corporate buyer) to whom this invoice is issued.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealer entity when the invoice is issued to a dealer for wholesale vehicle or parts transactions. Null for retail and fleet invoices.',
    `invoice_dealership_id` BIGINT COMMENT 'Reference to the dealer entity when the invoice is issued to a dealer for wholesale vehicle or parts transactions. Null for retail and fleet invoices.',
    `invoice_party_id` BIGINT COMMENT 'Reference to the customer (dealer, retail buyer, fleet account, or corporate buyer) to whom this invoice is issued.',
    `maintenance_order_id` BIGINT COMMENT 'Foreign key linking to asset.maintenance_order. Business justification: Invoices for maintenance services must link to the originating maintenance order for audit trail and revenue recognition.',
    `payment_term_id` BIGINT COMMENT 'Foreign key linking to billing.payment_term. Business justification: Invoice references a payment term; using a foreign key to payment_term provides full term details and removes the redundant code column.',
    `rep_id` BIGINT COMMENT 'Reference to the salesperson or account manager responsible for this sale, used for commission and performance tracking.',
    `service_contract_id` BIGINT COMMENT 'Foreign key linking to aftersales.service_contract. Business justification: REQUIRED: Service‑contract billing generates periodic invoices; linking enables contract‑level revenue and compliance tracking.',
    `supply_purchase_order_id` BIGINT COMMENT 'Foreign key linking to supply.supply_purchase_order. Business justification: AP process matches supplier purchase orders to invoices for payment reconciliation; experts expect a PO FK on invoice.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Needed for program-level financial reporting and cost allocation: linking each invoice to its vehicle program enables revenue tracking per engineering program.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Invoices for vehicle sales need to reference the exact vehicle VIN; adding vin_id creates a direct link between billing and the vehicle master.',
    `billing_address_line1` STRING COMMENT 'First line of the billing address to which the invoice is sent.',
    `billing_address_line2` STRING COMMENT 'Second line of the billing address (suite, building, department).',
    `billing_city` STRING COMMENT 'City of the billing address.',
    `billing_country_code` STRING COMMENT 'Three-letter ISO country code of the billing address.. Valid values are `^[A-Z]{3}$`',
    `billing_entity_code` STRING COMMENT 'Code identifying the legal entity or business unit issuing the invoice (e.g., regional sales company, parts distribution center, service center).. Valid values are `^[A-Z0-9]{4,10}$`',
    `billing_postal_code` STRING COMMENT 'Postal or ZIP code of the billing address.',
    `billing_state_province` STRING COMMENT 'State or province of the billing address.',
    `cancellation_reason` STRING COMMENT 'Description of the reason for invoice cancellation (order cancelled, billing error, duplicate invoice).',
    `cancelled_timestamp` TIMESTAMP COMMENT 'Timestamp when the invoice was cancelled, if applicable. Null for active invoices.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this invoice record was first created in the system. Audit trail field.',
    `credit_memo_reference` STRING COMMENT 'Reference to a credit memo document number if this invoice has been partially or fully credited.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code in which the invoice is denominated.. Valid values are `^[A-Z]{3}$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total discount amount applied to the invoice (volume discounts, promotional discounts, early payment discounts).',
    `dispute_date` DATE COMMENT 'Date when the invoice was flagged as disputed by the customer or internal review.',
    `dispute_reason` STRING COMMENT 'Description of the reason for dispute if the invoice status is disputed (pricing error, quantity mismatch, quality issue, delivery issue).',
    `due_date` DATE COMMENT 'The date by which payment is expected per the agreed payment terms.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month or quarter) within the fiscal year when the invoice was issued.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the invoice was issued, used for financial reporting and period closing.',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total invoice amount before taxes, discounts, and adjustments.',
    `invoice_date` DATE COMMENT 'The date the invoice was formally issued to the customer. Principal business event timestamp for the billing transaction.',
    `invoice_number` STRING COMMENT 'Externally-known unique invoice document number issued to the customer. Business identifier for the invoice.. Valid values are `^[A-Z0-9]{8,20}$`',
    `invoice_status` STRING COMMENT 'Current lifecycle status of the invoice in the billing and collection workflow.. Valid values are `draft|issued|partially_paid|paid|cancelled|disputed`',
    `invoice_type` STRING COMMENT 'Classification of the invoice based on the customer segment and transaction nature (dealer wholesale, retail customer, fleet account, parts sale, service work, warranty claim).. Valid values are `dealer|retail|fleet|parts|service|warranty`',
    `model_year` STRING COMMENT 'Model year of the vehicle or product being invoiced, providing context for pricing and product configuration.',
    `msrp_based_flag` BOOLEAN COMMENT 'Indicates whether the invoice pricing is based on MSRP (true) or negotiated/contracted pricing (false).',
    `net_amount` DECIMAL(18,2) COMMENT 'Final invoice amount payable after applying taxes, discounts, and all adjustments. This is the amount due from the customer.',
    `notes` STRING COMMENT 'Free-text notes or comments related to the invoice (special instructions, payment arrangements, delivery notes).',
    `outstanding_amount` DECIMAL(18,2) COMMENT 'Remaining unpaid balance on the invoice (net_amount minus paid_amount).',
    `paid_amount` DECIMAL(18,2) COMMENT 'Total amount paid against this invoice to date. Used to track partial payments.',
    `payment_method` STRING COMMENT 'The payment instrument or method expected or used for settling this invoice.. Valid values are `wire_transfer|check|credit_card|ach|cash|letter_of_credit`',
    `payment_received_date` DATE COMMENT 'Date when the full or final payment was received for this invoice. Null if not yet fully paid.',
    `sales_order_number` STRING COMMENT 'Reference to the originating sales order or service order that this invoice bills for.. Valid values are `^[A-Z0-9]{8,20}$`',
    `sales_region_code` STRING COMMENT 'Code identifying the sales region or territory to which this invoice is attributed for revenue reporting.. Valid values are `^[A-Z0-9]{2,10}$`',
    `sap_billing_document_number` STRING COMMENT 'Reference to the SAP SD billing document number from which this invoice was generated. System of record identifier.. Valid values are `^[0-9]{10}$`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount applied to the invoice (sales tax, VAT, GST, etc.).',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this invoice record was last modified. Audit trail field.',
    `vin` STRING COMMENT '17-character Vehicle Identification Number of the vehicle being invoiced, if applicable (for vehicle sales invoices).. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_invoice PRIMARY KEY(`invoice_id`)
) COMMENT 'Core billing document representing a formal demand for payment issued to dealers, retail customers, fleet accounts, or corporate buyers for vehicle sales, parts, or services. Captures invoice number, invoice date, due date, invoice type (dealer/retail/fleet/parts/service), billing entity, billing address, currency, total amount, tax amount, discount amount, net amount, payment terms, invoice status (draft/issued/partially_paid/paid/cancelled/disputed), SAP SD billing document reference, MSRP-based or negotiated pricing flag, and model year context. SSOT for all outbound billing documents in the enterprise.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` (
    `billing_invoice_line_id` BIGINT COMMENT 'Unique identifier for the invoice line item. Primary key for the invoice_line product.',
    `aftersales_service_appointment_id` BIGINT COMMENT 'Foreign key linking to aftersales.service_appointment. Business justification: REQUIRED: Service appointments generate billable items; linking appointment to invoice line provides appointment‑level financial reporting.',
    `billing_price_condition_id` BIGINT COMMENT 'Foreign key linking to billing.price_condition. Business justification: Invoice line items can be priced by a pricing condition; linking to price_condition normalizes pricing logic.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Needed to allocate line‑level costs to the correct cost center for internal cost tracking and reporting.',
    `employee_id` BIGINT COMMENT 'Identifier of the salesperson who completed this transaction. Used for sales commission calculation and performance tracking.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Required for General Ledger posting of each invoice line revenue to the appropriate GL account for financial reporting.',
    `invoice_id` BIGINT COMMENT 'Reference to the parent invoice header. Links this line item to the billing invoice document.',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Required for warranty claim and recall tracking: each invoice line must reference the engineering part master to associate sold parts with design, compliance, and cost data.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Supports profit‑center profitability analysis by linking each sales line to its profit center.',
    `rep_id` BIGINT COMMENT 'Identifier of the salesperson who completed this transaction. Used for sales commission calculation and performance tracking.',
    `repair_order_line_id` BIGINT COMMENT 'Foreign key linking to aftersales.repair_order_line. Business justification: REQUIRED: Each invoice line originates from a repair‑order line; the link supports detailed cost‑to‑service analysis.',
    `service_contract_claim_id` BIGINT COMMENT 'Foreign key linking to aftersales.service_contract_claim. Business justification: REQUIRED: Claims under service contracts are billed; linking claim to invoice line enables claim settlement and audit.',
    `service_subscription_id` BIGINT COMMENT 'Foreign key linking to mobility.service_subscription. Business justification: Needed for the Usage‑Based Service Billing report, linking each invoice line to the subscription that produced the charge.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Invoice line items represent sold SKUs; linking each invoice_line to the product SKU provides traceability from billing to product catalog.',
    `supply_po_line_id` BIGINT COMMENT 'Foreign key linking to supply.supply_po_line. Business justification: Invoice line validation against PO line items is required for accurate cost allocation and audit; standard in automotive AP.',
    `tax_code_id` BIGINT COMMENT 'Foreign key linking to billing.tax_code. Business justification: Invoice line tax details should reference the tax_code master; the tax rate can be derived, so the string code and rate columns are redundant.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Invoice line items are allocated to a specific vehicle for warranty and service charge tracking; linking ensures accurate vehicle‑level financial reporting.',
    `billing_date` DATE COMMENT 'Date when this line item was billed. Represents the accounting date for revenue recognition and the invoice document date.',
    `cancellation_reason` STRING COMMENT 'Reason code or description if this line was cancelled. Provides audit trail for cancelled billing lines and supports dispute analysis.',
    `cost_center` STRING COMMENT 'Cost center responsible for this revenue line. Used for internal cost accounting and profitability analysis by organizational unit.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this invoice line record was first created in the billing system. Provides audit trail for record creation.',
    `credit_memo_reference` STRING COMMENT 'Reference to the credit memo document if this line was credited. Links to the reversing document for returns, adjustments, or billing corrections.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts on this line. Indicates the currency in which the line is billed (e.g., USD, EUR, JPY, GBP, CAD).. Valid values are `^[A-Z]{3}$`',
    `dealer_code` STRING COMMENT 'Dealer or distribution partner code responsible for this sale. Identifies the selling dealer location for dealer network reporting and commission calculation.',
    `delivery_number` STRING COMMENT 'Reference to the delivery document that fulfilled this line. Links the billing to the physical shipment or service delivery event.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total discount applied to this line item. Represents the monetary reduction from the base unit price, including promotional discounts, volume discounts, and negotiated reductions.',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Discount expressed as a percentage of the unit price. Provides the rate of discount applied to calculate the discount_amount.',
    `item_code` STRING COMMENT 'Universal item identifier for the billed product or service. May represent a vehicle model code, part number, labor operation code, accessory SKU (Stock Keeping Unit), or fee code depending on line_item_type.',
    `item_description` STRING COMMENT 'Human-readable description of the billed item. Provides detailed text explaining the product, service, or charge represented by this line.',
    `labor_operation_code` STRING COMMENT 'Standardized labor operation code for service work. Identifies the specific repair or maintenance task performed. Populated only when line_item_type is labor.',
    `line_item_type` STRING COMMENT 'Classification of the invoice line item. Distinguishes between vehicle units, parts, labor operations, accessories, service fees, freight charges, warranty products, and insurance products. [ENUM-REF-CANDIDATE: vehicle|part|labor|accessory|fee|freight|warranty|insurance — 8 candidates stripped; promote to reference product]',
    `line_number` STRING COMMENT 'Sequential line number within the invoice. Determines the ordering and display sequence of line items on the invoice document.',
    `line_status` STRING COMMENT 'Current processing status of the invoice line. Tracks the lifecycle state from initial billing through payment or dispute resolution.. Valid values are `open|billed|paid|cancelled|disputed|credited`',
    `line_total_amount` DECIMAL(18,2) COMMENT 'Total amount for this line item including all charges and taxes. Calculated as subtotal_amount + tax_amount. Represents the final billable amount for this line.',
    `modified_by` STRING COMMENT 'User identifier of the person or system that last modified this invoice line record. Supports audit trail and change tracking.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this invoice line record was last modified. Tracks the most recent update to the record for audit and data quality purposes.',
    `msrp` DECIMAL(18,2) COMMENT 'Manufacturer Suggested Retail Price for the item. The list price recommended by the OEM (Original Equipment Manufacturer). Primarily applicable to vehicle and accessory line items.',
    `negotiated_price` DECIMAL(18,2) COMMENT 'Final negotiated price per unit after dealer or customer negotiations. May differ from MSRP (Manufacturer Suggested Retail Price) based on market conditions, promotions, or customer agreements.',
    `notes` STRING COMMENT 'Free-text notes or comments about this invoice line. Captures special instructions, explanations, or additional context for the billing line item.',
    `profit_center` STRING COMMENT 'Profit center for internal P&L (Profit and Loss) reporting. Enables profitability analysis by business segment, product line, or geographic region.',
    `promotion_code` STRING COMMENT 'Marketing promotion or incentive program code applied to this line. Tracks the specific promotional campaign that influenced the pricing or discount.',
    `quantity` DECIMAL(18,2) COMMENT 'Quantity of items or units billed on this line. For vehicles typically 1, for parts the number of units, for labor the number of hours.',
    `revenue_category` STRING COMMENT 'Revenue classification for financial reporting and analytics. Categorizes the line item into major revenue streams for P&L (Profit and Loss) reporting and business intelligence. [ENUM-REF-CANDIDATE: new_vehicle|used_vehicle|parts|service|warranty|finance|insurance — 7 candidates stripped; promote to reference product]',
    `sales_order_line_number` STRING COMMENT 'Line number on the originating sales order. Provides traceability from the invoice line back to the specific sales order line item.',
    `sales_order_number` STRING COMMENT 'Reference to the originating sales order document. Links the invoice line back to the sales order that authorized this billing.',
    `service_date` DATE COMMENT 'Date when the service or delivery occurred. For labor lines, the date the work was performed; for parts, the date the parts were delivered; for vehicles, the delivery date.',
    `subtotal_amount` DECIMAL(18,2) COMMENT 'Line subtotal before taxes. Calculated as (quantity × unit_price) - discount_amount. Represents the net selling amount before tax.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax charged on this line item. Calculated by applying the tax_rate to the subtotal_amount. Includes sales tax, VAT (Value Added Tax), or GST (Goods and Services Tax) as applicable.',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the quantity. EA=Each (for countable items), HR=Hour (for labor), KG=Kilogram, LB=Pound, L=Liter, GAL=Gallon, M=Meter, FT=Foot. [ENUM-REF-CANDIDATE: EA|HR|KG|LB|L|GAL|M|FT — 8 candidates stripped; promote to reference product]',
    `unit_price` DECIMAL(18,2) COMMENT 'Price per unit before discounts and taxes. Represents the base selling price for one unit of the item.',
    `warranty_code` STRING COMMENT 'Warranty program code if this line represents warranty coverage. Identifies the specific warranty plan or extended service contract being billed.',
    `created_by` STRING COMMENT 'User identifier of the person or system that created this invoice line record. Supports audit trail and accountability.',
    CONSTRAINT pk_billing_invoice_line PRIMARY KEY(`billing_invoice_line_id`)
) COMMENT 'Individual line item on a billing invoice representing a specific charge for a vehicle unit, parts SKU, labor operation, accessory, or service fee. Captures line number, item type (vehicle/part/labor/accessory/fee), item code, item description, VIN reference for vehicle lines, part number for parts lines, quantity, unit price, MSRP, negotiated price, discount amount, tax code, tax amount, line total, and revenue category. Supports multi-line invoices for mixed vehicle and parts/service billing.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`payment` (
    `payment_id` BIGINT COMMENT 'Unique identifier for the payment record. Primary key for the payment entity.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Payments are charged to a cost center for cash‑flow and expense tracking.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Cash receipt posting requires a GL account to record the payment in the ledger.',
    `invoice_id` BIGINT COMMENT 'Reference to the invoice against which this payment is applied. Links payment to the billing document.',
    `party_id` BIGINT COMMENT 'Identifier of the entity making the payment (dealer, retail customer, fleet operator, or corporate account).',
    `payment_payer_entity_party_id` BIGINT COMMENT 'Identifier of the entity making the payment (dealer, retail customer, fleet operator, or corporate account).',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Profit‑center reporting of cash receipts requires linking payments to the responsible profit center.',
    `amount` DECIMAL(18,2) COMMENT 'Gross monetary value of the payment received before any adjustments or fees.',
    `applied_amount` DECIMAL(18,2) COMMENT 'Portion of the payment amount that has been successfully applied to outstanding invoices or account balances.',
    `authorization_code` STRING COMMENT 'Authorization code provided by the payment processor or bank confirming approval of the payment transaction.',
    `bank_account_number` STRING COMMENT 'Bank account number from which the payment originated. Masked or tokenized for security. Used for reconciliation and fraud prevention.',
    `bank_reference_number` STRING COMMENT 'Unique reference number assigned by the bank or financial institution for the payment transaction. Used for reconciliation and dispute resolution.',
    `batch_reference` STRING COMMENT 'Identifier for the batch or group of payments processed together. Used for bulk payment processing and reconciliation.',
    `channel` STRING COMMENT 'Interface or channel through which the payment was submitted. Distinguishes between online portal, mobile app, bank transfer, mail, and in-person payments. [ENUM-REF-CANDIDATE: online_portal|mobile_app|bank_transfer|mail|in_person|automated_system|dealer_system — 7 candidates stripped; promote to reference product]',
    `clearing_date` DATE COMMENT 'Date when the payment was cleared and funds were confirmed as received in the company bank account.',
    `created_by_user` STRING COMMENT 'Username or identifier of the user or system that created the payment record. Used for audit trail and accountability.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the payment record was first created in the system. Used for audit trail and data lineage.',
    `currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the payment amount (e.g., USD, EUR, JPY).. Valid values are `^[A-Z]{3}$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Discount amount granted for early payment according to payment terms (e.g., 2% discount for payment within 10 days).',
    `dispute_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this payment is currently under dispute or has been disputed by the payer or payee.',
    `dispute_reason` STRING COMMENT 'Description of the reason for payment dispute. Populated only when dispute_flag is true.',
    `lockbox_number` STRING COMMENT 'Identifier for the bank lockbox service used to receive and process the payment. Applicable for check and mail payments.',
    `method` STRING COMMENT 'Instrument or mechanism used to make the payment. Includes wire transfer, ACH (Automated Clearing House), check, credit card, floorplan financing, and dealer draft. [ENUM-REF-CANDIDATE: wire_transfer|ach|check|credit_card|debit_card|floorplan_financing|dealer_draft|electronic_funds_transfer|cash|promissory_note — 10 candidates stripped; promote to reference product]',
    `notes` STRING COMMENT 'Free-text notes or comments related to the payment. May include remittance advice, special instructions, or reconciliation notes.',
    `payer_entity_type` STRING COMMENT 'Classification of the entity making the payment. Distinguishes between dealer payments, retail customer payments, fleet operator payments, and corporate account payments.. Valid values are `dealer|retail_customer|fleet_operator|corporate_account|leasing_company|financial_institution`',
    `payment_date` DATE COMMENT 'Date when the payment was initiated or received by the payer. Represents the business event date of the payment transaction.',
    `payment_number` STRING COMMENT 'Business-facing unique reference number for the payment transaction. Used for customer communication and reconciliation.',
    `payment_status` STRING COMMENT 'Current lifecycle status of the payment. Tracks whether the payment is pending, cleared, returned, reversed, or cancelled. [ENUM-REF-CANDIDATE: pending|cleared|returned|reversed|cancelled|on_hold|partially_applied — 7 candidates stripped; promote to reference product]',
    `processor` STRING COMMENT 'Name of the third-party payment processor or gateway used to process the payment (e.g., Stripe, PayPal, bank name).',
    `reconciliation_date` DATE COMMENT 'Date when the payment was reconciled with bank statements and confirmed in the accounting system.',
    `reconciliation_status` STRING COMMENT 'Status indicating whether the payment has been successfully reconciled with bank statements and accounting records.. Valid values are `unreconciled|reconciled|disputed|under_review`',
    `remittance_advice` STRING COMMENT 'Detailed remittance information provided by the payer indicating which invoices or charges this payment is intended to cover.',
    `return_date` DATE COMMENT 'Date when the payment was returned or reversed by the bank or payment processor. Populated only when payment status is returned or reversed.',
    `return_reason_code` STRING COMMENT 'Code indicating the reason for payment return or reversal (e.g., insufficient funds, account closed, stop payment). Populated only when payment status is returned or reversed.',
    `routing_number` STRING COMMENT 'Bank routing number or SWIFT code for the payer financial institution. Used for wire transfers and ACH (Automated Clearing House) transactions.',
    `sap_clearing_document_number` STRING COMMENT 'Reference to the SAP FI clearing document that records the application of this payment to open invoices. Links payment to financial accounting records.',
    `sap_payment_document_number` STRING COMMENT 'Reference to the SAP FI payment document that records the receipt of this payment. Primary link to ERP (Enterprise Resource Planning) financial records.',
    `terms_code` STRING COMMENT 'Code representing the payment terms under which this payment was made (e.g., net 30, net 60, immediate). Links to master payment terms reference.',
    `transaction_reference` STRING COMMENT 'Unique transaction identifier assigned by the payment processor or gateway. Used for tracking and reconciliation with external systems.',
    `unapplied_amount` DECIMAL(18,2) COMMENT 'Portion of the payment amount that remains unapplied and is held as credit on the payer account.',
    `updated_by_user` STRING COMMENT 'Username or identifier of the user or system that last modified the payment record. Used for audit trail and accountability.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the payment record was last modified. Used for audit trail and change tracking.',
    CONSTRAINT pk_payment PRIMARY KEY(`payment_id`)
) COMMENT 'Record of a payment received against an invoice or account balance from a dealer, retail customer, fleet operator, or corporate account. Captures payment date, payment method (wire/ACH/check/credit_card/floorplan/dealer_draft), payment amount, currency, applied invoice references, bank reference number, clearing date, payment status (pending/cleared/returned/reversed), SAP FI clearing document reference, and payer entity type. SSOT for all inbound payment receipts in the billing domain.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` (
    `payment_allocation_id` BIGINT COMMENT 'Unique identifier for the payment allocation record. Primary key for the payment allocation entity.',
    `billing_invoice_line_id` BIGINT COMMENT 'Reference to the specific invoice line item being settled. Enables line-level payment allocation for partial settlements and dispute resolution.',
    `invoice_id` BIGINT COMMENT 'Reference to the invoice receiving the payment allocation. Links to the invoice document being settled or partially settled by this allocation.',
    `employee_id` BIGINT COMMENT 'User ID of the supervisor or manager who approved the allocation. Required for allocations requiring management approval due to amount thresholds or exception handling.',
    `payment_employee_id` BIGINT COMMENT 'User ID of the person who created or approved the allocation. Used for audit trail and accountability in manual allocation scenarios.',
    `payment_id` BIGINT COMMENT 'Reference to the payment transaction being allocated. Links to the payment record that is being distributed across one or more invoices.',
    `primary_payment_employee_id` BIGINT COMMENT 'User ID of the person who created or approved the allocation. Used for audit trail and accountability in manual allocation scenarios.',
    `allocated_amount` DECIMAL(18,2) COMMENT 'The monetary amount from the payment that is allocated to this specific invoice or invoice line. Represents the portion of the total payment applied to settle this receivable.',
    `allocated_amount_base_currency` DECIMAL(18,2) COMMENT 'The allocated amount converted to the company base currency using the exchange rate. Enables consolidated financial reporting and accounts receivable aging in a single currency.',
    `allocation_date` DATE COMMENT 'The date when the payment was allocated to the invoice. Represents the business event date for accounts receivable clearing and aging calculations.',
    `allocation_method` STRING COMMENT 'Method used to create the allocation. Automatic indicates system-matched allocation, manual indicates user-created allocation, system_proposed indicates system suggestion requiring approval, batch_clearing indicates mass clearing process.. Valid values are `automatic|manual|system_proposed|batch_clearing`',
    `allocation_number` STRING COMMENT 'Business-readable unique identifier for the payment allocation. Used for tracking and reference in accounts receivable operations and customer communications.. Valid values are `^[A-Z0-9]{8,20}$`',
    `allocation_priority` STRING COMMENT 'Priority sequence for applying payment when multiple invoices are eligible. Lower numbers indicate higher priority. Used in automatic allocation rules and aging calculations.',
    `allocation_status` STRING COMMENT 'Current lifecycle status of the payment allocation. Pending indicates awaiting confirmation, cleared indicates successfully applied, reversed indicates allocation has been undone, disputed indicates under investigation, reconciled indicates confirmed and balanced, voided indicates cancelled allocation.. Valid values are `pending|cleared|reversed|disputed|reconciled|voided`',
    `allocation_timestamp` TIMESTAMP COMMENT 'Precise date and time when the payment allocation was recorded in the system. Used for audit trail and transaction sequencing.',
    `allocation_type` STRING COMMENT 'Classification of the allocation method. Full indicates complete invoice settlement, partial indicates partial payment, advance indicates prepayment before invoice, overpayment indicates excess payment requiring refund or credit, credit_memo indicates credit note application, adjustment indicates manual correction.. Valid values are `full|partial|advance|overpayment|credit_memo|adjustment`',
    `approval_date` DATE COMMENT 'Date when the allocation was approved. Null for automatic allocations not requiring approval. Used for workflow tracking and compliance audit.',
    `business_area` STRING COMMENT 'SAP business area for segment reporting. Enables revenue and receivables analysis by business unit, product line, or geographic region.. Valid values are `^[A-Z0-9]{4}$`',
    `clearing_document_number` STRING COMMENT 'SAP FI clearing document number that records the open item clearing transaction. Links the payment allocation to the financial accounting clearing entry.. Valid values are `^[A-Z0-9]{8,20}$`',
    `clearing_status` STRING COMMENT 'Status of the open item clearing in SAP FI. Open indicates invoice not yet settled, cleared indicates fully settled, partially_cleared indicates partial payment applied, reset indicates clearing was reversed.. Valid values are `open|cleared|partially_cleared|reset`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity receiving the payment. Enables multi-entity financial consolidation and statutory reporting.. Valid values are `^[A-Z0-9]{4}$`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the payment allocation record was first created in the database. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the allocated amount. Supports multi-currency billing and payment scenarios common in global automotive sales and dealer networks.. Valid values are `^[A-Z]{3}$`',
    `customer_account_number` STRING COMMENT 'Customer account number in the accounts receivable system. Used for customer-level payment tracking and credit management.. Valid values are `^[A-Z0-9]{6,15}$`',
    `dealer_code` STRING COMMENT 'Unique identifier for the dealer or customer account associated with this payment allocation. Enables dealer-level accounts receivable reporting and performance tracking.. Valid values are `^[A-Z0-9]{4,10}$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Early payment discount amount applied during this allocation. Common in automotive dealer invoicing where prompt payment terms offer percentage discounts.',
    `discount_percentage` DECIMAL(18,2) COMMENT 'The percentage rate of the cash discount applied. Typically defined in payment terms and calculated based on payment timing relative to invoice date.',
    `dispute_indicator` BOOLEAN COMMENT 'Flag indicating whether this allocation is under dispute. True indicates customer has contested the invoice or payment application.',
    `dispute_reason` STRING COMMENT 'Free-text description of the dispute reason. Captures customer explanation for contesting the allocation or invoice amount.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Exchange rate applied when payment currency differs from invoice currency. Used for cross-currency allocation calculations and financial reporting.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month) within the fiscal year when the allocation occurred. Supports monthly financial close and period-based reporting.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the payment allocation occurred. Used for period-based financial reporting and accounts receivable aging analysis.',
    `modified_timestamp` TIMESTAMP COMMENT 'System timestamp when the payment allocation record was last modified. Updated whenever any field in the record changes. Used for change tracking and audit trail.',
    `notes` STRING COMMENT 'Free-text notes or comments regarding the payment allocation. Used for documenting special circumstances, manual adjustments, or customer communications.',
    `posting_date` DATE COMMENT 'The date when the allocation was posted to the general ledger. May differ from allocation date due to period-end processing or backdated corrections.',
    `profit_center` STRING COMMENT 'Profit center responsible for this revenue transaction. Used for internal management accounting and profitability analysis.. Valid values are `^[A-Z0-9]{6,10}$`',
    `reconciliation_status` STRING COMMENT 'Status of the allocation in the accounts receivable reconciliation process. Pending indicates awaiting reconciliation, reconciled indicates confirmed and balanced, exception indicates discrepancy requiring investigation, under_review indicates active reconciliation in progress.. Valid values are `pending|reconciled|exception|under_review`',
    `remaining_invoice_balance` DECIMAL(18,2) COMMENT 'The outstanding balance remaining on the invoice after this allocation is applied. Zero indicates full settlement. Used for open item management and accounts receivable aging.',
    `reversal_date` DATE COMMENT 'Date when the allocation was reversed. Null if allocation has not been reversed. Used for audit trail and accounts receivable reconciliation.',
    `reversal_indicator` BOOLEAN COMMENT 'Flag indicating whether this allocation has been reversed. True indicates the allocation was subsequently undone, typically due to payment failure or correction.',
    `reversal_reason_code` STRING COMMENT 'Standardized code indicating the reason for allocation reversal. Examples include payment failure, incorrect allocation, duplicate payment, or customer dispute.. Valid values are `^[A-Z0-9]{2,6}$`',
    `value_date` DATE COMMENT 'The effective date for cash flow and liquidity management. Represents when funds are actually available in the bank account.',
    CONSTRAINT pk_payment_allocation PRIMARY KEY(`payment_allocation_id`)
) COMMENT 'Association record linking a payment to one or more invoice lines, capturing how a single payment is distributed across multiple invoices or partial invoice settlements. Tracks allocated amount per invoice, allocation date, allocation type (full/partial/advance/overpayment), remaining balance after allocation, and clearing status. Enables accurate accounts receivable aging and open item management aligned with SAP FI open item clearing.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`credit_memo` (
    `credit_memo_id` BIGINT COMMENT 'Unique identifier for the credit memo record. Primary key.',
    `aftersales_warranty_claim_id` BIGINT COMMENT 'Reference to the warranty claim that this credit memo is compensating, if applicable.',
    `employee_id` BIGINT COMMENT 'Reference to the employee or manager who approved the credit memo. Supports audit trail and authorization compliance.',
    `party_id` BIGINT COMMENT 'Reference to the customer (dealer, retail customer, or fleet account) receiving the credit memo.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealer receiving the credit memo, if applicable. Used for dealer-specific credits such as volume rebates or vehicle return credits.',
    `credit_dealership_id` BIGINT COMMENT 'Reference to the dealer receiving the credit memo, if applicable. Used for dealer-specific credits such as volume rebates or vehicle return credits.',
    `credit_employee_id` BIGINT COMMENT 'Reference to the employee or manager who approved the credit memo. Supports audit trail and authorization compliance.',
    `credit_party_id` BIGINT COMMENT 'Reference to the customer (dealer, retail customer, or fleet account) receiving the credit memo.',
    `dealer_incentive_program_id` BIGINT COMMENT 'Reference to the dealer incentive program (e.g., volume rebate, promotional allowance) that this credit memo fulfills, if applicable.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Credit memos need a GL account for reversal entries in the ledger.',
    `invoice_id` BIGINT COMMENT 'Reference to the original invoice that this credit memo is reversing or adjusting.',
    `recall_campaign_id` BIGINT COMMENT 'Reference to the recall campaign for which this credit memo provides dealer or customer compensation, if applicable.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Credit memos may be issued for a specific vehicle (e.g., warranty reimbursement); FK links credit adjustments to the vehicle record.',
    `approval_date` DATE COMMENT 'Date when the credit memo was approved by the authorized approver. Distinct lifecycle event from issue and posting.',
    `approver_name` STRING COMMENT 'Full name of the person who approved the credit memo. Provides human-readable audit information.',
    `cancellation_reason` STRING COMMENT 'Reason code or description explaining why the credit memo was cancelled, if status is cancelled.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the credit memo record was first created in the system. Audit trail for record lifecycle.',
    `credit_memo_number` STRING COMMENT 'Externally-known business identifier for the credit memo, typically following format CM followed by 10 digits. Used for customer communication and SAP SD document reference.. Valid values are `^CM[0-9]{10}$`',
    `credit_memo_status` STRING COMMENT 'Current lifecycle status of the credit memo in the approval and posting workflow. [ENUM-REF-CANDIDATE: draft|pending_approval|approved|issued|posted|cancelled|rejected — 7 candidates stripped; promote to reference product]',
    `credit_reason_code` STRING COMMENT 'Categorical code indicating the business reason for issuing the credit memo. Supports financial analysis and dispute resolution tracking. [ENUM-REF-CANDIDATE: return|pricing_error|warranty_adjustment|recall_allowance|volume_rebate|goodwill|service_reversal|parts_return|quality_claim|promotional_allowance — 10 candidates stripped; promote to reference product]',
    `credit_type` STRING COMMENT 'Classification of the credit memo by its financial treatment and business purpose.. Valid values are `full_reversal|partial_adjustment|volume_incentive|warranty_claim|recall_compensation`',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the credit memo transaction (e.g., USD, EUR, JPY).. Valid values are `^[A-Z]{3}$`',
    `dispute_id` BIGINT COMMENT 'Reference to the billing dispute record that triggered this credit memo, if applicable. Links credit to dispute resolution workflow.',
    `distribution_channel` STRING COMMENT 'SAP SD distribution channel through which the original sale and credit were processed (e.g., dealer network, fleet sales, direct retail).',
    `division` STRING COMMENT 'SAP SD division representing the product line or business unit (e.g., passenger vehicles, commercial vehicles, parts, service).',
    `fiscal_period` STRING COMMENT 'Fiscal period (month) within the fiscal year when the credit memo was posted. Supports monthly financial close and reporting.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the credit memo was issued or posted. Used for period-based financial reporting and analysis.',
    `gross_credit_amount` DECIMAL(18,2) COMMENT 'Total credit amount before tax adjustments. Represents the base value being credited to the customer or dealer.',
    `issue_date` DATE COMMENT 'Date when the credit memo was officially issued to the customer or dealer. Principal business event timestamp for this transaction.',
    `model_year` STRING COMMENT 'Model year of the vehicle associated with this credit memo, if applicable. Supports product-line analysis of credits.',
    `modified_by` STRING COMMENT 'Username or employee identifier of the person who last modified the credit memo record.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the credit memo record was last modified. Audit trail for record lifecycle.',
    `net_credit_amount` DECIMAL(18,2) COMMENT 'Total credit amount including tax. This is the final amount credited to the customer or dealer account.',
    `notes` STRING COMMENT 'Free-text notes or comments explaining the credit memo circumstances, approver rationale, or special handling instructions.',
    `payment_terms` STRING COMMENT 'Payment terms code from SAP SD indicating how the credit will be applied (e.g., immediate credit, offset against future invoices).',
    `posting_date` DATE COMMENT 'Date when the credit memo was posted to the financial ledger in SAP FI. Used for period-based financial reporting.',
    `reference_number` STRING COMMENT 'External reference number provided by the customer or dealer for their internal tracking (e.g., dealer claim number, customer case number).',
    `rejection_reason` STRING COMMENT 'Reason code or description explaining why the credit memo was rejected during approval workflow, if status is rejected.',
    `sales_organization` STRING COMMENT 'SAP SD sales organization responsible for the credit memo. Supports regional and organizational reporting.',
    `sap_accounting_document` STRING COMMENT 'SAP FI accounting document number generated when the credit memo was posted to the general ledger.',
    `sap_billing_document` STRING COMMENT 'SAP SD billing document number associated with this credit memo. Used for cross-reference to billing cycles.',
    `sap_credit_memo_document` STRING COMMENT 'SAP SD credit memo document number. Links this record to the source system of record for reconciliation and traceability.',
    `tax_credit_amount` DECIMAL(18,2) COMMENT 'Tax portion of the credit memo. Reverses or adjusts the tax charged on the original invoice.',
    `vehicle_model` STRING COMMENT 'Model name or code of the vehicle associated with this credit memo, if applicable.',
    `created_by` STRING COMMENT 'Username or employee identifier of the person who created the credit memo record in the system.',
    CONSTRAINT pk_credit_memo PRIMARY KEY(`credit_memo_id`)
) COMMENT 'Formal credit note issued to a dealer, retail customer, or fleet account to reverse or reduce a previously issued invoice charge. Captures credit memo number, originating invoice reference, credit reason code (return/pricing_error/warranty_adjustment/recall_allowance/volume_rebate/goodwill), credit amount, tax credit amount, issue date, approval status, approver, and SAP SD credit memo document reference. Supports dealer volume rebates, vehicle return credits, and service charge reversals.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`debit_memo` (
    `debit_memo_id` BIGINT COMMENT 'Unique identifier for the debit memo record. Primary key.',
    `account_id` BIGINT COMMENT 'Foreign key linking to billing.billing_account. Business justification: Debit memos adjust balances on a specific customer billing account; essential for accurate account reconciliation.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealer or account being debited. Primary counterparty for this debit memo.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Debit memos require a GL account to record additional charges.',
    `invoice_id` BIGINT COMMENT 'Reference to the original invoice that this debit memo adjusts or supplements. Links to the invoice product.',
    `primary_debit_dealership_id` BIGINT COMMENT 'Reference to the dealer or account being debited. Primary counterparty for this debit memo.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Debit memos for parts or service are vehicle‑specific; FK enables accurate cost allocation and audit trails.',
    `approval_status` STRING COMMENT 'Current approval workflow status of the debit memo. DRAFT indicates initial creation, PENDING_APPROVAL indicates awaiting finance approval, APPROVED indicates ready for posting, REJECTED indicates declined by approver, CANCELLED indicates voided before posting.. Valid values are `DRAFT|PENDING_APPROVAL|APPROVED|REJECTED|CANCELLED`',
    `approved_by` STRING COMMENT 'User ID or name of the person who approved the debit memo for posting. Null if not yet approved or approval not required.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the debit memo was approved. Null if not yet approved.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity issuing the debit memo. Used for multi-entity financial consolidation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the debit memo record was first created in the system. Audit trail field.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this debit memo (e.g., USD, EUR, JPY).. Valid values are `^[A-Z]{3}$`',
    `debit_amount` DECIMAL(18,2) COMMENT 'Gross amount being debited to the dealer or account before tax. Represents the base charge amount.',
    `debit_memo_number` STRING COMMENT 'Externally-known business identifier for the debit memo, typically following a format like DM followed by 10 digits. Used for communication with dealers and in financial documents.. Valid values are `^DM[0-9]{10}$`',
    `debit_reason_code` STRING COMMENT 'Categorical code indicating the business reason for issuing the debit memo. Common values include FREIGHT (freight adjustments), PDI (Pre-Delivery Inspection charges), HOMOLOGATION (regulatory certification fees), PRICE_CORRECTION (price adjustments post-invoice), TOOLING (special tooling charges), ACCESSORY (additional accessory charges), LATE_FEE (late payment penalties), OTHER (miscellaneous charges). [ENUM-REF-CANDIDATE: FREIGHT|PDI|HOMOLOGATION|PRICE_CORRECTION|TOOLING|ACCESSORY|LATE_FEE|OTHER — 8 candidates stripped; promote to reference product]',
    `debit_reason_description` STRING COMMENT 'Detailed textual explanation of why the debit memo was issued. Provides context beyond the reason code.',
    `dispute_date` DATE COMMENT 'Date when the dealer formally disputed the debit memo. Null if never disputed.',
    `dispute_flag` BOOLEAN COMMENT 'Boolean indicator whether the dealer has disputed this debit memo. True if disputed, False otherwise.',
    `dispute_reason` STRING COMMENT 'Textual explanation provided by the dealer for disputing the debit memo. Null if not disputed.',
    `distribution_channel` STRING COMMENT 'SAP SD distribution channel through which the debit memo was issued (e.g., dealer network, fleet sales, direct sales).',
    `division` STRING COMMENT 'SAP SD division or product line associated with the debit memo (e.g., passenger vehicles, commercial vehicles, parts).',
    `due_date` DATE COMMENT 'Date by which the dealer is expected to settle the debit memo amount. Calculated based on payment terms.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month) within the fiscal year when the debit memo was issued. Typically 1-12.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the debit memo was issued, based on the companys fiscal calendar.',
    `issue_date` DATE COMMENT 'Date when the debit memo was officially issued to the dealer. Represents the business event date for accounting and aging purposes.',
    `modified_by` STRING COMMENT 'User ID or name of the person who last modified the debit memo record.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the debit memo record was last modified. Audit trail field for change tracking.',
    `notes` STRING COMMENT 'Free-form internal notes or comments about the debit memo for operational reference. Not shared with dealer.',
    `payment_date` DATE COMMENT 'Date when the debit memo was fully paid or cleared by the dealer. Null if still unpaid.',
    `payment_status` STRING COMMENT 'Current payment settlement status of the debit memo. Tracks whether the dealer has paid the debited amount.. Valid values are `UNPAID|PARTIALLY_PAID|PAID|DISPUTED|WRITTEN_OFF`',
    `posting_date` DATE COMMENT 'Date when the debit memo was posted to the financial ledger in SAP FI. May differ from issue_date due to batch processing.',
    `reference_document_number` STRING COMMENT 'External reference document number such as a purchase order, delivery note, or contract number that provides additional context for the debit memo.',
    `resolution_date` DATE COMMENT 'Date when a disputed debit memo was resolved (either upheld, adjusted, or cancelled). Null if dispute is still open or never disputed.',
    `resolution_notes` STRING COMMENT 'Notes documenting how the dispute was resolved, including any adjustments or corrective actions taken.',
    `sales_organization` STRING COMMENT 'SAP SD sales organization responsible for the debit memo. Represents the selling unit or region.',
    `sap_fi_document_number` STRING COMMENT 'SAP FI accounting document number generated when the debit memo was posted to the general ledger.',
    `sap_sd_document_number` STRING COMMENT 'SAP SD billing document number for the debit memo. System-of-record reference for integration and reconciliation.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount applied to the debit memo. Includes sales tax, VAT, GST, or other applicable taxes based on jurisdiction.',
    `total_debit_amount` DECIMAL(18,2) COMMENT 'Total amount of the debit memo including tax. Sum of debit_amount and tax_amount. This is the net amount charged to the dealer.',
    `created_by` STRING COMMENT 'User ID or name of the person who created the debit memo record in the system.',
    CONSTRAINT pk_debit_memo PRIMARY KEY(`debit_memo_id`)
) COMMENT 'Formal debit note issued to a dealer or account to charge additional amounts not captured in the original invoice, such as freight adjustments, PDI (Pre-Delivery Inspection) charges, homologation fees, or price corrections. Captures debit memo number, originating invoice reference, debit reason code, charge amount, tax amount, issue date, approval status, and SAP SD debit memo document reference. Complements credit_memo for bilateral billing adjustments.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`account` (
    `account_id` BIGINT COMMENT 'Unique identifier for the billing account. Primary key.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Assigns a default cost center to the billing account for expense allocation.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Default GL account for all transactions posted from a billing account for consistent accounting.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Financial reporting requires mapping each billing account to a jurisdiction for tax and regulatory compliance.',
    `parent_account_id` BIGINT COMMENT 'Reference to the parent billing account for hierarchical account structures. Used for corporate accounts with multiple subsidiaries or dealer groups with multiple locations. Null for standalone accounts.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Account Management Report requires linking each billing account to its owning customer party for credit limits, statements, and compliance.',
    `account_number` STRING COMMENT 'Externally-visible unique account number assigned to the billing party. Used on invoices, statements, and payment correspondence. Typically alphanumeric format following internal numbering scheme.. Valid values are `^[A-Z0-9]{8,20}$`',
    `account_status` STRING COMMENT 'Current lifecycle status of the billing account. Active accounts can transact normally. Suspended accounts have temporary restrictions. Closed accounts are permanently terminated. Pending approval accounts await credit review. Blocked accounts cannot transact due to payment issues. Dormant accounts have no recent activity.. Valid values are `active|suspended|closed|pending_approval|blocked|dormant`',
    `account_type` STRING COMMENT 'Classification of the billing account based on the nature of the billing party. Dealer accounts are for franchise dealerships, retail for individual consumers, fleet for commercial fleet operators, corporate for B2B accounts, government for public sector entities, and export for international distributors.. Valid values are `dealer|retail|fleet|corporate|government|export`',
    `auto_pay_enrolled_flag` BOOLEAN COMMENT 'Indicates whether the account is enrolled in automatic payment processing. True when account has authorized automatic ACH, direct debit, or credit card charges for recurring invoices.',
    `billing_address_line1` STRING COMMENT 'Primary street address line for billing correspondence and invoice delivery. First line of the billing partys registered address.',
    `billing_address_line2` STRING COMMENT 'Secondary address line for suite, apartment, building, or additional location details for billing correspondence.',
    `billing_city` STRING COMMENT 'City or municipality name for the billing address.',
    `billing_contact_email` STRING COMMENT 'Email address of the primary billing contact person. Used for invoice inquiries, payment confirmations, and account correspondence.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `billing_contact_name` STRING COMMENT 'Name of the primary billing contact person at the billing party organization. Accounts payable manager, controller, or designated billing representative.',
    `billing_contact_phone` STRING COMMENT 'Primary phone number for the billing contact. Used for payment inquiries, dispute resolution, and collections communication.',
    `billing_country_code` STRING COMMENT 'Three-letter ISO country code for the billing address country (e.g., USA, CAN, MEX, DEU, CHN, JPN).. Valid values are `^[A-Z]{3}$`',
    `billing_postal_code` STRING COMMENT 'Postal or ZIP code for the billing address. Format varies by country.',
    `billing_state_province` STRING COMMENT 'State, province, or regional administrative division for the billing address. Format varies by country (e.g., two-letter US state codes, Canadian province codes).',
    `closed_date` DATE COMMENT 'Date when the billing account was permanently closed. Null for active, suspended, or dormant accounts. Set when account status transitions to closed after final settlement.',
    `consolidated_billing_flag` BOOLEAN COMMENT 'Indicates whether this account receives consolidated invoices combining multiple transactions or sub-accounts into a single statement. Common for fleet and corporate accounts with multiple locations or cost centers.',
    `credit_check_date` DATE COMMENT 'Date of the most recent credit review or credit check performed for this account. Credit reviews are typically performed at account opening, annually, or when credit limit increase is requested.',
    `credit_exposure_amount` DECIMAL(18,2) COMMENT 'Current total outstanding receivables balance for this account, including open invoices and unbilled charges. Updated in near-real-time as transactions post. Compared against credit limit for credit control decisions.',
    `credit_limit_amount` DECIMAL(18,2) COMMENT 'Maximum outstanding receivables balance allowed for this account before credit hold is triggered. Expressed in the accounts base currency. Set by credit management based on creditworthiness assessment.',
    `credit_rating_code` STRING COMMENT 'Internal or external credit rating assigned to the billing party. AAA is highest creditworthiness, D is default, NR is not rated. Used for credit limit determination and risk management. [ENUM-REF-CANDIDATE: AAA|AA|A|BBB|BB|B|CCC|CC|C|D|NR — 11 candidates stripped; promote to reference product]',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the accounts base transactional currency (e.g., USD, EUR, CAD, MXN, CNY, JPY). All invoices and payments for this account are denominated in this currency unless explicitly converted.. Valid values are `^[A-Z]{3}$`',
    `dispute_count_ytd` STRING COMMENT 'Number of billing disputes or invoice challenges raised by this account in the current fiscal year. Used to identify problematic accounts and improve billing accuracy.',
    `distribution_channel_code` STRING COMMENT 'SAP distribution channel code indicating how products reach this account (e.g., direct sales, dealer network, fleet sales, export). Affects pricing and terms determination.. Valid values are `^[A-Z0-9]{2}$`',
    `division_code` STRING COMMENT 'SAP division code representing the product line or business unit (e.g., passenger vehicles, commercial vehicles, parts, service). Used for revenue segmentation and reporting.. Valid values are `^[A-Z0-9]{2}$`',
    `dms_account_code` STRING COMMENT 'External account identifier from the dealer management system (CDK Global DMS) for dealer accounts. Used to link billing account to dealer inventory, service, and F&I transactions. Null for non-dealer account types.',
    `dunning_block_flag` BOOLEAN COMMENT 'Indicates whether automated dunning (collections) notices are blocked for this account. True when account is in dispute resolution, payment plan, or has special handling requirements.',
    `dunning_level` STRING COMMENT 'Current dunning (collections) level for overdue accounts. Ranges from 0 (no overdue) to higher numbers indicating escalating collection actions. Drives automated dunning letter generation and collection workflow.',
    `invoice_delivery_method` STRING COMMENT 'Preferred method for delivering invoices and statements to the billing party. Email for electronic delivery, postal mail for paper, EDI for automated B2B integration, portal for self-service access, fax for legacy systems.. Valid values are `email|postal_mail|edi|portal|fax`',
    `invoice_email_address` STRING COMMENT 'Primary email address for electronic invoice and statement delivery. Used when invoice delivery method is email or as backup contact for portal notifications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `last_invoice_date` DATE COMMENT 'Date of the most recent invoice issued to this account. Used to identify dormant accounts and track billing activity patterns.',
    `last_payment_amount` DECIMAL(18,2) COMMENT 'Amount of the most recent payment received from this account in the accounts base currency. Used for payment pattern analysis and collections strategy.',
    `last_payment_date` DATE COMMENT 'Date of the most recent payment received from this account. Used for credit assessment, collections prioritization, and customer relationship management.',
    `account_name` STRING COMMENT 'Legal or registered name of the billing party. For dealers, this is the dealership legal entity name. For retail customers, the individual or household name. For fleet/corporate, the company legal name.',
    `opened_date` DATE COMMENT 'Date when the billing account was first established and activated. Marks the beginning of the financial relationship.',
    `payment_method_preference` STRING COMMENT 'Preferred payment method for this account. Wire transfer and ACH for electronic payments, check for paper payments, credit card for retail, direct debit for recurring charges, letter of credit for export accounts.. Valid values are `wire_transfer|ach|check|credit_card|direct_debit|letter_of_credit`',
    `payment_performance_score` DECIMAL(18,2) COMMENT 'Calculated score (0-100) representing the accounts payment timeliness and reliability. Based on historical payment patterns, days sales outstanding, and dispute frequency. Higher scores indicate better payment performance.',
    `payment_terms_code` STRING COMMENT 'Standard payment terms code defining the due date calculation and discount conditions (e.g., NET30, NET60, 2/10NET30). Maps to SAP FI payment terms master data.. Valid values are `^[A-Z0-9]{2,10}$`',
    `payment_terms_days` STRING COMMENT 'Number of days from invoice date until payment is due. Derived from payment terms code but stored for reporting convenience.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this billing account record was first created in the data platform. System-generated audit field.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this billing account record was last modified in the data platform. System-generated audit field updated on every change.',
    `sales_organization_code` STRING COMMENT 'SAP sales organization code responsible for this billing account. Defines the organizational unit for sales and distribution processes, pricing, and revenue recognition.. Valid values are `^[A-Z0-9]{4}$`',
    `sap_customer_number` STRING COMMENT 'SAP FI customer account number (KUNNR) in the ERP system. Ten-digit numeric identifier used for financial postings, invoice generation, and payment application. Primary system of record reference.. Valid values are `^[0-9]{10}$`',
    `tax_registration_number` STRING COMMENT 'Government-issued tax identification number for the billing party. Format varies by jurisdiction (e.g., EIN in USA, GST number in Canada, RFC in Mexico, VAT number in EU). Used for tax reporting and compliance.',
    `vat_number` STRING COMMENT 'VAT registration identifier for EU and other VAT jurisdictions. Required for cross-border invoicing and VAT reclaim. Format follows country-specific VAT ID structure.',
    CONSTRAINT pk_account PRIMARY KEY(`account_id`)
) COMMENT 'Billing account master record representing the financial relationship between Automotive and a billing party (dealer, retail customer, fleet operator, or corporate account). Captures account number, account type (dealer/retail/fleet/corporate/government), account name, billing address, payment terms, credit limit, credit exposure, currency, tax registration number, VAT ID, account status (active/suspended/closed), assigned credit controller, SAP FI customer account reference, and DMS account linkage for dealer accounts. Distinct from the customer identity record owned by the customer domain.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`receivable` (
    `receivable_id` BIGINT COMMENT 'Unique identifier for the accounts receivable item. Primary key for the receivable product. Represents a single open item in the AR ledger.',
    `account_id` BIGINT COMMENT 'Reference to the billing account (dealer, retail customer, or fleet account) that owes this receivable. Represents the debtor party.',
    `invoice_id` BIGINT COMMENT 'Reference to the source invoice that generated this receivable. Links to the originating billing document in SAP SD/FI.',
    `payment_plan_id` BIGINT COMMENT 'Reference to the active payment plan agreement if payment_plan_flag is true. Links to payment plan schedule and terms.',
    `employee_id` BIGINT COMMENT 'Reference to the collections agent or team assigned to pursue this receivable. Used for workload distribution and performance tracking.',
    `receivable_employee_id` BIGINT COMMENT 'Reference to the collections agent or team assigned to pursue this receivable. Used for workload distribution and performance tracking.',
    `aging_bucket` STRING COMMENT 'Standard aging classification bucket based on days past due. Used for AR aging reports, bad debt provisioning, and collections prioritization.. Valid values are `current|1_30_days|31_60_days|61_90_days|91_120_days|over_120_days`',
    `closed_date` DATE COMMENT 'Date the receivable was fully closed (paid, written off, or otherwise resolved). Null for open receivables. Used for DSO calculation and historical analysis.',
    `collection_status` STRING COMMENT 'Current status of collection efforts for overdue receivables. Tracks progression through collections workflow from initial contact to legal action. [ENUM-REF-CANDIDATE: not_started|in_progress|on_hold|escalated|legal|resolved|abandoned — 7 candidates stripped; promote to reference product]',
    `cost_center` STRING COMMENT 'Cost center responsible for the revenue transaction that generated this receivable. Used for profitability analysis and management reporting.. Valid values are `^[A-Z0-9]{6,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this receivable record was first created in the system. Audit trail for data lineage and compliance.',
    `credit_hold_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the debtor account is on credit hold due to this or other overdue receivables. Credit hold blocks new orders and shipments.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the receivable amounts. Supports multi-currency operations across global dealer networks and export markets.. Valid values are `^[A-Z]{3}$`',
    `customer_type` STRING COMMENT 'Segment classification of the debtor. Distinguishes dealer network, retail consumers, fleet operators, government entities, rental companies, and leasing firms.. Valid values are `dealer|retail|fleet|government|rental|leasing`',
    `days_past_due` STRING COMMENT 'Number of calendar days the receivable is overdue. Calculated as current date minus due date for unpaid balances. Zero or negative for current receivables.',
    `dealer_code` STRING COMMENT 'Dealer code if the receivable is from a dealer network transaction. Links to dealer master data for dealer-specific AR aging and floor plan management.. Valid values are `^[A-Z0-9]{5,10}$`',
    `dispute_date` DATE COMMENT 'Date the dispute was raised by the debtor. Used to track dispute aging and resolution SLA compliance.',
    `dispute_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the receivable is currently under dispute by the debtor. Disputed receivables are excluded from dunning and may be placed on payment hold.',
    `dispute_reason` STRING COMMENT 'Reason code for the dispute if dispute_flag is true. Categorizes the nature of the customer objection for resolution tracking. [ENUM-REF-CANDIDATE: pricing_error|quantity_discrepancy|quality_issue|delivery_problem|warranty_claim|incentive_disagreement|billing_error|not_disputed — 8 candidates stripped; promote to reference product]',
    `dispute_reference` STRING COMMENT 'External reference number for the dispute case. Links to dispute resolution system or customer service ticket.',
    `due_date` DATE COMMENT 'Contractual date by which payment is expected. Calculated from invoice date plus payment terms. Used to determine days past due and aging bucket.',
    `dunning_level` STRING COMMENT 'Current dunning escalation level for overdue receivables. Increments with each dunning run. Zero indicates no dunning action taken.',
    `gl_account_code` STRING COMMENT 'General ledger account code where this receivable is posted. Typically an AR control account in the balance sheet.. Valid values are `^[0-9]{6,10}$`',
    `invoice_date` DATE COMMENT 'Date the originating invoice was issued. Represents the business event timestamp when the receivable was created.',
    `last_contact_date` DATE COMMENT 'Date of the most recent contact attempt with the debtor regarding this receivable. Includes phone calls, emails, and letters.',
    `last_dunning_date` DATE COMMENT 'Date the most recent dunning notice was sent to the debtor. Used to calculate next dunning run eligibility and escalation timing.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this receivable record. Tracks changes to balance, status, or dispute information.',
    `next_dunning_date` DATE COMMENT 'Calculated date for the next dunning notice. Based on dunning frequency configuration and last dunning date.',
    `original_amount` DECIMAL(18,2) COMMENT 'Original gross amount of the receivable at invoice creation. Represents the initial debt obligation before any payments or adjustments.',
    `outstanding_balance` DECIMAL(18,2) COMMENT 'Current unpaid balance remaining on the receivable. Calculated as original amount minus payments, credits, and adjustments. SSOT for AR aging reports.',
    `payment_plan_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the debtor is on an approved payment plan for this receivable. Payment plan receivables follow modified dunning rules.',
    `payment_terms` STRING COMMENT 'Contractual payment terms governing the receivable. Defines the number of days until payment is due and any early payment discounts. [ENUM-REF-CANDIDATE: net_30|net_45|net_60|net_90|due_on_receipt|2_10_net_30|custom — 7 candidates stripped; promote to reference product]',
    `profit_center` STRING COMMENT 'Profit center for internal P&L reporting. Represents the business unit or product line that earned this revenue.. Valid values are `^[A-Z0-9]{6,10}$`',
    `receivable_number` STRING COMMENT 'Business-facing document number for the receivable item. Externally visible identifier used in collections correspondence and dunning letters.. Valid values are `^[A-Z]{2,3}-[0-9]{8,12}$`',
    `receivable_status` STRING COMMENT 'Current lifecycle state of the receivable. Tracks progression from open through payment, dispute, collections, or write-off. [ENUM-REF-CANDIDATE: open|partially_paid|paid|disputed|written_off|under_collection|legal_action — 7 candidates stripped; promote to reference product]',
    `receivable_type` STRING COMMENT 'Classification of the receivable by business transaction type. Distinguishes vehicle sales, parts, service, warranty, fleet, incentive recovery, and finance charges. [ENUM-REF-CANDIDATE: vehicle_sale|parts_sale|service_charge|warranty_reimbursement|fleet_invoice|incentive_recovery|finance_charge — 7 candidates stripped; promote to reference product]',
    `sales_region` STRING COMMENT 'Geographic sales region where the transaction occurred. Used for regional revenue and collections performance analysis.',
    `sap_fi_company_code` STRING COMMENT 'SAP company code representing the legal entity that owns this receivable. Used for multi-entity consolidation and statutory reporting.. Valid values are `^[A-Z0-9]{4}$`',
    `sap_fi_document_number` STRING COMMENT 'SAP FI accounting document number for the open item. SSOT reference for reconciliation with SAP general ledger and subledger.. Valid values are `^[0-9]{10}$`',
    `vin` STRING COMMENT '17-character VIN if the receivable is related to a specific vehicle sale. Links to vehicle master data for vehicle-level revenue tracking.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `write_off_amount` DECIMAL(18,2) COMMENT 'Amount written off as bad debt. May differ from outstanding balance if partial recovery was achieved before write-off.',
    `write_off_date` DATE COMMENT 'Date the receivable was written off. Represents the accounting period when the bad debt expense was recognized.',
    `write_off_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the receivable has been written off as uncollectible bad debt. Written-off receivables are removed from active AR aging.',
    `write_off_reason` STRING COMMENT 'Reason code for the write-off decision. Documents the business justification for recognizing bad debt expense. [ENUM-REF-CANDIDATE: bankruptcy|insolvency|uncollectible|customer_closure|legal_settlement|small_balance|other — 7 candidates stripped; promote to reference product]',
    CONSTRAINT pk_receivable PRIMARY KEY(`receivable_id`)
) COMMENT 'Open accounts receivable item representing an outstanding amount owed by a billing account against a specific invoice. Tracks original invoice amount, outstanding balance, due date, days past due, aging bucket (current/30/60/90/120+), dunning level, last dunning date, dispute flag, dispute reference, write-off flag, and SAP FI open item reference. SSOT for AR aging and collections management across dealer, retail, and fleet receivables.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`dispute` (
    `dispute_id` BIGINT COMMENT 'Unique identifier for the billing dispute record. Primary key.',
    `account_id` BIGINT COMMENT 'Foreign key linking to billing.billing_account. Business justification: Dispute management tracks which billing account a dispute concerns, required for account‑level dispute reporting.',
    `credit_memo_id` BIGINT COMMENT 'Reference to the credit memo issued as a result of the dispute resolution, if applicable. Null if no credit was issued.',
    `employee_id` BIGINT COMMENT 'Reference to the dispute analyst or customer service representative assigned to investigate and resolve the dispute.',
    `dispute_employee_id` BIGINT COMMENT 'Reference to the dispute analyst or customer service representative assigned to investigate and resolve the dispute.',
    `party_id` BIGINT COMMENT 'Reference to the customer, dealer, or fleet operator who raised the dispute. Links to the appropriate master data entity based on disputing_party_type.',
    `invoice_id` BIGINT COMMENT 'Reference to the invoice being disputed. Links to the billing invoice record in the billing domain.',
    `business_unit` STRING COMMENT 'The business unit or division responsible for the disputed invoice (e.g., Parts, Service, Vehicle Sales, Fleet).',
    `closed_date` DATE COMMENT 'The date when the dispute was formally closed in the system after resolution and all follow-up actions completed.',
    `contact_email` STRING COMMENT 'Email address of the primary contact person at the disputing party for correspondence regarding this dispute.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `contact_phone` STRING COMMENT 'Phone number of the primary contact person at the disputing party for verbal communication regarding this dispute.. Valid values are `^+?[0-9]{1,4}?[-.s]?(?[0-9]{1,3}?)?[-.s]?[0-9]{1,4}[-.s]?[0-9]{1,4}[-.s]?[0-9]{1,9}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this dispute record was first created in the system, in ISO 8601 format.',
    `credited_amount` DECIMAL(18,2) COMMENT 'The actual monetary amount credited back to the disputing party as a result of the resolution. May be less than, equal to, or zero relative to disputed_amount.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the disputed amount (e.g., USD, EUR, JPY).. Valid values are `^[A-Z]{3}$`',
    `dispute_number` STRING COMMENT 'Externally-known business identifier for the dispute, formatted as DSP- followed by 10 digits. Used in customer and dealer communications.. Valid values are `^DSP-[0-9]{10}$`',
    `dispute_status` STRING COMMENT 'Current lifecycle status of the dispute: open (newly raised), under_review (being investigated), resolved (solution agreed), escalated (sent to higher authority), closed (finalized), withdrawn (cancelled by disputing party).. Valid values are `open|under_review|resolved|escalated|closed|withdrawn`',
    `dispute_type` STRING COMMENT 'Classification of the dispute reason: pricing (incorrect price applied), quantity (billed quantity mismatch), quality (defective parts or service), duplicate (duplicate billing), unauthorized_charge (charge not authorized), warranty (warranty coverage dispute).. Valid values are `pricing|quantity|quality|duplicate|unauthorized_charge|warranty`',
    `disputed_amount` DECIMAL(18,2) COMMENT 'The monetary value being contested by the disputing party, in the invoice currency.',
    `disputing_party_type` STRING COMMENT 'Classification of the entity raising the dispute: dealer (authorized dealer), fleet_operator (commercial fleet customer), retail_customer (individual buyer), internal (internal business unit).. Valid values are `dealer|fleet_operator|retail_customer|internal`',
    `escalation_date` DATE COMMENT 'The date when the dispute was escalated to a higher authority level. Null if never escalated.',
    `escalation_level` STRING COMMENT 'The current escalation tier of the dispute: 0 (no escalation), 1 (supervisor review), 2 (manager review), 3 (director review), 4 (executive review).',
    `escalation_reason` STRING COMMENT 'Explanation of why the dispute required escalation beyond the initial analyst level.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this dispute record was last updated in the system, in ISO 8601 format.',
    `open_date` DATE COMMENT 'The date when the dispute was formally raised and entered into the system.',
    `priority` STRING COMMENT 'Business priority assigned to the dispute based on amount, customer tier, and business impact: low, medium, high, critical.. Valid values are `low|medium|high|critical`',
    `reason_description` STRING COMMENT 'Detailed free-text explanation provided by the disputing party describing the reason for the dispute and supporting details.',
    `received_timestamp` TIMESTAMP COMMENT 'Precise date and time when the dispute was received by the billing department, in ISO 8601 format.',
    `region_code` STRING COMMENT 'Three-letter geographic region code where the disputing party is located (e.g., USA, EUR, CHN).. Valid values are `^[A-Z]{3}$`',
    `resolution_date` DATE COMMENT 'The date when the dispute was resolved and a final decision was communicated to the disputing party.',
    `resolution_notes` STRING COMMENT 'Detailed explanation of the resolution decision, actions taken, and justification for the outcome.',
    `resolution_type` STRING COMMENT 'The outcome classification of the dispute resolution: accepted (dispute valid, full credit issued), rejected (dispute invalid, no action), partial_credit (compromise reached), adjustment (invoice corrected), waiver (charge waived as goodwill).. Valid values are `accepted|rejected|partial_credit|adjustment|waiver`',
    `root_cause_category` STRING COMMENT 'Classification of the underlying cause identified during dispute investigation: billing_error, system_error, data_entry_error, policy_misunderstanding, delivery_issue, quality_issue.. Valid values are `billing_error|system_error|data_entry_error|policy_misunderstanding|delivery_issue|quality_issue`',
    `sla_breach_flag` BOOLEAN COMMENT 'Indicates whether the dispute resolution exceeded the SLA target resolution time. True if breached, False if within SLA.',
    `sla_target_resolution_days` STRING COMMENT 'The number of business days within which the dispute should be resolved according to the applicable SLA policy.',
    `supporting_document_count` STRING COMMENT 'The number of supporting documents (invoices, delivery notes, quality reports, photos) attached to the dispute case.',
    CONSTRAINT pk_dispute PRIMARY KEY(`dispute_id`)
) COMMENT 'Formal dispute record raised by a dealer, fleet operator, or retail customer contesting an invoice charge, credit memo, or payment application. Captures dispute number, dispute type (pricing/quantity/quality/duplicate/unauthorized_charge/warranty), disputed invoice reference, disputed amount, dispute open date, dispute status (open/under_review/resolved/escalated/closed), resolution type (accepted/rejected/partial_credit), resolution date, resolution notes, assigned dispute analyst, and escalation history. Supports SAP FI dispute management integration.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` (
    `dealer_statement_id` BIGINT COMMENT 'Unique identifier for the dealer statement record. Primary key.',
    `account_id` BIGINT COMMENT 'Foreign key linking to billing.account. Business justification: Dealer statements are issued per dealer account; linking to the master account removes the redundant dealer_account_number column.',
    `employee_id` BIGINT COMMENT 'Identifier of the user or system process that issued this statement.',
    `dealer_issued_by_user_employee_id` BIGINT COMMENT 'Identifier of the user or system process that issued this statement.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership receiving this statement.',
    `aging_bucket_30_days_amount` DECIMAL(18,2) COMMENT 'Portion of the closing balance that is 1-30 days past due.',
    `aging_bucket_60_days_amount` DECIMAL(18,2) COMMENT 'Portion of the closing balance that is 31-60 days past due.',
    `aging_bucket_90_days_amount` DECIMAL(18,2) COMMENT 'Portion of the closing balance that is 61-90 days past due.',
    `aging_bucket_current_amount` DECIMAL(18,2) COMMENT 'Portion of the closing balance that is current and not yet past due.',
    `aging_bucket_over_90_days_amount` DECIMAL(18,2) COMMENT 'Portion of the closing balance that is more than 90 days past due.',
    `billing_cycle_code` STRING COMMENT 'Code identifying the billing cycle or schedule under which this statement was generated.. Valid values are `^[A-Z0-9]{2,10}$`',
    `cdk_statement_reference` STRING COMMENT 'External reference identifier from CDK Global DMS linking this statement to the dealer management system record.',
    `closing_balance_amount` DECIMAL(18,2) COMMENT 'The outstanding balance at the end of the statement period, calculated as opening balance plus charges minus credits and payments.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity issuing this statement.. Valid values are `^[A-Z0-9]{4}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this dealer statement record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts on this statement.. Valid values are `^[A-Z]{3}$`',
    `dispute_amount` DECIMAL(18,2) COMMENT 'The monetary amount under dispute by the dealer, if any.',
    `dispute_flag` BOOLEAN COMMENT 'Indicates whether the dealer has raised a dispute or discrepancy regarding this statement.',
    `dispute_reason_code` STRING COMMENT 'Code representing the reason for the dispute, such as pricing error, quantity discrepancy, or missing credit.. Valid values are `^[A-Z0-9]{2,10}$`',
    `distribution_channel_code` STRING COMMENT 'SAP distribution channel code indicating the route to market for this statement.. Valid values are `^[A-Z0-9]{2}$`',
    `fiscal_period` STRING COMMENT 'The fiscal period (month or quarter) within the fiscal year for this statement.. Valid values are `^[0-9]{2}$`',
    `fiscal_year` STRING COMMENT 'The fiscal year in which this statement period falls, used for financial reporting and period alignment.. Valid values are `^[0-9]{4}$`',
    `floorplan_financing_flag` BOOLEAN COMMENT 'Indicates whether this statement includes floorplan financing charges or is relevant for floorplan reporting.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this dealer statement record was last updated.',
    `opening_balance_amount` DECIMAL(18,2) COMMENT 'The outstanding balance carried forward from the previous statement period.',
    `payment_due_date` DATE COMMENT 'The date by which the dealer is expected to remit payment for the closing balance.',
    `payment_terms_code` STRING COMMENT 'Code representing the payment terms applicable to this statement, such as net 30, net 60, or custom terms.. Valid values are `^[A-Z0-9]{2,10}$`',
    `reconciliation_date` DATE COMMENT 'The date on which the dealer acknowledged and reconciled this statement with their own records.',
    `sales_organization_code` STRING COMMENT 'SAP sales organization code responsible for this dealer statement.. Valid values are `^[A-Z0-9]{4}$`',
    `statement_date` DATE COMMENT 'The date on which the statement was generated and issued to the dealer.',
    `statement_notes` STRING COMMENT 'Free-text field for additional notes, comments, or instructions related to this statement.',
    `statement_number` STRING COMMENT 'Unique business identifier for the dealer statement, externally visible and used for dealer reconciliation and reference.. Valid values are `^[A-Z0-9]{8,20}$`',
    `statement_period_end_date` DATE COMMENT 'The last date of the billing period covered by this statement.',
    `statement_period_start_date` DATE COMMENT 'The first date of the billing period covered by this statement.',
    `statement_status` STRING COMMENT 'Current lifecycle status of the dealer statement indicating its processing stage.. Valid values are `draft|issued|acknowledged|disputed|reconciled|closed`',
    `statement_type` STRING COMMENT 'Classification of the statement based on its frequency or purpose.. Valid values are `monthly|quarterly|ad_hoc|final|interim`',
    `total_adjustment_amount` DECIMAL(18,2) COMMENT 'Sum of all manual adjustments applied to the dealer account during the statement period, including corrections and write-offs.',
    `total_credit_memo_amount` DECIMAL(18,2) COMMENT 'Sum of all credit memos issued to the dealer during the statement period, reducing the amount owed.',
    `total_debit_memo_amount` DECIMAL(18,2) COMMENT 'Sum of all debit memos issued to the dealer during the statement period, increasing the amount owed.',
    `total_incentive_amount` DECIMAL(18,2) COMMENT 'Sum of all dealer incentives, rebates, and promotional credits applied during the statement period.',
    `total_invoice_amount` DECIMAL(18,2) COMMENT 'Sum of all invoices issued to the dealer during the statement period.',
    `total_parts_sales_amount` DECIMAL(18,2) COMMENT 'Sum of all parts sales invoices included in this statement period.',
    `total_payment_received_amount` DECIMAL(18,2) COMMENT 'Sum of all payments received from the dealer during the statement period.',
    `total_service_charges_amount` DECIMAL(18,2) COMMENT 'Sum of all service and labor charges included in this statement period.',
    `total_vehicle_sales_amount` DECIMAL(18,2) COMMENT 'Sum of all vehicle sales invoices included in this statement period.',
    `total_warranty_reimbursement_amount` DECIMAL(18,2) COMMENT 'Sum of all warranty claim reimbursements credited to the dealer during the statement period.',
    CONSTRAINT pk_dealer_statement PRIMARY KEY(`dealer_statement_id`)
) COMMENT 'Periodic account statement issued to a dealer summarizing all invoices, credit memos, debit memos, payments, and open balances within a statement period. Captures statement number, dealer account reference, statement period start/end dates, opening balance, total charges, total credits, total payments received, closing balance, statement status (draft/issued/acknowledged), and CDK Global DMS statement reference. Supports dealer reconciliation and floorplan financing reporting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` (
    `fleet_statement_id` BIGINT COMMENT 'Unique identifier for the fleet billing statement. Primary key.',
    `account_id` BIGINT COMMENT 'Foreign key linking to billing.account. Business justification: Fleet statements are issued for fleet accounts; linking to the master account provides a direct relationship.',
    `customer_fleet_account_id` BIGINT COMMENT 'Reference to the fleet account customer (corporate, government, rental) for which this statement is issued.',
    `approved_by` STRING COMMENT 'User or system identifier of the person or process that approved this statement for issuance.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when this fleet statement was approved for issuance to the customer.',
    `billing_address_line1` STRING COMMENT 'First line of the billing address for the fleet account customer.',
    `billing_address_line2` STRING COMMENT 'Second line of the billing address for the fleet account customer.',
    `billing_city` STRING COMMENT 'City of the billing address for the fleet account customer.',
    `billing_country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code of the billing address.. Valid values are `^[A-Z]{3}$`',
    `billing_cycle_end_date` DATE COMMENT 'End date of the billing cycle covered by this statement.',
    `billing_cycle_start_date` DATE COMMENT 'Start date of the billing cycle covered by this statement.',
    `billing_postal_code` STRING COMMENT 'Postal or ZIP code of the billing address for the fleet account customer.',
    `billing_state_province` STRING COMMENT 'State or province of the billing address for the fleet account customer.',
    `contact_name` STRING COMMENT 'Name of the primary contact person at the fleet account for billing inquiries.',
    `contact_phone` STRING COMMENT 'Phone number of the primary contact person at the fleet account for billing inquiries.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this fleet statement record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts on this statement.. Valid values are `^[A-Z]{3}$`',
    `delivery_email` STRING COMMENT 'Email address to which the statement is sent, if delivery method is email.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `delivery_method` STRING COMMENT 'Method by which the statement is delivered to the fleet account customer.. Valid values are `email|postal_mail|portal|edi`',
    `dispute_amount` DECIMAL(18,2) COMMENT 'Total amount of charges currently under dispute on this statement.',
    `dispute_flag` BOOLEAN COMMENT 'Indicates whether any charges on this statement are currently under dispute by the fleet account customer.',
    `due_date` DATE COMMENT 'Date by which payment for this statement is due from the fleet account customer.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month or quarter) within the fiscal year in which this statement was issued.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which this statement was issued, used for financial reporting and analysis.',
    `fleet_management_fees` DECIMAL(18,2) COMMENT 'Recurring or one-time fleet management and administration fees charged during the billing cycle.',
    `fuel_charges` DECIMAL(18,2) COMMENT 'Total fuel charges billed to the fleet account during the billing cycle, if applicable.',
    `insurance_charges` DECIMAL(18,2) COMMENT 'Insurance premium charges for fleet vehicles during the billing cycle, if managed by OEM.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this fleet statement record was last modified in the system.',
    `notes` STRING COMMENT 'Free-text notes or comments related to this fleet statement, such as special instructions or explanations.',
    `outstanding_balance` DECIMAL(18,2) COMMENT 'Total amount due from the fleet account after applying charges, credits, and payments.',
    `parts_charges` DECIMAL(18,2) COMMENT 'Total charges for parts supplied to the fleet account during the billing cycle.',
    `payment_terms` STRING COMMENT 'Payment terms applicable to this statement, such as Net 30, Net 60, or custom negotiated terms.',
    `previous_balance` DECIMAL(18,2) COMMENT 'Outstanding balance carried forward from the previous billing statement.',
    `service_charges` DECIMAL(18,2) COMMENT 'Total charges for maintenance and repair services provided to fleet vehicles during the billing cycle.',
    `statement_date` DATE COMMENT 'Date on which the fleet statement was issued to the customer.',
    `statement_number` STRING COMMENT 'Externally-known unique statement number assigned to this fleet billing statement for reference and tracking.. Valid values are `^FS-[0-9]{8}-[0-9]{4}$`',
    `statement_status` STRING COMMENT 'Current lifecycle status of the fleet statement in the billing and collection workflow.. Valid values are `draft|issued|partially_paid|paid|overdue|disputed`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount applied to all charges on this statement, including sales tax, VAT, and other applicable taxes.',
    `tco_summary_flag` BOOLEAN COMMENT 'Indicates whether this statement includes a Total Cost of Ownership summary for the fleet account.',
    `telematics_subscription_charges` DECIMAL(18,2) COMMENT 'Charges for connected vehicle telematics services and subscriptions during the billing cycle.',
    `total_charges` DECIMAL(18,2) COMMENT 'Sum of all charges before credits and payments (vehicle acquisition, parts, service, fees, taxes).',
    `total_credits` DECIMAL(18,2) COMMENT 'Total credit memos, adjustments, and allowances applied to the fleet account during the billing cycle.',
    `total_payments_received` DECIMAL(18,2) COMMENT 'Total payments received from the fleet account during the billing cycle, applied to outstanding balances.',
    `total_vehicles_billed` STRING COMMENT 'Total count of vehicles included in this billing statement for the fleet account.',
    `vehicle_acquisition_charges` DECIMAL(18,2) COMMENT 'Total charges for vehicle purchases or leases during the billing cycle.',
    CONSTRAINT pk_fleet_statement PRIMARY KEY(`fleet_statement_id`)
) COMMENT 'Periodic billing statement issued to fleet account customers (corporate, government, rental) summarizing vehicle acquisition charges, service fees, parts charges, and payments within a billing cycle. Captures statement number, fleet account reference, billing cycle, total vehicles billed, total parts and service charges, total credits, total payments, outstanding balance, TCO (Total Cost of Ownership) summary flag, and statement delivery method. Distinct from dealer_statement as fleet billing follows different commercial terms and cycles.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` (
    `billing_price_condition_id` BIGINT COMMENT 'Unique identifier for the price condition record. Primary key.',
    `jurisdiction_id` BIGINT COMMENT 'add column jurisdiction_id (BIGINT) with FK to compliance.jurisdiction.jurisdiction_id - pricing conditions vary by tax/regulatory jurisdiction',
    `approval_required_flag` BOOLEAN COMMENT 'Indicates whether application of this pricing condition requires managerial or pricing authority approval before being applied to a billing transaction. True requires approval workflow.',
    `approved_by` STRING COMMENT 'User ID or name of the pricing authority or manager who approved this condition for use in billing transactions. Null if approval is not required or pending.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this pricing condition was approved for use. Null if approval is not required or still pending. Part of the governance audit trail.',
    `calculation_type` STRING COMMENT 'Method used to calculate the condition value in the billing transaction. Defines whether the condition is applied as a fixed amount, percentage of base, quantity-dependent, or using a tiered/formula approach.. Valid values are `fixed|percentage|quantity_based|tiered|formula`',
    `condition_class` STRING COMMENT 'High-level classification of the condition type grouping similar pricing elements together for reporting and analysis purposes.. Valid values are `price|discount|surcharge|tax|freight`',
    `condition_description` STRING COMMENT 'Detailed textual description of the pricing condition, including its business purpose, applicability rules, and any special terms or restrictions. Provides context for pricing analysts and auditors.',
    `condition_exclusion_flag` BOOLEAN COMMENT 'Indicates whether this condition is marked for exclusion from certain pricing scenarios or customer groups. True means the condition should be excluded under specific business rules.',
    `condition_record_number` STRING COMMENT 'Business identifier for the pricing condition record, typically sourced from SAP SD condition record (KONP table). Used for external reference and traceability.',
    `condition_status` STRING COMMENT 'Current lifecycle status of the pricing condition record. Active conditions are available for use in billing; inactive, expired, or suspended conditions are not applied.. Valid values are `active|inactive|pending|expired|suspended`',
    `condition_step_number` STRING COMMENT 'Sequence number within the pricing procedure that defines the order in which this condition is evaluated and applied during billing calculation.',
    `condition_type` STRING COMMENT 'Type of pricing condition applied to the billing transaction. Defines whether this is a base price (MSRP), negotiated price, discount, surcharge, tax, or other pricing element. Aligns with SAP SD condition types. [ENUM-REF-CANDIDATE: msrp|negotiated|fleet_discount|dealer_margin|volume_rebate|freight|pdi_charge|tax|surcharge|promotional_discount — 10 candidates stripped; promote to reference product]',
    `condition_unit` STRING COMMENT 'Unit of measure for the condition value. Indicates whether the value is an absolute amount, a percentage, or a per-unit rate.. Valid values are `amount|percentage|per_unit|per_vehicle`',
    `condition_value` DECIMAL(18,2) COMMENT 'Monetary or percentage value of the pricing condition. For absolute amounts, represents the price or adjustment in the condition currency. For percentage-based conditions, represents the rate (e.g., 5.5 for 5.5%).',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this pricing condition record was first created in the system. Part of the audit trail for master data lifecycle tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the condition value when expressed as an absolute amount (e.g., USD, EUR, JPY).. Valid values are `^[A-Z]{3}$`',
    `customer_type` STRING COMMENT 'Type of customer for which this pricing condition is applicable. Enables customer segment-specific pricing strategies (retail, fleet, dealer, government, commercial).. Valid values are `retail|fleet|dealer|government|commercial`',
    `dealer_code` STRING COMMENT 'Unique identifier of the dealer or dealership for which this pricing condition is applicable. Enables dealer-specific pricing agreements and margin structures. Null indicates condition applies to all dealers.',
    `distribution_channel_code` STRING COMMENT 'SAP SD distribution channel code indicating the sales channel (e.g., retail, fleet, online) for which this condition applies. Enables channel-specific pricing strategies.',
    `effective_end_timestamp` TIMESTAMP COMMENT 'Precise date and time when this pricing condition record version is superseded or becomes inactive in the lakehouse. Null indicates the current active version. Used for SCD Type 2 tracking.',
    `effective_start_timestamp` TIMESTAMP COMMENT 'Precise date and time when this pricing condition record becomes effective in the lakehouse. Used for temporal queries and slowly changing dimension (SCD) Type 2 tracking.',
    `is_current_flag` BOOLEAN COMMENT 'Indicates whether this record represents the current active version of the pricing condition. True for the latest version, False for historical versions. Supports SCD Type 2 queries.',
    `last_modified_by` STRING COMMENT 'User ID or name of the person who last modified this pricing condition record. Supports change tracking and accountability.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this pricing condition record was last modified. Enables change detection and version control for pricing master data.',
    `manual_override_allowed_flag` BOOLEAN COMMENT 'Indicates whether sales or billing personnel are permitted to manually override this condition value during transaction processing. True allows manual adjustment, False enforces system-determined value.',
    `model_year` STRING COMMENT 'Model year of the vehicle for which this pricing condition is applicable. Enables year-over-year pricing adjustments and end-of-model-year promotions.',
    `pricing_procedure_code` STRING COMMENT 'Reference to the SAP SD pricing procedure that governs the sequence and logic of condition application. Links this condition to the broader pricing determination framework.',
    `sales_organization_code` STRING COMMENT 'SAP SD sales organization code that owns this pricing condition. Defines the organizational unit responsible for pricing governance and approval.',
    `sales_region_code` STRING COMMENT 'Geographic sales region or market code for which this pricing condition is valid. Enables region-specific pricing strategies to account for market conditions, competition, and regulatory requirements.',
    `sap_condition_table` STRING COMMENT 'Name of the SAP SD condition table (e.g., A001, A002) from which this condition record is sourced. Provides traceability to the source system configuration.',
    `sap_konp_record_number` STRING COMMENT 'Reference to the SAP SD KONP table record number that stores the condition record master data. Enables direct linkage to the source system for audit and reconciliation.',
    `sap_konv_counter` STRING COMMENT 'Reference to the SAP SD KONV table counter that tracks condition application instances in sales and billing documents. Used for transaction-level traceability.',
    `scale_basis` STRING COMMENT 'Basis for scale-based pricing conditions. Defines the dimension (quantity, value, weight, volume) used to determine tiered pricing or volume-based discounts.. Valid values are `quantity|value|weight|volume`',
    `scale_quantity_from` DECIMAL(18,2) COMMENT 'Lower bound of the scale range for tiered pricing conditions. Defines the minimum quantity or value at which this condition rate applies.',
    `scale_quantity_to` DECIMAL(18,2) COMMENT 'Upper bound of the scale range for tiered pricing conditions. Defines the maximum quantity or value at which this condition rate applies. Null indicates no upper limit.',
    `source_system_code` STRING COMMENT 'Identifier of the source system from which this pricing condition record was extracted (e.g., SAP_SD, SFDC, DMS). Supports multi-system integration and data lineage tracking.',
    `valid_from_date` DATE COMMENT 'Start date from which this pricing condition becomes effective and can be applied to billing transactions. Part of the condition validity period.',
    `valid_to_date` DATE COMMENT 'End date until which this pricing condition remains effective. Null indicates the condition is valid indefinitely. Part of the condition validity period.',
    `vehicle_model_code` STRING COMMENT 'Code identifying the specific vehicle model to which this pricing condition applies. Enables model-specific pricing and promotional strategies. Null indicates condition applies across all models.',
    `vehicle_trim_level` STRING COMMENT 'Trim or configuration level of the vehicle model for which this condition applies (e.g., base, sport, luxury, premium). Enables trim-specific pricing differentiation.',
    `created_by` STRING COMMENT 'User ID or name of the person who created this pricing condition record in the system. Supports audit trail and accountability.',
    CONSTRAINT pk_billing_price_condition PRIMARY KEY(`billing_price_condition_id`)
) COMMENT 'Pricing condition record defining the applicable price, discount, surcharge, or tax condition for a billing transaction based on customer type, vehicle model, region, and validity period. Captures condition type (MSRP/negotiated/fleet_discount/dealer_margin/volume_rebate/freight/PDI_charge/tax), condition value, condition unit, scale basis, validity start/end dates, pricing procedure reference, and SAP SD condition record reference (KONP/KONV). Supports both MSRP-based and negotiated pricing models as required by the billing domain.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`payment_term` (
    `payment_term_id` BIGINT COMMENT 'Unique identifier for the payment term record. Primary key.',
    `account_id` BIGINT COMMENT 'Foreign key linking to billing.account. Business justification: Accounts often have a default payment term; linking provides a normalized reference.',
    `applicable_account_types` STRING COMMENT 'Comma-separated list of billing account types to which this payment term applies (e.g., dealer, fleet, retail, corporate, OEM (Original Equipment Manufacturer)).',
    `approval_date` DATE COMMENT 'Date on which this payment term was approved by finance or credit management. Null if not yet approved.',
    `approval_required` BOOLEAN COMMENT 'Indicates whether finance or credit manager approval is required before this payment term can be assigned to a customer account.',
    `approved_by` STRING COMMENT 'Name or user ID of the finance or credit manager who approved this payment term for use. Null if no approval required or pending.',
    `auto_dunning_enabled` BOOLEAN COMMENT 'Indicates whether automatic dunning (collection reminder) process is enabled for invoices using this payment term.',
    `baseline_date_rule` STRING COMMENT 'Rule defining the baseline date from which net due days and discount days are calculated (invoice date, delivery date, end of month, or custom).. Valid values are `invoice_date|delivery_date|month_end|custom`',
    `business_unit_code` STRING COMMENT 'Code identifying the business unit or division that owns and manages this payment term (e.g., DEALER, FLEET, PARTS).. Valid values are `^[A-Z0-9]{2,6}$`',
    `payment_term_code` STRING COMMENT 'Short alphanumeric code representing the payment term (e.g., NET30, 2/10N30, COD). Maps to SAP FI payment term key in table T052.. Valid values are `^[A-Z0-9]{2,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this payment term record was first created in the system.',
    `credit_check_required` BOOLEAN COMMENT 'Indicates whether a credit check is required before this payment term can be assigned to a billing account.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for which this payment term is defined (e.g., USD, EUR, JPY). Null if applicable to all currencies.. Valid values are `^[A-Z]{3}$`',
    `payment_term_description` STRING COMMENT 'Detailed explanation of the payment term conditions, including discount and penalty clauses.',
    `discount_days_1` STRING COMMENT 'Number of days from invoice date within which discount percentage 1 applies.',
    `discount_days_2` STRING COMMENT 'Number of days from invoice date within which discount percentage 2 applies (typically longer than discount days 1).',
    `discount_percentage_1` DECIMAL(18,2) COMMENT 'First early payment discount percentage offered if payment is made within discount days 1 (e.g., 2.00 for 2%).',
    `discount_percentage_2` DECIMAL(18,2) COMMENT 'Second early payment discount percentage offered if payment is made within discount days 2 (typically lower than discount 1).',
    `dunning_level` STRING COMMENT 'Default dunning level (escalation stage) for collection reminders associated with this payment term. Null if auto dunning is disabled.',
    `effective_end_date` DATE COMMENT 'Date after which this payment term is no longer valid for new assignments. Null if no end date is defined.',
    `effective_start_date` DATE COMMENT 'Date from which this payment term becomes valid and available for assignment to billing accounts.',
    `fixed_day_of_month` STRING COMMENT 'If baseline date rule is custom, specifies a fixed day of the month for payment due date (e.g., 15 for the 15th of each month). Null if not applicable.',
    `last_modified_by` STRING COMMENT 'User ID or name of the person who last modified this payment term record.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this payment term record was last updated.',
    `maximum_order_value` DECIMAL(18,2) COMMENT 'Maximum invoice or order value for which this payment term is applicable. Null if no maximum.',
    `minimum_order_value` DECIMAL(18,2) COMMENT 'Minimum invoice or order value required for this payment term to be applicable. Null if no minimum.',
    `payment_term_name` STRING COMMENT 'Full descriptive name of the payment term (e.g., Net 30 Days, 2% 10 Net 30, Cash on Delivery).',
    `net_due_days` STRING COMMENT 'Number of days from invoice date by which full payment is due without penalty.',
    `notes` STRING COMMENT 'Free-text field for additional notes, special conditions, or internal comments about this payment term.',
    `payment_method_restriction` STRING COMMENT 'Comma-separated list of allowed payment methods for this term (e.g., wire_transfer, check, ACH, credit_card). Empty if no restriction.',
    `payment_term_status` STRING COMMENT 'Current lifecycle status of the payment term: active (in use), inactive (not available for new assignments), deprecated (legacy term), or pending approval (awaiting finance approval).. Valid values are `active|inactive|deprecated|pending_approval`',
    `penalty_calculation_method` STRING COMMENT 'Method used to calculate late payment penalties: daily accrual, monthly accrual, flat fee, or none.. Valid values are `daily|monthly|flat_fee|none`',
    `penalty_grace_days` STRING COMMENT 'Number of days after net due date before penalty charges begin to accrue.',
    `penalty_rate` DECIMAL(18,2) COMMENT 'Late payment penalty rate applied after grace period expires, expressed as percentage per period (e.g., 1.5% per month).',
    `region_code` STRING COMMENT 'Three-letter geographic region code where this payment term is applicable (e.g., USA, EUR, JPN). Null if globally applicable.. Valid values are `^[A-Z]{3}$`',
    `sap_fi_payment_term_key` STRING COMMENT 'Reference to the SAP FI payment term key in table T052 for ERP (Enterprise Resource Planning) integration and synchronization.. Valid values are `^[A-Z0-9]{4}$`',
    `usage_count` STRING COMMENT 'Number of active billing accounts or invoices currently using this payment term. Used for impact analysis before deprecation.',
    `created_by` STRING COMMENT 'User ID or name of the person who created this payment term record.',
    CONSTRAINT pk_payment_term PRIMARY KEY(`payment_term_id`)
) COMMENT 'Reference master for standard payment terms offered to billing accounts, defining due date calculation rules, early payment discount percentages, and penalty terms. Captures payment term code, description, net due days, discount percentage 1 and 2, discount days 1 and 2, penalty rate, penalty grace days, applicable account types (dealer/fleet/retail/corporate), and SAP FI payment term reference (T052). Used to standardize billing terms across all invoice types.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`tax_code` (
    `tax_code_id` BIGINT COMMENT 'Unique identifier for the tax code record. Primary key.',
    `account_id` BIGINT COMMENT 'Foreign key linking to billing.account. Business justification: Accounts may have a default tax code; linking normalizes tax code usage.',
    `applicable_transaction_types` STRING COMMENT 'Comma-separated list of transaction types to which this tax code applies. Examples: vehicle_sale, parts_sale, service_labor, warranty_repair, fleet_lease, export_sale, dealer_invoice, retail_invoice. Supports multi-transaction applicability.',
    `calculation_method` STRING COMMENT 'The method used to calculate the tax amount. Percentage for rate-based calculation, fixed_amount for flat fees, tiered for progressive rates based on value bands, formula_based for complex calculations (e.g., emissions-based environmental levies).. Valid values are `percentage|fixed_amount|tiered|formula_based`',
    `tax_code_code` STRING COMMENT 'The alphanumeric tax code identifier used in billing and invoicing systems. Maps to SAP FI/SD tax code field (MWSKZ). Examples: VAT_STD, GST_18, SALES_TX_CA, EXCISE_LUX.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this tax code record was first created in the system. Supports audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which tax amounts are calculated and reported (e.g., USD, EUR, GBP, INR, CNY). Supports multi-currency billing operations.. Valid values are `^[A-Z]{3}$`',
    `effective_date` DATE COMMENT 'The date from which this tax code and rate become active and applicable to transactions. Supports time-based tax rate changes and regulatory compliance.',
    `exemption_certificate_required` BOOLEAN COMMENT 'Indicates whether a tax exemption certificate must be on file to apply this code for exempt transactions. True if certificate is mandatory, False otherwise. Supports compliance with exemption documentation requirements.',
    `expiry_date` DATE COMMENT 'The date on which this tax code and rate cease to be valid. Nullable for indefinite validity. Supports sunset provisions and temporary tax measures.',
    `gl_account_code` STRING COMMENT 'The GL account number to which tax amounts calculated using this code are posted in the financial ledger. Supports automated accounting entries and financial reporting.. Valid values are `^[0-9]{4,10}$`',
    `is_deductible` BOOLEAN COMMENT 'Indicates whether the tax is deductible as a business expense for income tax purposes. Relevant for excise duties and certain non-recoverable taxes.',
    `is_recoverable` BOOLEAN COMMENT 'Indicates whether the tax paid under this code can be recovered or reclaimed from the tax authority (e.g., input VAT). True for recoverable taxes, False for non-recoverable taxes.',
    `jurisdiction_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code or extended jurisdiction identifier (e.g., USA-CA for California, DEU for Germany, IND-MH for Maharashtra). Identifies the specific geographic area where this tax applies.. Valid values are `^[A-Z]{2,3}(-[A-Z0-9]{2,5})?$`',
    `jurisdiction_level` STRING COMMENT 'The governmental or regional level at which this tax is levied. Federal for national taxes, state for US state or equivalent provincial taxes, local for city/county taxes, EU for European Union-wide directives, APAC for Asia-Pacific regional harmonized taxes, multi_jurisdiction for taxes spanning multiple levels.. Valid values are `federal|state|local|eu|apac|multi_jurisdiction`',
    `last_modified_by` STRING COMMENT 'The user ID or name of the person who last modified this tax code record. Supports change management and audit compliance.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this tax code record was most recently updated. Supports change tracking and audit compliance.',
    `tax_code_name` STRING COMMENT 'Human-readable name or description of the tax code for display and reporting purposes.',
    `notes` STRING COMMENT 'Free-text field for additional information, special instructions, or clarifications regarding the application of this tax code. May include references to specific regulations, exemptions, or business rules.',
    `reporting_code` STRING COMMENT 'The code or box number used when reporting this tax on statutory returns (e.g., VAT return box 1, GST return line 3A). Supports automated regulatory reporting and compliance.',
    `reverse_charge_applicable` BOOLEAN COMMENT 'Indicates whether the reverse charge mechanism applies, where the customer rather than the supplier accounts for VAT. Common in B2B cross-border EU transactions and certain domestic supplies.',
    `rounding_precision` STRING COMMENT 'The number of decimal places to which tax amounts are rounded (e.g., 2 for cents/pence, 0 for whole currency units). Supports multi-currency precision requirements.',
    `rounding_rule` STRING COMMENT 'The rounding method applied to calculated tax amounts. Round_up for ceiling, round_down for floor, round_nearest for standard rounding, no_rounding for exact amounts. Ensures compliance with jurisdiction-specific rounding regulations.. Valid values are `round_up|round_down|round_nearest|no_rounding`',
    `sap_fi_tax_code` STRING COMMENT 'The corresponding tax code identifier in SAP FI module (table T007A, field MWSKZ). Typically 1-2 character alphanumeric. Enables integration and reconciliation between lakehouse and SAP ERP.. Valid values are `^[A-Z0-9]{1,2}$`',
    `sap_sd_tax_code` STRING COMMENT 'The corresponding tax code identifier in SAP SD module used in sales orders and billing documents. May differ from FI code in some implementations. Supports sales-specific tax determination.. Valid values are `^[A-Z0-9]{1,2}$`',
    `tax_authority_name` STRING COMMENT 'The name of the governmental or regulatory body responsible for administering this tax. Examples: Internal Revenue Service (IRS), HM Revenue & Customs (HMRC), Goods and Services Tax Network (GSTN), California Department of Tax and Fee Administration.',
    `tax_authority_reference` STRING COMMENT 'The official reference number, code, or identifier assigned by the tax authority for this tax type or rate. Used for regulatory reporting and audit trail.',
    `tax_basis` STRING COMMENT 'The base amount on which the tax rate is applied. Net_amount for taxes on pre-tax subtotal, gross_amount for taxes on total including other taxes (cascading), MSRP (Manufacturer Suggested Retail Price) for luxury taxes, invoice_value for dealer invoices, customs_value for import duties.. Valid values are `net_amount|gross_amount|msrp|invoice_value|customs_value`',
    `tax_category` STRING COMMENT 'The accounting treatment category for this tax. Input_tax for recoverable VAT on purchases, output_tax for VAT charged on sales, withholding_tax for taxes deducted at source, reverse_charge for customer-remitted VAT, exempt for tax-exempt transactions, zero_rated for 0% taxable supplies.. Valid values are `input_tax|output_tax|withholding_tax|reverse_charge|exempt|zero_rated`',
    `tax_code_status` STRING COMMENT 'Current lifecycle status of the tax code. Active for codes in use, inactive for retired codes, pending for codes awaiting regulatory approval, superseded for codes replaced by newer versions.. Valid values are `active|inactive|pending|superseded`',
    `tax_rate_percentage` DECIMAL(18,2) COMMENT 'The tax rate as a percentage (e.g., 19.0000 for 19% VAT, 5.5000 for 5.5% GST). Precision to four decimal places supports fine-grained rates. Used to calculate tax amount from taxable base.',
    `tax_type` STRING COMMENT 'The category of tax represented by this code. VAT (Value Added Tax) for EU and similar jurisdictions, GST (Goods and Services Tax) for India/Australia/Canada, sales_tax for US state-level, excise for fuel/alcohol/tobacco duties, luxury_tax for high-value vehicles, environmental_levy for emissions-based charges.. Valid values are `vat|gst|sales_tax|excise|luxury_tax|environmental_levy`',
    `withholding_tax_applicable` BOOLEAN COMMENT 'Indicates whether withholding tax provisions apply to transactions using this code. Relevant for cross-border payments and certain domestic transactions where tax is deducted at source.',
    `created_by` STRING COMMENT 'The user ID or name of the person who created this tax code record. Supports accountability and audit trail.',
    CONSTRAINT pk_tax_code PRIMARY KEY(`tax_code_id`)
) COMMENT 'Reference master for tax codes applicable to automotive billing transactions across jurisdictions, capturing tax code identifier, tax type (VAT/GST/sales_tax/excise/luxury_tax/environmental_levy), jurisdiction (federal/state/local/EU/APAC), applicable transaction types, tax rate percentage, effective date, expiry date, tax authority reference, and SAP FI/SD tax code mapping. Supports multi-jurisdiction billing for domestic and export vehicle sales, parts, and services.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`dunning_record` (
    `dunning_record_id` BIGINT COMMENT 'Unique identifier for the dunning record. Primary key.',
    `account_id` BIGINT COMMENT 'Reference to the billing account that is subject to dunning activity due to overdue receivables.',
    `employee_id` BIGINT COMMENT 'Reference to the collections specialist or team responsible for managing this dunning case and follow-up actions.',
    `dunning_employee_id` BIGINT COMMENT 'Reference to the collections specialist or team responsible for managing this dunning case and follow-up actions.',
    `account_type` STRING COMMENT 'The classification of the billing account subject to dunning. Dealer accounts are franchise dealerships, fleet accounts are corporate fleet customers, retail accounts are individual consumers, commercial accounts are business customers, government accounts are public sector entities.. Valid values are `dealer|fleet|retail|commercial|government`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this dunning record was first created in the system.',
    `credit_exposure` DECIMAL(18,2) COMMENT 'The total outstanding receivables for the account at the time of the dunning run, including both overdue and current amounts. Confidential business data.',
    `credit_limit` DECIMAL(18,2) COMMENT 'The approved credit limit for the billing account at the time of the dunning run. Confidential business data.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the overdue amount (e.g., USD, EUR, JPY).. Valid values are `^[A-Z]{3}$`',
    `customer_segment` STRING COMMENT 'The business segment or risk classification of the customer, influencing dunning strategy and escalation path.. Valid values are `premium|standard|high_risk|vip|new`',
    `days_overdue` STRING COMMENT 'The number of days between the oldest overdue date and the dunning run date, representing the age of the oldest delinquency.',
    `delivery_address` STRING COMMENT 'The email address, postal address, or portal user ID to which the dunning notice was sent. Confidential organizational contact data.',
    `dispute_flag` BOOLEAN COMMENT 'Indicates whether the customer has raised a dispute regarding the overdue charges (True) or not (False).',
    `dispute_reason` STRING COMMENT 'Free-text description of the reason provided by the customer for disputing the overdue charges.',
    `dunning_block_date` DATE COMMENT 'The date on which the dunning block was applied to the account. Null if not blocked.',
    `dunning_block_flag` BOOLEAN COMMENT 'Indicates whether further dunning activity for this account has been temporarily blocked (True) due to dispute, payment arrangement, or other reason, or is active (False).',
    `dunning_block_reason` STRING COMMENT 'The reason why dunning activity has been blocked for this account. Null if not blocked.. Valid values are `dispute_under_review|payment_plan_active|legal_hold|customer_bankruptcy|account_closed|manual_block`',
    `dunning_fee_amount` DECIMAL(18,2) COMMENT 'The administrative fee charged to the customer for this dunning notice, if applicable. Zero if no fee charged.',
    `dunning_level` STRING COMMENT 'The escalation level of the dunning notice. Level 1 is initial reminder, Level 2 is warning, Level 3 is final demand, Legal indicates legal action initiated.. Valid values are `level_1|level_2|level_3|legal`',
    `dunning_notice_delivery_method` STRING COMMENT 'The channel through which the dunning notice was delivered to the customer.. Valid values are `email|postal_mail|customer_portal|fax|sms`',
    `dunning_notice_sent_timestamp` TIMESTAMP COMMENT 'The date and time when the dunning notice was successfully transmitted to the customer.',
    `dunning_notice_type` STRING COMMENT 'The type of dunning communication sent to the customer. Reminder is courtesy notice, warning indicates escalation, final demand is last notice before legal action, legal notice indicates attorney involvement, suspension notice warns of service suspension, account hold indicates credit freeze.. Valid values are `reminder|warning|final_demand|legal_notice|suspension_notice|account_hold`',
    `dunning_run_date` DATE COMMENT 'The date on which the dunning run was executed and this dunning notice was generated.',
    `dunning_run_number` STRING COMMENT 'Business identifier for the dunning run batch that generated this notice. Format: DUN-YYYYMMDD-NNNN.. Valid values are `^DUN-[0-9]{8}-[0-9]{4}$`',
    `dunning_status` STRING COMMENT 'The current lifecycle status of this dunning record. Sent indicates notice generated, delivered indicates successful transmission, bounced indicates delivery failure, responded indicates customer reply received, escalated indicates moved to higher level, resolved indicates payment received or dispute settled, cancelled indicates dunning withdrawn. [ENUM-REF-CANDIDATE: sent|delivered|bounced|responded|escalated|resolved|cancelled — 7 candidates stripped; promote to reference product]',
    `interest_amount` DECIMAL(18,2) COMMENT 'The late payment interest accrued on the overdue amount as of the dunning run date, if applicable. Zero if no interest charged.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this dunning record was last updated.',
    `next_action_date` DATE COMMENT 'The scheduled date for the next follow-up action or escalation if payment is not received.',
    `next_action_type` STRING COMMENT 'The type of follow-up action planned for the next action date.. Valid values are `phone_call|email_follow_up|escalate_level|legal_referral|account_suspension|write_off_review`',
    `notes` STRING COMMENT 'Free-text notes and comments from collections staff regarding this dunning case, customer interactions, and follow-up actions.',
    `oldest_overdue_date` DATE COMMENT 'The due date of the oldest unpaid invoice included in this dunning action, indicating how long the account has been delinquent.',
    `overdue_item_count` STRING COMMENT 'The number of individual overdue invoices or line items included in this dunning notice.',
    `payment_promise_amount` DECIMAL(18,2) COMMENT 'The amount the customer has committed to pay by the promise date. May be partial or full overdue amount.',
    `payment_promise_date` DATE COMMENT 'The date by which the customer has promised to remit payment, if a payment promise was received. Null otherwise.',
    `resolution_date` DATE COMMENT 'The date on which the dunning case was resolved through payment, dispute settlement, or write-off. Null if still open.',
    `resolution_type` STRING COMMENT 'The manner in which the dunning case was resolved. Null if still open.. Valid values are `full_payment|partial_payment|payment_plan|dispute_settled|write_off|account_closed`',
    `response_date` DATE COMMENT 'The date on which the customer responded to the dunning notice. Null if no response received.',
    `response_received_flag` BOOLEAN COMMENT 'Indicates whether the customer has responded to this dunning notice (True) or not (False).',
    `response_type` STRING COMMENT 'The nature of the customer response to the dunning notice. Payment promise indicates commitment to pay, dispute raised indicates disagreement with charges, payment plan request indicates request for installment arrangement, contact request indicates need for discussion.. Valid values are `payment_promise|dispute_raised|payment_plan_request|contact_request|no_response`',
    `sap_dunning_document_number` STRING COMMENT 'The SAP FI dunning document number generated by the dunning program. 10-digit numeric identifier.. Valid values are `^[0-9]{10}$`',
    `total_overdue_amount` DECIMAL(18,2) COMMENT 'The total amount of receivables that are overdue and subject to this dunning action, in the billing currency.',
    CONSTRAINT pk_dunning_record PRIMARY KEY(`dunning_record_id`)
) COMMENT 'Dunning activity record tracking collection notices sent to billing accounts with overdue receivables. Captures dunning run date, billing account reference, dunning level (1/2/3/legal), dunning notice type (reminder/warning/final_demand/legal_notice), total overdue amount, number of overdue items, dunning notice delivery method (email/post/portal), response received flag, response date, and SAP FI dunning document reference. Supports escalating collections workflow for dealer and fleet accounts.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` (
    `rebate_agreement_id` BIGINT COMMENT 'Unique identifier for the rebate agreement record. Primary key.',
    `account_id` BIGINT COMMENT 'Identifier of the dealer or fleet customer account that is the recipient of the rebate. Links to dealer or customer master data.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Rebate programs are tied to specific regulatory incentives; linking enables tracking of compliance‑driven rebates.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Rebate agreements are defined per vehicle program; linking to vehicle_program allows accurate accruals, compliance reporting, and program‑specific financial analysis.',
    `accrual_method` STRING COMMENT 'Method by which rebate amounts are calculated and accrued: periodic (monthly/quarterly calculation), milestone (triggered when target is reached), transaction_based (accrued per invoice).. Valid values are `periodic|milestone|transaction_based`',
    `achieved_volume` STRING COMMENT 'Actual number of vehicle units sold or delivered under this agreement as of the last accrual calculation. Updated periodically based on billing transactions.',
    `agreement_number` STRING COMMENT 'Externally-known business identifier for the rebate agreement, typically generated by SAP SD rebate management (BO01/BO02) or dealer management system.. Valid values are `^[A-Z0-9]{8,20}$`',
    `agreement_status` STRING COMMENT 'Current lifecycle status of the rebate agreement: draft (under negotiation), active (in force), suspended (temporarily paused), expired (validity period ended), terminated (cancelled before expiry), settled (final payment completed).. Valid values are `draft|active|suspended|expired|terminated|settled`',
    `agreement_type` STRING COMMENT 'Classification of the rebate agreement defining the incentive structure: volume_rebate (quantity-based), loyalty_bonus (retention incentive), conquest_bonus (new customer acquisition), fleet_incentive (commercial fleet programs), model_mix_bonus (product mix targets), early_payment_discount (payment terms incentive).. Valid values are `volume_rebate|loyalty_bonus|conquest_bonus|fleet_incentive|model_mix_bonus|early_payment_discount`',
    `approval_date` DATE COMMENT 'Date when the rebate agreement was approved by authorized personnel. Null if not yet approved.',
    `approval_status` STRING COMMENT 'Approval workflow status for the rebate agreement: pending_approval (awaiting management sign-off), approved (authorized for execution), rejected (not approved).. Valid values are `pending_approval|approved|rejected`',
    `approved_by` STRING COMMENT 'Name or user ID of the manager or executive who approved the rebate agreement. Null if not yet approved.',
    `beneficiary_type` STRING COMMENT 'Classification of the rebate recipient: dealer (franchise dealership), fleet_customer (commercial fleet operator), distributor (regional distributor), broker (third-party intermediary).. Valid values are `dealer|fleet_customer|distributor|broker`',
    `contract_document_reference` STRING COMMENT 'Reference number or file path to the signed legal contract or agreement document supporting this rebate arrangement. Used for audit and compliance.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the rebate agreement record was first created in the system. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this agreement (e.g., USD, EUR, JPY).. Valid values are `^[A-Z]{3}$`',
    `dealer_tier` STRING COMMENT 'Performance tier classification of the dealer beneficiary, used to determine rebate eligibility and rate structure. Higher tiers may receive enhanced rebate terms.. Valid values are `platinum|gold|silver|bronze|standard`',
    `dispute_description` STRING COMMENT 'Description of the dispute or disagreement related to the rebate agreement terms, calculation, or settlement. Null if no dispute exists.',
    `dispute_flag` BOOLEAN COMMENT 'Indicates whether the rebate agreement or its settlement is currently under dispute. True if disputed, False otherwise. Used to flag agreements requiring resolution.',
    `effective_end_date` DATE COMMENT 'Date when the rebate agreement expires and no further transactions accrue rebates. Nullable for open-ended agreements subject to annual renewal.',
    `effective_start_date` DATE COMMENT 'Date when the rebate agreement becomes active and eligible transactions begin accruing rebates. Aligns with fiscal year (FY) or model year (MY) boundaries.',
    `is_retroactive` BOOLEAN COMMENT 'Indicates whether the rebate agreement applies retroactively to transactions that occurred before the agreement effective start date. True if retroactive, False otherwise.',
    `last_accrual_calculation_date` DATE COMMENT 'Date when the rebate accrual amounts were last recalculated based on eligible transactions. Used to track data freshness and trigger next calculation cycle.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the rebate agreement record was last updated. Used for change tracking and audit purposes.',
    `last_settlement_date` DATE COMMENT 'Date of the most recent rebate settlement payment or credit memo issuance. Null if no settlements have occurred.',
    `next_settlement_date` DATE COMMENT 'Scheduled date for the next rebate settlement payment or credit memo generation. Null if agreement is settled or terminated.',
    `notes` STRING COMMENT 'Free-text field for additional comments, special terms, or clarifications related to the rebate agreement. Used for operational context and dispute resolution.',
    `outstanding_balance` DECIMAL(18,2) COMMENT 'Remaining rebate amount accrued but not yet settled. Calculated as total_accrued_amount minus total_settled_amount.',
    `payment_method` STRING COMMENT 'Method by which rebate is settled: credit_memo (issued against future purchases), direct_payment (bank transfer or check), offset_against_invoice (deducted from current receivables).. Valid values are `credit_memo|direct_payment|offset_against_invoice`',
    `powertrain_scope` STRING COMMENT 'Powertrain types eligible for the rebate: all (any powertrain), ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), EV (Electric Vehicle). Used to target electrification incentives.. Valid values are `all|ICE|HEV|PHEV|EV`',
    `rebate_amount_per_unit` DECIMAL(18,2) COMMENT 'Fixed rebate amount paid per vehicle unit sold. Used for flat-rate rebate structures. Null if percentage-based rebate is used.',
    `rebate_rate_percent` DECIMAL(18,2) COMMENT 'Percentage rate applied to eligible transaction amounts to calculate rebate accrual. Used for percentage-based rebate structures. Null if fixed amount rebate is used.',
    `sales_region` STRING COMMENT 'Geographic sales region or territory to which this rebate agreement applies. Used for regional incentive programs and performance tracking.',
    `sap_rebate_agreement_number` STRING COMMENT 'SAP SD rebate agreement reference number from transaction codes BO01 (create) or BO02 (change). Used for system integration and traceability.. Valid values are `^[0-9]{10}$`',
    `settlement_frequency` STRING COMMENT 'Frequency at which accrued rebates are paid out to the beneficiary: monthly, quarterly, semi_annual, annual, or upon_completion (at agreement end).. Valid values are `monthly|quarterly|semi_annual|annual|upon_completion`',
    `settlement_status` STRING COMMENT 'Current status of rebate settlement: not_started (no payments made), in_progress (settlement cycle active), partially_settled (some payments made), fully_settled (all accruals paid), disputed (settlement under review).. Valid values are `not_started|in_progress|partially_settled|fully_settled|disputed`',
    `target_volume` STRING COMMENT 'Target number of vehicle units that must be sold or delivered to qualify for the rebate. Null for non-volume-based agreements.',
    `termination_reason` STRING COMMENT 'Explanation for why the rebate agreement was terminated early, if applicable. Null for agreements that expired naturally or are still active.',
    `total_accrued_amount` DECIMAL(18,2) COMMENT 'Cumulative rebate amount accrued under this agreement as of the last calculation date. Represents the liability owed to the beneficiary.',
    `total_settled_amount` DECIMAL(18,2) COMMENT 'Cumulative rebate amount paid out to the beneficiary through credit memos or direct payments. Used to track settlement progress.',
    `vehicle_model_scope` STRING COMMENT 'Comma-separated list of vehicle models or model families eligible for this rebate agreement. May reference SKU (Stock Keeping Unit) codes or model year (MY) designations. Empty indicates all models are eligible.',
    CONSTRAINT pk_rebate_agreement PRIMARY KEY(`rebate_agreement_id`)
) COMMENT 'Dealer or fleet rebate agreement defining the terms under which volume-based or performance-based rebates are accrued and settled. Captures agreement number, agreement type (volume_rebate/loyalty_bonus/conquest_bonus/fleet_incentive/model_mix_bonus), beneficiary account, vehicle model scope, agreement period, target volume, achieved volume, rebate rate or amount, accrual method (periodic/milestone), settlement frequency (monthly/quarterly/annual), settlement status, and SAP SD rebate agreement reference (BO01/BO02). Drives credit memo generation upon settlement.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` (
    `rebate_accrual_id` BIGINT COMMENT 'Unique identifier for the rebate accrual record. Primary key for the rebate accrual entity.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Cost‑center assignment for rebate accruals enables internal cost tracking.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Rebate accruals must be posted to a GL account; replaces denormalized gl_account_code.',
    `employee_id` BIGINT COMMENT 'Reference to the finance manager or controller who approved this accrual for posting. Null if not yet approved.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Profit‑center linkage required for rebate profitability analysis.',
    `rebate_agreement_id` BIGINT COMMENT 'Reference to the parent rebate agreement under which this accrual is recorded. Links to the master rebate agreement contract.',
    `rebate_created_by_user_employee_id` BIGINT COMMENT 'System user ID of the person or automated process that created this accrual record. Used for audit trail and accountability.',
    `party_id` BIGINT COMMENT 'Reference to the fleet or retail customer who is the beneficiary of this rebate accrual. Null if the rebate is for a dealer.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealer or distributor who is the beneficiary of this rebate accrual. Null if the rebate is for a fleet customer or other non-dealer party.',
    `rebate_dealership_id` BIGINT COMMENT 'Reference to the dealer or distributor who is the beneficiary of this rebate accrual. Null if the rebate is for a fleet customer or other non-dealer party.',
    `rebate_employee_id` BIGINT COMMENT 'Reference to the finance manager or controller who approved this accrual for posting. Null if not yet approved.',
    `rebate_party_id` BIGINT COMMENT 'Reference to the fleet or retail customer who is the beneficiary of this rebate accrual. Null if the rebate is for a dealer.',
    `rebate_updated_by_user_employee_id` BIGINT COMMENT 'System user ID of the person or automated process that last modified this accrual record. Used for audit trail and accountability.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: REQUIRED: Rebate accruals are calculated per SKU sold; linking enables accurate accrual reporting per vehicle configuration.',
    `tertiary_rebate_updated_by_user_employee_id` BIGINT COMMENT 'System user ID of the person or automated process that last modified this accrual record. Used for audit trail and accountability.',
    `accrual_basis` STRING COMMENT 'The measurement basis used to calculate the accrual. Invoiced_units uses billed quantities; registered_units uses vehicle registrations; shipped_units uses factory shipments; delivered_units uses dealer deliveries; retail_sales uses end-customer sales.. Valid values are `invoiced_units|registered_units|shipped_units|delivered_units|retail_sales`',
    `accrual_notes` STRING COMMENT 'Free-text notes or comments regarding this accrual, such as calculation methodology, special adjustments, or reconciliation remarks. Used for audit trail and internal documentation.',
    `accrual_number` STRING COMMENT 'Business identifier for the accrual record, typically generated by the financial system. Used for audit trail and reconciliation.. Valid values are `^[A-Z0-9]{8,20}$`',
    `accrual_period_end_date` DATE COMMENT 'The last day of the period during which sales or performance milestones were achieved that triggered this accrual. Defines the end of the measurement window.',
    `accrual_period_start_date` DATE COMMENT 'The first day of the period during which sales or performance milestones were achieved that triggered this accrual. Defines the beginning of the measurement window.',
    `accrual_status` STRING COMMENT 'Current lifecycle status of the accrual record. Open indicates accrual is calculated but not yet posted to the general ledger; posted indicates the liability has been recorded; reversed indicates the accrual was backed out; settled indicates payment has been made; cancelled indicates the accrual was voided; pending_approval indicates awaiting finance approval.. Valid values are `open|posted|reversed|settled|cancelled|pending_approval`',
    `accrued_amount` DECIMAL(18,2) COMMENT 'The rebate liability amount accrued for this specific period, calculated based on the accrued units and the rebate rate defined in the agreement. Represents the incremental accrual for this period only.',
    `accrued_units` DECIMAL(18,2) COMMENT 'The quantity of units (vehicles, parts, or other items) that qualified for rebate during this accrual period. Measured in the unit of measure specified in the rebate agreement.',
    `approval_status` STRING COMMENT 'Workflow approval status for this accrual. Pending indicates awaiting finance approval; approved indicates cleared for posting; rejected indicates the accrual was not approved and should be cancelled.. Valid values are `pending|approved|rejected`',
    `approval_timestamp` TIMESTAMP COMMENT 'The date and time when this accrual was approved for posting. Null if not yet approved.',
    `copa_posting_reference` STRING COMMENT 'Reference number of the CO-PA posting document created when this accrual was posted to the profitability analysis module. Used for traceability between accrual and profitability reporting.. Valid values are `^[A-Z0-9]{8,20}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this accrual record was first created in the system. Used for audit trail and data lineage.',
    `cumulative_accrued_amount` DECIMAL(18,2) COMMENT 'The total rebate liability accrued from the start of the rebate agreement through the end of this accrual period. Used for tracking progress toward tiered rebate thresholds and total liability exposure.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which the accrued amounts are denominated (e.g., USD, EUR, JPY, CNY).. Valid values are `^[A-Z]{3}$`',
    `fiscal_period` STRING COMMENT 'The fiscal period (month or quarter) within the fiscal year in which this accrual period falls. Typically 1-12 for monthly periods or 1-4 for quarterly periods.',
    `fiscal_year` STRING COMMENT 'The fiscal year in which this accrual period falls. Used for financial reporting and year-end accrual reconciliation.',
    `posting_date` DATE COMMENT 'The date on which this accrual was posted to the general ledger. May differ from the accrual period end date due to month-end close timing.',
    `rebate_rate` DECIMAL(18,2) COMMENT 'The per-unit rebate rate applied to calculate the accrued amount for this period. May be a fixed amount per unit or a percentage of the transaction value, depending on the agreement structure.',
    `rebate_rate_type` STRING COMMENT 'The structure of the rebate rate. Fixed_per_unit is a flat amount per unit; percentage is a percentage of sales value; tiered uses different rates at different volume thresholds; volume_based varies continuously with volume.. Valid values are `fixed_per_unit|percentage|tiered|volume_based`',
    `reversal_date` DATE COMMENT 'The date on which this accrual was reversed, if applicable. Null if the accrual has not been reversed.',
    `reversal_reason_code` STRING COMMENT 'Code indicating the reason for reversing this accrual (e.g., calculation error, agreement termination, duplicate entry). Null if not reversed.. Valid values are `^[A-Z0-9]{2,10}$`',
    `sales_region_code` STRING COMMENT 'Code identifying the sales region or territory in which the qualifying sales occurred. Used for regional rebate program segmentation and reporting.. Valid values are `^[A-Z0-9]{2,10}$`',
    `sap_document_number` STRING COMMENT 'The SAP financial document number generated when this accrual was posted to the general ledger. Used for audit trail and reconciliation with SAP FI.. Valid values are `^[0-9]{10}$`',
    `settlement_date` DATE COMMENT 'The date on which the rebate liability was settled through payment or credit memo issuance. Null if not yet settled.',
    `settlement_reference` STRING COMMENT 'Reference to the payment document or credit memo that settled this accrual. Null if not yet settled.. Valid values are `^[A-Z0-9]{8,20}$`',
    `unit_of_measure` STRING COMMENT 'The unit in which accrued quantities are measured. EA=each (parts), VEH=vehicle, KG=kilogram, LTR=liter, M3=cubic meter, TON=metric ton, SET=set of components. [ENUM-REF-CANDIDATE: EA|VEH|KG|LTR|M3|TON|SET — 7 candidates stripped; promote to reference product]',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and time when this accrual record was last modified. Used for audit trail and change tracking.',
    CONSTRAINT pk_rebate_accrual PRIMARY KEY(`rebate_accrual_id`)
) COMMENT 'Periodic accrual record tracking the accumulation of rebate entitlements under a rebate agreement based on actual sales volumes or performance milestones achieved within a period. Captures accrual period, rebate agreement reference, accrued units, accrued amount, cumulative accrued amount, accrual basis (invoiced_units/registered_units), accrual status (open/posted/reversed), and SAP CO-PA accrual posting reference. Enables accurate liability provisioning and rebate settlement forecasting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`write_off` (
    `write_off_id` BIGINT COMMENT 'Unique identifier for the bad debt write-off record. Primary key.',
    `account_id` BIGINT COMMENT 'Reference to the billing account from which the receivable is being written off.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Cost‑center linkage for write‑offs supports expense analysis of bad‑debt.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Write‑off entries must be posted to a GL account; replaces denormalized code.',
    `invoice_id` BIGINT COMMENT 'Reference to the primary invoice associated with this write-off. Links to the original billing document.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Profit‑center association for write‑offs enables profitability impact assessment.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Write‑offs of vehicle invoices must be tied to the underlying vehicle for loss analysis and compliance reporting.',
    `employee_id` BIGINT COMMENT 'Reference to the employee or manager who authorized the write-off. Links to workforce/employee master data.',
    `party_id` BIGINT COMMENT 'Reference to the retail customer or fleet account associated with the written-off receivable. Links to customer master data.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership if the write-off relates to dealer invoicing or dealer-originated receivables. Nullable for direct retail transactions.',
    `write_dealership_id` BIGINT COMMENT 'Reference to the dealership if the write-off relates to dealer invoicing or dealer-originated receivables. Nullable for direct retail transactions.',
    `write_employee_id` BIGINT COMMENT 'Reference to the employee or manager who authorized the write-off. Links to workforce/employee master data.',
    `write_party_id` BIGINT COMMENT 'Reference to the retail customer or fleet account associated with the written-off receivable. Links to customer master data.',
    `amount` DECIMAL(18,2) COMMENT 'The total monetary value of the receivable being written off. Represents the net uncollectable balance.',
    `approval_authority_name` STRING COMMENT 'Full name of the individual who approved the write-off, captured for audit trail purposes.',
    `approval_date` DATE COMMENT 'The date on which the write-off was formally approved by the authorized authority.',
    `approval_level` STRING COMMENT 'The organizational level at which the write-off was approved, typically based on write-off amount thresholds. Values: manager, director, vp (vice president), cfo (chief financial officer).. Valid values are `manager|director|vp|cfo`',
    `business_unit_code` STRING COMMENT 'The business unit or division responsible for the original sale (e.g., vehicle sales, parts, service). Used for divisional bad debt reporting.',
    `write_off_category` STRING COMMENT 'Indicates whether the write-off is for the full outstanding balance or a partial amount. Values: full (entire balance written off), partial (portion of balance written off).. Valid values are `full|partial`',
    `collection_agency_code` BIGINT COMMENT 'Reference to the third-party collection agency assigned to pursue recovery of the written-off debt. Nullable if no agency was engaged.',
    `collection_status` STRING COMMENT 'Current status of collection efforts for the written-off debt. Values: not_assigned (no collection action), assigned (sent to agency), in_progress (active collection), recovered (payment received), closed (collection efforts ceased).. Valid values are `not_assigned|assigned|in_progress|recovered|closed`',
    `created_by_user` STRING COMMENT 'The user ID or username of the system user who created the write-off record. Used for audit trail and accountability.',
    `created_timestamp` TIMESTAMP COMMENT 'The system timestamp when the write-off record was first created in the database. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the write-off amount (e.g., USD, EUR, JPY).. Valid values are `^[A-Z]{3}$`',
    `days_past_due_at_write_off` STRING COMMENT 'The number of days the receivable was overdue at the time of write-off. Used for aging analysis and credit policy evaluation.',
    `fiscal_period` STRING COMMENT 'The fiscal period (month or quarter) within the fiscal year when the write-off was recorded.',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the write-off was recorded, used for financial reporting and period analysis.',
    `legal_case_reference` STRING COMMENT 'Reference number for any associated legal case, bankruptcy filing, or court proceeding related to the write-off. Nullable if no legal action was involved.',
    `notes` STRING COMMENT 'Free-text field for additional comments, supporting documentation references, or special circumstances related to the write-off decision.',
    `original_due_date` DATE COMMENT 'The original payment due date of the invoice before it became delinquent and was subsequently written off.',
    `original_invoice_amount` DECIMAL(18,2) COMMENT 'The original gross amount of the invoice before any payments, credits, or write-offs were applied. Provides context for the write-off magnitude.',
    `outstanding_balance_before_write_off` DECIMAL(18,2) COMMENT 'The receivable balance that was outstanding immediately before the write-off was applied. May differ from original invoice amount if partial payments were received.',
    `posting_date` DATE COMMENT 'The accounting period date when the write-off was posted to the general ledger. May differ from write_off_date for period-end adjustments.',
    `reason_code` STRING COMMENT 'Standardized code indicating the primary reason for the write-off. Values: bankruptcy (customer filed for bankruptcy), insolvency (customer insolvent), uncontactable (customer cannot be reached), statute_of_limitations (debt legally uncollectable), commercial_settlement (negotiated settlement), fraud (fraudulent transaction).. Valid values are `bankruptcy|insolvency|uncontactable|statute_of_limitations|commercial_settlement|fraud`',
    `reason_description` STRING COMMENT 'Detailed narrative explanation of the circumstances leading to the write-off decision. Provides additional context beyond the reason code.',
    `recovery_amount` DECIMAL(18,2) COMMENT 'The monetary amount recovered after the write-off was recorded. Null if no recovery has occurred. Used to track bad debt recovery income.',
    `recovery_date` DATE COMMENT 'The date on which a recovery payment was received for a previously written-off receivable. Null if no recovery has occurred.',
    `recovery_flag` BOOLEAN COMMENT 'Boolean indicator of whether any portion of the written-off amount was subsequently recovered. True if recovery occurred, False otherwise.',
    `sales_region_code` STRING COMMENT 'The sales region or geographic territory associated with the original sale. Used for regional bad debt analysis.',
    `sap_accounting_document_number` STRING COMMENT 'The SAP accounting document number for the general ledger posting of the write-off. May differ from the write-off document number in multi-step posting scenarios.',
    `sap_write_off_document_number` STRING COMMENT 'The SAP FI document number generated when the write-off was posted to the financial system. Used for reconciliation and audit trail.',
    `updated_by_user` STRING COMMENT 'The user ID or username of the system user who last modified the write-off record. Used for audit trail and accountability.',
    `updated_timestamp` TIMESTAMP COMMENT 'The system timestamp when the write-off record was last modified. Used for audit trail and change tracking.',
    `write_off_date` DATE COMMENT 'The date on which the formal decision to write off the uncollectable receivable was executed. This is the business event date for the write-off.',
    `write_off_number` STRING COMMENT 'Business-readable unique identifier for the write-off transaction, typically following organizational numbering convention (e.g., WO-20240001234).. Valid values are `^WO-[0-9]{8,12}$`',
    CONSTRAINT pk_write_off PRIMARY KEY(`write_off_id`)
) COMMENT 'Bad debt write-off record documenting the formal decision to write off an uncollectable receivable balance from a billing account. Captures write-off date, billing account reference, original invoice references, write-off amount, write-off reason (bankruptcy/insolvency/uncontactable/statute_of_limitations/commercial_settlement), approval authority, approval date, write-off category (full/partial), recovery flag, recovery amount if subsequently collected, and SAP FI write-off document reference. Supports credit risk management and bad debt provisioning.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` (
    `intercompany_invoice_id` BIGINT COMMENT 'Unique identifier for the intercompany invoice record. Primary key.',
    `account_id` BIGINT COMMENT 'Foreign key linking to billing.billing_account. Business justification: Intercompany invoices should reference the issuing billing account; the code and name become redundant.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Intercompany invoices for vehicle transfers reference the VIN; FK supports inter‑entity reconciliation and regulatory reporting.',
    `adjustment_amount` DECIMAL(18,2) COMMENT 'Any adjustments applied to the gross amount, such as discounts, rebates, or transfer pricing adjustments. Positive values increase the invoice; negative values decrease it.',
    `cost_center` STRING COMMENT 'Cost center code in SAP CO that bears the cost or revenue associated with this intercompany transaction. Used for internal cost allocation.',
    `created_by_user` STRING COMMENT 'User ID or name of the person who created this intercompany invoice record in the system. Used for accountability and audit purposes.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this intercompany invoice record was first created in the system. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which the intercompany invoice is denominated (e.g., USD, EUR, JPY, CNY).. Valid values are `^[A-Z]{3}$`',
    `dispute_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) showing whether the receiving entity has raised a dispute on this intercompany invoice due to pricing, quantity, or quality discrepancies.',
    `dispute_reason` STRING COMMENT 'Free-text description of the reason for dispute if dispute_flag is True. Captures details such as pricing disagreement, quantity mismatch, or quality issue.',
    `distribution_channel` STRING COMMENT 'SAP SD distribution channel through which the intercompany transaction flows (e.g., wholesale, retail, direct). Defines the route-to-market.',
    `division` STRING COMMENT 'SAP SD division representing the product line or business unit (e.g., passenger vehicles, commercial vehicles, parts). Used for segment reporting.',
    `due_date` DATE COMMENT 'Date by which the receiving entity is expected to settle the intercompany invoice amount.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month or quarter) within the fiscal year when the invoice was issued. Typically 1-12 for monthly periods.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the intercompany invoice was issued, used for financial reporting and period-based reconciliation.',
    `gl_account_code` STRING COMMENT 'General ledger account code to which the intercompany invoice revenue or expense is posted. Aligns with the corporate chart of accounts.. Valid values are `^[0-9]{10}$`',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total invoice amount before taxes, adjustments, or deductions. Represents the base transfer price or service charge.',
    `intercompany_invoice_status` STRING COMMENT 'Current lifecycle status of the intercompany invoice: draft (being prepared), issued (sent to receiving entity), acknowledged (received and accepted), disputed (under review for discrepancies), settled (payment completed), cancelled (voided).. Valid values are `draft|issued|acknowledged|disputed|settled|cancelled`',
    `invoice_number` STRING COMMENT 'Externally-known unique invoice number assigned to this intercompany transaction. Typically follows format IC followed by 10 digits.. Valid values are `^IC[0-9]{10}$`',
    `issue_date` DATE COMMENT 'Date when the intercompany invoice was formally issued by the issuing entity to the receiving entity.',
    `model_year` STRING COMMENT 'Model year of the vehicle or product being transferred. Applicable primarily to vehicle_transfer and CKD/SKD supply transactions.',
    `net_amount` DECIMAL(18,2) COMMENT 'Final payable amount after applying taxes and adjustments. Calculated as gross_amount + tax_amount + adjustment_amount.',
    `notes` STRING COMMENT 'Free-text notes or comments related to this intercompany invoice, such as special instructions, approvals, or clarifications.',
    `payment_method` STRING COMMENT 'Method by which the receiving entity will settle the invoice: wire_transfer (bank wire), ach (automated clearing house), check (paper check), netting (multilateral netting arrangement), offset (offset against reciprocal invoices).. Valid values are `wire_transfer|ach|check|netting|offset`',
    `payment_terms_code` STRING COMMENT 'Code representing the payment terms agreed between issuing and receiving entities (e.g., NET30, NET60, immediate). Defines the payment schedule and discount eligibility.',
    `posting_date` DATE COMMENT 'Date when the intercompany invoice was posted to the general ledger in both issuing and receiving entities.',
    `profit_center` STRING COMMENT 'Profit center code in SAP CO (Controlling) that captures the profitability impact of this intercompany transaction for internal management reporting.',
    `quantity` STRING COMMENT 'Number of units (vehicles, kits, or service units) covered by this intercompany invoice. Typically 1 for vehicle transfers, multiple for CKD/SKD kits or shared services.',
    `receiving_entity_code` STRING COMMENT 'Code identifying the Automotive legal entity or subsidiary that receives and must pay this intercompany invoice. Typically 2-letter country code followed by 4-digit entity identifier.. Valid values are `^[A-Z]{2}[0-9]{4}$`',
    `receiving_entity_name` STRING COMMENT 'Full legal name of the receiving entity or subsidiary.',
    `reference_document_number` STRING COMMENT 'External reference document number such as a purchase order, delivery note, or contract number that supports this intercompany invoice. Used for traceability.',
    `sales_organization` STRING COMMENT 'SAP SD sales organization code responsible for the intercompany transaction. Represents the selling unit within the issuing entity.',
    `sap_fi_document_number` STRING COMMENT 'SAP FI document number that records this intercompany invoice in the general ledger. Used for reconciliation and audit trail.. Valid values are `^[0-9]{10}$`',
    `sap_intercompany_clearing_account` STRING COMMENT 'General ledger account number used for intercompany clearing and reconciliation in SAP FI. Tracks outstanding balances between entities.. Valid values are `^[0-9]{10}$`',
    `settlement_date` DATE COMMENT 'Date when the intercompany invoice was fully settled (payment received and cleared). Null if not yet settled.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount applicable to this intercompany transaction, including VAT, GST, or other indirect taxes based on jurisdictional requirements.',
    `tax_treatment_code` STRING COMMENT 'Code indicating the tax treatment applicable to this intercompany transaction, such as VAT exemption, reverse charge, or standard rate. Aligns with jurisdictional tax regulations.',
    `transaction_type` STRING COMMENT 'Classification of the intercompany transaction: vehicle_transfer (finished vehicle transfer between entities), ckd_supply (Completely Knocked Down kit supply), skd_supply (Semi Knocked Down kit supply), royalty (intellectual property or brand royalty charges), management_fee (corporate services allocation), shared_service (shared service center charges).. Valid values are `vehicle_transfer|ckd_supply|skd_supply|royalty|management_fee|shared_service`',
    `transfer_price_basis` STRING COMMENT 'Methodology used to determine the transfer price for this intercompany transaction: cost_plus (cost plus markup), market_price (prevailing market rate), arm_length (arms-length principle per OECD), negotiated (bilaterally agreed rate), comparable_uncontrolled (comparable uncontrolled price method).. Valid values are `cost_plus|market_price|arm_length|negotiated|comparable_uncontrolled`',
    `transfer_pricing_policy_reference` STRING COMMENT 'Reference to the internal transfer pricing policy document or agreement that governs this transaction. Used for audit and compliance verification.',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the quantity: EA (each, for vehicles), KIT (for CKD/SKD kits), HR (hours, for shared services), LOT (batch, for bulk transfers).. Valid values are `EA|KIT|HR|LOT`',
    `updated_by_user` STRING COMMENT 'User ID or name of the person who last modified this intercompany invoice record. Used for accountability and audit purposes.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this intercompany invoice record was last modified. Used for audit trail and change tracking.',
    `vehicle_model_code` STRING COMMENT 'Internal model code identifying the vehicle platform or variant being transferred. Used for vehicle_transfer and kit supply transactions.',
    CONSTRAINT pk_intercompany_invoice PRIMARY KEY(`intercompany_invoice_id`)
) COMMENT 'Internal billing document issued between Automotive legal entities or subsidiaries for intercompany vehicle transfers, CKD/SKD kit supply, shared services, or royalty charges. Captures intercompany invoice number, issuing entity, receiving entity, transaction type (vehicle_transfer/CKD_supply/SKD_supply/royalty/management_fee/shared_service), transfer price basis (cost_plus/market_price/arm_length), amount, currency, applicable transfer pricing policy reference, tax treatment, and SAP FI intercompany document reference. Supports global intercompany reconciliation and transfer pricing compliance.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` (
    `parts_service_charge_id` BIGINT COMMENT 'Unique identifier for the parts and service charge record. Primary key for this transaction.',
    `account_id` BIGINT COMMENT 'Foreign key linking to billing.billing_account. Business justification: Service charges are billed to a customers account; linking enables service revenue attribution and account statements.',
    `employee_id` BIGINT COMMENT 'User identifier of the person who approved this charge. Used for audit trail and approval workflow tracking.',
    `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Parts service charges are billed on an invoice; adding invoice_id creates the proper parent link.',
    `parts_employee_id` BIGINT COMMENT 'User identifier of the person who approved this charge. Used for audit trail and approval workflow tracking.',
    `recall_campaign_id` BIGINT COMMENT 'Identifier for the recall campaign if this charge is related to recall parts or repair work. Links charge to manufacturer recall program.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Service charges are billed per vehicle; FK enables service history reconciliation and compliance with warranty regulations.',
    `approval_date` DATE COMMENT 'Date when the charge was approved for billing. Marks transition from pending to approved status in the charge lifecycle.',
    `billing_account_number` STRING COMMENT 'Account number to which this charge is billed. May reference dealer account, retail customer account, or fleet account depending on charge type.',
    `billing_date` DATE COMMENT 'Date when the charge was formally billed to the customer or dealer. Marks the date of invoice generation.',
    `cdk_repair_order_number` STRING COMMENT 'CDK Global DMS repair order reference number. Source system identifier linking charge to the dealer management system repair order.',
    `charge_date` DATE COMMENT 'Date when the parts and service charge was created or incurred. Principal business event timestamp for this transaction.',
    `charge_number` STRING COMMENT 'Business identifier for the parts and service charge. Externally-known unique charge reference number used in billing statements and dispute resolution.',
    `charge_status` STRING COMMENT 'Current lifecycle status of the charge in the billing workflow. Tracks progression from draft through approval, billing, payment, or dispute resolution. [ENUM-REF-CANDIDATE: draft|pending_approval|approved|billed|paid|disputed|cancelled — 7 candidates stripped; promote to reference product]',
    `charge_type` STRING COMMENT 'Classification of the charge based on service context. Distinguishes between warranty claims, retail service, fleet maintenance, recall campaigns, and Technical Service Bulletin (TSB) repairs. [ENUM-REF-CANDIDATE: warranty_parts|warranty_labor|retail_parts|retail_labor|fleet_maintenance|recall_parts|tsb_repair — 7 candidates stripped; promote to reference product]',
    `cost_center` STRING COMMENT 'Cost center code for internal accounting allocation. Used for profitability analysis and departmental cost tracking.',
    `created_by_user` STRING COMMENT 'User identifier of the person or system that created this charge record. Audit field for accountability and traceability.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this charge record was first created in the system. Audit field for record creation tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this charge record. Ensures proper currency handling in multi-currency environments.. Valid values are `^[A-Z]{3}$`',
    `dealer_code` STRING COMMENT 'Unique identifier for the dealership that performed the service and raised the charge. Links charge to the servicing dealer location.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total discount applied to the charge. May include promotional discounts, warranty coverage adjustments, or goodwill credits.',
    `dispute_flag` BOOLEAN COMMENT 'Indicates whether this charge is currently under dispute. True if customer or dealer has contested the charge.',
    `dispute_reason` STRING COMMENT 'Reason code or description for charge dispute. Captures customer or dealer objection to the charge for resolution tracking.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month) within the fiscal year for financial reporting. Enables monthly revenue tracking and variance analysis.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the charge was recognized for financial reporting. Used for period-based revenue analysis.',
    `gl_account_code` STRING COMMENT 'General ledger account code for revenue recognition. Maps charge to appropriate revenue account in the chart of accounts.',
    `labor_amount` DECIMAL(18,2) COMMENT 'Total monetary value of labor charged in this transaction before tax and adjustments. Represents the gross labor cost component.',
    `labor_hours` DECIMAL(18,2) COMMENT 'Total labor hours charged for the service work. Used for labor cost calculation and technician productivity tracking.',
    `labor_operation_code` STRING COMMENT 'Standardized labor operation code identifying the type of service work performed. Used for labor time estimation and billing calculation.',
    `labor_rate` DECIMAL(18,2) COMMENT 'Hourly labor rate applied to this charge. May vary by service type, warranty status, or dealer pricing policy.',
    `notes` STRING COMMENT 'Free-text notes or comments related to the charge. Captures additional context, special circumstances, or billing instructions.',
    `part_number` STRING COMMENT 'OEM (Original Equipment Manufacturer) part number for the primary part charged. References the parts catalog for the component installed or replaced.',
    `parts_amount` DECIMAL(18,2) COMMENT 'Total monetary value of parts charged in this transaction before tax and adjustments. Represents the gross parts cost component.',
    `parts_quantity` DECIMAL(18,2) COMMENT 'Quantity of parts charged in this transaction. Supports fractional quantities for fluids, lubricants, and bulk materials.',
    `profit_center` STRING COMMENT 'Profit center code for internal management reporting. Enables P&L analysis by business unit or service line.',
    `sap_billing_document_number` STRING COMMENT 'SAP SD billing document number generated when this charge is invoiced. Links charge to the formal invoice in the ERP system.',
    `service_date` DATE COMMENT 'Date when the actual service work was performed. May differ from charge date or billing date depending on workflow timing.',
    `service_order_number` STRING COMMENT 'Reference to the originating service order or repair order that generated this charge. Links charge to the after-sales service event.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount applied to the parts and labor charges. Includes sales tax, VAT, or other applicable taxes based on jurisdiction.',
    `total_charge_amount` DECIMAL(18,2) COMMENT 'Net total charge amount after applying parts, labor, tax, and discounts. Final billable amount for this charge record.',
    `tsb_number` STRING COMMENT 'Technical Service Bulletin number if this charge is related to a TSB repair. References manufacturer-issued service bulletin for known issues.',
    `unit_of_measure` STRING COMMENT 'Unit of measure for parts quantity. Common values include EA (each), L (liter), KG (kilogram), M (meter).',
    `updated_by_user` STRING COMMENT 'User identifier of the person or system that last modified this charge record. Audit field for change accountability.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this charge record was last modified. Audit field for change tracking and data lineage.',
    `warranty_claim_number` STRING COMMENT 'Reference to the warranty claim if this charge is associated with warranty parts or labor. Links charge to warranty reimbursement process.',
    CONSTRAINT pk_parts_service_charge PRIMARY KEY(`parts_service_charge_id`)
) COMMENT 'Billing record for after-sales parts and service charges raised against dealer warranty claims, retail service invoices, or fleet maintenance billing. Captures charge number, charge type (warranty_parts/warranty_labor/retail_parts/retail_labor/fleet_maintenance/recall_parts/TSB_repair), service order reference, VIN reference, part numbers charged, labor operation codes, parts amount, labor amount, total charge, billing account, charge status, and CDK Global DMS repair order reference. Bridges aftersales service operations with billing settlement.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`advance_payment` (
    `advance_payment_id` BIGINT COMMENT 'Unique identifier for the advance payment record. Primary key.',
    `employee_id` BIGINT COMMENT 'User ID or username of the person who created this advance payment record in the system.',
    `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Advance payments are often applied to a specific invoice; linking provides traceability.',
    `account_id` BIGINT COMMENT 'Identifier of the account making the advance payment. May reference dealer, fleet customer, or retail customer account.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Advance payments are tied to a specific vehicle order; linking supports finance tracking and downstream invoicing.',
    `advance_amount` DECIMAL(18,2) COMMENT 'Total amount of the advance payment received from the payer.',
    `advance_payment_number` STRING COMMENT 'Business-facing unique reference number for the advance payment, used for external communication and tracking.',
    `advance_type` STRING COMMENT 'Type of advance payment: vehicle deposit, fleet prepayment, dealer advance, booking fee, order deposit, or down payment.. Valid values are `vehicle_deposit|fleet_prepayment|dealer_advance|booking_fee|order_deposit|down_payment`',
    `application_status` STRING COMMENT 'Current status of the advance payment application: open (not yet applied), partially applied (some amount applied), fully applied (entire amount applied), refunded (returned to payer), or expired (no longer valid).. Valid values are `open|partially_applied|fully_applied|refunded|expired`',
    `applied_amount` DECIMAL(18,2) COMMENT 'Cumulative amount of the advance payment that has been applied to invoices or final billing documents.',
    `bank_reference_number` STRING COMMENT 'Bank transaction reference or confirmation number for the advance payment, used for reconciliation with bank statements.',
    `business_area` STRING COMMENT 'Business area or division within the company that the advance payment is attributed to for internal reporting.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity that received the advance payment.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this advance payment record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code for the advance payment amount (e.g., USD, EUR, JPY).. Valid values are `^[A-Z]{3}$`',
    `dealer_code` STRING COMMENT 'Unique code identifying the dealership associated with this advance payment, applicable when payer is a dealer or when payment is for dealer inventory.',
    `expiration_date` DATE COMMENT 'Date after which the advance payment is no longer valid and may be subject to refund or forfeiture per contract terms.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month) within the fiscal year when the advance payment was received.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the advance payment was received, used for financial period reporting.',
    `gl_account_code` STRING COMMENT 'General ledger account code where the advance payment liability is recorded, typically a special GL account for customer down payments.',
    `notes` STRING COMMENT 'Free-text notes or comments regarding the advance payment, including special instructions, exceptions, or additional context.',
    `payer_entity_type` STRING COMMENT 'Classification of the entity making the advance payment: dealer, fleet customer, retail customer, or corporate account.. Valid values are `dealer|fleet_customer|retail_customer|corporate_account`',
    `payment_date` DATE COMMENT 'Date when the advance payment was received from the payer.',
    `payment_method` STRING COMMENT 'Method used to make the advance payment: wire transfer, credit card, debit card, check, cash, ACH, or electronic funds transfer. [ENUM-REF-CANDIDATE: wire_transfer|credit_card|debit_card|check|cash|ach|electronic_funds_transfer — 7 candidates stripped; promote to reference product]',
    `payment_reference_number` STRING COMMENT 'External reference number from the payment processor, bank, or payer system for traceability and reconciliation.',
    `payment_terms_code` STRING COMMENT 'Payment terms code applicable to the transaction for which the advance was received, defining due dates and discount conditions.',
    `payment_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the advance payment transaction was recorded in the system.',
    `posting_date` DATE COMMENT 'Date when the advance payment was posted to the general ledger in the financial system.',
    `profit_center` STRING COMMENT 'Profit center responsible for the revenue associated with this advance payment, used for profitability analysis.',
    `reconciliation_date` DATE COMMENT 'Date when the advance payment was successfully reconciled with bank statements and confirmed in the financial system.',
    `reconciliation_status` STRING COMMENT 'Status of the advance payment reconciliation with bank statements and financial records: pending, reconciled, discrepancy, or under review.. Valid values are `pending|reconciled|discrepancy|under_review`',
    `refund_amount` DECIMAL(18,2) COMMENT 'Amount of the advance payment that has been refunded to the payer due to order cancellation or overpayment.',
    `refund_date` DATE COMMENT 'Date when the advance payment (or portion thereof) was refunded to the payer.',
    `refund_reason_code` STRING COMMENT 'Code indicating the reason for refunding the advance payment, such as order cancellation, overpayment, or customer request.',
    `sales_order_number` STRING COMMENT 'Reference to the sales order document for which this advance payment was received. Links the advance to the vehicle or parts order.',
    `sales_region_code` STRING COMMENT 'Geographic sales region code where the advance payment originated, used for regional revenue tracking.',
    `sap_clearing_document` STRING COMMENT 'SAP FI clearing document number used when the advance payment is applied against an invoice, clearing the down payment liability.',
    `sap_down_payment_document` STRING COMMENT 'SAP FI down payment document number (transaction F-29) that records this advance payment as a special GL transaction.',
    `unapplied_balance` DECIMAL(18,2) COMMENT 'Remaining balance of the advance payment that has not yet been applied to invoices or refunded. Calculated as advance_amount minus applied_amount minus refund_amount.',
    `updated_by_user` STRING COMMENT 'User ID or username of the person who last modified this advance payment record in the system.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this advance payment record was last modified in the system.',
    `value_date` DATE COMMENT 'Date when the funds became available in the company bank account, used for cash flow and treasury management.',
    `vehicle_order_number` STRING COMMENT 'Specific vehicle order reference number associated with this advance payment, used for vehicle deposits and booking fees.',
    CONSTRAINT pk_advance_payment PRIMARY KEY(`advance_payment_id`)
) COMMENT 'Record of advance or deposit payments received from dealers or customers prior to invoice issuance, such as vehicle order deposits, fleet pre-payments, or dealer down payments. Captures advance payment date, payer account, advance type (vehicle_deposit/fleet_prepayment/dealer_advance/booking_fee), advance amount, currency, linked sales order or vehicle order reference, application status (open/partially_applied/fully_applied/refunded), applied amount, refund amount, and SAP FI down payment document reference (F-29). Ensures accurate revenue recognition and liability tracking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`payment_plan` (
    `payment_plan_id` BIGINT COMMENT 'Primary key for payment_plan',
    `account_id` BIGINT COMMENT 'Foreign key linking to billing.account. Business justification: Accounts may have a default payment plan; adding the FK enables direct lookup.',
    `superseded_payment_plan_id` BIGINT COMMENT 'Self-referencing FK on payment_plan (superseded_payment_plan_id)',
    `auto_renewal` BOOLEAN COMMENT 'If true, the plan automatically renews at the end of its term.',
    `billing_cycle` STRING COMMENT 'Definition of the billing period used for invoicing.',
    `billing_day_of_month` STRING COMMENT 'Day of month on which recurring invoices are generated.',
    `collection_status` STRING COMMENT 'Current status of debt collection activities.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the payment plan record was first created.',
    `currency_code` STRING COMMENT 'Three‑letter ISO code of the currency used for the plan.',
    `default_date` DATE COMMENT 'Date when the plan entered default status.',
    `defaulted_flag` BOOLEAN COMMENT 'True if the plan is in default due to missed payments.',
    `payment_plan_description` STRING COMMENT 'Detailed description of the plan, including purpose and key terms.',
    `discount_rate` DECIMAL(18,2) COMMENT 'Percentage discount applied to the total amount.',
    `down_payment_amount` DECIMAL(18,2) COMMENT 'Initial lump‑sum payment required at plan inception.',
    `early_termination_fee` DECIMAL(18,2) COMMENT 'Fee charged if the plan is terminated before its effective end date.',
    `effective_end_date` DATE COMMENT 'Date when the payment plan terminates; null for open‑ended plans.',
    `effective_start_date` DATE COMMENT 'Date when the payment plan becomes binding.',
    `eligibility_criteria` STRING COMMENT 'Business rules that determine which customers may enroll in the plan.',
    `grace_period_days` STRING COMMENT 'Number of days after due date before penalties apply.',
    `installment_amount` DECIMAL(18,2) COMMENT 'Amount due for each regular installment.',
    `interest_rate` DECIMAL(18,2) COMMENT 'Annual percentage rate applied to the outstanding balance.',
    `last_payment_date` DATE COMMENT 'Date when the most recent payment was received.',
    `late_fee_amount` DECIMAL(18,2) COMMENT 'Fixed fee applied when a payment is received after the grace period.',
    `next_payment_due_date` DATE COMMENT 'Date of the next scheduled payment.',
    `notes` STRING COMMENT 'Free‑form comments or special instructions.',
    `number_of_installments` STRING COMMENT 'Total number of installments defined in the plan.',
    `outstanding_balance` DECIMAL(18,2) COMMENT 'Remaining amount due under the plan.',
    `payment_channel` STRING COMMENT 'Channel through which the payment is initiated.',
    `payment_frequency` STRING COMMENT 'Regular interval at which payments are scheduled.',
    `payment_method` STRING COMMENT 'Instrument used to settle payments.',
    `penalty_rate` DECIMAL(18,2) COMMENT 'Percentage applied to overdue balances as a penalty.',
    `plan_code` STRING COMMENT 'External business code used to reference the payment plan in contracts and invoices.',
    `plan_name` STRING COMMENT 'Human‑readable name of the payment plan.',
    `plan_type` STRING COMMENT 'Category of the payment plan indicating the financing model.',
    `promotional_code` STRING COMMENT 'Code representing a marketing promotion linked to the plan.',
    `recurring_amount` DECIMAL(18,2) COMMENT 'Amount that recurs each payment period after down payment.',
    `renewal_flag` BOOLEAN COMMENT 'Indicates whether the plan is eligible for renewal.',
    `payment_plan_status` STRING COMMENT 'Current lifecycle state of the payment plan.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Calculated tax amount based on tax_rate and taxable amount.',
    `tax_exempt_flag` BOOLEAN COMMENT 'Indicates whether the plan is exempt from sales tax.',
    `tax_rate` DECIMAL(18,2) COMMENT 'Applicable tax rate for the plan (if not tax‑exempt).',
    `total_amount` DECIMAL(18,2) COMMENT 'Overall amount to be paid over the life of the plan.',
    `total_paid_amount` DECIMAL(18,2) COMMENT 'Sum of all payments received to date.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the payment plan record.',
    CONSTRAINT pk_payment_plan PRIMARY KEY(`payment_plan_id`)
) COMMENT 'Master reference table for payment_plan. Referenced by payment_plan_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`billing_period` (
    `billing_period_id` BIGINT COMMENT 'Primary key for billing_period',
    `previous_billing_period_id` BIGINT COMMENT 'Self-referencing FK on billing_period (previous_billing_period_id)',
    `billing_cycle_code` STRING COMMENT 'Code representing the billing cycle associated with the period.',
    `billing_frequency` STRING COMMENT 'Frequency at which billing is generated for this period.',
    `close_date` DATE COMMENT 'Date on which the period was closed, if applicable.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the period record was first created.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code applicable to the periods financial amounts.',
    `days_in_period` STRING COMMENT 'Number of calendar days covered by the period.',
    `billing_period_description` STRING COMMENT 'Free‑form description or notes about the period.',
    `fiscal_quarter` STRING COMMENT 'Fiscal quarter identifier for the period.',
    `fiscal_year` STRING COMMENT 'Fiscal year to which the period belongs.',
    `is_closed` BOOLEAN COMMENT 'Indicates whether the period has been closed for posting.',
    `period_end_date` DATE COMMENT 'Last calendar date of the billing period.',
    `period_name` STRING COMMENT 'Human‑readable name of the billing period, e.g., "2023‑04".',
    `period_start_date` DATE COMMENT 'First calendar date of the billing period.',
    `period_type` STRING COMMENT 'Classification of the period (e.g., regular monthly, quarterly, adjustment, forecast).',
    `period_version` STRING COMMENT 'Version number for the period definition, used when revisions occur.',
    `billing_period_status` STRING COMMENT 'Current lifecycle status of the period.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the period record.',
    CONSTRAINT pk_billing_period PRIMARY KEY(`billing_period_id`)
) COMMENT 'Master reference table for billing_period. Referenced by billing_period_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`billing_run` (
    `billing_run_id` BIGINT COMMENT 'Unique identifier for the billing run batch execution. Primary key.',
    `employee_id` BIGINT COMMENT 'User ID of the supervisor or manager who approved the billing run for execution, required for high-value or correction runs.',
    `billing_employee_id` BIGINT COMMENT 'User ID or system account that triggered the billing run, used for audit trail and accountability.',
    `billing_period_id` BIGINT COMMENT 'Foreign key linking to billing.billing_period. Business justification: A billing run belongs to a billing period; linking run to billing_period clarifies the period context.',
    `billing_run_approved_by_user_employee_id` BIGINT COMMENT 'User ID of the supervisor or manager who approved the billing run for execution, required for high-value or correction runs.',
    `billing_run_employee_id` BIGINT COMMENT 'User ID or system account that triggered the billing run, used for audit trail and accountability.',
    `actual_end_timestamp` TIMESTAMP COMMENT 'Actual date and time when the billing run execution completed or failed, used for duration calculation and operational reporting.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when the billing run execution began, used for performance monitoring and variance analysis against scheduled time.',
    `batch_job_reference` STRING COMMENT 'SAP batch job ID or scheduler job reference for the billing run execution, used for technical troubleshooting and job monitoring.. Valid values are `^[A-Z0-9]{8,20}$`',
    `billing_category` STRING COMMENT 'Business classification of the billing scope: vehicle_sales (retail and dealer vehicle invoices), parts (OEM parts and accessories), service (after-sales maintenance and repair), fleet (corporate fleet accounts), export (international sales), warranty (warranty claim reimbursements), lease (leasing contracts), or rental (vehicle rental charges). [ENUM-REF-CANDIDATE: vehicle_sales|parts|service|fleet|export|warranty|lease|rental — 8 candidates stripped; promote to reference product]',
    `billing_date` DATE COMMENT 'The business date on which invoices in this run are dated and become effective for accounting and payment terms calculation. Determines invoice due dates and fiscal period assignment.',
    `billing_due_list_reference` STRING COMMENT 'SAP SD transaction VF04 billing due list execution reference number, linking this run to the SAP billing due list selection and processing log.. Valid values are `^VF04-[A-Z0-9]{10,20}$`',
    `billing_entity_code` STRING COMMENT 'Code identifying the legal entity or company code issuing the invoices in this run, used for multi-entity OEM structures and regional billing organizations.. Valid values are `^[A-Z0-9]{4,10}$`',
    `billing_period_end_date` DATE COMMENT 'End date of the billing period covered by this run, defining the cutoff for transactions included in the batch.',
    `billing_period_start_date` DATE COMMENT 'Start date of the billing period covered by this run, used for periodic billing cycles (e.g., monthly vehicle sales, service contracts).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the billing run record was first created in the system, used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the total billed amount (e.g., USD, EUR, JPY), representing the reporting currency for this run.. Valid values are `^[A-Z]{3}$`',
    `distribution_channel_code` STRING COMMENT 'SAP SD distribution channel code for the billing run (e.g., dealer network, direct sales, online, fleet).. Valid values are `^[A-Z0-9]{2}$`',
    `division_code` STRING COMMENT 'SAP SD division code representing the product line or business segment (e.g., passenger vehicles, commercial trucks, parts, service).. Valid values are `^[A-Z0-9]{2}$`',
    `edi_transmission_status` STRING COMMENT 'Status of EDI 810 invoice transmission for this billing run: not_applicable (no EDI invoices), pending (queued), transmitted (sent to trading partners), acknowledged (receipt confirmed), or failed (transmission error).. Valid values are `not_applicable|pending|transmitted|acknowledged|failed`',
    `error_count` STRING COMMENT 'Total number of errors encountered during the billing run execution, including validation errors, data quality issues, and system exceptions.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month or quarter) within the fiscal year to which the billing run is assigned, used for period-based revenue reporting.. Valid values are `^[0-9]{2,3}$`',
    `fiscal_year` STRING COMMENT 'Fiscal year to which the billing run and generated invoices are assigned for financial reporting and period closing.. Valid values are `^[0-9]{4}$`',
    `notes` STRING COMMENT 'Free-text notes and comments about the billing run execution, including special instructions, known issues, or manual interventions performed.',
    `output_format` STRING COMMENT 'Primary output format for invoices generated in this run: pdf (electronic document), xml (structured data), edi (EDI 810 invoice), print (physical mail), or email (direct delivery).. Valid values are `pdf|xml|edi|print|email`',
    `posting_date` DATE COMMENT 'Date on which the billing run invoices are posted to the financial ledger in SAP FI, determining the accounting period for revenue recognition.',
    `print_queue_name` STRING COMMENT 'Name of the SAP output device or print queue to which invoices were sent for physical printing and mailing.',
    `reversal_date` DATE COMMENT 'Date on which the billing run was reversed and credit memos were issued to cancel the original invoices.',
    `reversal_flag` BOOLEAN COMMENT 'Indicates whether this billing run was subsequently reversed or cancelled, requiring credit memo generation and financial adjustment.',
    `reversal_reason_code` STRING COMMENT 'Code indicating the reason for billing run reversal (e.g., pricing error, wrong billing date, duplicate run, system error).. Valid values are `^[A-Z0-9]{2,4}$`',
    `run_number` STRING COMMENT 'Human-readable business identifier for the billing run, typically formatted as BR-YYYYMMDD-NNNN for traceability and audit purposes.. Valid values are `^BR-[0-9]{8}-[0-9]{4}$`',
    `run_status` STRING COMMENT 'Current lifecycle state of the billing run: scheduled (queued for execution), in_progress (actively processing), completed (successfully finished), failed (terminated with errors), cancelled (aborted by user), or partially_completed (finished with some errors).. Valid values are `scheduled|in_progress|completed|failed|cancelled|partially_completed`',
    `run_type` STRING COMMENT 'Classification of the billing run execution mode: periodic (scheduled recurring), manual (user-initiated), correction (error fix), rerun (retry after failure), ad_hoc (one-time special), or final (end-of-period closing).. Valid values are `periodic|manual|correction|rerun|ad_hoc|final`',
    `sales_organization_code` STRING COMMENT 'SAP SD sales organization responsible for the billing run, representing the commercial unit (e.g., North America Automotive, Europe Commercial Vehicles).. Valid values are `^[A-Z0-9]{4}$`',
    `scheduled_start_timestamp` TIMESTAMP COMMENT 'Planned date and time when the billing run was scheduled to begin execution, used for batch job planning and SLA tracking.',
    `selection_criteria` STRING COMMENT 'Business rules and filters applied to select billing-eligible documents for this run (e.g., customer group, sales order type, delivery date range, billing block status).',
    `total_billed_amount` DECIMAL(18,2) COMMENT 'Sum of all net invoice amounts generated in this billing run, representing the total revenue recognized in the batch.',
    `total_discount_amount` DECIMAL(18,2) COMMENT 'Sum of all discounts, rebates, and allowances applied across invoices in this run, used for pricing analytics and margin analysis.',
    `total_gross_amount` DECIMAL(18,2) COMMENT 'Sum of all gross invoice amounts before discounts and taxes across all invoices in this run, representing the list-price revenue.',
    `total_invoices_failed` STRING COMMENT 'Number of invoice generation attempts that failed due to data errors, validation failures, or system issues during this run.',
    `total_invoices_generated` STRING COMMENT 'Total number of invoice documents successfully created during this billing run, used for volume tracking and reconciliation.',
    `total_tax_amount` DECIMAL(18,2) COMMENT 'Sum of all tax amounts (VAT, sales tax, GST) across all invoices generated in this run, used for tax reporting and reconciliation.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the billing run record was last modified, capturing status changes, error updates, and completion events.',
    `warning_count` STRING COMMENT 'Total number of warnings generated during the billing run, indicating non-critical issues that did not prevent invoice creation but require review.',
    CONSTRAINT pk_billing_run PRIMARY KEY(`billing_run_id`)
) COMMENT 'Batch billing run record representing a scheduled or ad-hoc execution of the invoice generation process for a defined set of billing accounts, order types, or billing dates. Captures run ID, run type (periodic/manual/correction), billing date, billing category (vehicle_sales/parts/service/fleet/export), number of invoices generated, total billed amount, run status (scheduled/in_progress/completed/failed/cancelled), error count, run initiated by, and SAP SD billing due list execution reference (VF04). Provides operational traceability for mass billing cycles.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`billing`.`billing_block` (
    `billing_block_id` BIGINT COMMENT 'Unique identifier for the billing block record. Primary key.',
    `account_id` BIGINT COMMENT 'Foreign key linking to billing.account. Business justification: Blocks can be applied at the account level; adding account_id creates a direct relationship and removes no redundant columns.',
    `employee_id` BIGINT COMMENT 'User ID or system identifier of the person or automated process that applied the billing block.',
    `billing_block_released_by_user_employee_id` BIGINT COMMENT 'User ID or system identifier of the person or automated process that released the billing block.',
    `party_id` BIGINT COMMENT 'Identifier of the customer account associated with the blocked billing document.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer associated with the blocked billing document, if applicable to dealer transactions.',
    `billing_employee_id` BIGINT COMMENT 'User ID or system identifier of the person or automated process that applied the billing block.',
    `billing_party_id` BIGINT COMMENT 'Identifier of the customer account associated with the blocked billing document.',
    `billing_released_by_user_employee_id` BIGINT COMMENT 'User ID or system identifier of the person or automated process that released the billing block.',
    `dispute_id` BIGINT COMMENT 'Identifier of the customer dispute record associated with this billing block, if the block is dispute-related.',
    `recall_campaign_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_recall_campaign. Business justification: Billing blocks must reference active recall campaigns to prevent invoicing for recalled vehicles.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Billing blocks are often placed on a particular vehicle for compliance or credit issues; FK allows block status reporting per VIN.',
    `aging_days` STRING COMMENT 'Number of days the billing block has been active since application, used for aging analysis and escalation triggers.',
    `applied_by_user_name` STRING COMMENT 'Full name of the user who applied the billing block, for business user reference and audit purposes.',
    `applied_date` DATE COMMENT 'Date on which the billing block was applied to the document, preventing invoice generation.',
    `applied_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the billing block was applied, including time-of-day for audit and tracking purposes.',
    `block_number` STRING COMMENT 'Business-facing unique identifier or reference number for the billing block, used for tracking and communication purposes.',
    `block_status` STRING COMMENT 'Current lifecycle status of the billing block. Active blocks prevent invoicing; released blocks have been cleared.. Valid values are `active|released|expired|cancelled`',
    `block_type` STRING COMMENT 'Category of billing block applied. Indicates the reason category for preventing invoice generation.. Valid values are `credit_limit_exceeded|pricing_incomplete|legal_hold|compliance_hold|dispute_hold|manual_hold`',
    `blocked_document_number` STRING COMMENT 'Reference number of the sales order, delivery, or billing account that is blocked from invoicing.',
    `blocked_document_type` STRING COMMENT 'Type of document to which the billing block is applied (e.g., sales order, delivery, billing account).. Valid values are `sales_order|delivery|billing_account|contract`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity to which the blocked billing document belongs.',
    `compliance_hold_reason` STRING COMMENT 'Specific compliance or regulatory reason for the billing hold, such as export control, sanctions screening, or regulatory investigation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this billing block record was first created in the system, for audit trail and data lineage purposes.',
    `credit_exposure_amount` DECIMAL(18,2) COMMENT 'Total credit exposure amount for the customer at the time the billing block was applied, used in credit limit evaluation.',
    `credit_limit_amount` DECIMAL(18,2) COMMENT 'Approved credit limit for the customer at the time of billing block application, used for credit hold decisions.',
    `credit_limit_exceeded_flag` BOOLEAN COMMENT 'Indicates whether the billing block was triggered due to the customer exceeding their approved credit limit.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for credit exposure and limit amounts.. Valid values are `^[A-Z]{3}$`',
    `delivery_number` STRING COMMENT 'Delivery document number associated with the billing block, if the block is applied at the delivery level.',
    `distribution_channel` STRING COMMENT 'SAP distribution channel through which the blocked billing document was processed (e.g., retail, fleet, wholesale).',
    `division` STRING COMMENT 'SAP division or product line associated with the blocked billing document (e.g., passenger vehicles, commercial vehicles, parts).',
    `escalation_date` DATE COMMENT 'Date on which the billing block was escalated for higher-level review or resolution.',
    `escalation_flag` BOOLEAN COMMENT 'Indicates whether the billing block has been escalated to management or a specialized resolution team due to age or complexity.',
    `expected_resolution_date` DATE COMMENT 'Target date by which the billing block is expected to be resolved and released, used for SLA tracking and customer communication.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month or quarter) within the fiscal year when the billing block was applied.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the billing block was applied, used for financial period reporting and analysis.',
    `legal_hold_case_number` STRING COMMENT 'Case or matter number for legal holds, linking the billing block to a specific legal proceeding or investigation.',
    `notes` STRING COMMENT 'General free-text notes or comments related to the billing block, capturing additional context, communications, or resolution actions.',
    `priority` STRING COMMENT 'Priority level assigned to the billing block for resolution workflow and escalation management.. Valid values are `low|medium|high|critical`',
    `reason_code` STRING COMMENT 'Standardized code representing the specific reason for the billing block. Maps to SAP SD billing block reason master data.',
    `reason_description` STRING COMMENT 'Detailed textual description of the reason the billing block was applied, providing context for resolution.',
    `release_date` DATE COMMENT 'Date on which the billing block was released or cleared, allowing invoice generation to proceed.',
    `release_notes` STRING COMMENT 'Free-text notes or comments entered by the user when releasing the billing block, documenting resolution actions taken.',
    `release_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the billing block was released, including time-of-day for audit and SLA tracking.',
    `released_by_user_name` STRING COMMENT 'Full name of the user who released the billing block, for business user reference and audit purposes.',
    `sales_order_number` STRING COMMENT 'Sales order number associated with the blocked document, if applicable. Links the block to the originating sales transaction.',
    `sales_organization` STRING COMMENT 'SAP sales organization code responsible for the blocked billing document.',
    `sap_billing_block_code` STRING COMMENT 'SAP SD system billing block code reference. Maps to SAP configuration table for billing block types and controls.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this billing block record was last modified, for audit trail and change tracking purposes.',
    CONSTRAINT pk_billing_block PRIMARY KEY(`billing_block_id`)
) COMMENT 'Record of a billing block applied to a sales order, delivery, or billing account that prevents invoice generation until the block is resolved. Captures block type (credit_limit_exceeded/pricing_incomplete/legal_hold/compliance_hold/dispute_hold/manual_hold), blocked document reference, block applied date, block applied by, block reason description, release date, released by, and SAP SD billing block code reference. Supports credit management and compliance-driven invoice holds.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_payment_term_id` FOREIGN KEY (`payment_term_id`) REFERENCES `vibe_automotive_v1`.`billing`.`payment_term`(`payment_term_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_billing_price_condition_id` FOREIGN KEY (`billing_price_condition_id`) REFERENCES `vibe_automotive_v1`.`billing`.`billing_price_condition`(`billing_price_condition_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_automotive_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `vibe_automotive_v1`.`billing`.`tax_code`(`tax_code_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_automotive_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_billing_invoice_line_id` FOREIGN KEY (`billing_invoice_line_id`) REFERENCES `vibe_automotive_v1`.`billing`.`billing_invoice_line`(`billing_invoice_line_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_automotive_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_payment_id` FOREIGN KEY (`payment_id`) REFERENCES `vibe_automotive_v1`.`billing`.`payment`(`payment_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_automotive_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ADD CONSTRAINT `fk_billing_debit_memo_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ADD CONSTRAINT `fk_billing_debit_memo_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_automotive_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ADD CONSTRAINT `fk_billing_account_parent_account_id` FOREIGN KEY (`parent_account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ADD CONSTRAINT `fk_billing_receivable_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ADD CONSTRAINT `fk_billing_receivable_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_automotive_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ADD CONSTRAINT `fk_billing_receivable_payment_plan_id` FOREIGN KEY (`payment_plan_id`) REFERENCES `vibe_automotive_v1`.`billing`.`payment_plan`(`payment_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_credit_memo_id` FOREIGN KEY (`credit_memo_id`) REFERENCES `vibe_automotive_v1`.`billing`.`credit_memo`(`credit_memo_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_automotive_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ADD CONSTRAINT `fk_billing_dealer_statement_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ADD CONSTRAINT `fk_billing_fleet_statement_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ADD CONSTRAINT `fk_billing_payment_term_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ADD CONSTRAINT `fk_billing_tax_code_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ADD CONSTRAINT `fk_billing_dunning_record_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ADD CONSTRAINT `fk_billing_rebate_agreement_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ADD CONSTRAINT `fk_billing_rebate_accrual_rebate_agreement_id` FOREIGN KEY (`rebate_agreement_id`) REFERENCES `vibe_automotive_v1`.`billing`.`rebate_agreement`(`rebate_agreement_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_automotive_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ADD CONSTRAINT `fk_billing_intercompany_invoice_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ADD CONSTRAINT `fk_billing_parts_service_charge_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ADD CONSTRAINT `fk_billing_parts_service_charge_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_automotive_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ADD CONSTRAINT `fk_billing_advance_payment_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_automotive_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ADD CONSTRAINT `fk_billing_advance_payment_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ADD CONSTRAINT `fk_billing_payment_plan_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ADD CONSTRAINT `fk_billing_payment_plan_superseded_payment_plan_id` FOREIGN KEY (`superseded_payment_plan_id`) REFERENCES `vibe_automotive_v1`.`billing`.`payment_plan`(`payment_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ADD CONSTRAINT `fk_billing_billing_period_previous_billing_period_id` FOREIGN KEY (`previous_billing_period_id`) REFERENCES `vibe_automotive_v1`.`billing`.`billing_period`(`billing_period_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ADD CONSTRAINT `fk_billing_billing_run_billing_period_id` FOREIGN KEY (`billing_period_id`) REFERENCES `vibe_automotive_v1`.`billing`.`billing_period`(`billing_period_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ADD CONSTRAINT `fk_billing_billing_block_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ADD CONSTRAINT `fk_billing_billing_block_dispute_id` FOREIGN KEY (`dispute_id`) REFERENCES `vibe_automotive_v1`.`billing`.`dispute`(`dispute_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`billing` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_automotive_v1`.`billing` SET TAGS ('dbx_domain' = 'billing');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` SET TAGS ('dbx_subdomain' = 'revenue_collection');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `compliance_emissions_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Emissions Certification Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Salesperson Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `homologation_record_id` SET TAGS ('dbx_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `invoice_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `invoice_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `maintenance_order_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Salesperson Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `service_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `supply_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_address_line1` SET TAGS ('dbx_business_glossary_term' = 'Billing Address Line 1');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_address_line2` SET TAGS ('dbx_business_glossary_term' = 'Billing Address Line 2');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_city` SET TAGS ('dbx_business_glossary_term' = 'Billing City');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_country_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Country Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_entity_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Entity Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_entity_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_postal_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Postal Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_state_province` SET TAGS ('dbx_business_glossary_term' = 'Billing State or Province');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_state_province` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `billing_state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `cancelled_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Invoice Cancelled Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `credit_memo_reference` SET TAGS ('dbx_business_glossary_term' = 'Credit Memo Reference Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `dispute_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Invoice Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Invoice Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `invoice_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `invoice_status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `invoice_status` SET TAGS ('dbx_value_regex' = 'draft|issued|partially_paid|paid|cancelled|disputed');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `invoice_type` SET TAGS ('dbx_business_glossary_term' = 'Invoice Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `invoice_type` SET TAGS ('dbx_value_regex' = 'dealer|retail|fleet|parts|service|warranty');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `msrp_based_flag` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Based Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Invoice Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Invoice Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `outstanding_amount` SET TAGS ('dbx_business_glossary_term' = 'Outstanding Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `paid_amount` SET TAGS ('dbx_business_glossary_term' = 'Paid Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'wire_transfer|check|credit_card|ach|cash|letter_of_credit');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `payment_received_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Received Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `sales_order_number` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `sales_order_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `sales_region_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Region Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `sales_region_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `sap_billing_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Billing Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `sap_billing_document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` SET TAGS ('dbx_subdomain' = 'revenue_collection');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `billing_invoice_line_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Line Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `aftersales_service_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Aftersales Service Appointment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `billing_price_condition_id` SET TAGS ('dbx_business_glossary_term' = 'Price Condition Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Salesperson Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Salesperson Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `repair_order_line_id` SET TAGS ('dbx_business_glossary_term' = 'Repair Order Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `service_contract_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Claim Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `service_subscription_id` SET TAGS ('dbx_business_glossary_term' = 'Service Subscription Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `supply_po_line_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Po Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `tax_code_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `billing_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `credit_memo_reference` SET TAGS ('dbx_business_glossary_term' = 'Credit Memo Reference');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `dealer_code` SET TAGS ('dbx_business_glossary_term' = 'Dealer Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `delivery_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `item_code` SET TAGS ('dbx_business_glossary_term' = 'Item Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `item_description` SET TAGS ('dbx_business_glossary_term' = 'Item Description');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `labor_operation_code` SET TAGS ('dbx_business_glossary_term' = 'Labor Operation Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `line_item_type` SET TAGS ('dbx_business_glossary_term' = 'Line Item Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Line Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `line_status` SET TAGS ('dbx_business_glossary_term' = 'Line Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `line_status` SET TAGS ('dbx_value_regex' = 'open|billed|paid|cancelled|disputed|credited');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `line_total_amount` SET TAGS ('dbx_business_glossary_term' = 'Line Total Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `msrp` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `negotiated_price` SET TAGS ('dbx_business_glossary_term' = 'Negotiated Price');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `promotion_code` SET TAGS ('dbx_business_glossary_term' = 'Promotion Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Quantity');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `revenue_category` SET TAGS ('dbx_business_glossary_term' = 'Revenue Category');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `sales_order_line_number` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Line Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `sales_order_number` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `service_date` SET TAGS ('dbx_business_glossary_term' = 'Service Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `subtotal_amount` SET TAGS ('dbx_business_glossary_term' = 'Subtotal Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Unit Price');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `warranty_code` SET TAGS ('dbx_business_glossary_term' = 'Warranty Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` SET TAGS ('dbx_subdomain' = 'revenue_collection');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `payment_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Payer Entity Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `payment_payer_entity_party_id` SET TAGS ('dbx_business_glossary_term' = 'Payer Entity Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `amount` SET TAGS ('dbx_business_glossary_term' = 'Payment Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `applied_amount` SET TAGS ('dbx_business_glossary_term' = 'Applied Payment Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `authorization_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Authorization Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `authorization_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_business_glossary_term' = 'Payer Bank Account Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `bank_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Bank Reference Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `bank_reference_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `batch_reference` SET TAGS ('dbx_business_glossary_term' = 'Payment Batch Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `channel` SET TAGS ('dbx_business_glossary_term' = 'Payment Channel');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `clearing_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Clearing Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Payment Record Created By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payment Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `currency` SET TAGS ('dbx_business_glossary_term' = 'Payment Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Early Payment Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Payment Dispute Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Payment Dispute Reason');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `lockbox_number` SET TAGS ('dbx_business_glossary_term' = 'Lockbox Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Payment Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `payer_entity_type` SET TAGS ('dbx_business_glossary_term' = 'Payer Entity Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `payer_entity_type` SET TAGS ('dbx_value_regex' = 'dealer|retail_customer|fleet_operator|corporate_account|leasing_company|financial_institution');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `payment_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `payment_number` SET TAGS ('dbx_business_glossary_term' = 'Payment Reference Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `payment_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `processor` SET TAGS ('dbx_business_glossary_term' = 'Payment Processor Name');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `reconciliation_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Reconciliation Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Reconciliation Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_value_regex' = 'unreconciled|reconciled|disputed|under_review');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `remittance_advice` SET TAGS ('dbx_business_glossary_term' = 'Remittance Advice');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `return_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Return Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `return_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Return Reason Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `routing_number` SET TAGS ('dbx_business_glossary_term' = 'Bank Routing Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `routing_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `sap_clearing_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Financial Accounting (FI) Clearing Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `sap_payment_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Financial Accounting (FI) Payment Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `transaction_reference` SET TAGS ('dbx_business_glossary_term' = 'Payment Transaction Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `transaction_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `unapplied_amount` SET TAGS ('dbx_business_glossary_term' = 'Unapplied Payment Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `updated_by_user` SET TAGS ('dbx_business_glossary_term' = 'Payment Record Updated By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payment Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` SET TAGS ('dbx_subdomain' = 'revenue_collection');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `payment_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Allocation Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `billing_invoice_line_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Line Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `payment_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Allocated By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `payment_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `payment_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `payment_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `primary_payment_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Allocated By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `primary_payment_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `primary_payment_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocated_amount` SET TAGS ('dbx_business_glossary_term' = 'Allocated Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocated_amount_base_currency` SET TAGS ('dbx_business_glossary_term' = 'Allocated Amount in Base Currency');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Allocation Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Allocation Method');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_method` SET TAGS ('dbx_value_regex' = 'automatic|manual|system_proposed|batch_clearing');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_number` SET TAGS ('dbx_business_glossary_term' = 'Payment Allocation Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_priority` SET TAGS ('dbx_business_glossary_term' = 'Payment Allocation Priority');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Allocation Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_status` SET TAGS ('dbx_value_regex' = 'pending|cleared|reversed|disputed|reconciled|voided');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Payment Allocation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_type` SET TAGS ('dbx_business_glossary_term' = 'Payment Allocation Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `allocation_type` SET TAGS ('dbx_value_regex' = 'full|partial|advance|overpayment|credit_memo|adjustment');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `business_area` SET TAGS ('dbx_business_glossary_term' = 'Business Area');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `business_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_business_glossary_term' = 'Clearing Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `clearing_status` SET TAGS ('dbx_business_glossary_term' = 'Clearing Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `clearing_status` SET TAGS ('dbx_value_regex' = 'open|cleared|partially_cleared|reset');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,15}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `dealer_code` SET TAGS ('dbx_business_glossary_term' = 'Dealer Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `dealer_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Cash Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Cash Discount Percentage');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `dispute_indicator` SET TAGS ('dbx_business_glossary_term' = 'Dispute Indicator');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Foreign Exchange (FX) Rate');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Allocation Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Financial Posting Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `profit_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_business_glossary_term' = 'Reconciliation Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_value_regex' = 'pending|reconciled|exception|under_review');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `remaining_invoice_balance` SET TAGS ('dbx_business_glossary_term' = 'Remaining Invoice Balance');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `reversal_date` SET TAGS ('dbx_business_glossary_term' = 'Reversal Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `reversal_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `reversal_reason_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,6}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ALTER COLUMN `value_date` SET TAGS ('dbx_business_glossary_term' = 'Value Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` SET TAGS ('dbx_subdomain' = 'revenue_collection');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `credit_memo_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Memo ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `aftersales_warranty_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `credit_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `credit_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `credit_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `credit_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `credit_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `dealer_incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `recall_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Recall Campaign ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `approver_name` SET TAGS ('dbx_business_glossary_term' = 'Approver Name');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `credit_memo_number` SET TAGS ('dbx_business_glossary_term' = 'Credit Memo Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `credit_memo_number` SET TAGS ('dbx_value_regex' = '^CM[0-9]{10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `credit_memo_status` SET TAGS ('dbx_business_glossary_term' = 'Credit Memo Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `credit_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Credit Reason Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `credit_type` SET TAGS ('dbx_business_glossary_term' = 'Credit Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `credit_type` SET TAGS ('dbx_value_regex' = 'full_reversal|partial_adjustment|volume_incentive|warranty_claim|recall_compensation');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `dispute_id` SET TAGS ('dbx_business_glossary_term' = 'Dispute ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `gross_credit_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Credit Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Credit Memo Issue Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `net_credit_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Credit Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Credit Memo Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `reference_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `sap_accounting_document` SET TAGS ('dbx_business_glossary_term' = 'SAP (Systems Applications and Products) Accounting Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `sap_billing_document` SET TAGS ('dbx_business_glossary_term' = 'SAP (Systems Applications and Products) Billing Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `sap_credit_memo_document` SET TAGS ('dbx_business_glossary_term' = 'SAP (Systems Applications and Products) Credit Memo Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `tax_credit_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Credit Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `vehicle_model` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Model');
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` SET TAGS ('dbx_subdomain' = 'revenue_collection');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `debit_memo_id` SET TAGS ('dbx_business_glossary_term' = 'Debit Memo Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Originating Invoice Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `primary_debit_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'DRAFT|PENDING_APPROVAL|APPROVED|REJECTED|CANCELLED');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `debit_amount` SET TAGS ('dbx_business_glossary_term' = 'Debit Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `debit_memo_number` SET TAGS ('dbx_business_glossary_term' = 'Debit Memo Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `debit_memo_number` SET TAGS ('dbx_value_regex' = '^DM[0-9]{10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `debit_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Debit Reason Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `debit_reason_description` SET TAGS ('dbx_business_glossary_term' = 'Debit Reason Description');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `dispute_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Issue Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Internal Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `payment_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `payment_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `payment_status` SET TAGS ('dbx_value_regex' = 'UNPAID|PARTIALLY_PAID|PAID|DISPUTED|WRITTEN_OFF');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `resolution_notes` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `sap_fi_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Financial Accounting (FI) Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `sap_sd_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Sales and Distribution (SD) Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `total_debit_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Debit Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` SET TAGS ('dbx_subdomain' = 'revenue_collection');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Account ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `parent_account_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Billing Account ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `account_number` SET TAGS ('dbx_business_glossary_term' = 'Billing Account Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `account_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `account_status` SET TAGS ('dbx_business_glossary_term' = 'Billing Account Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `account_status` SET TAGS ('dbx_value_regex' = 'active|suspended|closed|pending_approval|blocked|dormant');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `account_type` SET TAGS ('dbx_business_glossary_term' = 'Billing Account Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `account_type` SET TAGS ('dbx_value_regex' = 'dealer|retail|fleet|corporate|government|export');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `auto_pay_enrolled_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto Pay Enrolled Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_address_line1` SET TAGS ('dbx_business_glossary_term' = 'Billing Address Line 1');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_address_line2` SET TAGS ('dbx_business_glossary_term' = 'Billing Address Line 2');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_city` SET TAGS ('dbx_business_glossary_term' = 'Billing City');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Billing Contact Email Address');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Billing Contact Name');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_contact_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_contact_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Billing Contact Phone Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_country_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Country Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_postal_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Postal Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_state_province` SET TAGS ('dbx_business_glossary_term' = 'Billing State or Province');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_state_province` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `billing_state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `closed_date` SET TAGS ('dbx_business_glossary_term' = 'Account Closed Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `consolidated_billing_flag` SET TAGS ('dbx_business_glossary_term' = 'Consolidated Billing Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `credit_check_date` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `credit_exposure_amount` SET TAGS ('dbx_business_glossary_term' = 'Credit Exposure Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `credit_exposure_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `credit_limit_amount` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `credit_limit_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `credit_rating_code` SET TAGS ('dbx_business_glossary_term' = 'Credit Rating Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `credit_rating_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `dispute_count_ytd` SET TAGS ('dbx_business_glossary_term' = 'Dispute Count Year-to-Date (YTD)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `division_code` SET TAGS ('dbx_business_glossary_term' = 'Division Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `division_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `dms_account_code` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Account ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `dunning_block_flag` SET TAGS ('dbx_business_glossary_term' = 'Dunning Block Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `dunning_level` SET TAGS ('dbx_business_glossary_term' = 'Dunning Level');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `invoice_delivery_method` SET TAGS ('dbx_business_glossary_term' = 'Invoice Delivery Method');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `invoice_delivery_method` SET TAGS ('dbx_value_regex' = 'email|postal_mail|edi|portal|fax');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `invoice_email_address` SET TAGS ('dbx_business_glossary_term' = 'Invoice Email Address');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `invoice_email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `invoice_email_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `invoice_email_address` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `last_invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Last Invoice Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `last_payment_amount` SET TAGS ('dbx_business_glossary_term' = 'Last Payment Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `last_payment_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `last_payment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Payment Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `account_name` SET TAGS ('dbx_business_glossary_term' = 'Billing Account Name');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `account_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `opened_date` SET TAGS ('dbx_business_glossary_term' = 'Account Opened Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `payment_method_preference` SET TAGS ('dbx_business_glossary_term' = 'Payment Method Preference');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `payment_method_preference` SET TAGS ('dbx_value_regex' = 'wire_transfer|ach|check|credit_card|direct_debit|letter_of_credit');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `payment_performance_score` SET TAGS ('dbx_business_glossary_term' = 'Payment Performance Score');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `payment_performance_score` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `payment_terms_days` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Days');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `sap_customer_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Customer Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `sap_customer_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `tax_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Tax Registration Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `tax_registration_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `tax_registration_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `vat_number` SET TAGS ('dbx_business_glossary_term' = 'Value Added Tax (VAT) ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `vat_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ALTER COLUMN `vat_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` SET TAGS ('dbx_subdomain' = 'revenue_collection');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `receivable_id` SET TAGS ('dbx_business_glossary_term' = 'Receivable Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Account Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `payment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Plan Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Collector Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `receivable_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Collector Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `receivable_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `receivable_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `aging_bucket` SET TAGS ('dbx_business_glossary_term' = 'Accounts Receivable (AR) Aging Bucket');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `aging_bucket` SET TAGS ('dbx_value_regex' = 'current|1_30_days|31_60_days|61_90_days|91_120_days|over_120_days');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `closed_date` SET TAGS ('dbx_business_glossary_term' = 'Receivable Closure Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `collection_status` SET TAGS ('dbx_business_glossary_term' = 'Collection Activity Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `credit_hold_flag` SET TAGS ('dbx_business_glossary_term' = 'Credit Hold Indicator Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `customer_type` SET TAGS ('dbx_business_glossary_term' = 'Customer Type Segment');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `customer_type` SET TAGS ('dbx_value_regex' = 'dealer|retail|fleet|government|rental|leasing');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `days_past_due` SET TAGS ('dbx_business_glossary_term' = 'Days Past Due Count');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `dealer_code` SET TAGS ('dbx_business_glossary_term' = 'Dealer Code Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `dealer_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{5,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `dispute_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Initiation Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Indicator Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `dispute_reference` SET TAGS ('dbx_business_glossary_term' = 'Dispute Case Reference Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `dunning_level` SET TAGS ('dbx_business_glossary_term' = 'Dunning Level Escalation');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Issue Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `last_contact_date` SET TAGS ('dbx_business_glossary_term' = 'Last Customer Contact Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `last_dunning_date` SET TAGS ('dbx_business_glossary_term' = 'Last Dunning Notice Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `next_dunning_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Dunning Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `original_amount` SET TAGS ('dbx_business_glossary_term' = 'Original Invoice Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `outstanding_balance` SET TAGS ('dbx_business_glossary_term' = 'Outstanding Balance Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `payment_plan_flag` SET TAGS ('dbx_business_glossary_term' = 'Payment Plan Active Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `profit_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `receivable_number` SET TAGS ('dbx_business_glossary_term' = 'Receivable Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `receivable_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}-[0-9]{8,12}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `receivable_status` SET TAGS ('dbx_business_glossary_term' = 'Receivable Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `receivable_type` SET TAGS ('dbx_business_glossary_term' = 'Receivable Type Classification');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `sales_region` SET TAGS ('dbx_business_glossary_term' = 'Sales Region Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `sap_fi_company_code` SET TAGS ('dbx_business_glossary_term' = 'SAP Company Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `sap_fi_company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `sap_fi_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Financial Accounting (FI) Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `sap_fi_document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `write_off_amount` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `write_off_date` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Transaction Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `write_off_flag` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Indicator Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ALTER COLUMN `write_off_reason` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Reason Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` SET TAGS ('dbx_subdomain' = 'revenue_collection');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `dispute_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Dispute Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `credit_memo_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Memo Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Analyst Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `dispute_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Analyst Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `dispute_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `dispute_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Disputing Party Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `business_unit` SET TAGS ('dbx_business_glossary_term' = 'Business Unit');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `closed_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Closed Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `contact_email` SET TAGS ('dbx_business_glossary_term' = 'Contact Email Address');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Contact Phone Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `contact_phone` SET TAGS ('dbx_value_regex' = '^+?[0-9]{1,4}?[-.s]?(?[0-9]{1,3}?)?[-.s]?[0-9]{1,4}[-.s]?[0-9]{1,4}[-.s]?[0-9]{1,9}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `credited_amount` SET TAGS ('dbx_business_glossary_term' = 'Credited Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `dispute_number` SET TAGS ('dbx_business_glossary_term' = 'Dispute Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `dispute_number` SET TAGS ('dbx_value_regex' = '^DSP-[0-9]{10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `dispute_status` SET TAGS ('dbx_business_glossary_term' = 'Dispute Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `dispute_status` SET TAGS ('dbx_value_regex' = 'open|under_review|resolved|escalated|closed|withdrawn');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `dispute_type` SET TAGS ('dbx_business_glossary_term' = 'Dispute Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `dispute_type` SET TAGS ('dbx_value_regex' = 'pricing|quantity|quality|duplicate|unauthorized_charge|warranty');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `disputed_amount` SET TAGS ('dbx_business_glossary_term' = 'Disputed Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `disputing_party_type` SET TAGS ('dbx_business_glossary_term' = 'Disputing Party Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `disputing_party_type` SET TAGS ('dbx_value_regex' = 'dealer|fleet_operator|retail_customer|internal');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `escalation_date` SET TAGS ('dbx_business_glossary_term' = 'Escalation Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `escalation_level` SET TAGS ('dbx_business_glossary_term' = 'Escalation Level');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `escalation_reason` SET TAGS ('dbx_business_glossary_term' = 'Escalation Reason');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `open_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Open Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Dispute Priority');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `reason_description` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason Description');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `received_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Dispute Received Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Resolution Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `resolution_notes` SET TAGS ('dbx_business_glossary_term' = 'Resolution Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `resolution_type` SET TAGS ('dbx_business_glossary_term' = 'Resolution Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `resolution_type` SET TAGS ('dbx_value_regex' = 'accepted|rejected|partial_credit|adjustment|waiver');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'billing_error|system_error|data_entry_error|policy_misunderstanding|delivery_issue|quality_issue');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `sla_target_resolution_days` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Target Resolution Days');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ALTER COLUMN `supporting_document_count` SET TAGS ('dbx_business_glossary_term' = 'Supporting Document Count');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` SET TAGS ('dbx_subdomain' = 'statement_processing');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `dealer_statement_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Statement ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Issued By User ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `dealer_issued_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Issued By User ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `dealer_issued_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `dealer_issued_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `aging_bucket_30_days_amount` SET TAGS ('dbx_business_glossary_term' = 'Aging Bucket 30 Days Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `aging_bucket_60_days_amount` SET TAGS ('dbx_business_glossary_term' = 'Aging Bucket 60 Days Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `aging_bucket_90_days_amount` SET TAGS ('dbx_business_glossary_term' = 'Aging Bucket 90 Days Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `aging_bucket_current_amount` SET TAGS ('dbx_business_glossary_term' = 'Aging Bucket Current Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `aging_bucket_over_90_days_amount` SET TAGS ('dbx_business_glossary_term' = 'Aging Bucket Over 90 Days Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `billing_cycle_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Cycle Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `billing_cycle_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `cdk_statement_reference` SET TAGS ('dbx_business_glossary_term' = 'CDK (CDK Global) Statement Reference');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `closing_balance_amount` SET TAGS ('dbx_business_glossary_term' = 'Closing Balance Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `dispute_amount` SET TAGS ('dbx_business_glossary_term' = 'Dispute Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `dispute_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `dispute_reason_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^[0-9]{2}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `floorplan_financing_flag` SET TAGS ('dbx_business_glossary_term' = 'Floorplan Financing Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `opening_balance_amount` SET TAGS ('dbx_business_glossary_term' = 'Opening Balance Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `payment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `reconciliation_date` SET TAGS ('dbx_business_glossary_term' = 'Reconciliation Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `statement_date` SET TAGS ('dbx_business_glossary_term' = 'Statement Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `statement_notes` SET TAGS ('dbx_business_glossary_term' = 'Statement Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `statement_number` SET TAGS ('dbx_business_glossary_term' = 'Statement Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `statement_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `statement_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Statement Period End Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `statement_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Statement Period Start Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `statement_status` SET TAGS ('dbx_business_glossary_term' = 'Statement Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `statement_status` SET TAGS ('dbx_value_regex' = 'draft|issued|acknowledged|disputed|reconciled|closed');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `statement_type` SET TAGS ('dbx_business_glossary_term' = 'Statement Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `statement_type` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|ad_hoc|final|interim');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `total_adjustment_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Adjustment Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `total_credit_memo_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Credit Memo Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `total_debit_memo_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Debit Memo Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `total_incentive_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Incentive Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `total_invoice_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Invoice Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `total_parts_sales_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Parts Sales Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `total_payment_received_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Payment Received Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `total_service_charges_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Service Charges Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `total_vehicle_sales_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Vehicle Sales Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ALTER COLUMN `total_warranty_reimbursement_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Warranty Reimbursement Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` SET TAGS ('dbx_subdomain' = 'statement_processing');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `fleet_statement_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Statement ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `customer_fleet_account_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Account ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Statement Approved By');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Statement Approved Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_address_line1` SET TAGS ('dbx_business_glossary_term' = 'Billing Address Line 1');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_address_line2` SET TAGS ('dbx_business_glossary_term' = 'Billing Address Line 2');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_city` SET TAGS ('dbx_business_glossary_term' = 'Billing City');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_country_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Country Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_cycle_end_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Cycle End Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_cycle_start_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Cycle Start Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_postal_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Postal Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_state_province` SET TAGS ('dbx_business_glossary_term' = 'Billing State or Province');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_state_province` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `billing_state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `contact_name` SET TAGS ('dbx_business_glossary_term' = 'Fleet Account Contact Name');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `contact_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Fleet Account Contact Phone');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `delivery_email` SET TAGS ('dbx_business_glossary_term' = 'Statement Delivery Email');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `delivery_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `delivery_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `delivery_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `delivery_method` SET TAGS ('dbx_business_glossary_term' = 'Statement Delivery Method');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `delivery_method` SET TAGS ('dbx_value_regex' = 'email|postal_mail|portal|edi');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `dispute_amount` SET TAGS ('dbx_business_glossary_term' = 'Disputed Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `fleet_management_fees` SET TAGS ('dbx_business_glossary_term' = 'Fleet Management Fees');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `fuel_charges` SET TAGS ('dbx_business_glossary_term' = 'Fuel Charges');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `insurance_charges` SET TAGS ('dbx_business_glossary_term' = 'Insurance Charges');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Statement Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `outstanding_balance` SET TAGS ('dbx_business_glossary_term' = 'Outstanding Balance');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `parts_charges` SET TAGS ('dbx_business_glossary_term' = 'Parts Charges');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `previous_balance` SET TAGS ('dbx_business_glossary_term' = 'Previous Balance');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `service_charges` SET TAGS ('dbx_business_glossary_term' = 'Service Charges');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `statement_date` SET TAGS ('dbx_business_glossary_term' = 'Statement Issue Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `statement_number` SET TAGS ('dbx_business_glossary_term' = 'Fleet Statement Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `statement_number` SET TAGS ('dbx_value_regex' = '^FS-[0-9]{8}-[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `statement_status` SET TAGS ('dbx_business_glossary_term' = 'Fleet Statement Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `statement_status` SET TAGS ('dbx_value_regex' = 'draft|issued|partially_paid|paid|overdue|disputed');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `tco_summary_flag` SET TAGS ('dbx_business_glossary_term' = 'Total Cost of Ownership (TCO) Summary Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `telematics_subscription_charges` SET TAGS ('dbx_business_glossary_term' = 'Telematics Subscription Charges');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `total_charges` SET TAGS ('dbx_business_glossary_term' = 'Total Charges');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `total_credits` SET TAGS ('dbx_business_glossary_term' = 'Total Credits');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `total_payments_received` SET TAGS ('dbx_business_glossary_term' = 'Total Payments Received');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `total_vehicles_billed` SET TAGS ('dbx_business_glossary_term' = 'Total Vehicles Billed');
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ALTER COLUMN `vehicle_acquisition_charges` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Acquisition Charges');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` SET TAGS ('dbx_subdomain' = 'pricing_terms');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `billing_price_condition_id` SET TAGS ('dbx_business_glossary_term' = 'Price Condition ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `approval_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Approval Required Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `calculation_type` SET TAGS ('dbx_business_glossary_term' = 'Calculation Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `calculation_type` SET TAGS ('dbx_value_regex' = 'fixed|percentage|quantity_based|tiered|formula');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `condition_class` SET TAGS ('dbx_business_glossary_term' = 'Condition Class');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `condition_class` SET TAGS ('dbx_value_regex' = 'price|discount|surcharge|tax|freight');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `condition_description` SET TAGS ('dbx_business_glossary_term' = 'Condition Description');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `condition_exclusion_flag` SET TAGS ('dbx_business_glossary_term' = 'Condition Exclusion Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `condition_record_number` SET TAGS ('dbx_business_glossary_term' = 'Condition Record Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `condition_status` SET TAGS ('dbx_business_glossary_term' = 'Condition Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `condition_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|expired|suspended');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `condition_step_number` SET TAGS ('dbx_business_glossary_term' = 'Condition Step Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `condition_type` SET TAGS ('dbx_business_glossary_term' = 'Condition Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `condition_unit` SET TAGS ('dbx_business_glossary_term' = 'Condition Unit');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `condition_unit` SET TAGS ('dbx_value_regex' = 'amount|percentage|per_unit|per_vehicle');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `condition_value` SET TAGS ('dbx_business_glossary_term' = 'Condition Value');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `customer_type` SET TAGS ('dbx_business_glossary_term' = 'Customer Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `customer_type` SET TAGS ('dbx_value_regex' = 'retail|fleet|dealer|government|commercial');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `dealer_code` SET TAGS ('dbx_business_glossary_term' = 'Dealer Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `effective_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Effective End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `effective_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `is_current_flag` SET TAGS ('dbx_business_glossary_term' = 'Is Current Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `manual_override_allowed_flag` SET TAGS ('dbx_business_glossary_term' = 'Manual Override Allowed Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `pricing_procedure_code` SET TAGS ('dbx_business_glossary_term' = 'Pricing Procedure Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `sales_region_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Region Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `sap_condition_table` SET TAGS ('dbx_business_glossary_term' = 'SAP Condition Table');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `sap_konp_record_number` SET TAGS ('dbx_business_glossary_term' = 'SAP KONP Record Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `sap_konv_counter` SET TAGS ('dbx_business_glossary_term' = 'SAP KONV Counter');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `scale_basis` SET TAGS ('dbx_business_glossary_term' = 'Scale Basis');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `scale_basis` SET TAGS ('dbx_value_regex' = 'quantity|value|weight|volume');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `scale_quantity_from` SET TAGS ('dbx_business_glossary_term' = 'Scale Quantity From');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `scale_quantity_to` SET TAGS ('dbx_business_glossary_term' = 'Scale Quantity To');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `vehicle_trim_level` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Trim Level');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` SET TAGS ('dbx_subdomain' = 'pricing_terms');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `applicable_account_types` SET TAGS ('dbx_business_glossary_term' = 'Applicable Account Types');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `approval_required` SET TAGS ('dbx_business_glossary_term' = 'Approval Required');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `auto_dunning_enabled` SET TAGS ('dbx_business_glossary_term' = 'Automatic Dunning Enabled');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `baseline_date_rule` SET TAGS ('dbx_business_glossary_term' = 'Baseline Date Rule');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `baseline_date_rule` SET TAGS ('dbx_value_regex' = 'invoice_date|delivery_date|month_end|custom');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `business_unit_code` SET TAGS ('dbx_business_glossary_term' = 'Business Unit Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `business_unit_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,6}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `payment_term_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `payment_term_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `credit_check_required` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Required');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `payment_term_description` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Description');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `discount_days_1` SET TAGS ('dbx_business_glossary_term' = 'Discount Days 1');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `discount_days_2` SET TAGS ('dbx_business_glossary_term' = 'Discount Days 2');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `discount_percentage_1` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage 1');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `discount_percentage_2` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage 2');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `dunning_level` SET TAGS ('dbx_business_glossary_term' = 'Dunning Level');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `fixed_day_of_month` SET TAGS ('dbx_business_glossary_term' = 'Fixed Day of Month');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `maximum_order_value` SET TAGS ('dbx_business_glossary_term' = 'Maximum Order Value');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `minimum_order_value` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Value');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `payment_term_name` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Name');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `net_due_days` SET TAGS ('dbx_business_glossary_term' = 'Net Due Days');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `payment_method_restriction` SET TAGS ('dbx_business_glossary_term' = 'Payment Method Restriction');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `payment_term_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `payment_term_status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated|pending_approval');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `penalty_calculation_method` SET TAGS ('dbx_business_glossary_term' = 'Penalty Calculation Method');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `penalty_calculation_method` SET TAGS ('dbx_value_regex' = 'daily|monthly|flat_fee|none');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `penalty_grace_days` SET TAGS ('dbx_business_glossary_term' = 'Penalty Grace Days');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `penalty_rate` SET TAGS ('dbx_business_glossary_term' = 'Penalty Rate');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `sap_fi_payment_term_key` SET TAGS ('dbx_business_glossary_term' = 'SAP FI (Financial Accounting) Payment Term Key');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `sap_fi_payment_term_key` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `usage_count` SET TAGS ('dbx_business_glossary_term' = 'Usage Count');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_term` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` SET TAGS ('dbx_subdomain' = 'pricing_terms');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `tax_code_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `applicable_transaction_types` SET TAGS ('dbx_business_glossary_term' = 'Applicable Transaction Types');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `calculation_method` SET TAGS ('dbx_business_glossary_term' = 'Calculation Method');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `calculation_method` SET TAGS ('dbx_value_regex' = 'percentage|fixed_amount|tiered|formula_based');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `tax_code_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `tax_code_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `exemption_certificate_required` SET TAGS ('dbx_business_glossary_term' = 'Exemption Certificate Required Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_value_regex' = '^[0-9]{4,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `is_deductible` SET TAGS ('dbx_business_glossary_term' = 'Is Deductible Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `is_recoverable` SET TAGS ('dbx_business_glossary_term' = 'Is Recoverable Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `jurisdiction_code` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `jurisdiction_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}(-[A-Z0-9]{2,5})?$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `jurisdiction_level` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Level');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `jurisdiction_level` SET TAGS ('dbx_value_regex' = 'federal|state|local|eu|apac|multi_jurisdiction');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `tax_code_name` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Name');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `reporting_code` SET TAGS ('dbx_business_glossary_term' = 'Reporting Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `reverse_charge_applicable` SET TAGS ('dbx_business_glossary_term' = 'Reverse Charge Applicable Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `rounding_precision` SET TAGS ('dbx_business_glossary_term' = 'Rounding Precision');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `rounding_rule` SET TAGS ('dbx_business_glossary_term' = 'Rounding Rule');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `rounding_rule` SET TAGS ('dbx_value_regex' = 'round_up|round_down|round_nearest|no_rounding');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `sap_fi_tax_code` SET TAGS ('dbx_business_glossary_term' = 'SAP Financial Accounting (FI) Tax Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `sap_fi_tax_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `sap_sd_tax_code` SET TAGS ('dbx_business_glossary_term' = 'SAP Sales and Distribution (SD) Tax Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `sap_sd_tax_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `tax_authority_name` SET TAGS ('dbx_business_glossary_term' = 'Tax Authority Name');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `tax_authority_reference` SET TAGS ('dbx_business_glossary_term' = 'Tax Authority Reference');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `tax_basis` SET TAGS ('dbx_business_glossary_term' = 'Tax Basis');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `tax_basis` SET TAGS ('dbx_value_regex' = 'net_amount|gross_amount|msrp|invoice_value|customs_value');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `tax_category` SET TAGS ('dbx_business_glossary_term' = 'Tax Category');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `tax_category` SET TAGS ('dbx_value_regex' = 'input_tax|output_tax|withholding_tax|reverse_charge|exempt|zero_rated');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `tax_code_status` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `tax_code_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|superseded');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `tax_rate_percentage` SET TAGS ('dbx_business_glossary_term' = 'Tax Rate Percentage');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `tax_type` SET TAGS ('dbx_business_glossary_term' = 'Tax Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `tax_type` SET TAGS ('dbx_value_regex' = 'vat|gst|sales_tax|excise|luxury_tax|environmental_levy');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `withholding_tax_applicable` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax Applicable Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`tax_code` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` SET TAGS ('dbx_subdomain' = 'revenue_collection');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_record_id` SET TAGS ('dbx_business_glossary_term' = 'Dunning Record Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Account Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Collector Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Collector Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `account_type` SET TAGS ('dbx_business_glossary_term' = 'Account Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `account_type` SET TAGS ('dbx_value_regex' = 'dealer|fleet|retail|commercial|government');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `credit_exposure` SET TAGS ('dbx_business_glossary_term' = 'Credit Exposure');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `credit_exposure` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `credit_limit` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `credit_limit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `customer_segment` SET TAGS ('dbx_business_glossary_term' = 'Customer Segment');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `customer_segment` SET TAGS ('dbx_value_regex' = 'premium|standard|high_risk|vip|new');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `days_overdue` SET TAGS ('dbx_business_glossary_term' = 'Days Overdue');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `delivery_address` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `delivery_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `delivery_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_block_date` SET TAGS ('dbx_business_glossary_term' = 'Dunning Block Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_block_flag` SET TAGS ('dbx_business_glossary_term' = 'Dunning Block Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_block_reason` SET TAGS ('dbx_business_glossary_term' = 'Dunning Block Reason');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_block_reason` SET TAGS ('dbx_value_regex' = 'dispute_under_review|payment_plan_active|legal_hold|customer_bankruptcy|account_closed|manual_block');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_fee_amount` SET TAGS ('dbx_business_glossary_term' = 'Dunning Fee Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_level` SET TAGS ('dbx_business_glossary_term' = 'Dunning Level');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3|legal');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_notice_delivery_method` SET TAGS ('dbx_business_glossary_term' = 'Dunning Notice Delivery Method');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_notice_delivery_method` SET TAGS ('dbx_value_regex' = 'email|postal_mail|customer_portal|fax|sms');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_notice_sent_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Dunning Notice Sent Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_notice_type` SET TAGS ('dbx_business_glossary_term' = 'Dunning Notice Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_notice_type` SET TAGS ('dbx_value_regex' = 'reminder|warning|final_demand|legal_notice|suspension_notice|account_hold');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_run_date` SET TAGS ('dbx_business_glossary_term' = 'Dunning Run Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_run_number` SET TAGS ('dbx_business_glossary_term' = 'Dunning Run Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_run_number` SET TAGS ('dbx_value_regex' = '^DUN-[0-9]{8}-[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `dunning_status` SET TAGS ('dbx_business_glossary_term' = 'Dunning Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `interest_amount` SET TAGS ('dbx_business_glossary_term' = 'Interest Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `next_action_date` SET TAGS ('dbx_business_glossary_term' = 'Next Action Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `next_action_type` SET TAGS ('dbx_business_glossary_term' = 'Next Action Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `next_action_type` SET TAGS ('dbx_value_regex' = 'phone_call|email_follow_up|escalate_level|legal_referral|account_suspension|write_off_review');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `oldest_overdue_date` SET TAGS ('dbx_business_glossary_term' = 'Oldest Overdue Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `overdue_item_count` SET TAGS ('dbx_business_glossary_term' = 'Overdue Item Count');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `payment_promise_amount` SET TAGS ('dbx_business_glossary_term' = 'Payment Promise Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `payment_promise_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Promise Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Resolution Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `resolution_type` SET TAGS ('dbx_business_glossary_term' = 'Resolution Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `resolution_type` SET TAGS ('dbx_value_regex' = 'full_payment|partial_payment|payment_plan|dispute_settled|write_off|account_closed');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `response_date` SET TAGS ('dbx_business_glossary_term' = 'Response Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `response_received_flag` SET TAGS ('dbx_business_glossary_term' = 'Response Received Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `response_type` SET TAGS ('dbx_business_glossary_term' = 'Response Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `response_type` SET TAGS ('dbx_value_regex' = 'payment_promise|dispute_raised|payment_plan_request|contact_request|no_response');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `sap_dunning_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Dunning Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `sap_dunning_document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ALTER COLUMN `total_overdue_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Overdue Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` SET TAGS ('dbx_subdomain' = 'incentive_management');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `rebate_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Rebate Agreement ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Beneficiary Account ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `accrual_method` SET TAGS ('dbx_business_glossary_term' = 'Accrual Method');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `accrual_method` SET TAGS ('dbx_value_regex' = 'periodic|milestone|transaction_based');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `achieved_volume` SET TAGS ('dbx_business_glossary_term' = 'Achieved Volume');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Rebate Agreement Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `agreement_status` SET TAGS ('dbx_business_glossary_term' = 'Rebate Agreement Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `agreement_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|terminated|settled');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_business_glossary_term' = 'Rebate Agreement Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'volume_rebate|loyalty_bonus|conquest_bonus|fleet_incentive|model_mix_bonus|early_payment_discount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending_approval|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `beneficiary_type` SET TAGS ('dbx_business_glossary_term' = 'Beneficiary Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `beneficiary_type` SET TAGS ('dbx_value_regex' = 'dealer|fleet_customer|distributor|broker');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `contract_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Contract Document Reference');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `dealer_tier` SET TAGS ('dbx_business_glossary_term' = 'Dealer Tier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `dealer_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `dispute_description` SET TAGS ('dbx_business_glossary_term' = 'Dispute Description');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `is_retroactive` SET TAGS ('dbx_business_glossary_term' = 'Is Retroactive');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `last_accrual_calculation_date` SET TAGS ('dbx_business_glossary_term' = 'Last Accrual Calculation Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `last_settlement_date` SET TAGS ('dbx_business_glossary_term' = 'Last Settlement Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `next_settlement_date` SET TAGS ('dbx_business_glossary_term' = 'Next Settlement Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Agreement Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `outstanding_balance` SET TAGS ('dbx_business_glossary_term' = 'Outstanding Balance');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'credit_memo|direct_payment|offset_against_invoice');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `powertrain_scope` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Scope');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `powertrain_scope` SET TAGS ('dbx_value_regex' = 'all|ICE|HEV|PHEV|EV');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `rebate_amount_per_unit` SET TAGS ('dbx_business_glossary_term' = 'Rebate Amount Per Unit');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `rebate_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Rebate Rate Percent');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `sales_region` SET TAGS ('dbx_business_glossary_term' = 'Sales Region');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `sap_rebate_agreement_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Rebate Agreement Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `sap_rebate_agreement_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `settlement_frequency` SET TAGS ('dbx_business_glossary_term' = 'Settlement Frequency');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `settlement_frequency` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annual|annual|upon_completion');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `settlement_status` SET TAGS ('dbx_business_glossary_term' = 'Settlement Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `settlement_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|partially_settled|fully_settled|disputed');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `target_volume` SET TAGS ('dbx_business_glossary_term' = 'Target Volume');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Termination Reason');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `total_accrued_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Accrued Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `total_settled_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Settled Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ALTER COLUMN `vehicle_model_scope` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Model Scope');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` SET TAGS ('dbx_subdomain' = 'incentive_management');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `rebate_accrual_id` SET TAGS ('dbx_business_glossary_term' = 'Rebate Accrual Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `rebate_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Rebate Agreement Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `rebate_created_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `rebate_created_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `rebate_created_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `rebate_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `rebate_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `rebate_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `rebate_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `rebate_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `rebate_updated_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Updated By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `rebate_updated_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `rebate_updated_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `tertiary_rebate_updated_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Updated By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `tertiary_rebate_updated_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `tertiary_rebate_updated_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `accrual_basis` SET TAGS ('dbx_business_glossary_term' = 'Accrual Basis');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `accrual_basis` SET TAGS ('dbx_value_regex' = 'invoiced_units|registered_units|shipped_units|delivered_units|retail_sales');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `accrual_notes` SET TAGS ('dbx_business_glossary_term' = 'Accrual Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `accrual_number` SET TAGS ('dbx_business_glossary_term' = 'Accrual Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `accrual_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `accrual_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Accrual Period End Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `accrual_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Accrual Period Start Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `accrual_status` SET TAGS ('dbx_business_glossary_term' = 'Accrual Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `accrual_status` SET TAGS ('dbx_value_regex' = 'open|posted|reversed|settled|cancelled|pending_approval');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `accrued_amount` SET TAGS ('dbx_business_glossary_term' = 'Accrued Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `accrued_units` SET TAGS ('dbx_business_glossary_term' = 'Accrued Units');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `copa_posting_reference` SET TAGS ('dbx_business_glossary_term' = 'Controlling Profitability Analysis (CO-PA) Posting Reference');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `copa_posting_reference` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `cumulative_accrued_amount` SET TAGS ('dbx_business_glossary_term' = 'Cumulative Accrued Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `rebate_rate` SET TAGS ('dbx_business_glossary_term' = 'Rebate Rate');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `rebate_rate_type` SET TAGS ('dbx_business_glossary_term' = 'Rebate Rate Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `rebate_rate_type` SET TAGS ('dbx_value_regex' = 'fixed_per_unit|percentage|tiered|volume_based');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `reversal_date` SET TAGS ('dbx_business_glossary_term' = 'Reversal Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `reversal_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `reversal_reason_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `sales_region_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Region Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `sales_region_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `sap_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `sap_document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `settlement_date` SET TAGS ('dbx_business_glossary_term' = 'Settlement Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `settlement_reference` SET TAGS ('dbx_business_glossary_term' = 'Settlement Reference Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `settlement_reference` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` SET TAGS ('dbx_subdomain' = 'revenue_collection');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `write_off_id` SET TAGS ('dbx_business_glossary_term' = 'Write-Off ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Account ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `write_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `write_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `write_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `write_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `write_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `amount` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `approval_authority_name` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority Name');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `approval_level` SET TAGS ('dbx_business_glossary_term' = 'Approval Level');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `approval_level` SET TAGS ('dbx_value_regex' = 'manager|director|vp|cfo');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `business_unit_code` SET TAGS ('dbx_business_glossary_term' = 'Business Unit Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `write_off_category` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Category');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `write_off_category` SET TAGS ('dbx_value_regex' = 'full|partial');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `collection_agency_code` SET TAGS ('dbx_business_glossary_term' = 'Collection Agency ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `collection_status` SET TAGS ('dbx_business_glossary_term' = 'Collection Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `collection_status` SET TAGS ('dbx_value_regex' = 'not_assigned|assigned|in_progress|recovered|closed');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `days_past_due_at_write_off` SET TAGS ('dbx_business_glossary_term' = 'Days Past Due at Write-Off');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `legal_case_reference` SET TAGS ('dbx_business_glossary_term' = 'Legal Case Reference');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `original_due_date` SET TAGS ('dbx_business_glossary_term' = 'Original Due Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `original_invoice_amount` SET TAGS ('dbx_business_glossary_term' = 'Original Invoice Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `outstanding_balance_before_write_off` SET TAGS ('dbx_business_glossary_term' = 'Outstanding Balance Before Write-Off');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `reason_code` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Reason Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `reason_code` SET TAGS ('dbx_value_regex' = 'bankruptcy|insolvency|uncontactable|statute_of_limitations|commercial_settlement|fraud');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `reason_description` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Reason Description');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `recovery_amount` SET TAGS ('dbx_business_glossary_term' = 'Recovery Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `recovery_date` SET TAGS ('dbx_business_glossary_term' = 'Recovery Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `recovery_flag` SET TAGS ('dbx_business_glossary_term' = 'Recovery Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `sales_region_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Region Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `sap_accounting_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Accounting Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `sap_write_off_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Write-Off Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `updated_by_user` SET TAGS ('dbx_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `write_off_date` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `write_off_number` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ALTER COLUMN `write_off_number` SET TAGS ('dbx_value_regex' = '^WO-[0-9]{8,12}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` SET TAGS ('dbx_subdomain' = 'revenue_collection');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `intercompany_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Invoice ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Issuing Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `adjustment_amount` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Invoice Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `intercompany_invoice_status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `intercompany_invoice_status` SET TAGS ('dbx_value_regex' = 'draft|issued|acknowledged|disputed|settled|cancelled');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Invoice Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `invoice_number` SET TAGS ('dbx_value_regex' = '^IC[0-9]{10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Issue Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Invoice Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Invoice Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'wire_transfer|ach|check|netting|offset');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Accounting Posting Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Quantity');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `receiving_entity_code` SET TAGS ('dbx_business_glossary_term' = 'Receiving Legal Entity Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `receiving_entity_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `receiving_entity_name` SET TAGS ('dbx_business_glossary_term' = 'Receiving Legal Entity Name');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `sap_fi_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Financial Accounting (FI) Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `sap_fi_document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `sap_intercompany_clearing_account` SET TAGS ('dbx_business_glossary_term' = 'SAP Intercompany Clearing Account');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `sap_intercompany_clearing_account` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `settlement_date` SET TAGS ('dbx_business_glossary_term' = 'Settlement Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `tax_treatment_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Treatment Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `tax_treatment_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `tax_treatment_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `transaction_type` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Transaction Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `transaction_type` SET TAGS ('dbx_value_regex' = 'vehicle_transfer|ckd_supply|skd_supply|royalty|management_fee|shared_service');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `transfer_price_basis` SET TAGS ('dbx_business_glossary_term' = 'Transfer Price Basis');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `transfer_price_basis` SET TAGS ('dbx_value_regex' = 'cost_plus|market_price|arm_length|negotiated|comparable_uncontrolled');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `transfer_pricing_policy_reference` SET TAGS ('dbx_business_glossary_term' = 'Transfer Pricing Policy Reference');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `transfer_pricing_policy_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KIT|HR|LOT');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `updated_by_user` SET TAGS ('dbx_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` SET TAGS ('dbx_subdomain' = 'revenue_collection');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `parts_service_charge_id` SET TAGS ('dbx_business_glossary_term' = 'Parts Service Charge ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `parts_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `parts_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `parts_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `recall_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Recall Campaign ID');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `billing_account_number` SET TAGS ('dbx_business_glossary_term' = 'Billing Account Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `billing_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `billing_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `billing_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `cdk_repair_order_number` SET TAGS ('dbx_business_glossary_term' = 'CDK Global Dealer Management System (DMS) Repair Order Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `charge_date` SET TAGS ('dbx_business_glossary_term' = 'Charge Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `charge_number` SET TAGS ('dbx_business_glossary_term' = 'Charge Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `charge_status` SET TAGS ('dbx_business_glossary_term' = 'Charge Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `charge_type` SET TAGS ('dbx_business_glossary_term' = 'Charge Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `dealer_code` SET TAGS ('dbx_business_glossary_term' = 'Dealer Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `labor_amount` SET TAGS ('dbx_business_glossary_term' = 'Labor Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `labor_hours` SET TAGS ('dbx_business_glossary_term' = 'Labor Hours');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `labor_operation_code` SET TAGS ('dbx_business_glossary_term' = 'Labor Operation Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `labor_rate` SET TAGS ('dbx_business_glossary_term' = 'Labor Rate');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Charge Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `parts_amount` SET TAGS ('dbx_business_glossary_term' = 'Parts Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `parts_quantity` SET TAGS ('dbx_business_glossary_term' = 'Parts Quantity');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `sap_billing_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Billing Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `service_date` SET TAGS ('dbx_business_glossary_term' = 'Service Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `service_order_number` SET TAGS ('dbx_business_glossary_term' = 'Service Order Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `total_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Charge Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `tsb_number` SET TAGS ('dbx_business_glossary_term' = 'Technical Service Bulletin (TSB) Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `updated_by_user` SET TAGS ('dbx_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ALTER COLUMN `warranty_claim_number` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` SET TAGS ('dbx_subdomain' = 'revenue_collection');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `advance_payment_id` SET TAGS ('dbx_business_glossary_term' = 'Advance Payment Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Payer Account Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `advance_amount` SET TAGS ('dbx_business_glossary_term' = 'Advance Payment Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `advance_payment_number` SET TAGS ('dbx_business_glossary_term' = 'Advance Payment Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `advance_type` SET TAGS ('dbx_business_glossary_term' = 'Advance Payment Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `advance_type` SET TAGS ('dbx_value_regex' = 'vehicle_deposit|fleet_prepayment|dealer_advance|booking_fee|order_deposit|down_payment');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `application_status` SET TAGS ('dbx_business_glossary_term' = 'Application Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `application_status` SET TAGS ('dbx_value_regex' = 'open|partially_applied|fully_applied|refunded|expired');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `applied_amount` SET TAGS ('dbx_business_glossary_term' = 'Applied Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `bank_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Bank Reference Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `business_area` SET TAGS ('dbx_business_glossary_term' = 'Business Area');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `dealer_code` SET TAGS ('dbx_business_glossary_term' = 'Dealer Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Advance Payment Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `payer_entity_type` SET TAGS ('dbx_business_glossary_term' = 'Payer Entity Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `payer_entity_type` SET TAGS ('dbx_value_regex' = 'dealer|fleet_customer|retail_customer|corporate_account');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `payment_date` SET TAGS ('dbx_business_glossary_term' = 'Advance Payment Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `payment_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Payment Reference Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `payment_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Advance Payment Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `reconciliation_date` SET TAGS ('dbx_business_glossary_term' = 'Reconciliation Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_business_glossary_term' = 'Reconciliation Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_value_regex' = 'pending|reconciled|discrepancy|under_review');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `refund_amount` SET TAGS ('dbx_business_glossary_term' = 'Refund Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `refund_date` SET TAGS ('dbx_business_glossary_term' = 'Refund Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `refund_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Refund Reason Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `sales_order_number` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `sales_region_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Region Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `sap_clearing_document` SET TAGS ('dbx_business_glossary_term' = 'SAP Clearing Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `sap_down_payment_document` SET TAGS ('dbx_business_glossary_term' = 'SAP Down Payment Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `unapplied_balance` SET TAGS ('dbx_business_glossary_term' = 'Unapplied Balance');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `updated_by_user` SET TAGS ('dbx_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `value_date` SET TAGS ('dbx_business_glossary_term' = 'Value Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ALTER COLUMN `vehicle_order_number` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` SET TAGS ('dbx_subdomain' = 'pricing_terms');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `payment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `superseded_payment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded Payment Plan Id');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `superseded_payment_plan_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `auto_renewal` SET TAGS ('dbx_business_glossary_term' = 'Auto Renewal');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `billing_cycle` SET TAGS ('dbx_business_glossary_term' = 'Billing Cycle');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `billing_day_of_month` SET TAGS ('dbx_business_glossary_term' = 'Billing Day Of Month');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `collection_status` SET TAGS ('dbx_business_glossary_term' = 'Collection Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `default_date` SET TAGS ('dbx_business_glossary_term' = 'Default Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `defaulted_flag` SET TAGS ('dbx_business_glossary_term' = 'Defaulted Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `payment_plan_description` SET TAGS ('dbx_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `discount_rate` SET TAGS ('dbx_business_glossary_term' = 'Discount Rate');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `down_payment_amount` SET TAGS ('dbx_business_glossary_term' = 'Down Payment Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `early_termination_fee` SET TAGS ('dbx_business_glossary_term' = 'Early Termination Fee');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `eligibility_criteria` SET TAGS ('dbx_business_glossary_term' = 'Eligibility Criteria');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `grace_period_days` SET TAGS ('dbx_business_glossary_term' = 'Grace Period Days');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `installment_amount` SET TAGS ('dbx_business_glossary_term' = 'Installment Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `interest_rate` SET TAGS ('dbx_business_glossary_term' = 'Interest Rate');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `last_payment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Payment Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `late_fee_amount` SET TAGS ('dbx_business_glossary_term' = 'Late Fee Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `next_payment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Payment Due Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `number_of_installments` SET TAGS ('dbx_business_glossary_term' = 'Number Of Installments');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `outstanding_balance` SET TAGS ('dbx_business_glossary_term' = 'Outstanding Balance');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `payment_channel` SET TAGS ('dbx_business_glossary_term' = 'Payment Channel');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `payment_frequency` SET TAGS ('dbx_business_glossary_term' = 'Payment Frequency');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `penalty_rate` SET TAGS ('dbx_business_glossary_term' = 'Penalty Rate');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `plan_code` SET TAGS ('dbx_business_glossary_term' = 'Plan Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Plan Name');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Plan Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `promotional_code` SET TAGS ('dbx_business_glossary_term' = 'Promotional Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `recurring_amount` SET TAGS ('dbx_business_glossary_term' = 'Recurring Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Renewal Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `payment_plan_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `tax_exempt_flag` SET TAGS ('dbx_business_glossary_term' = 'Tax Exempt Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `tax_rate` SET TAGS ('dbx_business_glossary_term' = 'Tax Rate');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `total_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `total_paid_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Paid Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` SET TAGS ('dbx_subdomain' = 'pricing_terms');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `billing_period_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Period Identifier');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `previous_billing_period_id` SET TAGS ('dbx_business_glossary_term' = 'Previous Billing Period Id');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `previous_billing_period_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `billing_cycle_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Cycle Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_business_glossary_term' = 'Billing Frequency');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `close_date` SET TAGS ('dbx_business_glossary_term' = 'Close Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `days_in_period` SET TAGS ('dbx_business_glossary_term' = 'Days In Period');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `billing_period_description` SET TAGS ('dbx_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `fiscal_quarter` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Quarter');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `is_closed` SET TAGS ('dbx_business_glossary_term' = 'Is Closed');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Period End Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `period_name` SET TAGS ('dbx_business_glossary_term' = 'Period Name');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Period Start Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `period_type` SET TAGS ('dbx_business_glossary_term' = 'Period Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `period_version` SET TAGS ('dbx_business_glossary_term' = 'Period Version');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `billing_period_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_period` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` SET TAGS ('dbx_subdomain' = 'statement_processing');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_run_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Run Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Initiated By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_period_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Period Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_run_approved_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_run_approved_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_run_approved_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_run_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Initiated By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_run_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_run_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `actual_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `batch_job_reference` SET TAGS ('dbx_business_glossary_term' = 'Batch Job Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `batch_job_reference` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_category` SET TAGS ('dbx_business_glossary_term' = 'Billing Category');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_due_list_reference` SET TAGS ('dbx_business_glossary_term' = 'SAP Billing Due List Reference (VF04)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_due_list_reference` SET TAGS ('dbx_value_regex' = '^VF04-[A-Z0-9]{10,20}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_entity_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Entity Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_entity_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Period End Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `billing_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Period Start Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `division_code` SET TAGS ('dbx_business_glossary_term' = 'Division Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `division_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `edi_transmission_status` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Transmission Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `edi_transmission_status` SET TAGS ('dbx_value_regex' = 'not_applicable|pending|transmitted|acknowledged|failed');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `error_count` SET TAGS ('dbx_business_glossary_term' = 'Error Count');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^[0-9]{2,3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Billing Run Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `output_format` SET TAGS ('dbx_business_glossary_term' = 'Invoice Output Format');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `output_format` SET TAGS ('dbx_value_regex' = 'pdf|xml|edi|print|email');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Financial Posting Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `print_queue_name` SET TAGS ('dbx_business_glossary_term' = 'Print Queue Name');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `reversal_date` SET TAGS ('dbx_business_glossary_term' = 'Reversal Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `reversal_flag` SET TAGS ('dbx_business_glossary_term' = 'Reversal Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `reversal_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `reversal_reason_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,4}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `run_number` SET TAGS ('dbx_business_glossary_term' = 'Billing Run Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `run_number` SET TAGS ('dbx_value_regex' = '^BR-[0-9]{8}-[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `run_status` SET TAGS ('dbx_business_glossary_term' = 'Billing Run Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `run_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|failed|cancelled|partially_completed');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `run_type` SET TAGS ('dbx_business_glossary_term' = 'Billing Run Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `run_type` SET TAGS ('dbx_value_regex' = 'periodic|manual|correction|rerun|ad_hoc|final');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `scheduled_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `selection_criteria` SET TAGS ('dbx_business_glossary_term' = 'Selection Criteria');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `total_billed_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Billed Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `total_discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `total_gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `total_invoices_failed` SET TAGS ('dbx_business_glossary_term' = 'Total Invoices Failed Count');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `total_invoices_generated` SET TAGS ('dbx_business_glossary_term' = 'Total Invoices Generated Count');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `total_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ALTER COLUMN `warning_count` SET TAGS ('dbx_business_glossary_term' = 'Warning Count');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` SET TAGS ('dbx_subdomain' = 'statement_processing');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `billing_block_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Applied By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `billing_block_released_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Released By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `billing_block_released_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `billing_block_released_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `billing_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Applied By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `billing_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `billing_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `billing_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `billing_released_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Released By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `billing_released_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `billing_released_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `dispute_id` SET TAGS ('dbx_business_glossary_term' = 'Dispute Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `recall_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Recall Campaign Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `aging_days` SET TAGS ('dbx_business_glossary_term' = 'Aging Days');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `applied_by_user_name` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Applied By User Name');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `applied_by_user_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `applied_by_user_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `applied_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Applied Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `applied_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Applied Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `block_number` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `block_status` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Status');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `block_status` SET TAGS ('dbx_value_regex' = 'active|released|expired|cancelled');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `block_type` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `block_type` SET TAGS ('dbx_value_regex' = 'credit_limit_exceeded|pricing_incomplete|legal_hold|compliance_hold|dispute_hold|manual_hold');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `blocked_document_number` SET TAGS ('dbx_business_glossary_term' = 'Blocked Document Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `blocked_document_type` SET TAGS ('dbx_business_glossary_term' = 'Blocked Document Type');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `blocked_document_type` SET TAGS ('dbx_value_regex' = 'sales_order|delivery|billing_account|contract');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `compliance_hold_reason` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hold Reason');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `credit_exposure_amount` SET TAGS ('dbx_business_glossary_term' = 'Credit Exposure Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `credit_limit_amount` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit Amount');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `credit_limit_exceeded_flag` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit Exceeded Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `delivery_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `escalation_date` SET TAGS ('dbx_business_glossary_term' = 'Escalation Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `escalation_flag` SET TAGS ('dbx_business_glossary_term' = 'Escalation Flag');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `expected_resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Expected Resolution Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `legal_hold_case_number` SET TAGS ('dbx_business_glossary_term' = 'Legal Hold Case Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Priority');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `reason_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Reason Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `reason_description` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Reason Description');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `release_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Release Date');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `release_notes` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Release Notes');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `release_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Release Timestamp');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `released_by_user_name` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Released By User Name');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `released_by_user_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `released_by_user_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `sales_order_number` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Number');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `sap_billing_block_code` SET TAGS ('dbx_business_glossary_term' = 'SAP Sales and Distribution (SD) Billing Block Code');
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
