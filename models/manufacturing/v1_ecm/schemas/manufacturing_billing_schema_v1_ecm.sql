-- Schema for Domain: billing | Business: Manufacturing | Version: v1_ecm
-- Generated on: 2026-04-16 07:42:32

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`billing` COMMENT 'Generates invoices, records payments, handles credit notes and debit notes, manages revenue recognition, and links financial transactions to orders and contracts. Supports multi-currency billing, tax compliance, and integration with finance for accounts receivable and revenue reporting.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` (
    `invoice_line_item_id` BIGINT COMMENT 'Unique surrogate identifier for each invoice line item record in the billing system. Serves as the primary key for the invoice_line_item data product in the Databricks Silver Layer.',
    `batch_id` BIGINT COMMENT 'Foreign key linking to production.batch. Business justification: Invoice line items track which production batch fulfilled the order. Critical for regulated industries (pharma, food) requiring batch-level traceability and recall management.',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: invoice_line_item is the child entity of invoice. Currently has invoice_number (STRING) for reference, but needs proper FK invoice_id to invoice.invoice_id for referential integrity. This is the core ',
    `certificate_id` BIGINT COMMENT 'Foreign key linking to quality.quality_certificate. Business justification: Certain industries (aerospace, medical devices, automotive) require quality certificates (CoC, material certs) for each shipment. Invoice line items reference these certificates to prove compliance an',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Invoice line items bill for manufactured components. Billing department references component master data for part numbers, descriptions, and pricing. Used daily in customer invoicing for parts sold.',
    `contract_line_id` BIGINT COMMENT 'Foreign key linking to service.service_contract_line. Business justification: Invoice line items for contracted services reference the specific service contract line being billed. Billing teams use this to validate billing against contract terms and service delivery.',
    `contractor_qualification_id` BIGINT COMMENT 'Foreign key linking to hse.contractor_qualification. Business justification: Contractor safety qualification costs (training, certification, background checks) are invoiced to projects or contractors themselves. Billing requires reference to specific qualification records for ',
    `engineering_prototype_id` BIGINT COMMENT 'Foreign key linking to engineering.prototype. Business justification: Prototype builds are billable items in contract manufacturing. Invoice line items reference specific prototypes when billing customers for prototype development, testing, and iteration costs.',
    `environmental_permit_id` BIGINT COMMENT 'Foreign key linking to hse.environmental_permit. Business justification: Environmental permit fees (air quality, water discharge, hazardous waste) are billed as line items. Manufacturing finance teams invoice permit costs to cost centers or customers, requiring direct link',
    `field_service_order_id` BIGINT COMMENT 'Foreign key linking to service.field_service_order. Business justification: Ad-hoc field service work generates invoice line items. Billing must reference the specific service order to bill for labor, parts, and travel costs incurred during field visits.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Invoice line items post to specific GL revenue accounts in finance. Finance uses this for revenue classification and financial statement preparation.',
    `installation_record_id` BIGINT COMMENT 'Foreign key linking to service.installation_record. Business justification: Installation services for automation systems and equipment are billable events. Invoice line items reference installation records to charge for commissioning, setup, and configuration work performed.',
    `lot_batch_id` BIGINT COMMENT 'Foreign key linking to inventory.lot_batch. Business justification: Manufacturing invoices often require lot/batch traceability for quality control, recalls, and compliance. Critical for pharmaceutical, food, and automotive industries where batch tracking is mandatory',
    `procurement_po_line_item_id` BIGINT COMMENT 'Foreign key linking to procurement.po_line_item. Business justification: Invoice line items trace back to specific PO line items for detailed reconciliation. Accounts payable verifies quantities, prices, and specifications match the original purchase order.',
    `project_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_project. Business justification: Engineering services (NRE, design work, prototyping) are billed by project. Invoice line items track which engineering project generated the billable work for cost recovery and revenue recognition.',
    `safety_training_id` BIGINT COMMENT 'Foreign key linking to hse.safety_training. Business justification: Safety training costs are charged back to departments, projects, or contractors. Manufacturing billing systems invoice training expenses with direct reference to training sessions for cost allocation ',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Invoice line item references originating sales order line - normalize by replacing sales_order_number text with FK',
    `serialized_unit_id` BIGINT COMMENT 'Foreign key linking to inventory.serialized_unit. Business justification: High-value capital equipment and machinery sales require serial number tracking on invoices for warranty registration, service contracts, and asset management. Standard practice in industrial equipmen',
    `shipment_item_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment_item. Business justification: Invoice line items bill specific shipped items. Each line references the actual shipment item to ensure billed quantities match delivered quantities for manufactured goods.',
    `software_license_id` BIGINT COMMENT 'Foreign key linking to technology.software_license. Business justification: Manufacturing software licenses (PLM, MES, SCADA) are billed as line items on invoices. Billing must reference specific licenses for subscription renewals, true-ups, and compliance tracking.',
    `spare_part_id` BIGINT COMMENT 'Foreign key linking to asset.spare_part. Business justification: Spare parts consumed during maintenance are billed to customers. Each invoice line references the specific spare part used, including part number and unit price for billing.',
    `spare_parts_request_id` BIGINT COMMENT 'Foreign key linking to service.spare_parts_request. Business justification: Spare parts consumed during service are billed separately. Invoice line items reference the parts request to charge customers for replacement components used in repairs or maintenance.',
    `tooling_equipment_id` BIGINT COMMENT 'Foreign key linking to engineering.tooling_equipment. Business justification: Manufacturers bill customers for custom tooling, molds, and fixtures. Invoice line items reference specific tooling assets when charging tooling costs or amortization to customers.',
    `waste_record_id` BIGINT COMMENT 'Foreign key linking to hse.waste_record. Business justification: Manufacturing facilities invoice customers for waste disposal services (hazardous material handling, scrap removal). Billing line items reference specific waste records to justify charges and ensure r',
    `account_assignment_category` STRING COMMENT 'Indicates the type of account assignment object (cost center, project, asset, internal order) to which the costs or revenues of this line item are posted in SAP CO. Corresponds to KNTTP in SAP MM/SD.. Valid values are `cost_center|project|asset|order|profit_center|not_assigned`',
    `billed_quantity` DECIMAL(18,2) COMMENT 'The quantity of the material or service being billed on this line item. Expressed in the billing unit of measure. Corresponds to FKIMG in SAP SD-BIL.',
    `billing_currency` STRING COMMENT 'The ISO 4217 three-letter currency code in which this line item is billed (e.g., USD, EUR, GBP, JPY). Supports multi-currency billing for multinational operations. Corresponds to WAERK in SAP SD-BIL.. Valid values are `^[A-Z]{3}$`',
    `billing_date` DATE COMMENT 'The date on which the invoice was created and issued to the customer. Corresponds to FKDAT in SAP SD-BIL. Used as the reference date for payment terms calculation and accounts receivable aging.',
    `billing_item_category` STRING COMMENT 'SAP billing item category code that controls the billing behavior of the line item (e.g., TAN for standard item, TAD for service item, REN for returns credit). Corresponds to PSTYV in SAP SD.. Valid values are `TAN|TAD|TAX|TAB|TANN|REN|G2N|L2N|KLN|KAN`',
    `cogs_amount` DECIMAL(18,2) COMMENT 'The cost of goods sold amount associated with this line item, representing the direct cost of the material or service billed. Used for gross margin calculation and profitability analysis at the line level. Corresponds to WAVWR in SAP SD-BIL.',
    `company_code_currency` STRING COMMENT 'The ISO 4217 three-letter currency code of the company codes local currency, used for financial reporting and AR posting in SAP FI. Enables currency translation for consolidated financial reporting.. Valid values are `^[A-Z]{3}$`',
    `contract_number` STRING COMMENT 'The reference number of the customer contract or scheduling agreement from which this billing line item originates. Supports contract-based billing, milestone invoicing, and revenue recognition under long-term contracts.',
    `cost_center` STRING COMMENT 'The SAP cost center code associated with this line item for cost allocation and management accounting purposes. Relevant for service billing and internal cost tracking. Corresponds to KOSTL in SAP CO.',
    `delivery_number` STRING COMMENT 'The SAP outbound delivery document number associated with this billing line item. Links the invoice line to the physical shipment and goods issue. Corresponds to VGBEL in SAP SD-BIL for delivery-based billing.',
    `discount_amount` DECIMAL(18,2) COMMENT 'The total monetary discount applied to this line item, representing the difference between gross and net line value. Supports pricing analysis, margin reporting, and customer discount tracking.',
    `discount_percentage` DECIMAL(18,2) COMMENT 'The percentage discount applied to this line item relative to the gross line value. Derived from pricing condition records in SAP SD. Used for pricing analytics and customer agreement compliance monitoring.',
    `distribution_channel` STRING COMMENT 'The SAP distribution channel through which the product or service was sold (e.g., direct sales, dealer, OEM, e-commerce). Corresponds to VTWEG in SAP SD. Used for channel-level revenue analysis.',
    `division` STRING COMMENT 'The SAP division code representing the product group or business division responsible for the billed material or service. Corresponds to SPART in SAP SD. Supports divisional revenue reporting.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign currency exchange rate applied to translate the billing currency to the company code currency at the time of invoice creation. Corresponds to KURRF in SAP SD-BIL. Required for multi-currency reconciliation.',
    `goods_issue_date` DATE COMMENT 'The date on which goods were physically issued from the warehouse or plant for delivery to the customer, triggering the billing process. Corresponds to WADAT_IST in SAP SD/WM. Used for revenue recognition timing and logistics reconciliation.',
    `gross_line_value` DECIMAL(18,2) COMMENT 'The gross value of this line item before discounts and surcharges are applied, representing the list price multiplied by billed quantity. Used for discount analysis and pricing performance reporting.',
    `gross_margin_amount` DECIMAL(18,2) COMMENT 'The gross margin in monetary terms for this line item, calculated as net line value minus COGS amount. Supports profitability analysis and contribution margin reporting at the line level.',
    `line_item_number` STRING COMMENT 'Sequential position number of this line item within the parent invoice document. Used to order and reference individual billing positions. Corresponds to POSNR in SAP SD.. Valid values are `^[0-9]{1,6}$`',
    `line_item_status` STRING COMMENT 'The current processing and payment status of this invoice line item in the accounts receivable ledger. Drives AR aging, collections, and financial close processes.. Valid values are `open|cleared|partially_cleared|cancelled|reversed|blocked`',
    `material_number` STRING COMMENT 'The SAP material master number identifying the product, component, or service being billed on this line item. Corresponds to MATNR in SAP MM/SD. Links to the product catalog and BOM.',
    `net_line_value` DECIMAL(18,2) COMMENT 'The total net value of this line item before taxes, calculated as billed quantity multiplied by unit price, after applying any discounts or surcharges. Corresponds to NETWR in SAP SD-BIL. Used for revenue recognition and AR posting.',
    `net_line_value_company_currency` DECIMAL(18,2) COMMENT 'The net line value of this billing item translated into the company codes local currency using the exchange rate at the time of billing. Required for financial reporting and accounts receivable posting in SAP FI-AR.',
    `plant` STRING COMMENT 'The SAP plant code from which the goods or services on this line item were supplied or produced. Represents the manufacturing or distribution facility. Corresponds to WERKS in SAP SD/MM. Used for plant-level revenue and profitability reporting.',
    `profit_center` STRING COMMENT 'The SAP profit center code assigned to this line item for internal profitability reporting and management accounting. Corresponds to PRCTR in SAP CO. Enables revenue and margin analysis by business unit or product line.',
    `revenue_recognition_date` DATE COMMENT 'The date on which revenue for this line item is recognized in the financial statements, as determined by the applicable revenue recognition method and contract terms. Corresponds to SAP RAR (Revenue Accounting and Reporting) posting date.',
    `revenue_recognition_method` STRING COMMENT 'The method used to recognize revenue for this line item in accordance with IFRS 15 / ASC 606. Determines whether revenue is recognized at a point in time, over time, at milestones, or by percentage of completion. Critical for financial compliance.. Valid values are `point_in_time|over_time|milestone|percentage_of_completion|not_applicable`',
    `sales_order_line_item` STRING COMMENT 'The specific line item number within the originating sales order that this billing line item references. Enables precise order-to-invoice reconciliation at the line level. Corresponds to AUPOS in SAP SD-BIL.',
    `sales_organization` STRING COMMENT 'The SAP sales organization code responsible for the sale associated with this line item. Defines the legal entity and regional structure for revenue booking. Corresponds to VKORG in SAP SD.',
    `service_rendered_date` DATE COMMENT 'The date on which the service was performed or completed for service-based line items. Used as the performance obligation fulfillment date for revenue recognition under IFRS 15 / ASC 606.',
    `sku` STRING COMMENT 'Stock Keeping Unit code used for inventory and order management identification of the billed product. Supports cross-system reconciliation between WMS (Infor WMS), ERP (SAP), and billing systems.',
    `tax_amount` DECIMAL(18,2) COMMENT 'The calculated tax amount for this line item in the billing document currency, based on the applicable tax code and net line value. Used for tax liability reporting and compliance with local tax regulations.',
    `tax_code` STRING COMMENT 'The tax code assigned to this line item that determines the applicable tax rate and tax type (e.g., VAT, GST, sales tax). Corresponds to MWSKZ in SAP FI/SD. Drives tax calculation and compliance reporting.',
    `tax_rate` DECIMAL(18,2) COMMENT 'The effective tax rate percentage applied to this line item, as determined by the tax code and jurisdiction. Supports tax audit trails and multi-jurisdiction tax compliance reporting.',
    `unit_of_measure` STRING COMMENT 'The unit of measure in which the billed quantity is expressed (e.g., EA for each, KG for kilogram, HR for hour, M for meter). Corresponds to VRKME in SAP SD-BIL. Aligned with ISO 80000 unit codes.',
    `unit_price` DECIMAL(18,2) COMMENT 'The net price per unit of measure charged to the customer for this line item, in the billing document currency. Reflects agreed pricing from the sales order or pricing agreement. Corresponds to NETPR in SAP SD.',
    `wbs_element` STRING COMMENT 'The Work Breakdown Structure element code from SAP PS (Project System) to which this line items revenue or cost is assigned. Used for project-based billing, milestone invoicing, and ETO (Engineer to Order) scenarios.',
    CONSTRAINT pk_invoice_line_item PRIMARY KEY(`invoice_line_item_id`)
) COMMENT 'Individual line-level detail within a customer invoice capturing each billable item, service, or milestone. Records the billing item number, material or service description, billed quantity, unit of measure, unit price, net line value, tax code, tax amount, cost of goods sold (COGS) amount, profit center, plant, and reference to the originating sales order line item or delivery line. Supports revenue recognition at the line level and detailed accounts receivable posting in SAP FI-AR.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`credit_note` (
    `credit_note_id` BIGINT COMMENT 'Unique surrogate identifier for the credit note record in the data lakehouse. Serves as the primary key for this entity.',
    `approved_by_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Credit notes for returns, defects, or pricing adjustments require managerial approval in manufacturing. Finance tracks approver for authorization controls and financial audit requirements.',
    `ar_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ar_invoice. Business justification: Credit notes reverse or adjust original AR invoices in finance. Finance uses this to track receivables adjustments and revenue corrections.',
    `address_id` BIGINT COMMENT 'Foreign key linking to customer.address. Business justification: Credit notes require billing address for tax jurisdiction and legal compliance, matching the original invoices tax treatment in manufacturing transactions.',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Credit notes for returned equipment or billing corrections must reference the original invoice being adjusted. Critical for accounts receivable reconciliation and financial reporting accuracy.',
    `billing_payment_term_id` BIGINT COMMENT 'Foreign key linking to billing.payment_term. Business justification: credit_note has payment_terms_code (STRING) but needs proper FK payment_term_id to payment_term.payment_term_id for referential integrity and to access full payment term configuration. Removing paymen',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Credit note issued to customer account - normalize by replacing customer_account_number and customer_name with FK',
    `employee_id` BIGINT COMMENT 'SAP user ID of the individual who approved or rejected the credit note in the workflow. Supports segregation of duties compliance and audit trail requirements.',
    `ncr_id` BIGINT COMMENT 'Foreign key linking to quality.ncr. Business justification: Credit note may be issued due to quality non-conformance - normalize by replacing ncr_number text with FK to quality.ncr',
    `product_return_id` BIGINT COMMENT 'Foreign key linking to service.product_return. Business justification: Product returns for defective equipment trigger credit notes. Billing references the return record to issue refunds or credits for returned automation components and spare parts.',
    `returns_order_id` BIGINT COMMENT 'Foreign key linking to order.returns_order. Business justification: Credit note issued for return - normalize by replacing returns_order_number text with FK to order.returns_order',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Credit note references originating sales order - normalize by replacing sales_order_number text with FK',
    `stock_adjustment_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_adjustment. Business justification: Credit notes for damaged goods, returns, or inventory discrepancies must reference the stock adjustment that triggered the credit. Finance reconciles credits against physical inventory adjustments.',
    `type_id` BIGINT COMMENT 'Foreign key linking to billing.billing_type. Business justification: credit_note has document_type (STRING) which represents a billing type classification. Needs proper FK billing_type_id to billing_type.billing_type_id for consistency with invoice and to access billin',
    `warranty_claim_id` BIGINT COMMENT 'Foreign key linking to service.warranty_claim. Business justification: Approved warranty claims result in credit notes to reverse charges for covered repairs. Finance uses this link to process warranty-related billing adjustments and track warranty costs.',
    `approval_limit_amount` DECIMAL(18,2) COMMENT 'Maximum credit note value (in document currency) that the approver is authorized to approve per the delegation of authority matrix. Used to validate that the approver had sufficient authorization level.',
    `approval_status` STRING COMMENT 'Current status of the credit note within the approval workflow. Indicates whether the document is awaiting review, has been approved for posting, or has been rejected requiring revision.. Valid values are `NOT_REQUIRED|PENDING|APPROVED|REJECTED|ESCALATED`',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the credit note received final approval in the workflow. Null if not yet approved or if approval is not required. Used for approval cycle time analytics and SOX compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `billing_company_code` STRING COMMENT 'SAP FI company code of the legal entity issuing the credit note. Determines the chart of accounts, fiscal year variant, and local GAAP/IFRS reporting requirements applicable to this document.',
    `billing_date` DATE COMMENT 'Date on which the credit note was generated in the SAP SD billing run. Used for billing cycle reporting and revenue period assignment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `company_currency_code` STRING COMMENT 'ISO 4217 currency code of the issuing legal entitys local (functional) currency. Used for parallel currency valuation and statutory financial reporting.. Valid values are `^[A-Z]{3}$`',
    `cost_center` STRING COMMENT 'SAP CO cost center associated with the credit note for internal cost allocation purposes. Relevant when the credit note impacts cost of goods sold or warranty cost tracking.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customers billing country. Determines applicable tax regulations, legal requirements, and reporting obligations for the credit note.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the credit note record was first created in the source system (SAP S/4HANA). Provides audit trail for document origination.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `credit_reason_code` STRING COMMENT 'Standardized reason code classifying why the credit note was issued. Drives root-cause analytics, process improvement (CAPA), and revenue adjustment categorization. Aligned with SAP SD credit memo reason codes.. Valid values are `PRICE_CORRECTION|QUALITY_DEFECT|GOODS_RETURN|GOODWILL|OVERBILLING|DUPLICATE_INVOICE|CONTRACT_ADJUSTMENT|QUANTITY_DISPUTE|FREIGHT_DISPUTE|OTHER`',
    `credit_reason_description` STRING COMMENT 'Free-text narrative providing additional context for the credit note issuance beyond the structured reason code. Captures specific details such as defect description, pricing discrepancy explanation, or customer complaint summary.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the credit note document currency (e.g., USD, EUR, CNY). Supports multi-currency billing operations across global manufacturing entities.. Valid values are `^[A-Z]{3}$`',
    `distribution_channel` STRING COMMENT 'SAP SD distribution channel through which the original sale was made (e.g., direct sales, dealer, OEM). Used for revenue reporting segmentation and credit note routing.',
    `division` STRING COMMENT 'SAP SD division representing the product line or business unit associated with the original sale. Supports segment-level revenue and credit reporting.',
    `document_date` DATE COMMENT 'Date printed on the credit note document as issued to the customer. Represents the official date of the credit memo for customer-facing and legal purposes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign currency exchange rate applied to translate the document currency amount to the company code currency at the time of posting. Sourced from SAP exchange rate tables.',
    `gl_account_code` STRING COMMENT 'SAP FI general ledger account code to which the credit note revenue reversal is posted. Determines the financial statement line item affected by the credit adjustment.',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total gross value of the credit note before tax deductions, expressed in the document currency. Represents the full credit amount to be applied against the customers accounts receivable balance.',
    `is_intercompany` BOOLEAN COMMENT 'Indicates whether this credit note is an intercompany transaction between two legal entities within the same corporate group. Drives intercompany elimination processing in consolidated financial reporting.. Valid values are `true|false`',
    `net_amount` DECIMAL(18,2) COMMENT 'Net value of the credit note excluding taxes, expressed in the document currency. Used for revenue reversal posting and accounts receivable adjustment in the general ledger.',
    `net_amount_company_currency` DECIMAL(18,2) COMMENT 'Net credit amount translated into the issuing company codes local functional currency using the exchange rate at posting date. Required for statutory financial reporting and local GAAP compliance.',
    `number` STRING COMMENT 'Business-facing document number assigned to the credit note in SAP S/4HANA SD (billing document type CR). Used for customer communication, reconciliation, and audit trail.. Valid values are `^CR[0-9]{10}$`',
    `posting_date` DATE COMMENT 'Accounting date on which the credit note is posted to the general ledger in SAP FI. Determines the fiscal period for revenue reversal and accounts receivable adjustment. May differ from document date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `profit_center` STRING COMMENT 'SAP CO profit center to which the credit note is assigned for internal management reporting. Enables segment-level profitability analysis and credit note impact tracking by business unit.',
    `reference_invoice_number` STRING COMMENT 'Document number of the original customer invoice that this credit note partially or fully reverses or adjusts. Establishes the financial linkage between the credit memo and the source billing document.',
    `sales_organization` STRING COMMENT 'SAP SD sales organization responsible for issuing the credit note. Defines the selling unit, pricing procedures, and revenue assignment for the credit transaction.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this credit note record was extracted. Supports data lineage tracking and reconciliation in the lakehouse silver layer.. Valid values are `SAP_S4HANA|LEGACY_ERP|MANUAL`',
    `status` STRING COMMENT 'Current lifecycle status of the credit note document. Tracks progression from initial creation through approval workflow to financial posting or cancellation in SAP S/4HANA.. Valid values are `DRAFT|PENDING_APPROVAL|APPROVED|REJECTED|POSTED|CANCELLED|REVERSED`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax value (VAT, GST, sales tax) included in the credit note, expressed in the document currency. Drives tax adjustment postings in SAP FI and tax compliance reporting.',
    `tax_code` STRING COMMENT 'SAP tax condition code identifying the applicable tax rate and jurisdiction for this credit note (e.g., V1 for 19% VAT, A0 for zero-rated export). Drives automatic tax calculation and reporting.',
    `tax_jurisdiction_code` STRING COMMENT 'Geographic tax jurisdiction code (e.g., US state/county code or EU country code) used to determine the applicable tax authority and rate for this credit note. Critical for multi-country tax compliance.',
    CONSTRAINT pk_credit_note PRIMARY KEY(`credit_note_id`)
) COMMENT 'Formal credit memo issued to industrial customers to reduce or reverse a previously issued invoice. Captures credit note number, reference invoice, credit reason code (price correction, quality defect, return, goodwill, overbilling), credit amount, tax adjustment, currency, approval status, approver, and posting date. Linked to NCR (Non-Conformance Report) or returns order where applicable. Managed in SAP S/4HANA SD as a billing document type CR.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`debit_note` (
    `debit_note_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for the debit note record in the Databricks Silver Layer. Serves as the primary key for all downstream joins and references.',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Debit notes for additional charges (freight, installation, scope changes) reference the original project invoice. Used for billing adjustments and maintaining complete transaction history.',
    `billing_payment_term_id` BIGINT COMMENT 'Foreign key linking to billing.payment_term. Business justification: debit_note has payment_terms_code (STRING) but needs proper FK payment_term_id to payment_term.payment_term_id for referential integrity and to access full payment term configuration. Removing payment',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Debit note issued to customer account - normalize by replacing customer_account_number and customer_name with FK',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Debit note references sales order - normalize by replacing sales_order_number text with FK',
    `supplier_quality_event_id` BIGINT COMMENT 'Foreign key linking to quality.supplier_quality_event. Business justification: Manufacturers issue debit notes to suppliers for quality failures (rejected materials, containment costs, sorting charges). The supplier quality event documents the root cause and costs, which billing',
    `type_id` BIGINT COMMENT 'Foreign key linking to billing.billing_type. Business justification: debit_note is a billing document type but lacks explicit FK to billing_type. Needs FK billing_type_id to billing_type.billing_type_id for consistency with other billing documents and to access billing',
    `accounting_status` STRING COMMENT 'Status of the debit note transfer to financial accounting (FI). Indicates whether the document has been successfully posted to the general ledger and accounts receivable subledger.. Valid values are `NOT_POSTED|POSTED|CLEARED|PARTIALLY_CLEARED|ERROR`',
    `approval_status` STRING COMMENT 'Current approval workflow status of the debit note. Debit notes typically require internal approval before release to the customer, especially for high-value adjustments or penalty charges.. Valid values are `PENDING|APPROVED|REJECTED|CANCELLED|ON_HOLD`',
    `approved_by` STRING COMMENT 'User ID or name of the individual who approved the debit note for release. Required for audit trail and segregation of duties compliance.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the debit note was approved for release. Used for approval cycle time analysis and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `billing_date` DATE COMMENT 'Date on which the debit note billing document was created in SAP SD. Used for invoice aging, payment due date calculation, and customer-facing document dating.. Valid values are `^d{4}-d{2}-d{2}$`',
    `billing_status` STRING COMMENT 'Processing status of the debit note billing document in SAP SD. Indicates whether the document is in draft, released to accounting, cancelled, or reversed.. Valid values are `DRAFT|RELEASED|CANCELLED|REVERSED`',
    `company_code` STRING COMMENT 'SAP FI company code representing the legal entity issuing the debit note. Determines the chart of accounts, fiscal year variant, and local currency for financial posting.. Valid values are `^[A-Z0-9]{4}$`',
    `contract_number` STRING COMMENT 'Customer contract or scheduling agreement number under which the original transaction was executed. Required for contractual compliance and revenue recognition alignment.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customers billing address country. Determines applicable tax jurisdiction, regulatory compliance requirements, and reporting region.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the debit note record was created in SAP S/4HANA. Supports audit trail, document aging, and process cycle time analysis.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the debit note document currency (e.g., USD, EUR, GBP). Supports multi-currency billing for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `dispute_case_number` STRING COMMENT 'Reference number of any active customer dispute case associated with this debit note. Links to the SAP Collections and Dispute Management module for resolution tracking.',
    `distribution_channel` STRING COMMENT 'SAP SD distribution channel through which the original sale was made (e.g., direct sales, dealer, OEM). Part of the sales area determination for pricing and revenue reporting.',
    `division` STRING COMMENT 'SAP SD division representing the product line or business unit associated with the debit note. Used for segment reporting and revenue allocation.',
    `due_date` DATE COMMENT 'Date by which the customer is required to pay the debit note amount based on the applicable payment terms. Used for accounts receivable aging analysis and dunning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `dunning_block` BOOLEAN COMMENT 'Flag indicating whether the debit note open item is blocked from dunning (payment reminder) processing. Set when a dispute or credit hold is in progress.. Valid values are `true|false`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign currency exchange rate applied to convert the document currency amount to the company code local currency at the time of posting. Essential for multi-currency financial reporting.',
    `fiscal_period` STRING COMMENT 'Fiscal posting period (month) within the fiscal year for the debit note. Supports period-close reporting, revenue recognition, and accounts receivable subledger reconciliation.. Valid values are `^(0[1-9]|1[0-6])$`',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the debit note is posted. Used for period-end financial reporting, revenue recognition, and accounts receivable aging by fiscal period.. Valid values are `^d{4}$`',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total debit note amount inclusive of all taxes and surcharges in the document currency. Represents the total incremental amount owed by the customer.',
    `is_intercompany` BOOLEAN COMMENT 'Flag indicating whether the debit note is an intercompany transaction between two legal entities within the same corporate group. Drives intercompany elimination in consolidated financial statements.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the debit note record. Used for change tracking, delta extraction, and data lineage in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `local_currency_code` STRING COMMENT 'ISO 4217 currency code of the company code local currency (e.g., USD for US entity, EUR for German entity). Used for local statutory reporting and financial consolidation.. Valid values are `^[A-Z]{3}$`',
    `net_amount` DECIMAL(18,2) COMMENT 'Net debit amount before taxes in the document currency. Represents the incremental charge being levied on the customer above the original invoice amount.',
    `net_amount_local_currency` DECIMAL(18,2) COMMENT 'Net debit amount converted to the company code local currency using the applicable exchange rate. Required for local statutory financial reporting and general ledger posting.',
    `number` STRING COMMENT 'Business-facing document number assigned by SAP S/4HANA SD for the debit memo (billing document type DR). Used for customer communication, dispute resolution, and accounts receivable tracking.. Valid values are `^DR[0-9]{10}$`',
    `payer_account_number` STRING COMMENT 'SAP partner function payer account number responsible for settling the debit note amount. May differ from the sold-to customer in complex partner function scenarios.',
    `posting_date` DATE COMMENT 'Accounting posting date on which the debit note is recorded in the general ledger. Determines the fiscal period for revenue recognition and accounts receivable aging.. Valid values are `^d{4}-d{2}-d{2}$`',
    `reason_code` STRING COMMENT 'Standardized code classifying the business reason for issuing the debit note. Supports root cause analysis, revenue adjustment categorization, and management reporting. Examples include retroactive price increases, engineering change surcharges (ECN/ECO), tooling charges, freight surcharges, and penalties.. Valid values are `PRICE_ADJ|SURCHARGE|PENALTY|ENG_CHANGE|TOOLING|RETROACTIVE|FREIGHT|TAX_ADJ|OTHER`',
    `reason_description` STRING COMMENT 'Free-text narrative explaining the specific business justification for the debit note, such as retroactive price adjustment per amendment, tooling cost recovery, or engineering change order surcharge. Complements the reason code with contextual detail.',
    `reference_invoice_number` STRING COMMENT 'The original customer invoice number to which this debit note relates. Establishes the post-invoice adjustment linkage for accounts receivable reconciliation and audit trail.',
    `request_number` STRING COMMENT 'SAP SD debit memo request (sales document type DR) number that preceded and triggered the creation of this debit note billing document. Supports the two-step debit memo process.',
    `sales_organization` STRING COMMENT 'SAP SD sales organization responsible for the debit note. Defines the selling entity, pricing procedures, and revenue assignment for the transaction.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount (VAT, GST, sales tax, or other applicable taxes) calculated on the debit note net amount. Supports tax compliance reporting and remittance.',
    `tax_code` STRING COMMENT 'SAP tax code determining the applicable tax rate and tax category (VAT, GST, withholding tax) for the debit note. Drives tax calculation and reporting.',
    `created_by` STRING COMMENT 'SAP user ID of the person who created the debit note document. Required for audit trail, accountability, and segregation of duties.',
    CONSTRAINT pk_debit_note PRIMARY KEY(`debit_note_id`)
) COMMENT 'Formal debit memo issued to industrial customers to increase the amount owed beyond the original invoice. Captures debit note number, reference invoice, debit reason code (price adjustment, surcharge, penalty, additional scope), debit amount, tax amount, currency, approval status, and posting date. Used for post-invoice adjustments such as retroactive price increases, tooling charges, or engineering change surcharges. Managed in SAP S/4HANA SD as billing document type DR.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`payment_receipt` (
    `payment_receipt_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a payment receipt record in the accounts receivable process. Serves as the primary key for the payment_receipt data product.',
    `bank_account_id` BIGINT COMMENT 'Internal identifier of the companys bank account into which the payment was deposited. Used for bank reconciliation, treasury cash positioning, and multi-bank account management in SAP FI-TR.',
    `billing_payment_term_id` BIGINT COMMENT 'Foreign key linking to billing.payment_term. Business justification: payment_receipt has payment_terms_code (STRING) but needs proper FK payment_term_id to payment_term.payment_term_id for referential integrity and to access full payment term configuration. Removing pa',
    `payment_id` BIGINT COMMENT 'Foreign key linking to finance.payment. Business justification: Customer payments recorded in billing must post to finance payment records for cash application and bank reconciliation. Treasury uses this for daily cash positioning.',
    `procurement_supplier_invoice_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_invoice. Business justification: Payment receipts in accounts payable must reference the specific supplier invoice being paid. Treasury and procurement track which supplier invoices have been settled for cash flow management.',
    `amount_in_company_currency` DECIMAL(18,2) COMMENT 'The payment amount converted to the company codes functional currency using the applied exchange rate. Used for general ledger posting, financial reporting, and revenue recognition in the reporting currency.',
    `applied_amount` DECIMAL(18,2) COMMENT 'The portion of the received payment that has been applied (cleared) against one or more open invoices. May be less than payment_amount in the case of partial payments or unapplied cash.',
    `bank_reference_number` STRING COMMENT 'Reference number provided by the bank or payment network confirming the incoming funds transfer. Used for bank reconciliation and dispute resolution. Corresponds to the banks transaction ID or end-to-end reference.',
    `business_area` STRING COMMENT 'SAP business area code representing the organizational segment (e.g., product division, factory, region) responsible for the revenue associated with this payment. Supports segment reporting under IFRS 8.',
    `clearing_document_number` STRING COMMENT 'SAP FI-AR clearing document number generated when the incoming payment is applied against open invoice line items, confirming the accounts receivable clearing event in the general ledger.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity within the multinational enterprise that received the payment. Determines the general ledger, chart of accounts, and fiscal year variant applied to the posting.. Valid values are `^[A-Z0-9]{4}$`',
    `company_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the company codes functional (reporting) currency. Used to distinguish the local currency amount from the transaction currency amount in multi-currency environments.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the payment receipt record was first created in the source system (SAP FI-AR). Used for audit trail, data lineage, and SLA monitoring of payment processing turnaround times.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the currency in which the payment was received. Supports multi-currency billing for multinational industrial customers paying in local currencies.. Valid values are `^[A-Z]{3}$`',
    `customer_account_number` STRING COMMENT 'The SAP FI-AR customer account number (debtor number) associated with this payment receipt. Used to link the payment to the customers open item account and update the accounts receivable subledger.',
    `discount_taken_amount` DECIMAL(18,2) COMMENT 'The early payment discount amount deducted by the customer from the invoiced amount, in accordance with agreed payment terms (e.g., 2/10 net 30). Recorded for cash discount accounting and payment terms compliance monitoring.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign exchange rate applied to convert the transaction currency amount to the company code currency (functional currency) at the time of payment posting. Sourced from SAP FI exchange rate tables or treasury system.',
    `fiscal_period` STRING COMMENT 'The fiscal posting period (month) within the fiscal year in which the payment receipt is recorded. Supports monthly close, period-level AR aging, and management reporting aligned to the companys fiscal calendar.. Valid values are `^(0[1-9]|1[0-6])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the payment receipt is posted, as defined by the company codes fiscal year variant in SAP. Used for period-close, annual financial reporting, and year-end AR reconciliation.. Valid values are `^[0-9]{4}$`',
    `gl_account_code` STRING COMMENT 'The General Ledger (GL) account code to which the payment receipt is posted in the accounts receivable subledger. Typically maps to the trade receivables clearing account or bank clearing account in the chart of accounts.',
    `is_partial_payment` BOOLEAN COMMENT 'Boolean flag indicating whether the payment received does not fully settle all associated open invoices. When true, triggers partial clearing logic in SAP FI-AR and flags the receipt for collections follow-up on the remaining balance.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent update to the payment receipt record in the source system. Used for incremental data loading in the Databricks Silver layer, change data capture, and audit trail compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `notes` STRING COMMENT 'Free-text notes or remarks entered by the accounts receivable team regarding the payment receipt, such as customer communication details, dispute context, special clearing instructions, or exception handling notes.',
    `outstanding_balance` DECIMAL(18,2) COMMENT 'The remaining open accounts receivable balance for the customer after the payment has been applied to invoices. Represents unapplied cash or residual invoice balance. Used for AR aging and collections management.',
    `payment_channel` STRING COMMENT 'The channel or interface through which the payment was received and processed. Distinct from payment_method (instrument); channel describes the transmission path (e.g., SWIFT network, SEPA clearing, EDI 820 remittance, lockbox processing).. Valid values are `bank_portal|edi|manual_entry|customer_portal|lockbox|swift|sepa`',
    `payment_type` STRING COMMENT 'Classification of the payment indicating whether it fully settles the invoiced amount, partially covers it, represents an advance payment before invoicing, or constitutes an overpayment. Drives cash application logic and AR reporting.. Valid values are `full|partial|advance|overpayment|prepayment`',
    `posting_date` DATE COMMENT 'The accounting posting date on which the payment receipt was recorded in the general ledger. May differ from payment_date due to processing lag or period-end adjustments. Critical for period-close and financial reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `profit_center` STRING COMMENT 'SAP profit center to which the payment receipt is attributed for internal management accounting and profitability analysis. Enables revenue tracking at the business unit or product line level.',
    `receipt_number` STRING COMMENT 'Business-facing unique identifier for the payment receipt, used in customer communications, remittance advice matching, and audit trails. Follows the enterprise payment receipt numbering convention.. Valid values are `^PR-[0-9]{4}-[0-9]{8}$`',
    `remittance_reference` STRING COMMENT 'Customer-provided remittance advice reference or payment description included with the payment, used to match the incoming funds to specific invoices or purchase orders. Critical for automated cash application in high-volume AR environments.',
    `reversal_date` DATE COMMENT 'The date on which the payment receipt reversal was posted in the general ledger. Populated only when reversal_indicator is true. Used for period-close adjustments and AR aging recalculation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `reversal_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether this payment receipt has been reversed (e.g., due to returned check, failed ACH, or erroneous posting). When true, the associated clearing document is also reversed in SAP FI-AR.. Valid values are `true|false`',
    `reversal_reason_code` STRING COMMENT 'Standardized reason code explaining why the payment receipt was reversed. Populated only when reversal_indicator is true. Used for exception reporting, fraud detection, and process improvement analysis.. Valid values are `returned_check|failed_ach|duplicate_payment|incorrect_amount|customer_dispute|bank_error|other`',
    `source_system` STRING COMMENT 'The operational system of record from which this payment receipt record originated. Supports data lineage tracking, reconciliation between systems, and audit trail requirements in the Databricks Silver layer.. Valid values are `SAP_S4HANA|SALESFORCE|MANUAL|BANK_FEED|EDI|LOCKBOX`',
    `status` STRING COMMENT 'Current processing status of the payment receipt within the accounts receivable lifecycle. Drives workflow routing, cash application queues, and AR reporting. Transitions from received through posting, clearing, and potential reversal.. Valid values are `received|posted|cleared|partially_applied|unapplied|reversed|on_hold|cancelled`',
    `tax_amount` DECIMAL(18,2) COMMENT 'The tax component (e.g., VAT, GST, sales tax) included in or associated with the payment receipt. Required for tax compliance reporting, VAT reconciliation, and indirect tax filings across multiple jurisdictions.',
    `value_date` DATE COMMENT 'The bank value date on which the funds became available in the companys bank account. Used for cash flow reporting, treasury management, and bank reconciliation. May differ from payment_date for cross-border wire transfers.. Valid values are `^d{4}-d{2}-d{2}$`',
    `withholding_tax_amount` DECIMAL(18,2) COMMENT 'Amount of withholding tax deducted by the customer from the payment, common in cross-border industrial transactions in certain jurisdictions. Recorded for tax compliance, statutory reporting, and reconciliation against gross invoice amounts.',
    CONSTRAINT pk_payment_receipt PRIMARY KEY(`payment_receipt_id`)
) COMMENT 'Record of a payment received from an industrial customer against one or more invoices. Captures payment receipt number, payment date, payment method (wire transfer, ACH, check, letter of credit, direct debit), payment amount, currency, exchange rate applied, bank reference, clearing document number from SAP FI-AR, partial vs. full payment indicator, and outstanding balance after application. Links to the customer account and the invoices being settled. SSOT for incoming payment events in the accounts receivable process.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`payment_allocation` (
    `payment_allocation_id` BIGINT COMMENT 'Unique system-generated identifier for each payment allocation record linking a payment receipt to one or more invoices in the billing system.',
    `transaction_id` BIGINT COMMENT 'Unique identifier of the bank statement line item or electronic bank transaction associated with this payment, used for bank reconciliation and electronic bank statement (EBS) matching.',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Customer payments must be allocated to specific invoices to track which equipment deliveries are paid. Essential for accounts receivable aging, dunning, and cash application processes.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Payment allocation references customer account - normalize by replacing customer_account_number text with FK',
    `payment_receipt_id` BIGINT COMMENT 'Foreign key linking to billing.payment_receipt. Business justification: payment_allocation links payments to invoices. Currently has payment_document_number (STRING) but needs proper FK payment_receipt_id to payment_receipt.payment_receipt_id to establish the parent-child',
    `allocated_amount` DECIMAL(18,2) COMMENT 'The portion of the payment receipt applied to this specific invoice in the transaction currency. In partial payment scenarios, this may be less than the full invoice amount.',
    `allocated_amount_base_currency` DECIMAL(18,2) COMMENT 'The allocated amount converted to the companys functional (base) currency using the exchange rate at the time of allocation, required for consolidated financial reporting.',
    `allocation_date` DATE COMMENT 'The business date on which the payment was allocated and applied against the invoice. Used for aging analysis, cash application reporting, and revenue recognition timing.. Valid values are `^d{4}-d{2}-d{2}$`',
    `allocation_number` STRING COMMENT 'Business-facing unique reference number for the payment allocation record, used in correspondence and reconciliation with customers and finance teams.. Valid values are `^ALLOC-[0-9]{4}-[0-9]{8}$`',
    `allocation_type` STRING COMMENT 'Classifies the nature of the payment allocation. Distinguishes between full invoice clearance, partial payments, on-account postings (payment without invoice reference), credit/debit note offsets, and write-offs common in industrial B2B billing.. Valid values are `full_clearance|partial_payment|on_account|advance_payment|credit_note_offset|debit_note_offset|write_off|discount_clearance`',
    `base_currency` STRING COMMENT 'ISO 4217 three-letter currency code of the companys functional/reporting currency used for consolidated financial statements (e.g., USD for a US-headquartered multinational).. Valid values are `^[A-Z]{3}$`',
    `clearing_document_number` STRING COMMENT 'The FI clearing document number generated in the ERP system when the payment is matched and cleared against the invoice, confirming the offset of open items in accounts receivable.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity within the multinational group to which this payment allocation is posted. Enables entity-level financial reporting and intercompany reconciliation.. Valid values are `^[A-Z0-9]{4}$`',
    `cost_center` STRING COMMENT 'The cost center associated with the allocation for internal cost accounting purposes, particularly relevant when discount expenses or write-offs are posted to specific organizational units.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when the payment allocation record was first created in the system, used for audit trail, SLA tracking, and data lineage in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'The cash discount amount taken by the customer for early payment within the discount period (e.g., 2/10 net 30 terms). Reduces the effective payment received and is posted to a discount expense account.',
    `discount_percentage` DECIMAL(18,2) COMMENT 'The percentage rate of the early payment discount applied to the invoice amount, as defined in the customers payment terms (e.g., 0.02 for 2%). Used for discount eligibility validation.',
    `discount_taken_flag` BOOLEAN COMMENT 'Indicates whether the customer took an early payment discount on this allocation. True when a discount amount was deducted from the payment; False when full invoice amount was paid.. Valid values are `true|false`',
    `dispute_case_number` STRING COMMENT 'Reference number of the customer dispute or deduction case linked to this allocation, when the payment includes a short payment or deduction under dispute. Supports dispute management and collections workflows.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign exchange rate applied to convert the transaction currency amount to the base currency at the time of allocation posting. Sourced from the ERP exchange rate table.',
    `fiscal_period` STRING COMMENT 'The accounting period (month) within the fiscal year in which this allocation is posted. Used for period-end close, AR aging, and monthly revenue reporting.. Valid values are `^(0[1-9]|1[0-6])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year in which this payment allocation is recorded for financial reporting purposes. May differ from the calendar year depending on the companys fiscal year variant.. Valid values are `^[0-9]{4}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when the payment allocation record was most recently updated, supporting change tracking, audit compliance, and incremental data loading in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `notes` STRING COMMENT 'Free-text notes or comments entered by the accounts receivable analyst regarding special circumstances, customer instructions, or exceptions related to this payment allocation.',
    `payment_method` STRING COMMENT 'The instrument or mechanism used by the customer to make the payment (e.g., wire transfer, ACH, check, letter of credit). Relevant for bank reconciliation and treasury cash management in multinational operations.. Valid values are `bank_transfer|wire_transfer|check|ach|direct_debit|letter_of_credit|credit_card|netting|offset`',
    `payment_reference` STRING COMMENT 'Customer-provided payment reference or remittance advice number included with the payment (e.g., bank transfer reference, check number, wire reference). Used for automated cash application matching.',
    `posting_date` DATE COMMENT 'The accounting posting date on which the allocation entry is recorded in the general ledger, which may differ from the allocation date due to period-end processing or backdating.. Valid values are `^d{4}-d{2}-d{2}$`',
    `profit_center` STRING COMMENT 'The profit center to which the payment allocation revenue is attributed for internal management accounting and profitability analysis by business unit or product line.',
    `residual_amount` DECIMAL(18,2) COMMENT 'The remaining open balance on the invoice after this allocation is applied. A non-zero residual indicates a partial payment; zero indicates full clearance of the invoice.',
    `reversal_date` DATE COMMENT 'The date on which the payment allocation was reversed, if applicable. Populated only when reversal_flag is True. Used for audit trail and period-end reconciliation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `reversal_flag` BOOLEAN COMMENT 'Indicates whether this payment allocation has been reversed (cancelled). True when the allocation was reversed due to returned payment, incorrect posting, or dispute resolution.. Valid values are `true|false`',
    `reversal_reason` STRING COMMENT 'The business reason code explaining why the payment allocation was reversed (e.g., returned payment, duplicate posting, customer dispute, bank chargeback). Required for audit and exception reporting.. Valid values are `returned_payment|incorrect_posting|duplicate_payment|customer_dispute|bank_chargeback|other`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this payment allocation record originated (e.g., SAP S/4HANA FI-AR). Supports data lineage tracking and multi-source reconciliation in the lakehouse.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL|LEGACY`',
    `status` STRING COMMENT 'Current processing status of the payment allocation record. Cleared indicates full invoice settlement; Partially_cleared indicates partial payment applied; On_account indicates payment received but not yet matched to an invoice; Reversed indicates the allocation was cancelled.. Valid values are `draft|pending|posted|cleared|reversed|disputed|on_account|partially_cleared`',
    `tax_amount` DECIMAL(18,2) COMMENT 'The tax component (e.g., VAT, GST, sales tax) included within the allocated amount, required for tax reporting, VAT reconciliation, and compliance with local tax authorities across jurisdictions.',
    `tax_code` STRING COMMENT 'The tax determination code applied to this allocation, identifying the applicable tax rate and jurisdiction rules (e.g., domestic VAT, export zero-rated, reverse charge). Drives tax reporting and compliance.',
    `transaction_currency` STRING COMMENT 'ISO 4217 three-letter currency code of the currency in which the payment was received and the allocation is recorded (e.g., USD, EUR, GBP). Supports multi-currency billing for global OEM customers.. Valid values are `^[A-Z]{3}$`',
    `value_date` DATE COMMENT 'The bank value date on which the funds were credited to the companys bank account, used for cash flow reporting and bank reconciliation in treasury operations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `withholding_tax_amount` DECIMAL(18,2) COMMENT 'Amount of withholding tax deducted by the customer from the payment, applicable in certain jurisdictions (e.g., India TDS, Brazil IRRF). Reduces the net payment received and requires separate tax reporting.',
    CONSTRAINT pk_payment_allocation PRIMARY KEY(`payment_allocation_id`)
) COMMENT 'Association record linking a payment receipt to one or more invoices, capturing how a customer payment is allocated across outstanding billing documents. Records the allocated amount per invoice, allocation date, clearing document reference, residual amount, discount taken (early payment discount), and allocation status. Supports partial payment scenarios, on-account payments, and multi-invoice clearing common in industrial B2B billing with large OEM customers.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`plan` (
    `plan_id` BIGINT COMMENT 'Unique system-generated identifier for the billing plan record. Serves as the primary key for all billing plan transactions and references across the enterprise.',
    `billing_payment_term_id` BIGINT COMMENT 'Foreign key linking to billing.payment_term. Business justification: billing_plan has payment_terms_code (STRING) but needs proper FK payment_term_id to payment_term.payment_term_id for referential integrity and to access full payment term configuration. Removing payme',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: Multi-year service contracts require billing plans with milestone-based or periodic invoicing. Billing plans reference service contracts to schedule recurring maintenance billing and contract-based re',
    `performance_obligation_id` BIGINT COMMENT 'Identifier linking this billing plan to a specific performance obligation as defined under IFRS 15 / ASC 606. Enables allocation of transaction price to distinct deliverables within a multi-element contract.',
    `sales_opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Large manufacturing projects (factory automation, infrastructure) use milestone billing plans negotiated during the sales opportunity. Links billing schedule to original deal for project accounting an',
    `sla_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.sla_agreement. Business justification: Billing plans for service contracts reference SLA agreements that define service levels and billing triggers for maintenance, support, or managed services in manufacturing.',
    `approval_status` STRING COMMENT 'Workflow approval status of the billing plan. Billing plans for high-value ETO contracts typically require multi-level approval before activation. Tracks the current state in the approval workflow.. Valid values are `pending|approved|rejected|revision_required`',
    `approved_by` STRING COMMENT 'Name or employee identifier of the person who approved the billing plan. Required for audit trail and SOX compliance in financial transaction authorization.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the billing plan was formally approved. Provides an immutable audit record for financial governance and SOX compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `billed_amount` DECIMAL(18,2) COMMENT 'Cumulative monetary amount that has been invoiced to date against this billing plan. Used to track billing progress and calculate the remaining unbilled balance.',
    `billing_block_reason` STRING COMMENT 'Reason code indicating why invoice generation is currently blocked for this billing plan. Billing blocks prevent premature invoicing until conditions are met (e.g., milestone sign-off, credit clearance, contract amendment approval).. Valid values are `none|credit_hold|pending_approval|milestone_incomplete|dispute|legal_hold|contract_amendment`',
    `billing_frequency` STRING COMMENT 'Defines how often invoices are generated under this billing plan for periodic billing types. Milestone-driven plans generate invoices upon milestone completion rather than on a fixed schedule.. Valid values are `one_time|weekly|biweekly|monthly|quarterly|semi_annual|annual|milestone_driven|on_demand`',
    `billing_rule` STRING COMMENT 'Defines the calculation method used to determine the invoice amount for each billing line. Fixed amount bills a predetermined sum; percentage of contract applies a rate to the total contract value; percentage of completion ties billing to project progress; time and material bills actuals; unit price bills per delivered unit.. Valid values are `fixed_amount|percentage_of_contract|percentage_of_completion|time_and_material|unit_price|cost_plus`',
    `company_code` STRING COMMENT 'SAP company code identifying the legal entity responsible for this billing plan. Enables multi-entity financial reporting, intercompany billing, and statutory compliance across the multinational enterprise.. Valid values are `^[A-Z0-9]{4}$`',
    `contract_type` STRING COMMENT 'Indicates the manufacturing contract model associated with this billing plan. ETO (Engineer-to-Order) and MTO (Make-to-Order) contracts typically use milestone or progress billing; MTS (Make-to-Stock) and ATO (Assemble-to-Order) may use periodic or partial invoice plans.. Valid values are `eto|mto|mts|ato|service|maintenance|framework`',
    `contract_value` DECIMAL(18,2) COMMENT 'Total agreed contract value to which this billing plan is attached. Used as the basis for percentage-based billing calculations and revenue recognition. Expressed in the plan currency.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the billing entity or contract jurisdiction. Drives tax determination, regulatory compliance, and multi-country financial reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the billing plan record was initially created in the system. Provides the starting point for the billing plan lifecycle audit trail.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the billing plan. Supports multi-currency billing for multinational contracts (e.g., USD, EUR, GBP, JPY). All monetary amounts in this plan are expressed in this currency.. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Detailed narrative describing the purpose, scope, and terms of the billing plan. Includes context about the associated project, contract, or delivery arrangement.',
    `down_payment_amount` DECIMAL(18,2) COMMENT 'Initial advance payment amount required before project commencement or manufacturing start. Common in ETO and large capital equipment contracts to secure commitment and fund early-stage procurement.',
    `down_payment_percentage` DECIMAL(18,2) COMMENT 'Down payment expressed as a percentage of the total contract value. Used when the down payment is defined as a proportion rather than a fixed amount.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `end_date` DATE COMMENT 'The date on which the billing plan expires or the final billing event is expected to occur. Used for contract lifecycle management and revenue recognition period determination.. Valid values are `^d{4}-d{2}-d{2}$`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the point of risk and cost transfer between seller and buyer. Influences revenue recognition timing and billing trigger conditions for capital equipment deliveries.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `is_billing_blocked` BOOLEAN COMMENT 'Flag indicating whether invoice generation is currently blocked for this billing plan. When true, the billing run will skip this plan until the block is removed.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the billing plan record. Used for change tracking, data synchronization, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `name` STRING COMMENT 'Descriptive name for the billing plan, providing a human-readable label for identification in reports, dashboards, and contract documentation.',
    `next_billing_date` DATE COMMENT 'The scheduled date for the next invoice generation under this billing plan. Drives automated billing runs in SAP S/4HANA and accounts receivable planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `number` STRING COMMENT 'Business-facing alphanumeric identifier for the billing plan, used in customer communications, contract references, and financial reporting. Follows enterprise numbering conventions.. Valid values are `^BP-[0-9]{4}-[0-9]{6}$`',
    `payment_method` STRING COMMENT 'Specifies the agreed method of payment for invoices generated under this billing plan. Letter of credit is common for large international capital equipment contracts.. Valid values are `bank_transfer|check|letter_of_credit|direct_debit|wire_transfer|escrow`',
    `retention_percentage` DECIMAL(18,2) COMMENT 'Percentage of each invoice amount withheld by the customer as retention until final project acceptance or warranty expiry. Common in large industrial construction and automation system contracts.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `retention_release_date` DATE COMMENT 'Scheduled date on which withheld retention amounts are released and invoiced to the customer, typically upon final acceptance, commissioning completion, or warranty period expiry.. Valid values are `^d{4}-d{2}-d{2}$`',
    `revenue_recognition_method` STRING COMMENT 'Defines how revenue is recognized for this billing plan in accordance with IFRS 15 / ASC 606. Point-in-time recognition applies when control transfers at a specific moment; over-time methods apply for long-term ETO contracts where performance obligations are satisfied progressively.. Valid values are `point_in_time|over_time_percentage_completion|over_time_input_method|over_time_output_method`',
    `sales_organization` STRING COMMENT 'SAP sales organization responsible for the contract and billing plan. Determines pricing procedures, output determination, and revenue assignment in the enterprise structure.',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this billing plan record originated. Supports data lineage tracking and reconciliation in the Databricks Silver Layer lakehouse.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL|LEGACY`',
    `start_date` DATE COMMENT 'The date on which the billing plan becomes effective and the first billing event may be triggered. Aligns with contract commencement or project kickoff date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `status` STRING COMMENT 'Current lifecycle status of the billing plan. Tracks progression from initial creation through active billing, partial completion, full billing, and closure or cancellation.. Valid values are `draft|active|on_hold|partially_billed|fully_billed|cancelled|closed`',
    `tax_classification` STRING COMMENT 'Indicates the VAT/GST/sales tax treatment applicable to invoices generated from this billing plan. Reverse charge applies in cross-border B2B transactions within the EU. Drives tax calculation in SAP S/4HANA.. Valid values are `taxable|exempt|zero_rated|reverse_charge|out_of_scope`',
    `tax_code` STRING COMMENT 'System tax code used to determine the applicable tax rate and jurisdiction for invoice generation. Maps to SAP S/4HANA tax condition records and supports multi-jurisdiction tax compliance.',
    `total_plan_amount` DECIMAL(18,2) COMMENT 'Total monetary value scheduled for billing across all milestones or periods in this billing plan, expressed in the plan currency. Represents the sum of all planned billing line amounts and must reconcile with the associated sales order or contract value.',
    `type` STRING COMMENT 'Classifies the billing plan structure. Milestone billing triggers invoices upon completion of defined project milestones. Periodic billing generates invoices at regular intervals. Partial invoice supports staged billing for large capital equipment or ETO (Engineer-to-Order) contracts. Progress billing ties invoices to percentage of work completed.. Valid values are `milestone|periodic|partial_invoice|down_payment|progress_billing|advance_payment`',
    `unbilled_amount` DECIMAL(18,2) COMMENT 'Remaining monetary amount yet to be invoiced under this billing plan, calculated as total plan amount minus billed amount. Critical for revenue backlog reporting and accounts receivable forecasting.',
    CONSTRAINT pk_plan PRIMARY KEY(`plan_id`)
) COMMENT 'Defines the structured billing schedule for milestone-based, periodic, or progress-based billing arrangements common in ETO (Engineer-to-Order) and long-term industrial contracts. Captures billing plan type (milestone, periodic, partial invoice), billing plan dates, planned billing amounts or percentages per milestone, milestone description, completion criteria, billing rule, and link to the sales order or project. Supports multi-stage billing for large automation system deliveries and capital equipment projects.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`plan_milestone` (
    `plan_milestone_id` BIGINT COMMENT 'Unique system-generated identifier for each billing plan milestone record within the billing domain. Serves as the primary key for this entity.',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Each milestone billing event (design completion, equipment delivery, installation) generates an invoice. Links milestone to actual invoice for project revenue tracking and customer payment monitoring.',
    `billing_payment_term_id` BIGINT COMMENT 'Foreign key linking to billing.payment_term. Business justification: billing_plan_milestone has payment_terms_code (STRING) but needs proper FK payment_term_id to payment_term.payment_term_id for referential integrity and to access full payment term configuration. Remo',
    `it_project_milestone_id` BIGINT COMMENT 'Foreign key linking to technology.it_project_milestone. Business justification: IT project milestones (system go-live, UAT completion) trigger billing events in manufacturing. Finance links billing plans to technical milestones for automated invoice generation upon milestone comp',
    `plan_id` BIGINT COMMENT 'Foreign key linking to billing.billing_plan. Business justification: Billing plan milestones belong to a parent billing plan. Adding billing_plan_id FK establishes the parent-child relationship. The billing_plan_type column is redundant as it can be retrieved from the ',
    `project_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_project. Business justification: Engineering projects use milestone billing (design completion, prototype delivery, validation). Billing milestones tie to project phases for progressive invoicing as engineering deliverables are compl',
    `rd_milestone_id` BIGINT COMMENT 'Foreign key linking to research.rd_milestone. Business justification: Milestone-based billing for R&D contracts triggers invoicing when technical milestones are achieved (prototype delivery, testing completion). Finance uses this to align billing with project progress.',
    `revenue_recognition_event_id` BIGINT COMMENT 'Foreign key linking to billing.revenue_recognition_event. Business justification: billing_plan_milestone triggers revenue recognition events when milestones are completed. Needs FK revenue_recognition_event_id to revenue_recognition_event.revenue_recognition_event_id to track which',
    `actual_billing_date` DATE COMMENT 'The date on which the invoice for this milestone was actually created and issued to the customer. Compared against planned_billing_date to measure billing timeliness and schedule adherence.. Valid values are `^d{4}-d{2}-d{2}$`',
    `amount_in_company_currency` DECIMAL(18,2) COMMENT 'The milestone billing amount converted to the companys local reporting currency using the applicable exchange rate. Used for financial consolidation, revenue reporting, and IFRS/GAAP compliance.',
    `billed_amount` DECIMAL(18,2) COMMENT 'The cumulative amount that has been invoiced against this milestone to date. For partially billed milestones, this is less than net_billing_amount. Used to track billing progress and remaining unbilled value.',
    `billing_block_reason` STRING COMMENT 'The reason code explaining why a billing milestone is currently blocked from invoicing. Used by finance and project teams to manage billing holds and resolve blockers before the planned billing date.. Valid values are `credit_limit_exceeded|dispute_open|approval_pending|contract_amendment|quality_hold|customer_request|legal_review|none`',
    `billing_category` STRING COMMENT 'Classifies the commercial nature of the billing milestone within the contract payment structure: advance payment (upfront), progress payment (during execution), delivery payment (on shipment), acceptance payment (on customer sign-off), retention release, or final payment.. Valid values are `advance_payment|progress_payment|delivery_payment|acceptance_payment|retention_release|final_payment`',
    `billing_rule` STRING COMMENT 'Defines the triggering rule for this billing milestone — whether it is triggered by a fixed calendar date, a project milestone event, a percentage of work completion, time-and-material actuals, an advance payment schedule, or a retention release.. Valid values are `fixed_date|milestone_event|percentage_completion|time_and_material|advance_payment|retention_release`',
    `company_currency_code` STRING COMMENT 'ISO 4217 three-letter code for the companys local reporting currency used for financial consolidation (e.g., USD, EUR). Distinct from the document currency in which the customer is billed.. Valid values are `^[A-Z]{3}$`',
    `completion_confirmed` BOOLEAN COMMENT 'Indicates whether the milestone deliverable or event has been formally confirmed as complete by the responsible party (project manager, customer, or quality inspector). A value of True is typically required before billing can proceed.. Valid values are `true|false`',
    `completion_date` DATE COMMENT 'The date on which the milestone deliverable was formally confirmed as completed. Used to measure schedule variance against planned_billing_date and to trigger the billing process.. Valid values are `^d{4}-d{2}-d{2}$`',
    `cost_center` STRING COMMENT 'The cost center code associated with this billing milestone for internal cost allocation and management accounting purposes. Used in project cost tracking and variance analysis.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customer or delivery location relevant to this billing milestone. Used for tax jurisdiction determination, regulatory compliance, and multi-country revenue reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this billing plan milestone record was created in the system. Used for audit trail, data lineage, and compliance with financial record-keeping requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the milestone billing amount (e.g., USD, EUR, GBP, JPY). Supports multi-currency billing for multinational ETO projects.. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Detailed narrative description of the billing milestone, including the deliverable or event that triggers billing. Provides context for project managers, finance teams, and customers.',
    `due_date` DATE COMMENT 'The date by which payment for this milestone invoice is due from the customer, calculated based on invoice_date and payment_terms_code. Used for accounts receivable aging, dunning, and cash flow management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign exchange rate applied to convert the milestone billing amount from document currency to company currency at the time of billing. Captured for audit and financial reconciliation purposes.',
    `invoice_date` DATE COMMENT 'The official date printed on the invoice document issued for this milestone. May differ from actual_billing_date in cases of backdating or document posting adjustments.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this billing plan milestone record was last updated. Supports change tracking, audit compliance, and incremental data loading in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `milestone_amount` DECIMAL(18,2) COMMENT 'The absolute monetary amount to be billed for this milestone in the document currency. Represents the invoice value for this specific billing event. Either this or milestone_percentage is used depending on billing plan configuration.',
    `milestone_number` STRING COMMENT 'Sequential number indicating the order of this milestone within the billing plan. Used to sort and display milestones in chronological billing sequence (e.g., 10, 20, 30).. Valid values are `^[0-9]{1,4}$`',
    `milestone_percentage` DECIMAL(18,2) COMMENT 'The percentage of the total contract value to be billed at this milestone. Used when billing is defined as a proportion of the overall contract amount rather than a fixed sum (e.g., 30% on design completion).. Valid values are `^(100(.0{1,4})?|d{1,2}(.d{1,4})?)$`',
    `net_billing_amount` DECIMAL(18,2) COMMENT 'The net amount actually invoiced for this milestone after deducting retention and any applicable discounts from the gross milestone_amount. Represents the actual receivable created upon billing.',
    `planned_billing_date` DATE COMMENT 'The contractually agreed or planned date on which this milestone is scheduled to be invoiced. Used for cash flow forecasting, revenue planning, and accounts receivable scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `profit_center` STRING COMMENT 'The profit center code to which the revenue from this billing milestone is assigned for internal management accounting and profitability reporting. Aligns with the organizational unit responsible for the project.',
    `project_milestone_reference` STRING COMMENT 'The reference identifier linking this billing milestone to the corresponding project milestone or work breakdown structure (WBS) element in the project management system. Enables traceability between project execution and billing.',
    `retention_amount` DECIMAL(18,2) COMMENT 'The absolute monetary value withheld as retention from this milestone billing. Calculated from retention_percentage applied to milestone_amount. Tracked separately for accounts receivable aging and cash flow forecasting.',
    `retention_percentage` DECIMAL(18,2) COMMENT 'The percentage of the milestone amount withheld as retention by the customer until final project acceptance or warranty expiry. Common in ETO automation and infrastructure contracts. Retention is released as a separate billing milestone.. Valid values are `^(100(.0{1,4})?|d{1,2}(.d{1,4})?)$`',
    `revenue_recognition_date` DATE COMMENT 'The date on which revenue for this milestone is recognized in the financial statements, which may differ from the billing date based on performance obligation completion criteria under IFRS 15 / ASC 606.. Valid values are `^d{4}-d{2}-d{2}$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this billing plan milestone record originated (e.g., SAP S/4HANA SD module). Supports data lineage tracking and multi-source reconciliation in the lakehouse.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL|LEGACY`',
    `source_system_key` STRING COMMENT 'The natural or technical key of this billing plan milestone record in the originating source system (e.g., SAP billing plan item key). Enables traceability back to the system of record and supports reconciliation and audit.',
    `status` STRING COMMENT 'Current processing status of the billing milestone. Open indicates not yet invoiced; partially_billed means a portion has been invoiced; fully_billed means the full amount has been invoiced; blocked prevents billing until released; cancelled means the milestone is no longer applicable.. Valid values are `open|partially_billed|fully_billed|blocked|cancelled|on_hold`',
    `tax_amount` DECIMAL(18,2) COMMENT 'The calculated tax amount applicable to this billing milestone, including VAT, GST, or other applicable taxes based on the customers jurisdiction and product/service tax classification.',
    `tax_code` STRING COMMENT 'The tax determination code assigned to this milestone, used to calculate applicable taxes (VAT, GST, withholding tax) based on jurisdiction, customer type, and product/service classification.',
    `unbilled_amount` DECIMAL(18,2) COMMENT 'The remaining amount yet to be invoiced for this milestone (net_billing_amount minus billed_amount). Represents the unbilled receivable or contract asset for revenue recognition and financial reporting purposes.',
    `wbs_element` STRING COMMENT 'The Work Breakdown Structure (WBS) element code from the project system that this billing milestone is associated with. Enables cost and revenue assignment to specific project deliverables for project profitability analysis.',
    CONSTRAINT pk_plan_milestone PRIMARY KEY(`plan_milestone_id`)
) COMMENT 'Individual milestone or periodic billing date line within a billing plan. Captures milestone sequence number, milestone description, planned billing date, billing amount or percentage of total contract value, actual billing date, invoice reference once billed, milestone status (open, partially billed, fully billed, blocked), and completion confirmation flag. Enables tracking of billing progress against project milestones for ETO automation systems and infrastructure projects.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` (
    `revenue_recognition_event_id` BIGINT COMMENT 'Unique system-generated identifier for each revenue recognition event record in the billing domain. Serves as the primary key for the revenue_recognition_event data product.',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Revenue recognition for manufacturing projects follows ASC 606 rules, often differing from billing timing. Links recognition events to invoices for financial reporting and audit compliance.',
    `delivery_order_id` BIGINT COMMENT 'Foreign key linking to order.delivery_order. Business justification: Revenue recognition triggered by delivery - normalize by replacing delivery_document_number text with FK',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Revenue recognition events post to GL accounts for deferred and recognized revenue. Finance uses this for revenue schedule management and compliance.',
    `it_project_id` BIGINT COMMENT 'Foreign key linking to technology.it_project. Business justification: Revenue recognition for IT projects follows percentage-of-completion or milestone methods. Accounting teams link recognition events to projects for ASC 606 compliance and project profitability analysi',
    `journal_entry_id` BIGINT COMMENT 'Foreign key linking to finance.journal_entry. Business justification: Revenue recognition events trigger GL journal entries for deferred revenue and revenue realization. Finance uses this for ASC 606/IFRS 15 compliance.',
    `performance_obligation_id` BIGINT COMMENT 'Identifier for the specific performance obligation within the contract that this recognition event satisfies. Supports multi-element arrangement accounting for bundled automation solutions where a single contract may contain multiple distinct obligations (e.g., equipment delivery, installation, software license, maintenance).',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Revenue recognition event tied to sales order - normalize by replacing sales_order_number text with FK',
    `accounting_period` STRING COMMENT 'The fiscal accounting period (YYYY-MM) to which this revenue recognition event is posted. Used for period-end close, revenue reporting, and financial statement preparation. Must align with the companys fiscal calendar.. Valid values are `^d{4}-(0[1-9]|1[0-2])$`',
    `approved_timestamp` TIMESTAMP COMMENT 'The timestamp when this revenue recognition event was approved by the finance reviewer. Supports the financial close workflow and provides an audit trail for SOX compliance and IFRS 15 internal controls.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `company_code` STRING COMMENT 'SAP S/4HANA company code representing the legal entity responsible for this revenue recognition event. Determines the chart of accounts, fiscal year variant, and statutory reporting requirements applicable to the event.',
    `company_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the company codes functional (local) currency. Used for local statutory reporting and general ledger posting in the companys home currency.. Valid values are `^[A-Z]{3}$`',
    `contract_asset_balance` DECIMAL(18,2) COMMENT 'The contract asset balance after this recognition event, representing revenue recognized in excess of amounts billed to the customer. Arises when performance obligations are satisfied before the right to invoice is unconditional. Required for IFRS 15 / ASC 606 balance sheet disclosure.',
    `contract_liability_balance` DECIMAL(18,2) COMMENT 'The total outstanding contract liability balance after this recognition event is applied. Represents cumulative deferred revenue for the contract, reflecting amounts received or billed in advance of performance obligation satisfaction. Required for IFRS 15 / ASC 606 balance sheet disclosure.',
    `contract_number` STRING COMMENT 'Reference to the customer contract under which this revenue recognition event is triggered. Links the recognition event to the originating sales or service contract for multi-element arrangement accounting.',
    `cost_center` STRING COMMENT 'SAP S/4HANA cost center associated with the revenue recognition event, used for internal cost allocation and management reporting. Relevant for service-related performance obligations where cost tracking is required.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the revenue recognition event occurs. Used for country-level revenue reporting, tax jurisdiction determination, and regulatory compliance (e.g., VAT, GST).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this revenue recognition event record was created in the system. Used for audit trail, data lineage, and financial close monitoring.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the transaction currency in which the revenue recognition amounts are denominated (e.g., USD, EUR, GBP, JPY). Supports multi-currency billing for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `customer_acceptance_date` DATE COMMENT 'The date on which the customer formally accepted the delivered goods, completed installation, or signed off on a milestone. For customer_acceptance event types, this date determines the recognition date and is required for audit evidence under IFRS 15.. Valid values are `^d{4}-d{2}-d{2}$`',
    `deferred_revenue_amount` DECIMAL(18,2) COMMENT 'The amount of revenue that remains deferred (unrecognized) as of this event, representing the contract liability balance for performance obligations not yet satisfied. Reported on the balance sheet as a contract liability.',
    `event_number` STRING COMMENT 'Human-readable business reference number for the revenue recognition event, used for cross-referencing in financial reports, audit trails, and communication with finance teams. Typically formatted as RRE-YYYY-NNNNNNNN.. Valid values are `^RRE-[0-9]{4}-[0-9]{8}$`',
    `event_type` STRING COMMENT 'Classification of the trigger that caused revenue to be recognized. Determines the accounting treatment applied. Key types include: goods_delivery (point-in-time on physical delivery), customer_acceptance (point-in-time on formal sign-off), milestone_sign_off (contractual milestone completion), percentage_of_completion (over-time method for long-term contracts such as ETO automation systems), software_activation, service_rendered, subscription_period, bill_and_hold, and usage_based.. Valid values are `goods_delivery|customer_acceptance|milestone_sign_off|percentage_of_completion|software_activation|service_rendered|subscription_period|bill_and_hold|usage_based`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign exchange rate applied to convert the transaction currency amounts to the company functional currency at the recognition date. Stored for audit traceability and restatement purposes.',
    `fiscal_year` STRING COMMENT 'The fiscal year in which this revenue recognition event is recorded. Used for annual revenue reporting, IFRS 15 / ASC 606 disclosure, and year-end financial close.. Valid values are `^d{4}$`',
    `gl_account_code` STRING COMMENT 'The general ledger account code to which the recognized revenue is posted in SAP S/4HANA FI. Determines the income statement line item for revenue reporting and financial close.',
    `group_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the corporate groups reporting currency (e.g., USD for a US-headquartered multinational). Used for consolidated financial reporting and group-level revenue analytics.. Valid values are `^[A-Z]{3}$`',
    `is_intercompany` BOOLEAN COMMENT 'Indicates whether this revenue recognition event relates to an intercompany transaction between legal entities within the same corporate group. Intercompany revenue must be eliminated in consolidated financial statements.. Valid values are `true|false`',
    `milestone_reference` STRING COMMENT 'Reference identifier for the contractual milestone that triggered this recognition event. Applicable for milestone_sign_off event types in long-term ETO automation and infrastructure contracts. Links to the project milestone in SAP PS or Teamcenter.',
    `percentage_of_completion` DECIMAL(18,2) COMMENT 'For over-time recognition events, the cumulative percentage of the performance obligation completed as of the recognition date. Calculated using input methods (cost incurred / total estimated cost) or output methods (milestones achieved, units delivered). Drives the recognized revenue amount for long-term ETO automation contracts.. Valid values are `^(100(.00?)?|d{1,2}(.d{1,2})?)$`',
    `performance_obligation_description` STRING COMMENT 'Descriptive label for the performance obligation being satisfied, such as Automation System Hardware Delivery, Software License Activation, Installation and Commissioning, or Annual Maintenance Service. Supports audit and financial disclosure.',
    `profit_center` STRING COMMENT 'SAP S/4HANA profit center to which the recognized revenue is attributed. Enables segment-level revenue reporting, profitability analysis (CO-PA), and management accounting by business unit or product line.',
    `recognition_date` DATE COMMENT 'The business date on which revenue is recognized for this event. This is the date used for accounting entries and period allocation. For point-in-time events, this is the delivery or acceptance date; for over-time events, this is the period-end date of the recognition calculation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `recognition_method` STRING COMMENT 'Indicates whether revenue is recognized at a single point in time (e.g., goods delivery, customer acceptance) or over time (e.g., percentage of completion for long-term ETO contracts, subscription services). Drives the accounting model applied under IFRS 15 / ASC 606.. Valid values are `point_in_time|over_time`',
    `recognized_amount` DECIMAL(18,2) COMMENT 'The amount of revenue recognized in the transaction currency for this event. Represents the portion of the transaction price allocated to the satisfied performance obligation and recognized in the income statement for the accounting period.',
    `recognized_amount_company_currency` DECIMAL(18,2) COMMENT 'The recognized revenue amount converted to the company codes functional currency using the exchange rate at the recognition date. Used for local statutory financial reporting and general ledger posting.',
    `recognized_amount_group_currency` DECIMAL(18,2) COMMENT 'The recognized revenue amount converted to the corporate group reporting currency. Used for consolidated revenue reporting, group-level IFRS 15 disclosures, and executive financial dashboards.',
    `reversal_date` DATE COMMENT 'The date on which a previously posted revenue recognition event was reversed. Populated only for events with status reversed. Used for audit trail and restatement tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `reversal_reason` STRING COMMENT 'The business reason for reversing a previously posted revenue recognition event. Supports audit trail requirements and IFRS 15 / ASC 606 contract modification accounting.. Valid values are `contract_modification|customer_return|billing_error|period_correction|cancellation|other`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this revenue recognition event originated. SAP_RAR indicates SAP Revenue Accounting and Reporting; SAP_SD indicates origination from Sales and Distribution billing; MANUAL indicates a manually entered event; MIGRATION indicates data migrated from a legacy system.. Valid values are `SAP_RAR|SAP_SD|SAP_FI|MANUAL|MIGRATION`',
    `status` STRING COMMENT 'Current processing status of the revenue recognition event in the financial close workflow. Draft events are under preparation; pending_review awaits finance approval; approved events are validated; posted events have been recorded in the general ledger; reversed events have been corrected; cancelled events are voided.. Valid values are `draft|pending_review|approved|posted|reversed|cancelled`',
    `tax_amount` DECIMAL(18,2) COMMENT 'The tax amount (VAT, GST, sales tax) associated with the recognized revenue for this event. Excluded from recognized revenue per IFRS 15 / ASC 606 (revenue is recognized net of taxes collected on behalf of tax authorities).',
    `transaction_price_allocated` DECIMAL(18,2) COMMENT 'The portion of the total contract transaction price allocated to this specific performance obligation using the relative standalone selling price (SSP) method. Drives the maximum revenue recognizable for this obligation under IFRS 15 / ASC 606.',
    CONSTRAINT pk_revenue_recognition_event PRIMARY KEY(`revenue_recognition_event_id`)
) COMMENT 'Records individual revenue recognition events triggered by delivery, acceptance, or milestone completion for industrial products and automation systems. Captures recognition event type (goods delivery, customer acceptance, milestone sign-off, percentage of completion), recognition date, recognized revenue amount, deferred revenue amount, performance obligation reference, contract liability balance, accounting period, and IFRS 15 / ASC 606 compliance attributes. Supports multi-element arrangement accounting for bundled automation solutions.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`performance_obligation` (
    `performance_obligation_id` BIGINT COMMENT 'Unique system-generated identifier for each distinct performance obligation within a customer contract, used as the primary key for revenue recognition tracking under IFRS 15 / ASC 606.',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: Service contracts contain distinct performance obligations for revenue recognition under ASC 606. Finance tracks each obligation (maintenance, support, upgrades) separately for proper revenue allocati',
    `project_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_project. Business justification: Under ASC 606, engineering projects create performance obligations (design, testing, certification). Revenue recognition tracks fulfillment of contractual engineering deliverables tied to specific pro',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: Under ASC 606, custom R&D contracts create performance obligations tied to specific projects (deliver prototype, complete testing). Revenue recognition requires linking obligations to R&D deliverables',
    `actual_completion_date` DATE COMMENT 'The actual date on which the performance obligation was fully satisfied and accepted by the customer. Triggers final revenue recognition for point-in-time obligations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `allocated_price_company_currency` DECIMAL(18,2) COMMENT 'The allocated transaction price converted to the companys functional/reporting currency using the applicable exchange rate, for financial consolidation and statutory reporting.',
    `allocated_transaction_price` DECIMAL(18,2) COMMENT 'The portion of the total contract transaction price allocated to this specific performance obligation, based on relative standalone selling prices. This is the revenue ceiling for this obligation.',
    `billing_company_code` STRING COMMENT 'SAP company code of the legal entity responsible for billing and revenue recognition for this performance obligation. Supports multi-entity and intercompany scenarios.',
    `company_currency_code` STRING COMMENT 'ISO 4217 three-letter code for the reporting/functional currency of the legal entity. Used for financial consolidation and statutory reporting.. Valid values are `^[A-Z]{3}$`',
    `completion_percentage` DECIMAL(18,2) COMMENT 'Estimated percentage of the performance obligation that has been satisfied to date, expressed as a value between 0.00 and 100.00. Used to calculate revenue to be recognized for over-time obligations.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `contract_modification_number` STRING COMMENT 'Sequential number tracking the version of the contract modification that last affected this performance obligation. Supports contract modification history and audit trail per IFRS 15 paragraphs 18–21.. Valid values are `^[0-9]+$`',
    `contract_number` STRING COMMENT 'Reference to the parent customer contract under which this performance obligation is defined. Links the obligation to the overarching sales agreement.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the jurisdiction where the performance obligation is being fulfilled. Relevant for tax compliance, regulatory reporting, and local GAAP requirements.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this performance obligation record was first created in the system, used for audit trail and data lineage purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the contract and obligation amounts (e.g., USD, EUR, GBP). Supports multi-currency billing in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Detailed narrative description of the distinct performance obligation, such as Supply of CNC Automation Equipment, On-site Installation and Commissioning, Annual Preventive Maintenance Service, or Software License – 3 Years.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign currency exchange rate applied to convert obligation amounts from the contract currency to the companys functional currency at the time of recognition.',
    `expected_completion_date` DATE COMMENT 'The estimated or contractually agreed date by which the performance obligation is expected to be fully satisfied. Used for revenue forecasting and contract management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `gl_account_code` STRING COMMENT 'The general ledger account code to which recognized revenue for this performance obligation is posted in the financial accounting system.',
    `is_distinct` BOOLEAN COMMENT 'Indicates whether this obligation has been assessed as a distinct performance obligation under IFRS 15 / ASC 606 criteria (capable of being distinct and distinct within the context of the contract). Required for compliance documentation.. Valid values are `true|false`',
    `is_financing_component` BOOLEAN COMMENT 'Indicates whether the contract contains a significant financing component for this obligation, requiring adjustment of the transaction price for the time value of money per IFRS 15 paragraph 60.. Valid values are `true|false`',
    `is_variable_consideration` BOOLEAN COMMENT 'Indicates whether the allocated transaction price for this obligation includes variable consideration elements such as performance bonuses, penalties, rebates, or price concessions that are subject to constraint.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this performance obligation record was most recently updated, supporting change tracking, audit compliance, and incremental data loading in the Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_recognition_date` DATE COMMENT 'The most recent date on which revenue was recognized for this performance obligation. Used for period-end close processes and revenue recognition audit trails.. Valid values are `^d{4}-d{2}-d{2}$`',
    `modification_type` STRING COMMENT 'Indicates how a contract modification was accounted for: as a separate contract (prospective), as a modification of the existing contract with cumulative catch-up adjustment, or as a termination. Drives the revenue restatement approach.. Valid values are `original|prospective_modification|cumulative_catch_up|termination|not_applicable`',
    `obligation_number` STRING COMMENT 'Human-readable business identifier for the performance obligation, used in contract documentation, billing correspondence, and revenue recognition schedules.. Valid values are `^PO-[0-9]{4}-[0-9]{6}$`',
    `obligation_type` STRING COMMENT 'Classification of the performance obligation by the nature of the deliverable. Critical for industrial manufacturing contracts that bundle equipment, installation, commissioning, and aftermarket services.. Valid values are `equipment_supply|installation|commissioning|software_license|maintenance_service|aftermarket_service|training|engineering_service|spare_parts_supply|warranty_service|other`',
    `over_time_recognition_method` STRING COMMENT 'For obligations satisfied over time, specifies the method used to measure progress toward complete satisfaction: output methods (units delivered, milestones) or input methods (costs incurred, labor hours). Not applicable for point-in-time obligations.. Valid values are `output_method|input_method_cost|input_method_effort|milestone_based|straight_line|units_delivered|not_applicable`',
    `profit_center` STRING COMMENT 'SAP profit center to which the revenue from this performance obligation is attributed, enabling segment-level profitability reporting and management accounting.',
    `recognized_revenue_amount` DECIMAL(18,2) COMMENT 'Cumulative revenue recognized to date for this performance obligation, in the contract currency. Represents the portion of the allocated transaction price that has been earned based on satisfaction progress.',
    `remaining_obligation_amount` DECIMAL(18,2) COMMENT 'The unsatisfied or partially unsatisfied portion of the allocated transaction price remaining to be recognized as revenue. Calculated as allocated transaction price minus recognized revenue amount.',
    `revenue_recognition_standard` STRING COMMENT 'Identifies the applicable revenue recognition accounting standard governing this performance obligation. Multinational entities may apply IFRS 15 in some jurisdictions and ASC 606 in others.. Valid values are `IFRS_15|ASC_606|both`',
    `sales_order_number` STRING COMMENT 'Reference to the associated sales order in SAP S/4HANA SD module that triggered or is linked to this performance obligation.',
    `satisfaction_method` STRING COMMENT 'Indicates whether the performance obligation is satisfied at a single point in time (e.g., equipment delivery) or over time (e.g., multi-year maintenance contract). Determines the revenue recognition pattern per IFRS 15 / ASC 606.. Valid values are `point_in_time|over_time`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this performance obligation record originated, supporting data lineage and reconciliation in the Databricks lakehouse.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL|OTHER`',
    `ssp_estimation_method` STRING COMMENT 'Method used to estimate the standalone selling price when it is not directly observable. Required for audit and disclosure purposes under IFRS 15 / ASC 606.. Valid values are `observable_price|adjusted_market_assessment|expected_cost_plus_margin|residual_approach|not_applicable`',
    `standalone_selling_price` DECIMAL(18,2) COMMENT 'The price at which the entity would sell the promised good or service separately to a customer. Used as the basis for allocating the transaction price across multiple performance obligations in a bundled contract.',
    `start_date` DATE COMMENT 'The contractual start date for this performance obligation, representing when the entity begins its obligation to deliver the promised good or service.. Valid values are `^d{4}-d{2}-d{2}$`',
    `status` STRING COMMENT 'Current lifecycle status of the performance obligation, indicating whether it is in draft, active, partially or fully satisfied, cancelled, suspended, or modified due to a contract change.. Valid values are `draft|active|partially_satisfied|fully_satisfied|cancelled|suspended|modified`',
    `tax_treatment_code` STRING COMMENT 'Tax classification code applicable to this performance obligation, determining VAT, GST, or sales tax treatment at the time of revenue recognition and invoicing.',
    `variable_consideration_amount` DECIMAL(18,2) COMMENT 'The estimated amount of variable consideration included in the allocated transaction price for this obligation, constrained to the extent it is highly probable that a significant revenue reversal will not occur.',
    CONSTRAINT pk_performance_obligation PRIMARY KEY(`performance_obligation_id`)
) COMMENT 'Defines distinct performance obligations within a customer contract for IFRS 15 / ASC 606 revenue recognition compliance. Captures performance obligation description, standalone selling price (SSP), allocated transaction price, satisfaction method (point-in-time vs. over-time), estimated completion percentage, recognized revenue to date, remaining obligation value, and contract modification history. Critical for industrial manufacturing contracts bundling equipment, installation, commissioning, and aftermarket services.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`dunning_record` (
    `dunning_record_id` BIGINT COMMENT 'Unique system-generated identifier for each dunning record in the accounts receivable collections workflow.',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Dunning processes for overdue payments target specific unpaid invoices. Collections teams use this to track escalation levels and payment follow-up history for each invoice.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Dunning record for overdue customer account - normalize by replacing customer_account_number and customer_name with FK',
    `collections_officer` STRING COMMENT 'Name or user ID of the accounts receivable collections officer responsible for managing this dunning record and customer follow-up.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity issuing the dunning notice, used for multi-entity and intercompany billing scenarios.',
    `company_currency_code` STRING COMMENT 'ISO 4217 currency code of the company codes local currency, used for financial reporting and consolidation in the multinational enterprise.. Valid values are `^[A-Z]{3}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customers billing country, used to apply country-specific dunning regulations, tax rules, and legal escalation procedures.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the dunning record was created in the source system, providing an audit trail for the initiation of the collections process.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `credit_risk_category` STRING COMMENT 'Credit risk classification of the customer at the time of dunning, used to prioritize collections efforts and inform expected credit loss provisioning under IFRS 9.. Valid values are `low|medium|high|critical|write_off_candidate`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the dunning amount and charges (e.g., USD, EUR, GBP), supporting multi-currency billing operations.. Valid values are `^[A-Z]{3}$`',
    `customer_response_date` DATE COMMENT 'Date on which the customer responded to the dunning notice, used to measure response time and update collections workflow status.. Valid values are `^d{4}-d{2}-d{2}$`',
    `customer_response_status` STRING COMMENT 'Status of the customers response to the dunning notice, capturing whether the customer has acknowledged, disputed, promised payment, or made arrangements, supporting collections workflow management.. Valid values are `no_response|acknowledged|disputed|payment_promised|partial_payment|paid_in_full|payment_arrangement|referred_to_legal`',
    `days_overdue` STRING COMMENT 'Number of calendar days the invoice has been outstanding past its due date as of the dunning run date. Drives dunning level assignment and credit risk assessment.. Valid values are `^[0-9]+$`',
    `dunning_amount` DECIMAL(18,2) COMMENT 'Total outstanding overdue amount subject to dunning in the transaction currency, as calculated during the dunning run. Includes principal overdue balance.',
    `dunning_amount_company_currency` DECIMAL(18,2) COMMENT 'Dunning amount converted to the company codes local currency using the exchange rate at the time of the dunning run, for financial reporting and consolidation.',
    `dunning_area` STRING COMMENT 'SAP FI-AR dunning area used to segment dunning processing within a company code, enabling separate dunning programs per business unit or sales organization.',
    `dunning_block_reason` STRING COMMENT 'Reason code explaining why the dunning block indicator is set, enabling collections teams to prioritize and manage blocked accounts appropriately.. Valid values are `payment_arrangement|dispute_in_progress|credit_review|customer_request|legal_hold|write_off_pending|other`',
    `dunning_charge_amount` DECIMAL(18,2) COMMENT 'Late payment fee or dunning charge applied to the customer at this dunning level, as configured in the dunning procedure. Posted as a separate line item in SAP FI-AR.',
    `dunning_date` DATE COMMENT 'The date on which the dunning notice was issued to the customer. Used for aging analysis and SLA compliance tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `dunning_interest_amount` DECIMAL(18,2) COMMENT 'Interest on overdue amounts calculated and applied during the dunning run, based on the interest calculation method configured in SAP FI-AR.',
    `dunning_level` STRING COMMENT 'Numeric level of the dunning step reached for this record (e.g., 1 = 1st reminder, 2 = 2nd reminder, 3 = final notice, 4 = legal action). Drives escalation logic and charge calculation.. Valid values are `^[1-9]$`',
    `dunning_level_description` STRING COMMENT 'Human-readable label for the dunning level, such as 1st Reminder, 2nd Reminder, Final Notice, or Legal Action, supporting reporting and customer correspondence.. Valid values are `1st Reminder|2nd Reminder|Final Notice|Legal Action|Pre-Legal Notice|Debt Collection Agency`',
    `dunning_notice_number` STRING COMMENT 'Business-facing document number assigned to the dunning notice, used for correspondence and audit trail in SAP FI-AR.. Valid values are `^DN-[0-9]{4}-[0-9]{8}$`',
    `dunning_notice_sent_timestamp` TIMESTAMP COMMENT 'Exact date and time the dunning notice was dispatched to the customer, providing a precise audit trail for regulatory compliance and SLA measurement.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `dunning_notice_sent_via` STRING COMMENT 'Communication channel used to deliver the dunning notice to the customer (e.g., email, postal mail, EDI, customer portal), supporting audit trail and delivery confirmation.. Valid values are `email|postal_mail|fax|edi|portal|phone|in_person`',
    `dunning_procedure` STRING COMMENT 'Identifier of the multi-level dunning program configured in SAP FI-AR that governs the escalation steps, intervals, and charges applied to this customer.',
    `escalation_date` DATE COMMENT 'Date on which the dunning record was escalated to a higher collections authority, legal team, or external agency.. Valid values are `^d{4}-d{2}-d{2}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign currency exchange rate applied to convert the dunning amount from transaction currency to company currency at the time of the dunning run.',
    `invoice_due_date` DATE COMMENT 'Original payment due date of the overdue invoice, used to calculate days overdue and determine dunning level eligibility.. Valid values are `^d{4}-d{2}-d{2}$`',
    `is_dunning_blocked` BOOLEAN COMMENT 'Flag indicating whether the customer account or specific invoice has been blocked from further dunning processing in SAP FI-AR (e.g., due to dispute, payment arrangement, or credit hold).. Valid values are `true|false`',
    `is_escalated` BOOLEAN COMMENT 'Indicates whether this dunning record has been escalated beyond standard dunning levels to senior collections management, legal department, or external debt collection agency.. Valid values are `true|false`',
    `is_legal_action_initiated` BOOLEAN COMMENT 'Indicates whether formal legal proceedings or referral to a debt collection agency has been initiated for this overdue account, triggering specific accounting and disclosure requirements.. Valid values are `true|false`',
    `last_dunning_run_date` DATE COMMENT 'Date of the most recent dunning program execution in SAP FI-AR that evaluated this customer account, regardless of whether a notice was issued.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the dunning record, used for change tracking, data freshness monitoring, and incremental lakehouse processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `next_dunning_date` DATE COMMENT 'Scheduled date for the next dunning action based on the dunning procedure interval configuration, used for collections planning and workload forecasting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `payment_terms_code` STRING COMMENT 'SAP payment terms code applicable to the overdue invoice (e.g., NET30, NET60), used to validate overdue status and determine dunning eligibility.',
    `promised_payment_amount` DECIMAL(18,2) COMMENT 'Amount the customer has committed to paying by the promised payment date, which may be a partial or full settlement of the dunning amount.',
    `promised_payment_date` DATE COMMENT 'Date by which the customer has committed to making payment, as captured during collections contact. Used to monitor promise-to-pay compliance and defer further dunning actions.. Valid values are `^d{4}-d{2}-d{2}$`',
    `source_system` STRING COMMENT 'Operational system of record from which this dunning record was originated or extracted (e.g., SAP FI-AR), supporting data lineage and reconciliation in the lakehouse.. Valid values are `SAP_FI_AR|SALESFORCE_CRM|MANUAL|OTHER`',
    `status` STRING COMMENT 'Current processing status of the dunning record, tracking its lifecycle from issuance through resolution (e.g., open, sent, responded, paid, escalated, blocked, legal action, closed).. Valid values are `open|sent|responded|paid|escalated|blocked|cancelled|legal_action|closed`',
    `write_off_flag` BOOLEAN COMMENT 'Indicates whether the outstanding receivable associated with this dunning record has been written off as uncollectible, triggering bad debt expense recognition in the general ledger.. Valid values are `true|false`',
    CONSTRAINT pk_dunning_record PRIMARY KEY(`dunning_record_id`)
) COMMENT 'Tracks the dunning (collections) process for overdue customer invoices in the accounts receivable workflow. Captures dunning level (1st reminder, 2nd reminder, final notice, legal action), dunning date, dunning amount, dunning charges applied, dunning block indicator, last dunning run date, customer response status, and escalation flag. Supports multi-level dunning programs configured in SAP FI-AR for industrial customers with varying payment behaviors and credit risk profiles.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`tax_determination` (
    `tax_determination_id` BIGINT COMMENT 'Unique surrogate identifier for each tax determination record in the billing domain. Serves as the primary key for the tax_determination data product.',
    `billing_invoice_id` BIGINT COMMENT 'Reference number of the billing document (invoice, credit note, debit note) to which this tax determination record applies. Links tax results back to the originating billing transaction.',
    `tax_code_id` BIGINT COMMENT 'Foreign key linking to finance.tax_code. Business justification: Tax determination logic references finance tax code master data for accurate tax calculation. Used by billing engine for every invoice generation.',
    `billing_document_line_item` STRING COMMENT 'Line item number within the billing document to which this specific tax determination applies. Supports item-level tax calculation for multi-line invoices.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity responsible for the billing transaction. Determines the applicable tax procedure and jurisdiction rules.',
    `company_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the companys local reporting currency used for financial statement preparation and statutory tax reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp recording when the tax determination record was created in the system. Used for audit trail, data lineage, and compliance documentation purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the transaction currency in which the tax base amount and tax amount are expressed (e.g., USD, EUR, GBP, JPY).. Valid values are `^[A-Z]{3}$`',
    `customer_tax_classification` STRING COMMENT 'Tax classification code assigned to the customer master record that determines the customers tax liability status (e.g., taxable, exempt, government, non-profit, reseller). Drives tax determination logic.',
    `customer_vat_registration_number` STRING COMMENT 'Value Added Tax (VAT) registration number of the customer, required for intra-community B2B transactions and reverse charge validation. Verified against VIES for EU transactions.',
    `date` DATE COMMENT 'The date on which the tax determination was performed. Used to identify the applicable tax rates and rules in effect at the time of the transaction, as tax rates can change over time.. Valid values are `^d{4}-d{2}-d{2}$`',
    `determination_method` STRING COMMENT 'Indicates how the tax was determined for this record — automatically by the tax engine, manually overridden by a user, calculated by an external tax engine (e.g., Vertex, Avalara), or applied as a default fallback.. Valid values are `automatic|manual_override|external_engine|default_fallback`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign exchange rate used to convert the transaction currency tax amounts to the company reporting currency. Applied at the time of billing document creation.',
    `exemption_certificate_number` STRING COMMENT 'Reference number of the tax exemption certificate provided by the customer or applicable under law. Required for audit trail when is_tax_exempt is true. Supports compliance with tax authority documentation requirements.',
    `exemption_reason_code` STRING COMMENT 'Standardized code identifying the legal basis or reason for tax exemption (e.g., export sale, intra-community supply, diplomatic exemption, government entity). Used for tax return reporting and audit defense.',
    `external_tax_engine` STRING COMMENT 'Identifies the external tax calculation engine used to determine the tax, if applicable. Supports integration with third-party tax engines for complex multi-jurisdiction US sales tax and global indirect tax compliance.. Valid values are `vertex|avalara|thomson_reuters_onesource|sap_native|other|none`',
    `gl_account_code` STRING COMMENT 'General Ledger account code to which the tax amount is posted in the financial accounting system. Determined by the tax code and account key configuration.',
    `is_reverse_charge` BOOLEAN COMMENT 'Indicates whether the reverse charge mechanism applies to this transaction, shifting the VAT/GST liability from the supplier to the customer. Common in B2B cross-border EU transactions and certain domestic supplies.. Valid values are `true|false`',
    `is_tax_exempt` BOOLEAN COMMENT 'Indicates whether the billing transaction is fully exempt from the applicable tax. When true, no tax is charged and the exemption certificate reference must be provided for audit compliance.. Valid values are `true|false`',
    `material_tax_classification` STRING COMMENT 'Tax classification code assigned to the material/product master that determines the applicable tax treatment for the specific product (e.g., standard rated, reduced rated, zero rated, exempt). Drives product-level tax determination.',
    `place_of_supply_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code identifying the place of supply for VAT/GST purposes. Determines which countrys tax rules apply, particularly critical for cross-border services and digital goods.. Valid values are `^[A-Z]{3}$`',
    `posting_date` DATE COMMENT 'The accounting posting date of the billing document. Determines the fiscal period in which the tax liability is recognized and reported in the financial statements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sales_order_number` STRING COMMENT 'Reference to the originating sales order associated with this tax determination. Enables traceability from tax record back to the order management process.',
    `ship_from_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country from which goods are shipped. Used in conjunction with ship-to country to determine import/export tax treatment and customs duty applicability.. Valid values are `^[A-Z]{3}$`',
    `ship_to_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the destination country to which goods are shipped. Determines import VAT, customs duty, and destination-based tax obligations.. Valid values are `^[A-Z]{3}$`',
    `source_system` STRING COMMENT 'Identifier of the operational source system from which this tax determination record originated (e.g., SAP S/4HANA, Vertex, Avalara). Supports data lineage tracking in the lakehouse silver layer.',
    `status` STRING COMMENT 'Current processing status of the tax determination record. Indicates whether the tax has been successfully determined, posted to accounting, reversed, cancelled, or requires manual review due to an error.. Valid values are `determined|posted|reversed|cancelled|error|pending_review`',
    `supplier_vat_registration_number` STRING COMMENT 'Value Added Tax (VAT) registration number of the supplying legal entity. Printed on tax invoices and required for customer input VAT recovery. Must be valid in the tax country.',
    `tax_amount` DECIMAL(18,2) COMMENT 'The calculated tax amount in the transaction currency, derived by applying the tax rate to the tax base amount. Represents the actual tax charge on the billing document line.',
    `tax_amount_company_currency` DECIMAL(18,2) COMMENT 'The calculated tax amount converted to the companys local reporting currency. Used for financial reporting, GL posting, and statutory tax return preparation in the local currency.',
    `tax_base_amount` DECIMAL(18,2) COMMENT 'The taxable base amount in the transaction currency upon which the tax rate is applied to calculate the tax amount. Represents the net value of goods or services subject to tax.',
    `tax_base_amount_company_currency` DECIMAL(18,2) COMMENT 'The taxable base amount converted to the companys local reporting currency. Required for statutory tax reporting and reconciliation with financial statements.',
    `tax_category` STRING COMMENT 'High-level tax category classification indicating whether the transaction is subject to standard rate, reduced rate, zero-rated, exempt, or reverse charge treatment. Used for VAT return reporting and compliance.. Valid values are `standard|reduced|zero_rated|exempt|reverse_charge|out_of_scope|not_applicable`',
    `tax_condition_type` STRING COMMENT 'SAP condition type code identifying the specific tax category applied (e.g., MWST for output VAT, JR1 for US state tax, GST for Goods and Services Tax, WHT for withholding tax). Classifies the nature of the tax charge.',
    `tax_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code identifying the country in which the tax obligation arises. Drives jurisdiction-specific tax rules for cross-border industrial sales.. Valid values are `^[A-Z]{3}$`',
    `tax_invoice_number` STRING COMMENT 'Statutory tax invoice number assigned to the billing document for tax reporting purposes. In some jurisdictions (e.g., India GST, Saudi Arabia ZATCA), this is a government-mandated sequential number distinct from the commercial invoice number.',
    `tax_jurisdiction_code` STRING COMMENT 'Code identifying the specific tax jurisdiction (state, county, city, or special district) applicable to the transaction. Critical for US sales tax and multi-level jurisdiction compliance.',
    `tax_procedure_code` STRING COMMENT 'Code identifying the tax calculation procedure applied to the billing document (e.g., TAXUS for US, TAXEUR for Europe, TAXIN for India). Defines the sequence of tax condition types evaluated.',
    `tax_reporting_category` STRING COMMENT 'Category used to classify the tax record for statutory tax reporting purposes (e.g., EU VAT return box codes, US sales tax return categories, GST return classifications). Supports automated tax return preparation.',
    `tax_type` STRING COMMENT 'Classification of the tax type applied to the billing document. Distinguishes between output VAT, GST, US sales tax, withholding tax, excise duty, and other tax categories for multi-jurisdiction compliance.. Valid values are `output_vat|input_vat|gst|sales_tax|use_tax|withholding_tax|excise_duty|customs_duty|service_tax|digital_services_tax|other`',
    `withholding_tax_amount` DECIMAL(18,2) COMMENT 'The calculated withholding tax amount to be deducted from the payment and remitted to the tax authority on behalf of the payee. Reduces the net payment to the supplier.',
    `withholding_tax_base_amount` DECIMAL(18,2) COMMENT 'The base amount subject to withholding tax deduction. May differ from the invoice net amount based on treaty provisions or local regulations.',
    `withholding_tax_code` STRING COMMENT 'Code identifying the applicable withholding tax type and rate for transactions subject to withholding tax obligations (e.g., royalties, services, dividends). Relevant for cross-border payments in APAC and other regions.',
    CONSTRAINT pk_tax_determination PRIMARY KEY(`tax_determination_id`)
) COMMENT 'Records the tax calculation and determination results applied to billing documents for multi-jurisdiction tax compliance. Captures tax country, tax jurisdiction code, tax procedure, tax condition type (output VAT, GST, sales tax, withholding tax), tax base amount, tax rate, calculated tax amount, tax exemption indicator, exemption certificate reference, and tax reporting category. Supports cross-border industrial sales with complex tax requirements across EU, US, APAC, and other regions.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` (
    `intercompany_invoice_id` BIGINT COMMENT 'Unique surrogate identifier for the intercompany invoice record in the data lakehouse. Serves as the primary key for this entity.',
    `delivery_id` BIGINT COMMENT 'Foreign key linking to logistics.delivery. Business justification: Intercompany invoice references delivery - normalize by replacing delivery_number text with FK to logistics.delivery',
    `intercompany_transaction_id` BIGINT COMMENT 'Foreign key linking to finance.intercompany_transaction. Business justification: Intercompany billing documents must link to finance intercompany transactions for elimination entries and consolidated reporting. Controllers use this for month-end close.',
    `it_service_id` BIGINT COMMENT 'Foreign key linking to technology.it_service. Business justification: Shared IT services (ERP, data centers) are billed between manufacturing entities via intercompany invoices. Finance uses this for transfer pricing and shared service cost allocation.',
    `billing_date` DATE COMMENT 'The date on which the intercompany billing was executed in the SAP SD billing run. Used for revenue recognition timing and intercompany settlement scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `buying_company_code` STRING COMMENT 'SAP company code of the legal entity receiving the intercompany invoice (the purchasing/receiving entity). Paired with selling_company_code to define the intercompany trading relationship.. Valid values are `^[A-Z0-9]{1,10}$`',
    `buying_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the buying legal entity. Required for cross-border intercompany transfer pricing compliance and customs/import duty determination.. Valid values are `^[A-Z]{3}$`',
    `buying_plant` STRING COMMENT 'SAP plant code of the receiving facility that is the destination of the intercompany transfer. Used for inventory valuation and intercompany reconciliation at plant level.. Valid values are `^[A-Z0-9]{1,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the intercompany invoice record was first created in the source system. Used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the intercompany invoice transaction currency. May differ from either entitys local currency in cross-border transactions.. Valid values are `^[A-Z]{3}$`',
    `document_date` DATE COMMENT 'The date the intercompany invoice document was created or issued by the selling entity. May differ from the posting date in period-end scenarios.. Valid values are `^d{4}-d{2}-d{2}$`',
    `document_type` STRING COMMENT 'SAP document type classifying the intercompany billing document (e.g., IV = Intercompany Invoice, IG = Intercompany Credit Memo, RE = Returns). Drives accounting determination and posting logic.. Valid values are `IV|IG|RE|RG|ZICR|ZICD`',
    `due_date` DATE COMMENT 'The date by which the buying company must settle the intercompany invoice. Determined by the intercompany payment terms and used for netting and cash pooling management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign exchange rate applied to translate the transaction currency amount into the selling companys local currency at the time of invoice posting.',
    `fiscal_period` STRING COMMENT 'The fiscal period (accounting period) within the fiscal year in which the intercompany invoice is posted. Used for period-end close, accruals, and intercompany reconciliation.. Valid values are `^(0[1-9]|1[0-6])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the intercompany invoice is recognized for financial reporting purposes. Aligns with the companys fiscal calendar for period-end close and consolidation.. Valid values are `^d{4}$`',
    `gl_account_code` STRING COMMENT 'General ledger account code to which the intercompany revenue or receivable is posted in the selling companys chart of accounts.. Valid values are `^[0-9]{1,10}$`',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total gross value of the intercompany invoice including all taxes and surcharges, in the invoice transaction currency. Equals net_amount plus tax_amount.',
    `invoice_number` STRING COMMENT 'Business document number assigned to the intercompany invoice by the selling company code in SAP S/4HANA. Used for cross-entity reconciliation and audit trail.. Valid values are `^[A-Z0-9-]{1,35}$`',
    `is_profit_elimination_required` BOOLEAN COMMENT 'Indicates whether the intercompany profit embedded in this invoice must be eliminated during group consolidation. True for transactions where goods remain in inventory at the buying entity at period end.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the intercompany invoice record in the source system. Supports change tracking and incremental data loading in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `markup_percentage` DECIMAL(18,2) COMMENT 'Percentage markup applied above cost to derive the intercompany transfer price. Reflects the agreed profit margin for the selling entity and must be documented for transfer pricing compliance.',
    `net_amount` DECIMAL(18,2) COMMENT 'Total net value of the intercompany invoice before tax, in the invoice transaction currency. Represents the sum of all line item net values.',
    `net_amount_selling_currency` DECIMAL(18,2) COMMENT 'Net invoice amount translated into the selling companys local functional currency using the applicable exchange rate. Required for local statutory reporting of the selling entity.',
    `netting_indicator` BOOLEAN COMMENT 'Indicates whether this intercompany invoice is included in a multilateral netting arrangement, where offsetting payables and receivables between group entities are settled on a net basis.. Valid values are `true|false`',
    `payment_terms_code` STRING COMMENT 'SAP payment terms code governing the settlement timeline for the intercompany invoice. Intercompany payment terms are typically standardized across the group for cash management efficiency.. Valid values are `^[A-Z0-9]{1,10}$`',
    `posting_date` DATE COMMENT 'The accounting date on which the intercompany invoice is posted to the general ledger. Determines the fiscal period and year for financial reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `pricing_procedure` STRING COMMENT 'SAP pricing procedure code applied to determine the intercompany transfer price, including condition types for markup, discounts, and surcharges specific to intercompany transactions.. Valid values are `^[A-Z0-9]{1,10}$`',
    `profit_center` STRING COMMENT 'SAP profit center of the selling entity responsible for the intercompany revenue. Used for internal profitability reporting and intercompany profit elimination in consolidation.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `reconciliation_status` STRING COMMENT 'Status of the intercompany reconciliation process between the selling and buying entities. Tracks whether the invoice has been matched, confirmed, or disputed by the counterparty.. Valid values are `pending|matched|partially_matched|disputed|reconciled|written_off`',
    `reference_purchase_order_number` STRING COMMENT 'The purchase order number raised by the buying company corresponding to this intercompany invoice. Used for three-way matching and intercompany reconciliation.. Valid values are `^[A-Z0-9-]{1,35}$`',
    `reference_sales_order_number` STRING COMMENT 'The intercompany sales order number in the selling company that triggered the generation of this intercompany invoice. Links the billing document back to the originating order.. Valid values are `^[A-Z0-9-]{1,35}$`',
    `selling_company_code` STRING COMMENT 'SAP company code of the legal entity issuing the intercompany invoice (the supplying/selling entity). Used for intercompany profit elimination and consolidation.. Valid values are `^[A-Z0-9]{1,10}$`',
    `selling_company_currency_code` STRING COMMENT 'ISO 4217 currency code of the selling companys local (functional) currency. Used for local financial reporting and currency translation.. Valid values are `^[A-Z]{3}$`',
    `selling_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the selling legal entity. Required for cross-border intercompany transfer pricing compliance and tax determination.. Valid values are `^[A-Z]{3}$`',
    `selling_plant` STRING COMMENT 'SAP plant code of the manufacturing or distribution facility issuing the intercompany goods or services. Supports plant-level intercompany transfer analysis.. Valid values are `^[A-Z0-9]{1,10}$`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this intercompany invoice was extracted. Supports data lineage and multi-system reconciliation in the lakehouse.. Valid values are `SAP_S4HANA|SAP_ECC|MANUAL`',
    `status` STRING COMMENT 'Current processing and lifecycle status of the intercompany invoice, from initial creation through posting, reconciliation, and potential reversal.. Valid values are `draft|posted|cancelled|reversed|under_review|reconciled|disputed`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount (VAT, GST, or other applicable taxes) calculated on the intercompany invoice. May be zero for purely intercompany transactions exempt from external tax.',
    `tax_code` STRING COMMENT 'SAP tax code determining the applicable tax rate and tax category for the intercompany transaction. Drives VAT/GST posting and tax reporting.. Valid values are `^[A-Z0-9]{1,10}$`',
    `tax_jurisdiction_code` STRING COMMENT 'Tax jurisdiction code identifying the specific tax authority applicable to the intercompany transaction. Used for multi-jurisdiction tax compliance and reporting.',
    `transfer_price` DECIMAL(18,2) COMMENT 'The agreed intercompany transfer price per unit for goods or services exchanged between legal entities. Determined by the intercompany pricing procedure and must comply with arms-length transfer pricing regulations.',
    `transfer_type` STRING COMMENT 'Classification of the nature of the intercompany transaction (e.g., goods transfer between plants, management fee, royalty, cost recharge). Drives transfer pricing documentation requirements and tax treatment.. Valid values are `goods_transfer|service_charge|royalty|management_fee|cost_recharge|loan_interest|asset_transfer`',
    CONSTRAINT pk_intercompany_invoice PRIMARY KEY(`intercompany_invoice_id`)
) COMMENT 'Billing document generated for intercompany transactions between Manufacturing legal entities, plants, and subsidiaries. Captures intercompany invoice number, selling company code, buying company code, intercompany pricing procedure, transfer price, markup percentage, intercompany profit elimination flag, netting indicator, and reconciliation status. Supports global manufacturing operations where components or finished goods are transferred between plants across different legal entities and countries.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`billing_block` (
    `billing_block_id` BIGINT COMMENT 'Unique system-generated identifier for each billing block record applied to a sales order, delivery document, or customer account in the industrial manufacturing billing process.',
    `employee_id` BIGINT COMMENT 'System user ID of the person or automated process that applied the billing block. Supports audit trail requirements and accountability tracking for billing integrity controls.',
    `released_by_user_employee_id` BIGINT COMMENT 'System user ID of the person or automated process that released the billing block. Critical for segregation of duties controls — the releasing user should differ from the applying user in most scenarios.',
    `applied_by_department` STRING COMMENT 'Organizational department responsible for applying the billing block (e.g., Credit Management, Quality Assurance, Export Control, Legal). Used for workload analysis and escalation routing.',
    `applied_by_name` STRING COMMENT 'Full name of the user or system process that applied the billing block, providing human-readable audit trail information for finance and compliance reviews.',
    `applied_date` DATE COMMENT 'Calendar date on which the billing block was applied to the sales order, delivery, or customer account. Used for aging analysis and SLA compliance tracking of blocked invoices.. Valid values are `^d{4}-d{2}-d{2}$`',
    `applied_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone) when the billing block was applied. Provides audit trail granularity beyond the applied date for compliance and dispute resolution purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `blocked_invoice_amount` DECIMAL(18,2) COMMENT 'Total invoice value (net amount) that is being withheld from billing due to this block, expressed in the transaction currency. Critical for cash flow impact analysis and accounts receivable reporting.',
    `blocked_invoice_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the blocked invoice amount (e.g., USD, EUR, GBP, JPY). Supports multi-currency billing operations across global manufacturing entities.. Valid values are `^[A-Z]{3}$`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity or organizational unit responsible for the billing transaction. Enables financial reporting segregation across multinational manufacturing subsidiaries.. Valid values are `^[A-Z0-9]{4}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the billing entity or customer location associated with the blocked transaction. Supports regional compliance reporting and multi-country billing block analysis.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the billing block record was first created in the data platform. Supports audit trail, data lineage, and Silver layer ingestion tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `credit_control_area` STRING COMMENT 'SAP credit control area code associated with the billing block when the reason is credit-related. Identifies the organizational unit managing credit limits and exposure for the customer.. Valid values are `^[A-Z0-9]{4}$`',
    `customer_account_number` STRING COMMENT 'SAP customer account number (debtor number) of the customer whose billing is blocked. Used to link the billing block to the customer master and credit management records.. Valid values are `^[0-9]{10}$`',
    `dispute_case_number` STRING COMMENT 'Reference number of the associated dispute case in SAP Dispute Management or CRM when the billing block is related to a pricing dispute, invoice discrepancy, or customer complaint. Links billing block to formal dispute resolution workflow.',
    `distribution_channel` STRING COMMENT 'SAP distribution channel code indicating how the product or service is sold to the customer (e.g., direct sales, dealer, OEM, e-commerce). Supports billing block analysis by go-to-market channel.. Valid values are `^[0-9]{2}$`',
    `escalation_date` DATE COMMENT 'Date on which the billing block was escalated to a higher authority or management level due to non-resolution within the standard SLA period. Null if no escalation has occurred.. Valid values are `^d{4}-d{2}-d{2}$`',
    `escalation_level` STRING COMMENT 'Current escalation tier of the billing block, indicating how far up the management hierarchy the unresolved block has been escalated. Supports SLA breach management and executive reporting.. Valid values are `none|level_1|level_2|level_3|executive`',
    `expected_release_date` DATE COMMENT 'Anticipated date by which the billing block is expected to be resolved and released. Used for cash flow forecasting, accounts receivable aging projections, and escalation management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `export_control_case_number` STRING COMMENT 'Reference number of the export control review case when the billing block is applied pending export license approval, ECCN classification, or denied party screening clearance. Critical for regulatory compliance in cross-border industrial equipment sales.',
    `hold_duration_days` STRING COMMENT 'Number of calendar days the billing block has been or was active (from applied date to release date or current date). Used for aging analysis, SLA compliance reporting, and identifying chronic billing blocks.. Valid values are `^[0-9]+$`',
    `is_automatic_block` BOOLEAN COMMENT 'Indicates whether the billing block was applied automatically by the system (e.g., triggered by credit limit breach, incomplete order data, or automated quality hold) versus manually applied by a user. Supports process automation analysis.. Valid values are `true|false`',
    `is_intercompany` BOOLEAN COMMENT 'Indicates whether the billing block applies to an intercompany transaction between two legal entities within the same manufacturing group. Intercompany blocks require additional transfer pricing and elimination controls.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the billing block record was most recently updated in the data platform. Used for change data capture, incremental processing, and audit trail maintenance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `max_hold_duration_days` STRING COMMENT 'Maximum number of calendar days this billing block type is permitted to remain active before automatic escalation or expiry, as defined by company billing policy and SLA agreements.. Valid values are `^[0-9]+$`',
    `ncr_number` STRING COMMENT 'Reference number of the Non-Conformance Report (NCR) in the Quality Management System when the billing block is applied due to a quality hold. Links the billing block to the open quality issue preventing invoice release.',
    `number` STRING COMMENT 'Human-readable business reference number uniquely identifying the billing block record, used for cross-system traceability and communication with finance and order management teams.. Valid values are `^BB-[0-9]{4}-[0-9]{6}$`',
    `object_number` STRING COMMENT 'The document or account number of the specific business object (e.g., sales order number, delivery number, customer account number) to which this billing block is applied.',
    `object_type` STRING COMMENT 'Identifies the type of business document or entity to which the billing block is applied — sales order, delivery document, customer account, contract, or billing document — determining the scope of invoice prevention.. Valid values are `sales_order|delivery|customer_account|contract|billing_document`',
    `payer_account_number` STRING COMMENT 'SAP account number of the payer party responsible for settling the invoice, which may differ from the sold-to customer in complex industrial sales structures (e.g., intercompany, third-party billing).. Valid values are `^[0-9]{10}$`',
    `reason_category` STRING COMMENT 'High-level category grouping the billing block reason for analytics and reporting. Enables management dashboards to aggregate blocks by root cause category across the industrial order portfolio.. Valid values are `credit|data_quality|pricing|export_control|quality|legal|tax|contract|management_approval|other`',
    `reason_code` STRING COMMENT 'Standardized SAP billing block reason code (FAKSP) indicating why invoice generation is prevented. Codes map to reasons such as credit hold, incomplete data, pricing dispute, export control pending, quality hold, contract review, payment terms dispute, legal hold, tax compliance review, or management approval required.. Valid values are `01|02|03|04|05|06|07|08|09|10`',
    `reason_description` STRING COMMENT 'Human-readable description of the billing block reason, providing business context beyond the reason code. Examples: Credit Hold - Overdue Balance, Incomplete Pricing Data, Export Control Pending - ECCN Classification, Quality Hold - NCR Open.',
    `release_date` DATE COMMENT 'Calendar date on which the billing block was released, allowing invoice generation to proceed. Null if the block is still active. Used for cycle time analysis and revenue recognition timing.. Valid values are `^d{4}-d{2}-d{2}$`',
    `release_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone) when the billing block was released. Provides granular audit trail for compliance, dispute resolution, and revenue recognition timing analysis.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `released_by_name` STRING COMMENT 'Full name of the user or system process that released the billing block, providing human-readable audit trail for finance and compliance reviews.',
    `resolution_notes` STRING COMMENT 'Free-text notes documenting the resolution actions taken to release the billing block. Captures details such as credit limit increase approved, pricing corrected, export license obtained, NCR closed, or contract amendment signed.',
    `sales_organization` STRING COMMENT 'SAP sales organization code responsible for the sales order or billing document subject to the block. Determines the organizational unit accountable for resolving the billing block.. Valid values are `^[A-Z0-9]{4}$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which the billing block record originated. Supports data lineage tracking and reconciliation across SAP S/4HANA, Salesforce CRM, Siemens Opcenter MES, or manual entry.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|SIEMENS_OPCENTER|MANUAL`',
    `status` STRING COMMENT 'Current lifecycle status of the billing block. Active indicates the block is in force and prevents invoicing. Released indicates the block has been lifted and invoicing may proceed. Cancelled indicates the block was voided without release. Expired indicates the block lapsed past its maximum hold duration.. Valid values are `active|released|cancelled|expired`',
    CONSTRAINT pk_billing_block PRIMARY KEY(`billing_block_id`)
) COMMENT 'Records billing blocks applied to sales orders, delivery documents, or customer accounts that prevent invoice generation. Captures block reason code (credit hold, incomplete data, pricing dispute, export control pending, quality hold), block applied date, block applied by, block release date, block released by, and resolution notes. Ensures billing integrity by preventing premature or erroneous invoice creation for industrial orders under review or dispute.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` (
    `invoice_dispute_id` BIGINT COMMENT 'Unique surrogate identifier for each invoice dispute record in the billing domain. Serves as the primary key for the invoice_dispute data product.',
    `assigned_to_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Billing disputes in manufacturing (pricing errors, quantity discrepancies, quality claims) must be assigned to specific employees for resolution tracking and workload management.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Invoice disputes often involve specific components (wrong part billed, pricing discrepancy, quality issues). Dispute resolution requires linking to component master data for investigation and resoluti',
    `credit_note_id` BIGINT COMMENT 'Foreign key linking to billing.credit_note. Business justification: invoice_dispute tracks disputes and their resolution. Currently has credit_note_number (STRING) to reference resolution via credit note, but needs proper FK credit_note_id to credit_note.credit_note_i',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Invoice dispute raised by customer account - normalize by replacing customer_account_number and customer_name with FK',
    `employee_id` BIGINT COMMENT 'User identifier of the accounts receivable specialist or dispute handler currently responsible for managing and resolving the dispute case.',
    `exception_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_exception. Business justification: Invoice disputes may arise from compliance exceptions (non-standard terms, regulatory deviations, special approvals). Billing teams must link disputes to approved exceptions for resolution and audit t',
    `quality_notification_id` BIGINT COMMENT 'Foreign key linking to quality.quality_notification. Business justification: Invoice disputes frequently originate from quality issues. When customers dispute charges due to defective products or non-conformance, billing teams reference the formal quality notification to valid',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Invoice dispute references sales order - normalize by replacing sales_order_number text with FK',
    `service_invoice_id` BIGINT COMMENT 'Foreign key linking to service.service_invoice. Business justification: Customers dispute service charges for quality or scope issues. Dispute records reference service invoices to track contested charges and coordinate resolution between billing and service teams.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Invoice disputes often relate to shipment issues (late delivery, damaged goods). Billing disputes reference specific shipments to investigate delivery problems causing billing disagreements.',
    `billing_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the invoice was issued. Determines applicable tax regulations, legal jurisdiction, and compliance requirements for dispute resolution.. Valid values are `^[A-Z]{3}$`',
    `company_code` STRING COMMENT 'SAP company code of the legal entity responsible for the disputed invoice. Determines the accounting entity, currency, and fiscal rules applied during dispute resolution.. Valid values are `^[A-Z0-9]{4}$`',
    `company_currency_code` STRING COMMENT 'ISO 4217 three-letter code for the local reporting currency of the company code handling the dispute. Used for financial reporting and statutory compliance.. Valid values are `^[A-Z]{3}$`',
    `contract_number` STRING COMMENT 'Reference to the sales or framework contract associated with the disputed invoice. Used to validate pricing, terms, and delivery obligations during dispute resolution.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp recording when the invoice dispute record was first created in the source system. Used for audit trail, data lineage, and dispute aging calculations.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the disputed invoice transaction (e.g., USD, EUR, GBP). Supports multi-currency billing operations across global entities.. Valid values are `^[A-Z]{3}$`',
    `customer_communication_channel` STRING COMMENT 'The channel through which the customer submitted or communicated the invoice dispute. Used for channel analytics and process improvement in dispute intake.. Valid values are `EMAIL|PHONE|PORTAL|FAX|MAIL|IN_PERSON`',
    `days_open` STRING COMMENT 'Number of calendar days the dispute has been open since the open_date. Used for aging analysis, SLA compliance monitoring, and accounts receivable provisioning decisions. Stored as a snapshot value at Silver layer load time.. Valid values are `^[0-9]+$`',
    `dispute_case_number` STRING COMMENT 'Business-facing unique case reference number assigned to the invoice dispute, used for tracking and communication with the customer and internal teams. Corresponds to the Salesforce Service Cloud case number.. Valid values are `^DISP-[0-9]{4}-[0-9]{6}$`',
    `dispute_owner_team` STRING COMMENT 'Name or code of the internal team (e.g., AR Collections, Customer Finance, Regional Billing) responsible for managing the dispute. Supports workload distribution and team-level reporting.',
    `dispute_reason_code` STRING COMMENT 'Standardized code categorizing the primary reason for the invoice dispute. Drives workflow routing, resolution process, and root cause analytics for billing quality improvement.. Valid values are `PRICE_DISCREPANCY|QUANTITY_MISMATCH|QUALITY_ISSUE|DELIVERY_SHORTFALL|DUPLICATE_INVOICE|CONTRACT_NON_COMPLIANCE|TAX_ERROR|UNAUTHORIZED_CHARGE|OTHER`',
    `dispute_reason_description` STRING COMMENT 'Free-text narrative provided by the customer or billing team describing the specific reason for the dispute in detail, supplementing the standardized reason code.',
    `disputed_amount` DECIMAL(18,2) COMMENT 'The total monetary amount being contested by the customer in the dispute, expressed in the invoice transaction currency. Used for accounts receivable provisioning and dispute analytics.',
    `disputed_amount_company_currency` DECIMAL(18,2) COMMENT 'The disputed amount converted to the company code local currency using the exchange rate at the time of dispute creation. Required for statutory financial reporting and AR provisioning.',
    `escalation_date` DATE COMMENT 'The date on which the dispute was escalated to a higher authority or management tier due to complexity, SLA breach risk, or customer request. Null if not escalated.. Valid values are `^d{4}-d{2}-d{2}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign exchange rate applied to convert the disputed amount from transaction currency to company currency at the time of dispute creation or posting.',
    `is_escalated` BOOLEAN COMMENT 'Indicates whether the dispute has been formally escalated to a higher management level or executive team due to complexity, strategic customer importance, or SLA breach.. Valid values are `true|false`',
    `is_intercompany` BOOLEAN COMMENT 'Indicates whether the disputed invoice relates to an intercompany transaction between two legal entities within the same corporate group. Affects accounting treatment and elimination in consolidated financials.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent update to the invoice dispute record. Used for change tracking, incremental data loading in the Databricks Silver layer, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `open_date` DATE COMMENT 'The calendar date on which the invoice dispute was formally opened and registered in the system. Used as the baseline for SLA measurement and aging analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `priority` STRING COMMENT 'Priority level assigned to the dispute case, influencing resolution urgency and resource allocation. Critical disputes typically involve large amounts or strategic customers.. Valid values are `LOW|MEDIUM|HIGH|CRITICAL`',
    `resolution_date` DATE COMMENT 'The actual calendar date on which the invoice dispute was formally resolved and closed. Used to calculate resolution cycle time and SLA performance metrics.. Valid values are `^d{4}-d{2}-d{2}$`',
    `resolution_target_date` DATE COMMENT 'The contractually or operationally committed target date by which the dispute must be resolved. Drives SLA compliance monitoring and escalation triggers.. Valid values are `^d{4}-d{2}-d{2}$`',
    `resolution_type` STRING COMMENT 'The type of resolution applied to close the dispute. Determines downstream financial actions such as credit note issuance, price adjustment posting, or write-off in SAP FI-AR.. Valid values are `CREDIT_NOTE|PRICE_ADJUSTMENT|WRITE_OFF|UPHELD|PARTIAL_CREDIT|REBILL|PAYMENT_PLAN|NO_ACTION`',
    `resolved_amount` DECIMAL(18,2) COMMENT 'The final monetary amount agreed upon at dispute resolution, which may differ from the originally disputed amount. Used for credit note issuance, write-off, or price adjustment processing.',
    `root_cause_code` STRING COMMENT 'Standardized code identifying the root cause of the invoice dispute after investigation. Feeds into Corrective and Preventive Action (CAPA) processes and billing quality improvement initiatives.. Valid values are `BILLING_ERROR|PRICING_MASTER_DATA|CONTRACT_INTERPRETATION|LOGISTICS_DISCREPANCY|QUALITY_REJECTION|SYSTEM_ERROR|CUSTOMER_ERROR|PROCESS_GAP|OTHER`',
    `sales_organization` STRING COMMENT 'SAP sales organization responsible for the disputed invoice, representing the organizational unit responsible for the sale of products or services to the customer.',
    `salesforce_case_reference` STRING COMMENT 'External case identifier from Salesforce Service Cloud used to cross-reference the dispute record with the CRM system for case management and customer communication tracking.',
    `sla_breach_flag` BOOLEAN COMMENT 'Indicates whether the dispute resolution target date has been exceeded without resolution, constituting a Service Level Agreement (SLA) breach. Triggers escalation and management reporting.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which the invoice dispute record originated (e.g., SAP S/4HANA FI-AR Dispute Management or Salesforce Service Cloud). Supports data lineage and reconciliation.. Valid values are `SAP_S4HANA|SALESFORCE_SERVICE_CLOUD|MANUAL`',
    `status` STRING COMMENT 'Current lifecycle status of the invoice dispute case. Drives workflow actions, SLA monitoring, and accounts receivable aging treatment in SAP FI-AR.. Valid values are `OPEN|UNDER_REVIEW|PENDING_CUSTOMER|PENDING_INTERNAL|ESCALATED|RESOLVED|CLOSED|WITHDRAWN`',
    `supporting_document_reference` STRING COMMENT 'Reference identifier or URL pointing to supporting documentation submitted by the customer or internal team (e.g., delivery note, quality inspection report, purchase order) to substantiate the dispute claim.',
    `undisputed_amount` DECIMAL(18,2) COMMENT 'The portion of the invoice amount that the customer acknowledges as valid and agrees to pay. Enables partial payment processing and accurate AR aging in SAP FI-AR.',
    CONSTRAINT pk_invoice_dispute PRIMARY KEY(`invoice_dispute_id`)
) COMMENT 'Manages formal disputes raised by industrial customers against issued invoices. Captures dispute case number, dispute reason (price discrepancy, quantity mismatch, quality issue, delivery shortfall, duplicate invoice, contract non-compliance), disputed amount, undisputed amount, dispute open date, resolution target date, dispute status (open, under review, resolved, escalated), resolution type (credit note, price adjustment, write-off, upheld), and resolution date. Integrates with Salesforce Service Cloud for dispute case management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`run` (
    `run_id` BIGINT COMMENT 'Unique system-generated identifier for each billing run executed in SAP S/4HANA. Serves as the primary key for the billing_run entity.',
    `type_id` BIGINT COMMENT 'Foreign key linking to billing.billing_type. Business justification: billing_run has billing_type (STRING) to define which billing type is being processed in the batch run. Needs proper FK billing_type_id to billing_type.billing_type_id for referential integrity and to',
    `actual_start_timestamp` TIMESTAMP COMMENT 'The actual date and time the billing run began execution in SAP S/4HANA. Used to measure scheduling adherence and identify delays.',
    `billing_date` DATE COMMENT 'The billing date applied to all documents created in this run. Used as the reference date for pricing, payment terms calculation, and revenue recognition.',
    `billing_due_date_from` DATE COMMENT 'Start date of the billing due date range used as a selection criterion for the billing run. Only sales orders and deliveries with a billing due date on or after this date are included.',
    `billing_due_date_to` DATE COMMENT 'End date of the billing due date range used as a selection criterion for the billing run. Only sales orders and deliveries with a billing due date on or before this date are included.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity for which the billing run was executed. Determines the chart of accounts, currency, and fiscal year variant applied.. Valid values are `^[A-Z0-9]{4}$`',
    `completed_timestamp` TIMESTAMP COMMENT 'The date and time the billing run finished execution, whether successfully or with errors. Used to calculate run duration and support SLA reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time the billing run record was created in the source system. Used for audit trail and data lineage in the silver layer.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the total billed amounts for this run are expressed (e.g., USD, EUR, GBP). Supports multi-currency billing operations.. Valid values are `^[A-Z]{3}$`',
    `date` DATE COMMENT 'The business date on which the billing run was executed. Used for period-end reconciliation, revenue reporting, and accounts receivable aging.',
    `distribution_channel` STRING COMMENT 'SAP distribution channel used as a selection criterion for the billing run (e.g., direct sales, wholesale, e-commerce). Determines pricing and billing procedures applied.. Valid values are `^[A-Z0-9]{2}$`',
    `division` STRING COMMENT 'SAP division used as a selection criterion for the billing run, representing a product line or business unit (e.g., automation systems, electrification solutions).. Valid values are `^[A-Z0-9]{2}$`',
    `documents_processed_count` STRING COMMENT 'Total number of billing documents (invoices, credit memos, debit memos) that were attempted for creation during this billing run, including both successful and failed attempts.. Valid values are `^[0-9]+$`',
    `documents_selected_count` STRING COMMENT 'Total number of billing-due documents (sales orders, deliveries, service orders) selected for processing in this billing run based on the selection criteria.. Valid values are `^[0-9]+$`',
    `duration_seconds` STRING COMMENT 'Total elapsed time in seconds from actual start to completion of the billing run. Used for performance benchmarking, capacity planning, and SLA monitoring of batch processing windows.. Valid values are `^[0-9]+$`',
    `error_count` STRING COMMENT 'Number of billing documents that failed to be created during this billing run due to errors (e.g., missing master data, pricing errors, account determination failures). Used for quality monitoring and exception management.. Valid values are `^[0-9]+$`',
    `error_rate_percent` DECIMAL(18,2) COMMENT 'Percentage of billing documents that failed during this run, calculated as (error_count / documents_processed_count) * 100. Used as a KPI for billing process quality and exception management.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `executed_by` STRING COMMENT 'SAP user ID of the person or system account that initiated the billing run. For scheduled runs, this is typically a batch service account. Used for audit trail and accountability.',
    `fiscal_period` STRING COMMENT 'The fiscal posting period (01–12 for regular periods, 13–16 for special periods) within the fiscal year in which the billing run was executed. Used for period-end close and financial reporting.. Valid values are `^(0[1-9]|1[0-6])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the billing run was executed, as defined in the SAP fiscal year variant. Used for financial period assignment and revenue reporting.. Valid values are `^[0-9]{4}$`',
    `invoices_created_count` STRING COMMENT 'Number of billing documents successfully created and posted during this billing run. Used to measure run effectiveness and support accounts receivable reporting.. Valid values are `^[0-9]+$`',
    `is_test_run` BOOLEAN COMMENT 'Indicates whether this billing run was executed in simulation/test mode (true) without actually creating billing documents, or as a productive run (false). Used to distinguish test executions from actual billing cycles.. Valid values are `true|false`',
    `job_name` STRING COMMENT 'Name of the SAP background job (SM36/SM37) that executed this billing run. Used to correlate billing run records with system job logs for troubleshooting and audit purposes.',
    `job_number` STRING COMMENT 'Unique SAP background job number assigned by the system when the billing run job was scheduled. Used to trace execution details in SAP job logs.. Valid values are `^[0-9]{8}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time the billing run record was last updated in the source system (e.g., status change after partial completion or error resolution). Supports change tracking and incremental data loading.',
    `log_message` STRING COMMENT 'Summary log message or error description generated by SAP at the conclusion of the billing run. Captures key outcomes, warnings, or failure reasons for operational review and troubleshooting.',
    `number` STRING COMMENT 'Human-readable business identifier for the billing run, used for cross-referencing in finance and operations reporting. Typically formatted as BR-YYYY-NNNNNN.. Valid values are `^BR-[0-9]{4}-[0-9]{6}$`',
    `posting_date` DATE COMMENT 'The accounting posting date applied to all billing documents created in this run. Determines the fiscal period in which revenue and receivables are recognized in the general ledger.',
    `sales_organization` STRING COMMENT 'SAP sales organization used as a selection criterion for the billing run. Defines the organizational unit responsible for the sale of products and services included in this run.. Valid values are `^[A-Z0-9]{4}$`',
    `scheduled_start_timestamp` TIMESTAMP COMMENT 'The date and time the billing run was scheduled to begin execution, as configured in the SAP job scheduler. Used for SLA monitoring and run adherence reporting.',
    `selection_variant` STRING COMMENT 'Name of the SAP selection variant used to define the billing run parameters (e.g., billing due date range, sales organization, distribution channel). Enables reproducibility and standardization of recurring billing cycles.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this billing run record was extracted (e.g., SAP_S4HANA). Supports data lineage tracking in the Databricks lakehouse silver layer.. Valid values are `SAP_S4HANA|SAP_ECC|MANUAL`',
    `status` STRING COMMENT 'Current execution status of the billing run. completed indicates all documents processed successfully; partially_completed indicates some errors occurred; failed indicates the run did not complete; in_progress indicates the run is currently executing.. Valid values are `completed|partially_completed|failed|in_progress|cancelled`',
    `total_billed_amount` DECIMAL(18,2) COMMENT 'Aggregate net billed amount across all successfully created billing documents in this run, expressed in the run currency. Used for revenue reporting, period-end reconciliation, and accounts receivable management.',
    `total_gross_amount` DECIMAL(18,2) COMMENT 'Aggregate gross billed amount (net + tax) across all successfully created billing documents in this run, expressed in the run currency. Used for cash flow forecasting and AR reporting.',
    `total_tax_amount` DECIMAL(18,2) COMMENT 'Aggregate tax amount across all successfully created billing documents in this run, expressed in the run currency. Used for tax compliance reporting and VAT/GST reconciliation.',
    `type` STRING COMMENT 'Classification of the billing run indicating whether it was a scheduled nightly batch, manual trigger, ad-hoc run, month-end cycle, year-end cycle, or intercompany billing run.. Valid values are `scheduled|manual|adhoc|month_end|year_end|intercompany`',
    `warning_count` STRING COMMENT 'Number of billing documents processed with warnings during this billing run. Warnings do not prevent document creation but may indicate data quality issues requiring follow-up.. Valid values are `^[0-9]+$`',
    CONSTRAINT pk_run PRIMARY KEY(`run_id`)
) COMMENT 'Records each periodic billing run executed in SAP S/4HANA to generate invoices in batch for multiple sales orders and deliveries. Captures billing run ID, run date and time, billing type processed, selection criteria (billing due date range, sales organization, distribution channel), number of documents processed, number of invoices created, number of errors, total billed amount, run status (completed, partially completed, failed), and executed by. Supports scheduled nightly and month-end billing cycles.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` (
    `accounts_receivable_position_id` BIGINT COMMENT 'Unique surrogate identifier for each accounts receivable position record per customer account in the billing domain silver layer.',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: AR positions track outstanding balances per invoice for aging analysis, credit management, and cash forecasting. Each AR position corresponds to a specific invoice receivable.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: AR position tracks customer account balance - normalize by replacing customer_account_number and customer_name with FK',
    `account_status` STRING COMMENT 'Current operational status of the customers accounts receivable account. Drives workflow routing for collections, credit management, and order processing decisions.. Valid values are `active|credit_hold|collections|write_off|closed|disputed`',
    `bad_debt_provision_amount` DECIMAL(18,2) COMMENT 'Amount provisioned as potentially uncollectible for this customer account as of the position date, in transaction currency. Calculated based on aging analysis and credit risk assessment per IFRS 9 expected credit loss model.',
    `bucket_0_30_amount` DECIMAL(18,2) COMMENT 'Outstanding invoice amount overdue between 0 and 30 days as of the position date, in transaction currency. Used for AR aging analysis and collections prioritization.',
    `bucket_31_60_amount` DECIMAL(18,2) COMMENT 'Outstanding invoice amount overdue between 31 and 60 days as of the position date, in transaction currency. Indicates early-stage delinquency requiring follow-up.',
    `bucket_61_90_amount` DECIMAL(18,2) COMMENT 'Outstanding invoice amount overdue between 61 and 90 days as of the position date, in transaction currency. Signals elevated collections risk requiring escalation.',
    `bucket_90_plus_amount` DECIMAL(18,2) COMMENT 'Outstanding invoice amount overdue more than 90 days as of the position date, in transaction currency. Represents high-risk receivables potentially requiring bad debt provisioning.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity within the multinational enterprise that owns this AR position. Supports multi-entity financial reporting and intercompany reconciliation.',
    `company_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the legal entitys functional/reporting currency. Used for consolidated financial reporting and general ledger reconciliation.. Valid values are `^[A-Z]{3}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customers billing address. Used for tax jurisdiction determination, regulatory compliance, and regional AR reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this AR position record was first created in the silver layer data product. Supports audit trail and data lineage requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `credit_block` BOOLEAN COMMENT 'Indicates whether the customer account is currently subject to a credit block, preventing new orders or deliveries from being processed until the AR position is resolved.. Valid values are `true|false`',
    `credit_control_area` STRING COMMENT 'SAP credit control area code that governs the credit management rules, credit limit, and exposure monitoring for this customer. Defines the organizational unit responsible for credit decisions.',
    `credit_exposure` DECIMAL(18,2) COMMENT 'Total current credit exposure for the customer, including open AR, open sales orders, and open deliveries not yet invoiced. Used to assess whether the customer is within their approved credit limit.',
    `credit_limit` DECIMAL(18,2) COMMENT 'Maximum credit exposure approved for the customer account in the credit control area currency. Established through the credit management process and reviewed periodically.',
    `credit_utilization_percentage` DECIMAL(18,2) COMMENT 'Percentage of the approved credit limit currently utilized by the customer, calculated as credit exposure divided by credit limit. Drives credit block decisions and credit review triggers.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the customers AR position is denominated (e.g., USD, EUR, GBP). Supports multi-currency billing operations.. Valid values are `^[A-Z]{3}$`',
    `disputed_amount` DECIMAL(18,2) COMMENT 'Total value of invoices or invoice line items currently under formal dispute by the customer as of the position date. Disputed amounts are typically excluded from dunning and collections actions.',
    `dso_days` DECIMAL(18,2) COMMENT 'Days Sales Outstanding indicator representing the average number of days the customer takes to pay invoices. A key KPI for measuring collection efficiency and customer payment behavior.',
    `dunning_block` BOOLEAN COMMENT 'Indicates whether the customer account is blocked from receiving dunning notices. Set to true when disputes are active, special payment arrangements are in place, or by credit management decision.. Valid values are `true|false`',
    `dunning_date` DATE COMMENT 'Date on which the most recent dunning notice was issued to the customer. Used to track collections activity and schedule next dunning actions.. Valid values are `^d{4}-d{2}-d{2}$`',
    `dunning_level` STRING COMMENT 'Current dunning level assigned to the customer account, indicating the stage of the collections/dunning process. Level 0 means no dunning; higher levels indicate escalating overdue notices sent.. Valid values are `0|1|2|3|4`',
    `fiscal_period` STRING COMMENT 'The fiscal period (month) within the fiscal year for this AR position snapshot. Supports period-end close, AR aging reports, and month-over-month trend analysis.. Valid values are `^(0[1-9]|1[0-6])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year in which this AR position snapshot falls, as defined by the companys financial calendar. Used for period-end AR reporting and financial close processes.. Valid values are `^d{4}$`',
    `last_invoice_date` DATE COMMENT 'Date of the most recently issued invoice to the customer. Used to assess billing recency and identify gaps in invoicing activity.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this AR position record in the silver layer. Used for incremental processing, change detection, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_payment_amount` DECIMAL(18,2) COMMENT 'Amount of the most recent payment received from the customer, in transaction currency. Provides context for payment behavior analysis alongside last payment date.',
    `last_payment_date` DATE COMMENT 'Date of the most recent payment received from the customer and applied to their AR account. Used to assess payment recency and identify inactive payers.. Valid values are `^d{4}-d{2}-d{2}$`',
    `not_yet_due_amount` DECIMAL(18,2) COMMENT 'Total open invoice amount that has not yet reached its payment due date as of the position date, in transaction currency. Represents current receivables within agreed payment terms.',
    `oldest_open_item_date` DATE COMMENT 'Due date of the oldest unpaid invoice in the customers AR account. Indicates the extent of delinquency and is used to prioritize collections escalation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `open_item_count` STRING COMMENT 'Total number of open (unpaid) invoice line items in the customers AR account as of the position date. Used to assess collections workload and invoice volume.',
    `overdue_amount` DECIMAL(18,2) COMMENT 'Total amount of invoices that have passed their due date and remain unpaid as of the position date, in transaction currency. Drives collections prioritization and dunning processes.',
    `payment_terms_code` STRING COMMENT 'Standard payment terms code applicable to the customer account (e.g., NET30, NET60, 2/10NET30). Defines the agreed payment period and any early payment discount conditions.',
    `position_date` DATE COMMENT 'The as-of date for which this accounts receivable position snapshot was calculated. Represents the reporting cut-off date for all outstanding balances and aging buckets.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sales_organization` STRING COMMENT 'SAP sales organization code responsible for the customer relationship and associated billing. Used to segment AR positions by sales channel and organizational unit for reporting.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this AR position data was sourced (e.g., SAP_S4HANA_FI_AR). Supports data lineage tracking and multi-system reconciliation in the lakehouse.',
    `total_outstanding_balance` DECIMAL(18,2) COMMENT 'Aggregate total of all open (unpaid) invoice amounts for the customer account as of the position date, in transaction currency. Represents the gross receivable before any disputed or credit adjustments.',
    `total_outstanding_balance_company_currency` DECIMAL(18,2) COMMENT 'Aggregate total of all open invoice amounts converted to the companys functional currency using the applicable exchange rate. Used for consolidated AR reporting and general ledger reconciliation.',
    CONSTRAINT pk_accounts_receivable_position PRIMARY KEY(`accounts_receivable_position_id`)
) COMMENT 'Current open accounts receivable position per customer account, capturing the aggregate outstanding balance, overdue amounts by aging bucket (0-30, 31-60, 61-90, 90+ days), credit exposure, last payment date, last invoice date, disputed amount, and DSO (Days Sales Outstanding) indicator. Serves as the operational AR ledger view for the billing domain, distinct from the finance domain general ledger. Supports credit management, collections prioritization, and customer payment behavior monitoring.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`document_output` (
    `document_output_id` BIGINT COMMENT 'Unique surrogate identifier for each billing document output transmission record in the silver layer lakehouse.',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Tracks PDF generation, email delivery, and print jobs for invoice documents. Links output records to invoices for delivery confirmation and customer service inquiries.',
    `partner_id` BIGINT COMMENT 'Unique identifier of the EDI trading partner as configured in the EDI subsystem (e.g., SAP ALE/IDoc partner profile or third-party EDI VAN partner ID). Applicable when transmission channel is EDI.',
    `acknowledgement_timestamp` TIMESTAMP COMMENT 'Date and time when a formal business-level acknowledgement (e.g., EDI 997 functional acknowledgement, Peppol Message Level Response) was received from the trading partner or customer system.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}`',
    `archiving_timestamp` TIMESTAMP COMMENT 'Date and time when the billing document output was successfully archived in the legal document archiving system. Confirms compliance with statutory archiving obligations.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}`',
    `company_code` STRING COMMENT 'SAP company code of the issuing legal entity responsible for the billing document. Determines applicable legal entity, currency, and country-specific compliance rules for the output.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the recipient/customer country. Drives country-specific e-invoicing format selection, legal archiving requirements, and tax compliance rules.. Valid values are `[A-Z]{3}`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the billing document output record was created in the source system. Marks the beginning of the output lifecycle.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}`',
    `customer_account_number` STRING COMMENT 'Customer account identifier in the ERP system (SAP debtor/payer account). Used to link the output record to the customer master and accounts receivable.',
    `delivery_timestamp` TIMESTAMP COMMENT 'Date and time when delivery of the billing document was confirmed by the receiving system or recipient. Populated upon delivery confirmation or acknowledgement receipt.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}`',
    `digital_signature_reference` STRING COMMENT 'Reference identifier or hash of the digital signature applied to the e-invoice document. Required for legally compliant e-invoicing in jurisdictions mandating digital signatures (e.g., Italy FatturaPA, Mexico CFDI, Brazil NF-e).',
    `document_type` STRING COMMENT 'Type of billing document for which this output was generated. Determines applicable legal and format requirements for the output.. Valid values are `invoice|credit_note|debit_note|pro_forma_invoice|self_billing_invoice|intercompany_invoice`',
    `e_invoicing_format` STRING COMMENT 'Structured electronic invoicing format used for the output transmission. Supports global e-invoicing mandates including ZUGFeRD (Germany), Peppol BIS (EU/global), EDIFACT INVOIC, X12 810 (North America), FatturaPA (Italy), CFDI (Mexico), NF-e (Brazil), and xRechnung (Germany public sector).. Valid values are `ZUGFeRD|Peppol_BIS|EDIFACT_INVOIC|X12_810|FatturaPA|CFDI|NF-e|UBL_2.1|xRechnung|none`',
    `e_invoicing_standard_version` STRING COMMENT 'Version of the e-invoicing format specification used (e.g., ZUGFeRD 2.1.1, Peppol BIS 3.0, EDIFACT D.96A). Critical for compliance validation and format evolution tracking.',
    `edi_qualifier` STRING COMMENT 'EDI interchange qualifier identifying the type of EDI partner ID (e.g., 01=DUNS, 08=UCC, ZZ=Mutually Defined). Used in EDI X12 ISA segment or EDIFACT UNB segment.',
    `failure_reason_code` STRING COMMENT 'Coded reason for transmission failure (e.g., INVALID_ADDRESS, EDI_PARTNER_UNAVAILABLE, FORMAT_VALIDATION_ERROR, NETWORK_TIMEOUT, RECIPIENT_REJECTED). Populated when transmission_status is failed.',
    `failure_reason_description` STRING COMMENT 'Detailed human-readable description of the transmission failure cause, including system error messages or partner rejection reasons. Supports troubleshooting and root cause analysis.',
    `is_resend` BOOLEAN COMMENT 'Indicates whether this output record represents a manual or system-triggered resend of a previously transmitted billing document. Distinguishes original transmissions from resends for audit and duplicate detection.. Valid values are `true|false`',
    `is_test_transmission` BOOLEAN COMMENT 'Indicates whether this output transmission was a test/pilot run rather than a live production transmission. Test transmissions are excluded from legal archiving and customer-facing SLA reporting.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the billing document output record, including status changes, retry attempts, or acknowledgement receipt.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}`',
    `legal_archiving_reference` STRING COMMENT 'Reference identifier linking this billing document output to its legally compliant archived copy in the document management or archiving system (e.g., SAP ILM, OpenText). Required for tax authority audit trails and statutory retention compliance.',
    `max_retry_limit` STRING COMMENT 'Maximum number of transmission retry attempts configured for this output type before the record is marked as permanently failed and escalated for manual intervention.. Valid values are `^[0-9]+$`',
    `original_output_number` STRING COMMENT 'Reference to the original output record number when this record is a resend or retry. Enables traceability of the full transmission history chain for a billing document.',
    `output_language_code` STRING COMMENT 'ISO 639-1 two-letter language code in which the billing document was generated and transmitted (e.g., EN, DE, FR, ZH, JA). Supports multi-language billing for global customers.. Valid values are `[A-Z]{2}`',
    `output_medium_code` STRING COMMENT 'SAP output medium code specifying the technical dispatch method (e.g., 1=Print, 2=Fax, 3=Telex, 4=EDI, 5=Special Function, 6=EDI, 7=Simple Mail, 8=Special Function, 9=Events). Maps to SAP NAST medium field.. Valid values are `1|2|3|4|5|6|7|8|9`',
    `output_number` STRING COMMENT 'Business-facing unique identifier for the billing document output record, typically sourced from SAP S/4HANA SD output management (NAST/BRF+).',
    `output_type_code` STRING COMMENT 'SAP output type code identifying the specific output configuration used (e.g., RD00 for invoice print, EDI1 for EDI invoice, ZEI1 for e-invoice). Drives medium, partner function, and transmission settings.',
    `output_type_description` STRING COMMENT 'Human-readable description of the output type, such as Invoice Print, EDI Invoice, Email PDF Invoice, or E-Invoicing Peppol BIS.',
    `partner_function_code` STRING COMMENT 'SAP partner function code identifying the role of the recipient in the billing process (e.g., RE=Invoice Recipient, RG=Payer, WE=Goods Recipient). Determines output routing and address determination.. Valid values are `RE|RG|WE|AG|ZA`',
    `peppol_access_point_code` STRING COMMENT 'Peppol participant identifier (e.g., 0088:GLN or 9930:DE-VAT) of the recipients registered Peppol access point. Required for Peppol BIS e-invoicing transmission routing.',
    `print_queue_name` STRING COMMENT 'Name of the print spool or output queue to which the billing document was dispatched for physical printing. Applicable when transmission channel is print.',
    `recipient_address` STRING COMMENT 'Destination address for the billing document output. For email channel: email address; for print: postal address; for fax: fax number. Context-dependent based on transmission channel.',
    `retry_count` STRING COMMENT 'Number of transmission retry attempts made for this billing document output after an initial failure. Used to monitor transmission reliability and trigger escalation after maximum retries exceeded.. Valid values are `^[0-9]+$`',
    `sales_organization` STRING COMMENT 'SAP sales organization responsible for the billing document. Used for output routing, partner determination, and revenue reporting segmentation.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this billing document output record was sourced (e.g., SAP S/4HANA, EDI VAN, Peppol Access Point). Supports data lineage and reconciliation.. Valid values are `SAP_S4HANA|EDI_VAN|PEPPOL_AP|EXTERNAL_EINVOICING|LEGACY`',
    `spool_request_number` STRING COMMENT 'SAP spool request number assigned when the billing document output was sent to the print spool. Used for print job tracking and reprint requests.',
    `tax_authority_submission_reference` STRING COMMENT 'Unique identifier assigned by the tax authority or government clearance platform upon successful submission of the e-invoice (e.g., Mexico SAT UUID/folio fiscal, Brazil SEFAZ chave de acesso, Italy SDI numero protocollo). Required for clearance-model e-invoicing countries.',
    `transmission_channel` STRING COMMENT 'The delivery channel used to transmit the billing document to the customer. Supports multi-channel billing including print, EDI, email PDF, customer portal, e-invoicing, and API-based delivery.. Valid values are `print|edi|email_pdf|customer_portal|e_invoicing|fax|xml|api`',
    `transmission_date` DATE COMMENT 'Calendar date on which the billing document output was transmitted or dispatched to the recipient.. Valid values are `d{4}-d{2}-d{2}`',
    `transmission_status` STRING COMMENT 'Current processing and delivery status of the billing document output. Tracks the full lifecycle from queuing through delivery acknowledgement or failure.. Valid values are `queued|sent|delivered|failed|acknowledged|cancelled|pending_retry`',
    `transmission_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone offset) when the billing document output was dispatched. Used for SLA compliance tracking and audit trails.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}`',
    CONSTRAINT pk_document_output PRIMARY KEY(`document_output_id`)
) COMMENT 'Tracks the output and transmission of billing documents to customers across multiple channels. Captures output type (print, EDI, email PDF, customer portal, e-invoicing), transmission date and time, recipient address or EDI partner ID, transmission status (queued, sent, delivered, failed, acknowledged), retry count, e-invoicing format (ZUGFeRD, Peppol BIS, EDIFACT INVOIC, X12 810), and legal archiving reference. Supports global e-invoicing mandates and EDI-based billing with large OEM customers.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`type` (
    `type_id` BIGINT COMMENT 'Unique surrogate identifier for each billing document type record in the industrial manufacturing billing configuration. Serves as the primary key for the billing_type reference table.',
    `account_determination_procedure` STRING COMMENT 'SAP account determination procedure assigned to this billing type, controlling how revenue, tax, and receivables accounts are determined during FI posting. Critical for correct general ledger account assignment.. Valid values are `^[A-Z0-9]{1,6}$`',
    `applicable_company_codes` STRING COMMENT 'Comma-separated list of SAP company codes for which this billing type is activated and permitted. Restricts usage of specific billing types to relevant legal entities within the multinational manufacturing group.',
    `applicable_sales_doc_types` STRING COMMENT 'Comma-separated list of SAP sales document type codes (e.g., OR, RE, KA, DR) that are permitted to generate billing documents of this type. Defines the upstream order-to-billing document flow relationships.',
    `applicable_sales_organizations` STRING COMMENT 'Comma-separated list of SAP sales organization codes authorized to use this billing type. Controls which regional or divisional sales organizations can generate billing documents of this type.',
    `billing_relevance` STRING COMMENT 'Indicates the upstream business process that triggers billing documents of this type. Determines whether billing is based on sales orders, delivery notes, service orders, project milestones, or contracts — critical for manufacturing order-to-cash process alignment.. Valid values are `order_related|delivery_related|service_related|project_related|contract_related|milestone_related`',
    `cancellation_billing_type_code` STRING COMMENT 'Code of the billing document type used to cancel or reverse billing documents of this type. Defines the cancellation document pairing in SAP SD configuration (e.g., F2 is cancelled by S1).. Valid values are `^[A-Z0-9]{1,4}$`',
    `category` STRING COMMENT 'High-level classification of the billing document type that determines its fundamental business behavior and accounting treatment. Drives downstream processing rules in accounts receivable and revenue recognition.. Valid values are `invoice|credit_memo|debit_memo|pro_forma|intercompany|cancellation|self_billing|down_payment|milestone_billing`',
    `code` STRING COMMENT 'Alphanumeric code uniquely identifying the billing document type in SAP S/4HANA SD configuration (e.g., F2 for standard invoice, G2 for credit memo, L2 for debit memo, F8 for pro-forma invoice, IV for intercompany invoice). Maps directly to the VKBUR/FKART field in SAP.. Valid values are `^[A-Z0-9]{1,4}$`',
    `copy_control_source_types` STRING COMMENT 'Comma-separated list of source document types from which this billing type can be copied in SAP copy control configuration. Defines the permitted document flow paths (e.g., delivery to invoice, order to invoice, billing to cancellation).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this billing type configuration record was first created in the system. Supports audit trail and configuration change history tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `credit_check_active` BOOLEAN COMMENT 'Indicates whether credit limit checks are performed when creating billing documents of this type. Enables credit risk management controls for industrial manufacturing customers with high-value orders.. Valid values are `true|false`',
    `credit_memo_indicator` BOOLEAN COMMENT 'Indicates whether this billing type represents a credit memo document that reduces the customers accounts receivable balance. Used to distinguish credit-reducing documents from revenue-generating invoices in AR aging and reporting.. Valid values are `true|false`',
    `debit_memo_indicator` BOOLEAN COMMENT 'Indicates whether this billing type represents a debit memo document that increases the customers accounts receivable balance for additional charges, price corrections, or supplementary billings.. Valid values are `true|false`',
    `description` STRING COMMENT 'Detailed business description of the billing document type, explaining its purpose, usage context, and behavioral rules within the industrial manufacturing order-to-cash process.',
    `document_category` STRING COMMENT 'SAP internal document category code (VBTYP) that classifies the billing document at the system level, distinguishing between billing documents, cancellations, statistical documents, and intercompany documents.. Valid values are `M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z`',
    `dunning_relevant` BOOLEAN COMMENT 'Indicates whether open items from billing documents of this type are included in the dunning (payment reminder) process. Pro-forma invoices and statistical documents are typically excluded from dunning.. Valid values are `true|false`',
    `effective_date` DATE COMMENT 'Date from which this billing type configuration is valid and can be used to create billing documents. Supports configuration versioning and phased rollout of new billing type definitions.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date after which this billing type configuration is no longer valid for creating new billing documents. Null indicates no expiry. Used to manage configuration lifecycle and regulatory compliance transitions.. Valid values are `^d{4}-d{2}-d{2}$`',
    `gl_account_posting_key` STRING COMMENT 'SAP FI posting key used for the primary line item when billing documents of this type are transferred to Financial Accounting. Controls debit/credit assignment and field selection for GL account postings.. Valid values are `^[0-9]{1,2}$`',
    `intercompany_indicator` BOOLEAN COMMENT 'Indicates whether this billing type is used for intercompany transactions between legal entities within the manufacturing group. Intercompany billing types trigger specific transfer pricing and elimination entries for consolidated financial reporting.. Valid values are `true|false`',
    `invoice_list_type` STRING COMMENT 'SAP invoice list type code associated with this billing type, enabling periodic collective invoicing where multiple billing documents are consolidated into a single invoice list for high-volume manufacturing customers.. Valid values are `^[A-Z0-9]{0,4}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this billing type configuration record. Used for change tracking, audit compliance, and incremental data loading in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `multi_currency_enabled` BOOLEAN COMMENT 'Indicates whether billing documents of this type support transaction currencies different from the company code currency. Essential for multinational manufacturing operations billing customers in foreign currencies.. Valid values are `true|false`',
    `name` STRING COMMENT 'Short descriptive name of the billing document type as configured in SAP S/4HANA SD (e.g., Standard Invoice, Credit Memo, Debit Memo, Pro-Forma Invoice, Intercompany Invoice, Cancellation Billing).',
    `number_range_code` STRING COMMENT 'SAP number range object assignment for the billing document type, controlling the document number series assigned to billing documents of this type. Ensures sequential and auditable document numbering per fiscal year.. Valid values are `^[A-Z0-9]{1,2}$`',
    `output_determination_procedure` STRING COMMENT 'SAP output determination procedure assigned to this billing type, controlling which output messages (e.g., invoice PDF, EDI transmission, email notification) are generated and dispatched when a billing document of this type is created or processed.. Valid values are `^[A-Z0-9]{1,6}$`',
    `payment_terms_default` STRING COMMENT 'Default SAP payment terms code proposed for billing documents of this type when no customer-specific or order-specific payment terms override is present. Defines standard due date calculation and early payment discount conditions.. Valid values are `^[A-Z0-9]{1,4}$`',
    `posting_indicator` STRING COMMENT 'SAP SD configuration indicator that controls how the billing document posts to Financial Accounting (FI). Determines whether the document creates an accounting document, updates the general ledger, and triggers revenue recognition. Maps to SAP BUCHUNGSTYP field.. Valid values are `A|B|C|D|E`',
    `pricing_procedure_code` STRING COMMENT 'Identifier of the pricing procedure assigned to this billing document type in SAP SD configuration. Determines which condition types, discounts, surcharges, and tax calculations are applied when billing documents of this type are created.. Valid values are `^[A-Z0-9]{1,6}$`',
    `relevant_for_rebate` BOOLEAN COMMENT 'Indicates whether billing documents of this type are included in rebate accrual and settlement calculations. Relevant for industrial manufacturing customer rebate programs and volume discount agreements.. Valid values are `true|false`',
    `relevant_for_statistics` BOOLEAN COMMENT 'Indicates whether billing documents of this type update sales statistics and reporting structures (e.g., Sales Information System). Controls inclusion in revenue reporting, sales analytics, and KPI dashboards.. Valid values are `true|false`',
    `revenue_recognition_method` STRING COMMENT 'Method used to recognize revenue for billing documents of this type. Determines when and how revenue is posted to the income statement, aligned with IFRS 15 and GAAP ASC 606 performance obligation satisfaction criteria.. Valid values are `immediate|milestone|percentage_of_completion|time_based|event_based|manual`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this billing type configuration was sourced. Supports data lineage tracking and multi-system reconciliation in the Databricks lakehouse silver layer.. Valid values are `SAP_S4HANA|MANUAL|MIGRATION`',
    `source_system_key` STRING COMMENT 'Natural key or technical identifier of this billing type record in the originating source system (e.g., SAP FKART value). Enables traceability and reconciliation between the lakehouse silver layer and the operational system of record.',
    `status` STRING COMMENT 'Current operational status of the billing type configuration record. Inactive or deprecated billing types are retained for historical reference but cannot be used to create new billing documents.. Valid values are `active|inactive|deprecated|under_review`',
    `tax_determination_procedure` STRING COMMENT 'Tax calculation procedure assigned to this billing type, determining how VAT, GST, sales tax, and other indirect taxes are calculated and posted for billing documents of this type across different tax jurisdictions.. Valid values are `^[A-Z0-9]{1,6}$`',
    `transfer_to_accounting` BOOLEAN COMMENT 'Indicates whether billing documents of this type are automatically transferred to Financial Accounting (FI) for general ledger posting. When false, the billing document is statistical or pro-forma and does not create accounting entries.. Valid values are `true|false`',
    CONSTRAINT pk_type PRIMARY KEY(`type_id`)
) COMMENT 'Reference classification of billing document types used across the industrial manufacturing billing process. Captures billing type code, billing type description, billing category (invoice, credit memo, debit memo, pro-forma, intercompany, cancellation), posting indicator, number range assignment, pricing procedure, and applicable sales document types. Defines the behavioral rules for each billing document type in SAP S/4HANA SD configuration.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` (
    `billing_payment_term_id` BIGINT COMMENT 'Unique surrogate identifier for each payment term record in the billing master. Used as the primary key for referencing payment terms across invoices, contracts, and accounts receivable.',
    `applicable_customer_segment` STRING COMMENT 'Customer segment classification for which this payment term is applicable. Enables differentiated payment conditions for key accounts, OEM partners, government customers, distributors, and intercompany transactions in industrial B2B billing.. Valid values are `all|key_account|distributor|oem|government|small_medium_enterprise|intercompany|export`',
    `baseline_date_rule` STRING COMMENT 'Rule that determines the anchor date from which the net payment due date and early payment discount periods are calculated. For example, invoice_date starts the clock on the date the invoice is issued; end_of_month defers the baseline to the last day of the invoice month. Directly maps to SAP T052 baseline date field.. Valid values are `invoice_date|posting_date|delivery_date|goods_receipt_date|end_of_month|start_of_next_month|contract_start_date`',
    `code` STRING COMMENT 'Alphanumeric business key identifying the payment term, as defined in the ERP system (e.g., NT30, 2/10N30, ZB14). Used on invoices, sales orders, and customer master records to reference the applicable payment condition.. Valid values are `^[A-Z0-9]{2,10}$`',
    `company_code_restriction` STRING COMMENT 'SAP company code(s) to which this payment term is restricted. Ensures that payment terms are applied only within the appropriate legal entity context, supporting multi-entity financial reporting and statutory compliance.',
    `country_restriction` STRING COMMENT 'ISO 3166-1 alpha-3 country code(s) to which this payment term is restricted. Enables country-specific payment conditions to comply with local commercial law, tax regulations, and banking practices across multinational operations.. Valid values are `^[A-Z]{3}(|[A-Z]{3})*$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this payment term record was first created in the system. Used for audit trail, data lineage, and master data governance compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_restriction` STRING COMMENT 'ISO 4217 currency code(s) to which this payment term is restricted. If populated, the term may only be applied to invoices denominated in the specified currency(ies). Supports multi-currency billing governance in multinational industrial operations. Pipe-separated for multiple currencies.. Valid values are `^[A-Z]{3}(|[A-Z]{3})*$`',
    `description` STRING COMMENT 'Full textual description of the payment term conditions, including all applicable rules, discount tiers, and installment schedules. Used for legal documentation and customer communication.',
    `discount_days_1` STRING COMMENT 'Number of days from the baseline date within which the customer must pay to qualify for the first-tier early payment (cash) discount. For example, in 2/10 Net 30, this value is 10. Supports prompt payment incentive programs common in industrial B2B billing.. Valid values are `^[0-9]{1,3}$`',
    `discount_days_2` STRING COMMENT 'Number of days from the baseline date within which the customer must pay to qualify for the second-tier early payment discount. Supports multi-tier discount structures (e.g., 3/5, 2/10, Net 30) common in large industrial procurement contracts.. Valid values are `^[0-9]{1,3}$`',
    `discount_percentage_1` DECIMAL(18,2) COMMENT 'Percentage discount applied to the invoice net amount if payment is received within the first discount period (discount_days_1). For example, in 2/10 Net 30, this value is 0.0200 (2%). Stored as a decimal fraction for precision in financial calculations.. Valid values are `^(0(.d{1,4})?|1(.0{1,4})?)$`',
    `discount_percentage_2` DECIMAL(18,2) COMMENT 'Percentage discount applied to the invoice net amount if payment is received within the second discount period (discount_days_2). Enables multi-tier early payment incentive structures for industrial B2B customers.. Valid values are `^(0(.d{1,4})?|1(.0{1,4})?)$`',
    `document_language` STRING COMMENT 'ISO 639-1 two-letter language code for the language in which the payment term description and invoice text are printed on customer-facing documents. Supports multilingual invoice generation for global industrial customers.. Valid values are `^[A-Z]{2}$`',
    `dunning_block_indicator` BOOLEAN COMMENT 'Flag indicating whether dunning (payment reminder and escalation) is blocked for invoices assigned this payment term. When true, overdue invoices will not be included in automated dunning runs. Applicable for special contractual arrangements or disputed accounts.. Valid values are `true|false`',
    `effective_date` DATE COMMENT 'Date from which this payment term becomes valid and available for assignment to customer accounts and invoices. Supports time-bound payment condition management and contractual change control.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date after which this payment term is no longer valid for new assignments. Enables time-limited promotional payment terms (e.g., extended terms for a sales campaign) and supports master data lifecycle governance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `grace_period_days` STRING COMMENT 'Number of additional calendar days beyond the net due date before late payment interest or dunning actions are triggered. Provides a tolerance window for payment processing delays, particularly relevant for cross-border industrial transactions.. Valid values are `^[0-9]{1,3}$`',
    `incoterms_relevance` STRING COMMENT 'Incoterms rule associated with this payment term, indicating the point of risk transfer and delivery obligation that triggers the payment baseline. Relevant for export and cross-border industrial shipments where payment timing is linked to delivery milestones.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF|not_applicable`',
    `installment_count` STRING COMMENT 'Total number of installment payments defined under this payment term. Applicable only when is_installment is true. Used to validate billing plan milestone counts and schedule accounts receivable postings.. Valid values are `^[0-9]{1,3}$`',
    `is_installment` BOOLEAN COMMENT 'Flag indicating whether this payment term defines an installment payment schedule with multiple partial payments due at different dates. When true, the installment schedule details are defined in the associated billing plan milestones. Relevant for large capital equipment and project-based industrial contracts.. Valid values are `true|false`',
    `is_intercompany_applicable` BOOLEAN COMMENT 'Flag indicating whether this payment term is applicable to intercompany billing transactions between legal entities within the same corporate group. Supports intercompany reconciliation and transfer pricing compliance in multinational manufacturing operations.. Valid values are `true|false`',
    `is_prepayment_required` BOOLEAN COMMENT 'Flag indicating whether this payment term requires full or partial prepayment before goods are shipped or services are rendered. Common for new customers, high-risk accounts, or engineer-to-order (ETO) projects in industrial manufacturing.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this payment term record was most recently updated. Supports change tracking, data quality monitoring, and master data governance in the billing domain.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `late_payment_interest_rate` DECIMAL(18,2) COMMENT 'Annual interest rate (as a decimal percentage) charged on overdue invoice amounts when payment is not received by the net due date. Used to calculate late payment charges in compliance with contractual terms and statutory late payment regulations.. Valid values are `^d{1,2}(.d{1,4})?$`',
    `name` STRING COMMENT 'Short descriptive name of the payment term (e.g., Net 30 Days, 2/10 Net 30, Immediate Payment). Displayed on invoices and customer-facing documents.',
    `net_due_day_of_month` STRING COMMENT 'Specific calendar day of the month on which payment is due, used for fixed-date payment terms (e.g., payment due on the 15th of the following month). Applicable when the payment term uses a fixed monthly due date rather than a rolling day count.. Valid values are `^([1-9]|[12][0-9]|3[01])$`',
    `net_due_days` STRING COMMENT 'Number of calendar days from the baseline date by which the full invoice amount must be paid without penalty. For example, a value of 30 means the invoice is due 30 days after the baseline date. Core field for accounts receivable aging and dunning.. Valid values are `^[0-9]{1,4}$`',
    `payment_method` STRING COMMENT 'Permitted or required payment instrument associated with this payment term (e.g., bank_transfer, direct_debit, letter_of_credit). Drives payment processing routing in accounts receivable and bank communication. Maps to SAP payment method key.. Valid values are `bank_transfer|check|direct_debit|letter_of_credit|credit_card|electronic_funds_transfer|cash|promissory_note`',
    `prepayment_percentage` DECIMAL(18,2) COMMENT 'Percentage of the total invoice or contract value required as prepayment before order fulfillment begins. Applicable when is_prepayment_required is true. Used in billing plan milestone generation for ETO and project-based manufacturing orders.. Valid values are `^(100(.00?)?|d{1,2}(.d{1,2})?)$`',
    `print_text` STRING COMMENT 'Standardized text string printed on invoices and billing documents to communicate the payment conditions to the customer (e.g., Payment due within 30 days of invoice date. 2% discount if paid within 10 days.). Supports legal and contractual transparency requirements.',
    `revenue_recognition_relevance` STRING COMMENT 'Indicates how this payment term interacts with revenue recognition rules. deferred terms may require revenue to be held until payment conditions are met; milestone_based links recognition to project completion events. Supports IFRS 15 and ASC 606 compliance for industrial manufacturing contracts.. Valid values are `immediate|deferred|milestone_based|percentage_of_completion|not_applicable`',
    `sales_organization_restriction` STRING COMMENT 'SAP sales organization code(s) to which this payment term is restricted. If populated, the term is only available for invoices raised under the specified sales organization(s). Supports organizational governance in multinational manufacturing entities.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this payment term was sourced or originated (e.g., SAP_S4HANA for FI-AR configuration, SALESFORCE_CRM for CRM-driven terms). Supports data lineage and integration traceability in the Databricks Silver Layer.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL|ARIBA|LEGACY`',
    `source_system_key` STRING COMMENT 'Natural key or identifier of this payment term as it exists in the originating source system (e.g., SAP payment term key such as ZB30). Enables reconciliation between the lakehouse Silver Layer and the operational system of record.',
    `status` STRING COMMENT 'Current lifecycle status of the payment term record. active terms are available for assignment to invoices and customer accounts; inactive terms are suspended from new assignments; deprecated terms are retained for historical reference only.. Valid values are `active|inactive|deprecated`',
    `tax_relevance` STRING COMMENT 'Indicates the VAT/tax treatment applicable under this payment term. tax_on_payment (cash accounting) means VAT is due when payment is received; tax_on_invoice means VAT is due at invoice date. Relevant for VAT compliance across EU and other jurisdictions.. Valid values are `standard|tax_on_payment|tax_on_invoice|exempt`',
    `term_type` STRING COMMENT 'Classification of the payment term structure. standard indicates a single net due date; installment indicates multiple scheduled payments; milestone links payment to project or delivery milestones; prepayment requires payment before delivery; letter_of_credit requires documentary credit. Drives billing plan and accounts receivable processing logic.. Valid values are `standard|installment|milestone|prepayment|consignment|cash_on_delivery|letter_of_credit|open_account`',
    CONSTRAINT pk_billing_payment_term PRIMARY KEY(`billing_payment_term_id`)
) COMMENT 'Reference master for payment terms and conditions applicable to industrial customer billing. Captures payment term key, description, baseline date calculation rule, number of days for net payment, early payment discount percentage and days (e.g., 2/10 net 30), installment payment schedule indicator, and applicable customer segments. Defines the contractual payment conditions used on invoices and accounts receivable management for industrial B2B customers.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` (
    `invoice_status_history_id` BIGINT COMMENT 'Unique surrogate identifier for each invoice status history record in the Databricks Silver Layer. Serves as the primary key for the invoice_status_history data product.',
    `approved_by_user_employee_id` BIGINT COMMENT 'System user identifier of the approver who authorized the status transition when approval was required. Supports segregation of duties, internal audit, and Sarbanes-Oxley (SOX) compliance for financial document approvals.',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: invoice_status_history tracks status transitions for invoices. Currently has invoice_number (STRING) but needs proper FK invoice_id to invoice.invoice_id for referential integrity and to enable joins ',
    `employee_id` BIGINT COMMENT 'System user identifier of the person or service account that initiated the status transition. Populated for user_action and manual_override trigger types. For automated transitions, this may reflect the system service account. Supports accountability and audit trail requirements.',
    `approval_required` BOOLEAN COMMENT 'Indicates whether the status transition required formal approval before being executed (e.g., cancellation or reversal of high-value invoices requiring manager authorization). Supports segregation of duties and internal control compliance.. Valid values are `true|false`',
    `approved_timestamp` TIMESTAMP COMMENT 'Exact date and time when the status transition was formally approved. Populated only when approval_required is true. Supports SLA measurement for approval cycle times and audit trail completeness for financial controls.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})`',
    `billing_document_category` STRING COMMENT 'Classification of the invoice document type whose status is being tracked. Aligns with SAP S/4HANA billing document categories (VBRK-VBTYP) and supports segmented analysis of status transitions by invoice type.. Valid values are `standard_invoice|pro_forma|intercompany|credit_memo|debit_memo|milestone_billing|down_payment|cancellation`',
    `clearing_document_number` STRING COMMENT 'SAP FI clearing document number generated when the invoice is cleared against a payment. Populated during transitions to cleared or paid status. Supports accounts receivable reconciliation and audit trail completeness.',
    `company_code` STRING COMMENT 'SAP S/4HANA company code (VBRK-BUKRS) representing the legal entity that owns the invoice. Essential for multi-entity financial reporting, intercompany reconciliation, and compliance with IFRS and GAAP reporting requirements across multinational operations.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the billing entity or customer jurisdiction associated with the invoice. Supports country-level regulatory compliance tracking (e.g., VAT, e-invoicing mandates, GDPR, CCPA) and regional billing performance analysis.. Valid values are `[A-Z]{3}`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this invoice status history record was created in the Databricks Silver Layer. Supports data lineage, audit trail completeness, and Silver Layer ingestion monitoring for the billing domain.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})`',
    `customer_account_number` STRING COMMENT 'SAP S/4HANA customer account number (VBRK-KUNAG) of the invoice recipient. Included in the status history to support customer-level dispute resolution, accounts receivable aging analysis, and customer service inquiries without requiring a join to the invoice header.',
    `dispute_case_number` STRING COMMENT 'Reference number of the associated dispute case when the status transition is related to a billing dispute (e.g., transition to disputed or resolution from disputed). Links the status history to the dispute management process for resolution tracking.',
    `dunning_level` STRING COMMENT 'Current dunning level of the invoice at the time of the status transition (SAP VBRK dunning level). Tracks escalation of payment reminders from level 0 (no dunning) through level 4 (final notice). Supports accounts receivable collections performance monitoring.. Valid values are `0|1|2|3|4`',
    `fiscal_period` STRING COMMENT 'Fiscal accounting period (month) within the fiscal year in which the status transition occurred. Supports period-level accounts receivable reporting, revenue recognition monitoring, and month-end close processes.. Valid values are `0[1-9]|1[0-6]`',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the status transition occurred. Used for period-end financial reporting, accounts receivable aging analysis, and compliance with IFRS and GAAP fiscal period reporting requirements.. Valid values are `d{4}`',
    `hold_reason_code` STRING COMMENT 'Standardized code indicating the reason an invoice was placed on hold (e.g., credit limit exceeded, pending customer approval, tax compliance review, export control check). Populated when transitioning to on_hold status.',
    `invoice_currency` STRING COMMENT 'ISO 4217 three-letter currency code of the invoice (VBRK-WAERK). Supports multi-currency billing operations across multinational entities and is required for accurate financial reporting and foreign exchange reconciliation.. Valid values are `[A-Z]{3}`',
    `invoice_date` DATE COMMENT 'Original billing date of the invoice (VBRK-FKDAT). Included in the status history record to provide temporal context for the invoice lifecycle and support aging analysis relative to status transitions.. Valid values are `d{4}-d{2}-d{2}`',
    `invoice_gross_amount` DECIMAL(18,2) COMMENT 'Total gross amount of the invoice including taxes at the time of the status transition. Captured in the history record to provide financial context for each status change, supporting dispute resolution and accounts receivable reporting.',
    `is_intercompany` BOOLEAN COMMENT 'Indicates whether the invoice is an intercompany transaction between legal entities within the same corporate group. Supports intercompany reconciliation, transfer pricing compliance, and elimination entries in consolidated financial reporting.. Valid values are `true|false`',
    `new_status` STRING COMMENT 'The invoice lifecycle status after the transition captured in this record. Represents the resulting state following the trigger event and is the current status at the time of this history entry.. Valid values are `draft|open|posted|transmitted|partially_paid|paid|cleared|disputed|on_hold|cancelled|reversed|credit_memo_issued`',
    `notes` STRING COMMENT 'Free-text notes or comments associated with the status transition. May include explanations for manual overrides, dispute resolution context, customer communication references, or additional operational details not captured by structured fields.',
    `payment_due_date` DATE COMMENT 'Date by which payment is due for the invoice at the time of the status transition. Included to support overdue analysis, dunning process monitoring, and SLA compliance tracking relative to status changes.. Valid values are `d{4}-d{2}-d{2}`',
    `previous_status` STRING COMMENT 'The invoice lifecycle status immediately before the transition captured in this record. Enables reconstruction of the full status progression and supports dispute resolution and compliance auditing.. Valid values are `draft|open|posted|transmitted|partially_paid|paid|cleared|disputed|on_hold|cancelled|reversed|credit_memo_issued`',
    `revenue_recognition_status` STRING COMMENT 'Status of revenue recognition for the invoice at the time of the status transition. Tracks whether revenue has been recognized, deferred, or reversed in accordance with IFRS 15 / ASC 606 performance obligation fulfillment criteria.. Valid values are `not_started|in_progress|recognized|deferred|reversed`',
    `reversal_reason_code` STRING COMMENT 'Standardized reason code explaining why an invoice was reversed or cancelled (e.g., duplicate billing, incorrect pricing, customer return). Populated when the status transitions to reversed or cancelled. Supports root cause analysis and billing quality improvement.',
    `sales_organization` STRING COMMENT 'SAP S/4HANA sales organization (VBRK-VKORG) responsible for the invoice. Used to segment billing status history by sales channel and organizational unit for performance monitoring and revenue reporting.',
    `source_system` STRING COMMENT 'Identifies the operational system of record that originated the status transition event. Supports data lineage tracking and reconciliation across SAP S/4HANA SD/FI, Salesforce CRM, Siemens Opcenter MES, and integration middleware platforms.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|SIEMENS_OPCENTER|MANUAL|INTEGRATION_MIDDLEWARE`',
    `source_system_event_reference` STRING COMMENT 'Unique identifier of the change document or event record in the originating source system (e.g., SAP Change Document number from CDHDR). Enables traceability back to the source system for reconciliation and audit purposes.',
    `tax_compliance_status` STRING COMMENT 'Indicates the tax compliance validation status of the invoice at the time of the status transition. Supports VAT/GST compliance monitoring, tax authority audit readiness, and identification of invoices requiring tax correction before payment clearance.. Valid values are `compliant|pending_review|non_compliant|exempt|not_applicable`',
    `transition_timestamp` TIMESTAMP COMMENT 'Exact date and time (with timezone) when the invoice status transition occurred. Critical for compliance auditing, SLA measurement, and billing process performance monitoring. Stored in ISO 8601 format.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})`',
    `transmission_channel` STRING COMMENT 'Channel through which the invoice was transmitted to the customer when the status transitions to transmitted. Supports e-invoicing compliance tracking (e.g., EU mandatory e-invoicing), EDI reconciliation, and customer communication preference management.. Valid values are `email|edi|portal|print|fax|api|einvoice`',
    `transmission_timestamp` TIMESTAMP COMMENT 'Exact date and time when the invoice was transmitted to the customer. Populated when the status transitions to transmitted. Supports SLA compliance measurement for invoice delivery and regulatory e-invoicing audit requirements.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})`',
    `trigger_event_code` STRING COMMENT 'Standardized business event code that caused the status transition (e.g., INVOICE_POSTED, PAYMENT_RECEIVED, DISPUTE_RAISED, CANCELLATION_REQUESTED, CLEARING_EXECUTED). Enables systematic categorization and reporting of transition drivers across the billing lifecycle.',
    `trigger_event_description` STRING COMMENT 'Human-readable description of the business event or action that caused the invoice status transition. Provides contextual narrative for auditors, dispute resolution teams, and billing analysts reviewing the status history.',
    `trigger_type` STRING COMMENT 'Categorizes the mechanism that initiated the invoice status transition. Distinguishes between manual user actions, automated system processes, scheduled batch jobs, workflow rule evaluations, and inbound integration events from connected systems such as SAP S/4HANA or Siemens Opcenter MES.. Valid values are `user_action|system_automated|batch_job|workflow_rule|integration_event|manual_override`',
    `triggered_by_user_name` STRING COMMENT 'Display name of the user or process that triggered the status transition. Complements the user ID for human-readable audit reporting and dispute resolution workflows.',
    `workflow_instance_reference` STRING COMMENT 'Identifier of the business workflow instance (e.g., approval workflow, dispute resolution workflow) that triggered or processed the status transition. Supports end-to-end process traceability and billing process performance monitoring.',
    CONSTRAINT pk_invoice_status_history PRIMARY KEY(`invoice_status_history_id`)
) COMMENT 'Chronological audit trail of all status transitions for customer invoices throughout their lifecycle. Captures invoice reference, previous status, new status, transition timestamp, triggered by (user, system, automated process), trigger event description, and any associated notes. Tracks the full lifecycle from draft creation through posting, transmission, payment, clearing, and cancellation. Supports compliance auditing, dispute resolution, and billing process performance monitoring.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`write_off` (
    `write_off_id` BIGINT COMMENT 'Unique system-generated identifier for each write-off record in the accounts receivable process.',
    `authorized_by_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Bad debt write-offs require senior management authorization in manufacturing. Critical for financial controls, audit trails, and segregation of duties in accounts receivable management.',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Uncollectible invoices are written off after collection efforts fail. Links write-off to specific invoice for bad debt reporting, tax documentation, and accounts receivable cleanup.',
    `employee_id` BIGINT COMMENT 'System user identifier of the individual who approved the write-off. Supports segregation of duties, audit trail, and SOX internal control documentation.',
    `journal_entry_id` BIGINT COMMENT 'Foreign key linking to finance.journal_entry. Business justification: Bad debt write-offs create GL journal entries to expense accounts and reduce receivables. Finance uses this for allowance for doubtful accounts management.',
    `allowance_account` STRING COMMENT 'General ledger account code for the allowance for doubtful accounts (contra-asset) that is debited when the allowance method is used to absorb the write-off.',
    `amount` DECIMAL(18,2) COMMENT 'The gross amount of the customer invoice balance approved for write-off in the transaction currency. Represents the uncollectable receivable being removed from the books.',
    `amount_company_currency` DECIMAL(18,2) COMMENT 'Write-off amount converted to the company codes local functional currency for financial reporting and general ledger posting purposes.',
    `approval_date` DATE COMMENT 'The date on which the write-off was formally approved by the authorized approver. Required for audit trail and SOX compliance documentation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approval_limit_amount` DECIMAL(18,2) COMMENT 'Maximum write-off amount the approver is authorized to approve under the companys delegation of authority policy. Used to validate that the write-off is within the approvers authorization threshold.',
    `approval_status` STRING COMMENT 'Current state of the write-off approval workflow, indicating whether the write-off has been reviewed and authorized by the designated approver.. Valid values are `PENDING|APPROVED|REJECTED|ESCALATED`',
    `approver_name` STRING COMMENT 'Full name of the individual who approved the write-off. Retained for human-readable audit documentation and financial reporting.',
    `bad_debt_expense_account` STRING COMMENT 'General ledger account code to which the bad debt expense is charged when the write-off is posted. Drives income statement classification of credit losses.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity within the multinational organization that owns the receivable being written off. Supports multi-entity financial reporting.',
    `company_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the company codes functional currency used for local financial reporting.. Valid values are `^[A-Z]{3}$`',
    `cost_center` STRING COMMENT 'SAP cost center associated with the write-off for internal cost allocation and management reporting purposes.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the jurisdiction in which the write-off is recorded. Supports country-level bad debt reporting, VAT bad debt relief, and regulatory compliance.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when the write-off record was created in the source system. Used for audit trail, data lineage, and period-end reconciliation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the transaction in which the write-off amount is denominated (e.g., USD, EUR, GBP). Supports multi-currency billing operations.. Valid values are `^[A-Z]{3}$`',
    `customer_account_number` STRING COMMENT 'Identifier of the customer account in the accounts receivable ledger against which the write-off is posted.',
    `customer_name` STRING COMMENT 'Legal name of the customer whose invoice balance is being written off. Used for reporting, credit risk analysis, and audit documentation.',
    `date` DATE COMMENT 'The calendar date on which the write-off was formally approved and executed. Used for period-end close, bad debt expense recognition, and aging analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign exchange rate applied to convert the write-off amount from transaction currency to company currency at the time of posting.',
    `fiscal_period` STRING COMMENT 'The accounting period (month) within the fiscal year in which the write-off is posted. Used for monthly financial close and period-level bad debt expense reporting.. Valid values are `^(0[1-9]|1[0-2])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the write-off is posted, used for period-end financial close, bad debt expense reporting, and year-over-year credit loss trend analysis.. Valid values are `^d{4}$`',
    `is_recovery_expected` BOOLEAN COMMENT 'Indicates whether a subsequent recovery of the written-off amount is anticipated (e.g., through legal proceedings, insolvency distributions, or commercial negotiations). Triggers monitoring in the collections process.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when the write-off record was last updated in the source system. Supports change tracking, audit trail, and incremental data loading in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `method` STRING COMMENT 'Accounting method used to record the write-off. Direct write-off charges bad debt expense immediately; allowance method offsets against the previously established allowance for doubtful accounts.. Valid values are `DIRECT_WRITE_OFF|ALLOWANCE_METHOD`',
    `number` STRING COMMENT 'Business-facing document number assigned to the write-off transaction, used for reference in correspondence, audit trails, and financial reporting.. Valid values are `^WO-[0-9]{4}-[0-9]{6}$`',
    `original_invoice_amount` DECIMAL(18,2) COMMENT 'The total gross amount of the original invoice at the time of issuance, before any payments or adjustments. Provides context for the magnitude of the credit loss relative to the original billing.',
    `outstanding_balance_at_write_off` DECIMAL(18,2) COMMENT 'The remaining open receivable balance on the invoice at the time the write-off was approved, after accounting for any prior partial payments or credit notes applied.',
    `profit_center` STRING COMMENT 'SAP profit center to which the bad debt expense is allocated, enabling segment-level profitability reporting and management accounting analysis.',
    `reason_code` STRING COMMENT 'Standardized code classifying the business reason for the write-off. Drives bad debt expense categorization, credit risk reporting, and IFRS 9 expected credit loss (ECL) analysis.. Valid values are `BAD_DEBT|INSOLVENCY|COMMERCIAL_SETTLEMENT|STATUTE_OF_LIMITATIONS|DISPUTED|FRAUD|OTHER`',
    `reason_description` STRING COMMENT 'Free-text narrative providing additional context or justification for the write-off beyond the standardized reason code. Supports audit documentation and credit review.',
    `recovery_amount` DECIMAL(18,2) COMMENT 'The amount subsequently recovered from the customer after the write-off was posted. Populated when a recovery event occurs; triggers reversal or bad debt recovery accounting entry.',
    `recovery_date` DATE COMMENT 'The date on which a recovery payment was received from the customer after the write-off was posted. Used to record the bad debt recovery accounting entry in the correct period.. Valid values are `^d{4}-d{2}-d{2}$`',
    `reversal_date` DATE COMMENT 'The date on which the write-off was reversed in the general ledger. Populated only when reversal_indicator is true.. Valid values are `^d{4}-d{2}-d{2}$`',
    `reversal_indicator` BOOLEAN COMMENT 'Flag indicating whether this write-off has been reversed (e.g., due to subsequent full payment, error correction, or management decision). A reversed write-off reinstates the receivable.. Valid values are `true|false`',
    `reversal_reason` STRING COMMENT 'Explanation for why the write-off was reversed, such as full payment received, data entry error, or management override. Required for audit trail completeness.',
    `source_system` STRING COMMENT 'Name of the operational system of record from which the write-off record originated (e.g., SAP S/4HANA FI-AR). Supports data lineage tracking in the lakehouse.',
    `status` STRING COMMENT 'Current processing status of the write-off record, tracking its lifecycle from approval request through posting or reversal in the accounts receivable ledger.. Valid values are `PENDING_APPROVAL|APPROVED|POSTED|REVERSED|CANCELLED`',
    `tax_amount_written_off` DECIMAL(18,2) COMMENT 'The portion of the write-off amount attributable to taxes (e.g., VAT, GST). Required for tax authority reporting and VAT bad debt relief claims in applicable jurisdictions.',
    CONSTRAINT pk_write_off PRIMARY KEY(`write_off_id`)
) COMMENT 'Records approved write-offs of uncollectable customer invoice balances in the accounts receivable process. Captures write-off amount, write-off reason (bad debt, insolvency, commercial settlement, statute of limitations), original invoice reference, customer account, write-off approval date, approver, write-off method (direct write-off, allowance method), bad debt expense account, and recovery flag for subsequent collections. Supports IFRS and GAAP bad debt accounting and credit risk reporting.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` (
    `proforma_invoice_id` BIGINT COMMENT 'Unique surrogate identifier for the pro-forma invoice record in the Databricks Silver Layer. Serves as the primary key for all downstream joins and lineage tracking.',
    `billing_payment_term_id` BIGINT COMMENT 'Foreign key linking to billing.payment_term. Business justification: proforma_invoice has payment_terms_code (STRING) but needs proper FK payment_term_id to payment_term.payment_term_id for referential integrity and to access full payment term configuration. Removing p',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Proforma invoice issued to customer account - normalize by replacing customer_account_number and customer_name with FK',
    `delivery_order_id` BIGINT COMMENT 'Foreign key linking to order.delivery_order. Business justification: Proforma invoice references delivery - normalize by replacing delivery_number text with FK',
    `sales_opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Proforma invoices in manufacturing are issued during opportunity negotiation for large automation projects requiring customer approval before production. Links quote to billing documentation for proje',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Proforma invoice references sales order - normalize by replacing sales_order_number text with FK',
    `type_id` BIGINT COMMENT 'Foreign key linking to billing.billing_type. Business justification: proforma_invoice has billing_type (STRING) but needs proper FK billing_type_id to billing_type.billing_type_id for referential integrity and to access full billing type configuration. Removing billing',
    `company_code` STRING COMMENT 'SAP FI company code representing the legal entity issuing the pro-forma invoice. Determines the applicable accounting rules, tax jurisdiction, and currency for the issuing entity.',
    `company_currency_code` STRING COMMENT 'ISO 4217 code for the company codes local (functional) currency. Used for internal financial reporting and IFRS/GAAP currency translation disclosures.. Valid values are `^[A-Z]{3}$`',
    `contract_number` STRING COMMENT 'Reference to the underlying sales contract or scheduling agreement in SAP SD. Relevant for long-term supply agreements where pro-forma invoices are issued per shipment against a master contract.',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the goods were manufactured or substantially transformed. Mandatory for customs declarations, preferential tariff claims, and REACH/RoHS compliance documentation.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the pro-forma invoice record was created in the source system (SAP SD). Used for audit trail, data lineage, and SLA compliance tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the pro-forma invoice amounts are expressed (e.g., USD, EUR, GBP). Drives currency conversion for multi-currency reporting and letter-of-credit compliance.. Valid values are `^[A-Z]{3}$`',
    `customer_reference` STRING COMMENT 'Customer-provided reference number (e.g., customer purchase order number, project reference, or letter-of-credit application number) to be printed on the pro-forma invoice for customer reconciliation.',
    `customs_declaration_reference` STRING COMMENT 'Reference number of the associated customs export or import declaration (e.g., EAD/MRN in the EU, AES ITN in the US). Links the pro-forma invoice to the official customs filing for trade compliance audit trails.',
    `destination_country` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country to which the goods are being shipped. Required for import duty calculation, trade compliance screening, and customs declaration.. Valid values are `^[A-Z]{3}$`',
    `distribution_channel` STRING COMMENT 'SAP SD distribution channel code (e.g., direct sales, dealer, OEM) through which the goods or services are sold. Used for sales reporting segmentation and pricing determination.',
    `division` STRING COMMENT 'SAP SD division code representing the product line or business unit responsible for the goods on the pro-forma invoice. Used for profitability analysis and segment reporting.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign exchange rate applied to convert the transaction currency amounts to the company code local currency at the time of pro-forma invoice issuance. Sourced from SAP exchange rate tables.',
    `export_control_classification` STRING COMMENT 'Export Control Classification Number (ECCN) or equivalent classification code assigned to the goods. Required for dual-use goods subject to export licensing under EAR, ITAR, or EU Dual-Use Regulation to ensure trade compliance.',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total gross value of the pro-forma invoice including all taxes and charges, expressed in the transaction currency. Represents the total amount the customer is expected to pay or the total declared value for customs.',
    `hts_code` STRING COMMENT 'Harmonized System (HS) or Harmonized Tariff Schedule (HTS) commodity classification code for the goods being shipped. Required on customs export/import declarations to determine applicable duties, restrictions, and trade compliance requirements.. Valid values are `^[0-9]{4,10}(.[0-9]{2})?$`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the delivery obligations, risk transfer point, and cost responsibilities between seller and buyer. Mandatory on customs export declarations and letters of credit.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `incoterms_location` STRING COMMENT 'Named place or port associated with the Incoterms code (e.g., Hamburg for FOB Hamburg). Required alongside the Incoterms code on customs and trade documents per ICC Incoterms 2020 rules.',
    `is_intercompany` BOOLEAN COMMENT 'Flag indicating whether the pro-forma invoice is issued for an intercompany transaction (between two legal entities within the same corporate group). Drives transfer pricing compliance and intercompany elimination in consolidated reporting.. Valid values are `true|false`',
    `issue_date` DATE COMMENT 'Calendar date on which the pro-forma invoice was formally issued to the customer. Printed on the document and used as the reference date for validity period calculation and customs submission.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the pro-forma invoice record. Used for change detection in ETL pipelines and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `letter_of_credit_number` STRING COMMENT 'Reference number of the documentary letter of credit (L/C) against which this pro-forma invoice is presented. Required for L/C-based payment transactions to ensure document compliance with UCP 600 terms.',
    `net_amount` DECIMAL(18,2) COMMENT 'Total net value of the pro-forma invoice before taxes, expressed in the transaction currency. Represents the declared commercial value for customs purposes and the basis for letter-of-credit presentation.',
    `net_amount_company_currency` DECIMAL(18,2) COMMENT 'Net invoice amount converted to the company code local currency using the exchange rate at issuance. Used for internal financial planning, cost allocation, and IFRS/GAAP reporting.',
    `number` STRING COMMENT 'Externally visible, human-readable document number assigned to the pro-forma invoice. Used on customs declarations, letters of credit, and customer correspondence. Sourced from SAP SD billing document number range for pro-forma billing types (F5/F8).. Valid values are `^PF-[A-Z0-9]{2,10}-[0-9]{4,12}$`',
    `payer_account_number` STRING COMMENT 'SAP account number of the payer partner function, which may differ from the sold-to party in complex customer hierarchies. Relevant for advance payment requests and letter-of-credit scenarios.',
    `plant` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility from which the goods are shipped. Determines the country of export, warehouse location, and applicable export control regulations.',
    `purpose` STRING COMMENT 'Business purpose for which the pro-forma invoice was issued. Determines the required content, legal obligations, and downstream processing workflow (e.g., customs submission vs. bank presentation vs. internal charge-back).. Valid values are `customs_clearance|letter_of_credit|advance_payment|internal_cost_allocation|insurance_valuation|other`',
    `sales_organization` STRING COMMENT 'SAP SD sales organization code responsible for the sale. Determines pricing procedures, output determination, and revenue attribution for the pro-forma invoice.',
    `shipping_country` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country from which the goods are exported. Used for export control screening, customs declaration, and trade compliance reporting.. Valid values are `^[A-Z]{3}$`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which the pro-forma invoice data was sourced (e.g., SAP S/4HANA SD module). Supports data lineage, reconciliation, and multi-system integration audits.. Valid values are `SAP_S4HANA|MANUAL|LEGACY`',
    `status` STRING COMMENT 'Current lifecycle status of the pro-forma invoice. Drives workflow routing, validity checks, and downstream customs or letter-of-credit processing.. Valid values are `draft|issued|submitted|accepted|expired|cancelled|superseded`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount (VAT, GST, or applicable indirect tax) calculated on the pro-forma invoice. Included for informational purposes; pro-forma invoices carry no accounting posting but must reflect expected tax for advance payment requests.',
    `validity_date` DATE COMMENT 'Date until which the pro-forma invoice is considered valid for customs clearance, letter-of-credit presentation, or advance payment purposes. After this date the document must be reissued.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_proforma_invoice PRIMARY KEY(`proforma_invoice_id`)
) COMMENT 'Non-posting pro-forma billing document issued to industrial customers for customs clearance, letter of credit presentation, advance payment requests, or internal cost allocation purposes. Captures pro-forma invoice number, issue date, validity date, customer reference, total value, currency, incoterms, country of origin, harmonized tariff code (HTS), and customs declaration reference. Distinct from a posted invoice as it carries no accounting impact but is legally required for cross-border industrial shipments.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`condition` (
    `condition_id` BIGINT COMMENT 'Unique surrogate identifier for each billing condition record in the silver layer lakehouse. Serves as the primary key for this entity.',
    `billing_invoice_id` BIGINT COMMENT 'The SAP SD billing document number (VBELN) to which this condition record is applied. Links the condition to the parent invoice, credit note, or debit note.',
    `account_key` STRING COMMENT 'The SAP SD account key (KVSL1) that maps the condition type to the corresponding General Ledger (GL) account for revenue, freight, discount, or surcharge posting in Financial Accounting.',
    `accrual_account_key` STRING COMMENT 'The SAP SD accrual account key (KVSL2) used for conditions that require accrual postings, such as rebates and commissions, mapping to the corresponding accrual GL account.',
    `base_value` DECIMAL(18,2) COMMENT 'The base amount upon which the condition rate is applied to derive the condition value. For percentage-based conditions, this is the subtotal from which the percentage is calculated. Corresponds to SAP KAWRT field.',
    `billing_date` DATE COMMENT 'The date on which the billing document containing this condition was created and posted. Used for revenue recognition, tax determination, and period-end financial reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `billing_document_line_item` STRING COMMENT 'The line item number (POSNR) within the billing document to which this condition applies. A value of 000000 indicates a header-level condition.',
    `calculation_type` STRING COMMENT 'Defines how the condition value is calculated: as a fixed monetary amount, a percentage of the base, per unit of quantity, per unit of weight, per unit of volume, or via a formula. Corresponds to SAP KRECH field.. Valid values are `fixed_amount|percentage|quantity_based|weight_based|volume_based|formula|free_goods`',
    `category` STRING COMMENT 'Business classification of the condition record indicating whether it represents a base price, discount, surcharge, freight cost, tax, insurance, packaging fee, rebate, or other billing adjustment.. Valid values are `price|discount|surcharge|freight|tax|insurance|packaging|rebate|commission|cost|other`',
    `class` STRING COMMENT 'SAP SD condition class (KONDM) indicating the functional class of the condition: A=Discount/Surcharge, B=Prices, C=Expense Reimbursement, D=Taxes, E=Tax Jurisdiction.. Valid values are `A|B|C|D|E`',
    `company_code` STRING COMMENT 'The SAP FI company code (BUKRS) to which the billing document and its conditions are posted, representing an independent legal entity for financial accounting and statutory reporting.',
    `company_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the company code local currency used for financial reporting, such as USD for a US entity or EUR for a European entity.. Valid values are `^[A-Z]{3}$`',
    `counter` STRING COMMENT 'The counter within a pricing procedure step that allows multiple condition records of the same type to be applied at the same step. Used to differentiate multiple conditions at the same step number.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when the billing condition record was first created in the source system, used for audit trail, data lineage, and change history tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the billing transaction in which the condition value is expressed, such as USD, EUR, GBP, or JPY.. Valid values are `^[A-Z]{3}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign exchange rate applied to convert the condition value from the transaction currency to the company code local currency at the time of billing document creation.',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether this condition type is mandatory within the pricing procedure and cannot be deleted or overridden by the user during billing document processing.. Valid values are `true|false`',
    `is_manually_changed` BOOLEAN COMMENT 'Indicates whether the condition value or rate was manually overridden by a user from the automatically determined value. Supports audit trail and pricing compliance monitoring.. Valid values are `true|false`',
    `is_statistical` BOOLEAN COMMENT 'Indicates whether the condition is purely statistical (informational) and does not affect the net value or trigger an accounting posting. Statistical conditions are used for reporting and analysis purposes only.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when the billing condition record was last updated in the source system, supporting incremental data loading, change detection, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `origin` STRING COMMENT 'Indicates how the condition was determined and applied to the billing document: manually entered by a user, automatically determined by the pricing procedure, derived from a contract, pricing agreement, or promotional arrangement.. Valid values are `manual|automatic|contract|pricing_agreement|customer_specific|promotion|rebate_agreement`',
    `pricing_date` DATE COMMENT 'The date used to determine the applicable condition record from the condition master, which may differ from the billing date. Used for retroactive pricing adjustments and contract-based pricing.. Valid values are `^d{4}-d{2}-d{2}$`',
    `pricing_procedure` STRING COMMENT 'The SAP SD pricing procedure (KALSM) used to determine and sequence the condition types applied to the billing document, defining the order of price, discount, surcharge, and tax calculations.',
    `rate` DECIMAL(18,2) COMMENT 'The rate or percentage used to calculate the condition value. For percentage-based conditions this is the percentage (e.g., 5.00 for 5%), for quantity-based conditions this is the per-unit rate. Corresponds to SAP KBETR field.',
    `rate_unit` STRING COMMENT 'The unit of measure associated with the condition rate, such as % for percentage, EA for per each, KG for per kilogram, or L for per liter. Corresponds to SAP KMEIN field.',
    `record_number` STRING COMMENT 'The source system condition record number from SAP SD (KNUMH) that uniquely identifies the pricing or surcharge condition record in the originating ERP system.',
    `sales_organization` STRING COMMENT 'The SAP SD sales organization (VKORG) responsible for the billing document, representing a legal or organizational unit responsible for the sale of products and services in a specific market.',
    `scale_quantity` DECIMAL(18,2) COMMENT 'The quantity scale value at which this condition rate applies, enabling tiered or volume-based pricing where different rates apply at different quantity thresholds.',
    `scale_unit` STRING COMMENT 'The unit of measure associated with the condition scale quantity, such as EA (each), KG (kilogram), or L (liter), defining the basis for volume-based or weight-based tiered pricing.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this billing condition record was extracted, such as SAP S/4HANA SD, enabling data lineage tracking in the lakehouse.',
    `status` STRING COMMENT 'Current processing status of the condition record: active (applied and posted), inactive (not applied), deleted (removed from document), blocked (pending approval), or statistical (informational only, not posted to accounting).. Valid values are `active|inactive|deleted|blocked|statistical`',
    `step_number` STRING COMMENT 'The sequential step number within the pricing procedure at which this condition type is evaluated. Determines the order of condition calculation and the subtotal to which subsequent conditions are applied.',
    `tax_code` STRING COMMENT 'The tax code associated with this condition record, used to determine the applicable tax rate and tax account for VAT, GST, or sales tax posting. Relevant for tax-type conditions such as MWST.',
    `type` STRING COMMENT 'The SAP SD condition type code (KSCHL) identifying the nature of the pricing element, such as PR00 (base price), MWST (tax), FRB1 (freight), RA01 (discount), VPRS (cost), or custom surcharge types.',
    `type_description` STRING COMMENT 'Human-readable description of the condition type, such as Freight Surcharge, Insurance, Packaging Fee, Cash Discount, or Base Price, derived from the SAP condition type configuration.',
    `validity_end_date` DATE COMMENT 'The date until which the condition record remains valid. After this date the condition will no longer be automatically determined for new billing documents.. Valid values are `^d{4}-d{2}-d{2}$`',
    `validity_start_date` DATE COMMENT 'The date from which the condition record is valid and applicable to billing documents. Used for time-based pricing, seasonal surcharges, and contract-driven condition validity periods.. Valid values are `^d{4}-d{2}-d{2}$`',
    `value` DECIMAL(18,2) COMMENT 'The calculated monetary value of the condition applied to the billing document or line item in the billing transaction currency. Represents the actual amount of the surcharge, discount, freight, or other adjustment.',
    `value_company_currency` DECIMAL(18,2) COMMENT 'The condition value converted to the company code local currency for financial reporting and accounts receivable posting purposes.',
    CONSTRAINT pk_condition PRIMARY KEY(`condition_id`)
) COMMENT 'Pricing and surcharge condition records applied at the billing document level, capturing additional charges, freight costs, insurance, packaging surcharges, and other billing-specific adjustments not captured at the sales order level. Records condition type, condition value or rate, calculation base, currency, validity period, and condition origin (manual entry, automatic determination, contract-driven). Complements order-level pricing conditions with billing-specific adjustments in SAP SD.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` (
    `invoice_service_line_id` BIGINT COMMENT 'Unique surrogate identifier for each invoice service line item record',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to the parent invoice document',
    `it_service_id` BIGINT COMMENT 'Foreign key linking to the IT service being billed',
    `billing_frequency` STRING COMMENT 'The frequency at which this service is billed to the customer: monthly (recurring monthly charge), quarterly (recurring quarterly charge), annual (recurring annual charge), one-time (single charge), or usage-based (variable based on consumption).',
    `line_gross_amount` DECIMAL(18,2) COMMENT 'Total gross amount for this invoice line item including taxes, calculated as line_net_amount + line_tax_amount, expressed in the invoice transaction currency.',
    `line_item_number` STRING COMMENT 'Sequential line item number within the parent invoice, used for ordering and reference on the printed invoice document.',
    `line_net_amount` DECIMAL(18,2) COMMENT 'Total net amount for this invoice line item before taxes, calculated as service_quantity × unit_price, expressed in the invoice transaction currency.',
    `line_tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount applicable to this invoice line item, expressed in the invoice transaction currency.',
    `service_description_override` STRING COMMENT 'Optional customer-facing description of the service for this specific invoice line, overriding the standard service name when a more specific or customized description is needed for billing clarity.',
    `service_period_end` DATE COMMENT 'The end date of the service consumption period being billed on this invoice line. Defines the conclusion of the billing period for this specific service.',
    `service_period_start` DATE COMMENT 'The start date of the service consumption period being billed on this invoice line. Defines the beginning of the billing period for this specific service.',
    `service_quantity` DECIMAL(18,2) COMMENT 'The quantity of service units consumed during the billing period (e.g., number of users, compute hours, storage GB, support tickets). Unit of measure depends on the service cost model.',
    `unit_price` DECIMAL(18,2) COMMENT 'The price per unit of service for this specific invoice line item, expressed in the invoice transaction currency. May differ from the standard service unit cost due to customer-specific pricing agreements or discounts.',
    CONSTRAINT pk_invoice_service_line PRIMARY KEY(`invoice_service_line_id`)
) COMMENT 'This association product represents the line-item relationship between invoices and IT services billed to industrial customers. It captures the specific billing details for each IT service included on an invoice. Each record links one invoice to one IT service with attributes that exist only in the context of this billing relationship, including service consumption period, quantity consumed, unit pricing, and billing frequency.. Existence Justification: In industrial manufacturing billing operations, invoices routinely include multiple IT services (e.g., ERP hosting, MES platform access, SCADA support, device provisioning) as separate line items, each with distinct consumption periods, quantities, and pricing. Conversely, each IT service appears on multiple customer invoices across different billing cycles and customers. The business actively manages invoice line items as operational billing records, tracking service-specific consumption, pricing, and billing periods.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ADD CONSTRAINT `fk_billing_credit_note_billing_payment_term_id` FOREIGN KEY (`billing_payment_term_id`) REFERENCES `manufacturing_ecm`.`billing`.`billing_payment_term`(`billing_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ADD CONSTRAINT `fk_billing_credit_note_type_id` FOREIGN KEY (`type_id`) REFERENCES `manufacturing_ecm`.`billing`.`type`(`type_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_billing_payment_term_id` FOREIGN KEY (`billing_payment_term_id`) REFERENCES `manufacturing_ecm`.`billing`.`billing_payment_term`(`billing_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_type_id` FOREIGN KEY (`type_id`) REFERENCES `manufacturing_ecm`.`billing`.`type`(`type_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ADD CONSTRAINT `fk_billing_payment_receipt_billing_payment_term_id` FOREIGN KEY (`billing_payment_term_id`) REFERENCES `manufacturing_ecm`.`billing`.`billing_payment_term`(`billing_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_payment_receipt_id` FOREIGN KEY (`payment_receipt_id`) REFERENCES `manufacturing_ecm`.`billing`.`payment_receipt`(`payment_receipt_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ADD CONSTRAINT `fk_billing_plan_billing_payment_term_id` FOREIGN KEY (`billing_payment_term_id`) REFERENCES `manufacturing_ecm`.`billing`.`billing_payment_term`(`billing_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ADD CONSTRAINT `fk_billing_plan_performance_obligation_id` FOREIGN KEY (`performance_obligation_id`) REFERENCES `manufacturing_ecm`.`billing`.`performance_obligation`(`performance_obligation_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ADD CONSTRAINT `fk_billing_plan_milestone_billing_payment_term_id` FOREIGN KEY (`billing_payment_term_id`) REFERENCES `manufacturing_ecm`.`billing`.`billing_payment_term`(`billing_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ADD CONSTRAINT `fk_billing_plan_milestone_plan_id` FOREIGN KEY (`plan_id`) REFERENCES `manufacturing_ecm`.`billing`.`plan`(`plan_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ADD CONSTRAINT `fk_billing_plan_milestone_revenue_recognition_event_id` FOREIGN KEY (`revenue_recognition_event_id`) REFERENCES `manufacturing_ecm`.`billing`.`revenue_recognition_event`(`revenue_recognition_event_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ADD CONSTRAINT `fk_billing_revenue_recognition_event_performance_obligation_id` FOREIGN KEY (`performance_obligation_id`) REFERENCES `manufacturing_ecm`.`billing`.`performance_obligation`(`performance_obligation_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ADD CONSTRAINT `fk_billing_invoice_dispute_credit_note_id` FOREIGN KEY (`credit_note_id`) REFERENCES `manufacturing_ecm`.`billing`.`credit_note`(`credit_note_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ADD CONSTRAINT `fk_billing_run_type_id` FOREIGN KEY (`type_id`) REFERENCES `manufacturing_ecm`.`billing`.`type`(`type_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ADD CONSTRAINT `fk_billing_proforma_invoice_billing_payment_term_id` FOREIGN KEY (`billing_payment_term_id`) REFERENCES `manufacturing_ecm`.`billing`.`billing_payment_term`(`billing_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ADD CONSTRAINT `fk_billing_proforma_invoice_type_id` FOREIGN KEY (`type_id`) REFERENCES `manufacturing_ecm`.`billing`.`type`(`type_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`billing` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `manufacturing_ecm`.`billing` SET TAGS ('dbx_domain' = 'billing');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` SET TAGS ('dbx_subdomain' = 'invoice_management');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `invoice_line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Line Item ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `batch_id` SET TAGS ('dbx_business_glossary_term' = 'Batch Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `certificate_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Certificate Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `contract_line_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Line Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `contractor_qualification_id` SET TAGS ('dbx_business_glossary_term' = 'Contractor Qualification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `engineering_prototype_id` SET TAGS ('dbx_business_glossary_term' = 'Prototype Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `environmental_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Environmental Permit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `field_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Field Service Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `installation_record_id` SET TAGS ('dbx_business_glossary_term' = 'Installation Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `lot_batch_id` SET TAGS ('dbx_business_glossary_term' = 'Lot Batch Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `procurement_po_line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Po Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `safety_training_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Training Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `serialized_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Serialized Unit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `shipment_item_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `software_license_id` SET TAGS ('dbx_business_glossary_term' = 'Software License Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `spare_part_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `spare_parts_request_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Request Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `tooling_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Tooling Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `waste_record_id` SET TAGS ('dbx_business_glossary_term' = 'Waste Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_business_glossary_term' = 'Account Assignment Category');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_value_regex' = 'cost_center|project|asset|order|profit_center|not_assigned');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `billed_quantity` SET TAGS ('dbx_business_glossary_term' = 'Billed Quantity');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `billing_currency` SET TAGS ('dbx_business_glossary_term' = 'Billing Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `billing_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `billing_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `billing_item_category` SET TAGS ('dbx_business_glossary_term' = 'Billing Item Category');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `billing_item_category` SET TAGS ('dbx_value_regex' = 'TAN|TAD|TAX|TAB|TANN|REN|G2N|L2N|KLN|KAN');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `cogs_amount` SET TAGS ('dbx_business_glossary_term' = 'Cost of Goods Sold (COGS) Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `cogs_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `company_code_currency` SET TAGS ('dbx_business_glossary_term' = 'Company Code Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `company_code_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `delivery_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Document Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `discount_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `goods_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `gross_line_value` SET TAGS ('dbx_business_glossary_term' = 'Gross Line Value');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `gross_line_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `gross_margin_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Margin Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `gross_margin_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `line_item_number` SET TAGS ('dbx_business_glossary_term' = 'Line Item Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `line_item_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `line_item_status` SET TAGS ('dbx_business_glossary_term' = 'Line Item Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `line_item_status` SET TAGS ('dbx_value_regex' = 'open|cleared|partially_cleared|cancelled|reversed|blocked');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `net_line_value` SET TAGS ('dbx_business_glossary_term' = 'Net Line Value');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `net_line_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `net_line_value_company_currency` SET TAGS ('dbx_business_glossary_term' = 'Net Line Value in Company Code Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `net_line_value_company_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `plant` SET TAGS ('dbx_business_glossary_term' = 'Plant');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `revenue_recognition_date` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `revenue_recognition_method` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Method');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `revenue_recognition_method` SET TAGS ('dbx_value_regex' = 'point_in_time|over_time|milestone|percentage_of_completion|not_applicable');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `sales_order_line_item` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Line Item Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `service_rendered_date` SET TAGS ('dbx_business_glossary_term' = 'Service Rendered Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `tax_rate` SET TAGS ('dbx_business_glossary_term' = 'Tax Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Unit Price');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` SET TAGS ('dbx_subdomain' = 'invoice_management');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `credit_note_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Note ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `approved_by_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `ar_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ar Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `address_id` SET TAGS ('dbx_business_glossary_term' = 'Bill To Address Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `address_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `address_id` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Original Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `billing_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver User ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `ncr_id` SET TAGS ('dbx_business_glossary_term' = 'Ncr Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `product_return_id` SET TAGS ('dbx_business_glossary_term' = 'Product Return Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `returns_order_id` SET TAGS ('dbx_business_glossary_term' = 'Returns Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `stock_adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Adjustment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `type_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Type Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `warranty_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `approval_limit_amount` SET TAGS ('dbx_business_glossary_term' = 'Approval Limit Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'NOT_REQUIRED|PENDING|APPROVED|REJECTED|ESCALATED');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `billing_company_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `billing_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `billing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `credit_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Credit Reason Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `credit_reason_code` SET TAGS ('dbx_value_regex' = 'PRICE_CORRECTION|QUALITY_DEFECT|GOODS_RETURN|GOODWILL|OVERBILLING|DUPLICATE_INVOICE|CONTRACT_ADJUSTMENT|QUANTITY_DISPUTE|FREIGHT_DISPUTE|OTHER');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `credit_reason_description` SET TAGS ('dbx_business_glossary_term' = 'Credit Reason Description');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Document Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `document_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Credit Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `gross_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Credit Note Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Credit Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `net_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `net_amount_company_currency` SET TAGS ('dbx_business_glossary_term' = 'Net Amount in Company Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `net_amount_company_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Credit Note Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^CR[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `reference_invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Invoice Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|LEGACY_ERP|MANUAL');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Credit Note Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'DRAFT|PENDING_APPROVAL|APPROVED|REJECTED|POSTED|CANCELLED|REVERSED');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ALTER COLUMN `tax_jurisdiction_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Jurisdiction Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` SET TAGS ('dbx_subdomain' = 'invoice_management');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `debit_note_id` SET TAGS ('dbx_business_glossary_term' = 'Debit Note ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Original Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `billing_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `supplier_quality_event_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Quality Event Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `type_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Type Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `accounting_status` SET TAGS ('dbx_business_glossary_term' = 'Accounting Posting Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `accounting_status` SET TAGS ('dbx_value_regex' = 'NOT_POSTED|POSTED|CLEARED|PARTIALLY_CLEARED|ERROR');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'PENDING|APPROVED|REJECTED|CANCELLED|ON_HOLD');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `billing_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `billing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `billing_status` SET TAGS ('dbx_business_glossary_term' = 'Billing Document Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `billing_status` SET TAGS ('dbx_value_regex' = 'DRAFT|RELEASED|CANCELLED|REVERSED');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Document Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `dispute_case_number` SET TAGS ('dbx_business_glossary_term' = 'Dispute Case Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `dunning_block` SET TAGS ('dbx_business_glossary_term' = 'Dunning Block Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `dunning_block` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-6])$');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Debit Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `gross_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Local Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `local_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Debit Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `net_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `net_amount_local_currency` SET TAGS ('dbx_business_glossary_term' = 'Net Amount in Local Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `net_amount_local_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Debit Note Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^DR[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `payer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Payer Account Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `payer_account_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `reason_code` SET TAGS ('dbx_business_glossary_term' = 'Debit Reason Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `reason_code` SET TAGS ('dbx_value_regex' = 'PRICE_ADJ|SURCHARGE|PENALTY|ENG_CHANGE|TOOLING|RETROACTIVE|FREIGHT|TAX_ADJ|OTHER');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `reason_description` SET TAGS ('dbx_business_glossary_term' = 'Debit Reason Description');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `reference_invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Invoice Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `request_number` SET TAGS ('dbx_business_glossary_term' = 'Debit Note Request Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` SET TAGS ('dbx_subdomain' = 'payment_collections');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `payment_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Receipt ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Identifier');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `billing_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `payment_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `procurement_supplier_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `amount_in_company_currency` SET TAGS ('dbx_business_glossary_term' = 'Payment Amount in Company Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `amount_in_company_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `amount_in_company_currency` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `applied_amount` SET TAGS ('dbx_business_glossary_term' = 'Applied Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `applied_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `applied_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `bank_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Bank Reference Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `business_area` SET TAGS ('dbx_business_glossary_term' = 'Business Area');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_business_glossary_term' = 'Clearing Document Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Company Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `discount_taken_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Taken Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `discount_taken_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `discount_taken_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-6])$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `is_partial_payment` SET TAGS ('dbx_business_glossary_term' = 'Partial Payment Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `is_partial_payment` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Payment Receipt Notes');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `outstanding_balance` SET TAGS ('dbx_business_glossary_term' = 'Outstanding Balance After Application');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `outstanding_balance` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `outstanding_balance` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `payment_channel` SET TAGS ('dbx_business_glossary_term' = 'Payment Channel');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `payment_channel` SET TAGS ('dbx_value_regex' = 'bank_portal|edi|manual_entry|customer_portal|lockbox|swift|sepa');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `payment_type` SET TAGS ('dbx_business_glossary_term' = 'Payment Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `payment_type` SET TAGS ('dbx_value_regex' = 'full|partial|advance|overpayment|prepayment');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `receipt_number` SET TAGS ('dbx_business_glossary_term' = 'Payment Receipt Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `receipt_number` SET TAGS ('dbx_value_regex' = '^PR-[0-9]{4}-[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `remittance_reference` SET TAGS ('dbx_business_glossary_term' = 'Remittance Reference');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `reversal_date` SET TAGS ('dbx_business_glossary_term' = 'Reversal Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `reversal_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `reversal_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `reversal_reason_code` SET TAGS ('dbx_value_regex' = 'returned_check|failed_ach|duplicate_payment|incorrect_amount|customer_dispute|bank_error|other');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE|MANUAL|BANK_FEED|EDI|LOCKBOX');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Payment Receipt Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'received|posted|cleared|partially_applied|unapplied|reversed|on_hold|cancelled');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `tax_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `value_date` SET TAGS ('dbx_business_glossary_term' = 'Value Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `value_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` SET TAGS ('dbx_subdomain' = 'payment_collections');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `payment_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Allocation ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Bank Transaction ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `payment_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Receipt Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `allocated_amount` SET TAGS ('dbx_business_glossary_term' = 'Allocated Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `allocated_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `allocated_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `allocated_amount_base_currency` SET TAGS ('dbx_business_glossary_term' = 'Allocated Amount in Base Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `allocated_amount_base_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `allocated_amount_base_currency` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `allocation_date` SET TAGS ('dbx_business_glossary_term' = 'Allocation Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `allocation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `allocation_number` SET TAGS ('dbx_business_glossary_term' = 'Payment Allocation Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `allocation_number` SET TAGS ('dbx_value_regex' = '^ALLOC-[0-9]{4}-[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `allocation_type` SET TAGS ('dbx_business_glossary_term' = 'Allocation Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `allocation_type` SET TAGS ('dbx_value_regex' = 'full_clearance|partial_payment|on_account|advance_payment|credit_note_offset|debit_note_offset|write_off|discount_clearance');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `base_currency` SET TAGS ('dbx_business_glossary_term' = 'Base Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `base_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_business_glossary_term' = 'Clearing Document Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Early Payment Discount Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `discount_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `discount_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Early Payment Discount Percentage');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `discount_taken_flag` SET TAGS ('dbx_business_glossary_term' = 'Discount Taken Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `discount_taken_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `dispute_case_number` SET TAGS ('dbx_business_glossary_term' = 'Dispute Case Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-6])$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Allocation Notes');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'bank_transfer|wire_transfer|check|ach|direct_debit|letter_of_credit|credit_card|netting|offset');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `payment_reference` SET TAGS ('dbx_business_glossary_term' = 'Payment Reference');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `residual_amount` SET TAGS ('dbx_business_glossary_term' = 'Residual Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `residual_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `residual_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `reversal_date` SET TAGS ('dbx_business_glossary_term' = 'Reversal Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `reversal_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `reversal_flag` SET TAGS ('dbx_business_glossary_term' = 'Reversal Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `reversal_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `reversal_reason` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `reversal_reason` SET TAGS ('dbx_value_regex' = 'returned_payment|incorrect_posting|duplicate_payment|customer_dispute|bank_chargeback|other');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL|LEGACY');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Allocation Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending|posted|cleared|reversed|disputed|on_account|partially_cleared');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `tax_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `transaction_currency` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `transaction_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `value_date` SET TAGS ('dbx_business_glossary_term' = 'Value Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `value_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` SET TAGS ('dbx_subdomain' = 'revenue_recognition');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` SET TAGS ('dbx_original_name' = 'billing_plan');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `plan_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Plan ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `billing_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `performance_obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Performance Obligation ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `sales_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `sla_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|revision_required');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `billed_amount` SET TAGS ('dbx_business_glossary_term' = 'Billed Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `billed_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `billing_block_reason` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Reason');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `billing_block_reason` SET TAGS ('dbx_value_regex' = 'none|credit_hold|pending_approval|milestone_incomplete|dispute|legal_hold|contract_amendment');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_business_glossary_term' = 'Billing Frequency');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_value_regex' = 'one_time|weekly|biweekly|monthly|quarterly|semi_annual|annual|milestone_driven|on_demand');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `billing_rule` SET TAGS ('dbx_business_glossary_term' = 'Billing Rule');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `billing_rule` SET TAGS ('dbx_value_regex' = 'fixed_amount|percentage_of_contract|percentage_of_completion|time_and_material|unit_price|cost_plus');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `contract_type` SET TAGS ('dbx_business_glossary_term' = 'Contract Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `contract_type` SET TAGS ('dbx_value_regex' = 'eto|mto|mts|ato|service|maintenance|framework');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `contract_value` SET TAGS ('dbx_business_glossary_term' = 'Contract Value');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `contract_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Billing Plan Description');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `down_payment_amount` SET TAGS ('dbx_business_glossary_term' = 'Down Payment Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `down_payment_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `down_payment_percentage` SET TAGS ('dbx_business_glossary_term' = 'Down Payment Percentage');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `down_payment_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Plan End Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `is_billing_blocked` SET TAGS ('dbx_business_glossary_term' = 'Billing Blocked Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `is_billing_blocked` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Billing Plan Name');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `next_billing_date` SET TAGS ('dbx_business_glossary_term' = 'Next Billing Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `next_billing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Billing Plan Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^BP-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'bank_transfer|check|letter_of_credit|direct_debit|wire_transfer|escrow');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `retention_percentage` SET TAGS ('dbx_business_glossary_term' = 'Retention Percentage');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `retention_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `retention_release_date` SET TAGS ('dbx_business_glossary_term' = 'Retention Release Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `retention_release_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `revenue_recognition_method` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Method');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `revenue_recognition_method` SET TAGS ('dbx_value_regex' = 'point_in_time|over_time_percentage_completion|over_time_input_method|over_time_output_method');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL|LEGACY');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Plan Start Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Billing Plan Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|on_hold|partially_billed|fully_billed|cancelled|closed');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `tax_classification` SET TAGS ('dbx_business_glossary_term' = 'Tax Classification');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `tax_classification` SET TAGS ('dbx_value_regex' = 'taxable|exempt|zero_rated|reverse_charge|out_of_scope');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `total_plan_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Billing Plan Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `total_plan_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Billing Plan Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'milestone|periodic|partial_invoice|down_payment|progress_billing|advance_payment');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `unbilled_amount` SET TAGS ('dbx_business_glossary_term' = 'Unbilled Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ALTER COLUMN `unbilled_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` SET TAGS ('dbx_subdomain' = 'revenue_recognition');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` SET TAGS ('dbx_original_name' = 'billing_plan_milestone');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `plan_milestone_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Plan Milestone ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `billing_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `it_project_milestone_id` SET TAGS ('dbx_business_glossary_term' = 'It Project Milestone Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `plan_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `rd_milestone_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Milestone Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `revenue_recognition_event_id` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Event Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `actual_billing_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Billing Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `actual_billing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `amount_in_company_currency` SET TAGS ('dbx_business_glossary_term' = 'Milestone Amount in Company Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `amount_in_company_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `billed_amount` SET TAGS ('dbx_business_glossary_term' = 'Billed Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `billed_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `billing_block_reason` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Reason');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `billing_block_reason` SET TAGS ('dbx_value_regex' = 'credit_limit_exceeded|dispute_open|approval_pending|contract_amendment|quality_hold|customer_request|legal_review|none');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `billing_category` SET TAGS ('dbx_business_glossary_term' = 'Billing Category');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `billing_category` SET TAGS ('dbx_value_regex' = 'advance_payment|progress_payment|delivery_payment|acceptance_payment|retention_release|final_payment');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `billing_rule` SET TAGS ('dbx_business_glossary_term' = 'Billing Rule');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `billing_rule` SET TAGS ('dbx_value_regex' = 'fixed_date|milestone_event|percentage_completion|time_and_material|advance_payment|retention_release');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Company Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `completion_confirmed` SET TAGS ('dbx_business_glossary_term' = 'Completion Confirmation Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `completion_confirmed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `completion_date` SET TAGS ('dbx_business_glossary_term' = 'Milestone Completion Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `completion_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Milestone Description');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `invoice_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `milestone_amount` SET TAGS ('dbx_business_glossary_term' = 'Milestone Billing Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `milestone_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `milestone_number` SET TAGS ('dbx_business_glossary_term' = 'Milestone Sequence Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `milestone_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `milestone_percentage` SET TAGS ('dbx_business_glossary_term' = 'Milestone Billing Percentage');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `milestone_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,4})?|d{1,2}(.d{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `net_billing_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Billing Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `net_billing_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `planned_billing_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Billing Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `planned_billing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `project_milestone_reference` SET TAGS ('dbx_business_glossary_term' = 'Project Milestone Reference');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `retention_amount` SET TAGS ('dbx_business_glossary_term' = 'Retention Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `retention_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `retention_percentage` SET TAGS ('dbx_business_glossary_term' = 'Retention Percentage');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `retention_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,4})?|d{1,2}(.d{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `revenue_recognition_date` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `revenue_recognition_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL|LEGACY');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Milestone Billing Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|partially_billed|fully_billed|blocked|cancelled|on_hold');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `unbilled_amount` SET TAGS ('dbx_business_glossary_term' = 'Unbilled Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `unbilled_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` SET TAGS ('dbx_subdomain' = 'revenue_recognition');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `revenue_recognition_event_id` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Event ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Document Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `it_project_id` SET TAGS ('dbx_business_glossary_term' = 'It Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `performance_obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Performance Obligation ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `accounting_period` SET TAGS ('dbx_business_glossary_term' = 'Accounting Period');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `accounting_period` SET TAGS ('dbx_value_regex' = '^d{4}-(0[1-9]|1[0-2])$');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Company Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `contract_asset_balance` SET TAGS ('dbx_business_glossary_term' = 'Contract Asset Balance');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `contract_asset_balance` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `contract_liability_balance` SET TAGS ('dbx_business_glossary_term' = 'Contract Liability Balance');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `contract_liability_balance` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `customer_acceptance_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Acceptance Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `customer_acceptance_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `deferred_revenue_amount` SET TAGS ('dbx_business_glossary_term' = 'Deferred Revenue Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `deferred_revenue_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `event_number` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Event Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `event_number` SET TAGS ('dbx_value_regex' = '^RRE-[0-9]{4}-[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `event_type` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Event Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `event_type` SET TAGS ('dbx_value_regex' = 'goods_delivery|customer_acceptance|milestone_sign_off|percentage_of_completion|software_activation|service_rendered|subscription_period|bill_and_hold|usage_based');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `group_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Group Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `group_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Revenue Recognition Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `milestone_reference` SET TAGS ('dbx_business_glossary_term' = 'Milestone Reference');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `percentage_of_completion` SET TAGS ('dbx_business_glossary_term' = 'Percentage of Completion');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `percentage_of_completion` SET TAGS ('dbx_value_regex' = '^(100(.00?)?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `performance_obligation_description` SET TAGS ('dbx_business_glossary_term' = 'Performance Obligation Description');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `recognition_date` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `recognition_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `recognition_method` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Method');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `recognition_method` SET TAGS ('dbx_value_regex' = 'point_in_time|over_time');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `recognized_amount` SET TAGS ('dbx_business_glossary_term' = 'Recognized Revenue Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `recognized_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `recognized_amount_company_currency` SET TAGS ('dbx_business_glossary_term' = 'Recognized Revenue Amount in Company Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `recognized_amount_company_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `recognized_amount_group_currency` SET TAGS ('dbx_business_glossary_term' = 'Recognized Revenue Amount in Group Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `recognized_amount_group_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `reversal_date` SET TAGS ('dbx_business_glossary_term' = 'Reversal Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `reversal_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `reversal_reason` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `reversal_reason` SET TAGS ('dbx_value_regex' = 'contract_modification|customer_return|billing_error|period_correction|cancellation|other');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_RAR|SAP_SD|SAP_FI|MANUAL|MIGRATION');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Event Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_review|approved|posted|reversed|cancelled');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `transaction_price_allocated` SET TAGS ('dbx_business_glossary_term' = 'Allocated Transaction Price');
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ALTER COLUMN `transaction_price_allocated` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` SET TAGS ('dbx_subdomain' = 'revenue_recognition');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `performance_obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Performance Obligation ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Completion Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `allocated_price_company_currency` SET TAGS ('dbx_business_glossary_term' = 'Allocated Transaction Price in Company Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `allocated_price_company_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `allocated_transaction_price` SET TAGS ('dbx_business_glossary_term' = 'Allocated Transaction Price');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `allocated_transaction_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `billing_company_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Company Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `completion_percentage` SET TAGS ('dbx_business_glossary_term' = 'Completion Percentage');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `completion_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `contract_modification_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Modification Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `contract_modification_number` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Performance Obligation Description');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `expected_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Expected Completion Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `expected_completion_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `is_distinct` SET TAGS ('dbx_business_glossary_term' = 'Is Distinct Performance Obligation');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `is_distinct` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `is_financing_component` SET TAGS ('dbx_business_glossary_term' = 'Is Significant Financing Component');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `is_financing_component` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `is_variable_consideration` SET TAGS ('dbx_business_glossary_term' = 'Is Variable Consideration');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `is_variable_consideration` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `last_recognition_date` SET TAGS ('dbx_business_glossary_term' = 'Last Revenue Recognition Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `last_recognition_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `modification_type` SET TAGS ('dbx_business_glossary_term' = 'Contract Modification Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `modification_type` SET TAGS ('dbx_value_regex' = 'original|prospective_modification|cumulative_catch_up|termination|not_applicable');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `obligation_number` SET TAGS ('dbx_business_glossary_term' = 'Performance Obligation Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `obligation_number` SET TAGS ('dbx_value_regex' = '^PO-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `obligation_type` SET TAGS ('dbx_business_glossary_term' = 'Performance Obligation Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `obligation_type` SET TAGS ('dbx_value_regex' = 'equipment_supply|installation|commissioning|software_license|maintenance_service|aftermarket_service|training|engineering_service|spare_parts_supply|warranty_service|other');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `over_time_recognition_method` SET TAGS ('dbx_business_glossary_term' = 'Over-Time Revenue Recognition Method');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `over_time_recognition_method` SET TAGS ('dbx_value_regex' = 'output_method|input_method_cost|input_method_effort|milestone_based|straight_line|units_delivered|not_applicable');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `recognized_revenue_amount` SET TAGS ('dbx_business_glossary_term' = 'Recognized Revenue Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `recognized_revenue_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `remaining_obligation_amount` SET TAGS ('dbx_business_glossary_term' = 'Remaining Obligation Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `remaining_obligation_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `revenue_recognition_standard` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Standard');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `revenue_recognition_standard` SET TAGS ('dbx_value_regex' = 'IFRS_15|ASC_606|both');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `sales_order_number` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `satisfaction_method` SET TAGS ('dbx_business_glossary_term' = 'Satisfaction Method');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `satisfaction_method` SET TAGS ('dbx_value_regex' = 'point_in_time|over_time');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `ssp_estimation_method` SET TAGS ('dbx_business_glossary_term' = 'Standalone Selling Price (SSP) Estimation Method');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `ssp_estimation_method` SET TAGS ('dbx_value_regex' = 'observable_price|adjusted_market_assessment|expected_cost_plus_margin|residual_approach|not_applicable');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `standalone_selling_price` SET TAGS ('dbx_business_glossary_term' = 'Standalone Selling Price (SSP)');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `standalone_selling_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Obligation Start Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Performance Obligation Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|partially_satisfied|fully_satisfied|cancelled|suspended|modified');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `tax_treatment_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Treatment Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `variable_consideration_amount` SET TAGS ('dbx_business_glossary_term' = 'Variable Consideration Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ALTER COLUMN `variable_consideration_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` SET TAGS ('dbx_subdomain' = 'payment_collections');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_record_id` SET TAGS ('dbx_business_glossary_term' = 'Dunning Record ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `collections_officer` SET TAGS ('dbx_business_glossary_term' = 'Collections Officer');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Company Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `credit_risk_category` SET TAGS ('dbx_business_glossary_term' = 'Credit Risk Category');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `credit_risk_category` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical|write_off_candidate');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `credit_risk_category` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `customer_response_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Response Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `customer_response_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `customer_response_status` SET TAGS ('dbx_business_glossary_term' = 'Customer Response Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `customer_response_status` SET TAGS ('dbx_value_regex' = 'no_response|acknowledged|disputed|payment_promised|partial_payment|paid_in_full|payment_arrangement|referred_to_legal');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `days_overdue` SET TAGS ('dbx_business_glossary_term' = 'Days Overdue');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `days_overdue` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_amount` SET TAGS ('dbx_business_glossary_term' = 'Dunning Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_amount_company_currency` SET TAGS ('dbx_business_glossary_term' = 'Dunning Amount in Company Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_amount_company_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_area` SET TAGS ('dbx_business_glossary_term' = 'Dunning Area');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_block_reason` SET TAGS ('dbx_business_glossary_term' = 'Dunning Block Reason');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_block_reason` SET TAGS ('dbx_value_regex' = 'payment_arrangement|dispute_in_progress|credit_review|customer_request|legal_hold|write_off_pending|other');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Dunning Charge Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_charge_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_date` SET TAGS ('dbx_business_glossary_term' = 'Dunning Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_interest_amount` SET TAGS ('dbx_business_glossary_term' = 'Dunning Interest Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_interest_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_level` SET TAGS ('dbx_business_glossary_term' = 'Dunning Level');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_level` SET TAGS ('dbx_value_regex' = '^[1-9]$');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_level_description` SET TAGS ('dbx_business_glossary_term' = 'Dunning Level Description');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_level_description` SET TAGS ('dbx_value_regex' = '1st Reminder|2nd Reminder|Final Notice|Legal Action|Pre-Legal Notice|Debt Collection Agency');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_notice_number` SET TAGS ('dbx_business_glossary_term' = 'Dunning Notice Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_notice_number` SET TAGS ('dbx_value_regex' = '^DN-[0-9]{4}-[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_notice_sent_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Dunning Notice Sent Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_notice_sent_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_notice_sent_via` SET TAGS ('dbx_business_glossary_term' = 'Dunning Notice Delivery Channel');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_notice_sent_via` SET TAGS ('dbx_value_regex' = 'email|postal_mail|fax|edi|portal|phone|in_person');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `dunning_procedure` SET TAGS ('dbx_business_glossary_term' = 'Dunning Procedure');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `escalation_date` SET TAGS ('dbx_business_glossary_term' = 'Escalation Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `escalation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `invoice_due_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Due Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `invoice_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `is_dunning_blocked` SET TAGS ('dbx_business_glossary_term' = 'Dunning Block Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `is_dunning_blocked` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `is_escalated` SET TAGS ('dbx_business_glossary_term' = 'Escalation Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `is_escalated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `is_legal_action_initiated` SET TAGS ('dbx_business_glossary_term' = 'Legal Action Initiated Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `is_legal_action_initiated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `last_dunning_run_date` SET TAGS ('dbx_business_glossary_term' = 'Last Dunning Run Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `last_dunning_run_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `next_dunning_date` SET TAGS ('dbx_business_glossary_term' = 'Next Dunning Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `next_dunning_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `promised_payment_amount` SET TAGS ('dbx_business_glossary_term' = 'Promised Payment Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `promised_payment_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `promised_payment_date` SET TAGS ('dbx_business_glossary_term' = 'Promised Payment Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `promised_payment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_FI_AR|SALESFORCE_CRM|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Dunning Record Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|sent|responded|paid|escalated|blocked|cancelled|legal_action|closed');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `write_off_flag` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ALTER COLUMN `write_off_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` SET TAGS ('dbx_subdomain' = 'revenue_recognition');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_determination_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Determination ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Document Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_code_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `billing_document_line_item` SET TAGS ('dbx_business_glossary_term' = 'Billing Document Line Item');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Company Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `customer_tax_classification` SET TAGS ('dbx_business_glossary_term' = 'Customer Tax Classification');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `customer_vat_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Customer VAT Registration Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `customer_vat_registration_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `date` SET TAGS ('dbx_business_glossary_term' = 'Tax Determination Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `determination_method` SET TAGS ('dbx_business_glossary_term' = 'Tax Determination Method');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `determination_method` SET TAGS ('dbx_value_regex' = 'automatic|manual_override|external_engine|default_fallback');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `exemption_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Tax Exemption Certificate Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `exemption_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Exemption Reason Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `external_tax_engine` SET TAGS ('dbx_business_glossary_term' = 'External Tax Engine');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `external_tax_engine` SET TAGS ('dbx_value_regex' = 'vertex|avalara|thomson_reuters_onesource|sap_native|other|none');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `is_reverse_charge` SET TAGS ('dbx_business_glossary_term' = 'Reverse Charge Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `is_reverse_charge` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `is_tax_exempt` SET TAGS ('dbx_business_glossary_term' = 'Tax Exemption Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `is_tax_exempt` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `material_tax_classification` SET TAGS ('dbx_business_glossary_term' = 'Material Tax Classification');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `place_of_supply_code` SET TAGS ('dbx_business_glossary_term' = 'Place of Supply Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `place_of_supply_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `sales_order_number` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `ship_from_country_code` SET TAGS ('dbx_business_glossary_term' = 'Ship From Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `ship_from_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `ship_to_country_code` SET TAGS ('dbx_business_glossary_term' = 'Ship To Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `ship_to_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Tax Determination Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'determined|posted|reversed|cancelled|error|pending_review');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `supplier_vat_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier VAT Registration Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `supplier_vat_registration_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_amount_company_currency` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount in Company Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_base_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Base Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_base_amount_company_currency` SET TAGS ('dbx_business_glossary_term' = 'Tax Base Amount in Company Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_category` SET TAGS ('dbx_business_glossary_term' = 'Tax Category');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_category` SET TAGS ('dbx_value_regex' = 'standard|reduced|zero_rated|exempt|reverse_charge|out_of_scope|not_applicable');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_condition_type` SET TAGS ('dbx_business_glossary_term' = 'Tax Condition Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_country_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Tax Invoice Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_jurisdiction_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Jurisdiction Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_procedure_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Procedure Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_reporting_category` SET TAGS ('dbx_business_glossary_term' = 'Tax Reporting Category');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_type` SET TAGS ('dbx_business_glossary_term' = 'Tax Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `tax_type` SET TAGS ('dbx_value_regex' = 'output_vat|input_vat|gst|sales_tax|use_tax|withholding_tax|excise_duty|customs_duty|service_tax|digital_services_tax|other');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax (WHT) Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `withholding_tax_base_amount` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax (WHT) Base Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ALTER COLUMN `withholding_tax_code` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax (WHT) Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` SET TAGS ('dbx_subdomain' = 'invoice_management');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `intercompany_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Invoice ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `intercompany_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Transaction Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `it_service_id` SET TAGS ('dbx_business_glossary_term' = 'It Service Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `billing_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `billing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `buying_company_code` SET TAGS ('dbx_business_glossary_term' = 'Buying Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `buying_company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `buying_country_code` SET TAGS ('dbx_business_glossary_term' = 'Buying Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `buying_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `buying_plant` SET TAGS ('dbx_business_glossary_term' = 'Buying Plant');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `buying_plant` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `document_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Document Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `document_type` SET TAGS ('dbx_value_regex' = 'IV|IG|RE|RG|ZICR|ZICD');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-6])$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_value_regex' = '^[0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Invoice Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Invoice Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `invoice_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,35}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `is_profit_elimination_required` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Profit Elimination Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `is_profit_elimination_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `markup_percentage` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Markup Percentage');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `markup_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Invoice Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `net_amount_selling_currency` SET TAGS ('dbx_business_glossary_term' = 'Net Amount in Selling Company Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `net_amount_selling_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `netting_indicator` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Netting Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `netting_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `pricing_procedure` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Pricing Procedure');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `pricing_procedure` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `profit_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Reconciliation Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_value_regex' = 'pending|matched|partially_matched|disputed|reconciled|written_off');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `reference_purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `reference_purchase_order_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,35}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `reference_sales_order_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Sales Order Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `reference_sales_order_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,35}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `selling_company_code` SET TAGS ('dbx_business_glossary_term' = 'Selling Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `selling_company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `selling_company_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Selling Company Local Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `selling_company_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `selling_country_code` SET TAGS ('dbx_business_glossary_term' = 'Selling Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `selling_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `selling_plant` SET TAGS ('dbx_business_glossary_term' = 'Selling Plant');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `selling_plant` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ECC|MANUAL');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Invoice Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|posted|cancelled|reversed|under_review|reconciled|disputed');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `tax_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `tax_jurisdiction_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Jurisdiction Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `transfer_price` SET TAGS ('dbx_business_glossary_term' = 'Transfer Price');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `transfer_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `transfer_type` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Transfer Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ALTER COLUMN `transfer_type` SET TAGS ('dbx_value_regex' = 'goods_transfer|service_charge|royalty|management_fee|cost_recharge|loan_interest|asset_transfer');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` SET TAGS ('dbx_subdomain' = 'invoice_management');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` SET TAGS ('dbx_original_name' = 'billing_block');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `billing_block_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Block ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Applied By User ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `released_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Released By User ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `applied_by_department` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Applied By Department');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `applied_by_name` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Applied By Name');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `applied_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Applied Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `applied_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `applied_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Applied Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `applied_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `blocked_invoice_amount` SET TAGS ('dbx_business_glossary_term' = 'Blocked Invoice Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `blocked_invoice_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `blocked_invoice_currency` SET TAGS ('dbx_business_glossary_term' = 'Blocked Invoice Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `blocked_invoice_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `credit_control_area` SET TAGS ('dbx_business_glossary_term' = 'Credit Control Area Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `credit_control_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `dispute_case_number` SET TAGS ('dbx_business_glossary_term' = 'Dispute Case Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = '^[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `escalation_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Escalation Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `escalation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `escalation_level` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Escalation Level');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `escalation_level` SET TAGS ('dbx_value_regex' = 'none|level_1|level_2|level_3|executive');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `expected_release_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Expected Release Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `expected_release_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `export_control_case_number` SET TAGS ('dbx_business_glossary_term' = 'Export Control Case Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `hold_duration_days` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Hold Duration Days');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `hold_duration_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `is_automatic_block` SET TAGS ('dbx_business_glossary_term' = 'Is Automatic Billing Block Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `is_automatic_block` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_business_glossary_term' = 'Is Intercompany Billing Block Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `max_hold_duration_days` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Maximum Hold Duration Days');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `max_hold_duration_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `ncr_number` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Report (NCR) Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^BB-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `object_number` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Object Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `object_type` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Object Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `object_type` SET TAGS ('dbx_value_regex' = 'sales_order|delivery|customer_account|contract|billing_document');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `payer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Payer Account Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `payer_account_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `payer_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `payer_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `reason_category` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Reason Category');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `reason_category` SET TAGS ('dbx_value_regex' = 'credit|data_quality|pricing|export_control|quality|legal|tax|contract|management_approval|other');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `reason_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Reason Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `reason_code` SET TAGS ('dbx_value_regex' = '01|02|03|04|05|06|07|08|09|10');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `reason_description` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Reason Description');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `release_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Release Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `release_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `release_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Release Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `release_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `released_by_name` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Released By Name');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `resolution_notes` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Resolution Notes');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `sales_organization` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|SIEMENS_OPCENTER|MANUAL');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|released|cancelled|expired');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` SET TAGS ('dbx_subdomain' = 'invoice_management');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `invoice_dispute_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Dispute ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `assigned_to_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned To Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `credit_note_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Note Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned To User ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `exception_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Exception Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `quality_notification_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Notification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `service_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Service Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `billing_country_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `billing_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Company Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `customer_communication_channel` SET TAGS ('dbx_business_glossary_term' = 'Customer Communication Channel');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `customer_communication_channel` SET TAGS ('dbx_value_regex' = 'EMAIL|PHONE|PORTAL|FAX|MAIL|IN_PERSON');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `days_open` SET TAGS ('dbx_business_glossary_term' = 'Days Open');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `days_open` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `dispute_case_number` SET TAGS ('dbx_business_glossary_term' = 'Dispute Case Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `dispute_case_number` SET TAGS ('dbx_value_regex' = '^DISP-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `dispute_owner_team` SET TAGS ('dbx_business_glossary_term' = 'Dispute Owner Team');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `dispute_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `dispute_reason_code` SET TAGS ('dbx_value_regex' = 'PRICE_DISCREPANCY|QUANTITY_MISMATCH|QUALITY_ISSUE|DELIVERY_SHORTFALL|DUPLICATE_INVOICE|CONTRACT_NON_COMPLIANCE|TAX_ERROR|UNAUTHORIZED_CHARGE|OTHER');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `dispute_reason_description` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason Description');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `disputed_amount` SET TAGS ('dbx_business_glossary_term' = 'Disputed Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `disputed_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `disputed_amount_company_currency` SET TAGS ('dbx_business_glossary_term' = 'Disputed Amount in Company Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `disputed_amount_company_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `escalation_date` SET TAGS ('dbx_business_glossary_term' = 'Escalation Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `escalation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `is_escalated` SET TAGS ('dbx_business_glossary_term' = 'Is Escalated Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `is_escalated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_business_glossary_term' = 'Is Intercompany Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `open_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Open Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `open_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Dispute Priority');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'LOW|MEDIUM|HIGH|CRITICAL');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `resolution_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `resolution_target_date` SET TAGS ('dbx_business_glossary_term' = 'Resolution Target Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `resolution_target_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `resolution_type` SET TAGS ('dbx_business_glossary_term' = 'Resolution Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `resolution_type` SET TAGS ('dbx_value_regex' = 'CREDIT_NOTE|PRICE_ADJUSTMENT|WRITE_OFF|UPHELD|PARTIAL_CREDIT|REBILL|PAYMENT_PLAN|NO_ACTION');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `resolved_amount` SET TAGS ('dbx_business_glossary_term' = 'Resolved Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `resolved_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `root_cause_code` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `root_cause_code` SET TAGS ('dbx_value_regex' = 'BILLING_ERROR|PRICING_MASTER_DATA|CONTRACT_INTERPRETATION|LOGISTICS_DISCREPANCY|QUALITY_REJECTION|SYSTEM_ERROR|CUSTOMER_ERROR|PROCESS_GAP|OTHER');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `salesforce_case_reference` SET TAGS ('dbx_business_glossary_term' = 'Salesforce Case ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'SLA Breach Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_SERVICE_CLOUD|MANUAL');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Dispute Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'OPEN|UNDER_REVIEW|PENDING_CUSTOMER|PENDING_INTERNAL|ESCALATED|RESOLVED|CLOSED|WITHDRAWN');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `supporting_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Supporting Document Reference');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `undisputed_amount` SET TAGS ('dbx_business_glossary_term' = 'Undisputed Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ALTER COLUMN `undisputed_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` SET TAGS ('dbx_subdomain' = 'invoice_management');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` SET TAGS ('dbx_original_name' = 'billing_run');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `run_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Run ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `type_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Type Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `billing_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `billing_due_date_from` SET TAGS ('dbx_business_glossary_term' = 'Billing Due Date From');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `billing_due_date_to` SET TAGS ('dbx_business_glossary_term' = 'Billing Due Date To');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `completed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Completed Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `date` SET TAGS ('dbx_business_glossary_term' = 'Billing Run Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `division` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `documents_processed_count` SET TAGS ('dbx_business_glossary_term' = 'Documents Processed Count');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `documents_processed_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `documents_selected_count` SET TAGS ('dbx_business_glossary_term' = 'Documents Selected Count');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `documents_selected_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `duration_seconds` SET TAGS ('dbx_business_glossary_term' = 'Run Duration Seconds');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `duration_seconds` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `error_count` SET TAGS ('dbx_business_glossary_term' = 'Error Count');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `error_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `error_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Error Rate Percent');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `error_rate_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `executed_by` SET TAGS ('dbx_business_glossary_term' = 'Executed By User ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-6])$');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `invoices_created_count` SET TAGS ('dbx_business_glossary_term' = 'Invoices Created Count');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `invoices_created_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `is_test_run` SET TAGS ('dbx_business_glossary_term' = 'Is Test Run Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `is_test_run` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `job_name` SET TAGS ('dbx_business_glossary_term' = 'Background Job Name');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `job_number` SET TAGS ('dbx_business_glossary_term' = 'Background Job Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `job_number` SET TAGS ('dbx_value_regex' = '^[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `log_message` SET TAGS ('dbx_business_glossary_term' = 'Run Log Message');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Billing Run Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^BR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `sales_organization` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `scheduled_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `selection_variant` SET TAGS ('dbx_business_glossary_term' = 'Selection Variant Name');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ECC|MANUAL');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Billing Run Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'completed|partially_completed|failed|in_progress|cancelled');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `total_billed_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Billed Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `total_billed_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `total_gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Gross Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `total_gross_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `total_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Tax Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `total_tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Billing Run Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'scheduled|manual|adhoc|month_end|year_end|intercompany');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `warning_count` SET TAGS ('dbx_business_glossary_term' = 'Warning Count');
ALTER TABLE `manufacturing_ecm`.`billing`.`run` ALTER COLUMN `warning_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` SET TAGS ('dbx_subdomain' = 'payment_collections');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `accounts_receivable_position_id` SET TAGS ('dbx_business_glossary_term' = 'Accounts Receivable (AR) Position ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `account_status` SET TAGS ('dbx_business_glossary_term' = 'AR Account Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `account_status` SET TAGS ('dbx_value_regex' = 'active|credit_hold|collections|write_off|closed|disputed');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `bad_debt_provision_amount` SET TAGS ('dbx_business_glossary_term' = 'Bad Debt Provision Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `bad_debt_provision_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `bucket_0_30_amount` SET TAGS ('dbx_business_glossary_term' = 'Aging Bucket 0-30 Days Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `bucket_0_30_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `bucket_31_60_amount` SET TAGS ('dbx_business_glossary_term' = 'Aging Bucket 31-60 Days Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `bucket_31_60_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `bucket_61_90_amount` SET TAGS ('dbx_business_glossary_term' = 'Aging Bucket 61-90 Days Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `bucket_61_90_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `bucket_90_plus_amount` SET TAGS ('dbx_business_glossary_term' = 'Aging Bucket 90+ Days Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `bucket_90_plus_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Company Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `credit_block` SET TAGS ('dbx_business_glossary_term' = 'Credit Block Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `credit_block` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `credit_control_area` SET TAGS ('dbx_business_glossary_term' = 'Credit Control Area');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `credit_exposure` SET TAGS ('dbx_business_glossary_term' = 'Credit Exposure');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `credit_exposure` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `credit_limit` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `credit_limit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `credit_utilization_percentage` SET TAGS ('dbx_business_glossary_term' = 'Credit Utilization Percentage');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `credit_utilization_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `disputed_amount` SET TAGS ('dbx_business_glossary_term' = 'Disputed Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `disputed_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `dso_days` SET TAGS ('dbx_business_glossary_term' = 'Days Sales Outstanding (DSO)');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `dunning_block` SET TAGS ('dbx_business_glossary_term' = 'Dunning Block Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `dunning_block` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `dunning_date` SET TAGS ('dbx_business_glossary_term' = 'Last Dunning Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `dunning_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `dunning_level` SET TAGS ('dbx_business_glossary_term' = 'Dunning Level');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `dunning_level` SET TAGS ('dbx_value_regex' = '0|1|2|3|4');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-6])$');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `last_invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Last Invoice Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `last_invoice_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `last_payment_amount` SET TAGS ('dbx_business_glossary_term' = 'Last Payment Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `last_payment_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `last_payment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Payment Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `last_payment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `not_yet_due_amount` SET TAGS ('dbx_business_glossary_term' = 'Not Yet Due Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `not_yet_due_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `oldest_open_item_date` SET TAGS ('dbx_business_glossary_term' = 'Oldest Open Item Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `oldest_open_item_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `open_item_count` SET TAGS ('dbx_business_glossary_term' = 'Open Item Count');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `overdue_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Overdue Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `overdue_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `position_date` SET TAGS ('dbx_business_glossary_term' = 'AR Position Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `position_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `total_outstanding_balance` SET TAGS ('dbx_business_glossary_term' = 'Total Outstanding AR Balance');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `total_outstanding_balance` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `total_outstanding_balance_company_currency` SET TAGS ('dbx_business_glossary_term' = 'Total Outstanding AR Balance (Company Currency)');
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ALTER COLUMN `total_outstanding_balance_company_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` SET TAGS ('dbx_subdomain' = 'invoice_management');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` SET TAGS ('dbx_original_name' = 'billing_document_output');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `document_output_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Document Output ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `partner_id` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Partner ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `acknowledgement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Acknowledgement Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `acknowledgement_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `archiving_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Archiving Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `archiving_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `delivery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Delivery Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `delivery_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `digital_signature_reference` SET TAGS ('dbx_business_glossary_term' = 'Digital Signature Reference');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Billing Document Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `document_type` SET TAGS ('dbx_value_regex' = 'invoice|credit_note|debit_note|pro_forma_invoice|self_billing_invoice|intercompany_invoice');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `e_invoicing_format` SET TAGS ('dbx_business_glossary_term' = 'E-Invoicing Format');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `e_invoicing_format` SET TAGS ('dbx_value_regex' = 'ZUGFeRD|Peppol_BIS|EDIFACT_INVOIC|X12_810|FatturaPA|CFDI|NF-e|UBL_2.1|xRechnung|none');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `e_invoicing_standard_version` SET TAGS ('dbx_business_glossary_term' = 'E-Invoicing Standard Version');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `edi_qualifier` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Qualifier');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `failure_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Failure Reason Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `failure_reason_description` SET TAGS ('dbx_business_glossary_term' = 'Failure Reason Description');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `is_resend` SET TAGS ('dbx_business_glossary_term' = 'Resend Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `is_resend` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `is_test_transmission` SET TAGS ('dbx_business_glossary_term' = 'Test Transmission Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `is_test_transmission` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `legal_archiving_reference` SET TAGS ('dbx_business_glossary_term' = 'Legal Archiving Reference');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `max_retry_limit` SET TAGS ('dbx_business_glossary_term' = 'Maximum Retry Limit');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `max_retry_limit` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `original_output_number` SET TAGS ('dbx_business_glossary_term' = 'Original Output Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `output_language_code` SET TAGS ('dbx_business_glossary_term' = 'Output Language Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `output_language_code` SET TAGS ('dbx_value_regex' = '[A-Z]{2}');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `output_medium_code` SET TAGS ('dbx_business_glossary_term' = 'Output Medium Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `output_medium_code` SET TAGS ('dbx_value_regex' = '1|2|3|4|5|6|7|8|9');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `output_number` SET TAGS ('dbx_business_glossary_term' = 'Output Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `output_type_code` SET TAGS ('dbx_business_glossary_term' = 'Output Type Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `output_type_description` SET TAGS ('dbx_business_glossary_term' = 'Output Type Description');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `partner_function_code` SET TAGS ('dbx_business_glossary_term' = 'Partner Function Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `partner_function_code` SET TAGS ('dbx_value_regex' = 'RE|RG|WE|AG|ZA');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `peppol_access_point_code` SET TAGS ('dbx_business_glossary_term' = 'Peppol Access Point ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `print_queue_name` SET TAGS ('dbx_business_glossary_term' = 'Print Queue Name');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `recipient_address` SET TAGS ('dbx_business_glossary_term' = 'Recipient Address');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `recipient_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `recipient_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `retry_count` SET TAGS ('dbx_business_glossary_term' = 'Retry Count');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `retry_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|EDI_VAN|PEPPOL_AP|EXTERNAL_EINVOICING|LEGACY');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `spool_request_number` SET TAGS ('dbx_business_glossary_term' = 'Spool Request Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `tax_authority_submission_reference` SET TAGS ('dbx_business_glossary_term' = 'Tax Authority Submission ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `transmission_channel` SET TAGS ('dbx_business_glossary_term' = 'Transmission Channel');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `transmission_channel` SET TAGS ('dbx_value_regex' = 'print|edi|email_pdf|customer_portal|e_invoicing|fax|xml|api');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `transmission_date` SET TAGS ('dbx_business_glossary_term' = 'Transmission Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `transmission_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `transmission_status` SET TAGS ('dbx_business_glossary_term' = 'Transmission Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `transmission_status` SET TAGS ('dbx_value_regex' = 'queued|sent|delivered|failed|acknowledged|cancelled|pending_retry');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `transmission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Transmission Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ALTER COLUMN `transmission_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` SET TAGS ('dbx_subdomain' = 'invoice_management');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` SET TAGS ('dbx_original_name' = 'billing_type');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `type_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Type ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `account_determination_procedure` SET TAGS ('dbx_business_glossary_term' = 'Account Determination Procedure');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `account_determination_procedure` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `applicable_company_codes` SET TAGS ('dbx_business_glossary_term' = 'Applicable Company Codes');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `applicable_sales_doc_types` SET TAGS ('dbx_business_glossary_term' = 'Applicable Sales Document Types');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `applicable_sales_organizations` SET TAGS ('dbx_business_glossary_term' = 'Applicable Sales Organizations');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `billing_relevance` SET TAGS ('dbx_business_glossary_term' = 'Billing Relevance');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `billing_relevance` SET TAGS ('dbx_value_regex' = 'order_related|delivery_related|service_related|project_related|contract_related|milestone_related');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `cancellation_billing_type_code` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Billing Type Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `cancellation_billing_type_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Billing Category');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'invoice|credit_memo|debit_memo|pro_forma|intercompany|cancellation|self_billing|down_payment|milestone_billing');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Billing Type Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `copy_control_source_types` SET TAGS ('dbx_business_glossary_term' = 'Copy Control Source Document Types');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `credit_check_active` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Active Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `credit_check_active` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `credit_memo_indicator` SET TAGS ('dbx_business_glossary_term' = 'Credit Memo Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `credit_memo_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `debit_memo_indicator` SET TAGS ('dbx_business_glossary_term' = 'Debit Memo Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `debit_memo_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Billing Type Description');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `document_category` SET TAGS ('dbx_business_glossary_term' = 'Document Category');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `document_category` SET TAGS ('dbx_value_regex' = 'M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `dunning_relevant` SET TAGS ('dbx_business_glossary_term' = 'Dunning Relevant Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `dunning_relevant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `gl_account_posting_key` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Posting Key');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `gl_account_posting_key` SET TAGS ('dbx_value_regex' = '^[0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `intercompany_indicator` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Billing Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `intercompany_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `invoice_list_type` SET TAGS ('dbx_business_glossary_term' = 'Invoice List Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `invoice_list_type` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{0,4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `multi_currency_enabled` SET TAGS ('dbx_business_glossary_term' = 'Multi-Currency Enabled Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `multi_currency_enabled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Billing Type Name');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `number_range_code` SET TAGS ('dbx_business_glossary_term' = 'Number Range Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `number_range_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `output_determination_procedure` SET TAGS ('dbx_business_glossary_term' = 'Output Determination Procedure');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `output_determination_procedure` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `payment_terms_default` SET TAGS ('dbx_business_glossary_term' = 'Default Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `payment_terms_default` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `posting_indicator` SET TAGS ('dbx_business_glossary_term' = 'Posting Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `posting_indicator` SET TAGS ('dbx_value_regex' = 'A|B|C|D|E');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `pricing_procedure_code` SET TAGS ('dbx_business_glossary_term' = 'Pricing Procedure Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `pricing_procedure_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `relevant_for_rebate` SET TAGS ('dbx_business_glossary_term' = 'Relevant for Rebate Processing Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `relevant_for_rebate` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `relevant_for_statistics` SET TAGS ('dbx_business_glossary_term' = 'Relevant for Statistics Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `relevant_for_statistics` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `revenue_recognition_method` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Method');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `revenue_recognition_method` SET TAGS ('dbx_value_regex' = 'immediate|milestone|percentage_of_completion|time_based|event_based|manual');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|MANUAL|MIGRATION');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Billing Type Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated|under_review');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `tax_determination_procedure` SET TAGS ('dbx_business_glossary_term' = 'Tax Determination Procedure');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `tax_determination_procedure` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `transfer_to_accounting` SET TAGS ('dbx_business_glossary_term' = 'Transfer to Accounting Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`type` ALTER COLUMN `transfer_to_accounting` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` SET TAGS ('dbx_subdomain' = 'revenue_recognition');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `billing_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `applicable_customer_segment` SET TAGS ('dbx_business_glossary_term' = 'Applicable Customer Segment');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `applicable_customer_segment` SET TAGS ('dbx_value_regex' = 'all|key_account|distributor|oem|government|small_medium_enterprise|intercompany|export');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `baseline_date_rule` SET TAGS ('dbx_business_glossary_term' = 'Baseline Date Calculation Rule');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `baseline_date_rule` SET TAGS ('dbx_value_regex' = 'invoice_date|posting_date|delivery_date|goods_receipt_date|end_of_month|start_of_next_month|contract_start_date');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `company_code_restriction` SET TAGS ('dbx_business_glossary_term' = 'Company Code Restriction');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `country_restriction` SET TAGS ('dbx_business_glossary_term' = 'Country Restriction');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `country_restriction` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}(|[A-Z]{3})*$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `currency_restriction` SET TAGS ('dbx_business_glossary_term' = 'Currency Restriction');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `currency_restriction` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}(|[A-Z]{3})*$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Description');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `discount_days_1` SET TAGS ('dbx_business_glossary_term' = 'Early Payment Discount Days (Tier 1)');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `discount_days_1` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `discount_days_2` SET TAGS ('dbx_business_glossary_term' = 'Early Payment Discount Days (Tier 2)');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `discount_days_2` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `discount_percentage_1` SET TAGS ('dbx_business_glossary_term' = 'Early Payment Discount Percentage (Tier 1)');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `discount_percentage_1` SET TAGS ('dbx_value_regex' = '^(0(.d{1,4})?|1(.0{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `discount_percentage_2` SET TAGS ('dbx_business_glossary_term' = 'Early Payment Discount Percentage (Tier 2)');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `discount_percentage_2` SET TAGS ('dbx_value_regex' = '^(0(.d{1,4})?|1(.0{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `document_language` SET TAGS ('dbx_business_glossary_term' = 'Document Language');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `document_language` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `dunning_block_indicator` SET TAGS ('dbx_business_glossary_term' = 'Dunning Block Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `dunning_block_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `grace_period_days` SET TAGS ('dbx_business_glossary_term' = 'Grace Period Days');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `grace_period_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `incoterms_relevance` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Relevance');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `incoterms_relevance` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF|not_applicable');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `installment_count` SET TAGS ('dbx_business_glossary_term' = 'Number of Installments');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `installment_count` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `is_installment` SET TAGS ('dbx_business_glossary_term' = 'Installment Payment Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `is_installment` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `is_intercompany_applicable` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Applicable Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `is_intercompany_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `is_prepayment_required` SET TAGS ('dbx_business_glossary_term' = 'Prepayment Required Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `is_prepayment_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `late_payment_interest_rate` SET TAGS ('dbx_business_glossary_term' = 'Late Payment Interest Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `late_payment_interest_rate` SET TAGS ('dbx_value_regex' = '^d{1,2}(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Name');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `net_due_day_of_month` SET TAGS ('dbx_business_glossary_term' = 'Net Due Day of Month');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `net_due_day_of_month` SET TAGS ('dbx_value_regex' = '^([1-9]|[12][0-9]|3[01])$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `net_due_days` SET TAGS ('dbx_business_glossary_term' = 'Net Due Days');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `net_due_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'bank_transfer|check|direct_debit|letter_of_credit|credit_card|electronic_funds_transfer|cash|promissory_note');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `prepayment_percentage` SET TAGS ('dbx_business_glossary_term' = 'Prepayment Percentage');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `prepayment_percentage` SET TAGS ('dbx_value_regex' = '^(100(.00?)?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `print_text` SET TAGS ('dbx_business_glossary_term' = 'Invoice Print Text');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `revenue_recognition_relevance` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Relevance');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `revenue_recognition_relevance` SET TAGS ('dbx_value_regex' = 'immediate|deferred|milestone_based|percentage_of_completion|not_applicable');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `sales_organization_restriction` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Restriction');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL|ARIBA|LEGACY');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `tax_relevance` SET TAGS ('dbx_business_glossary_term' = 'Tax Relevance');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `tax_relevance` SET TAGS ('dbx_value_regex' = 'standard|tax_on_payment|tax_on_invoice|exempt');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `term_type` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_payment_term` ALTER COLUMN `term_type` SET TAGS ('dbx_value_regex' = 'standard|installment|milestone|prepayment|consignment|cash_on_delivery|letter_of_credit|open_account');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` SET TAGS ('dbx_subdomain' = 'invoice_management');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `invoice_status_history_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Status History ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `approved_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Triggered By User ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `approval_required` SET TAGS ('dbx_business_glossary_term' = 'Approval Required Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `approval_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `billing_document_category` SET TAGS ('dbx_business_glossary_term' = 'Billing Document Category');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `billing_document_category` SET TAGS ('dbx_value_regex' = 'standard_invoice|pro_forma|intercompany|credit_memo|debit_memo|milestone_billing|down_payment|cancellation');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `clearing_document_number` SET TAGS ('dbx_business_glossary_term' = 'Clearing Document Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `dispute_case_number` SET TAGS ('dbx_business_glossary_term' = 'Dispute Case Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `dunning_level` SET TAGS ('dbx_business_glossary_term' = 'Dunning Level');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `dunning_level` SET TAGS ('dbx_value_regex' = '0|1|2|3|4');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '0[1-9]|1[0-6]');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = 'd{4}');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `hold_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Hold Reason Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `invoice_currency` SET TAGS ('dbx_business_glossary_term' = 'Invoice Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `invoice_currency` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `invoice_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `invoice_gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Invoice Gross Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `invoice_gross_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `invoice_gross_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_business_glossary_term' = 'Is Intercompany Invoice Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `new_status` SET TAGS ('dbx_business_glossary_term' = 'New Invoice Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `new_status` SET TAGS ('dbx_value_regex' = 'draft|open|posted|transmitted|partially_paid|paid|cleared|disputed|on_hold|cancelled|reversed|credit_memo_issued');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Status Transition Notes');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `payment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `payment_due_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `previous_status` SET TAGS ('dbx_business_glossary_term' = 'Previous Invoice Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `previous_status` SET TAGS ('dbx_value_regex' = 'draft|open|posted|transmitted|partially_paid|paid|cleared|disputed|on_hold|cancelled|reversed|credit_memo_issued');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `revenue_recognition_status` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `revenue_recognition_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|recognized|deferred|reversed');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `reversal_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|SIEMENS_OPCENTER|MANUAL|INTEGRATION_MIDDLEWARE');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `source_system_event_reference` SET TAGS ('dbx_business_glossary_term' = 'Source System Event ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `tax_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Tax Compliance Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `tax_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|pending_review|non_compliant|exempt|not_applicable');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `transition_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Status Transition Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `transition_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `transmission_channel` SET TAGS ('dbx_business_glossary_term' = 'Invoice Transmission Channel');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `transmission_channel` SET TAGS ('dbx_value_regex' = 'email|edi|portal|print|fax|api|einvoice');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `transmission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Invoice Transmission Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `transmission_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `trigger_event_code` SET TAGS ('dbx_business_glossary_term' = 'Trigger Event Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `trigger_event_description` SET TAGS ('dbx_business_glossary_term' = 'Trigger Event Description');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `trigger_type` SET TAGS ('dbx_business_glossary_term' = 'Transition Trigger Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `trigger_type` SET TAGS ('dbx_value_regex' = 'user_action|system_automated|batch_job|workflow_rule|integration_event|manual_override');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `triggered_by_user_name` SET TAGS ('dbx_business_glossary_term' = 'Triggered By User Full Name');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `triggered_by_user_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `triggered_by_user_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ALTER COLUMN `workflow_instance_reference` SET TAGS ('dbx_business_glossary_term' = 'Workflow Instance ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` SET TAGS ('dbx_subdomain' = 'payment_collections');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `write_off_id` SET TAGS ('dbx_business_glossary_term' = 'Write-Off ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `authorized_by_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Authorized By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver User ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `allowance_account` SET TAGS ('dbx_business_glossary_term' = 'Allowance for Doubtful Accounts General Ledger (GL) Account');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `amount` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `amount_company_currency` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Amount in Company Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `amount_company_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Approval Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `approval_limit_amount` SET TAGS ('dbx_business_glossary_term' = 'Approval Limit Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `approval_limit_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'PENDING|APPROVED|REJECTED|ESCALATED');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `approver_name` SET TAGS ('dbx_business_glossary_term' = 'Approver Name');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `bad_debt_expense_account` SET TAGS ('dbx_business_glossary_term' = 'Bad Debt Expense General Ledger (GL) Account');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Company Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `customer_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Name');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `customer_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `date` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-2])$');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `is_recovery_expected` SET TAGS ('dbx_business_glossary_term' = 'Recovery Expected Flag');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `is_recovery_expected` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `method` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Method');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `method` SET TAGS ('dbx_value_regex' = 'DIRECT_WRITE_OFF|ALLOWANCE_METHOD');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Document Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^WO-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `original_invoice_amount` SET TAGS ('dbx_business_glossary_term' = 'Original Invoice Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `original_invoice_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `outstanding_balance_at_write_off` SET TAGS ('dbx_business_glossary_term' = 'Outstanding Balance at Write-Off');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `outstanding_balance_at_write_off` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `reason_code` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Reason Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `reason_code` SET TAGS ('dbx_value_regex' = 'BAD_DEBT|INSOLVENCY|COMMERCIAL_SETTLEMENT|STATUTE_OF_LIMITATIONS|DISPUTED|FRAUD|OTHER');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `reason_description` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Reason Description');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `recovery_amount` SET TAGS ('dbx_business_glossary_term' = 'Recovered Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `recovery_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `recovery_date` SET TAGS ('dbx_business_glossary_term' = 'Recovery Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `recovery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `reversal_date` SET TAGS ('dbx_business_glossary_term' = 'Reversal Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `reversal_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `reversal_reason` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Write-Off Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'PENDING_APPROVAL|APPROVED|POSTED|REVERSED|CANCELLED');
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ALTER COLUMN `tax_amount_written_off` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount Written Off');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` SET TAGS ('dbx_subdomain' = 'invoice_management');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `proforma_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Pro-Forma Invoice ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `billing_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `sales_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `type_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Type Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Company Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `customer_reference` SET TAGS ('dbx_business_glossary_term' = 'Customer Reference Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `customs_declaration_reference` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Reference');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `destination_country` SET TAGS ('dbx_business_glossary_term' = 'Destination Country');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `destination_country` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification Number (ECCN)');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `hts_code` SET TAGS ('dbx_business_glossary_term' = 'Harmonized Tariff Schedule (HTS) Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `hts_code` SET TAGS ('dbx_value_regex' = '^[0-9]{4,10}(.[0-9]{2})?$');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Location');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Issue Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `letter_of_credit_number` SET TAGS ('dbx_business_glossary_term' = 'Letter of Credit Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `net_amount_company_currency` SET TAGS ('dbx_business_glossary_term' = 'Net Amount in Company Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `net_amount_company_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Pro-Forma Invoice Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^PF-[A-Z0-9]{2,10}-[0-9]{4,12}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `payer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Payer Account Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `payer_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `payer_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `plant` SET TAGS ('dbx_business_glossary_term' = 'Plant');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `purpose` SET TAGS ('dbx_business_glossary_term' = 'Pro-Forma Invoice Purpose');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `purpose` SET TAGS ('dbx_value_regex' = 'customs_clearance|letter_of_credit|advance_payment|internal_cost_allocation|insurance_valuation|other');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `shipping_country` SET TAGS ('dbx_business_glossary_term' = 'Shipping Country');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `shipping_country` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|MANUAL|LEGACY');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Pro-Forma Invoice Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|issued|submitted|accepted|expired|cancelled|superseded');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `validity_date` SET TAGS ('dbx_business_glossary_term' = 'Validity Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ALTER COLUMN `validity_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` SET TAGS ('dbx_subdomain' = 'invoice_management');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` SET TAGS ('dbx_original_name' = 'billing_condition');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `condition_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Condition ID');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Document Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `account_key` SET TAGS ('dbx_business_glossary_term' = 'Account Key');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `accrual_account_key` SET TAGS ('dbx_business_glossary_term' = 'Accrual Account Key');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `base_value` SET TAGS ('dbx_business_glossary_term' = 'Condition Base Value');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `base_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `billing_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `billing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `billing_document_line_item` SET TAGS ('dbx_business_glossary_term' = 'Billing Document Line Item Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `calculation_type` SET TAGS ('dbx_business_glossary_term' = 'Calculation Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `calculation_type` SET TAGS ('dbx_value_regex' = 'fixed_amount|percentage|quantity_based|weight_based|volume_based|formula|free_goods');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Condition Category');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'price|discount|surcharge|freight|tax|insurance|packaging|rebate|commission|cost|other');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `class` SET TAGS ('dbx_business_glossary_term' = 'Condition Class');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `class` SET TAGS ('dbx_value_regex' = 'A|B|C|D|E');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Company Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `company_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `counter` SET TAGS ('dbx_business_glossary_term' = 'Condition Counter');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Mandatory Condition Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `is_manually_changed` SET TAGS ('dbx_business_glossary_term' = 'Manually Changed Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `is_manually_changed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `is_statistical` SET TAGS ('dbx_business_glossary_term' = 'Statistical Condition Indicator');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `is_statistical` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `origin` SET TAGS ('dbx_business_glossary_term' = 'Condition Origin');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `origin` SET TAGS ('dbx_value_regex' = 'manual|automatic|contract|pricing_agreement|customer_specific|promotion|rebate_agreement');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `pricing_date` SET TAGS ('dbx_business_glossary_term' = 'Pricing Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `pricing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `pricing_procedure` SET TAGS ('dbx_business_glossary_term' = 'Pricing Procedure');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `rate` SET TAGS ('dbx_business_glossary_term' = 'Condition Rate');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `rate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `rate_unit` SET TAGS ('dbx_business_glossary_term' = 'Condition Rate Unit');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `record_number` SET TAGS ('dbx_business_glossary_term' = 'Condition Record Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `scale_quantity` SET TAGS ('dbx_business_glossary_term' = 'Condition Scale Quantity');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `scale_unit` SET TAGS ('dbx_business_glossary_term' = 'Condition Scale Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Condition Status');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|deleted|blocked|statistical');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `step_number` SET TAGS ('dbx_business_glossary_term' = 'Pricing Procedure Step Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Condition Type');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `type_description` SET TAGS ('dbx_business_glossary_term' = 'Condition Type Description');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Condition Validity End Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Condition Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `value` SET TAGS ('dbx_business_glossary_term' = 'Condition Value');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `value_company_currency` SET TAGS ('dbx_business_glossary_term' = 'Condition Value in Company Currency');
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ALTER COLUMN `value_company_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` SET TAGS ('dbx_subdomain' = 'invoice_management');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` SET TAGS ('dbx_association_edges' = 'billing.invoice,technology.it_service');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` ALTER COLUMN `invoice_service_line_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Service Line Identifier');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Service Line - Invoice Id');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` ALTER COLUMN `it_service_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Service Line - It Service Id');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_business_glossary_term' = 'Billing Frequency');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` ALTER COLUMN `line_gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Line Gross Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` ALTER COLUMN `line_item_number` SET TAGS ('dbx_business_glossary_term' = 'Line Item Number');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` ALTER COLUMN `line_net_amount` SET TAGS ('dbx_business_glossary_term' = 'Line Net Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` ALTER COLUMN `line_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Line Tax Amount');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` ALTER COLUMN `service_description_override` SET TAGS ('dbx_business_glossary_term' = 'Service Description Override');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` ALTER COLUMN `service_period_end` SET TAGS ('dbx_business_glossary_term' = 'Service Period End Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` ALTER COLUMN `service_period_start` SET TAGS ('dbx_business_glossary_term' = 'Service Period Start Date');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` ALTER COLUMN `service_quantity` SET TAGS ('dbx_business_glossary_term' = 'Service Quantity');
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Unit Price');
