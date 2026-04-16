-- Schema for Domain: order | Business:  | Version: v1_mvm
-- Generated on: 2026-04-16 09:51:30

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`order` COMMENT 'SSOT for all customer order transactions including RFQ/RFP processing, quotations, sales orders, ATP/CTP commitments, order configuration options, fulfillment scheduling, delivery confirmation, and order-to-cash workflows. Manages order lifecycle from quote to cash across MTO, MTS, ETO, and ATO fulfillment modes.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`quotation` (
    `quotation_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a commercial quotation record in the Silver layer lakehouse. Serves as the primary key for all downstream joins and lineage tracking.',
    `blanket_order_id` BIGINT COMMENT 'Foreign key linking to order.blanket_order. Business justification: Quotations may be issued under a blanket order framework. The string contract_number is replaced by FK blanket_order_id.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to order.channel. Business justification: Commercial quotations are issued through specific sales channels. The channel reference table captures the full channel definition including SLA hours, credit check requirements, commission rates, and',
    `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: Quotations are addressed to specific contacts at customer accounts. Sales teams use this to direct quotes to the right decision-maker and track engagement.',
    `currency_exchange_rate_id` BIGINT COMMENT 'Foreign key linking to finance.currency_exchange_rate. Business justification: Quotations for international manufacturing customers are issued in customer currency. The exchange rate at quotation time must be locked and referenced for accurate price-to-order conversion and finan',
    `discount_structure_id` BIGINT COMMENT 'Foreign key linking to sales.discount_structure. Business justification: Quotations apply a negotiated discount structure (volume, channel, customer tier). Sales and finance use this link to validate that discounts on quotes comply with approved structures and margin thres',
    `pricing_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.pricing_agreement. Business justification: Quotations reference existing pricing agreements to provide consistent pricing. Sales teams use this to generate accurate quotes based on negotiated customer terms.',
    `rfq_request_id` BIGINT COMMENT 'Foreign key linking to order.rfq_request. Business justification: A quotation is issued in response to an RFQ/RFP. The string rfq_reference_number is replaced by FK rfq_request_id, establishing the quote-to-RFQ traceability.',
    `sales_org_id` BIGINT COMMENT 'Foreign key linking to product.sales_org. Business justification: Quotations are issued by a specific sales organization which governs product availability, pricing, and terms. Sales teams use this to ensure the correct product catalog and pricing rules are applied ',
    `sales_price_list_id` BIGINT COMMENT 'Foreign key linking to sales.price_list. Business justification: Quotations reference price lists to determine base pricing before discounts. Sales teams select appropriate price list based on customer type, region, and contract terms.',
    `service_contract_id` BIGINT COMMENT 'Foreign key linking to asset.service_contract. Business justification: Quotations for industrial equipment services or parts are frequently issued under an existing service contract that governs pricing, SLAs, and scope. Sales teams reference the service contract on the ',
    `tax_code_id` BIGINT COMMENT 'Foreign key linking to finance.tax_code. Business justification: Quotations must include applicable tax codes for accurate total pricing presented to customers. Finance and sales operations use this link to validate tax compliance before quotation approval.',
    `accepted_rejected_timestamp` TIMESTAMP COMMENT 'Date and time at which the customer formally accepted or rejected the quotation. Used to calculate quotation cycle time and measure sales velocity.',
    `competitor_name` STRING COMMENT 'Name of the competing supplier identified during the quotation process. Populated when the win/loss reason involves a competitor selection. Used for competitive intelligence and market share analysis.',
    `confirmed_delivery_date` DATE COMMENT 'Delivery date confirmed by manufacturing/supply chain based on ATP or CTP availability check. Represents the committed delivery commitment communicated to the customer in the quotation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `converted_order_number` STRING COMMENT 'SAP sales order number created when this quotation was accepted and converted. Populated only when status is converted. Enables end-to-end order-to-cash traceability.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which all monetary values on this quotation are expressed (e.g., USD, EUR, GBP). Supports multi-currency reporting and FX conversion.. Valid values are `^[A-Z]{3}$`',
    `customer_account_number` STRING COMMENT 'SAP customer account number (sold-to party) associated with this quotation. Links the quotation to the customer master record for credit, pricing, and order management purposes.',
    `customer_name` STRING COMMENT 'Legal or trading name of the customer or prospect to whom the quotation is addressed. Captured at quotation time to preserve the commercial record even if the customer master is subsequently updated.',
    `delivery_lead_time_days` STRING COMMENT 'Number of calendar days from order placement to expected delivery as quoted to the customer. Derived from production scheduling and logistics planning for the specific fulfillment mode.. Valid values are `^[0-9]+$`',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Overall header-level discount percentage applied to the quotation net value. Captures the commercial discount negotiated with the customer for margin analysis and pricing governance.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
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
    CONSTRAINT pk_quotation PRIMARY KEY(`quotation_id`)
) COMMENT 'Commercial quotation issued to a customer or prospect in response to an RFQ/RFP. Captures quotation number, validity start and end dates, customer reference, quoted products and configurations, pricing conditions, discount structures, delivery lead times, payment terms, incoterms, quotation status (draft, submitted, accepted, rejected, expired), win/loss reason, linked opportunity reference, and sales representative. Supports MTO, ETO, and ATO quoting workflows. Sourced from SAP S/4HANA SD quotation module.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`quotation_line_item` (
    `quotation_line_item_id` BIGINT COMMENT 'Unique system-generated identifier for each individual line item within a commercial quotation. Serves as the primary key for the quotation_line_item entity.',
    `discount_structure_id` BIGINT COMMENT 'Foreign key linking to sales.discount_structure. Business justification: Individual quotation line items in complex industrial deals may carry line-level discount structures (e.g., product-family discounts). Sales controllers validate per-line discounts against approved st',
    `product_configuration_id` BIGINT COMMENT 'Foreign key linking to product.product_configuration. Business justification: Quotation line items are built around specific product configurations. Sales engineers reference product configurations when preparing quotes to ensure accurate pricing and feasibility for configured ',
    `quotation_id` BIGINT COMMENT 'Foreign key linking to order.quotation. Business justification: quotation_line_item is a child of quotation. No existing quotation_id or quotation_number string key is visible in quotation_line_item attributes, so a new FK quotation_id is added to establish the pa',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: Quotation line items require a unit of measure for accurate quantity and pricing. Sales teams use this to align quoted quantities with product catalog UOM definitions before sending to customers.',
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
    `validity_end_date` DATE COMMENT 'Expiration date after which the pricing and terms on this quotation line item are no longer valid. Customer must accept or request renewal before this date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `validity_start_date` DATE COMMENT 'Date from which the pricing and terms on this quotation line item are valid. Defines the start of the quotation validity window for this specific line.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_quotation_line_item PRIMARY KEY(`quotation_line_item_id`)
) COMMENT 'Individual line item within a commercial quotation detailing a specific product, system, or component being quoted. Captures line number, material/SKU, quoted quantity, unit of measure, list price, quoted net price, discount percentage, delivery lead time, configuration options, technical specifications summary, and line item status. Enables granular pricing and configuration tracking at the item level for complex industrial manufacturing quotations.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`rfq_request` (
    `rfq_request_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each inbound RFQ or RFP record in the order domain. Serves as the primary key for all downstream joins and lineage tracking.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to sales.campaign. Business justification: RFQs in industrial manufacturing are frequently triggered by marketing campaigns (trade shows, product launches). Sales ops tracks which campaign sourced the RFQ to measure campaign ROI and pipeline c',
    `channel_id` BIGINT COMMENT 'Foreign key linking to order.channel. Business justification: Inbound RFQ/RFP requests arrive through specific sales channels (direct, distributor, portal, EDI). The source_channel STRING attribute is a denormalized channel identifier that is superseded by the F',
    `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: RFQ requests come from specific contacts at customer organizations. Sales teams use this to respond directly to the requesting person and maintain communication history.',
    `priority_id` BIGINT COMMENT 'Foreign key linking to order.order_priority. Business justification: RFQ requests carry a priority level for response urgency. The string priority is replaced by FK order_priority_id.',
    `product_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.product_specification. Business justification: RFQ requests in industrial manufacturing are issued against a defined product specification. Procurement and engineering jointly use this link to ensure suppliers quote against the correct technical r',
    `sales_territory_id` BIGINT COMMENT 'Foreign key linking to sales.sales_territory. Business justification: RFQs originate from a specific sales territory in manufacturing. Territory managers review and route RFQs; linking ensures correct team ownership, quota attribution, and regional reporting.',
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
    `required_delivery_date` DATE COMMENT 'The date by which the customer requires delivery of the ordered goods or systems. Used for Available-to-Promise (ATP) and Capable-to-Promise (CTP) checks and production scheduling feasibility assessment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `responded_timestamp` TIMESTAMP COMMENT 'The precise date and time at which the formal quotation or proposal response was submitted to the customer. Used to measure response cycle time and SLA adherence.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `response_due_date` DATE COMMENT 'The deadline by which the customer requires a formal quotation or proposal response. Drives prioritization of sales and engineering resources and triggers escalation workflows when approaching.. Valid values are `^d{4}-d{2}-d{2}$`',
    `rfp_indicator` BOOLEAN COMMENT 'Flag indicating whether the inbound request is a formal Request for Proposal (RFP) requiring a detailed technical and commercial proposal, as opposed to a standard Request for Quotation (RFQ) focused on pricing. True = RFP; False = RFQ.. Valid values are `true|false`',
    `rfq_number` STRING COMMENT 'Business-facing alphanumeric identifier assigned to the inbound RFQ or RFP document, used for cross-system reference and customer communication. Corresponds to the customer-provided document number or internally assigned tracking number.. Valid values are `^RFQ-[0-9]{4}-[0-9]{6}$`',
    `sales_organization` STRING COMMENT 'The SAP sales organization code representing the legal entity or business unit responsible for the sale. Determines pricing procedures, output determination, and revenue booking entity.',
    `status` STRING COMMENT 'Current lifecycle status of the inbound RFQ/RFP record, tracking progression from initial receipt through evaluation, response, and final disposition. Drives workflow routing and pipeline visibility.. Valid values are `received|under_review|responded|awarded|declined|cancelled|on_hold`',
    `submission_date` DATE COMMENT 'The date on which the customer or prospect formally submitted the RFQ or RFP to the company. Used to calculate response lead times and track compliance with response SLAs.. Valid values are `^d{4}-d{2}-d{2}$`',
    `technical_requirements_summary` STRING COMMENT 'Free-text summary of the customers technical specifications, performance requirements, and engineering constraints as stated in the RFQ/RFP document. Provides context for application engineering and product configuration.',
    `warranty_requirement` STRING COMMENT 'Customer-specified warranty duration, coverage scope, or warranty terms required for the products or systems being quoted. Informs commercial pricing, risk assessment, and after-sales service planning.',
    `win_probability_percent` DECIMAL(18,2) COMMENT 'Sales teams estimated probability (0-100%) of winning the RFQ/RFP and converting it to a sales order. Used for weighted pipeline reporting and revenue forecasting.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    CONSTRAINT pk_rfq_request PRIMARY KEY(`rfq_request_id`)
) COMMENT 'Inbound Request for Quotation (RFQ) or Request for Proposal (RFP) received from a customer or prospect. Captures RFQ/RFP number, customer identity, submission date, response due date, project name, application type (factory automation, building electrification, transportation infrastructure), required delivery date, technical requirements summary, quantity requirements, budget indication, evaluation criteria, RFQ status (received, under review, responded, awarded, declined), and assigned sales/application engineer. SSOT for inbound customer RFQ/RFP records.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`schedule_line` (
    `schedule_line_id` BIGINT COMMENT 'Unique surrogate identifier for each delivery schedule line record in the lakehouse Silver layer. Serves as the primary key for the order_schedule_line entity.',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: Schedule lines are associated with a specific order line item. The string order_line_number is replaced by FK order_line_item_id.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to product.product_plant. Business justification: Schedule lines define delivery dates and quantities from a specific plant. Production planning and logistics use this to align delivery schedules with plant-level inventory and production capacity for',
    `stock_position_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_position. Business justification: Schedule lines represent confirmed delivery quantities and dates tied to available stock. Order scheduling teams reference stock positions to confirm partial delivery quantities across multiple schedu',
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
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.line_item. Business justification: The status_history product is described as the chronological audit trail of all status transitions for a sales order throughout its lifecycle. The primary entity being tracked is the sales order line ',
    `reversal_reference_status_history_id` BIGINT COMMENT 'Reference to the order_status_history_id of the original status transition that this record reverses. Enables bidirectional traceability between a reversal event and the original transition it corrects. NULL when is_reversal is FALSE.',
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
    `ar_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ar_invoice. Business justification: Order confirmations in manufacturing trigger AR invoice creation. Finance links confirmations to invoices to validate that every confirmed order is billed and to support order-to-cash process audits.',
    `blanket_order_id` BIGINT COMMENT 'Foreign key linking to order.blanket_order. Business justification: Order confirmations may reference the blanket order under which the sales order was placed. The string contract_number is replaced by FK blanket_order_id.',
    `credit_check_id` BIGINT COMMENT 'Foreign key linking to order.credit_check. Business justification: Order confirmations include a credit status that reflects the outcome of the credit check performed before order validation. The credit_status STRING attribute is a denormalized snapshot of the credit',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.line_item. Business justification: An order confirmation is the formal acknowledgment document issued after a sales order line item is validated. The order_confirmation must reference the specific line_item it confirms to support order',
    `quotation_id` BIGINT COMMENT 'Foreign key linking to order.quotation. Business justification: An order confirmation may reference the originating quotation. The string quotation_number is replaced by FK quotation_id.',
    `atp_ctp_check_status` STRING COMMENT 'Result of the Available to Promise (ATP) or Capable to Promise (CTP) availability check performed in SAP S/4HANA prior to issuing the confirmation. Indicates whether confirmed delivery dates are backed by ATP stock availability or CTP production capacity.. Valid values are `atp_confirmed|ctp_confirmed|partial|not_checked|failed`',
    `confirmed_delivery_date` DATE COMMENT 'Committed delivery date communicated to the customer in the confirmation, representing the manufacturers contractual delivery commitment at the header level. Derived from ATP/CTP check results.. Valid values are `^d{4}-d{2}-d{2}$`',
    `confirmed_gross_value` DECIMAL(18,2) COMMENT 'Total confirmed gross value of the order including all taxes and surcharges. Represents the total financial obligation communicated to the customer in the confirmation.. Valid values are `^d+(.d{1,2})?$`',
    `confirmed_net_value` DECIMAL(18,2) COMMENT 'Total confirmed net value of the order as stated in the confirmation document, excluding taxes. Represents the contractual financial commitment. Expressed in the document currency.. Valid values are `^d+(.d{1,2})?$`',
    `confirmed_quantity` DECIMAL(18,2) COMMENT 'Total quantity confirmed by the manufacturer at the header level across all line items. Expressed in the base unit of measure of the order. May differ from ordered quantity if partial confirmation applies.. Valid values are `^d+(.d{1,4})?$`',
    `confirmed_tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount applicable to the confirmed order value, as calculated at the time of confirmation. Includes VAT, GST, or applicable sales tax based on ship-to jurisdiction.. Valid values are `^d+(.d{1,2})?$`',
    `country_of_destination` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the final delivery destination for the confirmed order. Used for export control classification, customs documentation, VAT/GST determination, and REACH/RoHS compliance assessment.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp at which the order confirmation record was first created in the system. Used for audit trail, data lineage, and order-to-cash cycle time analytics.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
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
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: ATP commitments represent confirmed supply promises tied to fiscal periods for demand planning and financial commitment reporting. Finance uses this to track open delivery obligations within each acco',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: ATP commitments are made at the order line item level. The string sales_order_item is replaced by FK order_line_item_id.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to product.product_plant. Business justification: ATP (Available-to-Promise) commitments are evaluated per product-plant combination. Supply chain and order fulfillment teams use this to confirm stock availability at the specific plant fulfilling the',
    `product_variant_id` BIGINT COMMENT 'Foreign key linking to engineering.product_variant. Business justification: Available-to-promise commitments are made at the product variant level. Production planning checks variant-specific BOM and routing to confirm material availability and capacity before committing a de',
    `schedule_line_id` BIGINT COMMENT 'Foreign key linking to order.order_schedule_line. Business justification: ATP commitments are linked to specific schedule lines for delivery confirmation. The string schedule_line_number is replaced by FK order_schedule_line_id.',
    `stock_position_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_position. Business justification: ATP (Available-to-Promise) commitments are calculated directly against current stock positions. Order management checks and reserves stock positions when confirming delivery dates to customers.',
    `usage_decision_id` BIGINT COMMENT 'Foreign key linking to quality.usage_decision. Business justification: ATP (Available-to-Promise) commitments in manufacturing are only valid after quality usage decisions release stock. The ATP engine must reference the usage decision to confirm unrestricted stock avail',
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
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: Product configuration options are captured at the order line item level. The string sales_order_line_item_number is replaced by FK order_line_item_id.',
    `product_configuration_id` BIGINT COMMENT 'Foreign key linking to product.product_configuration. Business justification: Order configurations are directly tied to product configurations selected by the customer. Manufacturing and order management use this to drive production BOMs and ensure the ordered configuration is ',
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
    `currency_exchange_rate_id` BIGINT COMMENT 'Foreign key linking to finance.currency_exchange_rate. Business justification: Pricing conditions in cross-border manufacturing orders must reference the exchange rate used at time of pricing. Finance uses this to ensure consistent FX conversion across order valuation and invoic',
    `discount_structure_id` BIGINT COMMENT 'Foreign key linking to sales.discount_structure. Business justification: Pricing conditions apply discount structures (volume, promotional, customer-specific) to order lines. Order management calculates final prices using defined discount rules and thresholds.',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: Pricing conditions are applied at the line item level. The polymorphic string document_item_number is replaced by nullable FK order_line_item_id.',
    `price_list_item_id` BIGINT COMMENT 'Foreign key linking to product.price_list_item. Business justification: Pricing conditions on orders are derived from product price list items. Pricing and sales teams use this link to apply correct list prices, discounts, and surcharges from the product catalog to order ',
    `quotation_id` BIGINT COMMENT 'Foreign key linking to order.quotation. Business justification: Pricing conditions are also applied to quotations. A nullable FK quotation_id is added (null when condition applies to a sales order). document_number already removed via sales_order_id link.',
    `quotation_line_item_id` BIGINT COMMENT 'Foreign key linking to order.quotation_line_item. Business justification: Pricing conditions apply to both sales order line items (already linked via line_item_id) and quotation line items. In industrial manufacturing, detailed pricing conditions (surcharges, discounts, fre',
    `sales_price_list_id` BIGINT COMMENT 'Foreign key linking to sales.sales_price_list. Business justification: Pricing conditions (surcharges, freight, special terms) are anchored to a sales price list in manufacturing ERP. Pricing analysts use this to trace which base list a condition modifies during order pr',
    `service_contract_id` BIGINT COMMENT 'Foreign key linking to asset.service_contract. Business justification: Pricing conditions for spare parts and service orders in manufacturing are often governed by service contracts that define negotiated rates and discounts. Pricing teams link conditions directly to the',
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

