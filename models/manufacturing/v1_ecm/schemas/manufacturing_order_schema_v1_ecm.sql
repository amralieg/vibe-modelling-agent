-- Schema for Domain: order | Business: Manufacturing | Version: v1_ecm
-- Generated on: 2026-04-16 07:42:35

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`order` COMMENT 'SSOT for all customer order transactions including RFQ/RFP processing, quotations, sales orders, ATP/CTP commitments, order configuration options, fulfillment scheduling, delivery confirmation, and order-to-cash workflows. Manages order lifecycle from quote to cash across MTO, MTS, ETO, and ATO fulfillment modes.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`line_item` (
    `line_item_id` BIGINT COMMENT 'Unique surrogate identifier for each order line item record in the silver layer lakehouse. Serves as the primary key for the order_line_item data product.',
    `compliance_reach_substance_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.reach_substance_declaration. Business justification: Manufacturing orders must include REACH substance declarations for products shipped to EU, documenting SVHC content. Customer service provides these declarations with shipments per regulatory and cust',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Order line items must reference the engineered component being sold. Sales order processing requires component specifications, pricing, and availability checks daily.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Individual line items often represent specific equipment units (PLCs, sensors, drives) being ordered. Critical for configuring automation systems and tracking serial numbers through order-to-delivery.',
    `fulfillment_mode_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_mode. Business justification: Individual line items may have different fulfillment modes. The string fulfillment_mode is replaced by FK fulfillment_mode_id.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Each order line item must post revenue to the correct GL account based on product type and revenue recognition rules. Accounting uses this for financial statement preparation.',
    `product_certification_id` BIGINT COMMENT 'Foreign key linking to compliance.product_certification. Business justification: Order line items must reference valid product certifications (UL, CE, CSA) to confirm products meet customer/regional requirements. Sales operations verify this during order entry for regulated indust',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: order_line_item is a child of sales_order. The string sales_order_number is replaced by a proper FK sales_order_id, enabling referential integrity and eliminating the denormalized string key.',
    `actual_delivery_date` DATE COMMENT 'The actual date on which the goods were delivered and goods issue was posted for this line item. Used for on-time delivery (OTD) performance measurement and customer SLA compliance reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `atp_ctp_confirmed` BOOLEAN COMMENT 'Boolean flag indicating whether the line item quantity and delivery date have been confirmed through an Available to Promise (ATP) or Capable to Promise (CTP) check in SAP S/4HANA. True indicates a firm commitment has been made.. Valid values are `true|false`',
    `batch_number` STRING COMMENT 'Manufacturing batch or lot number assigned to the goods for this line item, enabling full traceability from production through delivery. Critical for quality management, recall management, and regulatory compliance. Corresponds to CHARG in SAP VBAP.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `billing_block` STRING COMMENT 'Code indicating a billing block applied to this line item, preventing invoice creation until the block is released (e.g., pending approval, dispute resolution). Corresponds to FAKSP in SAP VBAP.. Valid values are `^[A-Z0-9]{2}$`',
    `confirmed_delivery_date` DATE COMMENT 'The delivery date confirmed by the system following ATP (Available to Promise) or CTP (Capable to Promise) check, representing the committed delivery date to the customer. May differ from requested delivery date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `confirmed_quantity` DECIMAL(18,2) COMMENT 'The quantity confirmed by Available to Promise (ATP) or Capable to Promise (CTP) check, representing the quantity the plant can commit to deliver. May be less than ordered quantity in partial confirmation scenarios.. Valid values are `^[0-9]{1,14}(.[0-9]{1,4})?$`',
    `cost_center` STRING COMMENT 'SAP cost center associated with this line item for cost allocation and controlling purposes, particularly relevant for internal orders and service line items. Supports COGS tracking and profitability analysis.. Valid values are `^[A-Z0-9-]{1,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the order line item was originally created in the source SAP S/4HANA system. Used for audit trail, data lineage, and order processing time analysis.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the order line item prices and values are expressed (e.g., USD, EUR, GBP, JPY). Supports multi-currency operations across global manufacturing sites.. Valid values are `^[A-Z]{3}$`',
    `delivered_quantity` DECIMAL(18,2) COMMENT 'The cumulative quantity of the line item that has been physically delivered and goods-issued to the customer. Used to track fulfillment progress and calculate open delivery quantity.. Valid values are `^[0-9]{1,14}(.[0-9]{1,4})?$`',
    `delivery_block` STRING COMMENT 'Code indicating a delivery block applied to this line item, preventing delivery processing until the block is released (e.g., credit block, quality hold, export control block). Corresponds to LIFSP in SAP VBAP.. Valid values are `^[A-Z0-9]{2}$`',
    `discount_percent` DECIMAL(18,2) COMMENT 'Percentage discount applied to the gross price for this line item, resulting from customer-specific pricing agreements, volume discounts, or promotional pricing. Used for margin analysis and pricing agreement compliance.. Valid values are `^(100(.0{1,4})?|[0-9]{1,2}(.[0-9]{1,4})?)$`',
    `gross_price` DECIMAL(18,2) COMMENT 'Gross list price per unit of measure before any discounts or pricing conditions are applied. Represents the catalog or list price for the product. Used for discount analysis and pricing strategy reporting.. Valid values are `^[0-9]{1,16}(.[0-9]{1,2})?$`',
    `higher_level_item` STRING COMMENT 'Line item number of the parent item in a hierarchical order structure, used for sub-items, free goods, or configuration components linked to a main item. Corresponds to UEPOS in SAP VBAP. Null for top-level items.. Valid values are `^[0-9]{1,6}$`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms) code defining the responsibilities of buyer and seller for delivery, risk transfer, and cost allocation for this line item. Corresponds to INCO1 in SAP VBAP.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `item_category` STRING COMMENT 'SAP SD item category code controlling the processing of the line item, determining billing relevance, delivery relevance, and pricing behavior (e.g., TAN=Standard Item, TAB=Individual Purchase Order, TAD=Service Item).. Valid values are `TAN|TAB|TAD|TAF|TAK|TAP|TAQ|TAX|TANN|TATX|ZTAN|ZTAD|ZTAB`',
    `last_changed_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the order line item in the source SAP S/4HANA system. Used for change tracking, delta extraction, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `material_description` STRING COMMENT 'Short text description of the material or product being ordered, as maintained in the SAP material master. Provides human-readable identification of the ordered item.',
    `material_number` STRING COMMENT 'SAP material master number identifying the product, automation system, electrification solution, or smart infrastructure component being ordered. Corresponds to MATNR in SAP VBAP table.. Valid values are `^[A-Z0-9-_]{1,40}$`',
    `net_price` DECIMAL(18,2) COMMENT 'Net price per unit of measure for this line item after all applicable discounts and pricing conditions have been applied. Used for revenue recognition and order-to-cash reporting. Corresponds to NETPR in SAP VBAP.. Valid values are `^[0-9]{1,16}(.[0-9]{1,2})?$`',
    `net_value` DECIMAL(18,2) COMMENT 'Total net value of the line item calculated as net price multiplied by ordered quantity. Represents the line item revenue contribution before tax. Corresponds to NETWR in SAP VBAP.. Valid values are `^[0-9]{1,16}(.[0-9]{1,2})?$`',
    `number` STRING COMMENT 'Sequential line item position number within the sales order, identifying the specific item within the order document. Corresponds to POSNR in SAP VBAP table (e.g., 10, 20, 30).. Valid values are `^[0-9]{1,6}$`',
    `ordered_quantity` DECIMAL(18,2) COMMENT 'The quantity of the material or product requested by the customer on this line item, expressed in the sales unit of measure. Corresponds to KWMENG in SAP VBAP.. Valid values are `^[0-9]{1,14}(.[0-9]{1,4})?$`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or distribution center assigned to fulfill this line item. Determines the production plant, storage locations, and shipping point. Corresponds to WERKS in SAP VBAP.. Valid values are `^[A-Z0-9]{4}$`',
    `pricing_date` DATE COMMENT 'The date used to determine applicable pricing conditions, exchange rates, and discounts for this line item. Controls which pricing agreements and condition records are valid for price determination. Corresponds to PRSDT in SAP VBAP.. Valid values are `^d{4}-d{2}-d{2}$`',
    `product_hierarchy` STRING COMMENT 'SAP product hierarchy code classifying the ordered material within the product portfolio structure (e.g., automation systems, electrification solutions, smart infrastructure). Used for sales analysis and reporting by product group.. Valid values are `^[A-Z0-9]{1,18}$`',
    `profit_center` STRING COMMENT 'SAP profit center assigned to this line item for internal management accounting and profitability analysis. Enables revenue and cost allocation to specific business units or product lines. Corresponds to PRCTR in SAP VBAP.. Valid values are `^[A-Z0-9-]{1,10}$`',
    `rejection_reason` STRING COMMENT 'Reason code indicating why a line item was rejected or cancelled (e.g., customer cancellation, material unavailability, credit block). Populated only when status is cancelled. Corresponds to ABGRU in SAP VBAP.',
    `requested_delivery_date` DATE COMMENT 'The delivery date requested by the customer for this specific line item. Used as the baseline for ATP/CTP checks and delivery scheduling. Corresponds to VDATU in SAP VBAP.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sales_unit_price` DECIMAL(18,2) COMMENT 'Price per single unit of the sales unit of measure, used for unit-level pricing analysis and comparison. Distinct from net_price which may reflect pricing per pricing unit (e.g., per 100 units). Corresponds to KPEIN/KMEIN pricing unit logic in SAP.. Valid values are `^[0-9]{1,14}(.[0-9]{1,4})?$`',
    `schedule_line_count` STRING COMMENT 'Number of schedule lines (delivery splits) associated with this order line item, indicating how many separate delivery dates or partial shipments have been scheduled. A value greater than 1 indicates split deliveries.. Valid values are `^[0-9]{1,4}$`',
    `shipping_point` STRING COMMENT 'SAP shipping point from which the goods for this line item will be dispatched. Determines the physical departure location, shipping conditions, and transportation planning. Corresponds to VSTEL in SAP VBAP.. Valid values are `^[A-Z0-9]{4}$`',
    `sku_number` STRING COMMENT 'Stock Keeping Unit (SKU) identifier used for inventory tracking and warehouse management, representing the specific variant of the product being ordered. May differ from material number for configurable products.. Valid values are `^[A-Z0-9-_]{1,50}$`',
    `status` STRING COMMENT 'Current processing status of the sales order line item across the order-to-cash lifecycle, from open through delivery and invoicing to completion or cancellation.. Valid values are `open|in_process|partially_delivered|fully_delivered|invoiced|cancelled|blocked|completed`',
    `storage_location` STRING COMMENT 'SAP storage location within the assigned plant from which the goods will be picked and shipped for this line item. Used for warehouse management and inventory allocation. Corresponds to LGORT in SAP VBAP.. Valid values are `^[A-Z0-9]{4}$`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax amount applicable to this line item based on the tax classification of the material and customer. Includes VAT, GST, or other applicable taxes depending on the jurisdiction.. Valid values are `^[0-9]{1,16}(.[0-9]{1,2})?$`',
    `unit_of_measure` STRING COMMENT 'The unit of measure in which the ordered quantity is expressed for this line item (e.g., EA=Each, PC=Piece, KG=Kilogram, SET=Set). Corresponds to VRKME in SAP VBAP.. Valid values are `EA|PC|KG|LB|M|M2|M3|L|SET|BOX|PAL|ROL|HR|DAY`',
    `wbs_element` STRING COMMENT 'Work Breakdown Structure (WBS) element from SAP Project System (PS) linked to this line item, used for Engineer to Order (ETO) and project-based manufacturing scenarios to track revenue and costs against specific projects.. Valid values are `^[A-Z0-9.-]{1,24}$`',
    CONSTRAINT pk_line_item PRIMARY KEY(`line_item_id`)
) COMMENT 'Individual line item within a sales order representing a specific product, automation system, electrification solution, or smart infrastructure component being ordered. Captures line item number, material/SKU number, ordered quantity, confirmed quantity, unit of measure, requested delivery date per line, confirmed delivery date, line item status, net price, gross price, discount, plant assignment, storage location, batch number, ATP/CTP confirmation flag, and schedule line details. Sourced from SAP S/4HANA SD line item tables.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`order_quotation` (
    `order_quotation_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a commercial quotation record in the Silver layer lakehouse. Serves as the primary key for all downstream joins and lineage tracking.',
    `blanket_order_id` BIGINT COMMENT 'Foreign key linking to order.blanket_order. Business justification: Quotations may be issued under a blanket order framework. The string contract_number is replaced by FK blanket_order_id.',
    `channel_partner_id` BIGINT COMMENT 'Foreign key linking to sales.channel_partner. Business justification: Quotations created by channel partners track the partner for deal registration validation and partner-specific pricing. Ensures proper partner attribution throughout sales cycle.',
    `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: Quotations are addressed to specific contacts at customer accounts. Sales teams use this to direct quotes to the right decision-maker and track engagement.',
    `customer_opportunity_id` BIGINT COMMENT 'Foreign key linking to customer.opportunity. Business justification: Quotations are generated in response to sales opportunities. Sales teams use this to track quote-to-close ratios and manage the sales pipeline for manufacturing deals.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Quotations for replacement equipment or upgrades reference existing installed equipment. Sales engineers use this to ensure compatibility and accurate pricing for retrofits and expansions.',
    `fulfillment_mode_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_mode. Business justification: Quotations specify the fulfillment mode for the proposed solution. The string fulfillment_mode is replaced by FK fulfillment_mode_id.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Quotations are prepared by sales engineers or account managers who configure solutions and pricing. Tracking ownership enables commission calculation, workload management, and customer relationship co',
    `pricing_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.pricing_agreement. Business justification: Quotations reference existing pricing agreements to provide consistent pricing. Sales teams use this to generate accurate quotes based on negotiated customer terms.',
    `rfq_request_id` BIGINT COMMENT 'Foreign key linking to order.rfq_request. Business justification: A quotation is issued in response to an RFQ/RFP. The string rfq_reference_number is replaced by FK rfq_request_id, establishing the quote-to-RFQ traceability.',
    `sales_price_list_id` BIGINT COMMENT 'Foreign key linking to sales.price_list. Business justification: Quotations reference price lists to determine base pricing before discounts. Sales teams select appropriate price list based on customer type, region, and contract terms.',
    `accepted_rejected_timestamp` TIMESTAMP COMMENT 'Date and time at which the customer formally accepted or rejected the quotation. Used to calculate quotation cycle time and measure sales velocity.',
    `competitor_name` STRING COMMENT 'Name of the competing supplier identified during the quotation process. Populated when the win/loss reason involves a competitor selection. Used for competitive intelligence and market share analysis.',
    `confirmed_delivery_date` DATE COMMENT 'Delivery date confirmed by manufacturing/supply chain based on ATP or CTP availability check. Represents the committed delivery commitment communicated to the customer in the quotation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `converted_order_number` STRING COMMENT 'SAP sales order number created when this quotation was accepted and converted. Populated only when status is converted. Enables end-to-end order-to-cash traceability.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which all monetary values on this quotation are expressed (e.g., USD, EUR, GBP). Supports multi-currency reporting and FX conversion.. Valid values are `^[A-Z]{3}$`',
    `customer_account_number` STRING COMMENT 'SAP customer account number (sold-to party) associated with this quotation. Links the quotation to the customer master record for credit, pricing, and order management purposes.',
    `customer_name` STRING COMMENT 'Legal or trading name of the customer or prospect to whom the quotation is addressed. Captured at quotation time to preserve the commercial record even if the customer master is subsequently updated.',
    `delivery_lead_time_days` STRING COMMENT 'Number of calendar days from order placement to expected delivery as quoted to the customer. Derived from production scheduling and logistics planning for the specific fulfillment mode.. Valid values are `^[0-9]+$`',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Overall header-level discount percentage applied to the quotation net value. Captures the commercial discount negotiated with the customer for margin analysis and pricing governance.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `distribution_channel` STRING COMMENT 'SAP distribution channel through which the quoted products will be sold (e.g., direct sales, dealer, OEM, e-commerce). Influences pricing conditions and availability checks.',
    `division` STRING COMMENT 'SAP division code representing the product line or business unit responsible for the quoted products. Used for sales area determination and reporting segmentation.',
    `gross_value` DECIMAL(18,2) COMMENT 'Total gross value of the quotation before application of discounts, representing the sum of all line item list prices. Used for discount analysis and margin reporting.',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the transfer of risk, cost responsibility, and delivery obligations between seller and buyer for the quoted shipment.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `incoterms_location` STRING COMMENT 'Named place or port associated with the Incoterms code, specifying the exact point of risk and cost transfer (e.g., FOB Shanghai Port). Required for logistics and insurance documentation.',
    `issue_date` DATE COMMENT 'Calendar date on which the quotation was formally issued and transmitted to the customer or prospect.. Valid values are `^d{4}-d{2}-d{2}$`',
    `net_value` DECIMAL(18,2) COMMENT 'Total net commercial value of the quotation after all discounts and surcharges but before taxes. Represents the revenue-recognizable amount if the quotation is accepted and converted to a sales order.',
    `number` STRING COMMENT 'Business-facing alphanumeric identifier for the quotation as assigned by SAP S/4HANA SD. Used in all customer-facing documents, correspondence, and cross-system references.. Valid values are `^QT-[0-9]{4}-[0-9]{6}$`',
    `opportunity_reference` STRING COMMENT 'Reference identifier linking this quotation to the originating sales opportunity in Salesforce CRM. Supports opportunity-to-order conversion tracking and win/loss analysis.',
    `payment_terms` STRING COMMENT 'Agreed payment terms code specifying the due date calculation and any early payment discount conditions (e.g., Net 30, 2/10 Net 30). Sourced from SAP payment terms configuration.',
    `probability_percent` DECIMAL(18,2) COMMENT 'Sales representatives estimated probability (0–100%) that this quotation will be accepted and converted to a sales order. Used for pipeline forecasting and revenue planning.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `requested_delivery_date` DATE COMMENT 'Customer-requested delivery date as stated in the RFQ/RFP. Used for Available to Promise (ATP) and Capable to Promise (CTP) checks and delivery lead time commitment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sales_office` STRING COMMENT 'SAP sales office code identifying the geographic or organizational unit from which the quotation is issued. Supports regional sales performance reporting.',
    `sales_organization` STRING COMMENT 'SAP sales organization code responsible for issuing and managing this quotation. Determines pricing procedures, output determination, and revenue attribution.',
    `sales_representative` STRING COMMENT 'Name or employee ID of the sales representative responsible for preparing and managing this quotation. Used for commission calculation, workload reporting, and customer relationship management.',
    `shipping_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customers ship-to destination. Used for export control screening, customs documentation, and logistics routing.. Valid values are `^[A-Z]{3}$`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this quotation record was sourced. Supports data lineage, reconciliation, and audit trail requirements in the Silver layer.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL`',
    `status` STRING COMMENT 'Current lifecycle status of the quotation. Drives workflow routing, reporting, and order-to-cash pipeline visibility. converted indicates the quotation has been turned into a sales order.. Valid values are `draft|submitted|under_review|accepted|rejected|expired|cancelled|converted`',
    `submission_timestamp` TIMESTAMP COMMENT 'Date and time at which the quotation was formally submitted to the customer. Used for response time SLA measurement and sales process analytics.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount (VAT, GST, sales tax) applicable to the quotation as calculated by the tax determination procedure. Required for statutory invoicing and tax reporting.',
    `type` STRING COMMENT 'Classification of the quotation by commercial structure. Standard quotations cover single transactions; framework quotations establish pricing for repeat orders; blanket quotations cover volume commitments; project quotations support ETO/large capital projects; spot quotations address one-time urgent requirements.. Valid values are `standard|framework|blanket|project|spot`',
    `validity_end_date` DATE COMMENT 'Last calendar date through which the quoted prices, terms, and conditions remain valid for customer acceptance. After this date the quotation status transitions to expired.. Valid values are `^d{4}-d{2}-d{2}$`',
    `validity_start_date` DATE COMMENT 'First calendar date from which the quoted prices, terms, and conditions are commercially binding and valid for customer acceptance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `version_number` STRING COMMENT 'Sequential version counter incremented each time the quotation is revised and reissued to the customer. Version 1 represents the initial issue; subsequent revisions increment the counter.. Valid values are `^[1-9][0-9]*$`',
    `win_loss_notes` STRING COMMENT 'Free-text narrative providing additional context for the win or loss outcome beyond the structured reason code. Captured by the sales representative for qualitative pipeline analysis.',
    `win_loss_reason` STRING COMMENT 'Categorized reason code explaining why the quotation was accepted (won) or rejected (lost). Critical input for sales analytics, pricing strategy, and competitive intelligence reporting.. Valid values are `price_competitive|price_too_high|lead_time|technical_fit|competitor_selected|customer_cancelled|budget_constraint|relationship|specification_mismatch|other`',
    CONSTRAINT pk_order_quotation PRIMARY KEY(`order_quotation_id`)
) COMMENT 'Commercial quotation issued to a customer or prospect in response to an RFQ/RFP. Captures quotation number, validity start and end dates, customer reference, quoted products and configurations, pricing conditions, discount structures, delivery lead times, payment terms, incoterms, quotation status (draft, submitted, accepted, rejected, expired), win/loss reason, linked opportunity reference, and sales representative. Supports MTO, ETO, and ATO quoting workflows. Sourced from SAP S/4HANA SD quotation module.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`quotation_line_item` (
    `quotation_line_item_id` BIGINT COMMENT 'Unique system-generated identifier for each individual line item within a commercial quotation. Serves as the primary key for the quotation_line_item entity.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Quotations must reference specific engineered components to provide accurate pricing, lead times, and technical specifications to customers during sales process.',
    `fulfillment_mode_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_mode. Business justification: Quotation line items specify fulfillment mode per line. The string fulfillment_mode is replaced by FK fulfillment_mode_id.',
    `order_configuration_id` BIGINT COMMENT 'Identifier referencing the specific product configuration selected for this line item in configurable product scenarios (e.g., variant configuration in SAP). Captures the unique combination of options and features selected.. Valid values are `^[A-Z0-9_-]{1,40}$`',
    `order_quotation_id` BIGINT COMMENT 'Foreign key linking to order.quotation. Business justification: quotation_line_item is a child of quotation. No existing quotation_id or quotation_number string key is visible in quotation_line_item attributes, so a new FK quotation_id is added to establish the pa',
    `product_certification_id` BIGINT COMMENT 'Foreign key linking to compliance.product_certification. Business justification: Quotations specify which certifications are included (CE, UL, ATEX) as this impacts pricing and lead time. Sales engineers use this to quote compliant configurations for customer jurisdictions.',
    `atp_ctp_method` STRING COMMENT 'Method used to confirm the delivery date for this line item: Available-to-Promise (ATP) based on existing stock, Capable-to-Promise (CTP) based on production capacity, MTO lead time calculation, or manually set by sales.. Valid values are `ATP|CTP|MTO_LEAD_TIME|MANUAL`',
    `configuration_description` STRING COMMENT 'Human-readable summary of the product configuration options selected for this line item, including key technical specifications, options, and features. Supports customer-facing quotation documentation.',
    `confirmed_delivery_date` DATE COMMENT 'Internally confirmed delivery date for this line item based on Available-to-Promise (ATP) or Capable-to-Promise (CTP) checks. Represents the committed delivery commitment to the customer.. Valid values are `^d{4}-d{2}-d{2}$`',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the quoted product is manufactured or assembled. Required for customs declarations, import/export compliance, and trade preference programs.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this quotation line item record was created in the system. Used for audit trail, SLA tracking, and quotation turnaround time analysis.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the line item pricing is expressed (e.g., USD, EUR, GBP). Supports multi-currency quotation management for global operations.. Valid values are `^[A-Z]{3}$`',
    `customs_tariff_number` STRING COMMENT 'Harmonized System (HS) tariff classification number for the quoted product, used for customs declarations, import duty calculation, and trade compliance. Required for cross-border transactions.. Valid values are `^[0-9]{6,10}$`',
    `delivery_lead_time_days` STRING COMMENT 'Committed or estimated number of calendar days from order confirmation to delivery for this specific line item. Reflects production lead time, material availability, and logistics scheduling.. Valid values are `^[0-9]{1,4}$`',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Percentage discount applied to the list price to arrive at the quoted net price for this line item. Reflects customer-specific pricing agreements, volume discounts, or promotional pricing.. Valid values are `^(100(.0{1,4})?|[0-9]{1,2}(.[0-9]{1,4})?)$`',
    `engineering_change_number` STRING COMMENT 'Reference to the Engineering Change Notice (ECN) or Engineering Change Order (ECO) applicable to the quoted material at the time of quotation. Ensures the correct revision level is quoted and traceable.. Valid values are `^[A-Z0-9_-]{1,20}$`',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether the quoted product is classified as a hazardous material requiring special handling, packaging, labeling, or transport documentation under applicable regulations.. Valid values are `true|false`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms) code defining the delivery obligations, risk transfer point, and cost responsibilities between seller and buyer for this line item. Governs logistics and insurance responsibilities.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `item_category` STRING COMMENT 'SAP SD item category code that controls the processing behavior of this line item, including billing relevance, delivery relevance, pricing, and scheduling. Examples: TAN (standard), TAK (consignment), TAP (third-party).. Valid values are `TAN|TAK|TAP|TAQ|TANN|ZTAN|ZTAP`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this quotation line item record was last updated. Supports change tracking, audit compliance, and data freshness monitoring in the Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `line_net_value` DECIMAL(18,2) COMMENT 'Total net value of this line item, calculated as quoted net price multiplied by quoted quantity. Represents the commercial value of this specific line in the quotation.. Valid values are `^[0-9]{1,14}(.[0-9]{1,4})?$`',
    `line_number` STRING COMMENT 'Sequential position number of this line item within the parent quotation. Used to order and reference individual items within a multi-line quotation document.. Valid values are `^[0-9]{1,6}$`',
    `list_price` DECIMAL(18,2) COMMENT 'Standard published catalog or list price per unit of measure for the quoted material, before any discounts or surcharges are applied. Represents the baseline pricing reference.. Valid values are `^[0-9]{1,14}(.[0-9]{1,4})?$`',
    `material_description` STRING COMMENT 'Short descriptive text for the material or product being quoted on this line item, as maintained in the SAP material master. Provides human-readable identification of the quoted item.',
    `material_number` STRING COMMENT 'SAP material master identifier (SKU) for the product, component, or system being quoted on this line. Links to the material master record in SAP S/4HANA MM module.. Valid values are `^[A-Z0-9_-]{1,40}$`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or distribution center responsible for fulfilling this line item. Determines production scheduling, inventory sourcing, and shipping origin.. Valid values are `^[A-Z0-9]{1,4}$`',
    `pricing_date` DATE COMMENT 'Reference date used to determine applicable pricing conditions, exchange rates, and discount agreements for this line item. Pricing conditions valid on this date are applied.. Valid values are `^d{4}-d{2}-d{2}$`',
    `product_group` STRING COMMENT 'Classification grouping for the quoted material, used for pricing, reporting, and sales analysis. Corresponds to the SAP material group or product hierarchy node.',
    `quoted_net_price` DECIMAL(18,2) COMMENT 'Net unit price offered to the customer on this line item after all applicable discounts, surcharges, and pricing conditions have been applied. This is the contractually binding price per unit.. Valid values are `^[0-9]{1,14}(.[0-9]{1,4})?$`',
    `quoted_quantity` DECIMAL(18,2) COMMENT 'The quantity of the material or product being quoted on this line item, expressed in the specified unit of measure. Basis for pricing and delivery planning.. Valid values are `^[0-9]{1,14}(.[0-9]{1,4})?$`',
    `reason_for_rejection` STRING COMMENT 'Reason code or description explaining why this specific line item was rejected or removed from the quotation. Used for win/loss analysis and sales process improvement.',
    `requested_delivery_date` DATE COMMENT 'Customer-requested delivery date for this line item as specified in the RFQ or quotation request. Used as the baseline for ATP/CTP commitment checks.. Valid values are `^d{4}-d{2}-d{2}$`',
    `rohs_compliant` BOOLEAN COMMENT 'Indicates whether the quoted product complies with the EU Restriction of Hazardous Substances (RoHS) Directive, restricting the use of specific hazardous materials in electrical and electronic equipment.. Valid values are `true|false`',
    `sales_unit` STRING COMMENT 'Unit of measure used for sales and pricing purposes on this line item, which may differ from the base unit of measure in the material master (e.g., selling in sets while stocking in pieces).. Valid values are `EA|PC|KG|M|M2|M3|L|SET|BOX|PAL`',
    `sku` STRING COMMENT 'Stock Keeping Unit code representing the specific product variant being quoted, including configuration and packaging distinctions. Used for inventory and fulfillment planning.. Valid values are `^[A-Z0-9_-]{1,50}$`',
    `status` STRING COMMENT 'Current processing status of this quotation line item within the order-to-cash workflow. Tracks the lifecycle from initial creation through approval, conversion to sales order, or rejection.. Valid values are `open|in_review|approved|rejected|expired|converted_to_order|cancelled`',
    `storage_location` STRING COMMENT 'SAP storage location within the plant from which the quoted material will be sourced or shipped. Used for inventory reservation and warehouse management.. Valid values are `^[A-Z0-9]{1,4}$`',
    `sub_line_number` STRING COMMENT 'Secondary sequence number used to identify sub-items or component breakdowns within a parent line item, supporting hierarchical line item structures common in Engineer-to-Order (ETO) and complex system quotations.. Valid values are `^[0-9]{1,4}$`',
    `surcharge_percentage` DECIMAL(18,2) COMMENT 'Percentage surcharge applied to the base price for this line item, covering special handling, expedite fees, hazardous material handling, or custom engineering premiums.. Valid values are `^(100(.0{1,4})?|[0-9]{1,2}(.[0-9]{1,4})?)$`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Calculated tax amount applicable to this line item based on the tax code and line net value. Supports tax reporting and compliance with local fiscal regulations.. Valid values are `^[0-9]{1,14}(.[0-9]{1,4})?$`',
    `tax_code` STRING COMMENT 'Tax classification code applicable to this line item, determining the applicable VAT, GST, or sales tax rate based on the product type and destination country. Used for tax calculation and compliance reporting.. Valid values are `^[A-Z0-9]{1,4}$`',
    `technical_spec_summary` STRING COMMENT 'Condensed summary of the key technical specifications for the product or system being quoted on this line item, including performance parameters, ratings, and compliance certifications relevant to the customers application.',
    `unit_of_measure` STRING COMMENT 'Standard unit of measure in which the quoted quantity is expressed (e.g., EA for each, KG for kilogram, M for meter). Aligns with ISO 80000 and SAP base unit of measure.. Valid values are `EA|PC|KG|M|M2|M3|L|SET|BOX|PAL|HR|DAY`',
    `validity_end_date` DATE COMMENT 'Expiration date after which the pricing and terms on this quotation line item are no longer valid. Customer must accept or request renewal before this date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `validity_start_date` DATE COMMENT 'Date from which the pricing and terms on this quotation line item are valid. Defines the start of the quotation validity window for this specific line.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_quotation_line_item PRIMARY KEY(`quotation_line_item_id`)
) COMMENT 'Individual line item within a commercial quotation detailing a specific product, system, or component being quoted. Captures line number, material/SKU, quoted quantity, unit of measure, list price, quoted net price, discount percentage, delivery lead time, configuration options, technical specifications summary, and line item status. Enables granular pricing and configuration tracking at the item level for complex industrial manufacturing quotations.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`rfq_request` (
    `rfq_request_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each inbound RFQ or RFP record in the order domain. Serves as the primary key for all downstream joins and lineage tracking.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: RFQ requests must reference specific components to enable accurate cost estimation, feasibility analysis, and technical review by engineering and sales teams.',
    `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: RFQ requests come from specific contacts at customer organizations. Sales teams use this to respond directly to the requesting person and maintain communication history.',
    `fulfillment_mode_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_mode. Business justification: RFQ requests specify the required fulfillment mode. The string fulfillment_mode is replaced by FK fulfillment_mode_id.',
    `priority_id` BIGINT COMMENT 'Foreign key linking to order.order_priority. Business justification: RFQ requests carry a priority level for response urgency. The string priority is replaced by FK order_priority_id.',
    `procurement_sourcing_event_id` BIGINT COMMENT 'Foreign key linking to procurement.sourcing_event. Business justification: Customer RFQs for custom manufacturing solutions trigger internal sourcing events to procure materials/components. Sales engineering uses this to coordinate customer quotes with supplier sourcing acti',
    `sales_opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: RFQ requests are initiated during opportunity qualification. Sales engineers link RFQs to opportunities to track technical requirements and prepare accurate proposals for complex manufacturing solutio',
    `application_type` STRING COMMENT 'Classification of the end-use application domain for which the requested products or systems are intended. Drives product line routing, engineering specialization assignment, and market segment reporting.. Valid values are `factory_automation|building_electrification|transportation_infrastructure|urban_environment|smart_infrastructure|energy_management|other`',
    `assigned_sales_engineer` STRING COMMENT 'Name or identifier of the sales engineer or application engineer responsible for managing the RFQ/RFP response. Drives accountability, workload tracking, and commission attribution.',
    `assigned_sales_office` STRING COMMENT 'The sales office or regional sales unit responsible for managing the customer relationship and RFQ response. Used for territory management, revenue attribution, and regional performance reporting.',
    `awarded_date` DATE COMMENT 'The date on which the customer formally awarded the contract or purchase order to the company following the RFQ/RFP evaluation. Marks the transition from pre-sales to order management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `budget_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the budget indication amount provided by the customer. Supports multi-currency commercial operations across global markets.. Valid values are `^[A-Z]{3}$`',
    `budget_indication_amount` DECIMAL(18,2) COMMENT 'The customers indicated or estimated budget for the project or procurement as disclosed in the RFQ/RFP. Used for commercial feasibility assessment, pricing strategy, and win probability scoring.',
    `competitor_names` STRING COMMENT 'Names of known competing suppliers or vendors also invited to respond to the RFQ/RFP. Used for competitive intelligence, bid strategy, and win/loss analysis.',
    `compliance_requirements` STRING COMMENT 'Customer-specified regulatory, safety, or certification requirements that the supplied products or systems must meet, such as CE Marking, UL certification, RoHS/REACH compliance, or IEC standards. Drives product compliance validation.',
    `confidentiality_agreement_required` BOOLEAN COMMENT 'Indicates whether the customer requires a Non-Disclosure Agreement (NDA) or confidentiality agreement to be in place before technical details of the RFQ/RFP can be shared internally or with subcontractors.. Valid values are `true|false`',
    `country_of_delivery` STRING COMMENT 'ISO 3166-1 alpha-3 country code for the destination country where the ordered goods or systems are to be delivered. Drives export compliance checks, trade regulation screening, and logistics planning.. Valid values are `^[A-Z]{3}$`',
    `customer_reference_number` STRING COMMENT 'The customers own internal document or project reference number as provided on the RFQ/RFP submission. Used for cross-referencing with the customers procurement system and for communication alignment.',
    `decline_reason` STRING COMMENT 'Standardized reason code explaining why the RFQ/RFP was declined, either by the company (no-bid decision) or by the customer (lost to competitor). Used for win/loss analysis and continuous improvement.. Valid values are `price_not_competitive|technical_non_compliance|capacity_unavailable|strategic_decision|customer_cancelled|lost_to_competitor|no_bid|other`',
    `distribution_channel` STRING COMMENT 'The channel through which the customer is engaging for this RFQ, such as direct sales, distributor, OEM partner, or system integrator. Affects pricing tiers, discount structures, and margin reporting.. Valid values are `direct|distributor|oem|system_integrator|online|agent`',
    `estimated_contract_value` DECIMAL(18,2) COMMENT 'Internal estimate of the total contract value if the RFQ/RFP is won, used for pipeline reporting, revenue forecasting, and resource allocation decisions. Distinct from the customers budget indication.',
    `evaluation_criteria` STRING COMMENT 'Description of the criteria the customer will use to evaluate and select a supplier response, such as price, technical compliance, delivery lead time, quality certifications, or after-sales support. Informs bid strategy and proposal emphasis.',
    `incoterms` STRING COMMENT 'International Commercial Terms (Incoterms) applicable to the requested delivery, defining the transfer of risk and responsibility between seller and buyer. Used for logistics planning, insurance, and contract terms.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent update to the RFQ record, capturing any changes to status, assignments, or commercial data. Used for data freshness tracking, audit compliance, and change detection in the Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `nda_signed_date` DATE COMMENT 'The date on which the Non-Disclosure Agreement (NDA) or confidentiality agreement was formally signed between the company and the customer for this RFQ/RFP. Required before sharing proprietary technical information.. Valid values are `^d{4}-d{2}-d{2}$`',
    `payment_terms_requested` STRING COMMENT 'The payment terms requested or indicated by the customer in the RFQ/RFP, such as net 30, net 60, or milestone-based payments. Used for credit assessment and commercial proposal structuring.',
    `project_name` STRING COMMENT 'The name of the customers project or initiative for which the RFQ/RFP is being issued. Provides business context for the request and is used for opportunity tracking and pipeline reporting.',
    `quantity_required` DECIMAL(18,2) COMMENT 'The total quantity of units, systems, or assemblies requested by the customer in the RFQ/RFP. Used for capacity planning, ATP/CTP checks, and commercial pricing calculations.',
    `quantity_unit_of_measure` STRING COMMENT 'The unit of measure associated with the requested quantity (e.g., EA for each, SET for a system set, KG for weight-based items). Ensures accurate commercial and production planning interpretation.. Valid values are `EA|SET|KIT|M|KG|TON|M2|M3|HR|LOT`',
    `received_timestamp` TIMESTAMP COMMENT 'The precise date and time at which the RFQ/RFP was received and registered in the system. Used for SLA compliance measurement, response time analytics, and audit trail.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `related_opportunity_number` STRING COMMENT 'Reference to the associated sales opportunity record in the CRM system (Salesforce) that this RFQ/RFP is linked to. Enables traceability between pre-sales pipeline management and formal RFQ processing.',
    `required_delivery_date` DATE COMMENT 'The date by which the customer requires delivery of the ordered goods or systems. Used for Available-to-Promise (ATP) and Capable-to-Promise (CTP) checks and production scheduling feasibility assessment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `responded_timestamp` TIMESTAMP COMMENT 'The precise date and time at which the formal quotation or proposal response was submitted to the customer. Used to measure response cycle time and SLA adherence.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `response_due_date` DATE COMMENT 'The deadline by which the customer requires a formal quotation or proposal response. Drives prioritization of sales and engineering resources and triggers escalation workflows when approaching.. Valid values are `^d{4}-d{2}-d{2}$`',
    `rfp_indicator` BOOLEAN COMMENT 'Flag indicating whether the inbound request is a formal Request for Proposal (RFP) requiring a detailed technical and commercial proposal, as opposed to a standard Request for Quotation (RFQ) focused on pricing. True = RFP; False = RFQ.. Valid values are `true|false`',
    `rfq_number` STRING COMMENT 'Business-facing alphanumeric identifier assigned to the inbound RFQ or RFP document, used for cross-system reference and customer communication. Corresponds to the customer-provided document number or internally assigned tracking number.. Valid values are `^RFQ-[0-9]{4}-[0-9]{6}$`',
    `sales_organization` STRING COMMENT 'The SAP sales organization code representing the legal entity or business unit responsible for the sale. Determines pricing procedures, output determination, and revenue booking entity.',
    `source_channel` STRING COMMENT 'The channel or medium through which the RFQ/RFP was received from the customer, such as email, customer portal, EDI transmission, or tender platform. Used for process efficiency analysis and digital transformation tracking.. Valid values are `email|portal|edi|mail|in_person|phone|tender_platform|other`',
    `status` STRING COMMENT 'Current lifecycle status of the inbound RFQ/RFP record, tracking progression from initial receipt through evaluation, response, and final disposition. Drives workflow routing and pipeline visibility.. Valid values are `received|under_review|responded|awarded|declined|cancelled|on_hold`',
    `submission_date` DATE COMMENT 'The date on which the customer or prospect formally submitted the RFQ or RFP to the company. Used to calculate response lead times and track compliance with response SLAs.. Valid values are `^d{4}-d{2}-d{2}$`',
    `technical_requirements_summary` STRING COMMENT 'Free-text summary of the customers technical specifications, performance requirements, and engineering constraints as stated in the RFQ/RFP document. Provides context for application engineering and product configuration.',
    `warranty_requirement` STRING COMMENT 'Customer-specified warranty duration, coverage scope, or warranty terms required for the products or systems being quoted. Informs commercial pricing, risk assessment, and after-sales service planning.',
    `win_probability_percent` DECIMAL(18,2) COMMENT 'Sales teams estimated probability (0-100%) of winning the RFQ/RFP and converting it to a sales order. Used for weighted pipeline reporting and revenue forecasting.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    CONSTRAINT pk_rfq_request PRIMARY KEY(`rfq_request_id`)
) COMMENT 'Inbound Request for Quotation (RFQ) or Request for Proposal (RFP) received from a customer or prospect. Captures RFQ/RFP number, customer identity, submission date, response due date, project name, application type (factory automation, building electrification, transportation infrastructure), required delivery date, technical requirements summary, quantity requirements, budget indication, evaluation criteria, RFQ status (received, under review, responded, awarded, declined), and assigned sales/application engineer. SSOT for inbound customer RFQ/RFP records.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`schedule_line` (
    `schedule_line_id` BIGINT COMMENT 'Unique surrogate identifier for each delivery schedule line record in the lakehouse Silver layer. Serves as the primary key for the order_schedule_line entity.',
    `delivery_order_id` BIGINT COMMENT 'Foreign key linking to order.delivery_order. Business justification: Schedule lines are linked to delivery documents for shipment tracking. The string delivery_document_number is replaced by FK delivery_order_id.',
    `fulfillment_mode_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_mode. Business justification: Schedule lines carry fulfillment mode for ATP/CTP scheduling. The string fulfillment_mode is replaced by FK fulfillment_mode_id.',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: Schedule lines are associated with a specific order line item. The string order_line_number is replaced by FK order_line_item_id.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Delivery schedule lines belong to a sales order. The string order_number is replaced by FK sales_order_id for proper referential integrity.',
    `atp_ctp_check_result` STRING COMMENT 'Result of the ATP (Available to Promise) or CTP (Capable to Promise) availability check performed for this schedule line. Indicates whether the full quantity was confirmed, partially confirmed, or not confirmed by the availability check engine.. Valid values are `ATP_CONFIRMED|CTP_CONFIRMED|PARTIAL|NOT_CONFIRMED|MANUAL_OVERRIDE|NOT_CHECKED`',
    `category` STRING COMMENT 'SAP schedule line category code (ETTYP) that controls the behavior of the schedule line, including relevance for MRP, delivery, goods movement, and billing. Examples: CP (standard with MRP), CN (no MRP), BN (no delivery).. Valid values are `CP|CN|BN|BP|CS|CT|CV|CX`',
    `confirmed_delivery_date` DATE COMMENT 'The ATP/CTP-confirmed date on which the quantity on this schedule line is committed for delivery to the customer. Represents the binding delivery promise date used in fulfillment scheduling and customer communication.. Valid values are `^d{4}-d{2}-d{2}$`',
    `confirmed_quantity` DECIMAL(18,2) COMMENT 'The quantity confirmed by ATP (Available to Promise) or CTP (Capable to Promise) check for delivery on the confirmed delivery date. Represents the binding quantity commitment for this schedule line.. Valid values are `^d+(.d{1,4})?$`',
    `country_of_origin` STRING COMMENT 'The ISO 3166-1 alpha-3 country code indicating the country where the material was manufactured or substantially transformed. Required for customs declarations, preferential trade agreements, and import/export compliance.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this schedule line record was first created in the source system (SAP S/4HANA). Used for audit trail, data lineage, and order processing timeline analysis.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'The ISO 4217 three-letter currency code in which the net value of this schedule line is expressed (e.g., USD, EUR, GBP). Supports multi-currency reporting in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `customs_tariff_number` STRING COMMENT 'The Harmonized System (HS) tariff classification number for the material on this schedule line. Required for customs clearance, duty calculation, and trade compliance reporting in cross-border shipments.',
    `delivered_quantity` DECIMAL(18,2) COMMENT 'The actual quantity that has been goods-issued and delivered against this schedule line. Used to track fulfillment progress and calculate open/remaining delivery quantity.. Valid values are `^d+(.d{1,4})?$`',
    `delivery_block_code` STRING COMMENT 'Code indicating whether this schedule line is blocked for delivery processing. A non-empty value prevents the creation of an outbound delivery document. Common blocks include credit holds, export control holds, and customer-requested holds.. Valid values are `01|02|03|04|05|06|07|08|09|10|11|12|`',
    `delivery_block_reason` STRING COMMENT 'Descriptive reason explaining why the delivery block was applied to this schedule line (e.g., Credit limit exceeded, Export license pending, Customer requested hold). Supports operational resolution workflows.',
    `delivery_relevance_indicator` BOOLEAN COMMENT 'Indicates whether this schedule line is relevant for outbound delivery document creation. When false, the schedule line is informational only and will not trigger a delivery in the WMS/SD process.. Valid values are `true|false`',
    `export_control_status` STRING COMMENT 'Status of export control compliance review for this schedule line. Indicates whether the shipment has been cleared for export, is pending license review, or is blocked due to export control regulations (e.g., EAR, ITAR, EU Dual-Use).. Valid values are `APPROVED|PENDING_REVIEW|BLOCKED|NOT_REQUIRED|EXEMPTED`',
    `goods_issue_date` DATE COMMENT 'The planned or actual date on which goods are issued from the warehouse/plant for this schedule line delivery. Triggers inventory reduction and initiates the billing process in the order-to-cash workflow.. Valid values are `^d{4}-d{2}-d{2}$`',
    `goods_issue_status` STRING COMMENT 'Current status of goods issue processing for this schedule line. Tracks whether goods have been fully issued, partially issued, or not yet issued from the warehouse, enabling fulfillment progress monitoring.. Valid values are `NOT_STARTED|PARTIAL|COMPLETE`',
    `hazardous_goods_indicator` BOOLEAN COMMENT 'Indicates whether the material on this schedule line is classified as hazardous goods requiring special handling, packaging, and documentation during transportation. Triggers dangerous goods compliance checks.. Valid values are `true|false`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms) code applicable to this schedule line delivery, defining the transfer of risk and responsibility between seller and buyer. May differ from the order-level Incoterms for split deliveries.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent modification to this schedule line record in the source system. Supports change detection, delta processing in the lakehouse pipeline, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `loading_date` DATE COMMENT 'The planned date on which goods for this schedule line are to be loaded onto the transport vehicle at the shipping point. Used for warehouse and dock scheduling coordination.. Valid values are `^d{4}-d{2}-d{2}$`',
    `material_availability_date` DATE COMMENT 'The date by which the material must be available in the warehouse for picking and packing to meet the loading date. Derived from backward scheduling in SAP SD and used to trigger MRP requirements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `material_number` STRING COMMENT 'The SAP material number (Stock Keeping Unit) identifying the product or component to be delivered on this schedule line. Aligns with the material master in SAP MM.',
    `mrp_relevance_indicator` BOOLEAN COMMENT 'Indicates whether this schedule line is relevant for MRP (Material Requirements Planning) processing. When true, the confirmed quantity and date generate a demand requirement in the MRP run to trigger production or procurement.. Valid values are `true|false`',
    `net_value` DECIMAL(18,2) COMMENT 'The net monetary value of this schedule line, calculated as confirmed quantity multiplied by the net unit price. Used for revenue recognition, billing, and order-to-cash financial reporting.. Valid values are `^-?d+(.d{1,2})?$`',
    `number` STRING COMMENT 'Sequential number identifying the delivery schedule line within a sales order line item, as assigned by SAP S/4HANA SD (VBEP-ETENR). Typically a 4-digit counter (e.g., 0001, 0002) representing each distinct delivery split.. Valid values are `^[0-9]{4}$`',
    `ordered_quantity` DECIMAL(18,2) COMMENT 'The originally requested quantity for this schedule line as entered on the sales order, before ATP/CTP confirmation. Enables comparison between customer request and confirmed commitment.. Valid values are `^d+(.d{1,4})?$`',
    `over_delivery_tolerance_pct` DECIMAL(18,2) COMMENT 'The maximum percentage by which the delivered quantity may exceed the confirmed quantity without requiring a new order or customer approval. Used in goods receipt and delivery processing to handle minor quantity variances.. Valid values are `^d{1,3}(.d{1,2})?$`',
    `partial_delivery_allowed` BOOLEAN COMMENT 'Indicates whether a partial delivery is permitted for this schedule line if the full confirmed quantity cannot be shipped on the confirmed delivery date. Drives ATP/CTP split logic and customer service decisions.. Valid values are `true|false`',
    `plant_code` STRING COMMENT 'The manufacturing or distribution plant code responsible for fulfilling this schedule line. Determines the supplying location for MRP planning, inventory allocation, and goods issue processing.. Valid values are `^[A-Z0-9]{4}$`',
    `quantity_unit` STRING COMMENT 'The unit of measure (UoM) applicable to the confirmed, ordered, and delivered quantities on this schedule line (e.g., EA for each, KG for kilogram, M for meter). Aligns with SAP base unit of measure.. Valid values are `EA|PC|KG|LB|M|M2|M3|L|GAL|SET|BOX|PAL|ROL|HR|MIN`',
    `requested_delivery_date` DATE COMMENT 'The delivery date originally requested by the customer for this schedule line, prior to ATP/CTP confirmation. Used to measure delivery promise accuracy and customer service level performance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `route_code` STRING COMMENT 'The transportation route code assigned to this schedule line, defining the path from shipping point to destination. Determines transit time, carrier selection, and transportation costs in the TMS.',
    `shipping_point` STRING COMMENT 'The SAP shipping point (VSTEL) from which the goods for this schedule line will be dispatched. Represents a physical location (warehouse, plant gate, dock) and determines the outbound delivery processing unit.',
    `storage_location` STRING COMMENT 'The specific storage location within the plant from which goods will be picked for this schedule line delivery. Used by the Warehouse Management System (WMS) for inventory allocation and pick order generation.',
    `transportation_planning_date` DATE COMMENT 'The date by which transportation must be planned and arranged for this schedule line shipment. Used by the Transportation Management System (TMS) to initiate carrier booking and route planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `under_delivery_tolerance_pct` DECIMAL(18,2) COMMENT 'The maximum percentage by which the delivered quantity may fall short of the confirmed quantity and still be considered a complete delivery. Prevents unnecessary open item management for minor shortfalls.. Valid values are `^d{1,3}(.d{1,2})?$`',
    CONSTRAINT pk_schedule_line PRIMARY KEY(`schedule_line_id`)
) COMMENT 'Delivery schedule lines associated with a sales order line item, representing ATP/CTP-confirmed delivery commitments broken into specific dates and quantities. Captures schedule line number, confirmed delivery date, confirmed quantity, delivery block status, goods issue date, transportation planning date, loading date, route, shipping point, and MRP-driven availability confirmation details. Critical for fulfillment scheduling and delivery promise management in multi-plant manufacturing environments. Sourced from SAP S/4HANA SD schedule lines.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`status_history` (
    `status_history_id` BIGINT COMMENT 'Unique surrogate identifier for each order status history record in the Silver Layer lakehouse. Serves as the primary key for the order_status_history data product.',
    `fulfillment_mode_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_mode. Business justification: Status history records capture the fulfillment mode at the time of each status transition. The string fulfillment_mode is replaced by FK fulfillment_mode_id.',
    `reversal_reference_status_history_id` BIGINT COMMENT 'Reference to the order_status_history_id of the original status transition that this record reverses. Enables bidirectional traceability between a reversal event and the original transition it corrects. NULL when is_reversal is FALSE.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Status history records are audit trail entries for a specific sales order. The string order_number is replaced by FK sales_order_id.',
    `approval_required_flag` BOOLEAN COMMENT 'Indicates whether this status transition required a formal approval step (e.g., credit manager approval for credit release, export compliance approval). Supports workflow governance and segregation of duties compliance.. Valid values are `true|false`',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the approval for this status transition was granted. Used to measure approval cycle time and identify approval bottlenecks in the order-to-cash process.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `approved_by_user` STRING COMMENT 'System user ID of the approver who authorized this status transition when approval was required. NULL when no approval was required. Supports segregation of duties and audit trail for compliance.',
    `atp_ctp_check_result` STRING COMMENT 'Result of the Available to Promise (ATP) or Capable to Promise (CTP) availability check performed during this status transition. Captures whether inventory or production capacity was confirmed at the time of the transition.. Valid values are `ATP_CONFIRMED|CTP_CONFIRMED|PARTIAL|FAILED|NOT_PERFORMED|BYPASSED`',
    `block_type` STRING COMMENT 'Categorizes the type of block applied or released during this status transition. Enables analysis of block frequency by type, resolution time, and impact on order-to-cash cycle time.. Valid values are `DELIVERY_BLOCK|BILLING_BLOCK|CREDIT_BLOCK|EXPORT_CONTROL_BLOCK|QUALITY_BLOCK|NONE`',
    `blocking_reason_code` STRING COMMENT 'SAP SD delivery or billing block reason code applied when the status transition results in an order being blocked (e.g., credit block, export control hold, quality hold). NULL when no block is applied. Aligns with SAP SD blocking reason configuration.. Valid values are `^[A-Z0-9_]{1,20}$`',
    `change_reason_code` STRING COMMENT 'Standardized code identifying the business reason for the order status transition (e.g., CREDIT_HOLD, CUSTOMER_REQUEST, DELIVERY_CONFIRMED, PAYMENT_RECEIVED, SYSTEM_AUTO). Enables root cause analysis and process improvement analytics.. Valid values are `^[A-Z0-9_]{1,20}$`',
    `change_reason_description` STRING COMMENT 'Human-readable description of the reason for the status transition. Provides additional context beyond the reason code, including free-text notes entered by the user or generated by the system.',
    `changed_by_user` STRING COMMENT 'System user ID or service account identifier of the actor who triggered the status transition. May represent a human user (SAP logon ID), an automated process (batch job), or an integration service account. Supports accountability and audit trail requirements.',
    `changed_by_user_name` STRING COMMENT 'Display name of the user or process that triggered the status transition. Complements the user ID for human-readable audit reporting and compliance documentation.',
    `comments` STRING COMMENT 'Free-text notes or comments entered by the user or system at the time of the status transition. Provides additional context, exception details, or customer communication notes not captured by structured reason codes.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the sales organization or ship-to location associated with this order status transition. Supports multi-country regulatory compliance, GDPR jurisdiction determination, and regional analytics.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this order status history record was created in the Silver Layer lakehouse. Represents the data ingestion time, which may differ from the status_change_timestamp (the business event time). Used for data lineage and pipeline monitoring.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `credit_check_result` STRING COMMENT 'Outcome of the credit check performed during this status transition, if applicable. Relevant for transitions involving credit status changes (e.g., order release from credit block). Aligns with SAP SD credit management integration.. Valid values are `PASSED|FAILED|BYPASSED|PENDING|NOT_APPLICABLE`',
    `duration_from_previous_minutes` STRING COMMENT 'Time elapsed in minutes between the previous status transition and this status transition. Enables cycle time analysis for each status stage, bottleneck identification, and order-to-cash process optimization.. Valid values are `^[0-9]+$`',
    `export_control_check_result` STRING COMMENT 'Result of the export control compliance screening performed during this status transition. Relevant for orders involving controlled goods, dual-use items, or shipments to restricted countries. Supports regulatory compliance with EAR, ITAR, and EU dual-use regulations.. Valid values are `CLEARED|BLOCKED|PENDING|NOT_APPLICABLE|ESCALATED`',
    `is_reversal` BOOLEAN COMMENT 'Indicates whether this status transition represents a reversal or rollback of a previous status change (e.g., un-cancelling an order, reversing a delivery confirmation). TRUE when the transition moves the order backward in its lifecycle. Supports exception and error analysis.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this order status history record in the Silver Layer. Supports incremental data processing, change data capture, and audit trail completeness verification.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `new_status` STRING COMMENT 'The order status value assigned as a result of this transition. Captures the to state in the status transition pair. Represents the current status of the order at the point of this event.. Valid values are `DRAFT|PENDING_APPROVAL|APPROVED|BLOCKED|RELEASED|IN_PROCESS|PARTIALLY_DELIVERED|FULLY_DELIVERED|INVOICED|PARTIALLY_INVOICED|COMPLETED|CANCELLED|ON_HOLD|REJECTED|CREDIT_CHECK|ATP_CHECK|PENDING_CONFIRMATION`',
    `notification_sent_flag` BOOLEAN COMMENT 'Indicates whether a customer notification (e.g., order confirmation, shipment notification, cancellation notice) was sent as a result of this status transition. Supports customer communication compliance and SLA tracking.. Valid values are `true|false`',
    `order_type` STRING COMMENT 'Classification of the sales order type at the time of this status transition. Provides context for interpreting the status transition within the appropriate order processing workflow.. Valid values are `STANDARD|RUSH|BLANKET|RETURN|CREDIT_MEMO|DEBIT_MEMO|CONSIGNMENT|INTERCOMPANY|THIRD_PARTY|SAMPLE`',
    `plant_code` STRING COMMENT 'SAP plant code associated with the order at the time of this status transition. Enables plant-level analysis of order status progression, fulfillment performance, and SLA compliance across manufacturing sites.. Valid values are `^[A-Z0-9]{1,10}$`',
    `previous_status` STRING COMMENT 'The order status value immediately before this transition occurred. Captures the from state in the status transition pair. NULL for the initial status record when the order is first created.. Valid values are `DRAFT|PENDING_APPROVAL|APPROVED|BLOCKED|RELEASED|IN_PROCESS|PARTIALLY_DELIVERED|FULLY_DELIVERED|INVOICED|PARTIALLY_INVOICED|COMPLETED|CANCELLED|ON_HOLD|REJECTED|CREDIT_CHECK|ATP_CHECK|PENDING_CONFIRMATION`',
    `release_reason_code` STRING COMMENT 'Standardized code identifying the reason an order block or hold was released during this status transition (e.g., CREDIT_APPROVED, EXPORT_CLEARED, QUALITY_PASSED). NULL when the transition does not involve a release action.. Valid values are `^[A-Z0-9_]{1,20}$`',
    `sales_organization` STRING COMMENT 'SAP sales organization code associated with the order at the time of this status transition. Supports multi-entity reporting and regional order lifecycle analytics across the multinational enterprise.. Valid values are `^[A-Z0-9]{1,10}$`',
    `sequence_number` STRING COMMENT 'Sequential integer representing the chronological order of this status transition within the lifecycle of a given sales order. Enables reconstruction of the full status progression timeline and identification of the current state.. Valid values are `^[0-9]+$`',
    `sla_breach_flag` BOOLEAN COMMENT 'Indicates whether this status transition occurred after the SLA-defined deadline for reaching this status, constituting an SLA breach. TRUE when the transition is late relative to the SLA target. Supports SLA compliance reporting and customer service analytics.. Valid values are `true|false`',
    `sla_target_timestamp` TIMESTAMP COMMENT 'The SLA-defined deadline by which this status transition was expected to occur. Used to calculate SLA compliance and breach duration for order-to-cash process analytics.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `source_system` STRING COMMENT 'Identifies the operational system that originated or triggered the status transition (e.g., SAP SD for order management events, Siemens Opcenter MES for production-driven status changes, Salesforce CRM for customer-initiated changes). Supports IT/OT convergence traceability.. Valid values are `SAP_SD|SAP_MM|MES|SALESFORCE_CRM|MANUAL|INTEGRATION|ARIBA|WMS|TMS`',
    `source_system_transaction_reference` STRING COMMENT 'Native transaction or document identifier from the originating system (e.g., SAP change document number, MES work order ID) that caused this status transition. Enables drill-back to the source system for detailed investigation.',
    `status_change_date` DATE COMMENT 'Calendar date on which the order status transition occurred. Used for day-level reporting, SLA breach detection, and order lifecycle analytics without requiring timestamp precision.. Valid values are `^d{4}-d{2}-d{2}$`',
    `status_change_timestamp` TIMESTAMP COMMENT 'Exact date and time (with timezone) when the order status transition occurred. Critical for SLA compliance tracking, order-to-cash cycle time analysis, and chronological audit trail reconstruction.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `transition_type` STRING COMMENT 'Classifies how the status transition was initiated — whether automatically by system rules (e.g., ATP/CTP check completion), manually by a user, via batch processing, or through system integration. Supports process automation analysis and exception management.. Valid values are `AUTOMATIC|MANUAL|BATCH|INTEGRATION|WORKFLOW_APPROVAL|SYSTEM_TRIGGERED`',
    `workflow_instance_reference` STRING COMMENT 'Identifier of the SAP workflow or business process instance that triggered or processed this status transition. Enables traceability from the status history record back to the originating workflow for process mining and automation analysis.',
    CONSTRAINT pk_status_history PRIMARY KEY(`status_history_id`)
) COMMENT 'Chronological audit trail of all status transitions for a sales order throughout its lifecycle from creation to cash. Captures order reference, previous status, new status, status change timestamp, changed by user, change reason code, system of origin (SAP SD, MES, manual), and any associated blocking or release actions. Supports order lifecycle visibility, SLA compliance tracking, and order-to-cash process analytics. Enables full traceability of order progression.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`order_confirmation` (
    `order_confirmation_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each order confirmation record in the Silver Layer lakehouse. Serves as the primary key for all downstream joins and lineage tracking.',
    `blanket_order_id` BIGINT COMMENT 'Foreign key linking to order.blanket_order. Business justification: Order confirmations may reference the blanket order under which the sales order was placed. The string contract_number is replaced by FK blanket_order_id.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Order confirmations require employee accountability - tracking who approved the order is critical for audit trails, quality control, and resolving disputes in manufacturing order management.',
    `customer_po_id` BIGINT COMMENT 'Foreign key linking to order.customer_po. Business justification: An order confirmation references the customer PO it acknowledges. The string customer_po_number is replaced by FK customer_po_id.',
    `fulfillment_mode_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_mode. Business justification: Order confirmations specify the confirmed fulfillment mode. The string fulfillment_mode is replaced by FK fulfillment_mode_id.',
    `order_quotation_id` BIGINT COMMENT 'Foreign key linking to order.quotation. Business justification: An order confirmation may reference the originating quotation. The string quotation_number is replaced by FK quotation_id.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: An order confirmation is the formal acknowledgment of a specific sales order. The string sales_order_number is replaced by FK sales_order_id.',
    `atp_ctp_check_status` STRING COMMENT 'Result of the Available to Promise (ATP) or Capable to Promise (CTP) availability check performed in SAP S/4HANA prior to issuing the confirmation. Indicates whether confirmed delivery dates are backed by ATP stock availability or CTP production capacity.. Valid values are `atp_confirmed|ctp_confirmed|partial|not_checked|failed`',
    `confirmed_delivery_date` DATE COMMENT 'Committed delivery date communicated to the customer in the confirmation, representing the manufacturers contractual delivery commitment at the header level. Derived from ATP/CTP check results.. Valid values are `^d{4}-d{2}-d{2}$`',
    `confirmed_gross_value` DECIMAL(18,2) COMMENT 'Total confirmed gross value of the order including all taxes and surcharges. Represents the total financial obligation communicated to the customer in the confirmation.. Valid values are `^d+(.d{1,2})?$`',
    `confirmed_net_value` DECIMAL(18,2) COMMENT 'Total confirmed net value of the order as stated in the confirmation document, excluding taxes. Represents the contractual financial commitment. Expressed in the document currency.. Valid values are `^d+(.d{1,2})?$`',
    `confirmed_quantity` DECIMAL(18,2) COMMENT 'Total quantity confirmed by the manufacturer at the header level across all line items. Expressed in the base unit of measure of the order. May differ from ordered quantity if partial confirmation applies.. Valid values are `^d+(.d{1,4})?$`',
    `confirmed_tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount applicable to the confirmed order value, as calculated at the time of confirmation. Includes VAT, GST, or applicable sales tax based on ship-to jurisdiction.. Valid values are `^d+(.d{1,2})?$`',
    `country_of_destination` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the final delivery destination for the confirmed order. Used for export control classification, customs documentation, VAT/GST determination, and REACH/RoHS compliance assessment.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp at which the order confirmation record was first created in the system. Used for audit trail, data lineage, and order-to-cash cycle time analytics.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `credit_status` STRING COMMENT 'Result of the customer credit check performed prior to issuing the confirmation. Approved indicates the order is within the customers credit limit; Blocked indicates a credit hold that must be resolved before fulfillment proceeds.. Valid values are `approved|blocked|released|under_review`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the confirmed order values are expressed (e.g., USD, EUR, GBP, JPY). Supports multi-currency reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `customer_acknowledgment_date` DATE COMMENT 'Date on which the customer formally acknowledged and accepted the order confirmation. Used for contractual binding date determination and SLA compliance measurement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `customer_acknowledgment_status` STRING COMMENT 'Status indicating whether the customer has formally acknowledged receipt and acceptance of the order confirmation. Acknowledged confirms mutual agreement; Rejected triggers order revision workflow; No Response may trigger follow-up SLA.. Valid values are `pending|acknowledged|rejected|no_response`',
    `date` DATE COMMENT 'Calendar date on which the order confirmation was formally issued and sent to the customer. Used for SLA compliance tracking and order-to-cash cycle time reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `delivery_date_deviation_days` STRING COMMENT 'Signed integer representing the difference in calendar days between the confirmed delivery date and the customer-requested delivery date. Negative values indicate early delivery; positive values indicate late delivery. Used for on-time delivery KPI reporting.. Valid values are `^-?d+$`',
    `deviation_description` STRING COMMENT 'Free-text description of any deviations between the original customer order request and the confirmed order terms (e.g., Quantity reduced from 500 to 450 due to material shortage; delivery date shifted by 5 days). Populated only when deviation_flag is TRUE.',
    `deviation_flag` BOOLEAN COMMENT 'Boolean indicator set to TRUE when the confirmed order contains one or more deviations from the original customer order request (e.g., quantity shortfall, delivery date change, price adjustment). Triggers deviation notification workflow.. Valid values are `true|false`',
    `distribution_channel` STRING COMMENT 'SAP distribution channel code indicating how the confirmed order will reach the customer (e.g., direct sales, wholesale, OEM, e-commerce). Influences pricing, output determination, and revenue reporting.. Valid values are `^[A-Z0-9]{2}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign exchange rate applied at the time of confirmation to convert document currency to company code currency. Sourced from SAP S/4HANA exchange rate tables. Required for multi-currency financial consolidation.. Valid values are `^d+(.d{1,6})?$`',
    `export_control_status` STRING COMMENT 'Status of export control compliance review for the confirmed order. Indicates whether the order involves dual-use goods, controlled technology, or restricted end-users requiring export license approval under applicable trade regulations.. Valid values are `not_required|approved|pending_review|blocked|rejected`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code confirmed on the order, defining the transfer of risk and responsibility between manufacturer and customer (e.g., DAP, DDP, FOB, CIF). Critical for logistics, insurance, and export compliance.. Valid values are `^(EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF)$`',
    `incoterms_location` STRING COMMENT 'Named place or port associated with the confirmed Incoterms code (e.g., Rotterdam for FOB Rotterdam, Customer Warehouse Chicago for DAP). Required to fully define the delivery obligation.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the order confirmation record. Supports change data capture (CDC) in the Databricks Silver Layer pipeline and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `method` STRING COMMENT 'Channel or medium through which the order confirmation was transmitted to the customer (e.g., email, EDI transaction set 855, customer portal, fax, printed document, or API). Supports communication audit and EDI compliance tracking.. Valid values are `email|edi|portal|fax|print|api`',
    `number` STRING COMMENT 'Business-facing alphanumeric identifier for the order confirmation document, as generated by SAP S/4HANA SD. Communicated to the customer as the formal reference number on the confirmation document.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `ordered_quantity` DECIMAL(18,2) COMMENT 'Total quantity originally requested by the customer on the sales order. Retained on the confirmation to enable quantity deviation analysis and partial fulfillment tracking.. Valid values are `^d+(.d{1,4})?$`',
    `payment_terms_code` STRING COMMENT 'SAP payment terms key confirmed on the order (e.g., NT30 for net 30 days, 2/10NT30 for 2% discount if paid within 10 days). Defines the cash discount and due date calculation for accounts receivable.. Valid values are `^[A-Z0-9]{2,10}$`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility responsible for fulfilling and shipping the confirmed order. Determines production scheduling, inventory sourcing, and shipping point.. Valid values are `^[A-Z0-9]{4}$`',
    `quantity_unit_of_measure` STRING COMMENT 'Unit of measure in which confirmed and ordered quantities are expressed (e.g., EA for each, KG for kilogram, M for meter, PC for piece). Aligned with SAP base unit of measure codes.. Valid values are `^[A-Z]{2,10}$`',
    `requested_delivery_date` DATE COMMENT 'Original delivery date requested by the customer on the sales order. Retained on the confirmation to enable deviation analysis between customer request and manufacturer commitment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sales_organization` STRING COMMENT 'SAP sales organization code responsible for the confirmed order, representing the legal entity or regional sales unit. Drives revenue recognition, pricing, and financial reporting allocation.. Valid values are `^[A-Z0-9]{4}$`',
    `shipping_point` STRING COMMENT 'SAP shipping point code from which the confirmed order will be dispatched. Determines the physical loading dock, carrier assignment, and outbound logistics routing.. Valid values are `^[A-Z0-9]{4}$`',
    `status` STRING COMMENT 'Current lifecycle status of the order confirmation document. Issued indicates the confirmation has been sent; Acknowledged indicates the customer has formally accepted; Superseded indicates a revised confirmation replaced this one; Cancelled indicates the confirmation was voided.. Valid values are `draft|issued|acknowledged|superseded|cancelled`',
    `superseded_by_confirmation_number` STRING COMMENT 'Confirmation number of the revised confirmation that replaced this record when status is Superseded. Enables version chain traceability for audit and dispute resolution purposes.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone offset) at which the order confirmation was generated and dispatched. Supports audit trail requirements and SLA measurement at sub-day granularity.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `version_number` STRING COMMENT 'Sequential version number of the order confirmation document. Incremented each time a revised confirmation is issued due to order amendments, deviations, or customer-requested changes. Version 1 is the original confirmation.. Valid values are `^[1-9]d*$`',
    CONSTRAINT pk_order_confirmation PRIMARY KEY(`order_confirmation_id`)
) COMMENT 'Formal order acknowledgment and confirmation document sent to the customer after a sales order is validated, ATP/CTP-checked, and accepted. Captures confirmation number, confirmation date, confirmed delivery dates per line, confirmed quantities, confirmed pricing, any deviations from original order request, confirmation method (email, EDI, portal), customer acknowledgment status, and linked sales order reference. Serves as the contractual commitment record between manufacturer and customer.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`atp_commitment` (
    `atp_commitment_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each ATP/CTP commitment record in the Silver Layer lakehouse. Serves as the primary key for all downstream joins and lineage tracking.',
    `fulfillment_mode_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_mode. Business justification: ATP commitments are mode-specific (MTS uses stock ATP, MTO uses CTP). The string fulfillment_mode is replaced by FK fulfillment_mode_id.',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: ATP commitments are made at the order line item level. The string sales_order_item is replaced by FK order_line_item_id.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: ATP/CTP commitment records are generated during order entry for a specific sales order. The string sales_order_number is replaced by FK sales_order_id.',
    `schedule_line_id` BIGINT COMMENT 'Foreign key linking to order.order_schedule_line. Business justification: ATP commitments are linked to specific schedule lines for delivery confirmation. The string schedule_line_number is replaced by FK order_schedule_line_id.',
    `atp_quantity` DECIMAL(18,2) COMMENT 'Net ATP quantity calculated by the SAP ATP engine at the time of the check, representing the uncommitted available stock after accounting for existing confirmed orders, planned receipts, and safety stock. Negative values indicate over-commitment.. Valid values are `^-?[0-9]+(.[0-9]{1,4})?$`',
    `backorder_quantity` DECIMAL(18,2) COMMENT 'Quantity that could not be confirmed for the requested delivery date and is placed on backorder for future fulfillment. Calculated as requested_quantity minus confirmed_quantity. Critical for backlog management and customer communication.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `check_timestamp` TIMESTAMP COMMENT 'Date and time when the ATP/CTP availability check was executed in SAP S/4HANA. Critical for audit trails, commitment versioning, and identifying stale commitments that may need re-evaluation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `checking_group` STRING COMMENT 'SAP availability checking group assigned to the material master, controlling the scope of the availability check (e.g., individual requirements vs. collective requirements). Works in conjunction with the checking rule.. Valid values are `^[A-Z0-9]{1,2}$`',
    `checking_rule` STRING COMMENT 'SAP checking rule code applied during the ATP/CTP availability check. Determines which stock categories, planned receipts, and replenishment elements are considered in the availability calculation (e.g., A for sales order check, B for delivery check).. Valid values are `^[A-Z0-9]{1,4}$`',
    `commitment_number` STRING COMMENT 'Business-facing alphanumeric identifier for the ATP/CTP commitment record as assigned by the SAP S/4HANA ATP engine. Used for cross-referencing with order management and logistics teams.. Valid values are `^[A-Z0-9-]{1,30}$`',
    `commitment_type` STRING COMMENT 'Indicates whether the delivery promise was generated via Available-to-Promise (ATP) logic based on existing stock and planned receipts, or Capable-to-Promise (CTP) logic based on production capacity and lead time feasibility.. Valid values are `ATP|CTP`',
    `confirmation_timestamp` TIMESTAMP COMMENT 'Date and time when the ATP/CTP commitment was formally confirmed and saved to the sales order schedule line. Marks the point at which the delivery promise becomes binding for order fulfillment planning.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `confirmed_delivery_date` DATE COMMENT 'Delivery date confirmed by the ATP/CTP engine based on available stock, planned receipts, or production capacity. May differ from the requested delivery date when stock is insufficient or capacity is constrained.. Valid values are `^d{4}-d{2}-d{2}$`',
    `confirmed_quantity` DECIMAL(18,2) COMMENT 'Quantity confirmed as available or producible by the ATP/CTP engine. May be less than the requested quantity in cases of partial availability or capacity constraints.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or shipping point from which the committed delivery will originate. Supports multi-country operations, export control checks, and regulatory compliance reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the ATP/CTP commitment record was first created in the source system (SAP S/4HANA). Used for audit trail, data lineage, and SLA compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `cumulative_atp_quantity` DECIMAL(18,2) COMMENT 'Cumulative ATP quantity across all future planning periods at the time of the check. Used in time-phased ATP logic to identify the earliest period with sufficient cumulative availability to fulfill the requested quantity.. Valid values are `^-?[0-9]+(.[0-9]{1,4})?$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code applicable to any financial values associated with the commitment (e.g., penalty clauses, commitment fees). Supports multi-currency global operations.. Valid values are `^[A-Z]{3}$`',
    `delivery_priority` STRING COMMENT 'SAP delivery priority code assigned to the order item, influencing the sequence in which ATP quantities are allocated during backorder processing and rescheduling runs. Higher priority orders receive preferential ATP allocation.. Valid values are `^[0-9]{1,2}$`',
    `distribution_channel` STRING COMMENT 'SAP distribution channel code indicating the route through which the product reaches the customer (e.g., direct sales, wholesale, e-commerce). Influences ATP checking rule selection and delivery scheduling.. Valid values are `^[A-Z0-9]{1,2}$`',
    `earliest_delivery_date` DATE COMMENT 'Earliest date on which the full requested quantity could be delivered, as calculated by the ATP/CTP engine considering replenishment lead times, production scheduling, and transportation time. Used for alternative delivery date proposals.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_timestamp` TIMESTAMP COMMENT 'Date and time after which the ATP/CTP commitment is no longer valid and must be re-evaluated. Relevant for quotation-based commitments and time-limited availability holds.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the ATP/CTP commitment record was last updated in the source system. Tracks changes to confirmed quantities, delivery dates, or commitment status throughout the order lifecycle.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `material_description` STRING COMMENT 'Short description of the material or product as maintained in the SAP material master. Provides human-readable context for the commitment record without requiring a join to the material master.',
    `material_number` STRING COMMENT 'SAP material number (SKU) for which the ATP/CTP commitment was generated. Identifies the specific product or component being promised for delivery.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `mrp_area` STRING COMMENT 'SAP MRP area used to segment inventory planning for the ATP check. Enables sub-plant level availability checks for materials managed across multiple MRP planning segments (e.g., consignment stock, subcontractor stock).. Valid values are `^[A-Z0-9]{1,10}$`',
    `partial_delivery_allowed` BOOLEAN COMMENT 'Indicates whether the customer has agreed to accept partial deliveries for this order item. When true, the ATP engine may confirm a quantity less than the requested quantity with a valid delivery date rather than rejecting the commitment.. Valid values are `true|false`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility where the ATP/CTP check was performed and from which the committed delivery will be sourced.. Valid values are `^[A-Z0-9]{1,4}$`',
    `receipt_element_number` STRING COMMENT 'Document number of the planned receipt element (e.g., planned order number, purchase order number, production order number) used to support the CTP commitment. Enables drill-down from the commitment to the underlying supply plan.. Valid values are `^[A-Z0-9]{1,20}$`',
    `receipt_element_type` STRING COMMENT 'Type of planned receipt element (planned order, purchase order, production order, stock transfer order, scheduling agreement) that was used by the CTP engine to confirm the delivery date when current stock was insufficient.. Valid values are `planned_order|purchase_order|production_order|stock_transfer|scheduling_agreement|none`',
    `replenishment_lead_time_days` STRING COMMENT 'Number of calendar days required to replenish the material through production or procurement, as used in the CTP calculation. Determines the earliest feasible delivery date when current stock is insufficient.. Valid values are `^[0-9]{1,5}$`',
    `requested_delivery_date` DATE COMMENT 'Customer-requested delivery date for the order item. The ATP/CTP engine evaluates stock availability and production capacity against this date to generate the commitment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `requested_quantity` DECIMAL(18,2) COMMENT 'Customer-requested order quantity for which the ATP/CTP check was performed. Represents the demand quantity submitted by the customer before availability confirmation.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `sales_organization` STRING COMMENT 'SAP sales organization code responsible for the sales order associated with this commitment. Defines the legal entity and regional sales structure under which the delivery promise is made.. Valid values are `^[A-Z0-9]{1,4}$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this ATP/CTP commitment record was sourced. Supports data lineage, audit trails, and multi-system reconciliation in the Silver Layer lakehouse.. Valid values are `SAP_S4HANA|LEGACY|MANUAL`',
    `status` STRING COMMENT 'Current lifecycle status of the ATP/CTP commitment record. Drives order fulfillment workflows and delivery promise accuracy reporting. Superseded indicates the commitment was replaced by a revised check.. Valid values are `open|confirmed|partially_confirmed|rejected|cancelled|expired|superseded`',
    `stock_category` STRING COMMENT 'Category of stock considered in the ATP check. Determines which inventory types (unrestricted, quality inspection, blocked, consignment, in-transit) were included in the availability calculation per the checking rule configuration.. Valid values are `unrestricted|quality_inspection|blocked|restricted|consignment|in_transit`',
    `storage_location` STRING COMMENT 'SAP storage location within the plant from which the committed stock will be sourced or reserved. Relevant for warehouse-level inventory allocation and pick/pack planning.. Valid values are `^[A-Z0-9]{1,4}$`',
    `unit_of_measure` STRING COMMENT 'Base unit of measure for the requested, confirmed, and backorder quantities (e.g., EA for each, KG for kilogram, M for meter, PC for piece). Aligns with SAP material master base UoM.. Valid values are `^[A-Z]{1,6}$`',
    CONSTRAINT pk_atp_commitment PRIMARY KEY(`atp_commitment_id`)
) COMMENT 'Available-to-Promise (ATP) and Capable-to-Promise (CTP) commitment records generated during order entry to confirm product availability and delivery feasibility. Captures commitment type (ATP or CTP), requested quantity, confirmed quantity, requested delivery date, confirmed delivery date, plant, storage location, MRP area, checking rule applied, backorder quantity, replenishment lead time, and commitment status. Critical for delivery promise accuracy in MTO, MTS, and ATO fulfillment modes. Sourced from SAP S/4HANA ATP/CTP engine.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`order_configuration` (
    `order_configuration_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a specific product configuration captured at the order line item level within SAP S/4HANA Variant Configuration (VC).',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Complex equipment orders (automation systems, control panels) require detailed configuration records. Engineering teams reference base equipment to apply customer-specific configurations and options.',
    `fulfillment_mode_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_mode. Business justification: Order configurations are relevant to specific fulfillment modes (e.g., ETO requires configuration). The string fulfillment_mode is replaced by FK fulfillment_mode_id.',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: Product configuration options are captured at the order line item level. The string sales_order_line_item_number is replaced by FK order_line_item_id.',
    `product_variant_id` BIGINT COMMENT 'Foreign key linking to engineering.product_variant. Business justification: Configure-to-order manufacturing requires linking customer-specific configurations to engineering-defined product variants. Order fulfillment uses this to determine exact build specifications.',
    `base_material_number` STRING COMMENT 'SAP material number of the configurable base product (e.g., automation system, drive system, switchgear) from which variant characteristics are selected. Corresponds to the configurable material master in SAP MM.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `bom_explosion_reference` STRING COMMENT 'Reference identifier linking this configuration to the exploded Bill of Materials (BOM) generated by SAP Variant Configuration, used to identify the specific component set required for production of this configured product.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `bom_explosion_status` STRING COMMENT 'Current status of the BOM explosion process for this configuration, indicating whether the variant-specific component list has been successfully generated, is pending, in progress, or has encountered errors.. Valid values are `pending|in_progress|completed|failed|not_required`',
    `certification_variant` STRING COMMENT 'Customer-selected regional or industry certification variant for the configured product, determining the applicable regulatory marking and compliance documentation (e.g., CE for EU, UL for North America, ATEX for explosive atmospheres).. Valid values are `CE|UL|CSA|ATEX|IECEx|CCC|EAC|none|multiple`',
    `characteristic_profile_code` STRING COMMENT 'Identifier of the SAP classification characteristic profile or configuration profile used to define the set of selectable variant characteristics for this product model, enabling traceability to the configuration knowledge base.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `color_finish` STRING COMMENT 'Customer-selected color or surface finish variant for the configured product enclosure or housing (e.g., RAL 7035 light grey, RAL 9005 black), applicable for panel-mounted and standalone enclosure products.',
    `communication_protocol` STRING COMMENT 'Customer-selected industrial communication protocol variant for the configured product, determining the fieldbus or industrial Ethernet interface installed (e.g., PROFINET for Siemens ecosystems, EtherNet/IP for Rockwell environments).. Valid values are `PROFINET|PROFIBUS|EtherNet_IP|Modbus_TCP|Modbus_RTU|CANopen|DeviceNet|EtherCAT|OPC_UA|none|other`',
    `control_type` STRING COMMENT 'Customer-selected motor or drive control method variant (e.g., scalar V/f control, sensorless vector, closed-loop vector with encoder, servo control), defining the control algorithm and hardware configuration.. Valid values are `scalar_vf|vector_sensorless|vector_encoder|servo|direct_torque|soft_starter|direct_online|star_delta|other`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the product configuration record was first created in SAP S/4HANA Variant Configuration, marking the start of the configuration lifecycle.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code applicable to the configuration price uplift and any configuration-specific pricing, aligned with the sales order currency.. Valid values are `^[A-Z]{3}$`',
    `ecn_reference` STRING COMMENT 'Reference to the Engineering Change Notice (ECN) or Engineering Change Order (ECO) that triggered a revision to this configuration, providing traceability between order configurations and engineering change management.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `enclosure_type` STRING COMMENT 'Customer-selected enclosure protection class for the configured product, defining the degree of protection against ingress of solid objects and liquids (IP rating per IEC 60529 or NEMA standard).. Valid values are `IP20|IP44|IP54|IP65|IP66|IP67|NEMA1|NEMA4|NEMA4X|NEMA12|open|other`',
    `export_control_classification` STRING COMMENT 'Export control classification code for the configured product variant, determining applicable export licensing requirements. Configurations with advanced communication protocols or safety features may carry different export classifications than the base product.. Valid values are `EAR99|ECCN_3A001|ECCN_3A002|ECCN_3B001|ECCN_4A001|ECCN_5A002|AL_N|AL_controlled|not_classified`',
    `frame_size` STRING COMMENT 'Customer-selected mechanical frame size designation for the configured product (e.g., FSA, FSB, FSC for drive systems; IEC frame sizes 63 to 355 for motors), determining physical dimensions and mounting footprint.. Valid values are `^[A-Z]{1,5}[0-9]{0,3}$`',
    `input_frequency` STRING COMMENT 'Customer-selected mains supply frequency variant for the configured product (50Hz for European/Asian markets, 60Hz for North American markets, or universal 50/60Hz), determining hardware compatibility.. Valid values are `50Hz|60Hz|50_60Hz`',
    `is_customer_approved` BOOLEAN COMMENT 'Indicates whether the customer has formally approved the final product configuration, required for ETO and ATO orders before production release. Supports PPAP and FAI processes.. Valid values are `true|false`',
    `is_feasibility_confirmed` BOOLEAN COMMENT 'Indicates whether engineering feasibility of the selected configuration has been confirmed by the engineering team, particularly relevant for ETO orders where custom configurations require technical review before production commitment.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the product configuration record, used for change tracking, audit compliance, and incremental data extraction in the Silver layer pipeline.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lead_time_days` STRING COMMENT 'Manufacturing or procurement lead time in calendar days specific to this product configuration, accounting for variant-specific components, special certifications, or ETO engineering effort required.. Valid values are `^[0-9]{1,4}$`',
    `motor_size` STRING COMMENT 'Customer-selected motor power rating characteristic for drive systems and motor-integrated products (e.g., 0.75kW, 7.5kW, 110kW), applicable when the configurable product includes a motor or is a motor drive.. Valid values are `^[0-9]+(.[0-9]+)?s?(W|kW|HP)$`',
    `number` STRING COMMENT 'Business-facing alphanumeric identifier for the product configuration as assigned in SAP S/4HANA Variant Configuration, used for cross-referencing with production and engineering systems.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `output_current_rating` STRING COMMENT 'Customer-selected nominal output current rating for drive systems and power electronics products (e.g., 3.0A, 18.5A, 250A), a key sizing characteristic used for BOM explosion and component selection.. Valid values are `^[0-9]+(.[0-9]+)?s?A$`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility designated to produce this configured product, determined by the variant characteristics and available production capabilities.. Valid values are `^[A-Z0-9]{4}$`',
    `ppap_required` BOOLEAN COMMENT 'Indicates whether a Production Part Approval Process (PPAP) submission is required for this configuration before production can commence, typically mandated for new configurations or significant variant changes.. Valid values are `true|false`',
    `price_uplift` DECIMAL(18,2) COMMENT 'Additional price delta applied to the base product price due to the selected variant characteristics and options (e.g., premium communication protocol, ATEX certification, safety integration), expressed in the order currency.. Valid values are `^-?[0-9]+(.[0-9]{1,4})?$`',
    `product_category` STRING COMMENT 'High-level product category classifying the configurable product type, used for routing configurations to the appropriate engineering and production teams.. Valid values are `automation_system|drive_system|switchgear|motor|control_panel|sensor|plc|hmi|power_supply|other`',
    `product_model` STRING COMMENT 'Commercial product model or product family name of the configurable product (e.g., SINAMICS G120, SIRIUS 3RV, SENTRON 3VA), as defined in the product catalog and PLM system.',
    `quantity` DECIMAL(18,2) COMMENT 'Quantity of units to be produced or assembled with this specific configuration, as ordered by the customer on the associated sales order line item.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `quantity_unit` STRING COMMENT 'Unit of measure for the configured quantity (e.g., EA for each, PC for piece, SET for set, KIT for kit), aligned with SAP base unit of measure for the material.. Valid values are `EA|PC|SET|KIT|M|KG|L`',
    `reach_rohs_compliant` BOOLEAN COMMENT 'Indicates whether the configured product variant complies with EU REACH (Registration, Evaluation, Authorisation and Restriction of Chemicals) and RoHS (Restriction of Hazardous Substances) directives, based on the selected components and materials.. Valid values are `true|false`',
    `released_timestamp` TIMESTAMP COMMENT 'Timestamp when the product configuration was formally released for production, triggering BOM explosion and production order creation in SAP S/4HANA PP and Siemens Opcenter MES.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `safety_integrity_level` STRING COMMENT 'Customer-selected functional safety integrity level for the configured product, indicating the required safety performance level per IEC 62061 (SIL) or ISO 13849 (Performance Level), applicable for safety-integrated drives and automation systems.. Valid values are `none|SIL1|SIL2|SIL3|PLc|PLd|PLe`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this configuration record was sourced, supporting data lineage and audit traceability in the Databricks Silver layer.. Valid values are `SAP_S4HANA|TEAMCENTER|OPCENTER|MANUAL`',
    `status` STRING COMMENT 'Current lifecycle status of the product configuration, indicating whether it is being drafted, under engineering review, validated, released for production, superseded by a newer version, or cancelled.. Valid values are `draft|in_review|valid|released|superseded|cancelled|locked`',
    `validity_end_date` DATE COMMENT 'Date after which this product configuration is no longer valid for new production orders, typically set when superseded by an Engineering Change Notice (ECN) or product discontinuation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `validity_start_date` DATE COMMENT 'Date from which this product configuration is considered valid and can be used for production planning and BOM explosion, aligned with engineering change effectivity dates.. Valid values are `^d{4}-d{2}-d{2}$`',
    `version` STRING COMMENT 'Version number of the product configuration, incremented when customer-selected variant characteristics are revised or updated during the order lifecycle.. Valid values are `^[0-9]{1,3}(.[0-9]{1,3})?$`',
    `voltage_rating` STRING COMMENT 'Customer-selected voltage rating characteristic for the configured product (e.g., 400V, 690V, 1.1kV), a key variant characteristic for electrical automation and switchgear products.. Valid values are `^[0-9]+(.[0-9]+)?s?(V|kV)$`',
    `work_center` STRING COMMENT 'SAP work center or production cell designated for manufacturing this configuration, derived from the variant characteristics and routing rules in the Bill of Process (BoP).. Valid values are `^[A-Z0-9-]{1,20}$`',
    CONSTRAINT pk_order_configuration PRIMARY KEY(`order_configuration_id`)
) COMMENT 'Product configuration options and variant selections captured at the order line item level for configurable products such as automation systems, drive systems, and switchgear. Captures configuration ID, linked order line item, product model/base material, selected variant characteristics (voltage rating, enclosure type, communication protocol, motor size, control type), configuration validity, BOM explosion reference, and configuration status. Supports ETO and ATO fulfillment modes where customer-specific configurations drive production. Sourced from SAP S/4HANA variant configuration (VC).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`pricing_condition` (
    `pricing_condition_id` BIGINT COMMENT 'Unique surrogate identifier for each pricing condition record in the silver layer lakehouse. Serves as the primary key for the pricing_condition data product.',
    `discount_structure_id` BIGINT COMMENT 'Foreign key linking to sales.discount_structure. Business justification: Pricing conditions apply discount structures (volume, promotional, customer-specific) to order lines. Order management calculates final prices using defined discount rules and thresholds.',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: Pricing conditions are applied at the line item level. The polymorphic string document_item_number is replaced by nullable FK order_line_item_id.',
    `order_quotation_id` BIGINT COMMENT 'Foreign key linking to order.quotation. Business justification: Pricing conditions are also applied to quotations. A nullable FK quotation_id is added (null when condition applies to a sales order). document_number already removed via sales_order_id link.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Pricing conditions are applied to sales orders. The polymorphic string document_number is replaced by nullable FK sales_order_id (null when condition applies to a quotation instead).',
    `special_pricing_request_id` BIGINT COMMENT 'Foreign key linking to sales.special_pricing_request. Business justification: Approved special pricing requests become pricing conditions on orders. Sales ops links exceptions to original approval requests for audit compliance and margin tracking.',
    `tax_code_id` BIGINT COMMENT 'Foreign key linking to finance.tax_code. Business justification: Pricing conditions must apply correct tax codes based on customer location and product taxability. Tax compliance requires accurate tax calculation on every order line.',
    `access_sequence_code` STRING COMMENT 'Code identifying the access sequence used to find the applicable condition record. The access sequence defines the hierarchy of search keys (customer/material, price list, material group) used in pricing determination.',
    `calculation_type` STRING COMMENT 'Defines the mathematical method used to calculate the condition value: fixed monetary amount, percentage of a base, quantity-based rate, weight-based rate, volume-based rate, formula-driven, or group condition. Directly maps to SAP KONV-KRECH.. Valid values are `fixed_amount|percentage|quantity_based|weight_based|volume_based|formula|group_condition`',
    `condition_base_value` DECIMAL(18,2) COMMENT 'The base amount upon which the condition rate is applied to derive the condition value. For percentage-based conditions, this is the subtotal from the preceding pricing step.',
    `condition_category` STRING COMMENT 'High-level classification of the pricing condition into business categories: price (base price), discount (reduction), surcharge (addition), freight (logistics cost), tax (statutory levy), rebate, or bonus. Enables aggregated pricing analysis.. Valid values are `price|discount|surcharge|freight|tax|rebate|bonus|other`',
    `condition_exclusion_group` STRING COMMENT 'Identifies the exclusion group to which this condition belongs. Conditions in the same exclusion group are mutually exclusive; only the most favorable or highest-priority condition is applied, preventing double discounting.',
    `condition_inactive_reason` STRING COMMENT 'Reason code explaining why a pricing condition is inactive or was deactivated. Supports audit trail requirements and pricing dispute resolution in commercial transactions.. Valid values are `pricing_error|manual_deletion|superseded|expired|blocked_by_exclusion|other`',
    `condition_origin` STRING COMMENT 'Indicates how the pricing condition was determined: automatically by the pricing engine, manually entered by a sales representative, derived from a contract, applied from a promotion, or set as an intercompany/transfer price.. Valid values are `automatic|manual|contract_based|promotion|intercompany|transfer_price`',
    `condition_quantity` DECIMAL(18,2) COMMENT 'The quantity to which the condition rate applies. For per-unit pricing conditions, this is the reference quantity (e.g., price per 100 units). Directly maps to SAP KONV-KPEIN.',
    `condition_rate` DECIMAL(18,2) COMMENT 'The rate or percentage used to compute the condition value before application to the base amount. For percentage discounts this is the discount rate; for per-unit surcharges this is the per-unit rate.',
    `condition_record_number` STRING COMMENT 'Business key identifying the pricing condition record as sourced from SAP S/4HANA SD pricing tables (KONV/KONP). Used to trace the condition back to the originating ERP record.',
    `condition_status` STRING COMMENT 'Current lifecycle status of the pricing condition record: active (applied in pricing), inactive (not applied), deleted (removed from document), blocked (temporarily suspended), or statistical (informational only, not included in net value).. Valid values are `active|inactive|deleted|blocked|statistical`',
    `condition_type_code` STRING COMMENT 'SAP SD condition type code identifying the nature of the pricing element (e.g., PR00 for base price, K007 for customer discount, KF00 for freight, MWST for tax). Drives pricing procedure determination logic.',
    `condition_type_name` STRING COMMENT 'Human-readable description of the condition type (e.g., Price List, Customer-Specific Discount, Freight Surcharge, Value Added Tax). Supports business reporting and price transparency.',
    `condition_unit` STRING COMMENT 'Unit of measure associated with the condition rate (e.g., EA for each, KG for kilogram, PC for piece, TO for metric ton). Relevant for quantity- or weight-based pricing conditions.',
    `condition_value` DECIMAL(18,2) COMMENT 'The monetary or percentage value of the pricing condition as applied to the sales document. For fixed-amount conditions this is the absolute value; for percentage conditions this is the computed monetary result.',
    `contract_reference_number` STRING COMMENT 'Reference number of the sales contract or outline agreement from which this pricing condition was derived. Enables traceability of contract-based pricing and supports contract compliance auditing.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the pricing condition record was first created in the source system. Supports audit trail, data lineage, and order-to-cash process timeline analysis.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the condition value is expressed (e.g., USD, EUR, GBP). Supports multi-currency operations across global manufacturing entities.. Valid values are `^[A-Z]{3}$`',
    `customer_price_group` STRING COMMENT 'Customer pricing group classification used in pricing determination. Groups customers with similar pricing entitlements (e.g., key accounts, standard customers, government) to apply consistent pricing policies.',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether this condition type is mandatory in the pricing procedure. Mandatory conditions must be present for the document to be processed; missing mandatory conditions trigger pricing errors.. Valid values are `true|false`',
    `is_statistical` BOOLEAN COMMENT 'Indicates whether this condition is purely statistical (informational) and does not affect the net document value. Statistical conditions are used for reporting and analysis without impacting the price charged to the customer.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the pricing condition record. Used for change detection, incremental data loading, and pricing audit trail maintenance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `manual_entry_allowed` BOOLEAN COMMENT 'Indicates whether the condition value can be manually overridden by a sales representative. Controls pricing governance and ensures compliance with approved pricing policies.. Valid values are `true|false`',
    `material_price_group` STRING COMMENT 'Material pricing group classification used in pricing determination. Groups products with similar pricing characteristics (e.g., automation components, electrification products, spare parts) for efficient condition record maintenance.',
    `price_list_type` STRING COMMENT 'Identifies the price list category from which this condition was sourced (e.g., wholesale, retail, OEM, distributor, export). Supports differentiated pricing strategies across customer segments in industrial manufacturing.',
    `pricing_date` DATE COMMENT 'The reference date used to determine which pricing condition records are applicable to the sales document. Typically the order creation date or a contractually agreed pricing reference date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `pricing_procedure_code` STRING COMMENT 'Code identifying the pricing procedure (calculation schema) under which this condition is determined. Pricing procedures define the sequence and logic for price determination in SAP SD.',
    `pricing_procedure_counter` STRING COMMENT 'Counter within a pricing procedure step used to differentiate multiple conditions at the same step. Supports complex pricing schemas with multiple conditions at identical step positions.. Valid values are `^[0-9]{1,3}$`',
    `pricing_procedure_step` STRING COMMENT 'Sequential step number within the pricing procedure at which this condition type is evaluated. Determines the order of price calculation and the base amount for percentage-based conditions.. Valid values are `^[0-9]{1,4}$`',
    `rebate_agreement_number` STRING COMMENT 'Reference to the rebate agreement under which this condition was generated. Applicable for rebate accrual conditions that accumulate over a period and are settled at agreement end.',
    `scale_basis_type` STRING COMMENT 'Defines the dimension on which pricing scales are applied: quantity (volume discount tiers), value (revenue-based tiers), weight, volume, or no scale. Enables tiered pricing models common in industrial manufacturing contracts.. Valid values are `quantity|value|weight|volume|none`',
    `scale_quantity` DECIMAL(18,2) COMMENT 'The quantity threshold at which this pricing scale level applies. Used in conjunction with scale_basis_type to determine the applicable tier for volume-based pricing.',
    `scale_value` DECIMAL(18,2) COMMENT 'The monetary value threshold at which this pricing scale level applies. Used for value-based tiered pricing where discounts or rates change based on order value brackets.',
    `tax_classification_code` STRING COMMENT 'Tax classification code associated with tax-type conditions (e.g., VAT, GST, sales tax). Identifies the applicable tax category for statutory reporting and compliance with regional tax regulations.',
    `tax_jurisdiction_code` STRING COMMENT 'Geographic tax jurisdiction code identifying the applicable tax authority for this condition. Critical for multinational operations where tax rates vary by country, state, or region.',
    `valid_from_date` DATE COMMENT 'The date from which this pricing condition record is valid and applicable to sales transactions. Supports time-bound pricing agreements and seasonal pricing strategies.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'The date until which this pricing condition record remains valid. After this date the condition expires and is no longer applied in automatic pricing determination.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_pricing_condition PRIMARY KEY(`pricing_condition_id`)
) COMMENT 'Pricing condition records applied to sales orders and quotations capturing the detailed pricing determination logic. Captures condition type (price list, customer-specific price, discount, surcharge, freight, tax), condition value, currency, calculation type, scale basis, validity period, pricing procedure step, and condition origin (manual, automatic, contract-based). Enables full price transparency and audit trail for industrial manufacturing commercial transactions. Sourced from SAP S/4HANA SD pricing (KONV/KONP).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`order_block` (
    `order_block_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for each order block record in the silver layer lakehouse. Serves as the primary key for the order_block data product.',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: Blocks can be applied at the line item level. The string line_item_number is replaced by FK order_line_item_id (nullable when block applies to entire order).',
    `quality_notification_id` BIGINT COMMENT 'Foreign key linking to quality.quality_notification. Business justification: Orders are automatically blocked when quality notifications are raised for defects or non-conformances. Prevents shipment of suspect material until quality clearance is obtained.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Order blocks are applied to specific sales orders to prevent fulfillment or invoicing. The string sales_order_number is replaced by FK sales_order_id.',
    `applied_by` STRING COMMENT 'User ID or system process identifier that applied the block. Supports audit trail requirements and accountability tracking for credit control and compliance workflows.',
    `applied_by_department` STRING COMMENT 'Organizational department responsible for applying the block (e.g., Credit Control, Export Compliance, Quality Assurance). Used for workload analysis and escalation routing.',
    `applied_by_name` STRING COMMENT 'Full name of the user or system process that applied the block, providing a human-readable audit trail for order management reviews and compliance reporting.',
    `applied_timestamp` TIMESTAMP COMMENT 'Date and time when the order block was applied to the sales order. Used for SLA tracking, aging analysis of blocked orders, and audit compliance.',
    `capa_reference` STRING COMMENT 'Reference identifier for the Corrective and Preventive Action (CAPA) record associated with a quality hold block. Supports quality management traceability and regulatory compliance documentation.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the ship-to or sold-to party associated with the blocked order. Used for export control jurisdiction determination, regional compliance reporting, and GDPR/CCPA applicability assessment.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the order block record was first created in the source system (SAP S/4HANA SD). Used for data lineage, audit trail, and silver layer ingestion tracking.',
    `credit_control_area` STRING COMMENT 'SAP credit control area code responsible for managing the credit block on this order. Defines the organizational unit that owns the credit risk assessment and release authorization for the blocked order.',
    `credit_exposure_amount` DECIMAL(18,2) COMMENT 'The total credit exposure amount associated with the customer at the time the credit block was applied, expressed in the order currency. Used by credit controllers to assess risk and determine release authorization level. Applicable primarily to credit_block type.',
    `credit_limit_amount` DECIMAL(18,2) COMMENT 'The approved credit limit for the customer at the time the credit block was applied. Compared against credit exposure to determine block trigger and release eligibility.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the credit exposure and credit limit amounts recorded on this block record (e.g., USD, EUR, GBP). Supports multi-currency global operations.. Valid values are `^[A-Z]{3}$`',
    `customer_notification_timestamp` TIMESTAMP COMMENT 'Date and time when the customer was notified of the order block. Supports SLA compliance tracking and customer service audit trails.',
    `customer_notified` BOOLEAN COMMENT 'Indicates whether the customer has been formally notified of the order block and its reason. Supports customer communication tracking and SLA compliance for order management and customer service workflows.. Valid values are `true|false`',
    `escalated_to` STRING COMMENT 'User ID or role to which the block was escalated for review and release authorization. Supports escalation workflow tracking and SLA compliance.',
    `escalation_timestamp` TIMESTAMP COMMENT 'Date and time when the block was escalated to a higher authorization level due to aging, financial exposure threshold breach, or customer priority. Null if no escalation has occurred.',
    `expected_release_date` DATE COMMENT 'Anticipated date by which the block is expected to be resolved and released, based on credit review schedules, export license processing timelines, or quality inspection completion dates. Used for delivery commitment and customer communication planning.',
    `export_control_classification` STRING COMMENT 'Export Control Classification Number or equivalent classification code associated with the blocked order, applicable when block_type is export_control_block. Used to document the regulatory basis for the export hold and support trade compliance audit trails.',
    `export_license_number` STRING COMMENT 'The export license or authorization number obtained to release an export control block. Populated when the block is released following receipt of the required trade compliance documentation.',
    `is_recurring_block` BOOLEAN COMMENT 'Indicates whether this customer or order has experienced the same block type previously, flagging repeat offenders for enhanced credit review, compliance scrutiny, or process improvement initiatives.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the order block record was last updated in the source system. Supports incremental data loading, change data capture, and audit trail requirements in the Databricks silver layer.',
    `ncr_number` STRING COMMENT 'Reference to the Non-Conformance Report (NCR) that triggered a quality hold block on the sales order. Links the order block to the QMS quality event for traceability and CAPA tracking.',
    `number` STRING COMMENT 'Business-facing unique identifier for the order block record, used for referencing in order management workflows, credit control communications, and audit trails. Sourced from SAP S/4HANA SD module.. Valid values are `^BLK-[0-9]{10}$`',
    `order_value_at_block` DECIMAL(18,2) COMMENT 'The net value of the sales order or line item at the time the block was applied. Provides a snapshot of the financial impact of the blocked order for credit and revenue management reporting.',
    `reason_code` STRING COMMENT 'Standardized code identifying the specific reason the block was applied, as defined in the SAP S/4HANA SD configuration. Examples include credit limit exceeded, missing export license, failed incoming inspection, disputed invoice, or payment overdue.',
    `reason_description` STRING COMMENT 'Human-readable description of the block reason code, providing context for order management teams, credit controllers, and compliance officers reviewing blocked orders.',
    `release_authorization_level` STRING COMMENT 'The authorization level required and used to release the block, reflecting the segregation of duties and approval hierarchy in credit control, export compliance, and quality management workflows. Higher levels indicate greater financial exposure or regulatory risk.. Valid values are `level_1_clerk|level_2_supervisor|level_3_manager|level_4_director|level_5_executive|system_auto`',
    `release_notes` STRING COMMENT 'Free-text notes entered by the releasing user documenting the justification, conditions, or exceptions applied when releasing the block. Supports audit trail and compliance documentation requirements.',
    `release_reason_code` STRING COMMENT 'Standardized code indicating the reason the block was released (e.g., credit limit increased, export license obtained, quality inspection passed, payment received). Supports root cause analysis and process improvement.',
    `release_timestamp` TIMESTAMP COMMENT 'Date and time when the order block was released, allowing fulfillment or invoicing to proceed. Null if the block has not yet been released.',
    `released_by` STRING COMMENT 'User ID of the individual who authorized and executed the release of the order block. Supports segregation of duties and audit trail requirements.',
    `released_by_name` STRING COMMENT 'Full name of the individual who released the order block, providing a human-readable audit trail for compliance and order management reviews.',
    `sales_organization` STRING COMMENT 'SAP sales organization code under which the blocked sales order was created. Used for organizational reporting, credit control area assignment, and regional compliance tracking in multinational operations.',
    `sla_resolution_hours` STRING COMMENT 'The maximum number of hours within which this block type must be reviewed and resolved per internal Service Level Agreement (SLA) policy. Used for SLA compliance monitoring and escalation triggering.',
    `source` STRING COMMENT 'Indicates whether the block was applied manually by a user or automatically triggered by a system rule (e.g., automatic credit check in SAP, export control screening, MES quality hold). Supports process analysis and automation effectiveness reporting.. Valid values are `manual|automatic_credit_check|automatic_export_check|automatic_quality_check|system_rule|workflow`',
    `status` STRING COMMENT 'Current lifecycle status of the order block. Active indicates the block is in force; released indicates the block has been removed and fulfillment can proceed; escalated indicates the block has been escalated to a higher authority; expired indicates the block lapsed without action; cancelled indicates the block was voided.. Valid values are `active|released|escalated|expired|cancelled`',
    `type` STRING COMMENT 'Classification of the order block indicating which fulfillment or invoicing process is being prevented. Delivery blocks prevent goods issue and shipment; billing blocks prevent invoice creation; credit blocks are triggered by credit management; export control blocks are triggered by trade compliance checks; quality hold blocks are triggered by QMS inspection failures.. Valid values are `delivery_block|billing_block|credit_block|export_control_block|quality_hold_block|payment_block|legal_block`',
    CONSTRAINT pk_order_block PRIMARY KEY(`order_block_id`)
) COMMENT 'Records of delivery, billing, or credit blocks applied to sales orders that prevent fulfillment or invoicing from proceeding. Captures block type (credit block, delivery block, billing block, export control block), block reason code, block applied date, block applied by, block release date, block released by, release authorization level, and associated credit exposure amount. Supports order management workflows for credit control, export compliance, and quality holds in industrial manufacturing order processing.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`returns_order` (
    `returns_order_id` BIGINT COMMENT 'Unique surrogate identifier for the customer return order (Return Material Authorization) record in the Databricks Silver Layer. Serves as the primary key for this entity.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Returns must identify which catalog item is being returned for warranty processing, restocking, and quality analysis. Returns department uses this daily.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Returns processing requires component reference for warranty validation, defect analysis, and potential engineering change requests based on field failures.',
    `ar_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ar_invoice. Business justification: Returns orders generate credit memos (AR invoices with negative amounts) to refund customers. Accounts receivable uses this to process customer credits and reconcile payments.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Returns orders must track which specific equipment unit is being returned for warranty claims, repairs, or replacements. Quality teams analyze failure patterns by equipment.',
    `field_service_order_id` BIGINT COMMENT 'Foreign key linking to service.field_service_order. Business justification: Returns orders may originate from field service activities where equipment is found defective during installation or maintenance. Links return to the service event that identified the issue for root c',
    `fulfillment_mode_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_mode. Business justification: Returns orders reference the fulfillment mode of the original order for reverse logistics processing. The string fulfillment_mode is replaced by FK fulfillment_mode_id.',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: Returns are typically at the line item level. The string original_line_item_number is replaced by FK order_line_item_id.',
    `ncr_id` BIGINT COMMENT 'Foreign key linking to quality.ncr. Business justification: Returns order may be triggered by NCR - normalize by replacing ncr_number text with FK to quality.ncr',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Returns processing requires employee accountability for authorization decisions, refund approvals, and quality inspection. Customer service and warehouse staff ownership is tracked for performance and',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Returns specify exact SKU for inventory restocking and defect tracking. Warehouse and quality teams need this for proper handling and disposition.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: A returns order (RMA) references the original sales order being returned. The string original_sales_order_number is replaced by FK sales_order_id.',
    `actual_goods_receipt_date` DATE COMMENT 'Date on which the returned goods were physically received at the return plant and a goods receipt (GR) was posted in SAP S/4HANA MM. Triggers inspection workflow and credit memo eligibility.. Valid values are `^d{4}-d{2}-d{2}$`',
    `batch_number` STRING COMMENT 'Manufacturing batch or lot number of the returned material as recorded in SAP batch management. Critical for traceability, quality investigations, recall management, and CAPA processes in industrial manufacturing.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the return order record was created in SAP S/4HANA SD. Used for audit trail, SLA measurement, and return processing cycle time analytics.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `credit_memo_request_flag` BOOLEAN COMMENT 'Indicates whether a credit memo request has been triggered in SAP S/4HANA FI/SD for this return order. When true, the accounts receivable team processes the credit memo to reverse the original invoice and issue a customer credit.. Valid values are `true|false`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the return order transaction (e.g., USD, EUR, GBP). All monetary values on the return order are expressed in this currency.. Valid values are `^[A-Z]{3}$`',
    `customer_return_authorization_number` STRING COMMENT 'Authorization number provided by the customer (buyer) from their own internal system authorizing the return shipment. Used for cross-referencing with the customers procurement or ERP system.',
    `disposition_code` STRING COMMENT 'Final disposition decision for the returned material following quality inspection or goods receipt assessment. Determines the subsequent inventory movement: unrestricted stock reposting, scrap posting, transfer to refurbishment order, or vendor return.. Valid values are `restock|refurbish|scrap|return_to_vendor|warranty_repair|quarantine|pending`',
    `distribution_channel` STRING COMMENT 'SAP distribution channel through which the original sale was made (e.g., direct sales, dealer, OEM). Inherited from the original sales order and used for return analytics segmentation and credit memo routing.. Valid values are `^[A-Z0-9]{1,2}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign currency exchange rate applied to convert the return order value from the transaction currency to the company code currency at the time of return order creation. Used for multi-currency financial reporting.. Valid values are `^d+(.d{1,6})?$`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms code governing the transfer of risk and responsibility for the return shipment between the customer and the company. Determines who bears freight costs and risk during reverse logistics.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `inspection_lot_number` STRING COMMENT 'SAP QM inspection lot number created for the quality inspection of returned goods. Links the return order to the quality management inspection process and usage decision outcome.. Valid values are `^[A-Z0-9-]{1,12}$`',
    `inspection_required_flag` BOOLEAN COMMENT 'Indicates whether a quality inspection is required for the returned goods before disposition decision (restock, scrap, repair). When true, an inspection lot is created in SAP QM and the material is placed in quality inspection stock.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the return order record in SAP S/4HANA SD. Used for change tracking, data synchronization, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `material_condition_code` STRING COMMENT 'Assessment code describing the physical condition of the returned material upon receipt at the return plant. Determines disposition routing: restock, refurbish, scrap, or warranty repair. Captured during goods receipt or quality inspection.. Valid values are `new|like_new|repairable|damaged|scrap|unknown`',
    `material_description` STRING COMMENT 'Short description of the returned material or product as maintained in the SAP material master. Provides human-readable identification of the returned item for customer communications and inspection documentation.',
    `material_number` STRING COMMENT 'SAP material master number identifying the specific product, component, or system being returned. Used for inventory posting, quality inspection routing, and BOM traceability.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `net_return_value` DECIMAL(18,2) COMMENT 'Net monetary value of the return order before tax, calculated as return quantity multiplied by the net unit price from the original sales order, less any applicable restocking fee. Forms the basis for credit memo creation in SAP FI.. Valid values are `^-?d+(.d{1,2})?$`',
    `order_date` DATE COMMENT 'Date on which the return order was created in SAP S/4HANA SD. Used as the baseline date for return processing SLA measurement, credit memo aging, and return analytics.. Valid values are `^d{4}-d{2}-d{2}$`',
    `requested_pickup_date` DATE COMMENT 'Date requested by the customer or logistics team for pickup or collection of the returned goods from the customers site. Used for reverse logistics scheduling and carrier coordination.. Valid values are `^d{4}-d{2}-d{2}$`',
    `restocking_fee` DECIMAL(18,2) COMMENT 'Fee charged to the customer for processing the return and restocking the material, deducted from the credit memo value. Applicable based on return reason code, material type, and contractual terms. Expressed in the transaction currency.. Valid values are `^d+(.d{1,2})?$`',
    `return_delivery_number` STRING COMMENT 'SAP outbound/inbound delivery document number created for the physical return shipment. Used to track the reverse logistics movement from customer to return plant and triggers goods receipt posting upon arrival.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `return_order_number` STRING COMMENT 'Business-facing return order document number assigned by SAP S/4HANA SD during RE order type creation (VA01). This is the externally visible RMA document number used in customer communications and logistics coordination.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `return_plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility designated to receive and process the returned goods. Determines the inventory posting location, inspection routing, and applicable quality procedures.. Valid values are `^[A-Z0-9]{1,4}$`',
    `return_quantity` DECIMAL(18,2) COMMENT 'Quantity of the material authorized for return, expressed in the base unit of measure. Drives credit memo value calculation, inventory reposting, and restocking fee computation.. Valid values are `^d+(.d{1,4})?$`',
    `return_reason_code` STRING COMMENT 'Standardized reason code classifying why the customer is returning the material. Drives credit memo processing rules, restocking fee applicability, warranty claim routing, and quality management CAPA workflows. Sourced from SAP SD return reason configuration.. Valid values are `defective|wrong_item|over_delivery|warranty_return|damaged_in_transit|quality_rejection|customer_cancellation|excess_stock|specification_mismatch|other`',
    `return_reason_description` STRING COMMENT 'Free-text description providing additional detail on the return reason beyond the standardized reason code. Captures customer-provided narrative or internal notes explaining the specific circumstances of the return.',
    `rma_number` STRING COMMENT 'Customer-facing Return Material Authorization number issued to the customer as authorization to ship back goods. This is the number the customer uses on their return shipment and is distinct from the internal SAP return order number.. Valid values are `^[A-Z0-9-]{1,30}$`',
    `sales_organization` STRING COMMENT 'SAP sales organization code responsible for processing the return order. Determines the applicable pricing, credit memo rules, and revenue recognition treatment for the return transaction.. Valid values are `^[A-Z0-9]{1,4}$`',
    `serial_number` STRING COMMENT 'Unique serial number of the returned item for serialized products such as automation systems, PLCs, or electrification components. Enables asset-level traceability and links to installed base records in Salesforce CRM and Maximo EAM.',
    `sku_number` STRING COMMENT 'Stock Keeping Unit identifier for the returned item, representing the specific sellable configuration including variant, packaging, and unit of measure. Used for inventory reconciliation and warehouse management in Infor WMS.. Valid values are `^[A-Z0-9-]{1,50}$`',
    `status` STRING COMMENT 'Current lifecycle status of the return order, tracking progression from initial creation through goods receipt, quality inspection, credit memo issuance, and final closure. Drives workflow routing in SAP SD and downstream finance processes.. Valid values are `open|in_review|approved|rejected|goods_received|inspection_pending|inspection_complete|credit_memo_created|closed|cancelled`',
    `storage_location` STRING COMMENT 'SAP storage location within the return plant where returned goods are physically placed upon receipt. Used for inventory management, blocked stock posting, and quality hold management in Infor WMS.. Valid values are `^[A-Z0-9]{1,4}$`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax amount applicable to the return order, calculated based on the tax jurisdiction and applicable tax codes. Reversed upon credit memo creation to correctly adjust the customers tax liability.. Valid values are `^-?d+(.d{1,2})?$`',
    `unit_of_measure` STRING COMMENT 'Unit of measure in which the return quantity is expressed (e.g., EA for each, KG for kilogram, PC for piece). Aligned with SAP base unit of measure configuration and GS1 unit of measure standards.. Valid values are `EA|PC|KG|LB|M|FT|L|GAL|BOX|PAL|SET|M2|M3`',
    `warranty_claim_flag` BOOLEAN COMMENT 'Indicates whether the return is associated with a warranty claim. When true, the return is linked to a warranty case in Salesforce Service Cloud and may trigger a CAPA investigation in the quality management system.. Valid values are `true|false`',
    CONSTRAINT pk_returns_order PRIMARY KEY(`returns_order_id`)
) COMMENT 'Customer returns order (RMA - Return Material Authorization) capturing the reverse logistics and credit process for returned industrial products, components, or systems. Captures return order number, original sales order reference, return reason code (defective, wrong item, over-delivery, warranty return), return quantity, material condition, return plant, credit memo request flag, inspection requirement flag, restocking fee, return status, and customer return authorization number. Sourced from SAP S/4HANA SD returns processing (VA01 - RE order type).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`amendment` (
    `amendment_id` BIGINT COMMENT 'Unique surrogate identifier for each order amendment record in the silver layer lakehouse. Serves as the primary key for the order_amendment data product.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Order amendments change contractual terms and pricing, requiring clear employee accountability. Tracking who made changes is critical for audit compliance, dispute resolution, and authorization valida',
    `fulfillment_mode_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_mode. Business justification: Amendments may change the fulfillment mode. The string fulfillment_mode is replaced by FK fulfillment_mode_id.',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: Amendments can target a specific line item within the order. The string line_item_number is replaced by FK order_line_item_id (nullable when amendment applies to entire order).',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Order amendments record changes to a specific sales order. The string sales_order_number is replaced by FK sales_order_id.',
    `approval_authority` STRING COMMENT 'Name or role of the individual or committee authorized to approve this amendment based on amendment type, value impact, and delegation of authority matrix.',
    `approval_level` STRING COMMENT 'Hierarchical approval tier required for this amendment based on financial impact thresholds and amendment type. Determines escalation path in the approval workflow.. Valid values are `sales_representative|sales_manager|commercial_director|vp_sales|executive`',
    `approval_status` STRING COMMENT 'Current internal approval decision status for the amendment, distinct from the overall amendment lifecycle status. Tracks the approval workflow outcome independently.. Valid values are `pending|approved|conditionally_approved|rejected|escalated`',
    `approved_rejected_timestamp` TIMESTAMP COMMENT 'Date and time when the amendment was formally approved or rejected by the designated approval authority. Used for SLA compliance measurement and audit trail.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `atp_ctp_recheck_required` BOOLEAN COMMENT 'Indicates whether an ATP or CTP availability check must be re-executed in SAP S/4HANA due to the nature of this amendment (e.g., quantity increase or delivery date change).. Valid values are `true|false`',
    `cancellation_reason_code` STRING COMMENT 'Standardized reason code applicable when the amendment type is cancellation. Required for revenue recognition adjustments, demand planning updates, and customer account management.. Valid values are `customer_request|duplicate_order|credit_hold|supply_failure|force_majeure|regulatory|pricing_dispute|other`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the order amendment record was first created in the source system. Provides the audit trail entry point for the amendment lifecycle.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the financial impact amount and any price-related amendment values. Supports multi-currency reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `customer_notification_timestamp` TIMESTAMP COMMENT 'Date and time when the customer was formally notified of the amendment outcome. Used for SLA compliance measurement and customer communication audit trail in Salesforce CRM.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customer_notified` BOOLEAN COMMENT 'Indicates whether the customer has been formally notified of the amendment decision (approval, rejection, or implementation). Supports customer communication SLA compliance tracking.. Valid values are `true|false`',
    `customer_reference_number` STRING COMMENT 'Customers own internal reference or purchase order amendment number for this change request. Required for customer invoice reconciliation and dispute management.',
    `customer_request_date` DATE COMMENT 'Date on which the customer formally requested the amendment to the sales order. Used for SLA tracking, response time measurement, and customer communication audit trail.. Valid values are `^d{4}-d{2}-d{2}$`',
    `ecn_reference` STRING COMMENT 'Reference to the Engineering Change Notice in Siemens Teamcenter PLM that triggered or is associated with this configuration change amendment. Links order changes to product engineering changes.',
    `field_changed` STRING COMMENT 'Name of the specific order field or attribute being modified by this amendment (e.g., ordered_quantity, confirmed_delivery_date, net_price). Provides granular audit trail for change management.',
    `financial_impact_amount` DECIMAL(18,2) COMMENT 'Monetary value of the financial impact resulting from the amendment, expressed in the order currency. May be positive (revenue increase) or negative (revenue reduction or cancellation penalty).',
    `implemented_timestamp` TIMESTAMP COMMENT 'Date and time when the approved amendment was actually applied to the sales order in the system of record (SAP S/4HANA SD). Confirms completion of the change management cycle.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the order amendment record in the source system. Supports incremental data loading and change data capture in the lakehouse pipeline.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `new_value` STRING COMMENT 'The requested new value for the field being amended, stored as a string representation. Represents the after-state that will be applied upon amendment approval.',
    `number` STRING COMMENT 'Business-facing sequential amendment number assigned to uniquely identify this change request against a sales order. Used in customer communications and change management workflows.. Valid values are `^AMD-[0-9]{4}-[0-9]{6}$`',
    `original_delivery_date` DATE COMMENT 'The confirmed delivery date on the sales order prior to this amendment. Captured for delivery date change amendments to measure schedule deviation and customer impact.. Valid values are `^d{4}-d{2}-d{2}$`',
    `previous_value` STRING COMMENT 'The original value of the field being amended prior to the change, stored as a string representation. Provides the before-state for audit trail and customer dispute resolution.',
    `production_schedule_impact` STRING COMMENT 'Assessment of the amendments impact on the existing production schedule and manufacturing execution plan. Informs MES rescheduling requirements and production planning decisions.. Valid values are `no_impact|minor_impact|moderate_impact|major_impact|critical_impact`',
    `production_schedule_impact_notes` STRING COMMENT 'Free-text description of the specific production schedule impacts identified, including affected work orders, operations, or resources. Supports production planning and MES coordination.',
    `quantity_delta` DECIMAL(18,2) COMMENT 'Net change in ordered quantity resulting from this amendment (positive for increases, negative for decreases). Applicable for quantity_change amendment types; used for ATP/CTP re-evaluation.',
    `reason_code` STRING COMMENT 'Standardized reason code categorizing why the amendment was initiated. Used for root cause analysis, CAPA processes, and customer communication workflows.. Valid values are `customer_request|forecast_revision|supply_constraint|engineering_change|pricing_correction|regulatory_compliance|force_majeure|internal_error|other`',
    `reason_description` STRING COMMENT 'Free-text narrative providing detailed explanation of the business reason for the amendment, supplementing the reason code with context for customer communication and internal review.',
    `rejection_reason` STRING COMMENT 'Explanation provided by the approver when an amendment is rejected. Required for rejected amendments to support customer communication and potential re-submission.',
    `requested_delivery_date` DATE COMMENT 'The new delivery date requested by the customer or proposed internally as part of a delivery date change amendment. Subject to ATP/CTP confirmation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sales_organization` STRING COMMENT 'SAP S/4HANA sales organization code responsible for processing this amendment. Determines the applicable pricing, approval hierarchy, and revenue reporting structure.',
    `source_system` STRING COMMENT 'Originating system from which the amendment record was captured. Supports data lineage tracking and reconciliation across SAP S/4HANA, Salesforce CRM, EDI channels, and customer self-service portals.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL|EDI|CUSTOMER_PORTAL`',
    `status` STRING COMMENT 'Current lifecycle status of the order amendment from initial submission through approval and implementation. Drives workflow routing and customer notification triggers.. Valid values are `draft|submitted|under_review|approved|rejected|implemented|cancelled|withdrawn`',
    `submitted_timestamp` TIMESTAMP COMMENT 'Date and time when the amendment was formally submitted for internal review and approval. Marks the start of the internal amendment processing SLA clock.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `type` STRING COMMENT 'Classification of the nature of the change being requested. Drives the approval workflow, production schedule impact assessment, and customer communication template selection.. Valid values are `quantity_change|delivery_date_change|configuration_change|price_change|cancellation|payment_terms_change|shipping_address_change|incoterms_change|other`',
    `unit_of_measure` STRING COMMENT 'Unit of measure applicable to the quantity delta and quantity-related amendment values (e.g., EA, KG, M, PC). Aligns with the base unit of measure defined in the material master.',
    `version_number` STRING COMMENT 'Sequential version counter for the amendment record, incremented each time the amendment is revised prior to final approval. Supports amendment revision history tracking.. Valid values are `^[1-9][0-9]*$`',
    CONSTRAINT pk_amendment PRIMARY KEY(`amendment_id`)
) COMMENT 'Record of changes made to an existing sales order after initial confirmation, capturing the amendment lifecycle for industrial manufacturing orders. Captures amendment number, original order reference, amendment type (quantity change, delivery date change, configuration change, price change, cancellation), previous value, new value, amendment reason, customer request date, internal approval status, approval authority, amendment impact on production schedule, and amendment status. Supports change management and customer communication workflows.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`customer_po` (
    `customer_po_id` BIGINT COMMENT 'Unique surrogate identifier for the customer purchase order record in the Silver Layer lakehouse. Serves as the primary key for all downstream joins and references.',
    `blanket_order_id` BIGINT COMMENT 'Foreign key linking to order.blanket_order. Business justification: A customer PO may be issued under a blanket/framework order agreement. The string blanket_po_reference is replaced by FK blanket_order_id.',
    `fulfillment_mode_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_mode. Business justification: Customer POs specify the required fulfillment mode. The string fulfillment_mode is replaced by FK fulfillment_mode_id.',
    `order_quotation_id` BIGINT COMMENT 'Foreign key linking to order.quotation. Business justification: A customer PO may reference the quotation it was issued against. The string linked_quotation_number is replaced by FK quotation_id.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: A customer PO is linked to the sales order it generates. The string linked_sales_order_number is replaced by FK sales_order_id.',
    `accepted_date` DATE COMMENT 'The date on which the manufacturer formally accepted the customer purchase order, triggering sales order creation and fulfillment processes. Used for order-to-cash cycle time measurement and contractual obligation start.. Valid values are `^d{4}-d{2}-d{2}$`',
    `buyer_contact_email` STRING COMMENT 'Email address of the buyer contact at the customer organization for order acknowledgement, acceptance/rejection notifications, and delivery confirmations.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `buyer_contact_name` STRING COMMENT 'Full name of the individual buyer or procurement contact at the customer organization who issued or is responsible for the purchase order. Used for order acknowledgement and correspondence.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the customer purchase order record was first created in the source system. Used for audit trail, data lineage, and order receipt SLA measurement.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `credit_check_status` STRING COMMENT 'Result of the customer credit limit check performed against this purchase order value. A blocked status prevents sales order creation until credit is released. Supports accounts receivable risk management.. Valid values are `not_checked|approved|blocked|released_by_manager`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the customer purchase order is denominated (e.g., USD, EUR, GBP, JPY). Drives multi-currency order processing, exchange rate application, and financial reporting.. Valid values are `^[A-Z]{3}$`',
    `customer_account_number` STRING COMMENT 'The internal customer account number (sold-to party) identifying the industrial buyer, OEM partner, or system integrator who issued the purchase order. Links to the customer master for credit, pricing, and compliance checks.',
    `customer_name` STRING COMMENT 'Legal name of the customer organization (company) that issued the purchase order. Captured from the PO document header for display, reporting, and audit purposes.',
    `distribution_channel` STRING COMMENT 'SAP distribution channel code indicating how the products ordered will be distributed to the customer (e.g., direct sales, OEM, distributor, e-commerce). Drives pricing and condition determination.',
    `edi_transmission_reference` STRING COMMENT 'Unique reference number assigned to the EDI transaction set (e.g., ANSI X12 850 or EDIFACT ORDERS) used to transmit this purchase order electronically. Supports EDI reconciliation, error tracking, and audit trails for automated order receipt.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign currency exchange rate applied to convert the PO currency to the companys functional/reporting currency at the time of PO receipt or acceptance. Required for multi-currency financial consolidation.',
    `export_control_status` STRING COMMENT 'Status of export control and trade compliance screening for this customer purchase order. Indicates whether the order has been cleared for shipment to the destination country under applicable export regulations (EAR, ITAR, EU Dual-Use).. Valid values are `not_checked|cleared|blocked|under_review|license_required`',
    `gross_po_value` DECIMAL(18,2) COMMENT 'Total gross value of the customer purchase order including all taxes and surcharges in the PO currency. Represents the total financial commitment of the customer as stated on the PO document.',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms) code specified in the customer purchase order defining the delivery obligations, risk transfer point, and cost responsibilities between buyer and seller (e.g., DAP, DDP, FOB, CIF).. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `incoterms_location` STRING COMMENT 'The named place or port associated with the Incoterms code specified in the customer purchase order (e.g., Port of Rotterdam for FOB, Customer Warehouse, Detroit for DDP). Required for precise risk and cost transfer determination.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the customer purchase order record in the source system. Supports change detection, incremental data loading, and audit trail maintenance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `payment_terms_code` STRING COMMENT 'Code representing the payment terms agreed upon and stated in the customer purchase order (e.g., NET30, NET60, 2/10NET30). Drives accounts receivable due date calculation and cash flow forecasting.',
    `po_date` DATE COMMENT 'The date on which the customer formally issued and signed the purchase order document. Used for payment terms calculation, delivery commitment baseline, and order-to-cash cycle time measurement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `po_line_item_count` STRING COMMENT 'Total number of line items included in the customer purchase order document. Used for order complexity assessment, processing time estimation, and completeness validation during PO intake.. Valid values are `^[1-9][0-9]*$`',
    `po_number` STRING COMMENT 'The official purchase order number assigned by the customer (buyer) on their procurement system. This is the external reference number printed on the customers PO document and used for all order-to-cash correspondence.',
    `po_type` STRING COMMENT 'Classification of the customer purchase order by procurement instrument type. Standard POs are single-transaction orders; blanket POs cover multiple releases over a period; release POs are call-offs against a blanket; framework POs establish terms for future orders; consignment POs cover vendor-managed inventory.. Valid values are `standard|blanket|release|framework|consignment|call-off`',
    `received_date` DATE COMMENT 'The date on which the customers purchase order was received by the manufacturers order management team, either via EDI, email, portal, or physical document. Distinct from the PO issue date; used for internal SLA tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `rejection_reason` STRING COMMENT 'Reason code or description explaining why a customer purchase order was rejected or partially accepted. Populated when status is rejected or partially_accepted. Supports customer communication and process improvement.',
    `requested_delivery_date` DATE COMMENT 'The delivery date requested by the customer on the purchase order. Represents the customers desired date for receipt of goods. Used for Available-to-Promise (ATP) / Capable-to-Promise (CTP) checks and delivery scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sales_organization` STRING COMMENT 'SAP sales organization code responsible for processing and fulfilling this customer purchase order. Determines pricing procedures, output determination, and legal entity assignment for revenue booking.',
    `ship_to_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the destination country where the ordered goods are to be delivered as specified on the customer purchase order. Required for export control screening, customs documentation, and logistics planning.. Valid values are `^[A-Z]{3}$`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this customer purchase order record was ingested into the Silver Layer. Supports data lineage, reconciliation, and audit traceability.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|EDI_GATEWAY|CUSTOMER_PORTAL|MANUAL`',
    `special_instructions` STRING COMMENT 'Free-text field capturing any special handling, packaging, labeling, or delivery instructions specified by the customer on the purchase order. Communicated to warehouse, logistics, and production teams for order fulfillment.',
    `status` STRING COMMENT 'Current lifecycle status of the customer purchase order from receipt through fulfillment. Drives order management workflows, customer notifications, and revenue recognition triggers.. Valid values are `received|under_review|accepted|partially_accepted|rejected|cancelled|fulfilled|closed`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount stated on the customer purchase order in the PO currency. Includes VAT, GST, sales tax, or other applicable taxes as specified by the customer. Used for accounts receivable and tax compliance reporting.',
    `total_po_value` DECIMAL(18,2) COMMENT 'Total net value of the customer purchase order in the PO currency, representing the sum of all line item values before taxes. Used for credit limit checks, revenue forecasting, and order prioritization.',
    `transmission_channel` STRING COMMENT 'The channel or method through which the customer purchase order was received by the manufacturer. Supports process automation metrics, EDI adoption tracking, and order receipt SLA monitoring.. Valid values are `EDI|email|customer_portal|fax|manual|API|ERP_integration`',
    `validity_end_date` DATE COMMENT 'The expiry date of the customer purchase order validity period. After this date, the PO is no longer valid for order creation or release. Critical for blanket and framework PO management and revenue recognition cutoff.. Valid values are `^d{4}-d{2}-d{2}$`',
    `validity_start_date` DATE COMMENT 'The start date of the validity period for the customer purchase order. Particularly relevant for blanket, framework, and long-term supply agreement POs. Orders cannot be released before this date.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_customer_po PRIMARY KEY(`customer_po_id`)
) COMMENT 'Customer Purchase Order (PO) document received from industrial buyers, OEM partners, or system integrators as the formal procurement instrument triggering order creation. Captures customer PO number, customer PO date, customer identity, PO type (standard, blanket, release, framework), total PO value, currency, payment terms, delivery terms (incoterms), PO validity period, EDI transmission reference, linked sales order reference, and PO acceptance status. SSOT for inbound customer purchase order documents distinct from internal procurement POs.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`blanket_order` (
    `blanket_order_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for the blanket order record in the Databricks Silver Layer. Serves as the primary key for all downstream joins and references.',
    `fulfillment_mode_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_mode. Business justification: Blanket orders define the fulfillment mode for all releases under the agreement. The string fulfillment_mode is replaced by FK fulfillment_mode_id.',
    `agreement_number` STRING COMMENT 'Business-facing scheduling agreement or blanket order number as assigned in SAP S/4HANA SD. This is the externally communicated reference number used in customer correspondence and order releases.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `agreement_type` STRING COMMENT 'Classification of the blanket order agreement type, distinguishing between scheduling agreements, quantity contracts, value contracts, and framework orders as defined in SAP SD/MM.. Valid values are `scheduling_agreement|blanket_purchase_order|framework_order|quantity_contract|value_contract`',
    `committed_quantity` DECIMAL(18,2) COMMENT 'Total quantity of material committed by the customer over the blanket order contract period. Expressed in the base unit of measure. Used for capacity planning and MRP.. Valid values are `^d+(.d{1,4})?$`',
    `contract_reference` STRING COMMENT 'Reference to the overarching master sales contract or framework agreement under which this blanket order is issued. Enables contract hierarchy traceability.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the ship-to destination for deliveries under this blanket order. Used for export control, customs compliance, and logistics routing.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the blanket order agreement was originally created in the source system (SAP S/4HANA). Used for audit trail and agreement lifecycle tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the blanket order values and pricing are denominated (e.g., USD, EUR, GBP). Supports multi-currency reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `customer_account_number` STRING COMMENT 'SAP customer account number (sold-to party) identifying the industrial customer who holds this blanket order agreement. Used for customer master data linkage.. Valid values are `^[A-Z0-9]{1,15}$`',
    `customer_name` STRING COMMENT 'Legal or trading name of the industrial customer holding the blanket order. Sourced from SAP customer master and used for reporting and customer-facing documents.',
    `discount_percent` DECIMAL(18,2) COMMENT 'Percentage discount applied to the list price to arrive at the net price for this blanket order. Reflects volume commitment or strategic customer pricing.. Valid values are `^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$`',
    `distribution_channel` STRING COMMENT 'SAP distribution channel through which the blanket order products are sold (e.g., direct sales, OEM, distributor). Affects pricing and availability determination.. Valid values are `^[A-Z0-9]{1,2}$`',
    `division` STRING COMMENT 'SAP division representing the product line or business unit responsible for fulfilling the blanket order. Used for revenue allocation and reporting.. Valid values are `^[A-Z0-9]{1,2}$`',
    `export_control_status` STRING COMMENT 'Export control classification status for the blanket order, indicating whether the material requires an export license or is subject to trade embargoes. Critical for multinational compliance.. Valid values are `not_restricted|license_required|license_approved|embargo|under_review`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the delivery and risk transfer conditions for shipments released under this blanket order.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `incoterms_location` STRING COMMENT 'The named place or port associated with the Incoterms code, specifying the exact location where risk and cost transfer from seller to buyer for releases under this agreement.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the blanket order agreement in the source system. Used for change detection, incremental loads, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_release_date` DATE COMMENT 'Date on which the most recent delivery release was issued against this blanket order. Used for consumption tracking and agreement activity monitoring.. Valid values are `^d{4}-d{2}-d{2}$`',
    `open_quantity` DECIMAL(18,2) COMMENT 'Remaining open quantity on the blanket order, calculated as committed quantity minus released quantity. Indicates how much of the customer commitment is yet to be fulfilled.. Valid values are `^d+(.d{1,4})?$`',
    `payment_terms_code` STRING COMMENT 'SAP payment terms code defining the payment due dates and early payment discount conditions applicable to invoices generated from releases against this blanket order.. Valid values are `^[A-Z0-9]{1,4}$`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility responsible for fulfilling releases against this blanket order. Drives MRP and ATP checks.. Valid values are `^[A-Z0-9]{1,4}$`',
    `price_unit` DECIMAL(18,2) COMMENT 'The quantity basis for the net unit price (e.g., price per 1 EA, per 100 PC, per 1000 KG). Required to correctly compute line values from quantity and price.. Valid values are `^d+(.d{1,4})?$`',
    `pricing_agreement_reference` STRING COMMENT 'Reference number of the associated customer pricing agreement or special pricing arrangement that governs the net prices and conditions applied to this blanket order.',
    `release_creation_profile` STRING COMMENT 'SAP release creation profile controlling the automatic generation of delivery schedule releases (JIT and forecast delivery schedules) based on MRP and planning horizons.. Valid values are `^[A-Z0-9]{1,4}$`',
    `released_quantity` DECIMAL(18,2) COMMENT 'Cumulative quantity released (called off) against the blanket order to date. Represents the sum of all delivery schedule lines confirmed and dispatched.. Valid values are `^d+(.d{1,4})?$`',
    `sales_organization` STRING COMMENT 'SAP sales organization responsible for the blanket order agreement. Determines pricing, currency, and legal entity for the order-to-cash process.. Valid values are `^[A-Z0-9]{1,4}$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this blanket order record was sourced. Supports data lineage and audit traceability in the lakehouse.. Valid values are `SAP_S4HANA|LEGACY_ERP|MANUAL`',
    `status` STRING COMMENT 'Current lifecycle status of the blanket order agreement. Drives downstream release processing, replenishment triggers, and order-to-cash workflows.. Valid values are `draft|active|partially_released|fully_released|on_hold|expired|cancelled|closed`',
    `tolerance_over_delivery_percent` DECIMAL(18,2) COMMENT 'Maximum percentage by which a delivery release quantity may exceed the scheduled quantity without triggering a goods receipt block. Defined per customer agreement.. Valid values are `^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$`',
    `tolerance_under_delivery_percent` DECIMAL(18,2) COMMENT 'Maximum percentage by which a delivery release quantity may fall short of the scheduled quantity and still be accepted as complete by the customer.. Valid values are `^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$`',
    `unit_of_measure` STRING COMMENT 'Base unit of measure for the committed and released quantities on the blanket order (e.g., EA, KG, PC, M, L). Aligned with SAP base UoM from the material master.. Valid values are `^[A-Z]{2,5}$`',
    `validity_end_date` DATE COMMENT 'The date on which the blanket order agreement expires. After this date, no further releases can be processed unless the agreement is extended.. Valid values are `^d{4}-d{2}-d{2}$`',
    `validity_start_date` DATE COMMENT 'The date from which the blanket order agreement becomes effective and releases can be made against it. Defines the start of the contract period.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_blanket_order PRIMARY KEY(`blanket_order_id`)
) COMMENT 'Long-term blanket or framework order agreement with industrial customers defining committed volumes, pricing, and delivery terms over a contract period. Captures blanket order number, customer identity, validity start and end dates, total committed value, total committed quantity per material, release schedule, consumed quantity to date, remaining open quantity, pricing conditions, delivery plant, and blanket order status. Supports MTS and Kanban-driven replenishment for high-volume industrial customers. Sourced from SAP S/4HANA SD scheduling agreements.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` (
    `fulfillment_plan_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a fulfillment execution plan record in the Databricks Silver Layer. Serves as the primary key for the order_fulfillment_plan entity.',
    `delivery_order_id` BIGINT COMMENT 'Foreign key linking to order.delivery_order. Business justification: Fulfillment plans link to the delivery document for physical execution tracking. The string delivery_document_number is replaced by FK delivery_order_id.',
    `fulfillment_mode_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_mode. Business justification: Fulfillment plans are mode-specific execution plans. The string fulfillment_mode is replaced by FK fulfillment_mode_id.',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Complex fulfillment plans may require internal orders to track cross-functional costs for special projects or custom manufacturing. Controlling uses this for project cost management.',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: Fulfillment plans can be created at the line item level. The string line_item_number is replaced by FK order_line_item_id.',
    `priority_id` BIGINT COMMENT 'Foreign key linking to order.order_priority. Business justification: Fulfillment plans use priority to sequence production and warehouse operations. The string priority is replaced by FK order_priority_id.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Fulfillment plans are execution plans for a specific sales order. The string sales_order_number is replaced by FK sales_order_id.',
    `actual_fulfillment_date` DATE COMMENT 'Date on which the fulfillment plan was actually completed and goods were confirmed as delivered. Used for on-time delivery performance measurement and order-to-cash cycle analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `actual_goods_issue_date` DATE COMMENT 'Actual date on which goods issue was posted in the warehouse management system, confirming physical departure of goods. Used for delivery performance tracking and revenue recognition timing.. Valid values are `^d{4}-d{2}-d{2}$`',
    `atp_ctp_check_result` STRING COMMENT 'Result of the ATP (Available to Promise) or CTP (Capable to Promise) availability check performed during order confirmation. Indicates whether inventory or production capacity can support the planned delivery date.. Valid values are `confirmed|partial|not_available|ctp_required|backorder`',
    `batch_number` STRING COMMENT 'Manufacturing batch or lot number assigned to the goods being fulfilled. Required for batch-managed materials to ensure traceability from production through delivery, supporting quality and recall management.',
    `bottleneck_description` STRING COMMENT 'Free-text description of the identified bottleneck, including the constraining resource, material shortage, or process step causing the delay. Populated when bottleneck_flag is true.',
    `bottleneck_flag` BOOLEAN COMMENT 'Indicates whether a capacity or material bottleneck has been identified in the fulfillment plan that may jeopardize the planned delivery date. Triggers escalation and expediting workflows.. Valid values are `true|false`',
    `confirmed_timestamp` TIMESTAMP COMMENT 'Timestamp when the fulfillment plan was formally confirmed, indicating that production, procurement, and logistics commitments have been validated and the plan is executable.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the fulfillment plan record was first created in the source system. Used for audit trail, data lineage, and order-to-cash cycle time measurement.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `delivery_delay_days` STRING COMMENT 'Number of calendar days by which the actual or projected fulfillment date exceeds the planned delivery date. Positive values indicate lateness; zero or negative values indicate on-time or early delivery.',
    `exception_alert_code` STRING COMMENT 'Standardized code identifying the type of exception or alert raised against this fulfillment plan. Used for exception-based management reporting and automated escalation routing.. Valid values are `material_shortage|capacity_overload|supplier_delay|quality_hold|export_control_hold|customer_change|engineering_change|logistics_delay|none`',
    `exception_alert_description` STRING COMMENT 'Detailed narrative describing the exception condition, its root cause, and the corrective actions being taken. Supports CAPA (Corrective and Preventive Action) documentation.',
    `fulfilled_quantity` DECIMAL(18,2) COMMENT 'Quantity of goods actually delivered and confirmed as fulfilled against this plan. Used to calculate fulfillment completion percentage and identify shortfalls.',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the transfer of risk and responsibility between seller and buyer for this fulfillment. Governs shipping cost allocation and insurance obligations.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the fulfillment plan record. Used for incremental data loading, change detection, and audit trail maintenance in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `material_number` STRING COMMENT 'SAP material master number identifying the product or component to be fulfilled. Used for cross-referencing with production, procurement, and inventory management.',
    `mrp_controller` STRING COMMENT 'SAP MRP controller code identifying the planner responsible for managing material requirements and production scheduling for this fulfillment plan. Used for workload assignment and escalation routing.',
    `on_time_delivery_flag` BOOLEAN COMMENT 'Indicates whether the fulfillment plan was completed on or before the planned delivery date. Key input for OTD (On-Time Delivery) KPI reporting and customer service level measurement.. Valid values are `true|false`',
    `plan_number` STRING COMMENT 'Human-readable business identifier for the fulfillment plan, used for cross-system referencing and communication with production, procurement, and logistics teams.. Valid values are `^OFP-[0-9]{4}-[0-9]{8}$`',
    `plan_version` STRING COMMENT 'Version number of the fulfillment plan, incremented each time the plan is revised due to schedule changes, capacity adjustments, or customer modifications. Supports plan change history tracking.. Valid values are `^[0-9]+$`',
    `planned_delivery_date` DATE COMMENT 'Target date by which the goods are planned to be delivered to the customer or ship-to party, as committed in the fulfillment plan. Derived from ATP/CTP check results and production scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_goods_issue_date` DATE COMMENT 'Scheduled date for posting goods issue from the warehouse, marking the physical departure of goods from the plant. Triggers inventory reduction and initiates the billing process in SAP.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_production_start_date` DATE COMMENT 'Scheduled date on which production activities for this fulfillment plan are planned to commence. Derived from backward scheduling based on the planned delivery date and production lead time.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_quantity` DECIMAL(18,2) COMMENT 'Quantity of goods planned to be fulfilled under this fulfillment plan, expressed in the base unit of measure. May differ from ordered quantity due to partial fulfillment splits or rounding.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or distribution center responsible for executing this fulfillment plan. Determines production capacity, storage locations, and shipping points.. Valid values are `^[A-Z0-9]{4}$`',
    `procurement_order_number` STRING COMMENT 'Reference to the purchase order or procurement document in SAP Ariba or SAP S/4HANA MM created to source materials or components required for this fulfillment plan.',
    `production_order_number` STRING COMMENT 'Reference to the production order created in SAP S/4HANA PP or Siemens Opcenter MES to manufacture the goods required for this fulfillment plan. Bridges the order domain with manufacturing execution.',
    `production_planner` STRING COMMENT 'Name or employee ID of the production planner responsible for scheduling and monitoring the production activities associated with this fulfillment plan.',
    `route_code` STRING COMMENT 'SAP transportation route code defining the logistics path from the shipping point to the customer delivery address, including transit modes and intermediate stops.',
    `scheduling_type` STRING COMMENT 'Type of scheduling logic applied to determine production dates. Forward scheduling calculates the earliest possible delivery; backward scheduling works from the required delivery date to determine production start.. Valid values are `forward|backward|current_date`',
    `shipping_point` STRING COMMENT 'SAP shipping point from which the goods will be dispatched. Determines the physical loading dock, carrier assignment, and transportation routing for the fulfillment.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this fulfillment plan record originated. Supports data lineage tracking and multi-system reconciliation in the lakehouse.. Valid values are `SAP_S4HANA|OPCENTER_MES|ARIBA|INFOR_WMS|MANUAL`',
    `status` STRING COMMENT 'Current lifecycle status of the fulfillment plan, tracking progression from initial creation through execution to completion or cancellation.. Valid values are `draft|confirmed|in_progress|partially_fulfilled|fulfilled|cancelled|on_hold|exception`',
    `storage_location` STRING COMMENT 'SAP storage location within the plant from which goods will be picked and issued for this fulfillment plan. Used for warehouse management and inventory reservation.',
    `unit_of_measure` STRING COMMENT 'Unit of measure applicable to the planned and fulfilled quantities (e.g., EA for each, KG for kilogram, PC for piece). Aligned with SAP base unit of measure configuration.. Valid values are `EA|KG|LB|M|M2|M3|L|PC|SET|BOX|PAL`',
    CONSTRAINT pk_fulfillment_plan PRIMARY KEY(`fulfillment_plan_id`)
) COMMENT 'Fulfillment execution plan associated with a sales order or order line item, linking the commercial order to the production, procurement, and logistics actions required to fulfill it. Captures fulfillment plan ID, linked sales order, fulfillment mode (MTO, MTS, ETO, ATO), planned production order reference, planned procurement reference, planned delivery date, actual fulfillment date, fulfillment status, bottleneck flags, and exception alerts. Bridges the order domain with production and supply chain execution.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`goods_issue` (
    `goods_issue_id` BIGINT COMMENT 'Unique surrogate identifier for the goods issue event record in the Silver layer lakehouse. Serves as the primary key for this entity.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Goods issues from warehouse must be charged to the cost center responsible for shipping operations. Cost accounting uses this for warehouse operational cost tracking.',
    `delivery_order_id` BIGINT COMMENT 'Foreign key linking to order.delivery_order. Business justification: Goods issues are executed against a delivery order document. The string delivery_document_number is replaced by FK delivery_order_id.',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: Goods issue requires released inspection lot status. Warehouse system checks inspection lot approval before allowing goods movement to ensure only quality-approved material ships.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Goods issue transactions must track which warehouse employee physically released the goods for shipping. This is essential for inventory accountability, loss prevention, and operational performance tr',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: Goods issues are recorded at the order line item level for quantity tracking. The string sales_order_item_number is replaced by FK order_line_item_id.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Goods issue events are triggered by sales order fulfillment. The string sales_order_number is replaced by FK sales_order_id.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Goods issue documents record inventory leaving warehouse via shipments - financial posting and inventory reduction tied to physical shipment execution.',
    `actual_goods_issue_timestamp` TIMESTAMP COMMENT 'The precise date and time at which the goods issue was physically executed and posted in SAP S/4HANA. This timestamp is the definitive event marker for inventory reduction, revenue recognition eligibility, and order-to-cash milestone tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `batch_number` STRING COMMENT 'The production or supplier batch number of the material issued. Critical for batch traceability, quality recall management, and regulatory compliance (e.g., RoHS, REACH). Enables end-to-end lot traceability from production to customer delivery.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `cost_center` STRING COMMENT 'The SAP Controlling (CO) cost center to which the goods issue cost is allocated. Used for internal cost accounting, profitability analysis, and COGS reporting. Relevant for non-sales goods issues such as production consumption or internal transfers.. Valid values are `^[A-Z0-9]{4,10}$`',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the issued material was manufactured or substantially transformed. Required for customs declarations, export control compliance, and preferential trade agreement eligibility.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this goods issue record was first created in the source system (SAP S/4HANA). Used for audit trail, data lineage, and Silver layer ingestion tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `currency_code` STRING COMMENT 'The ISO 4217 three-letter currency code in which the goods issue value is expressed (e.g., USD, EUR, GBP). Supports multi-currency operations for multinational manufacturing entities.. Valid values are `^[A-Z]{3}$`',
    `delivery_item_number` STRING COMMENT 'Line item number within the outbound delivery document corresponding to this goods issue line, enabling precise traceability between the delivery and the material document.. Valid values are `^[0-9]{6}$`',
    `delivery_quantity` DECIMAL(18,2) COMMENT 'The quantity confirmed on the outbound delivery document for this item. Compared against issued_quantity to identify over/under-delivery situations and partial shipment scenarios.. Valid values are `^d+(.d{1,4})?$`',
    `document_date` DATE COMMENT 'The physical date on which the goods issue document was created, which may differ from the posting date. Used for document management and audit trail purposes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `document_item_number` STRING COMMENT 'Line item number within the goods issue material document, identifying the specific material line within a multi-line goods issue posting.. Valid values are `^[0-9]{4}$`',
    `document_number` STRING COMMENT 'The material document number generated in SAP S/4HANA upon posting the goods issue. This is the primary business identifier for the goods issue transaction and is referenced in downstream financial and logistics processes.. Valid values are `^[0-9]{10}$`',
    `export_control_status` STRING COMMENT 'The export control classification status of the goods issue, indicating whether the issued materials are subject to export licensing requirements or trade embargoes. Critical for regulatory compliance in multinational shipments.. Valid values are `not_restricted|license_required|license_approved|embargoed|under_review`',
    `goods_recipient` STRING COMMENT 'The name or identifier of the person or organizational unit designated as the recipient of the issued goods. Used for internal goods issue scenarios (e.g., production orders, cost centers) and for shipping documentation.',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether the issued material is classified as hazardous under applicable regulations (e.g., OSHA HazCom, EU CLP/GHS, IATA/IMDG dangerous goods). When true, special handling, labeling, and shipping documentation requirements apply.. Valid values are `true|false`',
    `incoterms_code` STRING COMMENT 'The International Commercial Terms (Incoterms) code applicable to this goods issue, defining the transfer of risk and responsibility between seller and buyer. Determines the point at which revenue recognition is triggered under IFRS 15.. Valid values are `^(EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF)$`',
    `issued_quantity` DECIMAL(18,2) COMMENT 'The quantity of material physically issued from stock, expressed in the base unit of measure. Negative values represent reversals. This quantity drives inventory reduction and is the basis for revenue recognition eligibility.. Valid values are `^-?d+(.d{1,4})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent modification to this goods issue record in the source system. Used for incremental data loading, change detection, and audit compliance in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `material_description` STRING COMMENT 'Short descriptive text for the issued material or finished good, providing human-readable identification for reporting, shipping documents, and customer-facing documentation.',
    `material_number` STRING COMMENT 'The SAP material master number identifying the material or finished good being issued. Used for inventory management, BOM traceability, and product costing.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `movement_type` STRING COMMENT 'SAP S/4HANA movement type code classifying the nature of the goods issue transaction (e.g., 601 = Goods Issue for Delivery, 261 = Goods Issue for Production Order, 551 = Scrapping). Determines the accounting entries and inventory impact.. Valid values are `^[0-9]{3}$`',
    `plant_code` STRING COMMENT 'The SAP plant code identifying the manufacturing plant or distribution center from which the goods were issued. Determines the organizational unit for inventory valuation, cost accounting, and regulatory compliance.. Valid values are `^[A-Z0-9]{4}$`',
    `posting_date` DATE COMMENT 'The accounting and inventory posting date on which the goods issue was recorded in the system. Determines the fiscal period for inventory reduction and revenue recognition eligibility in the order-to-cash process.. Valid values are `^d{4}-d{2}-d{2}$`',
    `profit_center` STRING COMMENT 'The SAP Controlling profit center associated with the goods issue, enabling profitability analysis by business segment, product line, or geographic region. Supports management reporting and EBITDA analysis.. Valid values are `^[A-Z0-9]{4,10}$`',
    `reversal_flag` BOOLEAN COMMENT 'Indicates whether this goods issue record represents a reversal (cancellation) of a previously posted goods issue. When true, the issued_quantity will be negative and the original document reference is captured in reversal_reference_document.. Valid values are `true|false`',
    `reversal_reference_document` STRING COMMENT 'The original goods issue material document number that this record reverses. Populated only when reversal_flag is true, enabling audit trail linkage between the original posting and its cancellation.. Valid values are `^[0-9]{10}$`',
    `route_code` STRING COMMENT 'The SAP transportation route code assigned to the delivery, defining the path from the shipping point to the customer destination. Used for freight cost calculation, transit time estimation, and logistics planning.. Valid values are `^[A-Z0-9]{1,6}$`',
    `serial_number` STRING COMMENT 'The unique serial number of the issued item for serialized materials. Enables individual unit traceability from goods issue through customer delivery and after-sales service, supporting warranty management and field service operations.. Valid values are `^[A-Z0-9-]{1,30}$`',
    `shipping_point` STRING COMMENT 'The SAP shipping point from which the goods were dispatched. Represents the organizational unit responsible for outbound shipment processing and determines the shipping execution team and dock assignment.. Valid values are `^[A-Z0-9]{4}$`',
    `sku_number` STRING COMMENT 'The Stock Keeping Unit (SKU) identifier for the issued material, used for warehouse management, order fulfillment tracking, and sales reporting. May differ from the material number in multi-SKU scenarios.. Valid values are `^[A-Z0-9-]{1,50}$`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this goods issue record was sourced (e.g., SAP_S4HANA for MM/SD postings, INFOR_WMS for warehouse-initiated issues). Supports data lineage and multi-system reconciliation in the lakehouse.. Valid values are `SAP_S4HANA|INFOR_WMS|MANUAL`',
    `special_stock_indicator` STRING COMMENT 'SAP special stock indicator identifying whether the issued material belongs to a special stock category such as sales order stock (E), project stock (Q), consignment stock (K), or returnable packaging (W). Affects inventory valuation and ownership.. Valid values are `^(E|Q|K|W|V|M|O|S|)?$`',
    `status` STRING COMMENT 'Current processing status of the goods issue document. posted indicates the inventory reduction has been recorded; reversed indicates a cancellation has been applied; blocked indicates a hold pending resolution; in_transit indicates goods are en route; confirmed indicates delivery confirmation received.. Valid values are `posted|reversed|blocked|in_transit|confirmed|cancelled`',
    `storage_location` STRING COMMENT 'The SAP storage location within the plant from which the material was physically picked and issued. Enables precise warehouse-level inventory tracking and supports WMS integration with Infor WMS.. Valid values are `^[A-Z0-9]{4}$`',
    `unit_of_measure` STRING COMMENT 'The base unit of measure in which the issued quantity is expressed (e.g., EA = Each, KG = Kilogram, M = Meter, L = Liter, PC = Piece). Aligned with SAP unit of measure codes and ISO standards.. Valid values are `^[A-Z]{2,6}$`',
    `unloading_point` STRING COMMENT 'The specific unloading point or dock at the customers delivery address where the goods are to be received. Sourced from the customer master or delivery document and used for last-mile logistics coordination.',
    `valuation_type` STRING COMMENT 'The inventory valuation method applied to calculate the goods issue value (e.g., moving average price, standard price, FIFO, LIFO). Determines how COGS is computed and reported in financial statements.. Valid values are `moving_average_price|standard_price|fifo|lifo`',
    `value` DECIMAL(18,2) COMMENT 'The total inventory value of the issued goods in the document currency, calculated as issued quantity multiplied by the moving average price or standard cost. Represents the COGS impact and triggers revenue recognition eligibility.. Valid values are `^-?d+(.d{1,2})?$`',
    `warehouse_number` STRING COMMENT 'The SAP Warehouse Management (WM) warehouse number associated with the storage location from which goods were issued. Used for detailed warehouse operations tracking and transfer order management.. Valid values are `^[A-Z0-9]{3}$`',
    CONSTRAINT pk_goods_issue PRIMARY KEY(`goods_issue_id`)
) COMMENT 'Goods issue event record capturing the physical departure of finished goods or components from the manufacturing plant or warehouse against a delivery order. Captures goods issue document number, posting date, delivery reference, material/SKU, issued quantity, unit of measure, storage location, batch number, movement type, plant, cost center, and goods issue status. Represents the inventory reduction event and triggers revenue recognition eligibility in the order-to-cash process. Sourced from SAP S/4HANA MM/SD goods issue posting.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`channel` (
    `channel_id` BIGINT COMMENT 'Unique surrogate identifier for each order channel record in the silver layer lakehouse. Serves as the primary key for all downstream joins and references.',
    `partner_id` BIGINT COMMENT 'Unique EDI partner identifier (ISA sender/receiver ID for ANSI X12 or interchange sender ID for EDIFACT) assigned to the trading partner operating through this channel. Used for EDI message routing and acknowledgment processing.',
    `fulfillment_mode_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_mode. Business justification: Order channels have a default fulfillment mode. The string fulfillment_mode_default is replaced by FK fulfillment_mode_id referencing the fulfillment_mode reference table.',
    `approval_required_above_value` DECIMAL(18,2) COMMENT 'Order value threshold above which additional management approval is required before order confirmation for this channel. Supports internal controls and delegation of authority policies for high-value orders.. Valid values are `^d+(.d{1,2})?$`',
    `atp_ctp_check_required` BOOLEAN COMMENT 'Indicates whether Available to Promise (ATP) or Capable to Promise (CTP) availability checks are mandatory for orders received through this channel. Ensures delivery date commitments are validated against inventory and production capacity.. Valid values are `true|false`',
    `category` STRING COMMENT 'Granular business category of the order channel aligned to the industrial manufacturing go-to-market model. Distinguishes between direct sales force, distributor networks, OEM partnerships, e-commerce portals, EDI-based automated ordering, field sales, inside sales, and agent/representative channels.. Valid values are `direct_sales|distributor|oem_partner|ecommerce|edi|field_sales|inside_sales|agent_rep|reseller|marketplace`',
    `code` STRING COMMENT 'Short alphanumeric business code uniquely identifying the order channel (e.g., DIR_SALES, DIST_01, OEM_PART, ECOMM, EDI_X12). Used as a natural key in ERP and CRM integrations and for order routing logic.. Valid values are `^[A-Z0-9_]{2,20}$`',
    `commission_eligible` BOOLEAN COMMENT 'Indicates whether orders received through this channel are eligible for sales commission calculation. True for field sales, agent/rep, and distributor channels; typically false for EDI and e-commerce self-service channels.. Valid values are `true|false`',
    `commission_rate_percent` DECIMAL(18,2) COMMENT 'Standard commission rate percentage applicable to orders processed through this channel. Used as the default rate in commission calculations for agent/rep and distributor channels. Confidential as it reflects commercial agreements.. Valid values are `^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the primary country where this order channel operates. Supports country-level channel performance reporting, regulatory compliance, and tax jurisdiction determination.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this order channel record was first created in the system. Used for audit trail, data lineage tracking, and compliance with data governance policies.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `credit_check_required` BOOLEAN COMMENT 'Indicates whether orders received through this channel require an automated credit check against the customer credit limit before order confirmation. Typically true for distributor and direct sales channels; may be false for pre-approved EDI or OEM partner channels.. Valid values are `true|false`',
    `crm_channel_code` STRING COMMENT 'Corresponding channel or lead source identifier in Salesforce CRM Sales Cloud. Enables cross-system reconciliation between SAP SD distribution channel records and CRM opportunity/lead source tracking for pipeline and conversion analytics.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code representing the default transaction currency for orders processed through this channel (e.g., USD, EUR, GBP). Supports multi-currency order processing and financial reporting.. Valid values are `^[A-Z]{3}$`',
    `distribution_channel_code` STRING COMMENT 'SAP two-character distribution channel code (e.g., 10 for Direct Sales, 20 for Distributor) mapped to this order channel. Used in SAP SD order processing, pricing determination, and customer master assignment.. Valid values are `^[A-Z0-9]{1,4}$`',
    `division_code` STRING COMMENT 'SAP division code representing the product line or business unit associated with this order channel. Used in combination with sales organization and distribution channel to form the sales area for order processing.. Valid values are `^[A-Z0-9]{1,4}$`',
    `edi_standard` STRING COMMENT 'Electronic Data Interchange (EDI) messaging standard used by this channel for automated order transmission. EDIFACT is common in European and global trade; ANSI X12 is standard in North American manufacturing. NONE indicates non-EDI channels.. Valid values are `EDIFACT|ANSI_X12|ODETTE|VDA|TRADACOMS|NONE`',
    `edi_transaction_set` STRING COMMENT 'EDI transaction set or message type used for order processing on this channel (e.g., 850 Purchase Order, 855 PO Acknowledgment for ANSI X12; ORDERS, ORDRSP for EDIFACT). Null for non-EDI channels.',
    `effective_date` DATE COMMENT 'Date from which this order channel became or becomes operationally active and eligible to receive orders. Used for channel lifecycle management, historical reporting, and ensuring orders are only routed through channels valid at the time of order creation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date on which this order channel ceases to be operationally active. Orders cannot be routed through an expired channel. Null indicates no planned expiry. Used for channel lifecycle management and contract renewal tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `export_control_applicable` BOOLEAN COMMENT 'Indicates whether orders processed through this channel are subject to export control regulations (e.g., EAR, ITAR, EU Dual-Use). Triggers export license checks and embargo screening during order processing for international channels.. Valid values are `true|false`',
    `incoterms_code` STRING COMMENT 'Default International Commercial Terms (Incoterms) code applicable to orders processed through this channel. Defines the default risk transfer and delivery obligation between seller and buyer. Can be overridden at the order level.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `language_code` STRING COMMENT 'ISO 639-1 language code for the primary language used in communications and documents for this order channel (e.g., en, de, fr, zh-CN). Supports multi-language order confirmation, invoice, and correspondence generation.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this order channel record. Used for change tracking, incremental data loading in the lakehouse pipeline, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lead_time_days` STRING COMMENT 'Standard order processing lead time in calendar days associated with this channel, from order receipt to shipment readiness. Used in delivery date calculation and Available to Promise (ATP) commitments for channel-specific fulfillment planning.. Valid values are `^d+$`',
    `max_order_value` DECIMAL(18,2) COMMENT 'Maximum net order value (in the channels default currency) permitted for orders submitted through this channel without additional approval. Orders exceeding this threshold trigger escalation workflows or require management authorization.. Valid values are `^d+(.d{1,2})?$`',
    `min_order_value` DECIMAL(18,2) COMMENT 'Minimum net order value (in the channels default currency) required for orders submitted through this channel. Orders below this threshold may be rejected or subject to a minimum order surcharge. Supports channel profitability management.. Valid values are `^d+(.d{1,2})?$`',
    `name` STRING COMMENT 'Full descriptive name of the order channel (e.g., Direct Sales, Distributor, OEM Partner, E-Commerce Portal, EDI, Field Sales, Inside Sales, Agent/Representative). Used in reporting, dashboards, and commission calculations.',
    `order_entry_method` STRING COMMENT 'Method by which orders are entered into the order management system through this channel. Distinguishes manual entry by sales staff, automated EDI transmission, customer self-service via portal, API-based integration, and traditional communication methods.. Valid values are `manual|edi_automated|portal_self_service|api_integration|email|phone|fax|field_sales_app`',
    `partner_agreement_number` STRING COMMENT 'Reference number of the commercial agreement, distributor contract, OEM partnership agreement, or agent/representative contract governing the terms of this order channel. Links to the contract management system for terms and conditions enforcement.',
    `payment_terms_code` STRING COMMENT 'Default payment terms code assigned to orders received through this channel (e.g., NET30, NET60, 2/10NET30). Sourced from SAP S/4HANA FI payment terms configuration and applied as the default during order creation.. Valid values are `^[A-Z0-9]{1,10}$`',
    `portal_integration_reference` STRING COMMENT 'Reference identifier or URL for the e-commerce portal, customer self-service portal, or partner portal integrated with this order channel. Used for technical integration mapping and portal performance monitoring.',
    `portal_type` STRING COMMENT 'Classification of the digital portal or platform associated with this order channel. Distinguishes between customer self-service portals, partner/distributor portals, OEM-specific portals, third-party marketplaces, and non-portal channels.. Valid values are `customer_self_service|partner_portal|distributor_portal|oem_portal|marketplace|internal|none`',
    `region_code` STRING COMMENT 'Geographic region code to which this order channel is primarily assigned (e.g., EMEA, APAC, AMER, LATAM). Used for regional channel performance reporting and sales territory management in multinational operations.. Valid values are `^[A-Z]{2,10}$`',
    `sales_organization_code` STRING COMMENT 'SAP sales organization code to which this order channel is assigned. Defines the legal entity and organizational unit responsible for selling through this channel. Enables channel performance reporting by sales organization.. Valid values are `^[A-Z0-9]{1,10}$`',
    `sla_order_confirmation_hours` STRING COMMENT 'Service Level Agreement (SLA) target in hours for order confirmation after receipt through this channel. Defines the maximum acceptable time from order receipt to order confirmation, used for channel performance monitoring and customer SLA compliance.. Valid values are `^d+$`',
    `source_system` STRING COMMENT 'Operational system of record from which this order channel record originates. Supports data lineage tracking, reconciliation between source systems, and silver layer provenance documentation in the Databricks lakehouse.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL|EDI_GATEWAY|OTHER`',
    `status` STRING COMMENT 'Current operational status of the order channel. Active channels are eligible to receive and process orders. Inactive or decommissioned channels are retained for historical reporting but excluded from new order routing.. Valid values are `active|inactive|suspended|pending_activation|decommissioned`',
    `tax_classification` STRING COMMENT 'Default tax classification for orders processed through this channel. Determines whether standard tax rates, exemptions, zero-rating, or reverse charge mechanisms apply. Used in SAP SD pricing procedures for tax determination.. Valid values are `taxable|exempt|zero_rated|reverse_charge`',
    `type` STRING COMMENT 'High-level classification of the order channel indicating whether orders are received through direct engagement, indirect intermediaries, digital/e-commerce platforms, EDI transmission, partner networks, or agent/representative arrangements. Drives commission eligibility and routing rules.. Valid values are `direct|indirect|digital|edi|partner|agent`',
    CONSTRAINT pk_channel PRIMARY KEY(`channel_id`)
) COMMENT 'Reference classification of the channels through which industrial manufacturing orders are received and processed. Captures channel code, channel name (direct sales, distributor, OEM partner, e-commerce portal, EDI, field sales, inside sales, agent/rep), channel type, applicable sales organization, commission eligibility flag, EDI standard (EDIFACT, ANSI X12), portal integration reference, and channel status. Used for order routing, commission calculation, and channel performance reporting.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` (
    `fulfillment_mode_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a fulfillment mode record in the Silver Layer lakehouse. Serves as the primary key for all downstream joins and references.',
    `applicable_product_families` STRING COMMENT 'Comma-separated list or descriptive text identifying the product families or product lines for which this fulfillment mode is applicable (e.g., automation systems, electrification solutions, smart infrastructure components). Used for order routing rules and product-mode compatibility validation.',
    `atp_applicable` BOOLEAN COMMENT 'Indicates whether Available to Promise (ATP) checking is applicable for orders assigned this fulfillment mode. ATP checks confirm delivery dates based on current stock and planned receipts. Typically true for MTS and ATO modes.. Valid values are `true|false`',
    `bom_explosion_trigger` STRING COMMENT 'Defines the business event that triggers Bill of Materials (BOM) explosion for this fulfillment mode. For ETO, BOM explosion may occur at engineering order creation; for MTO at production order creation; for MTS during MRP run. Drives integration between SAP SD and PP modules.. Valid values are `order_creation|production_order|sales_order|manual|not_applicable`',
    `capacity_reservation_required` BOOLEAN COMMENT 'Indicates whether production capacity must be reserved at order confirmation for this fulfillment mode. True for MTO and ETO modes where dedicated capacity is allocated per order. Drives integration with Siemens Opcenter MES scheduling and SAP S/4HANA PP capacity planning.. Valid values are `true|false`',
    `code` STRING COMMENT 'Short standardized code representing the manufacturing fulfillment strategy. Recognized industry codes: MTO (Make to Order), MTS (Make to Stock), ETO (Engineer to Order), ATO (Assemble to Order). Used in order processing logic, SAP S/4HANA SD configuration, and MRP planning strategy assignment.. Valid values are `MTO|MTS|ETO|ATO`',
    `configuration_required` BOOLEAN COMMENT 'Indicates whether product configuration (variant configuration) is required during order entry for this fulfillment mode. True for ATO (Assemble to Order) and ETO modes where customer-selected options drive BOM and routing. Drives SAP S/4HANA variant configuration logic.. Valid values are `true|false`',
    `contract_manufacturing_eligible` BOOLEAN COMMENT 'Indicates whether orders under this fulfillment mode are eligible for subcontracting or contract manufacturing. Relevant for MTO and ATO modes where external manufacturing partners may be engaged. Drives SAP Ariba supplier management and SAP S/4HANA MM subcontracting processes.. Valid values are `true|false`',
    `costing_method` STRING COMMENT 'Specifies the product costing method applied to orders under this fulfillment mode. MTS typically uses standard cost; MTO and ETO use actual or project-based costing. Impacts COGS calculation, EBITDA reporting, and SAP S/4HANA CO-PC cost object controlling.. Valid values are `standard_cost|actual_cost|project_cost|moving_average|not_applicable`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this fulfillment mode record was first created in the system. Supports audit trail requirements, data governance, and ISO 9001 documented information management.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `ctp_applicable` BOOLEAN COMMENT 'Indicates whether Capable to Promise (CTP) checking is applicable for orders assigned this fulfillment mode. CTP checks confirm delivery dates based on production capacity and material availability. Typically true for MTO and ETO modes.. Valid values are `true|false`',
    `customer_specific_design` BOOLEAN COMMENT 'Indicates whether this fulfillment mode involves customer-specific product design or engineering customization. True for ETO (Engineer to Order) where unique engineering is performed per customer specification. Impacts PLM, BOM management, and intellectual property classification.. Valid values are `true|false`',
    `delivery_scheduling_method` STRING COMMENT 'Defines the delivery scheduling method used to calculate confirmed delivery dates for orders under this fulfillment mode. Forward scheduling calculates from today; backward scheduling works from the requested delivery date. Drives SAP S/4HANA SD delivery scheduling and ATP/CTP logic.. Valid values are `forward_scheduling|backward_scheduling|atp_based|ctp_based|manual`',
    `demand_management_type` STRING COMMENT 'Classifies how demand is managed for this fulfillment mode in the MRP II planning cycle. Make-to-forecast drives independent demand planning; make-to-order and engineer-to-order are driven by dependent demand from confirmed sales orders. Aligns with SAP S/4HANA demand management configuration.. Valid values are `make_to_forecast|make_to_order|engineer_to_order|assemble_to_order`',
    `description` STRING COMMENT 'Detailed narrative description of the fulfillment strategy, including its operational characteristics, when it is applied, and how it impacts production planning, inventory, and customer commitments.',
    `digital_twin_applicable` BOOLEAN COMMENT 'Indicates whether a digital twin model is created and maintained for products manufactured under this fulfillment mode. Relevant for complex ETO and MTO products monitored via Siemens MindSphere IIoT platform for asset performance and predictive analytics.. Valid values are `true|false`',
    `effective_date` DATE COMMENT 'The date from which this fulfillment mode definition becomes valid and available for assignment to new orders. Supports temporal validity management and ensures only current fulfillment strategies are applied in order processing.. Valid values are `^d{4}-d{2}-d{2}$`',
    `engineering_change_required` BOOLEAN COMMENT 'Indicates whether an Engineering Change Notice (ECN) or Engineering Change Order (ECO) process is typically required before production can commence for this fulfillment mode. Always true for ETO mode; typically false for MTS and ATO modes. Drives integration with Siemens Teamcenter PLM change management.. Valid values are `true|false`',
    `expiry_date` DATE COMMENT 'The date after which this fulfillment mode definition is no longer valid for assignment to new orders. Null indicates no expiry. Supports lifecycle management of fulfillment strategies as business processes evolve.. Valid values are `^d{4}-d{2}-d{2}$`',
    `export_control_relevance` STRING COMMENT 'Indicates the export control screening requirement for orders under this fulfillment mode. ETO and specialized MTO products may always require export license checks; standard MTS products may only require checks when applicable. Ensures compliance with export regulations and CE Marking requirements.. Valid values are `always_check|check_if_applicable|not_applicable`',
    `inventory_consumption_model` STRING COMMENT 'Describes how this fulfillment mode interacts with finished goods inventory. MTS consumes existing stock; MTO builds against a specific order without consuming finished goods stock; ATO configures from component stock; ETO has no pre-existing stock. Drives WMS and inventory management logic.. Valid values are `consume_stock|build_to_order|configure_to_order|engineer_to_order|no_stock_consumption`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this fulfillment mode record was most recently updated. Supports change tracking, audit compliance, and incremental data loading in the Databricks Silver Layer pipeline.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `max_lead_time_days` STRING COMMENT 'Maximum number of calendar days required to fulfill an order under this fulfillment mode, representing the worst-case scenario under constrained conditions. Used for SLA commitments, customer promise dates, and capacity planning buffers.. Valid values are `^[0-9]+$`',
    `min_lead_time_days` STRING COMMENT 'Minimum number of calendar days required to fulfill an order under this fulfillment mode, representing the best-case scenario under optimal conditions. Used for ATP/CTP commitment calculations and customer delivery date negotiations.. Valid values are `^[0-9]+$`',
    `mrp_type` STRING COMMENT 'Specifies the Material Requirements Planning (MRP) type applied to materials under this fulfillment mode. Determines how SAP S/4HANA PP generates planned orders and procurement proposals. MTO and ETO modes typically use order-driven MRP; MTS uses forecast-driven MRP.. Valid values are `MRP|KANBAN|reorder_point|no_planning|manual`',
    `name` STRING COMMENT 'Full descriptive name of the fulfillment mode (e.g., Make to Order, Make to Stock, Engineer to Order, Assemble to Order). Used in user interfaces, reports, and customer-facing documents.',
    `order_to_cash_process_variant` STRING COMMENT 'Identifies the order-to-cash (O2C) process variant associated with this fulfillment mode. ETO typically follows a project-based O2C cycle; MTS follows a standard cycle; ATO may follow a configure-and-ship variant. Drives SAP S/4HANA SD process flow and billing plan configuration.. Valid values are `standard|project_based|service_based|consignment|third_party`',
    `partial_delivery_allowed` BOOLEAN COMMENT 'Indicates whether partial deliveries are permitted for orders under this fulfillment mode. MTS orders may allow partial delivery from available stock; ETO orders typically require complete delivery. Drives SAP S/4HANA SD delivery and shipping configuration.. Valid values are `true|false`',
    `planning_strategy_group` STRING COMMENT 'SAP S/4HANA MRP planning strategy group code associated with this fulfillment mode (e.g., 10 for MTS, 20 for MTO, 50 for ATO). Drives MRP II planning logic, demand management, and production order creation rules in the ERP system.',
    `ppap_required` BOOLEAN COMMENT 'Indicates whether Production Part Approval Process (PPAP) documentation is required before production release for this fulfillment mode. Typically required for ETO and new MTO products in automotive and industrial manufacturing contexts. Drives APQP and quality documentation workflows.. Valid values are `true|false`',
    `procurement_trigger` STRING COMMENT 'Defines the business event that triggers material procurement for this fulfillment mode. For ETO and MTO, procurement is triggered by the sales or production order; for MTS, procurement is triggered by MRP run against forecast. Drives SAP Ariba and SAP S/4HANA MM procurement integration.. Valid values are `sales_order|production_order|mrp_run|manual|not_applicable`',
    `production_order_creation_rule` STRING COMMENT 'Defines how production orders are created for this fulfillment mode. Automatic creation triggers production orders upon sales order confirmation; manual requires planner intervention; planned order conversion follows MRP II recommendations. Drives Siemens Opcenter MES scheduling integration.. Valid values are `automatic|manual|not_applicable|planned_order_conversion`',
    `quality_inspection_plan` STRING COMMENT 'Specifies the quality inspection plan type applicable to production under this fulfillment mode. ETO and MTO modes may require First Article Inspection (FAI) or customer witness testing; MTS follows standard AQL-based sampling. Drives SAP S/4HANA QM and QMS integration.. Valid values are `standard|enhanced|first_article|customer_witness|not_required`',
    `revenue_recognition_method` STRING COMMENT 'Specifies the revenue recognition method applicable to orders under this fulfillment mode. ETO and long-lead MTO orders may recognize revenue over time or at milestones; MTS recognizes at point of delivery. Ensures compliance with IFRS 15 and GAAP revenue recognition standards.. Valid values are `point_in_time|over_time|milestone_based|percentage_of_completion`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this fulfillment mode reference data originates (e.g., SAP S/4HANA SD, Siemens Opcenter MES). Supports data lineage tracking and Silver Layer reconciliation in the Databricks Lakehouse.',
    `status` STRING COMMENT 'Current operational status of the fulfillment mode record. Active modes are available for order assignment. Inactive modes are temporarily disabled. Deprecated modes are retained for historical reference only and cannot be assigned to new orders.. Valid values are `active|inactive|deprecated`',
    `typical_lead_time_days` STRING COMMENT 'Standard expected number of calendar days to fulfill an order under this fulfillment mode under normal operating conditions. Used as the default lead time for quotation generation, delivery scheduling, and customer communication.. Valid values are `^[0-9]+$`',
    `wip_tracking_required` BOOLEAN COMMENT 'Indicates whether detailed Work in Progress (WIP) tracking is required on the shop floor for orders under this fulfillment mode. True for MTO and ETO modes with complex multi-stage production. Drives Siemens Opcenter MES shop floor control and SAP S/4HANA CO-PC cost object controlling.. Valid values are `true|false`',
    CONSTRAINT pk_fulfillment_mode PRIMARY KEY(`fulfillment_mode_id`)
) COMMENT 'Reference data defining the manufacturing fulfillment strategies applicable to industrial orders. Captures fulfillment mode code, mode name (MTO - Make to Order, MTS - Make to Stock, ETO - Engineer to Order, ATO - Assemble to Order), mode description, typical lead time range, ATP/CTP applicability, BOM explosion trigger, production order creation rule, planning strategy group, and applicable product families. Drives order processing logic, lead time commitments, and production planning integration.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`priority` (
    `priority_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for each order priority level record in the reference classification table.',
    `applicable_plant_code` STRING COMMENT 'SAP plant code(s) for which this priority level configuration applies. Allows plant-specific lead time targets and scheduling weights to reflect differences in production capacity and capability across manufacturing sites.',
    `applicable_sales_organization` STRING COMMENT 'SAP sales organization code(s) for which this priority level is applicable. Supports multinational operations where priority definitions, lead times, and escalation rules may differ by regional sales organization.',
    `approval_authority_level` STRING COMMENT 'Minimum organizational authority level required to approve assignment or upgrade of an order to this priority level. Enforces governance controls for high-urgency priorities that carry significant cost and resource implications.. Valid values are `none|supervisor|manager|director|vp|executive`',
    `approval_required_flag` BOOLEAN COMMENT 'Indicates whether a formal management approval workflow must be completed before an order can be upgraded to or assigned this priority level. True for high-impact priorities such as Emergency and Critical to prevent unauthorized escalations.. Valid values are `true|false`',
    `category` STRING COMMENT 'Broad classification grouping priority levels by their business driver: operational (production-driven urgency), strategic (key account or revenue-driven), regulatory (compliance or safety mandate), or contractual (SLA-bound commitment).. Valid values are `operational|strategic|regulatory|contractual`',
    `code` STRING COMMENT 'Short alphanumeric code uniquely identifying the priority level, used in system integrations with SAP S/4HANA SD, MES scheduling, and WMS pick sequencing (e.g., STD, EXP, CRIT, EMER, STRAT).. Valid values are `^[A-Z0-9_]{2,20}$`',
    `color_code` STRING COMMENT 'Hexadecimal color code used to visually distinguish priority levels in shop floor Andon boards, MES dashboards, Power BI reports, and order management UI screens for rapid visual identification by operators and planners.. Valid values are `^#[0-9A-Fa-f]{6}$`',
    `cost_surcharge_percent` DECIMAL(18,2) COMMENT 'Percentage surcharge applied to the order net value to recover the incremental operational costs (overtime, expedited freight, premium materials sourcing) associated with fulfilling orders at this priority level.. Valid values are `^[0-9]{1,3}(.[0-9]{1,2})?$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this order priority level record was first created in the system, recorded in ISO 8601 format with timezone offset. Used for audit trail and configuration change management.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the base currency in which the max_order_value_threshold and cost_surcharge_percent monetary values are expressed.. Valid values are `^[A-Z]{3}$`',
    `customer_notification_required_flag` BOOLEAN COMMENT 'Indicates whether the customer must be proactively notified of priority assignment, status changes, or delivery updates for orders at this priority level, supporting SLA transparency and customer satisfaction management.. Valid values are `true|false`',
    `dedicated_resource_flag` BOOLEAN COMMENT 'Indicates whether orders at this priority level require dedicated production resources (machines, operators, cells) to be reserved exclusively for their fulfillment, preventing resource sharing with lower-priority orders.. Valid values are `true|false`',
    `description` STRING COMMENT 'Detailed narrative explaining the business conditions, criteria, and use cases that qualify an order for this priority level, including customer impact and operational implications.',
    `escalation_threshold_days` STRING COMMENT 'Number of days before the target ship date at which an unshipped order at this priority level triggers an automatic escalation notification to operations management and customer service.. Valid values are `^[0-9]+$`',
    `expedited_freight_flag` BOOLEAN COMMENT 'Indicates whether orders at this priority level are automatically routed to expedited or premium freight carriers to meet compressed delivery timelines, triggering premium freight cost allocation in the TMS.. Valid values are `true|false`',
    `fulfillment_mode_applicability` STRING COMMENT 'Specifies which order fulfillment modes (Make to Order, Make to Stock, Engineer to Order, Assemble to Order, or all modes) this priority level is applicable to, ensuring correct priority assignment during order entry and ATP/CTP checks.. Valid values are `all|mto|mts|eto|ato`',
    `icon_code` STRING COMMENT 'Icon identifier or symbol code used in UI systems and dashboards to visually represent the priority level alongside the color code, supporting rapid visual triage on shop floor HMI screens and order management portals.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this order priority level record was most recently updated, recorded in ISO 8601 format with timezone offset. Supports change tracking, audit compliance, and Silver layer incremental data loading.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `max_order_value_threshold` DECIMAL(18,2) COMMENT 'Maximum order net value (in base currency) up to which this priority level can be assigned without additional financial approval. Orders exceeding this threshold require escalated authorization to control premium fulfillment cost exposure.',
    `name` STRING COMMENT 'Human-readable name of the priority level used in UI displays, reports, and customer-facing communications. Standard values include Standard, Expedite, Critical, Emergency, and Strategic Account.. Valid values are `Standard|Expedite|Critical|Emergency|Strategic Account`',
    `nps_impact_level` STRING COMMENT 'Qualitative assessment of the potential impact on customer Net Promoter Score (NPS) if orders at this priority level are not fulfilled on time. Used to prioritize customer communication and recovery actions.. Valid values are `low|medium|high|critical`',
    `overtime_authorization_flag` BOOLEAN COMMENT 'Indicates whether orders assigned this priority level automatically authorize shop floor overtime to meet the target lead time, enabling MES and workforce scheduling systems to plan extended shifts without separate approval.. Valid values are `true|false`',
    `production_scheduling_weight` DECIMAL(18,2) COMMENT 'Numeric weighting factor applied by the MES and MRP scheduling engine to sequence production jobs for orders at this priority level. Higher values result in earlier scheduling slots and preferential resource allocation.. Valid values are `^[0-9]{1,3}(.[0-9]{1,2})?$`',
    `rank` STRING COMMENT 'Numeric rank defining the relative urgency ordering of priority levels, where lower values indicate higher urgency (e.g., 1 = Emergency, 2 = Critical, 3 = Expedite, 4 = Strategic Account, 5 = Standard). Used for automated sequencing logic.. Valid values are `^[1-9][0-9]*$`',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether this priority level is designated for orders that must be fulfilled to meet regulatory, safety, or government mandate deadlines (e.g., CE Marking compliance shipments, OSHA-mandated safety equipment orders).. Valid values are `true|false`',
    `sla_breach_notification_hours` STRING COMMENT 'Number of hours before the committed delivery deadline at which an automated SLA breach warning notification is triggered for orders at this priority level, enabling proactive intervention by customer service and operations teams.. Valid values are `^[0-9]+$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this priority level configuration originates or is mastered, supporting data lineage tracking and reconciliation across SAP S/4HANA, Siemens Opcenter MES, and Salesforce CRM.. Valid values are `SAP_S4HANA|OPCENTER_MES|SALESFORCE_CRM|MANUAL|OTHER`',
    `status` STRING COMMENT 'Lifecycle status of the priority level record indicating whether it is currently available for assignment to orders (active), temporarily disabled (inactive), or retired from use (deprecated).. Valid values are `active|inactive|deprecated`',
    `strategic_account_flag` BOOLEAN COMMENT 'Indicates whether this priority level is reserved for orders from designated strategic accounts (key customers with high revenue, long-term contracts, or critical partnership status), enabling preferential treatment in fulfillment sequencing.. Valid values are `true|false`',
    `supplier_expedite_flag` BOOLEAN COMMENT 'Indicates whether procurement teams should automatically initiate supplier expediting actions (accelerated PO delivery, premium sourcing) for materials required to fulfill orders at this priority level.. Valid values are `true|false`',
    `target_order_to_ship_lead_time_days` STRING COMMENT 'Target number of calendar days from order receipt to shipment dispatch for orders assigned this priority level. Used as the baseline commitment for SLA management and ATP/CTP confirmation.. Valid values are `^[0-9]+$`',
    `valid_from_date` DATE COMMENT 'Date from which this priority level configuration becomes effective and available for assignment to orders. Supports time-bounded priority configurations for seasonal demand peaks or special business programs.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'Date after which this priority level configuration expires and is no longer available for new order assignments. Null indicates no expiry. Used to retire legacy priority codes without deleting historical records.. Valid values are `^d{4}-d{2}-d{2}$`',
    `warehouse_pick_priority` STRING COMMENT 'Numeric priority value passed to the WMS (Infor WMS) to sequence warehouse pick tasks for outbound shipments. Lower values indicate higher pick urgency and earlier task assignment to warehouse operatives.. Valid values are `^[1-9][0-9]*$`',
    CONSTRAINT pk_priority PRIMARY KEY(`priority_id`)
) COMMENT 'Reference classification of order priority levels used to manage fulfillment sequencing and resource allocation in industrial manufacturing operations. Captures priority code, priority name (standard, expedite, critical, emergency, strategic account), priority description, target order-to-ship lead time, escalation threshold days, production scheduling weight, warehouse pick priority, and approval required flag for priority upgrades. Supports shop floor scheduling and customer SLA management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`credit_check` (
    `credit_check_id` BIGINT COMMENT 'Unique system-generated identifier for each credit check evaluation record performed on a customer sales order within the order-to-cash process.',
    `ar_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ar_invoice. Business justification: Credit checks reference existing AR invoices to evaluate customer payment history and outstanding balances. Credit management teams use this to approve or block new orders.',
    `credit_profile_id` BIGINT COMMENT 'Foreign key linking to customer.credit_profile. Business justification: Credit checks evaluate customer credit profiles to determine order approval limits. Finance teams use this to assess risk and set credit holds on orders.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Credit checks require approval by authorized credit analysts or finance employees. Tracking who performed the credit review is mandatory for financial controls, compliance, and risk management.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Credit checks are performed on specific sales orders to assess credit exposure. The string sales_order_number is replaced by FK sales_order_id.',
    `available_credit_amount` DECIMAL(18,2) COMMENT 'Remaining credit available to the customer at the time of the check, calculated as credit limit minus current exposure. A negative value indicates the customer has exceeded their credit limit.',
    `check_date` DATE COMMENT 'The calendar date on which the credit check evaluation was performed against the customers credit account, used for aging analysis and audit trails.. Valid values are `^d{4}-d{2}-d{2}$`',
    `check_number` STRING COMMENT 'Business-facing alphanumeric reference number assigned to the credit check evaluation, used for cross-referencing in order management and financial controls.. Valid values are `^CC-[0-9]{10}$`',
    `check_timestamp` TIMESTAMP COMMENT 'Precise date and time when the credit check was executed in the system, supporting audit compliance and SLA measurement for order processing workflows.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `check_type` STRING COMMENT 'Classification of the credit check method applied. Static checks compare current exposure against a fixed credit limit. Dynamic checks include open orders and deliveries in the exposure calculation. Manual checks are initiated by a credit analyst.. Valid values are `static|dynamic|automatic|manual`',
    `checking_rule` STRING COMMENT 'SAP credit management checking rule code that defines which credit check procedure is applied (e.g., which exposure components are included, which thresholds trigger a block or warning).',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity under which the sales order and credit check are processed, used for financial reporting and multi-entity credit management.. Valid values are `^[A-Z0-9]{4}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customers billing country, used for regional credit policy application, regulatory compliance, and export credit risk assessment.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the credit check record was first created in the system, used for audit trail, data lineage, and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `credit_control_area` STRING COMMENT 'Organizational unit in SAP FI that defines the credit management scope. A credit control area may encompass one or more company codes and governs credit limit assignment and monitoring.',
    `credit_horizon_date` DATE COMMENT 'Future date up to which open sales orders and deliveries are included in the dynamic credit exposure calculation. Orders with delivery dates beyond this horizon are excluded from the exposure.. Valid values are `^d{4}-d{2}-d{2}$`',
    `credit_limit_amount` DECIMAL(18,2) COMMENT 'The maximum approved credit exposure amount authorized for the customer within the credit control area at the time of the credit check. Represents the ceiling against which current exposure is measured.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which all monetary amounts (credit limit, exposure, available credit, order value) are expressed for this credit check record.. Valid values are `^[A-Z]{3}$`',
    `current_exposure_amount` DECIMAL(18,2) COMMENT 'Total credit exposure of the customer at the time of the credit check, including open receivables, open sales orders, open deliveries, and open billing documents. Compared against the credit limit to determine check outcome.',
    `customer_account_number` STRING COMMENT 'The customer credit account reference number from the financial system used to retrieve the customers credit profile, credit limit, and exposure data.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the credit check record was last updated in the system, supporting change tracking, audit compliance, and data freshness monitoring in the Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic credit review of the customer account, used by credit management teams to proactively reassess credit limits and risk categories.. Valid values are `^d{4}-d{2}-d{2}$`',
    `oldest_open_item_days` STRING COMMENT 'Number of days since the oldest unpaid open receivable item for the customer, used as an indicator of payment behavior and credit risk during the check evaluation.. Valid values are `^[0-9]+$`',
    `open_deliveries_amount` DECIMAL(18,2) COMMENT 'Total value of goods delivered to the customer but not yet invoiced, included in the dynamic credit exposure calculation to capture unbilled revenue risk.',
    `open_orders_amount` DECIMAL(18,2) COMMENT 'Total value of open (undelivered) sales orders for the customer included in the dynamic credit exposure calculation, representing committed but not yet invoiced revenue.',
    `open_receivables_amount` DECIMAL(18,2) COMMENT 'Total value of outstanding accounts receivable (unpaid invoices) from the customer included in the dynamic credit exposure calculation at the time of the check.',
    `order_value_amount` DECIMAL(18,2) COMMENT 'Net value of the sales order that triggered the credit check. This amount is included in the exposure calculation to determine whether the order can be approved within the customers available credit.',
    `override_flag` BOOLEAN COMMENT 'Indicates whether the credit check result was manually overridden by an authorized user, bypassing the automated credit evaluation outcome. Critical for audit and SOX compliance tracking.. Valid values are `true|false`',
    `override_reason` STRING COMMENT 'Free-text justification provided by the authorized user when overriding the automated credit check result, required for audit trail and financial controls compliance.',
    `payment_index` DECIMAL(18,2) COMMENT 'Numerical score reflecting the customers historical payment behavior and timeliness, used as an input to the credit risk assessment. Higher values indicate better payment performance.',
    `release_authorization_level` STRING COMMENT 'Authorization level required to release a blocked sales order from credit hold. Higher levels indicate greater credit exposure or risk, requiring more senior approval to release.. Valid values are `level_1|level_2|level_3|executive`',
    `release_reason_code` STRING COMMENT 'Coded reason provided by the credit analyst when releasing a blocked order from credit hold (e.g., prepayment received, credit limit increase approved, exception granted).',
    `release_timestamp` TIMESTAMP COMMENT 'Date and time when a blocked sales order was released from credit hold by an authorized user, used for SLA measurement and audit compliance in the order-to-cash process.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `released_by` STRING COMMENT 'User ID or name of the credit analyst or manager who authorized the release of a blocked sales order from credit hold, supporting audit trail and segregation of duties compliance.',
    `result` STRING COMMENT 'Outcome of the credit check evaluation indicating whether the sales order was approved for processing, blocked pending credit review, or flagged with a warning for analyst attention.. Valid values are `approved|blocked|warning|released`',
    `risk_category` STRING COMMENT 'Risk classification assigned to the customer at the time of the credit check, derived from the customers credit profile, payment history, and financial standing. Used to determine credit check rules and thresholds.. Valid values are `low|medium|high|very_high|blocked`',
    `sales_organization` STRING COMMENT 'SAP organizational unit responsible for the sale of goods or services, used to determine applicable credit management rules and reporting hierarchy for the credit check.',
    `source_system` STRING COMMENT 'Identifies the originating system from which the credit check record was sourced (e.g., SAP S/4HANA automated credit management, manual entry, or external credit agency integration).. Valid values are `SAP_S4HANA|MANUAL|EXTERNAL_AGENCY`',
    `status` STRING COMMENT 'Current processing status of the credit check record, indicating whether the evaluation is still open, has been completed, was overridden by an authorized user, or cancelled.. Valid values are `open|completed|overridden|cancelled`',
    `utilization_percent` DECIMAL(18,2) COMMENT 'Percentage of the customers credit limit consumed by current exposure at the time of the credit check. Calculated as (current_exposure_amount / credit_limit_amount) * 100. Used for risk monitoring and reporting.. Valid values are `^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$`',
    CONSTRAINT pk_credit_check PRIMARY KEY(`credit_check_id`)
) COMMENT 'Credit check evaluation record performed on a customer sales order to assess credit exposure against approved credit limits. Captures check ID, linked sales order, customer credit account reference, credit check date, credit check type (static, dynamic), current credit exposure, credit limit, available credit, check result (approved, blocked, warning), risk category, credit control area, and release authorization. Supports order-to-cash risk management and financial controls. Sourced from SAP S/4HANA FI credit management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`export_control_check` (
    `export_control_check_id` BIGINT COMMENT 'Unique system-generated identifier for each export control compliance check record. Serves as the primary key for the export_control_check data product.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Export control checks are regulatory requirements where specific certified compliance officers must review and approve international shipments. Employee certification and accountability are legally ma',
    `export_classification_id` BIGINT COMMENT 'Foreign key linking to compliance.export_classification. Business justification: Export control checks validate orders against specific export classifications (ECCN/HTS codes). Trade compliance teams use this daily to determine if orders can ship to specific countries/customers pe',
    `hazardous_substance_id` BIGINT COMMENT 'Foreign key linking to product.hazardous_substance. Business justification: Export checks identify hazardous materials requiring special handling and documentation. Shipping department uses this for proper labeling and carrier selection.',
    `hse_reach_substance_declaration_id` BIGINT COMMENT 'Foreign key linking to hse.reach_substance_declaration. Business justification: Export compliance teams verify REACH substance declarations before approving international shipments of industrial equipment. Required for EU exports and blocked orders without valid declarations.',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: Export control checks can be performed at the line item level for specific materials. The string order_line_item_number is replaced by FK order_line_item_id.',
    `product_regulatory_certification_id` BIGINT COMMENT 'Foreign key linking to product.regulatory_certification. Business justification: Export compliance checks verify products have required certifications (CE, UL, ATEX) for destination country. Logistics and compliance teams use this before shipment.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Export control checks are performed on sales orders involving cross-border shipments. The string sales_order_number is replaced by FK sales_order_id.',
    `sanctions_screening_id` BIGINT COMMENT 'Foreign key linking to compliance.sanctions_screening. Business justification: Each export control check references a sanctions screening result to verify customer/destination against denied parties lists (OFAC, BIS). Required before order release in manufacturing exports.',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the export control check was approved or cleared by the authorized compliance officer. Used for audit trail and SLA measurement.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `approved_by` STRING COMMENT 'User ID or name of the compliance officer or authorized approver who cleared or approved the export control check, particularly for manual reviews, overrides, or high-risk transactions.',
    `blocked_reason_code` STRING COMMENT 'Standardized reason code explaining why the export control check resulted in a blocked status. Used for compliance reporting, root cause analysis, and order block management.. Valid values are `EMBARGO|DENIED_PARTY|LICENSE_REQUIRED|ECCN_RESTRICTED|END_USE_PROHIBITED|PENDING_DOCUMENTATION|OTHER`',
    `check_date` DATE COMMENT 'Calendar date on which the export control compliance check was initiated or performed.. Valid values are `^d{4}-d{2}-d{2}$`',
    `check_method` STRING COMMENT 'Method by which the export control check was performed. Automated = system-driven screening via integrated compliance tool; Manual = performed by a compliance analyst; Hybrid = automated screening with manual review overlay.. Valid values are `automated|manual|hybrid`',
    `check_number` STRING COMMENT 'Human-readable business reference number assigned to the export control check, used for tracking and communication across compliance, legal, and sales teams.. Valid values are `^ECC-[0-9]{4}-[0-9]{6}$`',
    `check_timestamp` TIMESTAMP COMMENT 'Precise date and time when the export control check was executed, including timezone offset. Used for audit trail and SLA compliance tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `consignee_name` STRING COMMENT 'Legal name of the consignee — the party to whom the goods are shipped. Subject to denied party screening and may differ from the end customer. Required on export documentation.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the export control check record was created in the system. Used for audit trail, data lineage, and compliance record retention.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `denied_party_screening_result` STRING COMMENT 'Result of screening the end customer, consignee, and intermediaries against denied party, debarred, and restricted entity lists including BIS Entity List, OFAC SDN List, DDTC Debarred List, and EU Consolidated List. Potential Match requires manual review.. Valid values are `pass|fail|potential_match|not_applicable`',
    `destination_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the shipment destination. Used to determine applicable export regulations, embargo restrictions, and license requirements.. Valid values are `^[A-Z]{3}$`',
    `eccn` STRING COMMENT 'Export Control Classification Number assigned to the product per the Commerce Control List (CCL). Determines which export regulations apply and whether a license is required for the destination country and end use.. Valid values are `^[0-9][A-E][0-9]{3}[a-z]?$`',
    `embargo_check_result` STRING COMMENT 'Result of the embargo screening against OFAC, EU, UN, and other sanctioned country lists. Pass indicates no embargo match; Fail indicates the destination or party is subject to embargo restrictions; Not Applicable for domestic transactions.. Valid values are `pass|fail|not_applicable`',
    `end_customer_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the end customers registered country. Used for denied party screening and end-use control assessments.. Valid values are `^[A-Z]{3}$`',
    `end_customer_name` STRING COMMENT 'Legal name of the ultimate end customer or end user of the exported product. Required for denied party screening and end-use certificate documentation. May differ from the ship-to party in the sales order.',
    `end_use_certificate_number` STRING COMMENT 'Reference number of the End-Use Certificate or End-User Statement obtained from the customer, confirming the declared end use and end user. Required for controlled items and certain license applications.',
    `end_use_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code where the exported product will ultimately be used. May differ from destination country in re-export or transit scenarios, and is critical for end-use control assessments.. Valid values are `^[A-Z]{3}$`',
    `end_use_description` STRING COMMENT 'Description of the intended end use of the exported product as declared by the end customer. Used to assess whether the end use is prohibited (e.g., weapons of mass destruction, military end use) under EAR Part 744 or ITAR.',
    `eu_dual_use_code` STRING COMMENT 'European Union dual-use classification code per Annex I of EU Regulation 2021/821. Applicable for shipments from EU member states and determines EU export license requirements.',
    `exporting_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country from which the goods are being exported. Determines which national export control regulations apply (e.g., US EAR/ITAR, EU Dual-Use, UK OGEL).. Valid values are `^[A-Z]{3}$`',
    `hs_code` STRING COMMENT 'Harmonized System tariff classification code for the exported product, used for customs declaration and cross-referencing with export control classification lists.. Valid values are `^[0-9]{6,10}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the export control check record was last updated. Tracks changes to check status, screening results, license information, or override decisions.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `license_exception_code` STRING COMMENT 'EAR license exception code that authorizes the export without a specific license, when applicable. Examples include EAR99 (no CCL classification), LVS (low value shipment), STA (strategic trade authorization), TSR (technology and software under restriction).. Valid values are `EAR99|LVS|GBS|CIV|TSR|APP|STA|TMP|RPL|GOV|TSU|BAG|AVS|NLR|`',
    `license_expiry_date` DATE COMMENT 'Date on which the export license expires. Shipments must be completed before this date or a license renewal must be obtained. Critical for compliance monitoring and order scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `license_number` STRING COMMENT 'Official export license number issued by the relevant regulatory authority (e.g., BIS for EAR, DDTC for ITAR, or EU member state authority) authorizing the shipment. Populated when license_required_flag is true and a license has been obtained.',
    `license_required_flag` BOOLEAN COMMENT 'Indicates whether an export license is required for this shipment based on the product ECCN, destination country, and end use. True = license required; False = no license required (NLR or license exception applies).. Valid values are `true|false`',
    `material_number` STRING COMMENT 'SAP material number of the product subject to the export control check. Used to retrieve the products ECCN, HS code, and other classification data from the product master.',
    `override_flag` BOOLEAN COMMENT 'Indicates whether a compliance analyst or authorized approver manually overrode an automated check result. True = override applied; False = no override. Triggers mandatory documentation and audit trail requirements.. Valid values are `true|false`',
    `override_reason` STRING COMMENT 'Documented justification provided by the approver when overriding an automated export control check result. Required when override_flag is true for audit and regulatory purposes.',
    `recheck_required_flag` BOOLEAN COMMENT 'Indicates whether this export control check requires re-screening due to changes in the order, product classification, destination, end customer, or regulatory list updates. True = re-check required before shipment.. Valid values are `true|false`',
    `regulatory_authority` STRING COMMENT 'Government authority responsible for the applicable export control regulations. BIS = Bureau of Industry and Security (EAR); DDTC = Directorate of Defense Trade Controls (ITAR); OFAC = Office of Foreign Assets Control (sanctions); EU_MEMBER_STATE = relevant EU national authority; HMRC = UK authority.. Valid values are `BIS|DDTC|OFAC|EU_MEMBER_STATE|HMRC|OTHER`',
    `regulatory_framework` STRING COMMENT 'Primary export control regulatory framework governing this check. EAR = US Export Administration Regulations; ITAR = International Traffic in Arms Regulations; EU_DUAL_USE = EU Dual-Use Regulation 2021/821; UK_OGEL = UK Open General Export Licence; WASSENAAR = Wassenaar Arrangement; COMBINED = multiple frameworks apply.. Valid values are `EAR|ITAR|EU_DUAL_USE|UK_OGEL|WASSENAAR|COMBINED|OTHER`',
    `risk_classification` STRING COMMENT 'Risk level assigned to this export transaction based on the combination of product classification, destination country, end customer, and end use. Drives escalation and review workflows.. Valid values are `low|medium|high|critical`',
    `sales_organization` STRING COMMENT 'SAP sales organization code associated with the sales order subject to this export control check. Determines the legal entity responsible for the export and the applicable regulatory jurisdiction.',
    `screening_tool` STRING COMMENT 'Name or identifier of the third-party or internal compliance screening tool used to perform denied party and embargo checks (e.g., SAP GTS, Visual Compliance, Amber Road, Descartes).',
    `status` STRING COMMENT 'Current lifecycle status of the export control check. Cleared indicates the shipment is approved to proceed; Blocked indicates a compliance hold; Pending Review requires manual analyst review; Expired indicates the check validity period has lapsed; Cancelled indicates the check was voided.. Valid values are `cleared|blocked|pending_review|expired|cancelled`',
    `us_ml_category` STRING COMMENT 'United States Munitions List category designation under ITAR, if applicable. Indicates the product is defense-related and subject to State Department jurisdiction rather than Commerce Department.',
    `validity_expiry_date` DATE COMMENT 'Date on which the export control check result expires and a re-screening is required. Checks have a defined validity period based on regulatory requirements and internal policy; expired checks must be renewed before shipment.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_export_control_check PRIMARY KEY(`export_control_check_id`)
) COMMENT 'Export control compliance check record for sales orders involving cross-border shipment of industrial automation, electrification, or smart infrastructure products subject to export regulations. Captures check ID, linked sales order, destination country, end customer identity, product ECCN (Export Control Classification Number), license requirement flag, license number, embargo check result, denied party screening result, check date, check status (cleared, blocked, pending review), and regulatory authority reference. Supports ITAR, EAR, and EU dual-use compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`text` (
    `text_id` STRING COMMENT 'Business-level text identifier as assigned by the source system (e.g., SAP text ID such as 0001, ZINT, ZEXT). Identifies the specific text object within the source document context.',
    `delivery_order_id` BIGINT COMMENT 'Foreign key linking to order.delivery_order. Business justification: Order texts can be associated with delivery documents (e.g., shipping instructions). A nullable FK delivery_order_id is added.',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: Order texts can be associated with specific line items. The polymorphic string document_item_number is replaced by nullable FK order_line_item_id.',
    `order_quotation_id` BIGINT COMMENT 'Foreign key linking to order.quotation. Business justification: Order texts can be associated with quotations. A nullable FK quotation_id is added. document_number already removed via sales_order_id link.',
    `previous_version_text_id` STRING COMMENT 'Reference to the order_text_id of the immediately preceding version of this text record. Supports version chain navigation and audit trail reconstruction for compliance and dispute resolution purposes.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Order texts are associated with sales orders as the primary document type. The polymorphic string document_number is replaced by nullable FK sales_order_id (null when text belongs to quotation or deli',
    `category` STRING COMMENT 'Structural category indicating whether the text is associated with the document header, a specific line item, a partner function (e.g., ship-to, sold-to), or a pricing condition. Determines the scope and applicability of the text within the document.. Valid values are `header_text|item_text|partner_text|condition_text`',
    `confidentiality_level` STRING COMMENT 'Data sensitivity classification of the text content, governing access control and distribution. Restricted texts may contain trade secrets, legal instructions, or export-controlled information; confidential texts contain sensitive business data; internal texts are for company use only.. Valid values are `public|internal|confidential|restricted`',
    `content` STRING COMMENT 'Full free-text or structured content of the note or instruction. May contain customer-specific delivery instructions, internal processing guidance, technical specifications, quality requirements, packing instructions, or communication records associated with the order document.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country context for this text record (typically the ship-to or sold-to country). Supports country-specific text determination, regulatory compliance notes, and multilingual document generation.. Valid values are `^[A-Z]{3}$`',
    `created_by_name` STRING COMMENT 'Full name of the user who created the text record. Provides a human-readable identifier for reporting and business communication, complementing the technical user ID.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the text record was originally created in the source system, stored in ISO 8601 format with timezone offset. Essential for audit trail, SLA measurement, and order communication timeline reconstruction.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `document_type` STRING COMMENT 'Classification of the parent business document to which this text record is linked. Determines the business context and processing rules for the text content.. Valid values are `sales_order|quotation|delivery|returns_order|rfq|contract|billing_document`',
    `export_control_relevant` BOOLEAN COMMENT 'Indicates whether the text content contains export-controlled information subject to trade compliance regulations (e.g., EAR, ITAR, EU Dual-Use). When true, the text must be reviewed by the export compliance team before sharing with external parties.. Valid values are `true|false`',
    `format` STRING COMMENT 'Format type of the text content, indicating how the content should be rendered or parsed. Plain text is the default; HTML or RTF may be used for customer-facing documents; structured format applies to machine-readable instruction blocks.. Valid values are `plain_text|html|rtf|structured`',
    `hazardous_goods_relevant` BOOLEAN COMMENT 'Indicates whether the text contains hazardous goods handling instructions, safety warnings, or dangerous goods declarations required for transport compliance. Relevant for shipments subject to ADR, IATA DGR, or IMDG regulations.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'ISO 639-1 two-letter language code indicating the language in which the text content is written (e.g., EN for English, DE for German, FR for French, ZH for Chinese). Supports multilingual order communication in global operations.. Valid values are `^[A-Z]{2}$`',
    `last_modified_by` STRING COMMENT 'User ID of the person who most recently modified the text record. Supports change accountability and audit trail requirements for order documentation.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the text record. Used for change tracking, delta processing in ETL pipelines, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `length_chars` STRING COMMENT 'Number of characters in the text content field. Used for data quality monitoring, storage planning, and identifying unusually long or empty text records that may require review.. Valid values are `^[0-9]+$`',
    `object` STRING COMMENT 'SAP text object identifier indicating the business entity type to which the text belongs (e.g., VBBK for sales order header, VBBP for sales order item, LIKP for delivery header). Supports text determination and retrieval logic.. Valid values are `VBBK|VBBP|LIKP|LIPS|VBKD|KUAGV|KNVV`',
    `print_indicator` BOOLEAN COMMENT 'Flag indicating whether this text should be included in printed or electronically transmitted order documents such as order confirmations, delivery notes, packing lists, or invoices sent to customers or carriers.. Valid values are `true|false`',
    `quality_relevant` BOOLEAN COMMENT 'Indicates whether the text contains quality-related instructions, inspection requirements, or quality notes that must be communicated to the production or quality assurance team. Supports QMS integration and CAPA traceability.. Valid values are `true|false`',
    `sales_organization` STRING COMMENT 'SAP sales organization code associated with the parent document. Provides organizational context for the text record, enabling filtering and reporting by sales entity in multinational operations.',
    `sequence_number` STRING COMMENT 'Ordering sequence number for multiple text records of the same type on the same document or document item. Determines the display and print order when multiple notes of the same text type exist.. Valid values are `^[0-9]+$`',
    `source_object_type` STRING COMMENT 'Type of the originating business object from which this text was copied or inherited. Indicates whether the text originated from a customer master record, material master, prior quotation, contract, or was manually entered by a user.. Valid values are `customer_master|material_master|quotation|contract|sales_order|manual_entry`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this text record was extracted. Supports data lineage, reconciliation, and multi-system integration in the silver layer lakehouse.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|TEAMCENTER_PLM|MANUAL|OTHER`',
    `source_system_text_key` STRING COMMENT 'Natural key or composite key of the text record as it exists in the source system (e.g., SAP text key combining client, text object, text name, and language). Enables exact record traceability back to the originating system for reconciliation and debugging.',
    `source_text_reference` STRING COMMENT 'Reference identifier of the originating text record from which this text was copied or derived (e.g., copied from a quotation text, a customer master text, or a material master text). Supports text lineage and traceability.',
    `status` STRING COMMENT 'Current lifecycle status of the text record. Active records are in use; superseded records have been replaced by a newer version; deleted records have been logically removed; archived records are retained for compliance but no longer operationally active.. Valid values are `active|superseded|deleted|archived`',
    `transfer_to_delivery_flag` BOOLEAN COMMENT 'Indicates whether this text should be automatically copied and transferred to the associated delivery document during order-to-delivery processing. Ensures shipping notes and packing instructions flow through to warehouse and logistics execution.. Valid values are `true|false`',
    `transfer_to_invoice_flag` BOOLEAN COMMENT 'Indicates whether this text should be automatically copied to the billing document (invoice) during the billing run. Relevant for customer-facing notes that must appear on invoices for legal, contractual, or communication purposes.. Valid values are `true|false`',
    `type_code` STRING COMMENT 'Standardized classification code identifying the business purpose and nature of the text content. Drives text determination, visibility rules, and downstream processing in order-to-cash workflows.. Valid values are `customer_instruction|internal_note|shipping_note|packing_instruction|technical_note|quality_note|delivery_note|billing_note|legal_note|compliance_note|hazardous_goods_note|export_note`',
    `type_name` STRING COMMENT 'Human-readable description of the text type code, providing a clear label for reporting, UI display, and business user communication (e.g., Customer Instructions, Internal Processing Note, Shipping Note).',
    `valid_from_date` DATE COMMENT 'Start date from which this text record is considered valid and applicable. Supports time-bounded text instructions such as seasonal shipping notes, temporary quality holds, or campaign-specific customer instructions.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'End date after which this text record is no longer considered valid or applicable. Enables automatic expiry of time-limited instructions and supports compliance with document retention policies.. Valid values are `^d{4}-d{2}-d{2}$`',
    `version_number` STRING COMMENT 'Sequential version counter for the text record, incremented each time the text content is modified. Enables version tracking and audit trail for changes to order instructions and notes over the order lifecycle.. Valid values are `^[0-9]+$`',
    `visibility_scope` STRING COMMENT 'Defines the audience and distribution scope of the text content. Internal texts are restricted to company personnel; customer-facing texts are printed on order confirmations and invoices; carrier-facing texts appear on shipping documents; supplier-facing texts are shared with vendors.. Valid values are `internal|customer_facing|carrier_facing|supplier_facing|public`',
    `created_by` STRING COMMENT 'User ID or username of the person who originally created this text record in the source system. Supports audit trail requirements and accountability for order communication records.',
    CONSTRAINT pk_text PRIMARY KEY(`text_id`)
) COMMENT 'Free-text and structured notes associated with sales orders, quotations, and delivery documents capturing customer instructions, internal processing notes, technical specifications, and communication records. Captures text ID, linked document reference, text type (customer instructions, internal note, shipping note, packing instruction, technical note, quality note), text language, text content, created by, creation timestamp, and visibility scope (internal, customer-facing, carrier-facing). Supports order communication and documentation requirements.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`blanket_order_line` (
    `blanket_order_line_id` BIGINT COMMENT 'Unique system-generated surrogate key for the blanket order line item',
    `blanket_order_id` BIGINT COMMENT 'Foreign key linking to the parent blanket order agreement',
    `spare_part_id` BIGINT COMMENT 'Foreign key linking to the specific spare part covered under this blanket order',
    `committed_quantity` DECIMAL(18,2) COMMENT 'Total quantity of this spare part committed under the blanket order over the contract period',
    `committed_value` DECIMAL(18,2) COMMENT 'Total monetary value committed under the blanket order agreement over the contract period, expressed in the agreement currency. Used for revenue forecasting and financial planning. [Moved from blanket_order: While blanket_order may retain a total_committed_value at header level, the line-level committed value is needed to track the value commitment per component.]. Valid values are `^d+(.d{1,2})?$`',
    `contracted_price` DECIMAL(18,2) COMMENT 'Negotiated unit price for this specific spare part under this blanket order agreement',
    `delivery_schedule_type` STRING COMMENT 'Type of delivery scheduling mechanism used for releases against this blanket order. Supports Just-in-Time (JIT), Kanban-driven, forecast-based, and periodic replenishment models. [Moved from blanket_order: Delivery scheduling mechanism can vary by component within the same blanket order (e.g., some components on Kanban, others on fixed schedule).]. Valid values are `jit|forecast|kanban|periodic|on_demand`',
    `lead_time_days` STRING COMMENT 'Number of days from release creation to expected delivery for this spare part under this agreement',
    `line_number` STRING COMMENT 'Sequential line number within the blanket order for this spare part',
    `line_status` STRING COMMENT 'Current status of this blanket order line (Active, Blocked, Completed, Cancelled)',
    `material_description` STRING COMMENT 'Short description of the material or product covered by the blanket order, as maintained in the SAP material master. Supports reporting and customer-facing documents. [Moved from blanket_order: Material description belongs at the line level, not the header level, to support multiple spare parts per blanket order.]',
    `material_number` STRING COMMENT 'SAP material number identifying the primary product or SKU covered under this blanket order. For multi-material agreements, this represents the primary material; line-level details are captured in release schedules. [Moved from blanket_order: The material_number in blanket_order appears to represent a single primary product, but blanket orders typically cover multiple line items. This attribute should move to the line level to support multi-line blanket orders.]. Valid values are `^[A-Z0-9-]{1,40}$`',
    `minimum_release_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity that must be released in each call-off against this line',
    `net_price` DECIMAL(18,2) COMMENT 'Negotiated net unit price per base unit of measure for the material under this blanket order, after all discounts and surcharges. This is the price applied to each release. [Moved from blanket_order: Net price is negotiated per spare part, not as a single price for the entire blanket order.]. Valid values are `^d+(.d{1,4})?$`',
    `next_release_date` DATE COMMENT 'Date on which the next delivery release is scheduled to be issued against this blanket order. Used for production planning and logistics coordination. [Moved from blanket_order: Next release date is tracked per component line, as different components have independent release schedules.]. Valid values are `^d{4}-d{2}-d{2}$`',
    `open_quantity` DECIMAL(18,2) COMMENT 'Remaining open quantity on this line, calculated as committed minus released',
    `plant_code` STRING COMMENT 'SAP plant code for the facility responsible for fulfilling releases against this line',
    `price_unit` DECIMAL(18,2) COMMENT 'The quantity basis for the contracted price (e.g., price per 1 EA, per 100 PC)',
    `released_quantity` DECIMAL(18,2) COMMENT 'Cumulative quantity released against this line to date',
    `released_value` DECIMAL(18,2) COMMENT 'Cumulative monetary value of all releases made against the blanket order to date. Used for revenue recognition tracking and contract consumption monitoring. [Moved from blanket_order: Released value must be tracked per component line to monitor consumption and remaining value by component.]. Valid values are `^d+(.d{1,2})?$`',
    `storage_location` STRING COMMENT 'Storage location within the plant where this spare part should be delivered',
    `unit_of_measure` STRING COMMENT 'Base unit of measure for quantities on this line (EA, PC, KG, etc.)',
    `validity_end_date` DATE COMMENT 'Date on which this line expires and no further releases are allowed',
    `validity_start_date` DATE COMMENT 'Date from which this line becomes effective for releases',
    CONSTRAINT pk_blanket_order_line PRIMARY KEY(`blanket_order_line_id`)
) COMMENT 'This association product represents the line-level contract between a blanket order agreement and a specific spare part. It captures the negotiated pricing, committed quantities, delivery terms, and release tracking for each spare part covered under a blanket order. Each record links one blanket order to one spare part with attributes that exist only in the context of this contractual relationship.. Existence Justification: In industrial manufacturing procurement, blanket orders are framework agreements that cover multiple spare parts with negotiated pricing and delivery terms. A single blanket order can include multiple spare part line items, each with its own contracted price, committed quantity, and lead time. Conversely, the same spare part can be covered under multiple blanket orders from different suppliers or for different customer facilities, each with different commercial terms. Procurement teams actively manage these line-level agreements and release against them based on maintenance schedules and consumption patterns.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`service_coverage` (
    `service_coverage_id` BIGINT COMMENT 'Unique surrogate identifier for this order-service coverage relationship record',
    `contract_id` BIGINT COMMENT 'Foreign key linking to the service contract providing coverage for equipment from this sales order',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to the sales order whose delivered equipment is covered by this service contract',
    `added_to_contract_date` DATE COMMENT 'Date on which equipment from this sales order was formally added to this service contract. Used for tracking contract amendments and coverage history.',
    `annual_coverage_value` DECIMAL(18,2) COMMENT 'Annualized monetary value allocated to covering equipment from this sales order within the broader service contract. Used for revenue allocation and profitability analysis per order.',
    `coverage_end_date` DATE COMMENT 'Date on which service coverage ends for equipment from this specific sales order under this contract. May differ from contract end date if equipment is removed from coverage.',
    `coverage_level` STRING COMMENT 'Defines the extent of service coverage for this orders equipment under this contract. Full coverage includes all services, partial may exclude certain components, preventive-only covers scheduled maintenance, emergency-only covers breakdown response.',
    `coverage_start_date` DATE COMMENT 'Date on which service coverage begins for equipment from this specific sales order under this contract. May differ from contract start date if order was delivered mid-contract.',
    `coverage_status` STRING COMMENT 'Current status of service coverage for this order-contract relationship. Active means coverage is in effect, suspended indicates temporary hold, expired means coverage period ended, cancelled indicates early termination.',
    `equipment_serial_numbers` STRING COMMENT 'Comma-separated list or JSON array of specific equipment serial numbers from this sales order that are covered under this service contract. Links order line items to contract coverage.',
    `removed_from_contract_date` DATE COMMENT 'Date on which equipment from this sales order was removed from this service contract, if applicable. Null if coverage is still active or expired naturally.',
    `response_time_sla_hours` DECIMAL(18,2) COMMENT 'Maximum response time in hours committed for service requests related to equipment from this sales order under this contract. May differ from contract-level SLA based on equipment criticality or customer negotiation.',
    CONSTRAINT pk_service_coverage PRIMARY KEY(`service_coverage_id`)
) COMMENT 'This association product represents the contractual service coverage relationship between sales orders and service contracts in industrial manufacturing. It captures which service contracts provide after-sales support for equipment delivered through specific sales orders. Each record links one sales order to one service contract with attributes that define the coverage terms, duration, and SLA commitments specific to that order-contract pairing.. Existence Justification: In industrial manufacturing, sales orders deliver equipment (production lines, automation systems, electrification components) that can be covered by multiple service contracts over their lifecycle - initial warranty, extended maintenance, emergency support, and remote monitoring contracts can all apply to the same delivered equipment. Conversely, enterprise service contracts routinely cover equipment from multiple sales orders, especially for customers with multi-site installations or phased project deliveries where a single master service agreement covers assets purchased across different orders and time periods.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ADD CONSTRAINT `fk_order_line_item_fulfillment_mode_id` FOREIGN KEY (`fulfillment_mode_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_mode`(`fulfillment_mode_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ADD CONSTRAINT `fk_order_order_quotation_blanket_order_id` FOREIGN KEY (`blanket_order_id`) REFERENCES `manufacturing_ecm`.`order`.`blanket_order`(`blanket_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ADD CONSTRAINT `fk_order_order_quotation_fulfillment_mode_id` FOREIGN KEY (`fulfillment_mode_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_mode`(`fulfillment_mode_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ADD CONSTRAINT `fk_order_order_quotation_rfq_request_id` FOREIGN KEY (`rfq_request_id`) REFERENCES `manufacturing_ecm`.`order`.`rfq_request`(`rfq_request_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ADD CONSTRAINT `fk_order_quotation_line_item_fulfillment_mode_id` FOREIGN KEY (`fulfillment_mode_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_mode`(`fulfillment_mode_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ADD CONSTRAINT `fk_order_quotation_line_item_order_configuration_id` FOREIGN KEY (`order_configuration_id`) REFERENCES `manufacturing_ecm`.`order`.`order_configuration`(`order_configuration_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ADD CONSTRAINT `fk_order_quotation_line_item_order_quotation_id` FOREIGN KEY (`order_quotation_id`) REFERENCES `manufacturing_ecm`.`order`.`order_quotation`(`order_quotation_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ADD CONSTRAINT `fk_order_rfq_request_fulfillment_mode_id` FOREIGN KEY (`fulfillment_mode_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_mode`(`fulfillment_mode_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ADD CONSTRAINT `fk_order_rfq_request_priority_id` FOREIGN KEY (`priority_id`) REFERENCES `manufacturing_ecm`.`order`.`priority`(`priority_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ADD CONSTRAINT `fk_order_schedule_line_fulfillment_mode_id` FOREIGN KEY (`fulfillment_mode_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_mode`(`fulfillment_mode_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ADD CONSTRAINT `fk_order_schedule_line_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`order`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ADD CONSTRAINT `fk_order_status_history_fulfillment_mode_id` FOREIGN KEY (`fulfillment_mode_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_mode`(`fulfillment_mode_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ADD CONSTRAINT `fk_order_status_history_reversal_reference_status_history_id` FOREIGN KEY (`reversal_reference_status_history_id`) REFERENCES `manufacturing_ecm`.`order`.`status_history`(`status_history_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ADD CONSTRAINT `fk_order_order_confirmation_blanket_order_id` FOREIGN KEY (`blanket_order_id`) REFERENCES `manufacturing_ecm`.`order`.`blanket_order`(`blanket_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ADD CONSTRAINT `fk_order_order_confirmation_customer_po_id` FOREIGN KEY (`customer_po_id`) REFERENCES `manufacturing_ecm`.`order`.`customer_po`(`customer_po_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ADD CONSTRAINT `fk_order_order_confirmation_fulfillment_mode_id` FOREIGN KEY (`fulfillment_mode_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_mode`(`fulfillment_mode_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ADD CONSTRAINT `fk_order_order_confirmation_order_quotation_id` FOREIGN KEY (`order_quotation_id`) REFERENCES `manufacturing_ecm`.`order`.`order_quotation`(`order_quotation_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ADD CONSTRAINT `fk_order_atp_commitment_fulfillment_mode_id` FOREIGN KEY (`fulfillment_mode_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_mode`(`fulfillment_mode_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ADD CONSTRAINT `fk_order_atp_commitment_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`order`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ADD CONSTRAINT `fk_order_atp_commitment_schedule_line_id` FOREIGN KEY (`schedule_line_id`) REFERENCES `manufacturing_ecm`.`order`.`schedule_line`(`schedule_line_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ADD CONSTRAINT `fk_order_order_configuration_fulfillment_mode_id` FOREIGN KEY (`fulfillment_mode_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_mode`(`fulfillment_mode_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ADD CONSTRAINT `fk_order_order_configuration_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`order`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ADD CONSTRAINT `fk_order_pricing_condition_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`order`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ADD CONSTRAINT `fk_order_pricing_condition_order_quotation_id` FOREIGN KEY (`order_quotation_id`) REFERENCES `manufacturing_ecm`.`order`.`order_quotation`(`order_quotation_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ADD CONSTRAINT `fk_order_order_block_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`order`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ADD CONSTRAINT `fk_order_returns_order_fulfillment_mode_id` FOREIGN KEY (`fulfillment_mode_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_mode`(`fulfillment_mode_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ADD CONSTRAINT `fk_order_returns_order_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`order`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ADD CONSTRAINT `fk_order_amendment_fulfillment_mode_id` FOREIGN KEY (`fulfillment_mode_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_mode`(`fulfillment_mode_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ADD CONSTRAINT `fk_order_amendment_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`order`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ADD CONSTRAINT `fk_order_customer_po_blanket_order_id` FOREIGN KEY (`blanket_order_id`) REFERENCES `manufacturing_ecm`.`order`.`blanket_order`(`blanket_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ADD CONSTRAINT `fk_order_customer_po_fulfillment_mode_id` FOREIGN KEY (`fulfillment_mode_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_mode`(`fulfillment_mode_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ADD CONSTRAINT `fk_order_customer_po_order_quotation_id` FOREIGN KEY (`order_quotation_id`) REFERENCES `manufacturing_ecm`.`order`.`order_quotation`(`order_quotation_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ADD CONSTRAINT `fk_order_blanket_order_fulfillment_mode_id` FOREIGN KEY (`fulfillment_mode_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_mode`(`fulfillment_mode_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_fulfillment_mode_id` FOREIGN KEY (`fulfillment_mode_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_mode`(`fulfillment_mode_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`order`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_priority_id` FOREIGN KEY (`priority_id`) REFERENCES `manufacturing_ecm`.`order`.`priority`(`priority_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`order`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ADD CONSTRAINT `fk_order_channel_fulfillment_mode_id` FOREIGN KEY (`fulfillment_mode_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_mode`(`fulfillment_mode_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ADD CONSTRAINT `fk_order_export_control_check_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`order`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`text` ADD CONSTRAINT `fk_order_text_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`order`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`text` ADD CONSTRAINT `fk_order_text_order_quotation_id` FOREIGN KEY (`order_quotation_id`) REFERENCES `manufacturing_ecm`.`order`.`order_quotation`(`order_quotation_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`text` ADD CONSTRAINT `fk_order_text_previous_version_text_id` FOREIGN KEY (`previous_version_text_id`) REFERENCES `manufacturing_ecm`.`order`.`text`(`text_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ADD CONSTRAINT `fk_order_blanket_order_line_blanket_order_id` FOREIGN KEY (`blanket_order_id`) REFERENCES `manufacturing_ecm`.`order`.`blanket_order`(`blanket_order_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`order` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `manufacturing_ecm`.`order` SET TAGS ('dbx_domain' = 'order');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` SET TAGS ('dbx_original_name' = 'order_line_item');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item ID');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `compliance_reach_substance_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Reach Substance Declaration Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `fulfillment_mode_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `product_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Certification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `atp_ctp_confirmed` SET TAGS ('dbx_business_glossary_term' = 'Available to Promise / Capable to Promise (ATP/CTP) Confirmation Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `atp_ctp_confirmed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `batch_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `billing_block` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Code');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `billing_block` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `confirmed_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `confirmed_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]{1,14}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `delivered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Delivered Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `delivered_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]{1,14}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `delivery_block` SET TAGS ('dbx_business_glossary_term' = 'Delivery Block Code');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `delivery_block` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `discount_percent` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `discount_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,4})?|[0-9]{1,2}(.[0-9]{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `discount_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `gross_price` SET TAGS ('dbx_business_glossary_term' = 'Gross Price');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `gross_price` SET TAGS ('dbx_value_regex' = '^[0-9]{1,16}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `gross_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `higher_level_item` SET TAGS ('dbx_business_glossary_term' = 'Higher Level Item Number');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `higher_level_item` SET TAGS ('dbx_value_regex' = '^[0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `item_category` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Item Category');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `item_category` SET TAGS ('dbx_value_regex' = 'TAN|TAB|TAD|TAF|TAK|TAP|TAQ|TAX|TANN|TATX|ZTAN|ZTAD|ZTAB');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `last_changed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Changed Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `last_changed_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-_]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `net_price` SET TAGS ('dbx_business_glossary_term' = 'Net Price');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `net_price` SET TAGS ('dbx_value_regex' = '^[0-9]{1,16}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `net_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `net_value` SET TAGS ('dbx_business_glossary_term' = 'Net Value');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `net_value` SET TAGS ('dbx_value_regex' = '^[0-9]{1,16}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `net_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Line Item Number');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `ordered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Ordered Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `ordered_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]{1,14}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `pricing_date` SET TAGS ('dbx_business_glossary_term' = 'Pricing Date');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `pricing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `product_hierarchy` SET TAGS ('dbx_business_glossary_term' = 'Product Hierarchy Code');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `product_hierarchy` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,18}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `profit_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason Code');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `sales_unit_price` SET TAGS ('dbx_business_glossary_term' = 'Sales Unit Price');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `sales_unit_price` SET TAGS ('dbx_value_regex' = '^[0-9]{1,14}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `sales_unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `schedule_line_count` SET TAGS ('dbx_business_glossary_term' = 'Schedule Line Count');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `schedule_line_count` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `shipping_point` SET TAGS ('dbx_business_glossary_term' = 'Shipping Point');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `shipping_point` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `sku_number` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) Number');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `sku_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-_]{1,50}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Line Item Status');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|in_process|partially_delivered|fully_delivered|invoiced|cancelled|blocked|completed');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `storage_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `tax_amount` SET TAGS ('dbx_value_regex' = '^[0-9]{1,16}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Sales Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|PC|KG|LB|M|M2|M3|L|SET|BOX|PAL|ROL|HR|DAY');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ALTER COLUMN `wbs_element` SET TAGS ('dbx_value_regex' = '^[A-Z0-9.-]{1,24}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` SET TAGS ('dbx_subdomain' = 'quotation_management');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `order_quotation_id` SET TAGS ('dbx_business_glossary_term' = 'Quotation ID');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `blanket_order_id` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `channel_partner_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Partner Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `customer_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `fulfillment_mode_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Prepared By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `pricing_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Pricing Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `rfq_request_id` SET TAGS ('dbx_business_glossary_term' = 'Rfq Request Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `sales_price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `accepted_rejected_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Quotation Accepted / Rejected Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `competitor_name` SET TAGS ('dbx_business_glossary_term' = 'Competitor Name');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `competitor_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `confirmed_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `confirmed_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `converted_order_number` SET TAGS ('dbx_business_glossary_term' = 'Converted Sales Order Number');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Quotation Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Number');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `customer_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Name');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `customer_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `delivery_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Delivery Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `delivery_lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Quotation Discount Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `gross_value` SET TAGS ('dbx_business_glossary_term' = 'Quotation Gross Value');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `gross_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Named Place / Location');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Quotation Issue Date');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `net_value` SET TAGS ('dbx_business_glossary_term' = 'Quotation Net Value');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `net_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Quotation Number');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^QT-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `opportunity_reference` SET TAGS ('dbx_business_glossary_term' = 'CRM Opportunity Reference');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `probability_percent` SET TAGS ('dbx_business_glossary_term' = 'Win Probability Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `probability_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `sales_office` SET TAGS ('dbx_business_glossary_term' = 'Sales Office');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `sales_representative` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `shipping_country_code` SET TAGS ('dbx_business_glossary_term' = 'Shipping Destination Country Code');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `shipping_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Quotation Status');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|accepted|rejected|expired|cancelled|converted');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Quotation Submission Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Quotation Tax Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Quotation Type');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'standard|framework|blanket|project|spot');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Quotation Validity End Date');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Quotation Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Quotation Version Number');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `win_loss_notes` SET TAGS ('dbx_business_glossary_term' = 'Win / Loss Notes');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `win_loss_reason` SET TAGS ('dbx_business_glossary_term' = 'Win / Loss Reason');
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ALTER COLUMN `win_loss_reason` SET TAGS ('dbx_value_regex' = 'price_competitive|price_too_high|lead_time|technical_fit|competitor_selected|customer_cancelled|budget_constraint|relationship|specification_mismatch|other');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` SET TAGS ('dbx_subdomain' = 'quotation_management');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `quotation_line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Quotation Line Item ID');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `fulfillment_mode_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `order_configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration ID');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `order_configuration_id` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `order_quotation_id` SET TAGS ('dbx_business_glossary_term' = 'Quotation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `product_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Certification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `atp_ctp_method` SET TAGS ('dbx_business_glossary_term' = 'Available-to-Promise / Capable-to-Promise (ATP/CTP) Method');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `atp_ctp_method` SET TAGS ('dbx_value_regex' = 'ATP|CTP|MTO_LEAD_TIME|MANUAL');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `configuration_description` SET TAGS ('dbx_business_glossary_term' = 'Configuration Description');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `confirmed_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `confirmed_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `customs_tariff_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Tariff Number (HS Code)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `customs_tariff_number` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `delivery_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Delivery Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `delivery_lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,4})?|[0-9]{1,2}(.[0-9]{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `engineering_change_number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Number');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `engineering_change_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `item_category` SET TAGS ('dbx_business_glossary_term' = 'Item Category');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `item_category` SET TAGS ('dbx_value_regex' = 'TAN|TAK|TAP|TAQ|TANN|ZTAN|ZTAP');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `line_net_value` SET TAGS ('dbx_business_glossary_term' = 'Line Net Value');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `line_net_value` SET TAGS ('dbx_value_regex' = '^[0-9]{1,14}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `line_net_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Line Item Number');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `line_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `list_price` SET TAGS ('dbx_business_glossary_term' = 'List Price');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `list_price` SET TAGS ('dbx_value_regex' = '^[0-9]{1,14}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `list_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `pricing_date` SET TAGS ('dbx_business_glossary_term' = 'Pricing Date');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `pricing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `product_group` SET TAGS ('dbx_business_glossary_term' = 'Product Group');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `quoted_net_price` SET TAGS ('dbx_business_glossary_term' = 'Quoted Net Price');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `quoted_net_price` SET TAGS ('dbx_value_regex' = '^[0-9]{1,14}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `quoted_net_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `quoted_quantity` SET TAGS ('dbx_business_glossary_term' = 'Quoted Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `quoted_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]{1,14}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `reason_for_rejection` SET TAGS ('dbx_business_glossary_term' = 'Reason for Rejection');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Compliant');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `sales_unit` SET TAGS ('dbx_business_glossary_term' = 'Sales Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `sales_unit` SET TAGS ('dbx_value_regex' = 'EA|PC|KG|M|M2|M3|L|SET|BOX|PAL');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `sku` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,50}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Line Item Status');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|in_review|approved|rejected|expired|converted_to_order|cancelled');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `storage_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `sub_line_number` SET TAGS ('dbx_business_glossary_term' = 'Sub-Line Item Number');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `sub_line_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `surcharge_percentage` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `surcharge_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,4})?|[0-9]{1,2}(.[0-9]{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `surcharge_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `tax_amount` SET TAGS ('dbx_value_regex' = '^[0-9]{1,14}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `tax_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `technical_spec_summary` SET TAGS ('dbx_business_glossary_term' = 'Technical Specification Summary');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|PC|KG|M|M2|M3|L|SET|BOX|PAL|HR|DAY');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Validity End Date');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` SET TAGS ('dbx_subdomain' = 'quotation_management');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `rfq_request_id` SET TAGS ('dbx_business_glossary_term' = 'Request for Quotation (RFQ) Request ID');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `fulfillment_mode_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `priority_id` SET TAGS ('dbx_business_glossary_term' = 'Order Priority Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `procurement_sourcing_event_id` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `sales_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `application_type` SET TAGS ('dbx_business_glossary_term' = 'Application Type');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `application_type` SET TAGS ('dbx_value_regex' = 'factory_automation|building_electrification|transportation_infrastructure|urban_environment|smart_infrastructure|energy_management|other');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `assigned_sales_engineer` SET TAGS ('dbx_business_glossary_term' = 'Assigned Sales Engineer');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `assigned_sales_office` SET TAGS ('dbx_business_glossary_term' = 'Assigned Sales Office');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `awarded_date` SET TAGS ('dbx_business_glossary_term' = 'RFQ Awarded Date');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `awarded_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `budget_currency` SET TAGS ('dbx_business_glossary_term' = 'Budget Currency');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `budget_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `budget_indication_amount` SET TAGS ('dbx_business_glossary_term' = 'Budget Indication Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `budget_indication_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `competitor_names` SET TAGS ('dbx_business_glossary_term' = 'Competitor Names');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `competitor_names` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `compliance_requirements` SET TAGS ('dbx_business_glossary_term' = 'Compliance Requirements');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `confidentiality_agreement_required` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Agreement Required Indicator');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `confidentiality_agreement_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `country_of_delivery` SET TAGS ('dbx_business_glossary_term' = 'Country of Delivery');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `country_of_delivery` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `customer_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Reference Number');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `customer_reference_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `decline_reason` SET TAGS ('dbx_business_glossary_term' = 'Decline Reason');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `decline_reason` SET TAGS ('dbx_value_regex' = 'price_not_competitive|technical_non_compliance|capacity_unavailable|strategic_decision|customer_cancelled|lost_to_competitor|no_bid|other');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = 'direct|distributor|oem|system_integrator|online|agent');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `estimated_contract_value` SET TAGS ('dbx_business_glossary_term' = 'Estimated Contract Value');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `estimated_contract_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `evaluation_criteria` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Criteria');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'Incoterms');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `incoterms` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `nda_signed_date` SET TAGS ('dbx_business_glossary_term' = 'Non-Disclosure Agreement (NDA) Signed Date');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `nda_signed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `payment_terms_requested` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Requested');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `project_name` SET TAGS ('dbx_business_glossary_term' = 'Project Name');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `quantity_required` SET TAGS ('dbx_business_glossary_term' = 'Quantity Required');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|SET|KIT|M|KG|TON|M2|M3|HR|LOT');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `received_timestamp` SET TAGS ('dbx_business_glossary_term' = 'RFQ Received Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `received_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `related_opportunity_number` SET TAGS ('dbx_business_glossary_term' = 'Related Opportunity Number');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `required_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Required Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `required_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `responded_timestamp` SET TAGS ('dbx_business_glossary_term' = 'RFQ Responded Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `responded_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `response_due_date` SET TAGS ('dbx_business_glossary_term' = 'RFQ Response Due Date');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `response_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `rfp_indicator` SET TAGS ('dbx_business_glossary_term' = 'Request for Proposal (RFP) Indicator');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `rfp_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `rfq_number` SET TAGS ('dbx_business_glossary_term' = 'Request for Quotation (RFQ) Number');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `rfq_number` SET TAGS ('dbx_value_regex' = '^RFQ-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `source_channel` SET TAGS ('dbx_business_glossary_term' = 'RFQ Source Channel');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `source_channel` SET TAGS ('dbx_value_regex' = 'email|portal|edi|mail|in_person|phone|tender_platform|other');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'RFQ Status');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'received|under_review|responded|awarded|declined|cancelled|on_hold');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'RFQ Submission Date');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `submission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `technical_requirements_summary` SET TAGS ('dbx_business_glossary_term' = 'Technical Requirements Summary');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `warranty_requirement` SET TAGS ('dbx_business_glossary_term' = 'Warranty Requirement');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `win_probability_percent` SET TAGS ('dbx_business_glossary_term' = 'Win Probability Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `win_probability_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` SET TAGS ('dbx_original_name' = 'order_schedule_line');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `schedule_line_id` SET TAGS ('dbx_business_glossary_term' = 'Order Schedule Line ID');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `fulfillment_mode_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `atp_ctp_check_result` SET TAGS ('dbx_business_glossary_term' = 'Available to Promise / Capable to Promise (ATP/CTP) Check Result');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `atp_ctp_check_result` SET TAGS ('dbx_value_regex' = 'ATP_CONFIRMED|CTP_CONFIRMED|PARTIAL|NOT_CONFIRMED|MANUAL_OVERRIDE|NOT_CHECKED');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Schedule Line Category');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'CP|CN|BN|BP|CS|CT|CV|CX');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `confirmed_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `confirmed_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Delivery Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `customs_tariff_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Tariff Number (HS Code)');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `delivered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Delivered Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `delivered_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `delivery_block_code` SET TAGS ('dbx_business_glossary_term' = 'Delivery Block Code');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `delivery_block_code` SET TAGS ('dbx_value_regex' = '01|02|03|04|05|06|07|08|09|10|11|12|');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `delivery_block_reason` SET TAGS ('dbx_business_glossary_term' = 'Delivery Block Reason');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `delivery_relevance_indicator` SET TAGS ('dbx_business_glossary_term' = 'Delivery Relevance Indicator');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `delivery_relevance_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `export_control_status` SET TAGS ('dbx_business_glossary_term' = 'Export Control Status');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `export_control_status` SET TAGS ('dbx_value_regex' = 'APPROVED|PENDING_REVIEW|BLOCKED|NOT_REQUIRED|EXEMPTED');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `goods_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue Date');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `goods_issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `goods_issue_status` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue Status');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `goods_issue_status` SET TAGS ('dbx_value_regex' = 'NOT_STARTED|PARTIAL|COMPLETE');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `hazardous_goods_indicator` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Goods Indicator');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `hazardous_goods_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `loading_date` SET TAGS ('dbx_business_glossary_term' = 'Loading Date');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `loading_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `material_availability_date` SET TAGS ('dbx_business_glossary_term' = 'Material Availability Date');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `material_availability_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number (SKU)');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `mrp_relevance_indicator` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Relevance Indicator');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `mrp_relevance_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `net_value` SET TAGS ('dbx_business_glossary_term' = 'Schedule Line Net Value');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `net_value` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `net_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Schedule Line Number');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `ordered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Ordered Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `ordered_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `over_delivery_tolerance_pct` SET TAGS ('dbx_business_glossary_term' = 'Over-Delivery Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `over_delivery_tolerance_pct` SET TAGS ('dbx_value_regex' = '^d{1,3}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `partial_delivery_allowed` SET TAGS ('dbx_business_glossary_term' = 'Partial Delivery Allowed Indicator');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `partial_delivery_allowed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `quantity_unit` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `quantity_unit` SET TAGS ('dbx_value_regex' = 'EA|PC|KG|LB|M|M2|M3|L|GAL|SET|BOX|PAL|ROL|HR|MIN');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `route_code` SET TAGS ('dbx_business_glossary_term' = 'Route Code');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `shipping_point` SET TAGS ('dbx_business_glossary_term' = 'Shipping Point');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `transportation_planning_date` SET TAGS ('dbx_business_glossary_term' = 'Transportation Planning Date');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `transportation_planning_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `under_delivery_tolerance_pct` SET TAGS ('dbx_business_glossary_term' = 'Under-Delivery Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `under_delivery_tolerance_pct` SET TAGS ('dbx_value_regex' = '^d{1,3}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` SET TAGS ('dbx_original_name' = 'order_status_history');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `status_history_id` SET TAGS ('dbx_business_glossary_term' = 'Order Status History ID');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `fulfillment_mode_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `reversal_reference_status_history_id` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reference History ID');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `approval_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Approval Required Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `approval_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `approved_by_user` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `atp_ctp_check_result` SET TAGS ('dbx_business_glossary_term' = 'Available to Promise / Capable to Promise (ATP/CTP) Check Result');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `atp_ctp_check_result` SET TAGS ('dbx_value_regex' = 'ATP_CONFIRMED|CTP_CONFIRMED|PARTIAL|FAILED|NOT_PERFORMED|BYPASSED');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `block_type` SET TAGS ('dbx_business_glossary_term' = 'Order Block Type');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `block_type` SET TAGS ('dbx_value_regex' = 'DELIVERY_BLOCK|BILLING_BLOCK|CREDIT_BLOCK|EXPORT_CONTROL_BLOCK|QUALITY_BLOCK|NONE');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `blocking_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Order Blocking Reason Code');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `blocking_reason_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `change_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Status Change Reason Code');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `change_reason_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `change_reason_description` SET TAGS ('dbx_business_glossary_term' = 'Status Change Reason Description');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `changed_by_user` SET TAGS ('dbx_business_glossary_term' = 'Changed By User ID');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `changed_by_user_name` SET TAGS ('dbx_business_glossary_term' = 'Changed By User Full Name');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `changed_by_user_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `changed_by_user_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Status Change Comments');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `credit_check_result` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Result');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `credit_check_result` SET TAGS ('dbx_value_regex' = 'PASSED|FAILED|BYPASSED|PENDING|NOT_APPLICABLE');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `duration_from_previous_minutes` SET TAGS ('dbx_business_glossary_term' = 'Duration From Previous Status (Minutes)');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `duration_from_previous_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `export_control_check_result` SET TAGS ('dbx_business_glossary_term' = 'Export Control Check Result');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `export_control_check_result` SET TAGS ('dbx_value_regex' = 'CLEARED|BLOCKED|PENDING|NOT_APPLICABLE|ESCALATED');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `is_reversal` SET TAGS ('dbx_business_glossary_term' = 'Status Reversal Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `is_reversal` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `new_status` SET TAGS ('dbx_business_glossary_term' = 'New Order Status');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `new_status` SET TAGS ('dbx_value_regex' = 'DRAFT|PENDING_APPROVAL|APPROVED|BLOCKED|RELEASED|IN_PROCESS|PARTIALLY_DELIVERED|FULLY_DELIVERED|INVOICED|PARTIALLY_INVOICED|COMPLETED|CANCELLED|ON_HOLD|REJECTED|CREDIT_CHECK|ATP_CHECK|PENDING_CONFIRMATION');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `notification_sent_flag` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Sent Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `notification_sent_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `order_type` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Type');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `order_type` SET TAGS ('dbx_value_regex' = 'STANDARD|RUSH|BLANKET|RETURN|CREDIT_MEMO|DEBIT_MEMO|CONSIGNMENT|INTERCOMPANY|THIRD_PARTY|SAMPLE');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `previous_status` SET TAGS ('dbx_business_glossary_term' = 'Previous Order Status');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `previous_status` SET TAGS ('dbx_value_regex' = 'DRAFT|PENDING_APPROVAL|APPROVED|BLOCKED|RELEASED|IN_PROCESS|PARTIALLY_DELIVERED|FULLY_DELIVERED|INVOICED|PARTIALLY_INVOICED|COMPLETED|CANCELLED|ON_HOLD|REJECTED|CREDIT_CHECK|ATP_CHECK|PENDING_CONFIRMATION');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `release_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Order Release Reason Code');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `release_reason_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `sales_organization` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Status Transition Sequence Number');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `sequence_number` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `sla_target_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Target Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `sla_target_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System of Origin');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_SD|SAP_MM|MES|SALESFORCE_CRM|MANUAL|INTEGRATION|ARIBA|WMS|TMS');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `source_system_transaction_reference` SET TAGS ('dbx_business_glossary_term' = 'Source System Transaction ID');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `status_change_date` SET TAGS ('dbx_business_glossary_term' = 'Status Change Date');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `status_change_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `status_change_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Status Change Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `status_change_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `transition_type` SET TAGS ('dbx_business_glossary_term' = 'Status Transition Type');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `transition_type` SET TAGS ('dbx_value_regex' = 'AUTOMATIC|MANUAL|BATCH|INTEGRATION|WORKFLOW_APPROVAL|SYSTEM_TRIGGERED');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `workflow_instance_reference` SET TAGS ('dbx_business_glossary_term' = 'Workflow Instance ID');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` SET TAGS ('dbx_original_name' = 'order_confirmation');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `order_confirmation_id` SET TAGS ('dbx_business_glossary_term' = 'Order Confirmation ID');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `blanket_order_id` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Confirmed By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `customer_po_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Po Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `fulfillment_mode_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `order_quotation_id` SET TAGS ('dbx_business_glossary_term' = 'Quotation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `atp_ctp_check_status` SET TAGS ('dbx_business_glossary_term' = 'Available to Promise / Capable to Promise (ATP/CTP) Check Status');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `atp_ctp_check_status` SET TAGS ('dbx_value_regex' = 'atp_confirmed|ctp_confirmed|partial|not_checked|failed');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `confirmed_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `confirmed_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `confirmed_gross_value` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Gross Order Value');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `confirmed_gross_value` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `confirmed_gross_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `confirmed_net_value` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Net Order Value');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `confirmed_net_value` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `confirmed_net_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Order Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `confirmed_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Tax Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `confirmed_tax_amount` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `confirmed_tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `country_of_destination` SET TAGS ('dbx_business_glossary_term' = 'Country of Destination');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `country_of_destination` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `credit_status` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Status');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `credit_status` SET TAGS ('dbx_value_regex' = 'approved|blocked|released|under_review');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Document Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `customer_acknowledgment_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Acknowledgment Date');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `customer_acknowledgment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `customer_acknowledgment_status` SET TAGS ('dbx_business_glossary_term' = 'Customer Acknowledgment Status');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `customer_acknowledgment_status` SET TAGS ('dbx_value_regex' = 'pending|acknowledged|rejected|no_response');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `date` SET TAGS ('dbx_business_glossary_term' = 'Order Confirmation Date');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `delivery_date_deviation_days` SET TAGS ('dbx_business_glossary_term' = 'Delivery Date Deviation (Days)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `delivery_date_deviation_days` SET TAGS ('dbx_value_regex' = '^-?d+$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `deviation_description` SET TAGS ('dbx_business_glossary_term' = 'Order Deviation Description');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `deviation_flag` SET TAGS ('dbx_business_glossary_term' = 'Order Deviation Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `deviation_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_value_regex' = '^d+(.d{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `export_control_status` SET TAGS ('dbx_business_glossary_term' = 'Export Control Status');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `export_control_status` SET TAGS ('dbx_value_regex' = 'not_required|approved|pending_review|blocked|rejected');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = '^(EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF)$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Named Place / Location');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `method` SET TAGS ('dbx_business_glossary_term' = 'Order Confirmation Method');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `method` SET TAGS ('dbx_value_regex' = 'email|edi|portal|fax|print|api');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Order Confirmation Number');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `ordered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Original Ordered Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `ordered_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Delivering Plant Code');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Requested Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `sales_organization` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `shipping_point` SET TAGS ('dbx_business_glossary_term' = 'Shipping Point');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `shipping_point` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Order Confirmation Status');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|issued|acknowledged|superseded|cancelled');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `superseded_by_confirmation_number` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Confirmation Number');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `superseded_by_confirmation_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `timestamp` SET TAGS ('dbx_business_glossary_term' = 'Order Confirmation Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Confirmation Version Number');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[1-9]d*$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `atp_commitment_id` SET TAGS ('dbx_business_glossary_term' = 'Available-to-Promise (ATP) Commitment ID');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `fulfillment_mode_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `schedule_line_id` SET TAGS ('dbx_business_glossary_term' = 'Order Schedule Line Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `atp_quantity` SET TAGS ('dbx_business_glossary_term' = 'Available-to-Promise (ATP) Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `atp_quantity` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `backorder_quantity` SET TAGS ('dbx_business_glossary_term' = 'Backorder Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `backorder_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `check_timestamp` SET TAGS ('dbx_business_glossary_term' = 'ATP/CTP Check Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `check_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `checking_group` SET TAGS ('dbx_business_glossary_term' = 'ATP Checking Group');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `checking_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `checking_rule` SET TAGS ('dbx_business_glossary_term' = 'ATP Checking Rule');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `checking_rule` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `commitment_number` SET TAGS ('dbx_business_glossary_term' = 'ATP/CTP Commitment Number');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `commitment_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,30}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `commitment_type` SET TAGS ('dbx_business_glossary_term' = 'Commitment Type (ATP/CTP)');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `commitment_type` SET TAGS ('dbx_value_regex' = 'ATP|CTP');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `confirmation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Commitment Confirmation Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `confirmation_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `confirmed_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `confirmed_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `cumulative_atp_quantity` SET TAGS ('dbx_business_glossary_term' = 'Cumulative Available-to-Promise (ATP) Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `cumulative_atp_quantity` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `delivery_priority` SET TAGS ('dbx_business_glossary_term' = 'Delivery Priority');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `delivery_priority` SET TAGS ('dbx_value_regex' = '^[0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `earliest_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Earliest Possible Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `earliest_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `expiry_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Commitment Expiry Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `expiry_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `mrp_area` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Area');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `mrp_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `partial_delivery_allowed` SET TAGS ('dbx_business_glossary_term' = 'Partial Delivery Allowed Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `partial_delivery_allowed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `receipt_element_number` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Receipt Element Number');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `receipt_element_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `receipt_element_type` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Receipt Element Type');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `receipt_element_type` SET TAGS ('dbx_value_regex' = 'planned_order|purchase_order|production_order|stock_transfer|scheduling_agreement|none');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `replenishment_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `replenishment_lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `requested_quantity` SET TAGS ('dbx_business_glossary_term' = 'Requested Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `requested_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `sales_organization` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|LEGACY|MANUAL');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Commitment Status');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|confirmed|partially_confirmed|rejected|cancelled|expired|superseded');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `stock_category` SET TAGS ('dbx_business_glossary_term' = 'Stock Category');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `stock_category` SET TAGS ('dbx_value_regex' = 'unrestricted|quality_inspection|blocked|restricted|consignment|in_transit');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `storage_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` SET TAGS ('dbx_original_name' = 'order_configuration');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `order_configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Order Configuration ID');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `fulfillment_mode_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `product_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Variant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `base_material_number` SET TAGS ('dbx_business_glossary_term' = 'Base Material Number');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `base_material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `bom_explosion_reference` SET TAGS ('dbx_business_glossary_term' = 'Bill of Materials (BOM) Explosion Reference');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `bom_explosion_reference` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `bom_explosion_status` SET TAGS ('dbx_business_glossary_term' = 'Bill of Materials (BOM) Explosion Status');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `bom_explosion_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|failed|not_required');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `certification_variant` SET TAGS ('dbx_business_glossary_term' = 'Certification Variant');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `certification_variant` SET TAGS ('dbx_value_regex' = 'CE|UL|CSA|ATEX|IECEx|CCC|EAC|none|multiple');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `characteristic_profile_code` SET TAGS ('dbx_business_glossary_term' = 'Characteristic Profile ID');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `characteristic_profile_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `color_finish` SET TAGS ('dbx_business_glossary_term' = 'Color and Finish');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `communication_protocol` SET TAGS ('dbx_business_glossary_term' = 'Communication Protocol');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `communication_protocol` SET TAGS ('dbx_value_regex' = 'PROFINET|PROFIBUS|EtherNet_IP|Modbus_TCP|Modbus_RTU|CANopen|DeviceNet|EtherCAT|OPC_UA|none|other');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `control_type` SET TAGS ('dbx_business_glossary_term' = 'Control Type');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `control_type` SET TAGS ('dbx_value_regex' = 'scalar_vf|vector_sensorless|vector_encoder|servo|direct_torque|soft_starter|direct_online|star_delta|other');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Configuration Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `ecn_reference` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Reference');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `ecn_reference` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `enclosure_type` SET TAGS ('dbx_business_glossary_term' = 'Enclosure Type');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `enclosure_type` SET TAGS ('dbx_value_regex' = 'IP20|IP44|IP54|IP65|IP66|IP67|NEMA1|NEMA4|NEMA4X|NEMA12|open|other');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_value_regex' = 'EAR99|ECCN_3A001|ECCN_3A002|ECCN_3B001|ECCN_4A001|ECCN_5A002|AL_N|AL_controlled|not_classified');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `frame_size` SET TAGS ('dbx_business_glossary_term' = 'Frame Size');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `frame_size` SET TAGS ('dbx_value_regex' = '^[A-Z]{1,5}[0-9]{0,3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `input_frequency` SET TAGS ('dbx_business_glossary_term' = 'Input Frequency');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `input_frequency` SET TAGS ('dbx_value_regex' = '50Hz|60Hz|50_60Hz');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `is_customer_approved` SET TAGS ('dbx_business_glossary_term' = 'Customer Approved Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `is_customer_approved` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `is_feasibility_confirmed` SET TAGS ('dbx_business_glossary_term' = 'Feasibility Confirmed Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `is_feasibility_confirmed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Configuration Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Configuration Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `motor_size` SET TAGS ('dbx_business_glossary_term' = 'Motor Size');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `motor_size` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]+)?s?(W|kW|HP)$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Configuration Number');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `output_current_rating` SET TAGS ('dbx_business_glossary_term' = 'Output Current Rating');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `output_current_rating` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]+)?s?A$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `ppap_required` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Required Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `ppap_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `price_uplift` SET TAGS ('dbx_business_glossary_term' = 'Configuration Price Uplift');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `price_uplift` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `price_uplift` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `product_category` SET TAGS ('dbx_business_glossary_term' = 'Product Category');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `product_category` SET TAGS ('dbx_value_regex' = 'automation_system|drive_system|switchgear|motor|control_panel|sensor|plc|hmi|power_supply|other');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `product_model` SET TAGS ('dbx_business_glossary_term' = 'Product Model');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Configured Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `quantity_unit` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `quantity_unit` SET TAGS ('dbx_value_regex' = 'EA|PC|SET|KIT|M|KG|L');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `reach_rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'REACH and RoHS Compliance Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `reach_rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `released_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Configuration Released Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `released_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `safety_integrity_level` SET TAGS ('dbx_business_glossary_term' = 'Safety Integrity Level (SIL)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `safety_integrity_level` SET TAGS ('dbx_value_regex' = 'none|SIL1|SIL2|SIL3|PLc|PLd|PLe');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|TEAMCENTER|OPCENTER|MANUAL');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Configuration Status');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|in_review|valid|released|superseded|cancelled|locked');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Configuration Validity End Date');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Configuration Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Configuration Version');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `version` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `voltage_rating` SET TAGS ('dbx_business_glossary_term' = 'Voltage Rating');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `voltage_rating` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]+)?s?(V|kV)$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `work_center` SET TAGS ('dbx_business_glossary_term' = 'Work Center');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `work_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` SET TAGS ('dbx_subdomain' = 'quotation_management');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `pricing_condition_id` SET TAGS ('dbx_business_glossary_term' = 'Pricing Condition ID');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `discount_structure_id` SET TAGS ('dbx_business_glossary_term' = 'Discount Structure Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `order_quotation_id` SET TAGS ('dbx_business_glossary_term' = 'Quotation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `special_pricing_request_id` SET TAGS ('dbx_business_glossary_term' = 'Special Pricing Request Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `tax_code_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `access_sequence_code` SET TAGS ('dbx_business_glossary_term' = 'Access Sequence Code');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `calculation_type` SET TAGS ('dbx_business_glossary_term' = 'Calculation Type');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `calculation_type` SET TAGS ('dbx_value_regex' = 'fixed_amount|percentage|quantity_based|weight_based|volume_based|formula|group_condition');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_base_value` SET TAGS ('dbx_business_glossary_term' = 'Condition Base Value');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_base_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_category` SET TAGS ('dbx_business_glossary_term' = 'Condition Category');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_category` SET TAGS ('dbx_value_regex' = 'price|discount|surcharge|freight|tax|rebate|bonus|other');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_exclusion_group` SET TAGS ('dbx_business_glossary_term' = 'Condition Exclusion Group');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_inactive_reason` SET TAGS ('dbx_business_glossary_term' = 'Condition Inactive Reason');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_inactive_reason` SET TAGS ('dbx_value_regex' = 'pricing_error|manual_deletion|superseded|expired|blocked_by_exclusion|other');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_origin` SET TAGS ('dbx_business_glossary_term' = 'Condition Origin');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_origin` SET TAGS ('dbx_value_regex' = 'automatic|manual|contract_based|promotion|intercompany|transfer_price');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_quantity` SET TAGS ('dbx_business_glossary_term' = 'Condition Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_rate` SET TAGS ('dbx_business_glossary_term' = 'Condition Rate');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_rate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_record_number` SET TAGS ('dbx_business_glossary_term' = 'Condition Record Number');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_status` SET TAGS ('dbx_business_glossary_term' = 'Condition Status');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_status` SET TAGS ('dbx_value_regex' = 'active|inactive|deleted|blocked|statistical');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_type_code` SET TAGS ('dbx_business_glossary_term' = 'Condition Type Code');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_type_name` SET TAGS ('dbx_business_glossary_term' = 'Condition Type Name');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_unit` SET TAGS ('dbx_business_glossary_term' = 'Condition Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_value` SET TAGS ('dbx_business_glossary_term' = 'Condition Value');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `condition_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `contract_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference Number');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `customer_price_group` SET TAGS ('dbx_business_glossary_term' = 'Customer Price Group');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Mandatory Condition Indicator');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `is_statistical` SET TAGS ('dbx_business_glossary_term' = 'Statistical Condition Indicator');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `is_statistical` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `manual_entry_allowed` SET TAGS ('dbx_business_glossary_term' = 'Manual Entry Allowed Indicator');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `manual_entry_allowed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `material_price_group` SET TAGS ('dbx_business_glossary_term' = 'Material Price Group');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `price_list_type` SET TAGS ('dbx_business_glossary_term' = 'Price List Type');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `pricing_date` SET TAGS ('dbx_business_glossary_term' = 'Pricing Date');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `pricing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `pricing_procedure_code` SET TAGS ('dbx_business_glossary_term' = 'Pricing Procedure Code');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `pricing_procedure_counter` SET TAGS ('dbx_business_glossary_term' = 'Pricing Procedure Counter');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `pricing_procedure_counter` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `pricing_procedure_step` SET TAGS ('dbx_business_glossary_term' = 'Pricing Procedure Step');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `pricing_procedure_step` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `rebate_agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Rebate Agreement Number');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `scale_basis_type` SET TAGS ('dbx_business_glossary_term' = 'Scale Basis Type');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `scale_basis_type` SET TAGS ('dbx_value_regex' = 'quantity|value|weight|volume|none');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `scale_quantity` SET TAGS ('dbx_business_glossary_term' = 'Scale Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `scale_value` SET TAGS ('dbx_business_glossary_term' = 'Scale Value');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `scale_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `tax_classification_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Classification Code');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `tax_jurisdiction_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Jurisdiction Code');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Validity End Date');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` SET TAGS ('dbx_original_name' = 'order_block');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `order_block_id` SET TAGS ('dbx_business_glossary_term' = 'Order Block ID');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `quality_notification_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Notification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `applied_by` SET TAGS ('dbx_business_glossary_term' = 'Block Applied By');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `applied_by_department` SET TAGS ('dbx_business_glossary_term' = 'Block Applied By Department');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `applied_by_name` SET TAGS ('dbx_business_glossary_term' = 'Block Applied By Name');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `applied_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Block Applied Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `capa_reference` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `credit_control_area` SET TAGS ('dbx_business_glossary_term' = 'Credit Control Area');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `credit_exposure_amount` SET TAGS ('dbx_business_glossary_term' = 'Credit Exposure Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `credit_exposure_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `credit_limit_amount` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `credit_limit_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `customer_notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `customer_notified` SET TAGS ('dbx_business_glossary_term' = 'Customer Notified Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `customer_notified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `escalated_to` SET TAGS ('dbx_business_glossary_term' = 'Block Escalated To');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `escalation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Block Escalation Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `expected_release_date` SET TAGS ('dbx_business_glossary_term' = 'Expected Block Release Date');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification Number (ECCN)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `export_license_number` SET TAGS ('dbx_business_glossary_term' = 'Export License Number');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `is_recurring_block` SET TAGS ('dbx_business_glossary_term' = 'Is Recurring Block');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `is_recurring_block` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `ncr_number` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Report (NCR) Number');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Block Number');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^BLK-[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `order_value_at_block` SET TAGS ('dbx_business_glossary_term' = 'Order Value at Block');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `order_value_at_block` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `reason_code` SET TAGS ('dbx_business_glossary_term' = 'Block Reason Code');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `reason_description` SET TAGS ('dbx_business_glossary_term' = 'Block Reason Description');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `release_authorization_level` SET TAGS ('dbx_business_glossary_term' = 'Release Authorization Level');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `release_authorization_level` SET TAGS ('dbx_value_regex' = 'level_1_clerk|level_2_supervisor|level_3_manager|level_4_director|level_5_executive|system_auto');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `release_notes` SET TAGS ('dbx_business_glossary_term' = 'Block Release Notes');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `release_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Block Release Reason Code');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `release_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Block Release Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `released_by` SET TAGS ('dbx_business_glossary_term' = 'Block Released By');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `released_by_name` SET TAGS ('dbx_business_glossary_term' = 'Block Released By Name');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `sla_resolution_hours` SET TAGS ('dbx_business_glossary_term' = 'Block Resolution Service Level Agreement (SLA) Hours');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `source` SET TAGS ('dbx_business_glossary_term' = 'Block Source');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `source` SET TAGS ('dbx_value_regex' = 'manual|automatic_credit_check|automatic_export_check|automatic_quality_check|system_rule|workflow');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Block Status');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|released|escalated|expired|cancelled');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Block Type');
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'delivery_block|billing_block|credit_block|export_control_block|quality_hold_block|payment_block|legal_block');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` SET TAGS ('dbx_subdomain' = 'fulfillment_logistics');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `returns_order_id` SET TAGS ('dbx_business_glossary_term' = 'Returns Order ID');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `ar_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Memo Ar Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `field_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Field Service Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `fulfillment_mode_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `ncr_id` SET TAGS ('dbx_business_glossary_term' = 'Ncr Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Processed By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `actual_goods_receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Goods Receipt Date');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `actual_goods_receipt_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `credit_memo_request_flag` SET TAGS ('dbx_business_glossary_term' = 'Credit Memo Request Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `credit_memo_request_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `customer_return_authorization_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Return Authorization Number');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `disposition_code` SET TAGS ('dbx_business_glossary_term' = 'Disposition Code');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `disposition_code` SET TAGS ('dbx_value_regex' = 'restock|refurbish|scrap|return_to_vendor|warranty_repair|quarantine|pending');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_value_regex' = '^d+(.d{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `inspection_lot_number` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Lot Number');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `inspection_lot_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,12}$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `inspection_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Inspection Required Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `inspection_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `material_condition_code` SET TAGS ('dbx_business_glossary_term' = 'Material Condition Code');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `material_condition_code` SET TAGS ('dbx_value_regex' = 'new|like_new|repairable|damaged|scrap|unknown');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `net_return_value` SET TAGS ('dbx_business_glossary_term' = 'Net Return Value');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `net_return_value` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `net_return_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `order_date` SET TAGS ('dbx_business_glossary_term' = 'Return Order Date');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `order_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `requested_pickup_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Pickup Date');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `requested_pickup_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `restocking_fee` SET TAGS ('dbx_business_glossary_term' = 'Restocking Fee');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `restocking_fee` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `restocking_fee` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `return_delivery_number` SET TAGS ('dbx_business_glossary_term' = 'Return Delivery Number');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `return_delivery_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `return_order_number` SET TAGS ('dbx_business_glossary_term' = 'Return Order Number');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `return_order_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `return_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Return Plant Code');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `return_plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `return_quantity` SET TAGS ('dbx_business_glossary_term' = 'Return Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `return_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `return_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Return Reason Code');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `return_reason_code` SET TAGS ('dbx_value_regex' = 'defective|wrong_item|over_delivery|warranty_return|damaged_in_transit|quality_rejection|customer_cancellation|excess_stock|specification_mismatch|other');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `return_reason_description` SET TAGS ('dbx_business_glossary_term' = 'Return Reason Description');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `rma_number` SET TAGS ('dbx_business_glossary_term' = 'Return Material Authorization (RMA) Number');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `rma_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,30}$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `sales_organization` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `sku_number` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) Number');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `sku_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,50}$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Return Order Status');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|in_review|approved|rejected|goods_received|inspection_pending|inspection_complete|credit_memo_created|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `storage_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `tax_amount` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|PC|KG|LB|M|FT|L|GAL|BOX|PAL|SET|M2|M3');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `warranty_claim_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ALTER COLUMN `warranty_claim_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` SET TAGS ('dbx_original_name' = 'order_amendment');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `amendment_id` SET TAGS ('dbx_business_glossary_term' = 'Order Amendment ID');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Amended By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `fulfillment_mode_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `approval_authority` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `approval_level` SET TAGS ('dbx_business_glossary_term' = 'Approval Level');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `approval_level` SET TAGS ('dbx_value_regex' = 'sales_representative|sales_manager|commercial_director|vp_sales|executive');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Internal Approval Status');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|conditionally_approved|rejected|escalated');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `approved_rejected_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Amendment Approved or Rejected Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `approved_rejected_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `atp_ctp_recheck_required` SET TAGS ('dbx_business_glossary_term' = 'Available to Promise / Capable to Promise (ATP/CTP) Recheck Required');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `atp_ctp_recheck_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `cancellation_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason Code');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `cancellation_reason_code` SET TAGS ('dbx_value_regex' = 'customer_request|duplicate_order|credit_hold|supply_failure|force_majeure|regulatory|pricing_dispute|other');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `customer_notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `customer_notification_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `customer_notified` SET TAGS ('dbx_business_glossary_term' = 'Customer Notified Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `customer_notified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `customer_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Reference Number');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `customer_request_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Request Date');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `customer_request_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `ecn_reference` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Reference');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `field_changed` SET TAGS ('dbx_business_glossary_term' = 'Field Changed');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `financial_impact_amount` SET TAGS ('dbx_business_glossary_term' = 'Financial Impact Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `financial_impact_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `implemented_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Amendment Implemented Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `implemented_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `new_value` SET TAGS ('dbx_business_glossary_term' = 'New Value');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Amendment Number');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^AMD-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `original_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Original Confirmed Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `original_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `previous_value` SET TAGS ('dbx_business_glossary_term' = 'Previous Value');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `production_schedule_impact` SET TAGS ('dbx_business_glossary_term' = 'Production Schedule Impact');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `production_schedule_impact` SET TAGS ('dbx_value_regex' = 'no_impact|minor_impact|moderate_impact|major_impact|critical_impact');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `production_schedule_impact_notes` SET TAGS ('dbx_business_glossary_term' = 'Production Schedule Impact Notes');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `quantity_delta` SET TAGS ('dbx_business_glossary_term' = 'Quantity Delta');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `reason_code` SET TAGS ('dbx_business_glossary_term' = 'Amendment Reason Code');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `reason_code` SET TAGS ('dbx_value_regex' = 'customer_request|forecast_revision|supply_constraint|engineering_change|pricing_correction|regulatory_compliance|force_majeure|internal_error|other');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `reason_description` SET TAGS ('dbx_business_glossary_term' = 'Amendment Reason Description');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested New Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL|EDI|CUSTOMER_PORTAL');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Amendment Status');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|approved|rejected|implemented|cancelled|withdrawn');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `submitted_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Amendment Submitted Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `submitted_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Amendment Type');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'quantity_change|delivery_date_change|configuration_change|price_change|cancellation|payment_terms_change|shipping_address_change|incoterms_change|other');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Amendment Version Number');
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `customer_po_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Purchase Order (PO) ID');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `blanket_order_id` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `fulfillment_mode_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `order_quotation_id` SET TAGS ('dbx_business_glossary_term' = 'Quotation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `accepted_date` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Acceptance Date');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `accepted_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `buyer_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Buyer Contact Email Address');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `buyer_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `buyer_contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `buyer_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `buyer_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Buyer Contact Name');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `buyer_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `buyer_contact_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `credit_check_status` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Status');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `credit_check_status` SET TAGS ('dbx_value_regex' = 'not_checked|approved|blocked|released_by_manager');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Number');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `customer_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Name');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `customer_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `edi_transmission_reference` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Transmission Reference');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `export_control_status` SET TAGS ('dbx_business_glossary_term' = 'Export Control Status');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `export_control_status` SET TAGS ('dbx_value_regex' = 'not_checked|cleared|blocked|under_review|license_required');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `gross_po_value` SET TAGS ('dbx_business_glossary_term' = 'Gross Purchase Order (PO) Value');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `gross_po_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Named Place / Location');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `po_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Purchase Order (PO) Date');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `po_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `po_line_item_count` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Line Item Count');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `po_line_item_count` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `po_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `po_type` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Type');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `po_type` SET TAGS ('dbx_value_regex' = 'standard|blanket|release|framework|consignment|call-off');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `received_date` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Received Date');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `received_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Rejection Reason');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `ship_to_country_code` SET TAGS ('dbx_business_glossary_term' = 'Ship-To Country Code');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `ship_to_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|EDI_GATEWAY|CUSTOMER_PORTAL|MANUAL');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Special Instructions');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Acceptance Status');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'received|under_review|accepted|partially_accepted|rejected|cancelled|fulfilled|closed');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Tax Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `total_po_value` SET TAGS ('dbx_business_glossary_term' = 'Total Purchase Order (PO) Value');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `total_po_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `transmission_channel` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Transmission Channel');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `transmission_channel` SET TAGS ('dbx_value_regex' = 'EDI|email|customer_portal|fax|manual|API|ERP_integration');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Validity End Date');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` SET TAGS ('dbx_subdomain' = 'contract_administration');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `blanket_order_id` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order ID');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `fulfillment_mode_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order Agreement Number');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `agreement_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `agreement_type` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order Agreement Type');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'scheduling_agreement|blanket_purchase_order|framework_order|quantity_contract|value_contract');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `committed_quantity` SET TAGS ('dbx_business_glossary_term' = 'Total Committed Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `committed_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Master Contract Reference Number');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `contract_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Ship-To Country Code');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Agreement Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Number');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,15}$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `customer_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Name');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `customer_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `discount_percent` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `discount_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `discount_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division Code');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `division` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `export_control_status` SET TAGS ('dbx_business_glossary_term' = 'Export Control Status');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `export_control_status` SET TAGS ('dbx_value_regex' = 'not_restricted|license_required|license_approved|embargo|under_review');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Named Place or Port');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `last_release_date` SET TAGS ('dbx_business_glossary_term' = 'Last Release Date');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `last_release_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `open_quantity` SET TAGS ('dbx_business_glossary_term' = 'Open Remaining Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `open_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Delivery Plant Code');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `price_unit` SET TAGS ('dbx_business_glossary_term' = 'Price Unit Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `price_unit` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `pricing_agreement_reference` SET TAGS ('dbx_business_glossary_term' = 'Pricing Agreement Reference Number');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `pricing_agreement_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `release_creation_profile` SET TAGS ('dbx_business_glossary_term' = 'Release Creation Profile');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `release_creation_profile` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `released_quantity` SET TAGS ('dbx_business_glossary_term' = 'Released Quantity to Date');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `released_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `sales_organization` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System Identifier');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|LEGACY_ERP|MANUAL');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order Status');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|partially_released|fully_released|on_hold|expired|cancelled|closed');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `tolerance_over_delivery_percent` SET TAGS ('dbx_business_glossary_term' = 'Over-Delivery Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `tolerance_over_delivery_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `tolerance_under_delivery_percent` SET TAGS ('dbx_business_glossary_term' = 'Under-Delivery Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `tolerance_under_delivery_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,5}$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order Validity End Date');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` SET TAGS ('dbx_subdomain' = 'fulfillment_logistics');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` SET TAGS ('dbx_original_name' = 'order_fulfillment_plan');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `fulfillment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Order Fulfillment Plan ID');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `fulfillment_mode_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `priority_id` SET TAGS ('dbx_business_glossary_term' = 'Order Priority Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `actual_fulfillment_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Fulfillment Date');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `actual_fulfillment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `actual_goods_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Goods Issue Date');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `actual_goods_issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `atp_ctp_check_result` SET TAGS ('dbx_business_glossary_term' = 'Available to Promise / Capable to Promise (ATP/CTP) Check Result');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `atp_ctp_check_result` SET TAGS ('dbx_value_regex' = 'confirmed|partial|not_available|ctp_required|backorder');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `bottleneck_description` SET TAGS ('dbx_business_glossary_term' = 'Bottleneck Description');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `bottleneck_flag` SET TAGS ('dbx_business_glossary_term' = 'Bottleneck Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `bottleneck_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `confirmed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Plan Confirmed Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `confirmed_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `delivery_delay_days` SET TAGS ('dbx_business_glossary_term' = 'Delivery Delay Days');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `exception_alert_code` SET TAGS ('dbx_business_glossary_term' = 'Exception Alert Code');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `exception_alert_code` SET TAGS ('dbx_value_regex' = 'material_shortage|capacity_overload|supplier_delay|quality_hold|export_control_hold|customer_change|engineering_change|logistics_delay|none');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `exception_alert_description` SET TAGS ('dbx_business_glossary_term' = 'Exception Alert Description');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `fulfilled_quantity` SET TAGS ('dbx_business_glossary_term' = 'Actual Fulfilled Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `mrp_controller` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Controller');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `on_time_delivery_flag` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `on_time_delivery_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Plan Number');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_value_regex' = '^OFP-[0-9]{4}-[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `plan_version` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Plan Version');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `plan_version` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `planned_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `planned_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `planned_goods_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Goods Issue Date');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `planned_goods_issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `planned_production_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Production Start Date');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `planned_production_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `planned_quantity` SET TAGS ('dbx_business_glossary_term' = 'Planned Fulfillment Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `procurement_order_number` SET TAGS ('dbx_business_glossary_term' = 'Planned Procurement Order Number');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `production_order_number` SET TAGS ('dbx_business_glossary_term' = 'Planned Production Order Number');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `production_planner` SET TAGS ('dbx_business_glossary_term' = 'Production Planner');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `route_code` SET TAGS ('dbx_business_glossary_term' = 'Transportation Route Code');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `scheduling_type` SET TAGS ('dbx_business_glossary_term' = 'Production Scheduling Type');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `scheduling_type` SET TAGS ('dbx_value_regex' = 'forward|backward|current_date');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `shipping_point` SET TAGS ('dbx_business_glossary_term' = 'Shipping Point');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|OPCENTER_MES|ARIBA|INFOR_WMS|MANUAL');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Plan Status');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|confirmed|in_progress|partially_fulfilled|fulfilled|cancelled|on_hold|exception');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|LB|M|M2|M3|L|PC|SET|BOX|PAL');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` SET TAGS ('dbx_subdomain' = 'fulfillment_logistics');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `goods_issue_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue ID');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Issued By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `actual_goods_issue_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Goods Issue Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `actual_goods_issue_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `batch_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `delivery_item_number` SET TAGS ('dbx_business_glossary_term' = 'Outbound Delivery Item Number');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `delivery_item_number` SET TAGS ('dbx_value_regex' = '^[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `delivery_quantity` SET TAGS ('dbx_business_glossary_term' = 'Delivery Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `delivery_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue Document Date');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `document_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `document_item_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue Document Item Number');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `document_item_number` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue Document Number');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `document_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `export_control_status` SET TAGS ('dbx_business_glossary_term' = 'Export Control Status');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `export_control_status` SET TAGS ('dbx_value_regex' = 'not_restricted|license_required|license_approved|embargoed|under_review');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `goods_recipient` SET TAGS ('dbx_business_glossary_term' = 'Goods Recipient');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = '^(EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF)$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `issued_quantity` SET TAGS ('dbx_business_glossary_term' = 'Issued Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `issued_quantity` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `movement_type` SET TAGS ('dbx_business_glossary_term' = 'Movement Type');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `movement_type` SET TAGS ('dbx_value_regex' = '^[0-9]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue Posting Date');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `profit_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `reversal_flag` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue Reversal Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `reversal_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `reversal_reference_document` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reference Document Number');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `reversal_reference_document` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `route_code` SET TAGS ('dbx_business_glossary_term' = 'Shipping Route Code');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `route_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `serial_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,30}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `shipping_point` SET TAGS ('dbx_business_glossary_term' = 'Shipping Point');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `shipping_point` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `sku_number` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) Number');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `sku_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,50}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|INFOR_WMS|MANUAL');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `special_stock_indicator` SET TAGS ('dbx_business_glossary_term' = 'Special Stock Indicator');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `special_stock_indicator` SET TAGS ('dbx_value_regex' = '^(E|Q|K|W|V|M|O|S|)?$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue Status');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'posted|reversed|blocked|in_transit|confirmed|cancelled');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `storage_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,6}$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `unloading_point` SET TAGS ('dbx_business_glossary_term' = 'Unloading Point');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `valuation_type` SET TAGS ('dbx_business_glossary_term' = 'Inventory Valuation Type');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `valuation_type` SET TAGS ('dbx_value_regex' = 'moving_average_price|standard_price|fifo|lifo');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `value` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue Value');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `value` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `warehouse_number` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Number');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `warehouse_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` SET TAGS ('dbx_subdomain' = 'contract_administration');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` SET TAGS ('dbx_original_name' = 'order_channel');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Order Channel ID');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `partner_id` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Partner Identifier');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `fulfillment_mode_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `approval_required_above_value` SET TAGS ('dbx_business_glossary_term' = 'Approval Required Above Value Threshold');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `approval_required_above_value` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `atp_ctp_check_required` SET TAGS ('dbx_business_glossary_term' = 'Available to Promise / Capable to Promise (ATP/CTP) Check Required Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `atp_ctp_check_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Order Channel Category');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'direct_sales|distributor|oem_partner|ecommerce|edi|field_sales|inside_sales|agent_rep|reseller|marketplace');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Order Channel Code');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `commission_eligible` SET TAGS ('dbx_business_glossary_term' = 'Commission Eligibility Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `commission_eligible` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `commission_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Commission Rate Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `commission_rate_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `commission_rate_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `credit_check_required` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Required Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `credit_check_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `crm_channel_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Relationship Management (CRM) Channel Identifier');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `division_code` SET TAGS ('dbx_business_glossary_term' = 'Division Code');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `division_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `edi_standard` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Standard');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `edi_standard` SET TAGS ('dbx_value_regex' = 'EDIFACT|ANSI_X12|ODETTE|VDA|TRADACOMS|NONE');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `edi_transaction_set` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Transaction Set');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Channel Effective Date');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Channel Expiry Date');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `export_control_applicable` SET TAGS ('dbx_business_glossary_term' = 'Export Control Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `export_control_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Channel Lead Time Days');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_value_regex' = '^d+$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `max_order_value` SET TAGS ('dbx_business_glossary_term' = 'Maximum Order Value');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `max_order_value` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `min_order_value` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Value');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `min_order_value` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Order Channel Name');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `order_entry_method` SET TAGS ('dbx_business_glossary_term' = 'Order Entry Method');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `order_entry_method` SET TAGS ('dbx_value_regex' = 'manual|edi_automated|portal_self_service|api_integration|email|phone|fax|field_sales_app');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `partner_agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Partner Agreement Number');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `partner_agreement_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `portal_integration_reference` SET TAGS ('dbx_business_glossary_term' = 'Portal Integration Reference');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `portal_type` SET TAGS ('dbx_business_glossary_term' = 'Portal Type');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `portal_type` SET TAGS ('dbx_value_regex' = 'customer_self_service|partner_portal|distributor_portal|oem_portal|marketplace|internal|none');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `sla_order_confirmation_hours` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Order Confirmation Hours');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `sla_order_confirmation_hours` SET TAGS ('dbx_value_regex' = '^d+$');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL|EDI_GATEWAY|OTHER');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Order Channel Status');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|pending_activation|decommissioned');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `tax_classification` SET TAGS ('dbx_business_glossary_term' = 'Tax Classification');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `tax_classification` SET TAGS ('dbx_value_regex' = 'taxable|exempt|zero_rated|reverse_charge');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Order Channel Type');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'direct|indirect|digital|edi|partner|agent');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` SET TAGS ('dbx_subdomain' = 'fulfillment_logistics');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `fulfillment_mode_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode ID');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `applicable_product_families` SET TAGS ('dbx_business_glossary_term' = 'Applicable Product Families');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `atp_applicable` SET TAGS ('dbx_business_glossary_term' = 'Available to Promise (ATP) Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `atp_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `bom_explosion_trigger` SET TAGS ('dbx_business_glossary_term' = 'Bill of Materials (BOM) Explosion Trigger');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `bom_explosion_trigger` SET TAGS ('dbx_value_regex' = 'order_creation|production_order|sales_order|manual|not_applicable');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `capacity_reservation_required` SET TAGS ('dbx_business_glossary_term' = 'Capacity Reservation Required Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `capacity_reservation_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Code');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = 'MTO|MTS|ETO|ATO');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `configuration_required` SET TAGS ('dbx_business_glossary_term' = 'Product Configuration Required Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `configuration_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `contract_manufacturing_eligible` SET TAGS ('dbx_business_glossary_term' = 'Contract Manufacturing Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `contract_manufacturing_eligible` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `costing_method` SET TAGS ('dbx_business_glossary_term' = 'Costing Method');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `costing_method` SET TAGS ('dbx_value_regex' = 'standard_cost|actual_cost|project_cost|moving_average|not_applicable');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `ctp_applicable` SET TAGS ('dbx_business_glossary_term' = 'Capable to Promise (CTP) Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `ctp_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `customer_specific_design` SET TAGS ('dbx_business_glossary_term' = 'Customer-Specific Design Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `customer_specific_design` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `delivery_scheduling_method` SET TAGS ('dbx_business_glossary_term' = 'Delivery Scheduling Method');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `delivery_scheduling_method` SET TAGS ('dbx_value_regex' = 'forward_scheduling|backward_scheduling|atp_based|ctp_based|manual');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `demand_management_type` SET TAGS ('dbx_business_glossary_term' = 'Demand Management Type');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `demand_management_type` SET TAGS ('dbx_value_regex' = 'make_to_forecast|make_to_order|engineer_to_order|assemble_to_order');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Description');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `digital_twin_applicable` SET TAGS ('dbx_business_glossary_term' = 'Digital Twin Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `digital_twin_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `engineering_change_required` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Required Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `engineering_change_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `export_control_relevance` SET TAGS ('dbx_business_glossary_term' = 'Export Control Relevance');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `export_control_relevance` SET TAGS ('dbx_value_regex' = 'always_check|check_if_applicable|not_applicable');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `inventory_consumption_model` SET TAGS ('dbx_business_glossary_term' = 'Inventory Consumption Model');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `inventory_consumption_model` SET TAGS ('dbx_value_regex' = 'consume_stock|build_to_order|configure_to_order|engineer_to_order|no_stock_consumption');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `max_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Maximum Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `max_lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `min_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Minimum Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `min_lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `mrp_type` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Type');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `mrp_type` SET TAGS ('dbx_value_regex' = 'MRP|KANBAN|reorder_point|no_planning|manual');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Name');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `order_to_cash_process_variant` SET TAGS ('dbx_business_glossary_term' = 'Order-to-Cash Process Variant');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `order_to_cash_process_variant` SET TAGS ('dbx_value_regex' = 'standard|project_based|service_based|consignment|third_party');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `partial_delivery_allowed` SET TAGS ('dbx_business_glossary_term' = 'Partial Delivery Allowed Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `partial_delivery_allowed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `planning_strategy_group` SET TAGS ('dbx_business_glossary_term' = 'Planning Strategy Group');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `ppap_required` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Required Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `ppap_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `procurement_trigger` SET TAGS ('dbx_business_glossary_term' = 'Procurement Trigger');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `procurement_trigger` SET TAGS ('dbx_value_regex' = 'sales_order|production_order|mrp_run|manual|not_applicable');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `production_order_creation_rule` SET TAGS ('dbx_business_glossary_term' = 'Production Order Creation Rule');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `production_order_creation_rule` SET TAGS ('dbx_value_regex' = 'automatic|manual|not_applicable|planned_order_conversion');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `quality_inspection_plan` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Plan Type');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `quality_inspection_plan` SET TAGS ('dbx_value_regex' = 'standard|enhanced|first_article|customer_witness|not_required');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `revenue_recognition_method` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Method');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `revenue_recognition_method` SET TAGS ('dbx_value_regex' = 'point_in_time|over_time|milestone_based|percentage_of_completion');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Status');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `typical_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Typical Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `typical_lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `wip_tracking_required` SET TAGS ('dbx_business_glossary_term' = 'Work in Progress (WIP) Tracking Required Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_mode` ALTER COLUMN `wip_tracking_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` SET TAGS ('dbx_original_name' = 'order_priority');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `priority_id` SET TAGS ('dbx_business_glossary_term' = 'Order Priority ID');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `applicable_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Applicable Plant Code');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `applicable_sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Applicable Sales Organization');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `approval_authority_level` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority Level');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `approval_authority_level` SET TAGS ('dbx_value_regex' = 'none|supervisor|manager|director|vp|executive');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `approval_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Approval Required Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `approval_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Order Priority Category');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'operational|strategic|regulatory|contractual');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Order Priority Code');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `color_code` SET TAGS ('dbx_business_glossary_term' = 'Priority Color Code');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `color_code` SET TAGS ('dbx_value_regex' = '^#[0-9A-Fa-f]{6}$');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `cost_surcharge_percent` SET TAGS ('dbx_business_glossary_term' = 'Priority Cost Surcharge Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `cost_surcharge_percent` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `customer_notification_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Required Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `customer_notification_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `dedicated_resource_flag` SET TAGS ('dbx_business_glossary_term' = 'Dedicated Resource Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `dedicated_resource_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Order Priority Description');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `escalation_threshold_days` SET TAGS ('dbx_business_glossary_term' = 'Escalation Threshold Days');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `escalation_threshold_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `expedited_freight_flag` SET TAGS ('dbx_business_glossary_term' = 'Expedited Freight Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `expedited_freight_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `fulfillment_mode_applicability` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Mode Applicability');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `fulfillment_mode_applicability` SET TAGS ('dbx_value_regex' = 'all|mto|mts|eto|ato');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `icon_code` SET TAGS ('dbx_business_glossary_term' = 'Priority Icon Code');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `max_order_value_threshold` SET TAGS ('dbx_business_glossary_term' = 'Maximum Order Value Threshold');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Order Priority Name');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `name` SET TAGS ('dbx_value_regex' = 'Standard|Expedite|Critical|Emergency|Strategic Account');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `nps_impact_level` SET TAGS ('dbx_business_glossary_term' = 'Net Promoter Score (NPS) Impact Level');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `nps_impact_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `overtime_authorization_flag` SET TAGS ('dbx_business_glossary_term' = 'Overtime Authorization Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `overtime_authorization_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `production_scheduling_weight` SET TAGS ('dbx_business_glossary_term' = 'Production Scheduling Weight');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `production_scheduling_weight` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `rank` SET TAGS ('dbx_business_glossary_term' = 'Order Priority Rank');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `rank` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `sla_breach_notification_hours` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach Notification Hours');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `sla_breach_notification_hours` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|OPCENTER_MES|SALESFORCE_CRM|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Order Priority Status');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `strategic_account_flag` SET TAGS ('dbx_business_glossary_term' = 'Strategic Account Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `strategic_account_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `supplier_expedite_flag` SET TAGS ('dbx_business_glossary_term' = 'Supplier Expedite Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `supplier_expedite_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `target_order_to_ship_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Target Order-to-Ship Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `target_order_to_ship_lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `warehouse_pick_priority` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Pick Priority');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` ALTER COLUMN `warehouse_pick_priority` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` SET TAGS ('dbx_subdomain' = 'fulfillment_logistics');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `credit_check_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Check ID');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `ar_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ar Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `credit_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Profile Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reviewed By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `available_credit_amount` SET TAGS ('dbx_business_glossary_term' = 'Available Credit Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `available_credit_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `check_date` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Date');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `check_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `check_number` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Number');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `check_number` SET TAGS ('dbx_value_regex' = '^CC-[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `check_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `check_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `check_type` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Type');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `check_type` SET TAGS ('dbx_value_regex' = 'static|dynamic|automatic|manual');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `checking_rule` SET TAGS ('dbx_business_glossary_term' = 'Credit Checking Rule');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `credit_control_area` SET TAGS ('dbx_business_glossary_term' = 'Credit Control Area');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `credit_horizon_date` SET TAGS ('dbx_business_glossary_term' = 'Credit Horizon Date');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `credit_horizon_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `credit_limit_amount` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `credit_limit_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `current_exposure_amount` SET TAGS ('dbx_business_glossary_term' = 'Current Credit Exposure Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `current_exposure_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Number');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Credit Review Date');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `oldest_open_item_days` SET TAGS ('dbx_business_glossary_term' = 'Oldest Open Item Age (Days)');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `oldest_open_item_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `open_deliveries_amount` SET TAGS ('dbx_business_glossary_term' = 'Open Deliveries Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `open_deliveries_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `open_orders_amount` SET TAGS ('dbx_business_glossary_term' = 'Open Orders Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `open_orders_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `open_receivables_amount` SET TAGS ('dbx_business_glossary_term' = 'Open Receivables Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `open_receivables_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `order_value_amount` SET TAGS ('dbx_business_glossary_term' = 'Order Value Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `order_value_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `override_flag` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Override Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `override_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `override_reason` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Override Reason');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `payment_index` SET TAGS ('dbx_business_glossary_term' = 'Customer Payment Index');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `release_authorization_level` SET TAGS ('dbx_business_glossary_term' = 'Release Authorization Level');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `release_authorization_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3|executive');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `release_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Credit Release Reason Code');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `release_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Credit Block Release Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `release_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `released_by` SET TAGS ('dbx_business_glossary_term' = 'Released By User');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `result` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Result');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `result` SET TAGS ('dbx_value_regex' = 'approved|blocked|warning|released');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `risk_category` SET TAGS ('dbx_business_glossary_term' = 'Customer Credit Risk Category');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `risk_category` SET TAGS ('dbx_value_regex' = 'low|medium|high|very_high|blocked');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|MANUAL|EXTERNAL_AGENCY');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Status');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|completed|overridden|cancelled');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `utilization_percent` SET TAGS ('dbx_business_glossary_term' = 'Credit Utilization Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `utilization_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` SET TAGS ('dbx_subdomain' = 'fulfillment_logistics');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `export_control_check_id` SET TAGS ('dbx_business_glossary_term' = 'Export Control Check ID');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Officer Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `export_classification_id` SET TAGS ('dbx_business_glossary_term' = 'Export Classification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `hazardous_substance_id` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Substance Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `hse_reach_substance_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Reach Substance Declaration Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `product_regulatory_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Certification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `sanctions_screening_id` SET TAGS ('dbx_business_glossary_term' = 'Sanctions Screening Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `blocked_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Blocked Reason Code');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `blocked_reason_code` SET TAGS ('dbx_value_regex' = 'EMBARGO|DENIED_PARTY|LICENSE_REQUIRED|ECCN_RESTRICTED|END_USE_PROHIBITED|PENDING_DOCUMENTATION|OTHER');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `check_date` SET TAGS ('dbx_business_glossary_term' = 'Export Control Check Date');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `check_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `check_method` SET TAGS ('dbx_business_glossary_term' = 'Export Control Check Method');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `check_method` SET TAGS ('dbx_value_regex' = 'automated|manual|hybrid');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `check_number` SET TAGS ('dbx_business_glossary_term' = 'Export Control Check Number');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `check_number` SET TAGS ('dbx_value_regex' = '^ECC-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `check_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Export Control Check Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `check_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `consignee_name` SET TAGS ('dbx_business_glossary_term' = 'Consignee Name');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `consignee_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `denied_party_screening_result` SET TAGS ('dbx_business_glossary_term' = 'Denied Party Screening (DPS) Result');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `denied_party_screening_result` SET TAGS ('dbx_value_regex' = 'pass|fail|potential_match|not_applicable');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Code');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `eccn` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification Number (ECCN)');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `eccn` SET TAGS ('dbx_value_regex' = '^[0-9][A-E][0-9]{3}[a-z]?$');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `embargo_check_result` SET TAGS ('dbx_business_glossary_term' = 'Embargo Check Result');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `embargo_check_result` SET TAGS ('dbx_value_regex' = 'pass|fail|not_applicable');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `end_customer_country_code` SET TAGS ('dbx_business_glossary_term' = 'End Customer Country Code');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `end_customer_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `end_customer_name` SET TAGS ('dbx_business_glossary_term' = 'End Customer Name');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `end_customer_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `end_use_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'End-Use Certificate (EUC) Number');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `end_use_country_code` SET TAGS ('dbx_business_glossary_term' = 'End-Use Country Code');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `end_use_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `end_use_description` SET TAGS ('dbx_business_glossary_term' = 'End-Use Description');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `eu_dual_use_code` SET TAGS ('dbx_business_glossary_term' = 'EU Dual-Use Control Code');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `exporting_country_code` SET TAGS ('dbx_business_glossary_term' = 'Exporting Country Code');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `exporting_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `hs_code` SET TAGS ('dbx_business_glossary_term' = 'Harmonized System (HS) Code');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `hs_code` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `license_exception_code` SET TAGS ('dbx_business_glossary_term' = 'Export License Exception Code');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `license_exception_code` SET TAGS ('dbx_value_regex' = 'EAR99|LVS|GBS|CIV|TSR|APP|STA|TMP|RPL|GOV|TSU|BAG|AVS|NLR|');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `license_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Export License Expiry Date');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `license_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `license_number` SET TAGS ('dbx_business_glossary_term' = 'Export License Number');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `license_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Export License Required Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `license_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `override_flag` SET TAGS ('dbx_business_glossary_term' = 'Compliance Override Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `override_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `override_reason` SET TAGS ('dbx_business_glossary_term' = 'Compliance Override Reason');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `recheck_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Re-Check Required Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `recheck_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `regulatory_authority` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Authority');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `regulatory_authority` SET TAGS ('dbx_value_regex' = 'BIS|DDTC|OFAC|EU_MEMBER_STATE|HMRC|OTHER');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `regulatory_framework` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Framework');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `regulatory_framework` SET TAGS ('dbx_value_regex' = 'EAR|ITAR|EU_DUAL_USE|UK_OGEL|WASSENAAR|COMBINED|OTHER');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `risk_classification` SET TAGS ('dbx_business_glossary_term' = 'Export Control Risk Classification');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `risk_classification` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `screening_tool` SET TAGS ('dbx_business_glossary_term' = 'Screening Tool');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Export Control Check Status');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'cleared|blocked|pending_review|expired|cancelled');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `us_ml_category` SET TAGS ('dbx_business_glossary_term' = 'US Munitions List (USML) Category');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `validity_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Check Validity Expiry Date');
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ALTER COLUMN `validity_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`text` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`text` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `manufacturing_ecm`.`order`.`text` SET TAGS ('dbx_original_name' = 'order_text');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `text_id` SET TAGS ('dbx_business_glossary_term' = 'Text ID');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `order_quotation_id` SET TAGS ('dbx_business_glossary_term' = 'Quotation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `previous_version_text_id` SET TAGS ('dbx_business_glossary_term' = 'Previous Version ID');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Text Category');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'header_text|item_text|partner_text|condition_text');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Level');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_value_regex' = 'public|internal|confidential|restricted');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `content` SET TAGS ('dbx_business_glossary_term' = 'Text Content');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `created_by_name` SET TAGS ('dbx_business_glossary_term' = 'Created By User Full Name');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Document Type');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `document_type` SET TAGS ('dbx_value_regex' = 'sales_order|quotation|delivery|returns_order|rfq|contract|billing_document');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `export_control_relevant` SET TAGS ('dbx_business_glossary_term' = 'Export Control Relevant Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `export_control_relevant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `format` SET TAGS ('dbx_business_glossary_term' = 'Text Format');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `format` SET TAGS ('dbx_value_regex' = 'plain_text|html|rtf|structured');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `hazardous_goods_relevant` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Goods Relevant Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `hazardous_goods_relevant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `length_chars` SET TAGS ('dbx_business_glossary_term' = 'Text Length in Characters');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `length_chars` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `object` SET TAGS ('dbx_business_glossary_term' = 'Text Object');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `object` SET TAGS ('dbx_value_regex' = 'VBBK|VBBP|LIKP|LIPS|VBKD|KUAGV|KNVV');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `print_indicator` SET TAGS ('dbx_business_glossary_term' = 'Print Indicator');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `print_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `quality_relevant` SET TAGS ('dbx_business_glossary_term' = 'Quality Relevant Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `quality_relevant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Sequence Number');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `sequence_number` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `source_object_type` SET TAGS ('dbx_business_glossary_term' = 'Source Object Type');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `source_object_type` SET TAGS ('dbx_value_regex' = 'customer_master|material_master|quotation|contract|sales_order|manual_entry');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|TEAMCENTER_PLM|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `source_system_text_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Text Key');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `source_text_reference` SET TAGS ('dbx_business_glossary_term' = 'Source Text Reference');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Text Record Status');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|superseded|deleted|archived');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `transfer_to_delivery_flag` SET TAGS ('dbx_business_glossary_term' = 'Transfer to Delivery Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `transfer_to_delivery_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `transfer_to_invoice_flag` SET TAGS ('dbx_business_glossary_term' = 'Transfer to Invoice Flag');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `transfer_to_invoice_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `type_code` SET TAGS ('dbx_business_glossary_term' = 'Text Type Code');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `type_code` SET TAGS ('dbx_value_regex' = 'customer_instruction|internal_note|shipping_note|packing_instruction|technical_note|quality_note|delivery_note|billing_note|legal_note|compliance_note|hazardous_goods_note|export_note');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `type_name` SET TAGS ('dbx_business_glossary_term' = 'Text Type Name');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `visibility_scope` SET TAGS ('dbx_business_glossary_term' = 'Visibility Scope');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `visibility_scope` SET TAGS ('dbx_value_regex' = 'internal|customer_facing|carrier_facing|supplier_facing|public');
ALTER TABLE `manufacturing_ecm`.`order`.`text` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` SET TAGS ('dbx_subdomain' = 'contract_administration');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` SET TAGS ('dbx_association_edges' = 'order.blanket_order,asset.spare_part');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `blanket_order_line_id` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order Line Identifier');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `blanket_order_id` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order Line - Blanket Order Id');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `spare_part_id` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order Line - Spare Part Id');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `committed_quantity` SET TAGS ('dbx_business_glossary_term' = 'Committed Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `committed_value` SET TAGS ('dbx_business_glossary_term' = 'Total Committed Contract Value');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `committed_value` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `committed_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `contracted_price` SET TAGS ('dbx_business_glossary_term' = 'Contracted Unit Price');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `delivery_schedule_type` SET TAGS ('dbx_business_glossary_term' = 'Delivery Schedule Type');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `delivery_schedule_type` SET TAGS ('dbx_value_regex' = 'jit|forecast|kanban|periodic|on_demand');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Procurement Lead Time');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Line Item Number');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `line_status` SET TAGS ('dbx_business_glossary_term' = 'Line Item Status');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `minimum_release_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Release Quantity');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `net_price` SET TAGS ('dbx_business_glossary_term' = 'Net Unit Price');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `net_price` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `net_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `next_release_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Release Date');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `next_release_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `open_quantity` SET TAGS ('dbx_business_glossary_term' = 'Open Quantity Remaining');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Delivery Plant');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `price_unit` SET TAGS ('dbx_business_glossary_term' = 'Price Unit Basis');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `released_quantity` SET TAGS ('dbx_business_glossary_term' = 'Released Quantity to Date');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `released_value` SET TAGS ('dbx_business_glossary_term' = 'Released Value to Date');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `released_value` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `released_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Line Validity End Date');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Line Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` SET TAGS ('dbx_subdomain' = 'contract_administration');
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` SET TAGS ('dbx_association_edges' = 'order.sales_order,service.service_contract');
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` SET TAGS ('dbx_original_name' = 'order_service_coverage');
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` ALTER COLUMN `service_coverage_id` SET TAGS ('dbx_business_glossary_term' = 'Order Service Coverage ID');
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Order Service Coverage - Service Contract Id');
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Order Service Coverage - Sales Order Id');
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` ALTER COLUMN `added_to_contract_date` SET TAGS ('dbx_business_glossary_term' = 'Added to Contract Date');
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` ALTER COLUMN `annual_coverage_value` SET TAGS ('dbx_business_glossary_term' = 'Annual Coverage Value');
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` ALTER COLUMN `coverage_end_date` SET TAGS ('dbx_business_glossary_term' = 'Coverage End Date');
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` ALTER COLUMN `coverage_level` SET TAGS ('dbx_business_glossary_term' = 'Coverage Level');
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` ALTER COLUMN `coverage_start_date` SET TAGS ('dbx_business_glossary_term' = 'Coverage Start Date');
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` ALTER COLUMN `coverage_status` SET TAGS ('dbx_business_glossary_term' = 'Coverage Status');
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` ALTER COLUMN `equipment_serial_numbers` SET TAGS ('dbx_business_glossary_term' = 'Equipment Serial Numbers');
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` ALTER COLUMN `removed_from_contract_date` SET TAGS ('dbx_business_glossary_term' = 'Removed from Contract Date');
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` ALTER COLUMN `response_time_sla_hours` SET TAGS ('dbx_business_glossary_term' = 'Response Time SLA');
