-- Schema for Domain: sales | Business: Automotive | Version: v2_mvm
-- Generated on: 2026-07-13 17:05:59

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`sales` COMMENT 'Sales operations including lead management, opportunity tracking, quote generation, order capture, and sales performance analytics. Manages MSRP (Manufacturer Suggested Retail Price), incentive programs, fleet sales, and commercial vehicle contracts. Tracks sales pipeline, conversion rates, and regional sales performance. Integrates with dealer networks and Salesforce Automotive Cloud for unified sales execution across direct and indirect channels. Interfaces with SAP SD.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`opportunity` (
    `opportunity_id` BIGINT COMMENT 'Unique identifier for the sales opportunity record. Primary key.',
    `configuration_id` BIGINT COMMENT '',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership managing this opportunity.',
    `incentive_program_id` BIGINT COMMENT 'Foreign key linking to sales.sales_incentive_program. Business justification: An opportunity in automotive sales is frequently associated with an OEM-sponsored incentive program (e.g., customer cash rebate, conquest bonus) that influences the deal. opportunity already carries i',
    `party_id` BIGINT COMMENT 'Reference to the prospect or customer associated with this opportunity.',
    `model_id` BIGINT COMMENT 'Reference to the specific vehicle configuration or model of interest for this opportunity.',
    `organization_account_id` BIGINT COMMENT 'Foreign key linking to customer.organization_account. Business justification: B2B/fleet sales pipeline management requires linking opportunities to organization_account to access credit_limit, fleet_size, payment_terms, and preferred_oem_programs for commercial opportunity qual',
    `primary_model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Opportunity tracking by model enables sales forecasting, market analysis, and model performance dashboards.',
    `primary_party_id` BIGINT COMMENT 'Reference to the prospect or customer associated with this opportunity.',
    `vehicle_order_id` BIGINT COMMENT '',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Required for Opportunity Management report to align sales opportunities with engineering program schedules, ensuring capacity planning.',
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
    `incentive_amount` DECIMAL(18,2) COMMENT 'Total manufacturer incentive amount applicable to this opportunity.',
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
    `number` STRING COMMENT 'Business-facing unique identifier for the opportunity, typically auto-generated and used in communications with dealers and sales teams.. Valid values are `^OPP-[0-9]{8}$`',
    `opportunity_type` STRING COMMENT 'Classification of the opportunity based on customer segment and purchase type.. Valid values are `retail|fleet|commercial|government|employee_purchase|demo`',
    `powertrain_type` STRING COMMENT 'Type of powertrain for the vehicle of interest: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), FCEV (Fuel Cell Electric Vehicle).. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `priority` STRING COMMENT 'Priority level assigned to this opportunity based on strategic importance, deal size, or customer value.. Valid values are `low|medium|high|critical`',
    `probability` DECIMAL(18,2) COMMENT 'Estimated probability of closing this opportunity successfully, expressed as a percentage (0-100).',
    `quote_date` DATE COMMENT 'Date when the quote was generated, if applicable.',
    `quote_generated` BOOLEAN COMMENT 'Indicates whether a formal quote has been generated for this opportunity.',
    `region` STRING COMMENT 'Geographic sales region where this opportunity is being managed.',
    `sales_stage` STRING COMMENT 'Current stage of the opportunity in the sales pipeline, reflecting progression from initial contact through close. [ENUM-REF-CANDIDATE: lead|qualification|needs_analysis|test_drive|quote|negotiation|closed_won|closed_lost — 8 candidates stripped; promote to reference product]',
    `ssot_governance_note` STRING COMMENT '',
    `territory` STRING COMMENT 'Sales territory within the region where this opportunity is being managed.',
    `test_drive_completed` BOOLEAN COMMENT 'Indicates whether the prospect has completed a test drive for the vehicle of interest.',
    `test_drive_date` DATE COMMENT 'Date when the test drive was completed, if applicable.',
    `trade_in_value` DECIMAL(18,2) COMMENT 'Appraised value of the customers trade-in vehicle, if applicable.',
    `vehicle_configuration` STRING COMMENT 'Detailed configuration of the vehicle including trim level, options, and packages.',
    `win_reason` STRING COMMENT 'Primary reason why the opportunity was won, if applicable. [ENUM-REF-CANDIDATE: price|product_features|brand_loyalty|service|financing|relationship|other — 7 candidates stripped; promote to reference product]',
    CONSTRAINT pk_opportunity PRIMARY KEY(`opportunity_id`)
) COMMENT 'Core sales opportunity record tracking a potential vehicle sale from initial identification through close. Captures prospect vehicle interest, estimated deal value, probability of close, sales stage, assigned sales representative, source channel, and expected close date. Aligns with Salesforce Automotive Cloud Opportunity object and SAP SD pre-sales pipeline. Covers retail, fleet, and commercial vehicle opportunities.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`quote` (
    `quote_id` BIGINT COMMENT 'Primary key for quote',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Quotes in automotive are issued by a specific legal entity for VAT/tax document generation, revenue recognition, and intercompany billing. A domain expert expects every quote to identify the issuing c',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_configuration. Business justification: Quote must be tied to a specific vehicle configuration to calculate options, OTA updates, and compliance; supports configuration‑based pricing.',
    `finished_vehicle_stock_id` BIGINT COMMENT 'Foreign key linking to inventory.finished_vehicle_stock. Business justification: Stock vehicle quoting and soft reservation: when a dealer quotes a customer on an in-stock vehicle, the quote must reference the specific finished vehicle stock record to reflect current availability,',
    `fleet_contract_id` BIGINT COMMENT 'Foreign key linking to sales.fleet_contract. Business justification: Fleet vehicle quotes are generated against an existing fleet contract that governs pricing, discount tiers, and eligible models. A quote issued to a fleet customer should reference the governing fleet',
    `incentive_program_id` BIGINT COMMENT 'Foreign key linking to sales.sales_incentive_program. Business justification: A vehicle sales quote is built against a specific OEM incentive program that determines the incentive_total presented to the customer. quote carries incentive_total but has no FK to the authoritative ',
    `dealer_inventory_id` BIGINT COMMENT 'Foreign key linking to dealer.dealer_inventory. Business justification: When a quote is written against a specific in-stock lot vehicle, the quote must reference the dealer_inventory record to lock the unit and prevent double-selling. This is standard DMS-to-CRM integrati',
    `opportunity_id` BIGINT COMMENT 'Reference to the sales opportunity or lead that generated this quote. Tracks quote back to pipeline stage in Salesforce Automotive Cloud.',
    `organization_account_id` BIGINT COMMENT 'Foreign key linking to customer.organization_account. Business justification: Commercial/fleet quote generation requires referencing organization_account for credit limit validation, payment terms, and preferred OEM program pricing. Finance and sales ops teams run quote-to-acco',
    `powertrain_spec_id` BIGINT COMMENT 'Foreign key linking to engineering.powertrain_spec. Business justification: Sales quoting requires validated powertrain specs (range, emissions, power output) for regulatory disclosures (EU CO2 labeling) and accurate customer-facing specs. The quote.powertrain_type plain stri',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership or direct sales channel issuing the quote. Links to dealer master data in CDK Global DMS or SAP.',
    `party_id` BIGINT COMMENT 'Reference to the customer or prospect receiving this quote. Links to customer master data in SAP or Salesforce Automotive Cloud.',
    `quote_customer_party_id` BIGINT COMMENT 'Reference to the customer or prospect receiving this quote. Links to customer master data in SAP or Salesforce Automotive Cloud.',
    `quote_dealer_dealership_id` BIGINT COMMENT 'Reference to the dealership or direct sales channel issuing the quote. Links to dealer master data in CDK Global DMS or SAP.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Required for Quote generation to reference the exact vehicle model, ensuring pricing consistency and enabling model‑level reporting.',
    `quote_trim_level_model_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_trim_level. Business justification: Quote-to-trim-level binding: automotive quotes are built around specific trim levels for accurate pricing and feature presentation. Direct FK to vehicle_trim_level enables trim-level sales mix reporti',
    `vehicle_order_id` BIGINT COMMENT 'Reference to the sales order created from this quote if converted_to_order is true. Links quote to order for fulfillment tracking.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle configuration being quoted. Links to vehicle master data including model, trim, powertrain, and options.',
    `warranty_policy_id` BIGINT COMMENT 'Foreign key linking to aftersales.warranty_policy. Business justification: Sales quotes must disclose warranty terms per Magnuson-Moss Warranty Act and equivalent regulations. Linking quote to warranty_policy ensures accurate warranty coverage disclosure on the quote documen',
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
    `number` STRING COMMENT 'Externally visible business identifier for the quote, typically generated by SAP SD (VA21) or Salesforce Automotive Cloud. Used for customer communication and dealer reference.. Valid values are `^[A-Z0-9]{8,20}$`',
    `options_total` DECIMAL(18,2) COMMENT 'Total value of factory-installed options and packages selected by customer (e.g., ADAS, premium audio, sunroof). Sum of individual option prices.',
    `quote_date` DATE COMMENT 'Date when the quote was issued to the customer or prospect. Represents the principal business event timestamp for this transaction.',
    `quote_status` STRING COMMENT 'Current lifecycle status of the quote. Tracks progression from draft through approval to conversion or expiry. [ENUM-REF-CANDIDATE: draft|submitted|approved|rejected|expired|converted|cancelled — 7 candidates stripped; promote to reference product]',
    `quote_type` STRING COMMENT 'Classification of quote by sales channel and vehicle delivery format. Retail for individual consumers, fleet for corporate bulk orders, CKD (Completely Knocked Down) and SKD (Semi Knocked Down) for export assembly, commercial for business vehicles, demo for demonstration units. [ENUM-REF-CANDIDATE: retail|fleet|ckd|skd|commercial|demo|export — 7 candidates stripped; promote to reference product]',
    `registration_fee` DECIMAL(18,2) COMMENT 'Government registration and title fees for the vehicle. Varies by state/province and vehicle type.',
    `rejection_reason` STRING COMMENT 'Free-text reason why quote was rejected or not converted. Captured for loss analysis and sales process improvement.',
    `sales_channel` STRING COMMENT 'Channel through which quote was generated. Dealer for franchise network, direct for OEM-owned stores, online for digital sales, fleet for corporate accounts, broker for third-party intermediaries.. Valid values are `dealer|direct|online|fleet|broker`',
    `sales_region` STRING COMMENT 'Geographic sales region code where quote was issued. Used for regional pricing, incentive eligibility, and sales performance tracking.. Valid values are `^[A-Z]{2,3}$`',
    `ssot_governance_note` STRING COMMENT '',
    `subtotal_amount` DECIMAL(18,2) COMMENT 'Subtotal before incentives, trade-in, taxes, and fees. Calculated as msrp_base + options_total + accessories_total + destination_charge.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total sales tax calculated on net_selling_price based on customer delivery location jurisdiction. May include state, county, and local taxes.',
    `total_amount_due` DECIMAL(18,2) COMMENT 'Final total amount customer must pay. Calculated as net_selling_price + tax_amount + registration_fee + doc_fee. Used for financing calculation or cash payment.',
    `trade_in_allowance` DECIMAL(18,2) COMMENT 'Value credited to customer for trade-in vehicle. Based on used vehicle appraisal. Reduces amount due from customer.',
    `trade_in_payoff` DECIMAL(18,2) COMMENT 'Outstanding loan balance on trade-in vehicle that must be paid off. If greater than trade_in_allowance, creates negative equity rolled into new financing.',
    `trade_in_vin` STRING COMMENT 'VIN of the customers trade-in vehicle if applicable. Used for appraisal lookup and title transfer processing.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `transmission_type` STRING COMMENT 'Type of transmission: manual, automatic, CVT (Continuously Variable Transmission), DCT (Dual Clutch Transmission), or single-speed (for EVs).. Valid values are `manual|automatic|cvt|dct|single_speed`',
    `version` STRING COMMENT 'Version number of the quote. Increments when quote is revised with updated pricing, configuration, or terms. Supports quote revision history and audit trail.',
    `vin` STRING COMMENT '17-character Vehicle Identification Number if quote is for a specific in-stock or allocated vehicle. Null for build-to-order quotes where VIN is not yet assigned.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `created_by` STRING COMMENT 'User ID or name of the person who created this quote record. Audit trail for accountability.',
    CONSTRAINT pk_quote PRIMARY KEY(`quote_id`)
) COMMENT 'Formal vehicle sales quotation issued to a prospect or customer, detailing configured vehicle, MSRP, applied incentives, trade-in allowance, financing terms, accessories, and net selling price. Tracks quote version, expiry date, quote status, and issuing dealer or direct sales channel. Supports retail, fleet, and CKD/SKD export quotes. Linked to SAP SD quotation (VA21) and Salesforce Automotive Cloud Quote.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`quote_line` (
    `quote_line_id` BIGINT COMMENT 'Unique identifier for the quote line item. Primary key.',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_option_package. Business justification: Quote line for an option package should reference the canonical package entity for accurate pricing, warranty, and regulatory compliance.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Quote line items in automotive represent vehicles, accessories, and options — each mapping to a GL account for revenue type classification (vehicle revenue, accessory revenue, options revenue). This s',
    `incentive_program_id` BIGINT COMMENT 'Foreign key linking to sales.sales_incentive_program. Business justification: Individual quote line items in automotive sales can carry line-level incentives (e.g., accessory bundle rebate, powertrain-specific cash back) tied to a specific incentive program. quote_line has ince',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Quote line items need to reference the official MSRP schedule for the selected configuration; adding msrp_schedule_id eliminates redundant MSRP columns and enables consistent pricing lookup.',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Needed for Pricing Engine to pull cost, lead time, and compliance from Part Master when generating quotes.',
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
    `list_price` DECIMAL(18,2) COMMENT 'Manufacturer Suggested Retail Price (MSRP) or standard list price for the line item before any discounts or incentives. Expressed in the quote currency.',
    `margin_amount` DECIMAL(18,2) COMMENT 'Gross margin for this line item. Calculated as extended_price - cost_amount. Used for profitability analysis and sales performance evaluation.',
    `model_year` STRING COMMENT 'Model year of the vehicle being quoted. Critical for pricing, incentive eligibility, and inventory allocation. Aligns with manufacturer production cycles.',
    `modified_by` STRING COMMENT 'User identifier of the person who last modified this quote line. Supports change tracking and audit requirements.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to this quote line. Recorded in ISO 8601 format with timezone. Used for change tracking and audit trail.',
    `notes` STRING COMMENT 'Free-text notes and comments specific to this line item. Used for special instructions, configuration details, customer requests, or internal coordination.',
    `number` STRING COMMENT 'Sequential line item number within the quote. Determines the ordering and display sequence of line items.',
    `product_code` STRING COMMENT 'Stock Keeping Unit (SKU) or product code for accessories, service packages, warranties, or other non-vehicle line items. Links to product master for pricing and availability.',
    `product_description` STRING COMMENT 'Detailed description of the line item product or service. Includes accessory names, service package details, warranty coverage terms, or fee descriptions for customer clarity.',
    `quantity` STRING COMMENT 'Number of units for this line item. Typically 1 for vehicles, but may be greater than 1 for accessories, fleet orders, or service packages.',
    `quote_line_status` STRING COMMENT 'Current lifecycle status of the quote line. Tracks the line through draft, approval, conversion to order, or cancellation workflows.. Valid values are `draft|active|approved|rejected|cancelled|converted`',
    `quote_line_type` STRING COMMENT 'Classification of the quote line item. Distinguishes between vehicle configurations, accessories, service packages, warranties, insurance products, fees, discounts, and trade-in credits. [ENUM-REF-CANDIDATE: vehicle|accessory|service_package|warranty|insurance|fee|discount|trade_in — 8 candidates stripped; promote to reference product]',
    `rejection_reason` STRING COMMENT 'Explanation for why this line item was rejected or removed from the quote. Captures business reasons such as unavailability, pricing issues, or customer preference changes.',
    `ssot_governance_note` STRING COMMENT '',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total sales tax calculated for this line item. Calculated as extended_price * tax_rate. Contributes to the overall quote tax total.',
    `tax_code` STRING COMMENT 'Tax jurisdiction code determining the applicable sales tax rate for this line item. Links to tax master for rate lookup and tax calculation rules.',
    `tax_rate` DECIMAL(18,2) COMMENT 'Sales tax rate applied to this line item, expressed as a decimal (e.g., 0.0825 for 8.25%). Used for tax calculation and compliance reporting.',
    `total` DECIMAL(18,2) COMMENT 'Total amount for this line item including tax. Calculated as extended_price + tax_amount. Represents the final customer-facing line total.',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the line item quantity. Common values include each (vehicles, accessories), set, pair, kit, hour (labor), month/year (subscriptions, warranties). [ENUM-REF-CANDIDATE: each|set|pair|kit|hour|month|year — 7 candidates stripped; promote to reference product]',
    `unit_price` DECIMAL(18,2) COMMENT 'Actual selling price per unit after dealer adjustments but before line-level discounts and incentives. May differ from list price due to market conditions or dealer pricing strategy.',
    `vin` STRING COMMENT '17-character Vehicle Identification Number uniquely identifying a specific vehicle unit. Populated when quoting a specific in-stock or allocated vehicle. Null for build-to-order quotes.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `created_by` STRING COMMENT 'User identifier of the sales representative or system user who created this quote line. Used for audit trail and accountability.',
    CONSTRAINT pk_quote_line PRIMARY KEY(`quote_line_id`)
) COMMENT 'Individual line item within a vehicle sales quote, representing a specific vehicle configuration, accessory, service package, or fee. Captures line type, configured model code, option packages, unit price, discount amount, incentive applied, and line-level tax. Enables multi-vehicle fleet quotes and accessory bundling. Child entity of quote.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` (
    `vehicle_order_id` BIGINT COMMENT '',
    `company_code_id` BIGINT COMMENT '',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.configuration. Business justification: Order-to-configuration binding: vehicle orders are placed against a specific configuration (model+trim+options). Direct FK enables production scheduling, build-to-order reporting, and configuration-le',
    `contact_point_id` BIGINT COMMENT '',
    `cost_center_id` BIGINT COMMENT '',
    `dealership_id` BIGINT COMMENT '',
    `incentive_program_id` BIGINT COMMENT 'Foreign key linking to sales.sales_incentive_program. Business justification: A confirmed vehicle purchase order is tied to the OEM incentive program under which it was sold. vehicle_order carries incentive_amount but has no FK to the authoritative sales_incentive_program recor',
    `model_id` BIGINT COMMENT '',
    `plant_id` BIGINT COMMENT '',
    `powertrain_spec_id` BIGINT COMMENT 'Foreign key linking to engineering.powertrain_spec. Business justification: Vehicle orders must reference the exact engineering powertrain_spec to support production scheduling, regulatory CO2-per-vehicle-sold reporting, and warranty registration. The plain powertrain_type st',
    `party_id` BIGINT COMMENT '',
    `organization_account_id` BIGINT COMMENT 'Foreign key linking to customer.customer_fleet_account. Business justification: Fleet order management requires direct vehicle_order→customer_fleet_account linkage to track committed vs. delivered volume per fleet account, apply fleet discounts, and report fleet program complianc',
    `vehicle_organization_account_id` BIGINT COMMENT 'Foreign key linking to customer.organization_account. Business justification: Fleet/commercial vehicle orders must reference organization_account for SAP customer number reconciliation, credit limit enforcement, and payment terms application. AR and fleet operations teams requi',
    `actual_delivery_date` DATE COMMENT '',
    `build_week` STRING COMMENT '',
    `cancellation_reason` STRING COMMENT '',
    `committed_delivery_date` DATE COMMENT '',
    `confirmed_date` DATE COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `currency_code` STRING COMMENT '',
    `delivery_location` STRING COMMENT '',
    `discount_amount` DECIMAL(18,2) COMMENT '',
    `exterior_color_code` STRING COMMENT '',
    `field_service_package_flag` BOOLEAN COMMENT '',
    `financing_reference_number` STRING COMMENT '',
    `financing_type` STRING COMMENT '',
    `fiscal_year` STRING COMMENT '',
    `incentive_amount` DECIMAL(18,2) COMMENT '',
    `interior_color_code` STRING COMMENT '',
    `model_year` STRING COMMENT '',
    `msrp` DECIMAL(18,2) COMMENT '',
    `number` STRING COMMENT '',
    `payment_method` STRING COMMENT '',
    `priority_code` STRING COMMENT '',
    `production_plant_code` STRING COMMENT '',
    `region_code` STRING COMMENT '',
    `requested_delivery_date` DATE COMMENT '',
    `sales_channel` STRING COMMENT '',
    `selling_price` DECIMAL(18,2) COMMENT '',
    `special_instructions` STRING COMMENT '',
    `tax_amount` DECIMAL(18,2) COMMENT '',
    `timestamp` TIMESTAMP COMMENT '',
    `total_amount` DECIMAL(18,2) COMMENT '',
    `trade_in_value` DECIMAL(18,2) COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT '',
    `vehicle_order_date` DATE COMMENT '',
    `vehicle_order_status` STRING COMMENT '',
    `vehicle_order_type` STRING COMMENT '',
    `vin` STRING COMMENT '',
    CONSTRAINT pk_vehicle_order PRIMARY KEY(`vehicle_order_id`)
) COMMENT 'Confirmed customer vehicle purchase order capturing the commercial commitment to buy a specific configured vehicle. Records order type (retail, fleet, government, export), ordered VIN or build-to-order configuration, agreed selling price, payment method, financing reference, delivery commitment date, and order status lifecycle (placed, confirmed, in-production, shipped, delivered). Interfaces with SAP SD sales order (VA01) and triggers manufacturing scheduling.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`order_line` (
    `order_line_id` BIGINT COMMENT 'Unique identifier for the order line item. Primary key for the order_line product.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership responsible for this order line. Links to dealer network and channel management.',
    `finished_vehicle_stock_id` BIGINT COMMENT 'Foreign key linking to inventory.finished_vehicle_stock. Business justification: Vehicle allocation process: automotive OEMs and dealers allocate a specific finished vehicle stock unit to a sales order line. This link supports allocation reporting, stock aging analysis, and ensure',
    `fleet_contract_id` BIGINT COMMENT 'Reference to the fleet sales contract or commercial vehicle agreement governing this line item. Null for retail orders.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Revenue Posting: every order line maps to a GL account to generate journal entries for recognized revenue.',
    `incentive_program_id` BIGINT COMMENT 'Foreign key linking to sales.sales_incentive_program. Business justification: Order line items in fleet and retail vehicle orders can be associated with specific incentive programs at the line level (e.g., fleet discount program, accessory incentive). order_line carries incenti',
    `configuration_id` BIGINT COMMENT 'Reference to the detailed vehicle configuration record capturing all selected options, packages, and specifications for this order line.',
    `order_option_package_configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_option_package. Business justification: Order line must reference option package entity to drive production planning, parts allocation, and warranty tracking.',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Production scheduling uses Order Line to retrieve Part Master details for manufacturing execution.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Line‑level accountability requires the employee responsible for each order line.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle master record when line_type is vehicle. Links to vehicle configuration and specifications.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Parts and accessories order fulfillment: order lines for non-vehicle items (accessories, service parts) must reference the inventory SKU master for pricing, availability, and warehouse fulfillment. Au',
    `trade_in_id` BIGINT COMMENT 'Reference to the trade-in vehicle appraisal record if this order line includes a trade-in transaction. Null if no trade-in.',
    `vehicle_allocation_id` BIGINT COMMENT 'Foreign key linking to dealer.vehicle_allocation. Business justification: An order line for a specific vehicle must reference the dealer vehicle_allocation record that fulfills it — this is the core allocation-to-order traceability used in production scheduling, dealer inve',
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
    `list_price` DECIMAL(18,2) COMMENT 'Manufacturer Suggested Retail Price (MSRP) or catalog list price per unit before any discounts or incentives.',
    `model_code` STRING COMMENT 'Manufacturer model code identifying the vehicle platform, body style, and base configuration. Used for production planning and parts allocation.',
    `model_year` STRING COMMENT 'Model year designation for the vehicle. Represents the production year classification, not the calendar year of manufacture.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this order line record was last modified. Updated whenever any attribute changes.',
    `net_price` DECIMAL(18,2) COMMENT 'Net unit price after applying all discounts and incentives but before taxes and fees. Calculated as list_price minus discount_amount minus incentive_amount.',
    `number` STRING COMMENT 'Sequential line item number within the parent order. Determines display and processing sequence.',
    `order_line_status` STRING COMMENT 'Current fulfillment status of this order line. Tracks progression from order capture through delivery or cancellation. [ENUM-REF-CANDIDATE: open|allocated|in_production|shipped|delivered|cancelled|on_hold — 7 candidates stripped; promote to reference product]',
    `order_line_type` STRING COMMENT 'Classification of the order line item indicating whether it represents a vehicle unit, accessory, warranty product, service contract, parts, freight charge, or documentation fee. [ENUM-REF-CANDIDATE: vehicle|accessory|extended_warranty|service_contract|parts|freight|documentation_fee — 7 candidates stripped; promote to reference product]',
    `powertrain_type` STRING COMMENT 'Type of powertrain system. ICE=Internal Combustion Engine, HEV=Hybrid Electric Vehicle, PHEV=Plug-in Hybrid Electric Vehicle, BEV=Battery Electric Vehicle, FCEV=Fuel Cell Electric Vehicle.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `product_description` STRING COMMENT 'Human-readable description of the line item product or service. Provides business context for reporting and customer documentation.',
    `quantity` DECIMAL(18,2) COMMENT 'Ordered quantity for this line item. Typically 1 for vehicle units, may be greater than 1 for accessories, parts, or fleet orders.',
    `scheduled_production_date` DATE COMMENT 'Planned Start of Production (SOP) date for this vehicle unit. Applicable only for build-to-order vehicles.',
    `ship_date` DATE COMMENT 'Date when the line item was shipped from the manufacturing plant or distribution center to the dealer or customer.',
    `special_instructions` STRING COMMENT 'Free-text field capturing any special handling instructions, customer requests, or delivery notes specific to this order line.',
    `ssot_governance_note` STRING COMMENT '',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount for this line item including sales tax, value-added tax, and any applicable excise taxes.',
    `total` DECIMAL(18,2) COMMENT 'Total amount for this line item including net price, taxes, and fees. Calculated as (net_price * quantity) plus tax_amount.',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the quantity field. EA=Each, SET=Set, KIT=Kit, HR=Hour (for service contracts), UNIT=Unit.. Valid values are `EA|SET|KIT|HR|UNIT`',
    `vin` STRING COMMENT '17-character Vehicle Identification Number assigned to this line item when available. May be null at order capture and populated during production allocation. Uniquely identifies the physical vehicle unit.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_order_line PRIMARY KEY(`order_line_id`)
) COMMENT 'Individual line item within a vehicle order representing a specific vehicle unit, accessory, extended warranty, or service contract. Captures VIN assignment (when available), model code, trim level, exterior/interior color, option packages, unit net price, quantity, and line fulfillment status. Supports multi-unit fleet orders with individual VIN-level tracking per line.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`incentive_program` (
    `incentive_program_id` BIGINT COMMENT '',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Incentive programs in multi-brand automotive groups are administered by specific legal entities for intercompany cost allocation and regulatory compliance. A finance manager expects each incentive pro',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Incentive programs are funded from specific cost centers in automotive finance for marketing/sales budget control and variance reporting. A sales finance manager expects every incentive program to be ',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Incentive program accruals and payouts are posted to dedicated GL accounts in automotive accounting (e.g., sales incentive expense accounts). A controller expects every incentive program to map to a G',
    `powertrain_spec_id` BIGINT COMMENT 'Foreign key linking to engineering.powertrain_spec. Business justification: Government EV/hybrid incentive programs (e.g., IRA tax credits, EU EV subsidies) are scoped to specific powertrain specs meeting battery capacity or range thresholds defined in engineering. Linking sa',
    `vehicle_program_id` BIGINT COMMENT '',
    `amount` DECIMAL(18,2) COMMENT '',
    `budget_allocated` DECIMAL(18,2) COMMENT '',
    `budget_amount` DECIMAL(18,2) COMMENT '',
    `currency_code` STRING COMMENT '',
    `dummy_flag` BIGINT COMMENT 'Placeholder attribute added to satisfy target entity mutation.',
    `eligibility_criteria` STRING COMMENT '',
    `end_date` DATE COMMENT '',
    `field_service_bonus_eligible_flag` BOOLEAN COMMENT '',
    `incentive_amount` DECIMAL(18,2) COMMENT '',
    `program_name` STRING COMMENT '',
    `program_status` STRING COMMENT '',
    `program_type` STRING COMMENT '',
    `sales_incentive_program_description` STRING COMMENT '',
    `sales_incentive_program_name` STRING COMMENT '',
    `sales_incentive_program_status` STRING COMMENT '',
    `sales_incentive_program_type` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT '',
    `start_date` DATE COMMENT '',
    `target_region` STRING COMMENT '',
    CONSTRAINT pk_incentive_program PRIMARY KEY(`incentive_program_id`)
) COMMENT 'Master record for OEM-sponsored sales incentive programs including customer cash rebates, dealer cash allowances, low-APR financing offers, lease support, conquest bonuses, loyalty rewards, and fleet incentives. Captures program code, program type, eligible model year and nameplate, start and end dates, maximum incentive amount, funding source (OEM vs regional), stackability rules, and eligibility criteria. Managed centrally and distributed to dealer network.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` (
    `fleet_contract_id` BIGINT COMMENT 'Unique identifier for the fleet contract. Primary key for the fleet contract entity.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Fleet contracts in multi-brand automotive groups are issued by a specific legal entity for revenue recognition, intercompany settlement, and regulatory compliance. A domain expert expects fleet contra',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Fleet contracts in automotive corporate/government sales are assigned to cost centers for fleet expense budget tracking and financial reporting. A fleet finance manager expects every fleet contract to',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Fleet Contract Management tracks the sales employee handling each fleet contract.',
    `opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: A fleet contract in automotive sales is the commercial outcome of a fleet sales opportunity. Linking fleet_contract back to the originating opportunity enables end-to-end fleet sales pipeline tracking',
    `organization_account_id` BIGINT COMMENT 'Reference to the fleet customer account that holds this contract. Links to the master fleet account entity.',
    `party_id` BIGINT COMMENT 'Reference to the primary customer entity associated with this fleet contract. May represent corporate buyer, government agency, or rental company.',
    `vehicle_program_id` BIGINT COMMENT 'Reference to the fleet incentive program linked to this contract. Determines eligibility for manufacturer rebates and special financing.',
    `annual_mileage_allowance` STRING COMMENT 'Maximum annual mileage allowed per vehicle under lease terms without excess mileage charges. Typical values range from 10,000 to 25,000 miles per year. Null for purchase contracts.',
    `approval_date` DATE COMMENT 'Date when the fleet contract received final internal approval from sales management or finance. Precedes contract signing.',
    `approved_by_user_code` BIGINT COMMENT 'Reference to the user who granted final approval for this fleet contract. Typically a sales director or VP of fleet sales.',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the contract automatically renews for an additional term unless either party provides notice of non-renewal.',
    `base_discount_percentage` DECIMAL(18,2) COMMENT 'Base percentage discount off Manufacturer Suggested Retail Price (MSRP) granted to the fleet customer. Additional volume-based discounts may apply.',
    `committed_volume` STRING COMMENT 'Total number of vehicles the fleet customer has committed to purchase or lease under this contract. Used for volume-based pricing tier qualification.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this fleet contract record was first created in the system. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this contract (e.g., USD, EUR, CAD).. Valid values are `^[A-Z]{3}$`',
    `delivered_volume` STRING COMMENT 'Cumulative count of vehicles delivered to the fleet customer under this contract to date. Updated upon each delivery completion.',
    `delivery_schedule_type` STRING COMMENT 'Classification of how vehicles will be delivered over the contract term. Staggered and quarterly schedules are common for large fleet orders.. Valid values are `single_delivery|staggered|quarterly|annual|on_demand`',
    `effective_end_date` DATE COMMENT 'Date when the fleet contract expires or terminates. After this date, no new orders can be placed under the contract terms. Nullable for open-ended agreements.',
    `effective_start_date` DATE COMMENT 'Date when the fleet contract becomes active and eligible for vehicle orders. Aligns with fiscal year or model year start in many cases.',
    `eligible_model_years` STRING COMMENT 'Comma-separated list of model years eligible for purchase under this contract. Typically current and next model year.',
    `eligible_nameplates` STRING COMMENT 'Comma-separated list of vehicle nameplates (model names) eligible for purchase under this fleet contract. May include sedans, SUVs, trucks, or commercial vehicles.',
    `eligible_powertrain_types` STRING COMMENT 'Comma-separated list of powertrain types eligible under this contract. May include ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), EV (Electric Vehicle), or combinations.',
    `field_service_sla_level` STRING COMMENT 'Field service SLA level for fleet contract',
    `financing_type` STRING COMMENT 'Primary financing method for vehicles under this contract. Captive finance refers to manufacturer-owned financing arm.. Valid values are `cash_purchase|lease|captive_finance|third_party_finance|mixed`',
    `fleet_contract_status` STRING COMMENT 'Current lifecycle status of the fleet contract. Governs whether new orders can be placed and whether pricing and incentives are active. [ENUM-REF-CANDIDATE: draft|pending_approval|active|suspended|expired|terminated|completed — 7 candidates stripped; promote to reference product]',
    `fleet_contract_type` STRING COMMENT 'Classification of the fleet contract based on customer segment and business model. Determines pricing rules, incentive eligibility, and delivery processes.. Valid values are `corporate|government|rental|utility|leasing|dealer_demo`',
    `government_contract_flag` BOOLEAN COMMENT 'Indicates whether this is a government procurement contract subject to special regulations, reporting requirements, and compliance standards.',
    `gsa_schedule_number` STRING COMMENT 'GSA schedule contract number for U.S. federal government fleet purchases. Null for non-government contracts.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this fleet contract record was last updated. Tracks the most recent change to any field in the record.',
    `lease_term_months` STRING COMMENT 'Duration of lease agreement in months if financing_type is lease. Typical fleet lease terms are 24, 36, or 48 months. Null for cash purchases.',
    `maintenance_included_flag` BOOLEAN COMMENT 'Indicates whether scheduled maintenance services are included in the fleet contract pricing. Common for lease agreements and full-service fleet contracts.',
    `minimum_order_quantity` STRING COMMENT 'Minimum number of vehicles that must be ordered in a single transaction to qualify for fleet contract pricing.',
    `multi_location_delivery_flag` BOOLEAN COMMENT 'Indicates whether vehicles under this contract will be delivered to multiple locations. True for national fleet accounts with regional distribution.',
    `fleet_contract_name` STRING COMMENT 'Descriptive name or title of the fleet contract, typically including customer name and program identifier for easy reference.',
    `national_fleet_account_flag` BOOLEAN COMMENT 'Indicates whether this is a national fleet account with centralized purchasing and multi-region delivery. National accounts receive special pricing and dedicated account management.',
    `number` STRING COMMENT 'Externally-known unique business identifier for the fleet contract, used in communications with fleet customers and internal systems. Format: FC-YYYYNNNN.. Valid values are `^FC-[0-9]{8}$`',
    `payment_terms` STRING COMMENT 'Standard payment terms governing when payment is due after vehicle delivery. Net 30/60/90 are common for corporate fleets; government contracts may have custom terms.. Valid values are `net_30|net_60|net_90|prepayment|milestone|custom`',
    `primary_delivery_location` STRING COMMENT 'Primary geographic location or facility where fleet vehicles will be delivered. May be a corporate headquarters, fleet depot, or distribution center.',
    `remaining_volume` STRING COMMENT 'Number of vehicles remaining to be delivered under the committed volume. Calculated as committed_volume minus delivered_volume.',
    `renewal_eligible_flag` BOOLEAN COMMENT 'Indicates whether this fleet contract is eligible for renewal upon expiration. Based on customer performance, payment history, and strategic account status.',
    `sales_region` STRING COMMENT 'Geographic sales region where this fleet contract is managed. Used for regional sales performance tracking and territory management.',
    `signed_date` DATE COMMENT 'Date when the fleet contract was formally signed by both parties. Marks the legal binding of the agreement.',
    `special_terms_notes` STRING COMMENT 'Free-text field capturing any special terms, conditions, or negotiated provisions unique to this fleet contract that are not captured in standard fields.',
    `ssot_governance_note` STRING COMMENT '',
    `term_months` STRING COMMENT 'Duration of the fleet contract expressed in months. Typical terms range from 12 to 60 months for corporate fleets.',
    `termination_date` DATE COMMENT 'Date when the fleet contract was terminated prior to its natural expiration. Null for contracts that completed normally or are still active.',
    `termination_reason` STRING COMMENT 'Business reason for early termination of the fleet contract. Examples include customer request, breach of terms, business closure, or strategic change.',
    `value_amount` DECIMAL(18,2) COMMENT 'Total estimated monetary value of the fleet contract based on committed volume and agreed pricing. Expressed in contract currency.',
    `volume_tier_discount_percentage` DECIMAL(18,2) COMMENT 'Additional discount percentage applied when cumulative volume reaches specified tier thresholds. Stacks on top of base discount.',
    `warranty_extension_months` STRING COMMENT 'Number of months beyond standard manufacturer warranty that are included in the fleet contract. Zero indicates standard warranty only.',
    CONSTRAINT pk_fleet_contract PRIMARY KEY(`fleet_contract_id`)
) COMMENT 'Commercial agreement governing the sale or lease of multiple vehicles to a fleet customer (corporate, government, rental, utility). Captures fleet account reference, contracted volume commitments, agreed pricing tiers, eligible nameplates and model years, contract term, delivery schedule, fleet incentive program linkage, and contract status. Supports national fleet accounts and government procurement contracts. Distinct from retail sales orders due to volume pricing, multi-delivery scheduling, and contract lifecycle management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`trade_in` (
    `trade_in_id` BIGINT COMMENT '',
    `dealership_id` BIGINT COMMENT '',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Trade-in allowances, reconditioning costs, and disposition proceeds (auction/wholesale/retail) are posted to specific GL accounts in automotive dealer accounting. A dealer controller expects every tra',
    `party_id` BIGINT COMMENT '',
    `vehicle_order_id` BIGINT COMMENT '',
    `accepted_date` DATE COMMENT '',
    `accident_history_flag` BOOLEAN COMMENT '',
    `allowance` DECIMAL(18,2) COMMENT '',
    `appraisal_date` DATE COMMENT '',
    `appraised_value` DECIMAL(18,2) COMMENT '',
    `body_style` STRING COMMENT '',
    `condition_grade` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `currency_code` STRING COMMENT '',
    `disposition_amount` DECIMAL(18,2) COMMENT '',
    `disposition_date` DATE COMMENT '',
    `disposition_type` STRING COMMENT '',
    `exterior_color` STRING COMMENT '',
    `exterior_condition` STRING COMMENT '',
    `inspection_completed` BOOLEAN COMMENT '',
    `inspection_date` DATE COMMENT '',
    `interior_color` STRING COMMENT '',
    `interior_condition` STRING COMMENT '',
    `lien_holder` STRING COMMENT '',
    `make` STRING COMMENT '',
    `mechanical_condition` STRING COMMENT '',
    `model` STRING COMMENT '',
    `model_year` STRING COMMENT '',
    `modified_timestamp` TIMESTAMP COMMENT '',
    `notes` STRING COMMENT '',
    `number` STRING COMMENT '',
    `odometer_reading` STRING COMMENT '',
    `odometer_unit` STRING COMMENT '',
    `outstanding_loan_balance` DECIMAL(18,2) COMMENT '',
    `powertrain_type` STRING COMMENT '',
    `service_records_available` BOOLEAN COMMENT '',
    `ssot_governance_note` STRING COMMENT '',
    `tire_condition` STRING COMMENT '',
    `title_status` STRING COMMENT '',
    `transmission_type` STRING COMMENT '',
    `trim_level` STRING COMMENT '',
    `vin` STRING COMMENT '',
    CONSTRAINT pk_trade_in PRIMARY KEY(`trade_in_id`)
) COMMENT 'Record of a customer vehicle trade-in evaluated and accepted as part of a new vehicle purchase transaction. Captures trade-in vehicle details (VIN, make, model, year, mileage, condition grade), appraised value, agreed trade-in allowance, appraisal date, appraising dealer, and disposition (wholesale auction, certified pre-owned, retail resale). Links to the associated vehicle order.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` (
    `delivery_appointment_id` BIGINT COMMENT 'Unique identifier for the delivery appointment record. Primary key for the delivery appointment entity.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership or delivery center where the vehicle handover will occur.',
    `finished_vehicle_stock_id` BIGINT COMMENT 'Foreign key linking to inventory.finished_vehicle_stock. Business justification: PDI and vehicle delivery workflow: delivery coordinators must directly access the finished vehicle stock record to confirm lot location, hold codes, and PDI status before scheduling handover. Navigati',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Delivery appointment must verify and activate the customers subscribed connectivity services; link provides the exact subscription record.',
    `original_delivery_appointment_id` BIGINT COMMENT 'Reference to the previous delivery appointment if this appointment is a rescheduled version.',
    `technician_id` BIGINT COMMENT 'Reference to the technician who performed the Pre-Delivery Inspection.',
    `party_id` BIGINT COMMENT 'Reference to the customer who will take delivery of the vehicle.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle unit being delivered, linked by VIN (Vehicle Identification Number).',
    `trade_in_id` BIGINT COMMENT 'Foreign key linking to sales.trade_in. Business justification: Vehicle delivery appointments in automotive retail often include the simultaneous acceptance of a customer trade-in vehicle. delivery_appointment already carries trade_in_status (indicating trade-in p',
    `vehicle_order_id` BIGINT COMMENT 'Reference to the confirmed vehicle order for which this delivery appointment is scheduled.',
    `actual_delivery_timestamp` TIMESTAMP COMMENT 'Date and time when the vehicle was actually handed over to the customer and delivery was completed.',
    `address_line1` STRING COMMENT 'Primary street address line for the delivery location if delivery is not at a standard dealership facility.',
    `address_line2` STRING COMMENT 'Secondary address line (suite, apartment, building) for the delivery location.',
    `cancellation_reason` STRING COMMENT 'Reason provided for cancellation if the delivery appointment was cancelled.',
    `city` STRING COMMENT 'City name for the delivery location.',
    `connected_services_activated` BOOLEAN COMMENT 'Indicates whether connected vehicle services and mobile app access were activated during delivery.',
    `country_code` STRING COMMENT 'Three-letter ISO country code for the delivery location.. Valid values are `^[A-Z]{3}$`',
    `created_by_user_code` BIGINT COMMENT 'Reference to the user who created the delivery appointment record.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the delivery appointment record was first created in the system.',
    `customer_arrival_timestamp` TIMESTAMP COMMENT 'Date and time when the customer arrived at the delivery location for their appointment.',
    `customer_confirmation_status` STRING COMMENT 'Status indicating whether the customer has confirmed their attendance at the scheduled delivery appointment.. Valid values are `pending|confirmed|declined|no_response`',
    `customer_confirmed_timestamp` TIMESTAMP COMMENT 'Date and time when the customer confirmed the delivery appointment.',
    `delivery_appointment_status` STRING COMMENT 'Current lifecycle status of the delivery appointment. [ENUM-REF-CANDIDATE: scheduled|confirmed|in_progress|completed|cancelled|no_show|rescheduled — 7 candidates stripped; promote to reference product]',
    `delivery_appointment_type` STRING COMMENT 'Classification of the delivery service level provided to the customer.. Valid values are `standard|express|white_glove|fleet|commercial`',
    `digital_owner_manual_sent` BOOLEAN COMMENT 'Indicates whether the digital owner manual and vehicle information was sent to the customer.',
    `documentation_status` STRING COMMENT 'Status of delivery documentation preparation including title, registration, warranty cards, and owner manuals.. Valid values are `pending|in_progress|completed|incomplete`',
    `duration_minutes` STRING COMMENT 'Expected duration of the delivery appointment in minutes, including vehicle walkthrough, paperwork, and handover.',
    `financing_status` STRING COMMENT 'Status of financing approval and funding for the vehicle purchase if applicable.. Valid values are `not_applicable|pending|approved|funded|declined`',
    `handover_duration_minutes` STRING COMMENT 'Actual duration of the vehicle handover process from customer arrival to departure.',
    `last_reminder_sent_timestamp` TIMESTAMP COMMENT 'Date and time when the most recent appointment reminder was sent to the customer.',
    `location_type` STRING COMMENT 'Classification of the delivery location where the vehicle will be handed over to the customer.. Valid values are `dealership|customer_home|fleet_depot|distribution_center|direct_delivery_hub|other`',
    `modified_by_user_code` BIGINT COMMENT 'Reference to the user who last modified the delivery appointment record.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when the delivery appointment record was last modified.',
    `number` STRING COMMENT 'Business-facing unique appointment reference number used for customer communication and tracking. Format: DA-YYYYMMDD-sequence.. Valid values are `^DA-[0-9]{8}$`',
    `pdi_completed_timestamp` TIMESTAMP COMMENT 'Date and time when the Pre-Delivery Inspection was completed and the vehicle was cleared for delivery.',
    `pdi_status` STRING COMMENT 'Status of the Pre-Delivery Inspection process ensuring the vehicle meets quality standards before customer handover.. Valid values are `not_started|in_progress|completed|failed|waived`',
    `postal_code` STRING COMMENT 'Postal or ZIP code for the delivery location.',
    `reminder_sent_count` STRING COMMENT 'Number of appointment reminder notifications sent to the customer via email, SMS, or phone.',
    `satisfaction_score` STRING COMMENT 'Customer satisfaction rating for the delivery experience, typically on a scale of 1-10, collected immediately after delivery.',
    `scheduled_delivery_date` DATE COMMENT 'The date on which the vehicle delivery appointment is scheduled to occur.',
    `scheduled_delivery_time` TIMESTAMP COMMENT 'The precise date and time when the customer is expected to arrive for vehicle handover.',
    `special_instructions` STRING COMMENT 'Any special instructions or requirements for the delivery appointment such as accessibility needs, language preferences, or specific requests.',
    `ssot_governance_note` STRING COMMENT '',
    `state_province` STRING COMMENT 'State or province code for the delivery location.',
    `trade_in_status` STRING COMMENT 'Status of trade-in vehicle processing if the customer is trading in a vehicle as part of the transaction.. Valid values are `not_applicable|pending_appraisal|appraised|accepted|declined|completed`',
    `vehicle_orientation_completed` BOOLEAN COMMENT 'Indicates whether the delivery specialist completed the vehicle features and controls orientation with the customer.',
    `vehicle_preparation_status` STRING COMMENT 'Status of vehicle preparation activities including cleaning, fueling, accessory installation, and final detailing before delivery.. Valid values are `pending|in_progress|completed|on_hold`',
    `vin` STRING COMMENT '17-character Vehicle Identification Number uniquely identifying the vehicle being delivered. ISO 3779 standard format.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_delivery_appointment PRIMARY KEY(`delivery_appointment_id`)
) COMMENT 'Scheduled vehicle delivery appointment for a confirmed vehicle order, coordinating the handover of a new vehicle to the customer at a dealer or direct delivery point. Captures scheduled delivery date and time, delivery location, assigned delivery specialist, PDI (Pre-Delivery Inspection) completion status, customer confirmation status, and actual delivery completion timestamp. Triggers post-delivery customer satisfaction follow-up.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`order_status_event` (
    `order_status_event_id` BIGINT COMMENT 'Unique identifier for the order status event record. Primary key.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership or dealer location that placed or is fulfilling the order.',
    `plant_id` BIGINT COMMENT 'The user or system account that triggered the status change. May be a human user ID or a system service account identifier.',
    `party_id` BIGINT COMMENT 'Reference to the customer who placed the order. Enables customer-specific order tracking and communication.',
    `vin_registry_id` BIGINT COMMENT 'Internal unique identifier for the vehicle master record associated with this order.',
    `production_order_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_order. Business justification: Order-to-delivery tracking: order_status_event records production milestones (actual_production_start_date, actual_production_completion_date, quality_release_date) triggered by production_order state',
    `vehicle_build_id` BIGINT COMMENT 'Foreign key linking to manufacturing.vehicle_build. Business justification: VIN-level build tracking: order_status_event carries vin and build-stage timestamps; vehicle_build is the authoritative per-VIN build record. Customer order status portals and dealer delivery dashboar',
    `vehicle_order_id` BIGINT COMMENT 'Reference to the vehicle order that experienced the status change. Links to the parent order entity.',
    `actual_delivery_date` DATE COMMENT 'The actual date when the vehicle was delivered to the dealer or customer. Populated when the order transitions to delivered status.',
    `actual_production_completion_date` DATE COMMENT 'The actual date when the vehicle completed assembly and exited the production line. Populated when the order transitions to built status.',
    `actual_production_start_date` DATE COMMENT 'The actual date when the vehicle entered the production line. Populated when the order transitions to in_production status.',
    `carrier_name` STRING COMMENT 'The name of the logistics carrier or transportation provider responsible for shipping the vehicle. Relevant for shipped and in_transit status events.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this order status event record was first created in the data system. Audit field for data lineage and compliance.',
    `delay_days` STRING COMMENT 'The number of days the order is delayed relative to the original schedule. Calculated when a status transition occurs later than planned.',
    `destination_location` STRING COMMENT 'The destination location where the vehicle is being delivered. Typically the dealership code or customer delivery address reference.',
    `estimated_delivery_date` DATE COMMENT 'The estimated date when the vehicle is expected to arrive at the dealer or customer location. Updated as the order progresses through logistics.',
    `exception_flag` BOOLEAN COMMENT 'Indicates whether this status event represents an exception or deviation from the normal order fulfillment process. True if exception, False otherwise.',
    `exception_reason` STRING COMMENT 'Detailed explanation of the exception or deviation, if exception_flag is True. Examples include production delay, quality hold, parts shortage, logistics delay, customer request.',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the status event occurred. Used for financial and operational reporting alignment.',
    `model_year` STRING COMMENT 'The model year of the vehicle associated with the order. Used for product lifecycle and sales analytics.',
    `modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this order status event record was last modified in the data system. Audit field for data lineage and compliance.',
    `new_status` STRING COMMENT 'The order status after this transition event. Captures the to-state in the order lifecycle. Enables end-to-end order tracking through the fulfillment pipeline. [ENUM-REF-CANDIDATE: confirmed|scheduled_for_production|in_production|built|quality_released|shipped|in_transit|at_dealer|delivered|cancelled — 10 candidates stripped; promote to reference product]',
    `notes` STRING COMMENT 'Free-text notes or comments associated with the status change event. Provides additional context or details not captured in structured fields.',
    `notification_channel` STRING COMMENT 'The communication channel used to notify the customer of the status change. Examples include email, SMS, mobile app push notification, customer portal, phone call.. Valid values are `email|sms|push|portal|phone|none`',
    `notification_sent_flag` BOOLEAN COMMENT 'Indicates whether a customer notification was sent for this status change event. True if notification sent, False otherwise.',
    `order_status_event_type` STRING COMMENT 'Classification of the status event. Distinguishes routine status progressions from exceptions, cancellations, or amendments.. Valid values are `status_change|milestone_reached|exception|cancellation|amendment`',
    `origin_location` STRING COMMENT 'The location from which the vehicle was shipped. Typically the manufacturing plant or distribution center code.',
    `previous_status` STRING COMMENT 'The order status immediately before this transition event. Captures the from-state in the order lifecycle. [ENUM-REF-CANDIDATE: placed|confirmed|scheduled_for_production|in_production|built|quality_released|shipped — 7 candidates stripped; promote to reference product]',
    `production_line` STRING COMMENT 'The specific production line or assembly line within the plant where the vehicle is being built. Captured during in-production status events.',
    `quality_release_date` DATE COMMENT 'The date when the vehicle passed final quality inspection and was released for shipment. Populated when the order transitions to quality_released status.',
    `region` STRING COMMENT 'The sales region or geographic market where the order is being fulfilled. Used for regional performance tracking and logistics planning.',
    `responsible_party` STRING COMMENT 'The business unit, department, or role responsible for the status transition. Examples include Production Planning, Manufacturing, Quality Assurance, Logistics, Dealer Network.',
    `sales_channel` STRING COMMENT 'The sales channel through which the order was placed. Examples include retail (dealer), fleet sales, commercial vehicle sales, direct-to-consumer, online sales.. Valid values are `retail|fleet|commercial|direct|online`',
    `scheduled_production_date` DATE COMMENT 'The planned date when the vehicle is scheduled to enter production. Populated when the order transitions to scheduled_for_production status.',
    `shipment_date` DATE COMMENT 'The date when the vehicle was shipped from the manufacturing plant or distribution center. Populated when the order transitions to shipped status.',
    `ssot_governance_note` STRING COMMENT '',
    `timestamp` TIMESTAMP COMMENT 'The precise date and time when the order status transition occurred in the source system. This is the business event time, distinct from audit timestamps.',
    `tracking_number` STRING COMMENT 'The tracking number or shipment reference provided by the carrier for end-to-end logistics visibility.',
    `triggering_system` STRING COMMENT 'The source system or application that initiated the status change event. Examples include SAP SD (Sales and Distribution), MES (Manufacturing Execution System), TMS (Transportation Management System), WMS (Warehouse Management System), DMS (Dealer Management System), Salesforce Automotive Cloud, or manual entry. [ENUM-REF-CANDIDATE: SAP_SD|MES|WMS|TMS|DMS|SALESFORCE|MANUAL — 7 candidates stripped; promote to reference product]',
    `triggering_user_code` STRING COMMENT 'The user or system account that triggered the status change. May be a human user ID or a system service account identifier.',
    `vin` STRING COMMENT 'The 17-character Vehicle Identification Number assigned to the vehicle associated with this order. Populated once the vehicle enters production and a VIN is assigned.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_order_status_event PRIMARY KEY(`order_status_event_id`)
) COMMENT 'Lifecycle status change event record for a vehicle order, capturing each transition through the order fulfillment pipeline (placed → confirmed → scheduled for production → in production → built → quality released → shipped → in transit → at dealer → delivered). Records event timestamp, previous status, new status, triggering system (SAP SD, MES, logistics), and responsible party. Enables end-to-end order tracking and customer communication.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_incentive_program_id` FOREIGN KEY (`incentive_program_id`) REFERENCES `vibe_automotive_v1`.`sales`.`incentive_program`(`incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_fleet_contract_id` FOREIGN KEY (`fleet_contract_id`) REFERENCES `vibe_automotive_v1`.`sales`.`fleet_contract`(`fleet_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_incentive_program_id` FOREIGN KEY (`incentive_program_id`) REFERENCES `vibe_automotive_v1`.`sales`.`incentive_program`(`incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_opportunity_id` FOREIGN KEY (`opportunity_id`) REFERENCES `vibe_automotive_v1`.`sales`.`opportunity`(`opportunity_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_incentive_program_id` FOREIGN KEY (`incentive_program_id`) REFERENCES `vibe_automotive_v1`.`sales`.`incentive_program`(`incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_quote_id` FOREIGN KEY (`quote_id`) REFERENCES `vibe_automotive_v1`.`sales`.`quote`(`quote_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_incentive_program_id` FOREIGN KEY (`incentive_program_id`) REFERENCES `vibe_automotive_v1`.`sales`.`incentive_program`(`incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_fleet_contract_id` FOREIGN KEY (`fleet_contract_id`) REFERENCES `vibe_automotive_v1`.`sales`.`fleet_contract`(`fleet_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_incentive_program_id` FOREIGN KEY (`incentive_program_id`) REFERENCES `vibe_automotive_v1`.`sales`.`incentive_program`(`incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_trade_in_id` FOREIGN KEY (`trade_in_id`) REFERENCES `vibe_automotive_v1`.`sales`.`trade_in`(`trade_in_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ADD CONSTRAINT `fk_sales_fleet_contract_opportunity_id` FOREIGN KEY (`opportunity_id`) REFERENCES `vibe_automotive_v1`.`sales`.`opportunity`(`opportunity_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ADD CONSTRAINT `fk_sales_trade_in_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_original_delivery_appointment_id` FOREIGN KEY (`original_delivery_appointment_id`) REFERENCES `vibe_automotive_v1`.`sales`.`delivery_appointment`(`delivery_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_trade_in_id` FOREIGN KEY (`trade_in_id`) REFERENCES `vibe_automotive_v1`.`sales`.`trade_in`(`trade_in_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ADD CONSTRAINT `fk_sales_order_status_event_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`sales` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_automotive_v1`.`sales` SET TAGS ('dbx_domain' = 'sales');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` SET TAGS ('dbx_subdomain' = 'revenue_pipeline');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Incentive Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `organization_account_id` SET TAGS ('dbx_business_glossary_term' = 'Organization Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `primary_model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `primary_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `incentive_amount` SET TAGS ('dbx_business_glossary_term' = 'Incentive Amount');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^OPP-[0-9]{8}$');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `territory` SET TAGS ('dbx_business_glossary_term' = 'Sales Territory');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `test_drive_completed` SET TAGS ('dbx_business_glossary_term' = 'Test Drive Completed');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `test_drive_date` SET TAGS ('dbx_business_glossary_term' = 'Test Drive Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `trade_in_value` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Value');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `vehicle_configuration` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `win_reason` SET TAGS ('dbx_business_glossary_term' = 'Win Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` SET TAGS ('dbx_subdomain' = 'revenue_pipeline');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_id` SET TAGS ('dbx_business_glossary_term' = 'Quote Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `finished_vehicle_stock_id` SET TAGS ('dbx_business_glossary_term' = 'Finished Vehicle Stock Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Incentive Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `dealer_inventory_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Inventory Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Opportunity Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `organization_account_id` SET TAGS ('dbx_business_glossary_term' = 'Organization Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `powertrain_spec_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Spec Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_customer_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_dealer_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_trim_level_model_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Trim Level Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `warranty_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Quote Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `options_total` SET TAGS ('dbx_business_glossary_term' = 'Options Total Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_date` SET TAGS ('dbx_business_glossary_term' = 'Quote Issue Date');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `trade_in_vin` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `trade_in_vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `trade_in_vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `trade_in_vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `transmission_type` SET TAGS ('dbx_business_glossary_term' = 'Transmission Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `transmission_type` SET TAGS ('dbx_value_regex' = 'manual|automatic|cvt|dct|single_speed');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Quote Version Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By User');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` SET TAGS ('dbx_subdomain' = 'revenue_pipeline');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `quote_line_id` SET TAGS ('dbx_business_glossary_term' = 'Quote Line Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Option Package Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Incentive Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Msrp Schedule Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `list_price` SET TAGS ('dbx_business_glossary_term' = 'List Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `margin_amount` SET TAGS ('dbx_business_glossary_term' = 'Margin Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `margin_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Line Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Line Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `product_code` SET TAGS ('dbx_business_glossary_term' = 'Product Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `product_description` SET TAGS ('dbx_business_glossary_term' = 'Product Description');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Quantity');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `quote_line_status` SET TAGS ('dbx_business_glossary_term' = 'Line Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `quote_line_status` SET TAGS ('dbx_value_regex' = 'draft|active|approved|rejected|cancelled|converted');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `quote_line_type` SET TAGS ('dbx_business_glossary_term' = 'Line Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `tax_rate` SET TAGS ('dbx_business_glossary_term' = 'Tax Rate');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `total` SET TAGS ('dbx_business_glossary_term' = 'Line Total');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Unit Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `vin` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` SET TAGS ('dbx_subdomain' = 'order_fulfillment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Incentive Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `powertrain_spec_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Spec Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `organization_account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Fleet Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vehicle_organization_account_id` SET TAGS ('dbx_business_glossary_term' = 'Organization Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` SET TAGS ('dbx_subdomain' = 'order_fulfillment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `order_line_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `finished_vehicle_stock_id` SET TAGS ('dbx_business_glossary_term' = 'Finished Vehicle Stock Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Incentive Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `order_option_package_configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Option Package Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Sales Rep Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `trade_in_id` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vehicle_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Allocation Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `list_price` SET TAGS ('dbx_business_glossary_term' = 'List Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `model_code` SET TAGS ('dbx_business_glossary_term' = 'Model Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `net_price` SET TAGS ('dbx_business_glossary_term' = 'Net Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Line Item Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `order_line_status` SET TAGS ('dbx_business_glossary_term' = 'Line Item Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `order_line_type` SET TAGS ('dbx_business_glossary_term' = 'Line Item Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `product_description` SET TAGS ('dbx_business_glossary_term' = 'Product Description');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Quantity');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `scheduled_production_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Production Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `ship_date` SET TAGS ('dbx_business_glossary_term' = 'Ship Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Instructions');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `total` SET TAGS ('dbx_business_glossary_term' = 'Line Total Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|SET|KIT|HR|UNIT');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`incentive_program` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`incentive_program` SET TAGS ('dbx_subdomain' = 'revenue_pipeline');
ALTER TABLE `vibe_automotive_v1`.`sales`.`incentive_program` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`incentive_program` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`incentive_program` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`incentive_program` ALTER COLUMN `powertrain_spec_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Spec Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` SET TAGS ('dbx_subdomain' = 'order_fulfillment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Sales Rep Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `dealership_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `organization_account_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Account Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Incentive Program Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `annual_mileage_allowance` SET TAGS ('dbx_business_glossary_term' = 'Annual Mileage Allowance');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Approval Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `approved_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Approved By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `approved_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `approved_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto-Renewal Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `base_discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Base Fleet Discount Percentage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `base_discount_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `committed_volume` SET TAGS ('dbx_business_glossary_term' = 'Committed Vehicle Volume');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `fleet_contract_status` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `fleet_contract_type` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `fleet_contract_type` SET TAGS ('dbx_value_regex' = 'corporate|government|rental|utility|leasing|dealer_demo');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `government_contract_flag` SET TAGS ('dbx_business_glossary_term' = 'Government Contract Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `gsa_schedule_number` SET TAGS ('dbx_business_glossary_term' = 'General Services Administration (GSA) Schedule Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `lease_term_months` SET TAGS ('dbx_business_glossary_term' = 'Lease Term in Months');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `maintenance_included_flag` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Included Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `multi_location_delivery_flag` SET TAGS ('dbx_business_glossary_term' = 'Multi-Location Delivery Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `fleet_contract_name` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `national_fleet_account_flag` SET TAGS ('dbx_business_glossary_term' = 'National Fleet Account Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^FC-[0-9]{8}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = 'net_30|net_60|net_90|prepayment|milestone|custom');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `primary_delivery_location` SET TAGS ('dbx_business_glossary_term' = 'Primary Delivery Location');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `remaining_volume` SET TAGS ('dbx_business_glossary_term' = 'Remaining Vehicle Volume');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `renewal_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Renewal Eligible Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `sales_region` SET TAGS ('dbx_business_glossary_term' = 'Sales Region');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `signed_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Signed Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `special_terms_notes` SET TAGS ('dbx_business_glossary_term' = 'Special Terms and Conditions Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `term_months` SET TAGS ('dbx_business_glossary_term' = 'Contract Term in Months');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Termination Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Contract Termination Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `value_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Contract Value Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `volume_tier_discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Volume Tier Discount Percentage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `volume_tier_discount_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `warranty_extension_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Extension Period in Months');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` SET TAGS ('dbx_subdomain' = 'revenue_pipeline');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` SET TAGS ('dbx_subdomain' = 'order_fulfillment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Appointment Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `finished_vehicle_stock_id` SET TAGS ('dbx_business_glossary_term' = 'Finished Vehicle Stock Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Service Subscription Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `original_delivery_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Rescheduled From Appointment Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `technician_id` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Technician Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `trade_in_id` SET TAGS ('dbx_business_glossary_term' = 'Trade In Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `actual_delivery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address Line 1');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address Line 2');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'Delivery City');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `connected_services_activated` SET TAGS ('dbx_business_glossary_term' = 'Connected Services Activated Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Delivery Country Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Created By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `customer_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Customer Arrival Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `customer_confirmation_status` SET TAGS ('dbx_business_glossary_term' = 'Customer Confirmation Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `customer_confirmation_status` SET TAGS ('dbx_value_regex' = 'pending|confirmed|declined|no_response');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `customer_confirmed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Customer Confirmation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_appointment_status` SET TAGS ('dbx_business_glossary_term' = 'Appointment Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_appointment_type` SET TAGS ('dbx_business_glossary_term' = 'Delivery Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_appointment_type` SET TAGS ('dbx_value_regex' = 'standard|express|white_glove|fleet|commercial');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `digital_owner_manual_sent` SET TAGS ('dbx_business_glossary_term' = 'Digital Owner Manual Sent Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `documentation_status` SET TAGS ('dbx_business_glossary_term' = 'Documentation Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `documentation_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|incomplete');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Appointment Duration in Minutes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `financing_status` SET TAGS ('dbx_business_glossary_term' = 'Financing Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `financing_status` SET TAGS ('dbx_value_regex' = 'not_applicable|pending|approved|funded|declined');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `handover_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Handover Duration in Minutes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `last_reminder_sent_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Reminder Sent Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `location_type` SET TAGS ('dbx_business_glossary_term' = 'Delivery Location Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `location_type` SET TAGS ('dbx_value_regex' = 'dealership|customer_home|fleet_depot|distribution_center|direct_delivery_hub|other');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `modified_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Modified By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `modified_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `modified_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Appointment Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^DA-[0-9]{8}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `pdi_completed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Completion Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `pdi_status` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `pdi_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|failed|waived');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Delivery Postal Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `reminder_sent_count` SET TAGS ('dbx_business_glossary_term' = 'Reminder Sent Count');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `satisfaction_score` SET TAGS ('dbx_business_glossary_term' = 'Delivery Satisfaction Score');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `scheduled_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `scheduled_delivery_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Time');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Instructions');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'Delivery State or Province');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `state_province` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `trade_in_status` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `trade_in_status` SET TAGS ('dbx_value_regex' = 'not_applicable|pending_appraisal|appraised|accepted|declined|completed');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vehicle_orientation_completed` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Orientation Completed Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vehicle_preparation_status` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Preparation Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vehicle_preparation_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|on_hold');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vin` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` SET TAGS ('dbx_subdomain' = 'order_fulfillment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `order_status_event_id` SET TAGS ('dbx_business_glossary_term' = 'Order Status Event Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Triggering User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `production_order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `vehicle_build_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Build Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Order Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `actual_production_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Production Completion Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `actual_production_start_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Production Start Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `carrier_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `delay_days` SET TAGS ('dbx_business_glossary_term' = 'Delay Days');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `destination_location` SET TAGS ('dbx_business_glossary_term' = 'Destination Location');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `estimated_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `exception_flag` SET TAGS ('dbx_business_glossary_term' = 'Exception Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `exception_reason` SET TAGS ('dbx_business_glossary_term' = 'Exception Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `new_status` SET TAGS ('dbx_business_glossary_term' = 'New Order Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Event Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `notification_channel` SET TAGS ('dbx_business_glossary_term' = 'Notification Channel');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `notification_channel` SET TAGS ('dbx_value_regex' = 'email|sms|push|portal|phone|none');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `notification_sent_flag` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Sent Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `order_status_event_type` SET TAGS ('dbx_business_glossary_term' = 'Event Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `order_status_event_type` SET TAGS ('dbx_value_regex' = 'status_change|milestone_reached|exception|cancellation|amendment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `origin_location` SET TAGS ('dbx_business_glossary_term' = 'Origin Location');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `previous_status` SET TAGS ('dbx_business_glossary_term' = 'Previous Order Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `production_line` SET TAGS ('dbx_business_glossary_term' = 'Production Line');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `quality_release_date` SET TAGS ('dbx_business_glossary_term' = 'Quality Release Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Sales Region');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `responsible_party` SET TAGS ('dbx_business_glossary_term' = 'Responsible Party');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `sales_channel` SET TAGS ('dbx_business_glossary_term' = 'Sales Channel');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `sales_channel` SET TAGS ('dbx_value_regex' = 'retail|fleet|commercial|direct|online');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `scheduled_production_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Production Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `shipment_date` SET TAGS ('dbx_business_glossary_term' = 'Shipment Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `timestamp` SET TAGS ('dbx_business_glossary_term' = 'Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Shipment Tracking Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `triggering_system` SET TAGS ('dbx_business_glossary_term' = 'Triggering System');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `triggering_user_code` SET TAGS ('dbx_business_glossary_term' = 'Triggering User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `triggering_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `triggering_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