CREATE OR REPLACE TABLE `manufacturing_ecm`.`order`.`blanket_order` (
    `blanket_order_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for the blanket order record in the Databricks Silver Layer. Serves as the primary key for all downstream joins and references.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to order.channel. Business justification: Blanket/framework orders are established through specific sales channels that govern commission eligibility, payment terms, and order entry methods. The distribution_channel STRING attribute is a deno',
    `discount_structure_id` BIGINT COMMENT 'Foreign key linking to sales.discount_structure. Business justification: Blanket orders negotiate volume-based discount structures upfront. Sales and procurement teams use this link to apply the correct discount automatically to each release order drawn against the blanket',
    `profitability_segment_id` BIGINT COMMENT 'Foreign key linking to finance.profitability_segment. Business justification: Blanket orders in manufacturing represent long-term customer commitments tracked against profitability segments for margin analysis. Controlling teams use this link to report contribution margins by s',
    `rfq_request_id` BIGINT COMMENT 'Foreign key linking to order.rfq_request. Business justification: In industrial manufacturing, long-term blanket/framework orders frequently originate from formal RFP/RFQ processes. Linking blanket_order to the originating rfq_request provides end-to-end traceabilit',
    `sales_org_id` BIGINT COMMENT 'Foreign key linking to product.sales_org. Business justification: Blanket orders are created within a specific sales organization context. Sales operations use this to enforce correct pricing, currency, and product availability rules applicable to the sales org mana',
    `sales_price_list_id` BIGINT COMMENT 'Foreign key linking to sales.sales_price_list. Business justification: Blanket orders in manufacturing lock pricing for a period against a specific price list. Contract managers reference this link to enforce agreed pricing across all call-off orders under the blanket.',
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
    `bop_id` BIGINT COMMENT 'Foreign key linking to engineering.bop. Business justification: Fulfillment plans in manufacturing are executed against a Bill of Process. Production scheduling uses the BOP to sequence operations, assign work centers, and estimate lead times when building the ful',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: Fulfillment plans are aligned to fiscal periods for revenue forecasting and delivery scheduling. Finance uses this link to project revenue recognition timing and match planned deliveries to accounting',
    `forecast_id` BIGINT COMMENT 'Foreign key linking to sales.forecast. Business justification: Fulfillment plans in manufacturing are built against sales forecasts to pre-position inventory and capacity. Supply chain planners use this link to reconcile actual orders against forecast and adjust ',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: Fulfillment plans in manufacturing must reference the associated inspection lot to confirm goods have passed quality checks before scheduling shipment. Planners use this link to gate delivery executio',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: Fulfillment plans can be created at the line item level. The string line_item_number is replaced by FK order_line_item_id.',
    `maintenance_plan_id` BIGINT COMMENT 'Foreign key linking to asset.maintenance_plan. Business justification: Scheduled spare parts and consumable replenishment orders in manufacturing are driven by maintenance plans. The fulfillment plan references the maintenance plan to align delivery timing with planned m',
    `order_confirmation_id` BIGINT COMMENT 'Foreign key linking to order.order_confirmation. Business justification: A fulfillment plan is created after an order is confirmed. Linking fulfillment_plan to order_confirmation establishes the commercial-to-operational handoff traceability — the confirmed order terms (de',
    `plant_id` BIGINT COMMENT 'Foreign key linking to product.product_plant. Business justification: Fulfillment plans are executed from a specific product-plant location. Logistics and production planning teams use this to route orders to the correct manufacturing or warehouse plant for shipment.',
    `priority_id` BIGINT COMMENT 'Foreign key linking to order.order_priority. Business justification: Fulfillment plans use priority to sequence production and warehouse operations. The string priority is replaced by FK order_priority_id.',
    `schedule_line_id` BIGINT COMMENT 'Foreign key linking to order.schedule_line. Business justification: A fulfillment execution plan is directly tied to specific ATP/CTP-confirmed delivery schedule lines. The schedule_line defines the confirmed delivery date and quantity that the fulfillment plan must e',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Fulfillment plans specify which storage location will supply the order. Supply chain planners assign source locations during fulfillment planning to optimize pick routing and stock allocation across w',
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
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: Goods issue postings in manufacturing must be assigned to a fiscal period for inventory and COGS accounting. Finance closes periods and uses this link to ensure goods movements post to the correct per',
    `fulfillment_plan_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_plan. Business justification: A goods issue event is the physical execution of a fulfillment plan — it records the actual departure of goods from the manufacturing facility. Linking goods_issue to fulfillment_plan enables on-time ',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: Goods issue requires released inspection lot status. Warehouse system checks inspection lot approval before allowing goods movement to ensure only quality-approved material ships.',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.order_line_item. Business justification: Goods issues are recorded at the order line item level for quantity tracking. The string sales_order_item_number is replaced by FK order_line_item_id.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to product.product_plant. Business justification: Goods issues are posted against a specific product-plant record to reduce inventory. Warehouse and logistics teams use this daily to record physical outbound movements tied to the correct plant and pr',
    `product_variant_id` BIGINT COMMENT 'Foreign key linking to engineering.product_variant. Business justification: Goods issue documents record the physical shipment of a specific product variant. Warehouse and logistics teams reference the engineering variant to confirm correct part number, packaging spec, and ex',
    `schedule_line_id` BIGINT COMMENT 'Foreign key linking to order.schedule_line. Business justification: A goods issue fulfills a specific delivery schedule line commitment. Linking goods_issue to schedule_line enables direct reconciliation of confirmed delivery quantities against actual issued quantitie',
    `stock_position_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_position. Business justification: Goods issue execution directly reduces a stock position. Warehouse and logistics teams link each goods issue document to the exact stock position being decremented, ensuring real-time inventory accura',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: A goods issue must record the physical storage location from which stock is being issued. This is a core warehouse management operation used every time inventory leaves a facility for an outbound orde',
    `transaction_id` BIGINT COMMENT 'Foreign key linking to inventory.transaction. Business justification: Every goods issue generates or references an inventory transaction for stock movement accounting. Finance and inventory control teams use this link to reconcile order-driven stock movements against in',
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
    `sales_territory_id` BIGINT COMMENT 'Foreign key linking to sales.sales_territory. Business justification: Sales channels (direct, distributor, OEM) operate within defined territories in industrial manufacturing. Channel managers use this link to enforce territory rules, prevent channel conflict, and repor',
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
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: Credit checks in manufacturing are scoped to a controlling area which defines the credit exposure boundary. Finance controlling teams configure and monitor credit limits per controlling area.',
    `credit_profile_id` BIGINT COMMENT 'Foreign key linking to customer.credit_profile. Business justification: Credit checks evaluate customer credit profiles to determine order approval limits. Finance teams use this to assess risk and set credit holds on orders.',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.line_item. Business justification: Credit checks are triggered by sales order line items during order entry. Linking credit_check to line_item enables direct traceability between the credit evaluation and the specific order that trigge',
    `sales_territory_id` BIGINT COMMENT 'Foreign key linking to sales.sales_territory. Business justification: Credit checks in manufacturing are often managed regionally with territory-specific credit limits and risk profiles. Finance and sales ops use this link to apply the correct regional credit policy dur',
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

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ADD CONSTRAINT `fk_order_quotation_blanket_order_id` FOREIGN KEY (`blanket_order_id`) REFERENCES `manufacturing_ecm`.`order`.`blanket_order`(`blanket_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ADD CONSTRAINT `fk_order_quotation_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `manufacturing_ecm`.`order`.`channel`(`channel_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ADD CONSTRAINT `fk_order_quotation_rfq_request_id` FOREIGN KEY (`rfq_request_id`) REFERENCES `manufacturing_ecm`.`order`.`rfq_request`(`rfq_request_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ADD CONSTRAINT `fk_order_quotation_line_item_quotation_id` FOREIGN KEY (`quotation_id`) REFERENCES `manufacturing_ecm`.`order`.`quotation`(`quotation_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ADD CONSTRAINT `fk_order_rfq_request_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `manufacturing_ecm`.`order`.`channel`(`channel_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ADD CONSTRAINT `fk_order_rfq_request_priority_id` FOREIGN KEY (`priority_id`) REFERENCES `manufacturing_ecm`.`order`.`priority`(`priority_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ADD CONSTRAINT `fk_order_status_history_reversal_reference_status_history_id` FOREIGN KEY (`reversal_reference_status_history_id`) REFERENCES `manufacturing_ecm`.`order`.`status_history`(`status_history_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ADD CONSTRAINT `fk_order_order_confirmation_blanket_order_id` FOREIGN KEY (`blanket_order_id`) REFERENCES `manufacturing_ecm`.`order`.`blanket_order`(`blanket_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ADD CONSTRAINT `fk_order_order_confirmation_credit_check_id` FOREIGN KEY (`credit_check_id`) REFERENCES `manufacturing_ecm`.`order`.`credit_check`(`credit_check_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ADD CONSTRAINT `fk_order_order_confirmation_quotation_id` FOREIGN KEY (`quotation_id`) REFERENCES `manufacturing_ecm`.`order`.`quotation`(`quotation_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ADD CONSTRAINT `fk_order_atp_commitment_schedule_line_id` FOREIGN KEY (`schedule_line_id`) REFERENCES `manufacturing_ecm`.`order`.`schedule_line`(`schedule_line_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ADD CONSTRAINT `fk_order_pricing_condition_quotation_id` FOREIGN KEY (`quotation_id`) REFERENCES `manufacturing_ecm`.`order`.`quotation`(`quotation_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ADD CONSTRAINT `fk_order_pricing_condition_quotation_line_item_id` FOREIGN KEY (`quotation_line_item_id`) REFERENCES `manufacturing_ecm`.`order`.`quotation_line_item`(`quotation_line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ADD CONSTRAINT `fk_order_blanket_order_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `manufacturing_ecm`.`order`.`channel`(`channel_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ADD CONSTRAINT `fk_order_blanket_order_rfq_request_id` FOREIGN KEY (`rfq_request_id`) REFERENCES `manufacturing_ecm`.`order`.`rfq_request`(`rfq_request_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_order_confirmation_id` FOREIGN KEY (`order_confirmation_id`) REFERENCES `manufacturing_ecm`.`order`.`order_confirmation`(`order_confirmation_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_priority_id` FOREIGN KEY (`priority_id`) REFERENCES `manufacturing_ecm`.`order`.`priority`(`priority_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_schedule_line_id` FOREIGN KEY (`schedule_line_id`) REFERENCES `manufacturing_ecm`.`order`.`schedule_line`(`schedule_line_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_fulfillment_plan_id` FOREIGN KEY (`fulfillment_plan_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_plan`(`fulfillment_plan_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_schedule_line_id` FOREIGN KEY (`schedule_line_id`) REFERENCES `manufacturing_ecm`.`order`.`schedule_line`(`schedule_line_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`order` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `manufacturing_ecm`.`order` SET TAGS ('dbx_domain' = 'order');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` SET TAGS ('dbx_subdomain' = 'quotation_management');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` SET TAGS ('dbx_original_name' = 'order_quotation');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `quotation_id` SET TAGS ('dbx_business_glossary_term' = 'Quotation ID');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `blanket_order_id` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `currency_exchange_rate_id` SET TAGS ('dbx_business_glossary_term' = 'Currency Exchange Rate Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `discount_structure_id` SET TAGS ('dbx_business_glossary_term' = 'Discount Structure Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `pricing_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Pricing Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `rfq_request_id` SET TAGS ('dbx_business_glossary_term' = 'Rfq Request Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `sales_org_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Org Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `sales_price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `service_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `tax_code_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `accepted_rejected_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Quotation Accepted / Rejected Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `competitor_name` SET TAGS ('dbx_business_glossary_term' = 'Competitor Name');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `competitor_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `confirmed_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `confirmed_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `converted_order_number` SET TAGS ('dbx_business_glossary_term' = 'Converted Sales Order Number');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Quotation Currency Code');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Number');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `customer_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Name');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `customer_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `delivery_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Delivery Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `delivery_lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Quotation Discount Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `gross_value` SET TAGS ('dbx_business_glossary_term' = 'Quotation Gross Value');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `gross_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Named Place / Location');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Quotation Issue Date');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `net_value` SET TAGS ('dbx_business_glossary_term' = 'Quotation Net Value');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `net_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Quotation Number');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^QT-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `opportunity_reference` SET TAGS ('dbx_business_glossary_term' = 'CRM Opportunity Reference');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `probability_percent` SET TAGS ('dbx_business_glossary_term' = 'Win Probability Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `probability_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `sales_office` SET TAGS ('dbx_business_glossary_term' = 'Sales Office');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `sales_representative` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `shipping_country_code` SET TAGS ('dbx_business_glossary_term' = 'Shipping Destination Country Code');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `shipping_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Quotation Status');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|accepted|rejected|expired|cancelled|converted');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Quotation Submission Timestamp');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Quotation Tax Amount');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Quotation Type');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'standard|framework|blanket|project|spot');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Quotation Validity End Date');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Quotation Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Quotation Version Number');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `win_loss_notes` SET TAGS ('dbx_business_glossary_term' = 'Win / Loss Notes');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `win_loss_reason` SET TAGS ('dbx_business_glossary_term' = 'Win / Loss Reason');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ALTER COLUMN `win_loss_reason` SET TAGS ('dbx_value_regex' = 'price_competitive|price_too_high|lead_time|technical_fit|competitor_selected|customer_cancelled|budget_constraint|relationship|specification_mismatch|other');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` SET TAGS ('dbx_subdomain' = 'quotation_management');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `quotation_line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Quotation Line Item ID');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `discount_structure_id` SET TAGS ('dbx_business_glossary_term' = 'Discount Structure Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `product_configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Product Configuration Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `quotation_id` SET TAGS ('dbx_business_glossary_term' = 'Quotation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Uom Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Validity End Date');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` SET TAGS ('dbx_subdomain' = 'quotation_management');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `rfq_request_id` SET TAGS ('dbx_business_glossary_term' = 'Request for Quotation (RFQ) Request ID');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `priority_id` SET TAGS ('dbx_business_glossary_term' = 'Order Priority Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `product_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Specification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `sales_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Territory Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'RFQ Status');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'received|under_review|responded|awarded|declined|cancelled|on_hold');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'RFQ Submission Date');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `submission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `technical_requirements_summary` SET TAGS ('dbx_business_glossary_term' = 'Technical Requirements Summary');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `warranty_requirement` SET TAGS ('dbx_business_glossary_term' = 'Warranty Requirement');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `win_probability_percent` SET TAGS ('dbx_business_glossary_term' = 'Win Probability Percentage');
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ALTER COLUMN `win_probability_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` SET TAGS ('dbx_subdomain' = 'order_reference');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `schedule_line_id` SET TAGS ('dbx_business_glossary_term' = 'Order Schedule Line ID');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ALTER COLUMN `stock_position_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Position Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` SET TAGS ('dbx_subdomain' = 'order_reference');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `status_history_id` SET TAGS ('dbx_business_glossary_term' = 'Order Status History ID');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ALTER COLUMN `reversal_reference_status_history_id` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reference History ID');
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
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` SET TAGS ('dbx_subdomain' = 'order_reference');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` SET TAGS ('dbx_original_name' = 'order_confirmation');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `order_confirmation_id` SET TAGS ('dbx_business_glossary_term' = 'Order Confirmation ID');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `ar_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ar Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `blanket_order_id` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `credit_check_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ALTER COLUMN `quotation_id` SET TAGS ('dbx_business_glossary_term' = 'Quotation Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` SET TAGS ('dbx_subdomain' = 'order_reference');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `atp_commitment_id` SET TAGS ('dbx_business_glossary_term' = 'Available-to-Promise (ATP) Commitment ID');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `product_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Variant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `schedule_line_id` SET TAGS ('dbx_business_glossary_term' = 'Order Schedule Line Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `stock_position_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Position Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ALTER COLUMN `usage_decision_id` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` SET TAGS ('dbx_subdomain' = 'order_reference');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` SET TAGS ('dbx_original_name' = 'order_configuration');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `order_configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Order Configuration ID');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ALTER COLUMN `product_configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Product Configuration Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `currency_exchange_rate_id` SET TAGS ('dbx_business_glossary_term' = 'Currency Exchange Rate Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `discount_structure_id` SET TAGS ('dbx_business_glossary_term' = 'Discount Structure Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `price_list_item_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `quotation_id` SET TAGS ('dbx_business_glossary_term' = 'Quotation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `quotation_line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Quotation Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `sales_price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Price List Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ALTER COLUMN `service_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` SET TAGS ('dbx_subdomain' = 'quotation_management');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `blanket_order_id` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order ID');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `discount_structure_id` SET TAGS ('dbx_business_glossary_term' = 'Discount Structure Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `profitability_segment_id` SET TAGS ('dbx_business_glossary_term' = 'Profitability Segment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `rfq_request_id` SET TAGS ('dbx_business_glossary_term' = 'Rfq Request Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `sales_org_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Org Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ALTER COLUMN `sales_price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Price List Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` SET TAGS ('dbx_subdomain' = 'order_reference');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `fulfillment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Order Fulfillment Plan ID');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `bop_id` SET TAGS ('dbx_business_glossary_term' = 'Bop Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Forecast Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `maintenance_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `order_confirmation_id` SET TAGS ('dbx_business_glossary_term' = 'Order Confirmation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `priority_id` SET TAGS ('dbx_business_glossary_term' = 'Order Priority Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `schedule_line_id` SET TAGS ('dbx_business_glossary_term' = 'Schedule Line Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` SET TAGS ('dbx_subdomain' = 'order_reference');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `goods_issue_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue ID');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `fulfillment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `product_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Variant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `schedule_line_id` SET TAGS ('dbx_business_glossary_term' = 'Schedule Line Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `stock_position_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Position Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ALTER COLUMN `transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Transaction Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`order`.`channel` SET TAGS ('dbx_subdomain' = 'order_reference');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Order Channel ID');
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ALTER COLUMN `sales_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Territory Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`order`.`priority` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`order`.`priority` SET TAGS ('dbx_subdomain' = 'order_reference');
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
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` SET TAGS ('dbx_subdomain' = 'order_reference');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `credit_check_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Check ID');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `ar_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ar Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `credit_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Profile Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ALTER COLUMN `sales_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Territory Id (Foreign Key)');
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
