-- Schema for Domain: sales | Business: Automotive | Version: v2_mvm
-- Generated on: 2026-07-14 04:30:42

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`sales` COMMENT 'Sales operations including lead management, opportunity tracking, quote generation, order capture, and sales performance analytics. Manages MSRP (Manufacturer Suggested Retail Price), incentive programs, fleet sales, and commercial vehicle contracts. Tracks sales pipeline, conversion rates, and regional sales performance. Integrates with dealer networks and Salesforce Automotive Cloud for unified sales execution across direct and indirect channels. Interfaces with SAP SD.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`opportunity` (
    `opportunity_id` BIGINT COMMENT 'Unique identifier for the sales opportunity record. Primary key.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership managing this opportunity.',
    `incentive_program_id` BIGINT COMMENT 'Foreign key linking to sales.sales_incentive_program. Business justification: An opportunity is often driven by or associated with a specific OEM incentive program (cash rebate, dealer cash, special APR). Adding sales_incentive_program_id normalizes the incentive reference and ',
    `party_id` BIGINT COMMENT 'Reference to the prospect or customer associated with this opportunity.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Opportunity tracking by model enables sales forecasting, market analysis, and model performance dashboards.',
    `opportunity_party_id` BIGINT COMMENT 'Reference to the prospect or customer associated with this opportunity.',
    `opportunity_vehicle_model_id` BIGINT COMMENT 'Reference to the specific vehicle configuration or model of interest for this opportunity.',
    `territory_id` BIGINT COMMENT 'Foreign key linking to dealer.dealer_territory. Business justification: Opportunities are assigned to dealer sales territories for quota tracking, lead routing, and territory-based sales performance reporting. opportunity.territory is a denormalized text field that should',
    `actual_close_date` DATE COMMENT 'Actual date when the opportunity was closed (won or lost).',
    `competitor_brand` STRING COMMENT 'Competitor brand or OEM that the customer is also considering, if known.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the opportunity record was first created in the system.',
    `delivery_location` STRING COMMENT 'Preferred delivery location or dealership for vehicle handover.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total discount amount applied to the opportunity, including dealer discounts and manufacturer incentives.',
    `estimated_value` DECIMAL(18,2) COMMENT 'Estimated total deal value including vehicle price, options, accessories, and services.',
    `expected_close_date` DATE COMMENT 'Anticipated date when the opportunity is expected to close (either won or lost).',
    `exterior_color` STRING COMMENT 'Preferred exterior color for the vehicle.',
    `financing_type` STRING COMMENT 'Type of financing or payment method the customer intends to use.. Valid values are `cash|finance|lease|balloon|fleet_contract`',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the opportunity is expected to close, used for sales forecasting and quota tracking.. Valid values are `^FY[0-9]{4}$`',
    `fleet_size` STRING COMMENT 'Number of vehicles in the fleet opportunity, applicable for fleet and commercial sales.',
    `interior_color` STRING COMMENT 'Preferred interior color or trim for the vehicle.',
    `is_active` BOOLEAN COMMENT 'Indicates whether the opportunity is currently active (open) or closed.',
    `is_won` BOOLEAN COMMENT 'Indicates whether the opportunity was closed as won (successful sale).',
    `last_activity_date` DATE COMMENT 'Date of the most recent sales activity or interaction related to this opportunity.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the opportunity record was last modified.',
    `lead_source` STRING COMMENT 'Original channel or source through which the opportunity was generated. [ENUM-REF-CANDIDATE: web|phone|email|walk_in|referral|event|advertising|social_media|partner — 9 candidates stripped; promote to reference product]',
    `loss_reason` STRING COMMENT 'Primary reason why the opportunity was lost, if applicable. [ENUM-REF-CANDIDATE: price|product_fit|competitor|timing|financing|no_response|other — 7 candidates stripped; promote to reference product]',
    `model_year` STRING COMMENT 'Model year of the vehicle of interest in this opportunity.. Valid values are `^MY[0-9]{4}$`',
    `msrp` DECIMAL(18,2) COMMENT 'Manufacturer Suggested Retail Price for the vehicle configuration of interest.',
    `opportunity_name` STRING COMMENT 'Descriptive name of the opportunity, typically including prospect name and vehicle of interest.',
    `next_follow_up_date` DATE COMMENT 'Scheduled date for the next follow-up activity with the prospect.',
    `notes` STRING COMMENT 'Free-text notes and comments about the opportunity, customer preferences, and sales interactions.',
    `opportunity_number` STRING COMMENT 'Business-facing unique identifier for the opportunity, typically auto-generated and used in communications with dealers and sales teams.. Valid values are `^OPP-[0-9]{8}$`',
    `opportunity_type` STRING COMMENT 'Classification of the opportunity based on customer segment and purchase type.. Valid values are `retail|fleet|commercial|government|employee_purchase|demo`',
    `powertrain_type` STRING COMMENT 'Type of powertrain for the vehicle of interest: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), FCEV (Fuel Cell Electric Vehicle).. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `priority` STRING COMMENT 'Priority level assigned to this opportunity based on strategic importance, deal size, or customer value.. Valid values are `low|medium|high|critical`',
    `probability` DECIMAL(18,2) COMMENT 'Estimated probability of closing this opportunity successfully, expressed as a percentage (0-100).',
    `quote_date` DATE COMMENT 'Date when the quote was generated, if applicable.',
    `quote_generated` BOOLEAN COMMENT 'Indicates whether a formal quote has been generated for this opportunity.',
    `region` STRING COMMENT 'Geographic sales region where this opportunity is being managed.',
    `sales_stage` STRING COMMENT 'Current stage of the opportunity in the sales pipeline, reflecting progression from initial contact through close. [ENUM-REF-CANDIDATE: lead|qualification|needs_analysis|test_drive|quote|negotiation|closed_won|closed_lost — 8 candidates stripped; promote to reference product]',
    `test_drive_completed` BOOLEAN COMMENT 'Indicates whether the prospect has completed a test drive for the vehicle of interest.',
    `test_drive_date` DATE COMMENT 'Date when the test drive was completed, if applicable.',
    `trade_in_value` DECIMAL(18,2) COMMENT 'Appraised value of the customers trade-in vehicle, if applicable.',
    `win_reason` STRING COMMENT 'Primary reason why the opportunity was won, if applicable. [ENUM-REF-CANDIDATE: price|product_features|brand_loyalty|service|financing|relationship|other — 7 candidates stripped; promote to reference product]',
    CONSTRAINT pk_opportunity PRIMARY KEY(`opportunity_id`)
) COMMENT 'Core sales opportunity record tracking a potential vehicle sale from initial identification through close. Captures prospect vehicle interest, estimated deal value, probability of close, sales stage, assigned sales representative, source channel, and expected close date. Aligns with Salesforce Automotive Cloud Opportunity object and SAP SD pre-sales pipeline. Covers retail, fleet, and commercial vehicle opportunities.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`quote` (
    `quote_id` BIGINT COMMENT 'Primary key for quote',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_configuration. Business justification: Quote must be tied to a specific vehicle configuration to calculate options, OTA updates, and compliance; supports configuration‑based pricing.',
    `incentive_program_id` BIGINT COMMENT 'Foreign key linking to sales.sales_incentive_program. Business justification: A quote is typically structured around a specific OEM incentive program (customer cash, special financing rate, lease support). While quote_line already references sales_incentive_program for line-lev',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Required for Quote generation to reference the exact vehicle model, ensuring pricing consistency and enabling model‑level reporting.',
    `opportunity_id` BIGINT COMMENT 'Reference to the sales opportunity or lead that generated this quote. Tracks quote back to pipeline stage in Salesforce Automotive Cloud.',
    `party_id` BIGINT COMMENT 'Reference to the customer or prospect receiving this quote. Links to customer master data in SAP or Salesforce Automotive Cloud.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership or direct sales channel issuing the quote. Links to dealer master data in CDK Global DMS or SAP.',
    `quote_dealership_id` BIGINT COMMENT 'Reference to the dealership or direct sales channel issuing the quote. Links to dealer master data in CDK Global DMS or SAP.',
    `quote_party_id` BIGINT COMMENT 'Reference to the customer or prospect receiving this quote. Links to customer master data in SAP or Salesforce Automotive Cloud.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle configuration being quoted. Links to vehicle master data including model, trim, powertrain, and options.',
    `quote_vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle configuration being quoted. Links to vehicle master data including model, trim, powertrain, and options.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Quotes can include optional connectivity/ADAS services; linking the quoted service enables accurate pricing, compliance, and downstream provisioning.',
    `trade_in_id` BIGINT COMMENT 'Foreign key linking to sales.trade_in. Business justification: A vehicle sales quote frequently incorporates a trade-in vehicle evaluation, with trade_in_allowance and trade_in_payoff captured on the quote. Adding trade_in_id normalizes the trade-in reference, re',
    `vehicle_order_id` BIGINT COMMENT 'Reference to the sales order created from this quote if converted_to_order is true. Links quote to order for fulfillment tracking.',
    `accessories_total` DECIMAL(18,2) COMMENT 'Total value of dealer-installed accessories (e.g., floor mats, cargo organizers, protection packages). Separate from factory options.',
    `apr_rate` DECIMAL(18,2) COMMENT 'Annual percentage rate for financing if offered. Expressed as decimal (e.g., 0.0399 for 3.99% APR). Subject to credit approval.',
    `conversion_date` DATE COMMENT 'Date when quote was converted to order. Used for sales cycle time analytics and conversion rate reporting.',
    `converted_to_order` BOOLEAN COMMENT 'Indicates whether this quote was successfully converted to a customer order. True when customer accepts quote and order is created in SAP SD.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this quote record was first created in the system. Audit trail for record creation.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this quote (e.g., USD, CAD, EUR, MXN).. Valid values are `^[A-Z]{3}$`',
    `delivery_method` STRING COMMENT 'Method by which customer will take delivery of vehicle. Dealer pickup is standard; home delivery, port pickup (for imports), and factory pickup (for premium brands) are alternatives.. Valid values are `dealer_pickup|home_delivery|port_pickup|factory_pickup`',
    `destination_charge` DECIMAL(18,2) COMMENT 'Freight and delivery charge from manufacturing plant to dealer. Typically a fixed amount per vehicle set by OEM.',
    `doc_fee` DECIMAL(18,2) COMMENT 'Dealer documentation and administrative fee for processing the sale. Regulated by state law in many jurisdictions.',
    `down_payment` DECIMAL(18,2) COMMENT 'Customer down payment amount if financing is offered. Reduces amount financed and monthly payment.',
    `drivetrain` STRING COMMENT 'Drivetrain configuration: FWD (Front-Wheel Drive), RWD (Rear-Wheel Drive), AWD (All-Wheel Drive), 4WD (Four-Wheel Drive).. Valid values are `fwd|rwd|awd|4wd`',
    `engine_code` STRING COMMENT 'Internal code identifying the specific engine or electric motor configuration. Used for parts ordering and service documentation.. Valid values are `^[A-Z0-9]{4,10}$`',
    `estimated_delivery_date` DATE COMMENT 'Estimated date when vehicle will be available for customer delivery. For in-stock vehicles, typically within days; for build-to-order, may be weeks or months.',
    `expiry_date` DATE COMMENT 'Date when the quote expires and pricing/terms are no longer valid. Typically 30-90 days from quote_date depending on market and vehicle type.',
    `exterior_color_code` STRING COMMENT 'Code representing the exterior paint color selected by customer. Links to color master data and may affect pricing for premium colors.. Valid values are `^[A-Z0-9]{3,6}$`',
    `financing_offered` BOOLEAN COMMENT 'Indicates whether financing terms are included in this quote. True if quote includes loan or lease options, false for cash-only quotes.',
    `financing_term_months` STRING COMMENT 'Length of financing term in months if financing_offered is true. Common terms: 36, 48, 60, 72, 84 months.',
    `incentive_total` DECIMAL(18,2) COMMENT 'Total value of manufacturer incentives, rebates, and discounts applied to this quote (e.g., loyalty bonus, conquest incentive, EV tax credit eligibility). Reduces net selling price.',
    `interior_color_code` STRING COMMENT 'Code representing the interior upholstery and trim color selected by customer.. Valid values are `^[A-Z0-9]{3,6}$`',
    `lease_annual_mileage` STRING COMMENT 'Annual mileage allowance for lease if offered. Common values: 10000, 12000, 15000 miles per year. Excess mileage incurs per-mile charges.',
    `lease_monthly_payment` DECIMAL(18,2) COMMENT 'Estimated monthly lease payment if lease is offered. Based on capitalized cost, residual value, money factor, and term.',
    `lease_offered` BOOLEAN COMMENT 'Indicates whether lease terms are included in this quote as an alternative to purchase financing.',
    `lease_term_months` STRING COMMENT 'Length of lease term in months if lease_offered is true. Common terms: 24, 36, 39, 48 months.',
    `model_year` STRING COMMENT 'Model year of the vehicle being quoted. Critical for pricing, incentive eligibility, and inventory management.',
    `modified_by` STRING COMMENT 'User ID or name of the person who last modified this quote record. Audit trail for change tracking.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this quote record was last modified. Audit trail for record updates and revisions.',
    `monthly_payment` DECIMAL(18,2) COMMENT 'Estimated monthly payment amount if financing is offered. Calculated from amount financed, APR, and term. Subject to credit approval.',
    `msrp_base` DECIMAL(18,2) COMMENT 'Base MSRP for the vehicle model and trim before options, accessories, and destination charges. Published pricing from OEM.',
    `net_selling_price` DECIMAL(18,2) COMMENT 'Final vehicle price after all incentives and trade-in allowance. Calculated as subtotal_amount - incentive_total - trade_in_allowance + trade_in_payoff. Base for tax calculation.',
    `notes` STRING COMMENT 'Free-text notes and comments about the quote. May include special customer requests, configuration details, or sales rep observations.',
    `options_total` DECIMAL(18,2) COMMENT 'Total value of factory-installed options and packages selected by customer (e.g., ADAS, premium audio, sunroof). Sum of individual option prices.',
    `powertrain_type` STRING COMMENT 'Type of powertrain: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), FCEV (Fuel Cell Electric Vehicle). Critical for incentive eligibility and regulatory compliance.. Valid values are `ice|hev|phev|bev|fcev`',
    `quote_date` DATE COMMENT 'Date when the quote was issued to the customer or prospect. Represents the principal business event timestamp for this transaction.',
    `quote_number` STRING COMMENT 'Externally visible business identifier for the quote, typically generated by SAP SD (VA21) or Salesforce Automotive Cloud. Used for customer communication and dealer reference.. Valid values are `^[A-Z0-9]{8,20}$`',
    `quote_status` STRING COMMENT 'Current lifecycle status of the quote. Tracks progression from draft through approval to conversion or expiry. [ENUM-REF-CANDIDATE: draft|submitted|approved|rejected|expired|converted|cancelled — 7 candidates stripped; promote to reference product]',
    `quote_type` STRING COMMENT 'Classification of quote by sales channel and vehicle delivery format. Retail for individual consumers, fleet for corporate bulk orders, CKD (Completely Knocked Down) and SKD (Semi Knocked Down) for export assembly, commercial for business vehicles, demo for demonstration units. [ENUM-REF-CANDIDATE: retail|fleet|ckd|skd|commercial|demo|export — 7 candidates stripped; promote to reference product]',
    `registration_fee` DECIMAL(18,2) COMMENT 'Government registration and title fees for the vehicle. Varies by state/province and vehicle type.',
    `rejection_reason` STRING COMMENT 'Free-text reason why quote was rejected or not converted. Captured for loss analysis and sales process improvement.',
    `sales_channel` STRING COMMENT 'Channel through which quote was generated. Dealer for franchise network, direct for OEM-owned stores, online for digital sales, fleet for corporate accounts, broker for third-party intermediaries.. Valid values are `dealer|direct|online|fleet|broker`',
    `sales_region` STRING COMMENT 'Geographic sales region code where quote was issued. Used for regional pricing, incentive eligibility, and sales performance tracking.. Valid values are `^[A-Z]{2,3}$`',
    `subtotal_amount` DECIMAL(18,2) COMMENT 'Subtotal before incentives, trade-in, taxes, and fees. Calculated as msrp_base + options_total + accessories_total + destination_charge.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total sales tax calculated on net_selling_price based on customer delivery location jurisdiction. May include state, county, and local taxes.',
    `total_amount_due` DECIMAL(18,2) COMMENT 'Final total amount customer must pay. Calculated as net_selling_price + tax_amount + registration_fee + doc_fee. Used for financing calculation or cash payment.',
    `trade_in_allowance` DECIMAL(18,2) COMMENT 'Value credited to customer for trade-in vehicle. Based on used vehicle appraisal. Reduces amount due from customer.',
    `trade_in_payoff` DECIMAL(18,2) COMMENT 'Outstanding loan balance on trade-in vehicle that must be paid off. If greater than trade_in_allowance, creates negative equity rolled into new financing.',
    `transmission_type` STRING COMMENT 'Type of transmission: manual, automatic, CVT (Continuously Variable Transmission), DCT (Dual Clutch Transmission), or single-speed (for EVs).. Valid values are `manual|automatic|cvt|dct|single_speed`',
    `trim_level` STRING COMMENT 'Trim or grade level of the vehicle (e.g., Base, Sport, Luxury, Premium). Determines standard equipment and base pricing.',
    `version` STRING COMMENT 'Version number of the quote. Increments when quote is revised with updated pricing, configuration, or terms. Supports quote revision history and audit trail.',
    `vin` STRING COMMENT '17-character Vehicle Identification Number if quote is for a specific in-stock or allocated vehicle. Null for build-to-order quotes where VIN is not yet assigned.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `created_by` STRING COMMENT 'User ID or name of the person who created this quote record. Audit trail for accountability.',
    CONSTRAINT pk_quote PRIMARY KEY(`quote_id`)
) COMMENT 'Formal vehicle sales quotation issued to a prospect or customer, detailing configured vehicle, MSRP, applied incentives, trade-in allowance, financing terms, accessories, and net selling price. Tracks quote version, expiry date, quote status, and issuing dealer or direct sales channel. Supports retail, fleet, and CKD/SKD export quotes. Linked to SAP SD quotation (VA21) and Salesforce Automotive Cloud Quote.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`quote_line` (
    `quote_line_id` BIGINT COMMENT 'Unique identifier for the quote line item. Primary key.',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.configuration. Business justification: Each quote line represents a specific vehicle configuration being priced. Linking quote_line to configuration enables accurate option validation, pricing calculation, and order conversion workflows. N',
    `incentive_program_id` BIGINT COMMENT 'Reference to the manufacturer or dealer incentive program applied to this line. Links to incentive program master for eligibility rules, amounts, and expiration dates.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Quote line items need to reference the official MSRP schedule for the selected configuration; adding msrp_schedule_id eliminates redundant MSRP columns and enables consistent pricing lookup.',
    `option_package_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_option_package. Business justification: Quote line for an option package should reference the canonical package entity for accurate pricing, warranty, and regulatory compliance.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle configuration being quoted. Applicable when line_type is vehicle. Links to the vehicle master for model, trim, and base specifications.',
    `quote_id` BIGINT COMMENT 'Foreign key reference to the parent quote header. Establishes the header-detail relationship for this line item.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Quote lines are proposals for specific SKUs; adding a foreign key to inventory.sku enables pricing and configuration consistency.',
    `availability_status` STRING COMMENT 'Current availability status of the line item. Indicates whether the product is in dealer inventory, allocated from manufacturer, requires build-to-order, is backordered, or has been discontinued.. Valid values are `in_stock|allocated|build_to_order|backordered|discontinued`',
    `commission_eligible` BOOLEAN COMMENT 'Indicates whether this line item is eligible for sales representative commission. Certain line types (fees, trade-ins) may be excluded from commission calculations.',
    `commission_rate` DECIMAL(18,2) COMMENT 'Commission rate applied to this line item for sales representative compensation. Expressed as a decimal percentage. May vary by product type and sales program.',
    `cost_amount` DECIMAL(18,2) COMMENT 'Dealer cost or transfer price for this line item. Used for margin analysis and profitability reporting. Confidential business data not disclosed to customers.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this quote line was first created. Recorded in ISO 8601 format with timezone. Used for audit trail and lifecycle tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts on this line. Typically inherits from quote header but may differ for international fleet quotes.. Valid values are `^[A-Z]{3}$`',
    `delivery_date` DATE COMMENT 'Estimated or committed delivery date for this line item. Critical for customer expectations, logistics planning, and order fulfillment tracking.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total discount applied to this line item. Includes dealer discounts, promotional discounts, and volume discounts. Expressed as a positive value that reduces the line total.',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Discount expressed as a percentage of the unit price. Used for percentage-based discount calculations and reporting. Stored alongside discount_amount for transparency.',
    `extended_price` DECIMAL(18,2) COMMENT 'Line item subtotal before tax. Calculated as (unit_price * quantity) - discount_amount - incentive_amount. Represents the pre-tax line total.',
    `exterior_color_code` STRING COMMENT 'Manufacturer color code for the vehicle exterior paint. Used for vehicle configuration, pricing (premium colors), and inventory matching.',
    `incentive_amount` DECIMAL(18,2) COMMENT 'Total manufacturer or dealer incentive applied to this line item. Includes cash rebates, loyalty bonuses, conquest incentives, and special financing subsidies. Reduces the customer-facing price.',
    `incentive_description` STRING COMMENT 'Human-readable description of the incentive applied. Provides customer-facing explanation of the incentive program, eligibility criteria, and value proposition.',
    `interior_color_code` STRING COMMENT 'Manufacturer color code for the vehicle interior trim and upholstery. Used for vehicle configuration, pricing, and customer preference tracking.',
    `line_number` STRING COMMENT 'Sequential line item number within the quote. Determines the ordering and display sequence of line items.',
    `line_status` STRING COMMENT 'Current lifecycle status of the quote line. Tracks the line through draft, approval, conversion to order, or cancellation workflows.. Valid values are `draft|active|approved|rejected|cancelled|converted`',
    `line_total` DECIMAL(18,2) COMMENT 'Total amount for this line item including tax. Calculated as extended_price + tax_amount. Represents the final customer-facing line total.',
    `line_type` STRING COMMENT 'Classification of the quote line item. Distinguishes between vehicle configurations, accessories, service packages, warranties, insurance products, fees, discounts, and trade-in credits. [ENUM-REF-CANDIDATE: vehicle|accessory|service_package|warranty|insurance|fee|discount|trade_in — 8 candidates stripped; promote to reference product]',
    `list_price` DECIMAL(18,2) COMMENT 'Manufacturer Suggested Retail Price (MSRP) or standard list price for the line item before any discounts or incentives. Expressed in the quote currency.',
    `margin_amount` DECIMAL(18,2) COMMENT 'Gross margin for this line item. Calculated as extended_price - cost_amount. Used for profitability analysis and sales performance evaluation.',
    `model_year` STRING COMMENT 'Model year of the vehicle being quoted. Critical for pricing, incentive eligibility, and inventory allocation. Aligns with manufacturer production cycles.',
    `modified_by` STRING COMMENT 'User identifier of the person who last modified this quote line. Supports change tracking and audit requirements.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to this quote line. Recorded in ISO 8601 format with timezone. Used for change tracking and audit trail.',
    `notes` STRING COMMENT 'Free-text notes and comments specific to this line item. Used for special instructions, configuration details, customer requests, or internal coordination.',
    `product_code` STRING COMMENT 'Stock Keeping Unit (SKU) or product code for accessories, service packages, warranties, or other non-vehicle line items. Links to product master for pricing and availability.',
    `product_description` STRING COMMENT 'Detailed description of the line item product or service. Includes accessory names, service package details, warranty coverage terms, or fee descriptions for customer clarity.',
    `quantity` STRING COMMENT 'Number of units for this line item. Typically 1 for vehicles, but may be greater than 1 for accessories, fleet orders, or service packages.',
    `rejection_reason` STRING COMMENT 'Explanation for why this line item was rejected or removed from the quote. Captures business reasons such as unavailability, pricing issues, or customer preference changes.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total sales tax calculated for this line item. Calculated as extended_price * tax_rate. Contributes to the overall quote tax total.',
    `tax_code` STRING COMMENT 'Tax jurisdiction code determining the applicable sales tax rate for this line item. Links to tax master for rate lookup and tax calculation rules.',
    `tax_rate` DECIMAL(18,2) COMMENT 'Sales tax rate applied to this line item, expressed as a decimal (e.g., 0.0825 for 8.25%). Used for tax calculation and compliance reporting.',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the line item quantity. Common values include each (vehicles, accessories), set, pair, kit, hour (labor), month/year (subscriptions, warranties). [ENUM-REF-CANDIDATE: each|set|pair|kit|hour|month|year — 7 candidates stripped; promote to reference product]',
    `unit_price` DECIMAL(18,2) COMMENT 'Actual selling price per unit after dealer adjustments but before line-level discounts and incentives. May differ from list price due to market conditions or dealer pricing strategy.',
    `vin` STRING COMMENT '17-character Vehicle Identification Number uniquely identifying a specific vehicle unit. Populated when quoting a specific in-stock or allocated vehicle. Null for build-to-order quotes.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `created_by` STRING COMMENT 'User identifier of the sales representative or system user who created this quote line. Used for audit trail and accountability.',
    CONSTRAINT pk_quote_line PRIMARY KEY(`quote_line_id`)
) COMMENT 'Individual line item within a vehicle sales quote, representing a specific vehicle configuration, accessory, service package, or fee. Captures line type, configured model code, option packages, unit price, discount amount, incentive applied, and line-level tax. Enables multi-vehicle fleet quotes and accessory bundling. Child entity of quote.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` (
    `vehicle_order_id` BIGINT COMMENT 'Primary key for vehicle_order',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.configuration. Business justification: A vehicle order must reference a specific buildable configuration to trigger BOM explosion, production scheduling, and order fulfillment. This is a fundamental order management link. vehicle_configur',
    `contact_point_id` BIGINT COMMENT 'Reference to the specific address where the vehicle will be delivered. Links to customer or dealer address master data.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership through which the order was placed. Links to the dealer network master data.',
    `fleet_contract_id` BIGINT COMMENT 'Foreign key linking to sales.fleet_contract. Business justification: Vehicle orders placed under a fleet contract should reference that contract at the order header level, not just at the order_line level. This enables fleet contract volume tracking (committed_volume v',
    `incentive_program_id` BIGINT COMMENT 'Foreign key linking to sales.sales_incentive_program. Business justification: A confirmed vehicle order is executed under a specific OEM incentive program that determines the final incentive_amount applied. Adding sales_incentive_program_id to vehicle_order normalizes the incen',
    `opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: A confirmed vehicle order originates from a won sales opportunity. Adding opportunity_id to vehicle_order provides end-to-end sales pipeline traceability from initial opportunity through order fulfill',
    `party_id` BIGINT COMMENT 'Reference to the customer who placed the vehicle order. Links to the customer master data.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle unit ordered. For stock orders, links to existing inventory. For build-to-order, links to the vehicle configuration that will be manufactured.',
    `production_schedule_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_schedule. Business justification: Vehicle orders are allocated to production schedules (build weeks) in automotive order management. This allocation determines committed_delivery_date and drives customer communication. build_week on v',
    `actual_delivery_date` DATE COMMENT 'Actual date when the vehicle was delivered to the customer or dealer. Used for On-Time Delivery (OTD) performance measurement.',
    `cancellation_reason` STRING COMMENT 'Free-text explanation for order cancellation. Populated only when order_status is cancelled. Used for loss analysis and process improvement.',
    `committed_delivery_date` DATE COMMENT 'OEM-committed delivery date communicated to the customer. Represents the contractual delivery obligation.',
    `confirmed_date` DATE COMMENT 'Date when the order was confirmed by the OEM and accepted into the production schedule. Represents the commitment to fulfill the order.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this order record was first created in the data platform. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this order.. Valid values are `^[A-Z]{3}$`',
    `delivery_location` STRING COMMENT 'Type of location where the vehicle will be delivered. Dealer for dealership pickup, customer_address for home delivery, port for export shipments, distribution_center for fleet staging.. Valid values are `dealer|customer_address|port|distribution_center`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total discount amount applied to the MSRP. Includes dealer discounts, promotional offers, and negotiated price reductions.',
    `exterior_color_code` STRING COMMENT 'Code representing the selected exterior paint color for the ordered vehicle.. Valid values are `^[A-Z0-9]{3,10}$`',
    `financing_reference_number` STRING COMMENT 'External reference number for the financing or lease agreement associated with this vehicle order. Links to the financial institution contract.. Valid values are `^[A-Z0-9]{8,20}$`',
    `financing_type` STRING COMMENT 'Source of financing for the vehicle purchase. Captive for OEM-owned finance arm, third_party for external lenders, none for cash purchases.. Valid values are `captive|third_party|bank|credit_union|none`',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the order was placed. Used for financial reporting and sales performance tracking.. Valid values are `^FY(19|20)d{2}$`',
    `incentive_amount` DECIMAL(18,2) COMMENT 'Total manufacturer incentive amount applied to the order. Includes cash rebates, loyalty bonuses, conquest incentives, and special financing subsidies.',
    `interior_color_code` STRING COMMENT 'Code representing the selected interior trim and upholstery color for the ordered vehicle.. Valid values are `^[A-Z0-9]{3,10}$`',
    `model_year` STRING COMMENT 'Model year designation of the ordered vehicle. Represents the production year classification used for regulatory compliance and marketing.. Valid values are `^(19|20)d{2}$`',
    `msrp` DECIMAL(18,2) COMMENT 'Manufacturer Suggested Retail Price for the configured vehicle before any discounts, incentives, or dealer adjustments.',
    `order_date` DATE COMMENT 'Date when the customer placed the vehicle order. Represents the business event timestamp for order capture.',
    `order_number` STRING COMMENT 'Externally-visible unique order number assigned to the vehicle purchase order. Used for customer communication and dealer reference.. Valid values are `^[A-Z0-9]{10,20}$`',
    `order_status` STRING COMMENT 'Current lifecycle status of the vehicle order. Tracks progression from initial placement through manufacturing, shipment, and final delivery to customer. [ENUM-REF-CANDIDATE: draft|placed|confirmed|scheduled|in_production|built|shipped|delivered|cancelled — 9 candidates stripped; promote to reference product]',
    `order_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the vehicle order was captured in the system. Used for order sequencing and audit trail.',
    `order_type` STRING COMMENT 'Classification of the vehicle order by customer segment and sales channel. Retail for individual consumers, fleet for commercial bulk purchases, government for public sector contracts, export for international sales, demo for dealer demonstration vehicles, internal for company use.. Valid values are `retail|fleet|government|export|demo|internal`',
    `payment_method` STRING COMMENT 'Method of payment for the vehicle order. Cash for full upfront payment, finance for loan-based purchase, lease for lease agreement, fleet_contract for commercial fleet arrangements.. Valid values are `cash|finance|lease|fleet_contract`',
    `powertrain_type` STRING COMMENT 'Type of powertrain system for the ordered vehicle. ICE for Internal Combustion Engine, HEV for Hybrid Electric Vehicle, PHEV for Plug-in Hybrid Electric Vehicle, BEV for Battery Electric Vehicle, FCEV for Fuel Cell Electric Vehicle.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `priority_code` STRING COMMENT 'Priority classification for production scheduling. VIP for high-value customers, expedited for rush orders, fleet_priority for large commercial contracts, standard for normal processing.. Valid values are `standard|expedited|vip|fleet_priority`',
    `region_code` STRING COMMENT 'Geographic sales region code where the order was placed. Used for regional sales performance analysis and territory management.. Valid values are `^[A-Z]{2,5}$`',
    `requested_delivery_date` DATE COMMENT 'Customer-requested date for vehicle delivery. Used for production planning and logistics scheduling.',
    `sales_channel` STRING COMMENT 'Channel through which the order was captured. Dealer for traditional dealership sales, direct for OEM-direct sales, online for e-commerce platform, fleet_sales for commercial fleet division, broker for third-party intermediaries.. Valid values are `dealer|direct|online|fleet_sales|broker`',
    `selling_price` DECIMAL(18,2) COMMENT 'Final agreed selling price for the vehicle after all discounts, incentives, rebates, and negotiations. Represents the actual transaction price.',
    `special_instructions` STRING COMMENT 'Free-text field for special handling instructions, customer requests, or delivery notes that require attention during order fulfillment.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total sales tax, value-added tax, or other applicable taxes calculated for the vehicle order based on delivery jurisdiction.',
    `total_amount` DECIMAL(18,2) COMMENT 'Total amount payable by the customer including selling price, taxes, fees, and any additional charges minus trade-in value.',
    `trade_in_value` DECIMAL(18,2) COMMENT 'Appraised value of the customer trade-in vehicle applied toward the purchase. Null if no trade-in is involved.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this order record was last modified in the data platform. Used for change tracking and audit trail.',
    `vehicle_model_code` STRING COMMENT 'Internal model code identifying the base vehicle platform and variant. Used for production planning and parts management.. Valid values are `^[A-Z0-9]{5,15}$`',
    `vin` STRING COMMENT '17-character Vehicle Identification Number assigned to the ordered vehicle. May be null at order placement for build-to-order vehicles and populated when the vehicle enters production.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_vehicle_order PRIMARY KEY(`vehicle_order_id`)
) COMMENT 'Confirmed customer vehicle purchase order capturing the commercial commitment to buy a specific configured vehicle. Records order type (retail, fleet, government, export), ordered VIN or build-to-order configuration, agreed selling price, payment method, financing reference, delivery commitment date, and order status lifecycle (placed, confirmed, in-production, shipped, delivered). Interfaces with SAP SD sales order (VA01) and triggers manufacturing scheduling.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`order_line` (
    `order_line_id` BIGINT COMMENT 'Unique identifier for the order line item. Primary key for the order_line product.',
    `configuration_id` BIGINT COMMENT 'Reference to the detailed vehicle configuration record capturing all selected options, packages, and specifications for this order line.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership responsible for this order line. Links to dealer network and channel management.',
    `fleet_contract_id` BIGINT COMMENT 'Reference to the fleet sales contract or commercial vehicle agreement governing this line item. Null for retail orders.',
    `incentive_program_id` BIGINT COMMENT 'Foreign key linking to sales.sales_incentive_program. Business justification: Order lines capture incentive_amount applied at the line level. Adding sales_incentive_program_id to order_line normalizes the incentive reference, enabling line-level incentive program redemption tra',
    `option_package_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_option_package. Business justification: Order line must reference option package entity to drive production planning, parts allocation, and warranty tracking.',
    `party_id` BIGINT COMMENT 'FK to the F&I menu product sold on this line.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Line‑level accountability requires the employee responsible for each order line.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the trade-in vehicle appraisal record if this order line includes a trade-in transaction. Null if no trade-in.',
    `production_schedule_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_schedule. Business justification: Order lines are allocated to production schedules at the line level in automotive order management systems. scheduled_production_date on order_line is a denormalized representation of the production s',
    `quote_line_id` BIGINT COMMENT 'Foreign key linking to sales.quote_line. Business justification: Each order line item originates from a specific quote line item when a quote is converted to an order. Linking order_line.quote_line_id to quote_line provides line-level quote-to-order conversion trac',
    `tertiary_order_vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle master record when line_type is vehicle. Links to vehicle configuration and specifications.',
    `trade_in_id` BIGINT COMMENT 'Reference to the trade-in vehicle appraisal record if this order line includes a trade-in transaction. Null if no trade-in.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key reference to the parent sales order header. Links this line item to its containing order transaction.',
    `actual_delivery_date` DATE COMMENT 'Actual date when the line item was delivered and accepted by the dealer or customer. Triggers revenue recognition.',
    `actual_production_date` DATE COMMENT 'Actual date when vehicle production was completed. Populated from MES upon job completion.',
    `allocation_date` DATE COMMENT 'Date when a specific vehicle unit or inventory item was allocated to fulfill this order line. Null until allocation occurs.',
    `cancellation_reason` STRING COMMENT 'Reason code or description explaining why this order line was cancelled. Null for non-cancelled lines.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this order line record was first created in the system. Represents the moment of order line capture.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts on this line item.. Valid values are `^[A-Z]{3}$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total discount applied to this line item including dealer discounts, promotional discounts, and volume discounts.',
    `estimated_delivery_date` DATE COMMENT 'Estimated date when the line item will be delivered to the dealer or end customer. Updated based on production and logistics schedules.',
    `exterior_color_code` STRING COMMENT 'Manufacturer color code for the vehicle exterior paint finish. Links to paint specification and supply chain planning.',
    `financing_type` STRING COMMENT 'Method of financing selected for this line item. Indicates whether the customer is paying cash, securing a loan, entering a lease, or using fleet financing.. Valid values are `cash|loan|lease|fleet_lease|captive_finance`',
    `fleet_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether this line item is part of a fleet or commercial vehicle order. True for fleet sales, False for retail sales.',
    `incentive_amount` DECIMAL(18,2) COMMENT 'Manufacturer or dealer incentive amount applied to this line item. Includes rebates, loyalty bonuses, and promotional incentives.',
    `interior_color_code` STRING COMMENT 'Manufacturer color code for the vehicle interior trim and upholstery. Links to interior material specifications.',
    `line_number` STRING COMMENT 'Sequential line item number within the parent order. Determines display and processing sequence.',
    `line_status` STRING COMMENT 'Current fulfillment status of this order line. Tracks progression from order capture through delivery or cancellation. [ENUM-REF-CANDIDATE: open|allocated|in_production|shipped|delivered|cancelled|on_hold — 7 candidates stripped; promote to reference product]',
    `line_total` DECIMAL(18,2) COMMENT 'Total amount for this line item including net price, taxes, and fees. Calculated as (net_price * quantity) plus tax_amount.',
    `line_type` STRING COMMENT 'Classification of the order line item indicating whether it represents a vehicle unit, accessory, warranty product, service contract, parts, freight charge, or documentation fee. [ENUM-REF-CANDIDATE: vehicle|accessory|extended_warranty|service_contract|parts|freight|documentation_fee — 7 candidates stripped; promote to reference product]',
    `list_price` DECIMAL(18,2) COMMENT 'Manufacturer Suggested Retail Price (MSRP) or catalog list price per unit before any discounts or incentives.',
    `model_code` STRING COMMENT 'Manufacturer model code identifying the vehicle platform, body style, and base configuration. Used for production planning and parts allocation.',
    `model_year` STRING COMMENT 'Model year designation for the vehicle. Represents the production year classification, not the calendar year of manufacture.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this order line record was last modified. Updated whenever any attribute changes.',
    `net_price` DECIMAL(18,2) COMMENT 'Net unit price after applying all discounts and incentives but before taxes and fees. Calculated as list_price minus discount_amount minus incentive_amount.',
    `powertrain_type` STRING COMMENT 'Type of powertrain system. ICE=Internal Combustion Engine, HEV=Hybrid Electric Vehicle, PHEV=Plug-in Hybrid Electric Vehicle, BEV=Battery Electric Vehicle, FCEV=Fuel Cell Electric Vehicle.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `product_description` STRING COMMENT 'Human-readable description of the line item product or service. Provides business context for reporting and customer documentation.',
    `quantity` DECIMAL(18,2) COMMENT 'Ordered quantity for this line item. Typically 1 for vehicle units, may be greater than 1 for accessories, parts, or fleet orders.',
    `ship_date` DATE COMMENT 'Date when the line item was shipped from the manufacturing plant or distribution center to the dealer or customer.',
    `special_instructions` STRING COMMENT 'Free-text field capturing any special handling instructions, customer requests, or delivery notes specific to this order line.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount for this line item including sales tax, value-added tax, and any applicable excise taxes.',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the quantity field. EA=Each, SET=Set, KIT=Kit, HR=Hour (for service contracts), UNIT=Unit.. Valid values are `EA|SET|KIT|HR|UNIT`',
    `vin` STRING COMMENT '17-character Vehicle Identification Number assigned to this line item when available. May be null at order capture and populated during production allocation. Uniquely identifies the physical vehicle unit.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_order_line PRIMARY KEY(`order_line_id`)
) COMMENT 'Individual line item within a vehicle order representing a specific vehicle unit, accessory, extended warranty, or service contract. Captures VIN assignment (when available), model code, trim level, exterior/interior color, option packages, unit net price, quantity, and line fulfillment status. Supports multi-unit fleet orders with individual VIN-level tracking per line.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`incentive_program` (
    `incentive_program_id` BIGINT COMMENT 'Unique identifier for the sales_incentive_program data product (auto-inserted pre-linking).',
    `budget_amount` DECIMAL(18,2) COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `currency_code` STRING COMMENT '',
    `eligibility_criteria` STRING COMMENT '',
    `end_date` DATE COMMENT '',
    `incentive_amount` DECIMAL(18,2) COMMENT '',
    `incentive_type` STRING COMMENT '',
    `program_code` STRING COMMENT '',
    `program_description` STRING COMMENT '',
    `program_name` STRING COMMENT '',
    `program_status` STRING COMMENT '',
    `start_date` DATE COMMENT '',
    `target_region` STRING COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT '',
    CONSTRAINT pk_incentive_program PRIMARY KEY(`incentive_program_id`)
) COMMENT 'Master record for OEM-sponsored sales incentive programs including customer cash rebates, dealer cash allowances, low-APR financing offers, lease support, conquest bonuses, loyalty rewards, and fleet incentives. Captures program code, program type, eligible model year and nameplate, start and end dates, maximum incentive amount, funding source (OEM vs regional), stackability rules, and eligibility criteria. Managed centrally and distributed to dealer network.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` (
    `fleet_contract_id` BIGINT COMMENT 'Unique identifier for the fleet contract. Primary key for the fleet contract entity.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Fleet Contract Management tracks the sales employee handling each fleet contract.',
    `incentive_program_id` BIGINT COMMENT 'Reference to the fleet incentive program linked to this contract. Determines eligibility for manufacturer rebates and special financing.',
    `opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Fleet contracts are typically negotiated and closed from fleet sales opportunities. Linking fleet_contract.opportunity_id to opportunity enables traceability from fleet opportunity identification thro',
    `organization_account_id` BIGINT COMMENT 'Reference to the fleet customer account that holds this contract. Links to the master fleet account entity.',
    `party_id` BIGINT COMMENT 'Reference to the primary customer entity associated with this fleet contract. May represent corporate buyer, government agency, or rental company.',
    `annual_mileage_allowance` STRING COMMENT 'Maximum annual mileage allowed per vehicle under lease terms without excess mileage charges. Typical values range from 10,000 to 25,000 miles per year. Null for purchase contracts.',
    `approval_date` DATE COMMENT 'Date when the fleet contract received final internal approval from sales management or finance. Precedes contract signing.',
    `approved_by_user_code` BIGINT COMMENT 'Reference to the user who granted final approval for this fleet contract. Typically a sales director or VP of fleet sales.',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the contract automatically renews for an additional term unless either party provides notice of non-renewal.',
    `base_discount_percentage` DECIMAL(18,2) COMMENT 'Base percentage discount off Manufacturer Suggested Retail Price (MSRP) granted to the fleet customer. Additional volume-based discounts may apply.',
    `committed_volume` STRING COMMENT 'Total number of vehicles the fleet customer has committed to purchase or lease under this contract. Used for volume-based pricing tier qualification.',
    `contract_name` STRING COMMENT 'Descriptive name or title of the fleet contract, typically including customer name and program identifier for easy reference.',
    `contract_number` STRING COMMENT 'Externally-known unique business identifier for the fleet contract, used in communications with fleet customers and internal systems. Format: FC-YYYYNNNN.. Valid values are `^FC-[0-9]{8}$`',
    `contract_signed_date` DATE COMMENT 'Date when the fleet contract was formally signed by both parties. Marks the legal binding of the agreement.',
    `contract_status` STRING COMMENT 'Current lifecycle status of the fleet contract. Governs whether new orders can be placed and whether pricing and incentives are active. [ENUM-REF-CANDIDATE: draft|pending_approval|active|suspended|expired|terminated|completed — 7 candidates stripped; promote to reference product]',
    `contract_term_months` STRING COMMENT 'Duration of the fleet contract expressed in months. Typical terms range from 12 to 60 months for corporate fleets.',
    `contract_type` STRING COMMENT 'Classification of the fleet contract based on customer segment and business model. Determines pricing rules, incentive eligibility, and delivery processes.. Valid values are `corporate|government|rental|utility|leasing|dealer_demo`',
    `contract_value_amount` DECIMAL(18,2) COMMENT 'Total estimated monetary value of the fleet contract based on committed volume and agreed pricing. Expressed in contract currency.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this fleet contract record was first created in the system. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this contract (e.g., USD, EUR, CAD).. Valid values are `^[A-Z]{3}$`',
    `delivered_volume` STRING COMMENT 'Cumulative count of vehicles delivered to the fleet customer under this contract to date. Updated upon each delivery completion.',
    `delivery_schedule_type` STRING COMMENT 'Classification of how vehicles will be delivered over the contract term. Staggered and quarterly schedules are common for large fleet orders.. Valid values are `single_delivery|staggered|quarterly|annual|on_demand`',
    `effective_end_date` DATE COMMENT 'Date when the fleet contract expires or terminates. After this date, no new orders can be placed under the contract terms. Nullable for open-ended agreements.',
    `effective_start_date` DATE COMMENT 'Date when the fleet contract becomes active and eligible for vehicle orders. Aligns with fiscal year or model year start in many cases.',
    `eligible_model_years` STRING COMMENT 'Comma-separated list of model years eligible for purchase under this contract. Typically current and next model year.',
    `eligible_nameplates` STRING COMMENT 'Comma-separated list of vehicle nameplates (model names) eligible for purchase under this fleet contract. May include sedans, SUVs, trucks, or commercial vehicles.',
    `eligible_powertrain_types` STRING COMMENT 'Comma-separated list of powertrain types eligible under this contract. May include ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), EV (Electric Vehicle), or combinations.',
    `financing_type` STRING COMMENT 'Primary financing method for vehicles under this contract. Captive finance refers to manufacturer-owned financing arm.. Valid values are `cash_purchase|lease|captive_finance|third_party_finance|mixed`',
    `government_contract_flag` BOOLEAN COMMENT 'Indicates whether this is a government procurement contract subject to special regulations, reporting requirements, and compliance standards.',
    `gsa_schedule_number` STRING COMMENT 'GSA schedule contract number for U.S. federal government fleet purchases. Null for non-government contracts.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this fleet contract record was last updated. Tracks the most recent change to any field in the record.',
    `lease_term_months` STRING COMMENT 'Duration of lease agreement in months if financing_type is lease. Typical fleet lease terms are 24, 36, or 48 months. Null for cash purchases.',
    `maintenance_included_flag` BOOLEAN COMMENT 'Indicates whether scheduled maintenance services are included in the fleet contract pricing. Common for lease agreements and full-service fleet contracts.',
    `minimum_order_quantity` STRING COMMENT 'Minimum number of vehicles that must be ordered in a single transaction to qualify for fleet contract pricing.',
    `multi_location_delivery_flag` BOOLEAN COMMENT 'Indicates whether vehicles under this contract will be delivered to multiple locations. True for national fleet accounts with regional distribution.',
    `national_fleet_account_flag` BOOLEAN COMMENT 'Indicates whether this is a national fleet account with centralized purchasing and multi-region delivery. National accounts receive special pricing and dedicated account management.',
    `payment_terms` STRING COMMENT 'Standard payment terms governing when payment is due after vehicle delivery. Net 30/60/90 are common for corporate fleets; government contracts may have custom terms.. Valid values are `net_30|net_60|net_90|prepayment|milestone|custom`',
    `primary_delivery_location` STRING COMMENT 'Primary geographic location or facility where fleet vehicles will be delivered. May be a corporate headquarters, fleet depot, or distribution center.',
    `remaining_volume` STRING COMMENT 'Number of vehicles remaining to be delivered under the committed volume. Calculated as committed_volume minus delivered_volume.',
    `renewal_eligible_flag` BOOLEAN COMMENT 'Indicates whether this fleet contract is eligible for renewal upon expiration. Based on customer performance, payment history, and strategic account status.',
    `sales_region` STRING COMMENT 'Geographic sales region where this fleet contract is managed. Used for regional sales performance tracking and territory management.',
    `special_terms_notes` STRING COMMENT 'Free-text field capturing any special terms, conditions, or negotiated provisions unique to this fleet contract that are not captured in standard fields.',
    `termination_date` DATE COMMENT 'Date when the fleet contract was terminated prior to its natural expiration. Null for contracts that completed normally or are still active.',
    `termination_reason` STRING COMMENT 'Business reason for early termination of the fleet contract. Examples include customer request, breach of terms, business closure, or strategic change.',
    `volume_tier_discount_percentage` DECIMAL(18,2) COMMENT 'Additional discount percentage applied when cumulative volume reaches specified tier thresholds. Stacks on top of base discount.',
    `warranty_extension_months` STRING COMMENT 'Number of months beyond standard manufacturer warranty that are included in the fleet contract. Zero indicates standard warranty only.',
    CONSTRAINT pk_fleet_contract PRIMARY KEY(`fleet_contract_id`)
) COMMENT 'Commercial agreement governing the sale or lease of multiple vehicles to a fleet customer (corporate, government, rental, utility). Captures fleet account reference, contracted volume commitments, agreed pricing tiers, eligible nameplates and model years, contract term, delivery schedule, fleet incentive program linkage, and contract status. Supports national fleet accounts and government procurement contracts. Distinct from retail sales orders due to volume pricing, multi-delivery scheduling, and contract lifecycle management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`trade_in` (
    `trade_in_id` BIGINT COMMENT 'Unique identifier for the trade-in transaction record.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership that appraised and accepted the trade-in vehicle.',
    `party_id` BIGINT COMMENT 'Reference to the customer who traded in the vehicle.',
    `vehicle_order_id` BIGINT COMMENT 'Reference to the associated new vehicle purchase order for which this trade-in was accepted.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Trade-in appraisal, CPO eligibility assessment, and remarketing disposition all require linking the trade-in vehicle to its canonical VIN registry record. Appraisal reports and reconditioning cost ana',
    `accepted_date` DATE COMMENT 'Date when the customer and dealership agreed to the trade-in terms and the trade-in was officially accepted.',
    `accident_history_flag` BOOLEAN COMMENT 'Indicates whether the trade-in vehicle has a reported accident history (True/False).',
    `allowance` DECIMAL(18,2) COMMENT 'Agreed-upon credit amount applied toward the new vehicle purchase, which may differ from appraised value due to negotiation.',
    `appraisal_date` DATE COMMENT 'Date when the trade-in vehicle was appraised and evaluated by the dealership.',
    `appraised_value` DECIMAL(18,2) COMMENT 'Fair market value of the trade-in vehicle as determined by the dealership appraiser, before negotiation.',
    `body_style` STRING COMMENT 'Body style classification of the trade-in vehicle. [ENUM-REF-CANDIDATE: sedan|coupe|suv|truck|van|wagon|convertible|hatchback — 8 candidates stripped; promote to reference product]',
    `condition_grade` STRING COMMENT 'Overall condition assessment of the trade-in vehicle based on physical inspection (excellent, good, fair, poor).. Valid values are `excellent|good|fair|poor`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this trade-in record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this trade-in transaction.. Valid values are `^[A-Z]{3}$`',
    `disposition_amount` DECIMAL(18,2) COMMENT 'Actual sale or disposal amount realized when the trade-in vehicle was disposed of, used to calculate trade-in profitability.',
    `disposition_date` DATE COMMENT 'Date when the trade-in vehicle was sold, transferred, or otherwise disposed of by the dealership.',
    `disposition_type` STRING COMMENT 'Planned or actual disposition channel for the trade-in vehicle after acceptance (wholesale auction, certified pre-owned program, retail resale, internal fleet, scrap).. Valid values are `wholesale_auction|certified_pre_owned|retail_resale|internal_fleet|scrap`',
    `exterior_color` STRING COMMENT 'Exterior paint color of the trade-in vehicle.',
    `exterior_condition` STRING COMMENT 'Assessment of the exterior body condition of the trade-in vehicle (paint, body panels, glass).. Valid values are `excellent|good|fair|poor`',
    `inspection_completed` BOOLEAN COMMENT 'Indicates whether a full mechanical and safety inspection was completed on the trade-in vehicle (True/False).',
    `inspection_date` DATE COMMENT 'Date when the detailed inspection of the trade-in vehicle was completed.',
    `interior_color` STRING COMMENT 'Interior upholstery color of the trade-in vehicle.',
    `interior_condition` STRING COMMENT 'Assessment of the interior condition of the trade-in vehicle (seats, dashboard, carpets, controls).. Valid values are `excellent|good|fair|poor`',
    `lien_holder` STRING COMMENT 'Name of the financial institution or entity holding a lien on the trade-in vehicle, if applicable.',
    `make` STRING COMMENT 'Manufacturer or brand of the trade-in vehicle (e.g., Ford, Toyota, Honda).',
    `mechanical_condition` STRING COMMENT 'Assessment of the mechanical and operational condition of the trade-in vehicle (engine, transmission, drivetrain).. Valid values are `excellent|good|fair|poor`',
    `model` STRING COMMENT 'Model name of the trade-in vehicle (e.g., F-150, Camry, Accord).',
    `model_year` STRING COMMENT 'Model year of the trade-in vehicle as designated by the manufacturer.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this trade-in record was last modified or updated.',
    `notes` STRING COMMENT 'Free-form notes and comments regarding the trade-in vehicle, appraisal, condition, or negotiation details.',
    `odometer_reading` STRING COMMENT 'Mileage reading on the trade-in vehicle at the time of appraisal, in miles or kilometers as per regional standard.',
    `odometer_unit` STRING COMMENT 'Unit of measure for the odometer reading (miles or kilometers).. Valid values are `miles|kilometers`',
    `outstanding_loan_balance` DECIMAL(18,2) COMMENT 'Remaining loan balance owed on the trade-in vehicle at the time of trade, if applicable.',
    `powertrain_type` STRING COMMENT 'Type of powertrain in the trade-in vehicle: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), FCEV (Fuel Cell Electric Vehicle).. Valid values are `ice|hev|phev|bev|fcev`',
    `reconditioning_cost` DECIMAL(18,2) COMMENT 'Total cost incurred to recondition the trade-in vehicle for resale (repairs, detailing, inspection).',
    `service_records_available` BOOLEAN COMMENT 'Indicates whether complete service and maintenance records are available for the trade-in vehicle (True/False).',
    `tire_condition` STRING COMMENT 'Assessment of the tire condition and tread depth on the trade-in vehicle.. Valid values are `excellent|good|fair|poor`',
    `title_status` STRING COMMENT 'Legal title status of the trade-in vehicle (clean, salvage, rebuilt, lemon, flood).. Valid values are `clean|salvage|rebuilt|lemon|flood`',
    `trade_in_number` STRING COMMENT 'Business-facing unique transaction number assigned to the trade-in for tracking and reference purposes.',
    `transmission_type` STRING COMMENT 'Type of transmission in the trade-in vehicle (manual, automatic, CVT, dual-clutch).. Valid values are `manual|automatic|cvt|dct`',
    `trim_level` STRING COMMENT 'Trim or package level of the trade-in vehicle (e.g., LX, EX, Limited, Sport).',
    CONSTRAINT pk_trade_in PRIMARY KEY(`trade_in_id`)
) COMMENT 'Record of a customer vehicle trade-in evaluated and accepted as part of a new vehicle purchase transaction. Captures trade-in vehicle details (VIN, make, model, year, mileage, condition grade), appraised value, agreed trade-in allowance, appraisal date, appraising dealer, and disposition (wholesale auction, certified pre-owned, retail resale). Links to the associated vehicle order.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` (
    `delivery_appointment_id` BIGINT COMMENT 'Unique identifier for the delivery appointment record. Primary key for the delivery appointment entity.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership or delivery center where the vehicle handover will occur.',
    `finished_vehicle_stock_id` BIGINT COMMENT 'Foreign key linking to inventory.finished_vehicle_stock. Business justification: Vehicle delivery operations require PDI status, hold codes, and recall flags from the specific finished_vehicle_stock record before appointment proceeds. Automotive delivery coordinators must confirm ',
    `technician_id` BIGINT COMMENT 'Reference to the technician who performed the Pre-Delivery Inspection.',
    `plant_id` BIGINT COMMENT 'Reference to the sales representative or delivery specialist assigned to conduct the vehicle handover and customer orientation.',
    `party_id` BIGINT COMMENT 'Reference to the customer who will take delivery of the vehicle.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle unit being delivered, linked by VIN (Vehicle Identification Number).',
    `rescheduled_from_delivery_appointment_id` BIGINT COMMENT 'Reference to the previous delivery appointment if this appointment is a rescheduled version.',
    `trade_in_id` BIGINT COMMENT 'Foreign key linking to sales.trade_in. Business justification: A delivery appointment often involves simultaneous trade-in vehicle acceptance. The delivery_appointment already has a trade_in_status field indicating the trade-in is tracked at delivery time. Adding',
    `vehicle_order_id` BIGINT COMMENT 'Reference to the confirmed vehicle order for which this delivery appointment is scheduled.',
    `actual_delivery_timestamp` TIMESTAMP COMMENT 'Date and time when the vehicle was actually handed over to the customer and delivery was completed.',
    `appointment_duration_minutes` STRING COMMENT 'Expected duration of the delivery appointment in minutes, including vehicle walkthrough, paperwork, and handover.',
    `appointment_number` STRING COMMENT 'Business-facing unique appointment reference number used for customer communication and tracking. Format: DA-YYYYMMDD-sequence.. Valid values are `^DA-[0-9]{8}$`',
    `appointment_status` STRING COMMENT 'Current lifecycle status of the delivery appointment. [ENUM-REF-CANDIDATE: scheduled|confirmed|in_progress|completed|cancelled|no_show|rescheduled — 7 candidates stripped; promote to reference product]',
    `cancellation_reason` STRING COMMENT 'Reason provided for cancellation if the delivery appointment was cancelled.',
    `connected_services_activated` BOOLEAN COMMENT 'Indicates whether connected vehicle services and mobile app access were activated during delivery.',
    `created_by_user_code` BIGINT COMMENT 'Reference to the user who created the delivery appointment record.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the delivery appointment record was first created in the system.',
    `customer_arrival_timestamp` TIMESTAMP COMMENT 'Date and time when the customer arrived at the delivery location for their appointment.',
    `customer_confirmation_status` STRING COMMENT 'Status indicating whether the customer has confirmed their attendance at the scheduled delivery appointment.. Valid values are `pending|confirmed|declined|no_response`',
    `customer_confirmed_timestamp` TIMESTAMP COMMENT 'Date and time when the customer confirmed the delivery appointment.',
    `delivery_address_line1` STRING COMMENT 'Primary street address line for the delivery location if delivery is not at a standard dealership facility.',
    `delivery_address_line2` STRING COMMENT 'Secondary address line (suite, apartment, building) for the delivery location.',
    `delivery_city` STRING COMMENT 'City name for the delivery location.',
    `delivery_country_code` STRING COMMENT 'Three-letter ISO country code for the delivery location.. Valid values are `^[A-Z]{3}$`',
    `delivery_location_type` STRING COMMENT 'Classification of the delivery location where the vehicle will be handed over to the customer.. Valid values are `dealership|customer_home|fleet_depot|distribution_center|direct_delivery_hub|other`',
    `delivery_postal_code` STRING COMMENT 'Postal or ZIP code for the delivery location.',
    `delivery_satisfaction_score` STRING COMMENT 'Customer satisfaction rating for the delivery experience, typically on a scale of 1-10, collected immediately after delivery.',
    `delivery_state_province` STRING COMMENT 'State or province code for the delivery location.',
    `delivery_type` STRING COMMENT 'Classification of the delivery service level provided to the customer.. Valid values are `standard|express|white_glove|fleet|commercial`',
    `digital_owner_manual_sent` BOOLEAN COMMENT 'Indicates whether the digital owner manual and vehicle information was sent to the customer.',
    `documentation_status` STRING COMMENT 'Status of delivery documentation preparation including title, registration, warranty cards, and owner manuals.. Valid values are `pending|in_progress|completed|incomplete`',
    `financing_status` STRING COMMENT 'Status of financing approval and funding for the vehicle purchase if applicable.. Valid values are `not_applicable|pending|approved|funded|declined`',
    `handover_duration_minutes` STRING COMMENT 'Actual duration of the vehicle handover process from customer arrival to departure.',
    `last_reminder_sent_timestamp` TIMESTAMP COMMENT 'Date and time when the most recent appointment reminder was sent to the customer.',
    `modified_by_user_code` BIGINT COMMENT 'Reference to the user who last modified the delivery appointment record.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when the delivery appointment record was last modified.',
    `pdi_completed_timestamp` TIMESTAMP COMMENT 'Date and time when the Pre-Delivery Inspection was completed and the vehicle was cleared for delivery.',
    `pdi_status` STRING COMMENT 'Status of the Pre-Delivery Inspection process ensuring the vehicle meets quality standards before customer handover.. Valid values are `not_started|in_progress|completed|failed|waived`',
    `reminder_sent_count` STRING COMMENT 'Number of appointment reminder notifications sent to the customer via email, SMS, or phone.',
    `scheduled_delivery_date` DATE COMMENT 'The date on which the vehicle delivery appointment is scheduled to occur.',
    `scheduled_delivery_time` TIMESTAMP COMMENT 'The precise date and time when the customer is expected to arrive for vehicle handover.',
    `special_instructions` STRING COMMENT 'Any special instructions or requirements for the delivery appointment such as accessibility needs, language preferences, or specific requests.',
    `trade_in_status` STRING COMMENT 'Status of trade-in vehicle processing if the customer is trading in a vehicle as part of the transaction.. Valid values are `not_applicable|pending_appraisal|appraised|accepted|declined|completed`',
    `vehicle_orientation_completed` BOOLEAN COMMENT 'Indicates whether the delivery specialist completed the vehicle features and controls orientation with the customer.',
    `vehicle_preparation_status` STRING COMMENT 'Status of vehicle preparation activities including cleaning, fueling, accessory installation, and final detailing before delivery.. Valid values are `pending|in_progress|completed|on_hold`',
    `vin` STRING COMMENT '17-character Vehicle Identification Number uniquely identifying the vehicle being delivered. ISO 3779 standard format.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_delivery_appointment PRIMARY KEY(`delivery_appointment_id`)
) COMMENT 'Scheduled vehicle delivery appointment for a confirmed vehicle order, coordinating the handover of a new vehicle to the customer at a dealer or direct delivery point. Captures scheduled delivery date and time, delivery location, assigned delivery specialist, PDI (Pre-Delivery Inspection) completion status, customer confirmation status, and actual delivery completion timestamp. Triggers post-delivery customer satisfaction follow-up.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` (
    `telemetry_event_id` BIGINT COMMENT 'Unique surrogate key for each telemetry event record.',
    `dealership_id` BIGINT COMMENT 'Unique identifier of the driver associated with the vehicle at event time.',
    `individual_id` BIGINT COMMENT 'Unique identifier of the driver associated with the vehicle at event time.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Telemetry events from connected vehicles can be correlated to the originating vehicle order for post-sale analytics, warranty tracking, and connected services activation monitoring. The telemetry_even',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Allows raw telemetry events to be associated with the official vehicle record for diagnostics, safety reporting and emissions compliance.',
    `altitude` DOUBLE COMMENT 'Elevation above sea level of the vehicle at event time, in meters.',
    `battery_soc_percent` DOUBLE COMMENT 'Current electric battery charge level for EV/HEV vehicles, expressed as a percentage.',
    `battery_voltage_volt` DOUBLE COMMENT 'Instantaneous voltage of the vehicles high‑voltage battery, expressed in volts.',
    `charging_status` BOOLEAN COMMENT 'True if the vehicle is currently connected to a charger and charging, otherwise false.',
    `connectivity_status` BOOLEAN COMMENT 'True if the telematics device had an active network connection at event time.',
    `engine_rpm` STRING COMMENT 'Engine speed measured in revolutions per minute at the time of the event.',
    `engine_temperature_c` DOUBLE COMMENT 'Measured temperature of the engine coolant at event time, in degrees Celsius.',
    `event_sequence` BIGINT COMMENT 'Monotonically increasing sequence number for events from the same vehicle, used for ordering.',
    `event_source` STRING COMMENT 'Identifier of the source system that produced the telemetry record (e.g., Geotab, Bosch).',
    `event_timestamp` TIMESTAMP COMMENT 'Date and time when the telemetry event was generated by the vehicle sensor.',
    `event_type_code` STRING COMMENT 'Code that categorizes the type of telemetry event (e.g., speed, harsh_brake, idle).',
    `firmware_version` STRING COMMENT 'Version identifier of the telematics device firmware that generated the event.',
    `fuel_level_percent` DOUBLE COMMENT 'Remaining fuel level expressed as a percentage of tank capacity.',
    `gps_accuracy_m` DOUBLE COMMENT 'Estimated horizontal accuracy of the GPS position in meters.',
    `heading_degrees` DOUBLE COMMENT 'Compass direction the vehicle is facing at event time, expressed in degrees from true north.',
    `ignition_state` BOOLEAN COMMENT 'Indicates whether the vehicle ignition is on (true) or off (false) at the moment of the event.',
    `latitude` DOUBLE COMMENT 'Geographic latitude of the vehicle at event time, expressed in decimal degrees.',
    `latitude_accuracy` DOUBLE COMMENT 'Estimated vertical accuracy of the latitude measurement.',
    `location_city` STRING COMMENT 'City name derived from the GPS coordinates at event time.',
    `location_country` STRING COMMENT 'Three‑letter ISO country code derived from the GPS coordinates at event time.',
    `location_state` STRING COMMENT 'State or province name derived from the GPS coordinates at event time.',
    `longitude` DOUBLE COMMENT 'Geographic longitude of the vehicle at event time, expressed in decimal degrees.',
    `longitude_accuracy` DOUBLE COMMENT 'Estimated vertical accuracy of the longitude measurement.',
    `odometer_km` DOUBLE COMMENT 'Cumulative distance traveled by the vehicle, recorded in kilometers.',
    `raw_payload` STRING COMMENT 'Original JSON payload received from the telematics device before any transformation.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the telemetry record was first ingested into the silver layer.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the telemetry record in the lakehouse.',
    `signal_quality` STRING COMMENT 'Qualitative assessment of the telemetry signal (e.g., good, moderate, poor).',
    `speed_kph` DOUBLE COMMENT 'Instantaneous vehicle speed at event time, measured in kilometers per hour.',
    `tire_pressure_front_left_psi` DOUBLE COMMENT 'Air pressure of the front‑left tire measured in pounds per square inch.',
    `tire_pressure_front_right_psi` DOUBLE COMMENT 'Air pressure of the front‑right tire measured in pounds per square inch.',
    `tire_pressure_rear_left_psi` DOUBLE COMMENT 'Air pressure of the rear‑left tire measured in pounds per square inch.',
    `tire_pressure_rear_right_psi` DOUBLE COMMENT 'Air pressure of the rear‑right tire measured in pounds per square inch.',
    CONSTRAINT pk_telemetry_event PRIMARY KEY(`telemetry_event_id`)
) COMMENT 'High-frequency transactional record of raw and processed telematics events streamed from connected vehicles via Geotab or Bosch IoT. Each record captures event timestamp, VIN reference, GPS coordinates (latitude, longitude, altitude), vehicle speed, heading, ignition state, odometer reading, fuel level, battery state of charge (for EV/HEV), engine RPM, and event type code. Silver layer record represents cleansed and deduplicated stream from the bronze ingestion layer.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_incentive_program_id` FOREIGN KEY (`incentive_program_id`) REFERENCES `vibe_automotive_v1`.`sales`.`incentive_program`(`incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_incentive_program_id` FOREIGN KEY (`incentive_program_id`) REFERENCES `vibe_automotive_v1`.`sales`.`incentive_program`(`incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_opportunity_id` FOREIGN KEY (`opportunity_id`) REFERENCES `vibe_automotive_v1`.`sales`.`opportunity`(`opportunity_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_trade_in_id` FOREIGN KEY (`trade_in_id`) REFERENCES `vibe_automotive_v1`.`sales`.`trade_in`(`trade_in_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_incentive_program_id` FOREIGN KEY (`incentive_program_id`) REFERENCES `vibe_automotive_v1`.`sales`.`incentive_program`(`incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_quote_id` FOREIGN KEY (`quote_id`) REFERENCES `vibe_automotive_v1`.`sales`.`quote`(`quote_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_fleet_contract_id` FOREIGN KEY (`fleet_contract_id`) REFERENCES `vibe_automotive_v1`.`sales`.`fleet_contract`(`fleet_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_incentive_program_id` FOREIGN KEY (`incentive_program_id`) REFERENCES `vibe_automotive_v1`.`sales`.`incentive_program`(`incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_opportunity_id` FOREIGN KEY (`opportunity_id`) REFERENCES `vibe_automotive_v1`.`sales`.`opportunity`(`opportunity_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_fleet_contract_id` FOREIGN KEY (`fleet_contract_id`) REFERENCES `vibe_automotive_v1`.`sales`.`fleet_contract`(`fleet_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_incentive_program_id` FOREIGN KEY (`incentive_program_id`) REFERENCES `vibe_automotive_v1`.`sales`.`incentive_program`(`incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_quote_line_id` FOREIGN KEY (`quote_line_id`) REFERENCES `vibe_automotive_v1`.`sales`.`quote_line`(`quote_line_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_trade_in_id` FOREIGN KEY (`trade_in_id`) REFERENCES `vibe_automotive_v1`.`sales`.`trade_in`(`trade_in_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ADD CONSTRAINT `fk_sales_fleet_contract_incentive_program_id` FOREIGN KEY (`incentive_program_id`) REFERENCES `vibe_automotive_v1`.`sales`.`incentive_program`(`incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ADD CONSTRAINT `fk_sales_fleet_contract_opportunity_id` FOREIGN KEY (`opportunity_id`) REFERENCES `vibe_automotive_v1`.`sales`.`opportunity`(`opportunity_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ADD CONSTRAINT `fk_sales_trade_in_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_rescheduled_from_delivery_appointment_id` FOREIGN KEY (`rescheduled_from_delivery_appointment_id`) REFERENCES `vibe_automotive_v1`.`sales`.`delivery_appointment`(`delivery_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_trade_in_id` FOREIGN KEY (`trade_in_id`) REFERENCES `vibe_automotive_v1`.`sales`.`trade_in`(`trade_in_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ADD CONSTRAINT `fk_sales_telemetry_event_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`sales` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_automotive_v1`.`sales` SET TAGS ('dbx_domain' = 'sales');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` SET TAGS ('dbx_subdomain' = 'revenue_pipeline');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Incentive Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `opportunity_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `opportunity_vehicle_model_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `territory_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Territory Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `actual_close_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Close Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `competitor_brand` SET TAGS ('dbx_business_glossary_term' = 'Competitor Brand');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `delivery_location` SET TAGS ('dbx_business_glossary_term' = 'Delivery Location');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `estimated_value` SET TAGS ('dbx_business_glossary_term' = 'Estimated Value');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `expected_close_date` SET TAGS ('dbx_business_glossary_term' = 'Expected Close Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `exterior_color` SET TAGS ('dbx_business_glossary_term' = 'Exterior Color');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `financing_type` SET TAGS ('dbx_business_glossary_term' = 'Financing Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `financing_type` SET TAGS ('dbx_value_regex' = 'cash|finance|lease|balloon|fleet_contract');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^FY[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `fleet_size` SET TAGS ('dbx_business_glossary_term' = 'Fleet Size');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `interior_color` SET TAGS ('dbx_business_glossary_term' = 'Interior Color');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `is_won` SET TAGS ('dbx_business_glossary_term' = 'Is Won');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `last_activity_date` SET TAGS ('dbx_business_glossary_term' = 'Last Activity Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `lead_source` SET TAGS ('dbx_business_glossary_term' = 'Lead Source');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `loss_reason` SET TAGS ('dbx_business_glossary_term' = 'Loss Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `model_year` SET TAGS ('dbx_value_regex' = '^MY[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `msrp` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `opportunity_name` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `next_follow_up_date` SET TAGS ('dbx_business_glossary_term' = 'Next Follow-Up Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `opportunity_number` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `opportunity_number` SET TAGS ('dbx_value_regex' = '^OPP-[0-9]{8}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `opportunity_type` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `opportunity_type` SET TAGS ('dbx_value_regex' = 'retail|fleet|commercial|government|employee_purchase|demo');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Priority');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `probability` SET TAGS ('dbx_business_glossary_term' = 'Probability of Close');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `quote_date` SET TAGS ('dbx_business_glossary_term' = 'Quote Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `quote_generated` SET TAGS ('dbx_business_glossary_term' = 'Quote Generated');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Sales Region');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `sales_stage` SET TAGS ('dbx_business_glossary_term' = 'Sales Stage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `test_drive_completed` SET TAGS ('dbx_business_glossary_term' = 'Test Drive Completed');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `test_drive_date` SET TAGS ('dbx_business_glossary_term' = 'Test Drive Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `trade_in_value` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Value');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `win_reason` SET TAGS ('dbx_business_glossary_term' = 'Win Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` SET TAGS ('dbx_subdomain' = 'revenue_pipeline');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_id` SET TAGS ('dbx_business_glossary_term' = 'Quote Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Incentive Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Opportunity Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Mobility Service Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `trade_in_id` SET TAGS ('dbx_business_glossary_term' = 'Trade In Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `accessories_total` SET TAGS ('dbx_business_glossary_term' = 'Accessories Total Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `apr_rate` SET TAGS ('dbx_business_glossary_term' = 'Annual Percentage Rate (APR)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `conversion_date` SET TAGS ('dbx_business_glossary_term' = 'Quote Conversion Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `converted_to_order` SET TAGS ('dbx_business_glossary_term' = 'Converted to Order Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `delivery_method` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Delivery Method');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `delivery_method` SET TAGS ('dbx_value_regex' = 'dealer_pickup|home_delivery|port_pickup|factory_pickup');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `destination_charge` SET TAGS ('dbx_business_glossary_term' = 'Destination and Delivery Charge');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `doc_fee` SET TAGS ('dbx_business_glossary_term' = 'Documentation Fee');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `down_payment` SET TAGS ('dbx_business_glossary_term' = 'Down Payment Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `drivetrain` SET TAGS ('dbx_business_glossary_term' = 'Drivetrain Configuration');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `drivetrain` SET TAGS ('dbx_value_regex' = 'fwd|rwd|awd|4wd');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `engine_code` SET TAGS ('dbx_business_glossary_term' = 'Engine Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `engine_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `estimated_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Quote Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `exterior_color_code` SET TAGS ('dbx_business_glossary_term' = 'Exterior Color Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `exterior_color_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,6}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `financing_offered` SET TAGS ('dbx_business_glossary_term' = 'Financing Offered Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `financing_term_months` SET TAGS ('dbx_business_glossary_term' = 'Financing Term in Months');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `incentive_total` SET TAGS ('dbx_business_glossary_term' = 'Total Incentive Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `interior_color_code` SET TAGS ('dbx_business_glossary_term' = 'Interior Color Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `interior_color_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,6}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `lease_annual_mileage` SET TAGS ('dbx_business_glossary_term' = 'Lease Annual Mileage Allowance');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `lease_monthly_payment` SET TAGS ('dbx_business_glossary_term' = 'Lease Monthly Payment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `lease_offered` SET TAGS ('dbx_business_glossary_term' = 'Lease Offered Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `lease_term_months` SET TAGS ('dbx_business_glossary_term' = 'Lease Term in Months');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Record Modified By User');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `monthly_payment` SET TAGS ('dbx_business_glossary_term' = 'Estimated Monthly Payment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `msrp_base` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Base');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `net_selling_price` SET TAGS ('dbx_business_glossary_term' = 'Net Selling Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Quote Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `options_total` SET TAGS ('dbx_business_glossary_term' = 'Options Total Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ice|hev|phev|bev|fcev');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_date` SET TAGS ('dbx_business_glossary_term' = 'Quote Issue Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_number` SET TAGS ('dbx_business_glossary_term' = 'Quote Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_status` SET TAGS ('dbx_business_glossary_term' = 'Quote Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_type` SET TAGS ('dbx_business_glossary_term' = 'Quote Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `registration_fee` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Registration Fee');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Quote Rejection Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `sales_channel` SET TAGS ('dbx_business_glossary_term' = 'Sales Channel');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `sales_channel` SET TAGS ('dbx_value_regex' = 'dealer|direct|online|fleet|broker');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `sales_region` SET TAGS ('dbx_business_glossary_term' = 'Sales Region Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `sales_region` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `subtotal_amount` SET TAGS ('dbx_business_glossary_term' = 'Subtotal Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Sales Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `total_amount_due` SET TAGS ('dbx_business_glossary_term' = 'Total Amount Due');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `trade_in_allowance` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Allowance Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `trade_in_payoff` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Loan Payoff Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `trade_in_payoff` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `trade_in_payoff` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `transmission_type` SET TAGS ('dbx_business_glossary_term' = 'Transmission Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `transmission_type` SET TAGS ('dbx_value_regex' = 'manual|automatic|cvt|dct|single_speed');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `trim_level` SET TAGS ('dbx_business_glossary_term' = 'Trim Level');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Quote Version Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By User');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` SET TAGS ('dbx_subdomain' = 'revenue_pipeline');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `quote_line_id` SET TAGS ('dbx_business_glossary_term' = 'Quote Line Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Msrp Schedule Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `option_package_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Option Package Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `quote_id` SET TAGS ('dbx_business_glossary_term' = 'Quote Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `availability_status` SET TAGS ('dbx_business_glossary_term' = 'Availability Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `availability_status` SET TAGS ('dbx_value_regex' = 'in_stock|allocated|build_to_order|backordered|discontinued');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `commission_eligible` SET TAGS ('dbx_business_glossary_term' = 'Commission Eligible Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `commission_rate` SET TAGS ('dbx_business_glossary_term' = 'Commission Rate');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `commission_rate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Cost Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `cost_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `extended_price` SET TAGS ('dbx_business_glossary_term' = 'Extended Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `exterior_color_code` SET TAGS ('dbx_business_glossary_term' = 'Exterior Color Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `incentive_amount` SET TAGS ('dbx_business_glossary_term' = 'Incentive Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `incentive_description` SET TAGS ('dbx_business_glossary_term' = 'Incentive Description');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `interior_color_code` SET TAGS ('dbx_business_glossary_term' = 'Interior Color Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Line Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `line_status` SET TAGS ('dbx_business_glossary_term' = 'Line Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `line_status` SET TAGS ('dbx_value_regex' = 'draft|active|approved|rejected|cancelled|converted');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `line_total` SET TAGS ('dbx_business_glossary_term' = 'Line Total');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `line_type` SET TAGS ('dbx_business_glossary_term' = 'Line Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `list_price` SET TAGS ('dbx_business_glossary_term' = 'List Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `margin_amount` SET TAGS ('dbx_business_glossary_term' = 'Margin Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `margin_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Line Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `product_code` SET TAGS ('dbx_business_glossary_term' = 'Product Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `product_description` SET TAGS ('dbx_business_glossary_term' = 'Product Description');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Quantity');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `tax_rate` SET TAGS ('dbx_business_glossary_term' = 'Tax Rate');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Unit Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `vin` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` SET TAGS ('dbx_subdomain' = 'order_fulfillment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `contact_point_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `contact_point_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `contact_point_id` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Incentive Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `production_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Production Schedule Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `committed_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Committed Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `confirmed_date` SET TAGS ('dbx_business_glossary_term' = 'Order Confirmation Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `delivery_location` SET TAGS ('dbx_business_glossary_term' = 'Delivery Location Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `delivery_location` SET TAGS ('dbx_value_regex' = 'dealer|customer_address|port|distribution_center');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `exterior_color_code` SET TAGS ('dbx_business_glossary_term' = 'Exterior Color Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `exterior_color_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,10}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `financing_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Financing Reference Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `financing_reference_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `financing_reference_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `financing_reference_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `financing_type` SET TAGS ('dbx_business_glossary_term' = 'Financing Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `financing_type` SET TAGS ('dbx_value_regex' = 'captive|third_party|bank|credit_union|none');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^FY(19|20)d{2}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `incentive_amount` SET TAGS ('dbx_business_glossary_term' = 'Incentive Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `interior_color_code` SET TAGS ('dbx_business_glossary_term' = 'Interior Color Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `interior_color_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,10}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `model_year` SET TAGS ('dbx_value_regex' = '^(19|20)d{2}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `msrp` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `order_date` SET TAGS ('dbx_business_glossary_term' = 'Order Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `order_number` SET TAGS ('dbx_business_glossary_term' = 'Order Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `order_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10,20}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `order_status` SET TAGS ('dbx_business_glossary_term' = 'Order Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `order_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Order Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `order_type` SET TAGS ('dbx_business_glossary_term' = 'Order Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `order_type` SET TAGS ('dbx_value_regex' = 'retail|fleet|government|export|demo|internal');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'cash|finance|lease|fleet_contract');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `priority_code` SET TAGS ('dbx_business_glossary_term' = 'Order Priority Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `priority_code` SET TAGS ('dbx_value_regex' = 'standard|expedited|vip|fleet_priority');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Region Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,5}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `sales_channel` SET TAGS ('dbx_business_glossary_term' = 'Sales Channel');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `sales_channel` SET TAGS ('dbx_value_regex' = 'dealer|direct|online|fleet_sales|broker');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `selling_price` SET TAGS ('dbx_business_glossary_term' = 'Selling Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Instructions');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `total_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Order Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `trade_in_value` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Value');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{5,15}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vin` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` SET TAGS ('dbx_subdomain' = 'order_fulfillment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `order_line_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Incentive Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `option_package_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Option Package Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Sales Rep Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `production_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Production Schedule Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `quote_line_id` SET TAGS ('dbx_business_glossary_term' = 'Quote Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `tertiary_order_vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `trade_in_id` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Order Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `actual_production_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Production Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `allocation_date` SET TAGS ('dbx_business_glossary_term' = 'Allocation Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `estimated_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `exterior_color_code` SET TAGS ('dbx_business_glossary_term' = 'Exterior Color Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `financing_type` SET TAGS ('dbx_business_glossary_term' = 'Financing Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `financing_type` SET TAGS ('dbx_value_regex' = 'cash|loan|lease|fleet_lease|captive_finance');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `fleet_indicator` SET TAGS ('dbx_business_glossary_term' = 'Fleet Order Indicator');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `incentive_amount` SET TAGS ('dbx_business_glossary_term' = 'Incentive Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `interior_color_code` SET TAGS ('dbx_business_glossary_term' = 'Interior Color Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Line Item Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `line_status` SET TAGS ('dbx_business_glossary_term' = 'Line Item Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `line_total` SET TAGS ('dbx_business_glossary_term' = 'Line Total Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `line_type` SET TAGS ('dbx_business_glossary_term' = 'Line Item Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `list_price` SET TAGS ('dbx_business_glossary_term' = 'List Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `model_code` SET TAGS ('dbx_business_glossary_term' = 'Model Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `net_price` SET TAGS ('dbx_business_glossary_term' = 'Net Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `product_description` SET TAGS ('dbx_business_glossary_term' = 'Product Description');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Quantity');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `ship_date` SET TAGS ('dbx_business_glossary_term' = 'Ship Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Instructions');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|SET|KIT|HR|UNIT');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`incentive_program` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`incentive_program` SET TAGS ('dbx_subdomain' = 'revenue_pipeline');
ALTER TABLE `vibe_automotive_v1`.`sales`.`incentive_program` ALTER COLUMN `incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for sales_incentive_program');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` SET TAGS ('dbx_subdomain' = 'commercial_accounts');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Sales Rep Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `dealership_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Incentive Program Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `organization_account_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Account Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `annual_mileage_allowance` SET TAGS ('dbx_business_glossary_term' = 'Annual Mileage Allowance');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Approval Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `approved_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Approved By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `approved_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `approved_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto-Renewal Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `base_discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Base Fleet Discount Percentage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `base_discount_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `committed_volume` SET TAGS ('dbx_business_glossary_term' = 'Committed Vehicle Volume');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `contract_name` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `contract_number` SET TAGS ('dbx_value_regex' = '^FC-[0-9]{8}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `contract_signed_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Signed Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `contract_status` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `contract_term_months` SET TAGS ('dbx_business_glossary_term' = 'Contract Term in Months');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_value_regex' = 'corporate|government|rental|utility|leasing|dealer_demo');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `contract_value_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Contract Value Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `delivered_volume` SET TAGS ('dbx_business_glossary_term' = 'Delivered Vehicle Volume');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `delivery_schedule_type` SET TAGS ('dbx_business_glossary_term' = 'Delivery Schedule Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `delivery_schedule_type` SET TAGS ('dbx_value_regex' = 'single_delivery|staggered|quarterly|annual|on_demand');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `eligible_model_years` SET TAGS ('dbx_business_glossary_term' = 'Eligible Model Years (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `eligible_nameplates` SET TAGS ('dbx_business_glossary_term' = 'Eligible Vehicle Nameplates');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `eligible_powertrain_types` SET TAGS ('dbx_business_glossary_term' = 'Eligible Powertrain Types');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `financing_type` SET TAGS ('dbx_business_glossary_term' = 'Fleet Financing Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `financing_type` SET TAGS ('dbx_value_regex' = 'cash_purchase|lease|captive_finance|third_party_finance|mixed');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `government_contract_flag` SET TAGS ('dbx_business_glossary_term' = 'Government Contract Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `gsa_schedule_number` SET TAGS ('dbx_business_glossary_term' = 'General Services Administration (GSA) Schedule Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `lease_term_months` SET TAGS ('dbx_business_glossary_term' = 'Lease Term in Months');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `maintenance_included_flag` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Included Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `multi_location_delivery_flag` SET TAGS ('dbx_business_glossary_term' = 'Multi-Location Delivery Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `national_fleet_account_flag` SET TAGS ('dbx_business_glossary_term' = 'National Fleet Account Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = 'net_30|net_60|net_90|prepayment|milestone|custom');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `primary_delivery_location` SET TAGS ('dbx_business_glossary_term' = 'Primary Delivery Location');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `remaining_volume` SET TAGS ('dbx_business_glossary_term' = 'Remaining Vehicle Volume');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `renewal_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Renewal Eligible Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `sales_region` SET TAGS ('dbx_business_glossary_term' = 'Sales Region');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `special_terms_notes` SET TAGS ('dbx_business_glossary_term' = 'Special Terms and Conditions Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Termination Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Contract Termination Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `volume_tier_discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Volume Tier Discount Percentage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `volume_tier_discount_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `warranty_extension_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Extension Period in Months');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` SET TAGS ('dbx_subdomain' = 'order_fulfillment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `trade_in_id` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Trade In Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `accepted_date` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Accepted Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `accident_history_flag` SET TAGS ('dbx_business_glossary_term' = 'Accident History Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `allowance` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Allowance');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `appraisal_date` SET TAGS ('dbx_business_glossary_term' = 'Appraisal Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `appraised_value` SET TAGS ('dbx_business_glossary_term' = 'Appraised Value');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `body_style` SET TAGS ('dbx_business_glossary_term' = 'Body Style');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `condition_grade` SET TAGS ('dbx_business_glossary_term' = 'Condition Grade');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `condition_grade` SET TAGS ('dbx_value_regex' = 'excellent|good|fair|poor');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `disposition_amount` SET TAGS ('dbx_business_glossary_term' = 'Disposition Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `disposition_date` SET TAGS ('dbx_business_glossary_term' = 'Disposition Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `disposition_type` SET TAGS ('dbx_business_glossary_term' = 'Disposition Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `disposition_type` SET TAGS ('dbx_value_regex' = 'wholesale_auction|certified_pre_owned|retail_resale|internal_fleet|scrap');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `exterior_color` SET TAGS ('dbx_business_glossary_term' = 'Exterior Color');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `exterior_condition` SET TAGS ('dbx_business_glossary_term' = 'Exterior Condition');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `exterior_condition` SET TAGS ('dbx_value_regex' = 'excellent|good|fair|poor');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `inspection_completed` SET TAGS ('dbx_business_glossary_term' = 'Inspection Completed Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Inspection Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `interior_color` SET TAGS ('dbx_business_glossary_term' = 'Interior Color');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `interior_condition` SET TAGS ('dbx_business_glossary_term' = 'Interior Condition');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `interior_condition` SET TAGS ('dbx_value_regex' = 'excellent|good|fair|poor');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `lien_holder` SET TAGS ('dbx_business_glossary_term' = 'Lien Holder');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `lien_holder` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `make` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Make');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `mechanical_condition` SET TAGS ('dbx_business_glossary_term' = 'Mechanical Condition');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `mechanical_condition` SET TAGS ('dbx_value_regex' = 'excellent|good|fair|poor');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `model` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Model');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `odometer_reading` SET TAGS ('dbx_business_glossary_term' = 'Odometer Reading');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `odometer_unit` SET TAGS ('dbx_business_glossary_term' = 'Odometer Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `odometer_unit` SET TAGS ('dbx_value_regex' = 'miles|kilometers');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `outstanding_loan_balance` SET TAGS ('dbx_business_glossary_term' = 'Outstanding Loan Balance');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `outstanding_loan_balance` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `outstanding_loan_balance` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ice|hev|phev|bev|fcev');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `reconditioning_cost` SET TAGS ('dbx_business_glossary_term' = 'Reconditioning Cost');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `service_records_available` SET TAGS ('dbx_business_glossary_term' = 'Service Records Available Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `tire_condition` SET TAGS ('dbx_business_glossary_term' = 'Tire Condition');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `tire_condition` SET TAGS ('dbx_value_regex' = 'excellent|good|fair|poor');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `title_status` SET TAGS ('dbx_business_glossary_term' = 'Title Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `title_status` SET TAGS ('dbx_value_regex' = 'clean|salvage|rebuilt|lemon|flood');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `trade_in_number` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Transaction Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `transmission_type` SET TAGS ('dbx_business_glossary_term' = 'Transmission Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `transmission_type` SET TAGS ('dbx_value_regex' = 'manual|automatic|cvt|dct');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `trim_level` SET TAGS ('dbx_business_glossary_term' = 'Trim Level');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` SET TAGS ('dbx_subdomain' = 'order_fulfillment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Appointment Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `finished_vehicle_stock_id` SET TAGS ('dbx_business_glossary_term' = 'Finished Vehicle Stock Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `technician_id` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Technician Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Specialist Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `rescheduled_from_delivery_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Rescheduled From Appointment Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `rescheduled_from_delivery_appointment_id` SET TAGS ('dbx_self_reference' = 'rescheduled_from');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `trade_in_id` SET TAGS ('dbx_business_glossary_term' = 'Trade In Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `actual_delivery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `appointment_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Appointment Duration in Minutes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `appointment_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Appointment Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `appointment_number` SET TAGS ('dbx_value_regex' = '^DA-[0-9]{8}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `appointment_status` SET TAGS ('dbx_business_glossary_term' = 'Appointment Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `connected_services_activated` SET TAGS ('dbx_business_glossary_term' = 'Connected Services Activated Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Created By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `customer_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Customer Arrival Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `customer_confirmation_status` SET TAGS ('dbx_business_glossary_term' = 'Customer Confirmation Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `customer_confirmation_status` SET TAGS ('dbx_value_regex' = 'pending|confirmed|declined|no_response');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `customer_confirmed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Customer Confirmation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_address_line1` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address Line 1');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_address_line2` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address Line 2');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_city` SET TAGS ('dbx_business_glossary_term' = 'Delivery City');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_country_code` SET TAGS ('dbx_business_glossary_term' = 'Delivery Country Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_location_type` SET TAGS ('dbx_business_glossary_term' = 'Delivery Location Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_location_type` SET TAGS ('dbx_value_regex' = 'dealership|customer_home|fleet_depot|distribution_center|direct_delivery_hub|other');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_postal_code` SET TAGS ('dbx_business_glossary_term' = 'Delivery Postal Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_satisfaction_score` SET TAGS ('dbx_business_glossary_term' = 'Delivery Satisfaction Score');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_state_province` SET TAGS ('dbx_business_glossary_term' = 'Delivery State or Province');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_state_province` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_type` SET TAGS ('dbx_business_glossary_term' = 'Delivery Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_type` SET TAGS ('dbx_value_regex' = 'standard|express|white_glove|fleet|commercial');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `digital_owner_manual_sent` SET TAGS ('dbx_business_glossary_term' = 'Digital Owner Manual Sent Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `documentation_status` SET TAGS ('dbx_business_glossary_term' = 'Documentation Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `documentation_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|incomplete');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `financing_status` SET TAGS ('dbx_business_glossary_term' = 'Financing Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `financing_status` SET TAGS ('dbx_value_regex' = 'not_applicable|pending|approved|funded|declined');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `handover_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Handover Duration in Minutes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `last_reminder_sent_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Reminder Sent Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `modified_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Modified By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `modified_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `modified_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `pdi_completed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Completion Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `pdi_status` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `pdi_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|failed|waived');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `reminder_sent_count` SET TAGS ('dbx_business_glossary_term' = 'Reminder Sent Count');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `scheduled_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `scheduled_delivery_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Time');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Instructions');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `trade_in_status` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `trade_in_status` SET TAGS ('dbx_value_regex' = 'not_applicable|pending_appraisal|appraised|accepted|declined|completed');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vehicle_orientation_completed` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Orientation Completed Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vehicle_preparation_status` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Preparation Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vehicle_preparation_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|on_hold');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vin` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` SET TAGS ('dbx_subdomain' = 'commercial_accounts');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `telemetry_event_id` SET TAGS ('dbx_business_glossary_term' = 'Telemetry Event Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Driver Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `dealership_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `individual_id` SET TAGS ('dbx_business_glossary_term' = 'Driver Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `altitude` SET TAGS ('dbx_business_glossary_term' = 'Altitude (Meters)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `battery_soc_percent` SET TAGS ('dbx_business_glossary_term' = 'Battery State of Charge (SOC) Percentage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `battery_voltage_volt` SET TAGS ('dbx_business_glossary_term' = 'Battery Voltage (V)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `charging_status` SET TAGS ('dbx_business_glossary_term' = 'Charging Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `connectivity_status` SET TAGS ('dbx_business_glossary_term' = 'Connectivity Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `engine_rpm` SET TAGS ('dbx_business_glossary_term' = 'Engine Revolutions Per Minute (RPM)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `engine_temperature_c` SET TAGS ('dbx_business_glossary_term' = 'Engine Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `event_sequence` SET TAGS ('dbx_business_glossary_term' = 'Event Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `event_source` SET TAGS ('dbx_business_glossary_term' = 'Event Source System');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `event_type_code` SET TAGS ('dbx_business_glossary_term' = 'Event Type Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `firmware_version` SET TAGS ('dbx_business_glossary_term' = 'Device Firmware Version');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `fuel_level_percent` SET TAGS ('dbx_business_glossary_term' = 'Fuel Level Percentage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `gps_accuracy_m` SET TAGS ('dbx_business_glossary_term' = 'GPS Accuracy (Meters)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `heading_degrees` SET TAGS ('dbx_business_glossary_term' = 'Heading (Degrees)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `ignition_state` SET TAGS ('dbx_business_glossary_term' = 'Ignition State');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude (Degrees)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `latitude_accuracy` SET TAGS ('dbx_business_glossary_term' = 'Latitude Accuracy (Meters)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `latitude_accuracy` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `latitude_accuracy` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `location_city` SET TAGS ('dbx_business_glossary_term' = 'Location City');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `location_city` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `location_country` SET TAGS ('dbx_business_glossary_term' = 'Location Country (ISO 3166‑1 Alpha‑3)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `location_state` SET TAGS ('dbx_business_glossary_term' = 'Location State/Province');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude (Degrees)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `longitude_accuracy` SET TAGS ('dbx_business_glossary_term' = 'Longitude Accuracy (Meters)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `longitude_accuracy` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `longitude_accuracy` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `odometer_km` SET TAGS ('dbx_business_glossary_term' = 'Odometer Reading (km)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `raw_payload` SET TAGS ('dbx_business_glossary_term' = 'Raw Telemetry Payload');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `signal_quality` SET TAGS ('dbx_business_glossary_term' = 'Signal Quality Indicator');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `speed_kph` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Speed (km/h)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `tire_pressure_front_left_psi` SET TAGS ('dbx_business_glossary_term' = 'Front Left Tire Pressure (psi)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `tire_pressure_front_right_psi` SET TAGS ('dbx_business_glossary_term' = 'Front Right Tire Pressure (psi)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `tire_pressure_rear_left_psi` SET TAGS ('dbx_business_glossary_term' = 'Rear Left Tire Pressure (psi)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`telemetry_event` ALTER COLUMN `tire_pressure_rear_right_psi` SET TAGS ('dbx_business_glossary_term' = 'Rear Right Tire Pressure (psi)');
