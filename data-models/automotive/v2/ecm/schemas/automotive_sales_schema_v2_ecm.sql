-- Schema for Domain: sales | Business:  | Version: v2_ecm
-- Generated on: 2026-07-14 02:32:24

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`sales` COMMENT 'Sales operations including lead management, opportunity tracking, quote generation, order capture, and sales performance analytics. Manages MSRP (Manufacturer Suggested Retail Price), incentive programs, fleet sales, and commercial vehicle contracts. Tracks sales pipeline, conversion rates, and regional sales performance. Integrates with dealer networks and Salesforce Automotive Cloud for unified sales execution across direct and indirect channels. Interfaces with SAP SD.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`opportunity` (
    `opportunity_id` BIGINT COMMENT 'Unique identifier for the sales opportunity record. Primary key.',
    `campaign_id` BIGINT COMMENT 'Reference to the marketing campaign that generated this opportunity, if applicable.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership managing this opportunity.',
    `product_nameplate_id` BIGINT COMMENT 'Foreign key linking to product.nameplate. Business justification: Opportunities are tied to a specific vehicle model (nameplate); linking to product.nameplate captures the product line the opportunity targets.',
    `party_id` BIGINT COMMENT 'Reference to the prospect or customer associated with this opportunity.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Opportunity tracking by model enables sales forecasting, market analysis, and model performance dashboards.',
    `opportunity_party_id` BIGINT COMMENT 'Reference to the prospect or customer associated with this opportunity.',
    `rep_id` BIGINT COMMENT 'Reference to the sales representative or account owner assigned to this opportunity.',
    `opportunity_sales_representative_rep_id` BIGINT COMMENT 'Reference to the sales representative or account owner assigned to this opportunity.',
    `opportunity_vehicle_model_id` BIGINT COMMENT 'Reference to the specific vehicle configuration or model of interest for this opportunity.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Required for Opportunity Ownership Report showing which employee owns each opportunity.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Required for Opportunity Management report to align sales opportunities with engineering program schedules, ensuring capacity planning.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle configuration or model of interest for this opportunity.',
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
    `opportunity_number` STRING COMMENT 'Business-facing unique identifier for the opportunity, typically auto-generated and used in communications with dealers and sales teams.. Valid values are `^OPP-[0-9]{8}$`',
    `opportunity_type` STRING COMMENT 'Classification of the opportunity based on customer segment and purchase type.. Valid values are `retail|fleet|commercial|government|employee_purchase|demo`',
    `powertrain_type` STRING COMMENT 'Type of powertrain for the vehicle of interest: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), FCEV (Fuel Cell Electric Vehicle).. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `priority` STRING COMMENT 'Priority level assigned to this opportunity based on strategic importance, deal size, or customer value.. Valid values are `low|medium|high|critical`',
    `probability` DECIMAL(18,2) COMMENT 'Estimated probability of closing this opportunity successfully, expressed as a percentage (0-100).',
    `quote_date` DATE COMMENT 'Date when the quote was generated, if applicable.',
    `quote_generated` BOOLEAN COMMENT 'Indicates whether a formal quote has been generated for this opportunity.',
    `region` STRING COMMENT 'Geographic sales region where this opportunity is being managed.',
    `sales_stage` STRING COMMENT 'Current stage of the opportunity in the sales pipeline, reflecting progression from initial contact through close. [ENUM-REF-CANDIDATE: lead|qualification|needs_analysis|test_drive|quote|negotiation|closed_won|closed_lost — 8 candidates stripped; promote to reference product]',
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
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_configuration. Business justification: Quote must be tied to a specific vehicle configuration to calculate options, OTA updates, and compliance; supports configuration‑based pricing.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Quote creation audit requires the employee who generated the quote.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Required for Quote generation to reference the exact vehicle model, ensuring pricing consistency and enabling model‑level reporting.',
    `product_nameplate_id` BIGINT COMMENT 'Foreign key linking to product.nameplate. Business justification: Quote generation must tie to official nameplate record for pricing, compliance, and reporting; experts expect a nameplate_id FK.',
    `online_order_id` BIGINT COMMENT 'FK to the online order this quote was converted into via the digital channel.',
    `opportunity_id` BIGINT COMMENT 'Reference to the sales opportunity or lead that generated this quote. Tracks quote back to pipeline stage in Salesforce Automotive Cloud.',
    `party_id` BIGINT COMMENT 'Reference to the customer or prospect receiving this quote. Links to customer master data in SAP or Salesforce Automotive Cloud.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership or direct sales channel issuing the quote. Links to dealer master data in CDK Global DMS or SAP.',
    `quote_dealership_id` BIGINT COMMENT 'Reference to the dealership or direct sales channel issuing the quote. Links to dealer master data in CDK Global DMS or SAP.',
    `quote_party_id` BIGINT COMMENT 'Reference to the customer or prospect receiving this quote. Links to customer master data in SAP or Salesforce Automotive Cloud.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle configuration being quoted. Links to vehicle master data including model, trim, powertrain, and options.',
    `quote_vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle configuration being quoted. Links to vehicle master data including model, trim, powertrain, and options.',
    `rep_id` BIGINT COMMENT 'Reference to the sales representative or account manager who prepared the quote. Used for commission tracking and performance analytics.',
    `mobility_service_id` BIGINT COMMENT 'Foreign key linking to mobility.mobility_service. Business justification: Quotes can include optional connectivity/ADAS services; linking the quoted service enables accurate pricing, compliance, and downstream provisioning.',
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
    `trade_in_vin` STRING COMMENT 'VIN of the customers trade-in vehicle if applicable. Used for appraisal lookup and title transfer processing.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `transmission_type` STRING COMMENT 'Type of transmission: manual, automatic, CVT (Continuously Variable Transmission), DCT (Dual Clutch Transmission), or single-speed (for EVs).. Valid values are `manual|automatic|cvt|dct|single_speed`',
    `trim_level` STRING COMMENT 'Trim or grade level of the vehicle (e.g., Base, Sport, Luxury, Premium). Determines standard equipment and base pricing.',
    `version` STRING COMMENT 'Version number of the quote. Increments when quote is revised with updated pricing, configuration, or terms. Supports quote revision history and audit trail.',
    `vin` STRING COMMENT '17-character Vehicle Identification Number if quote is for a specific in-stock or allocated vehicle. Null for build-to-order quotes where VIN is not yet assigned.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `created_by` STRING COMMENT 'User ID or name of the person who created this quote record. Audit trail for accountability.',
    CONSTRAINT pk_quote PRIMARY KEY(`quote_id`)
) COMMENT 'Formal vehicle sales quotation issued to a prospect or customer, detailing configured vehicle, MSRP, applied incentives, trade-in allowance, financing terms, accessories, and net selling price. Tracks quote version, expiry date, quote status, and issuing dealer or direct sales channel. Supports retail, fleet, and CKD/SKD export quotes. Linked to SAP SD quotation (VA21) and Salesforce Automotive Cloud Quote.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`quote_line` (
    `quote_line_id` BIGINT COMMENT 'Unique identifier for the quote line item. Primary key.',
    `dealer_incentive_program_id` BIGINT COMMENT 'Reference to the manufacturer or dealer incentive program applied to this line. Links to incentive program master for eligibility rules, amounts, and expiration dates.',
    `msrp_schedule_id` BIGINT COMMENT 'Foreign key linking to sales.msrp_schedule. Business justification: Quote line items need to reference the official MSRP schedule for the selected configuration; adding msrp_schedule_id eliminates redundant MSRP columns and enables consistent pricing lookup.',
    `quote_id` BIGINT COMMENT 'Foreign key reference to the parent quote header. Establishes the header-detail relationship for this line item.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle configuration being quoted. Applicable when line_type is vehicle. Links to the vehicle master for model, trim, and base specifications.',
    `quote_vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle configuration being quoted. Applicable when line_type is vehicle. Links to the vehicle master for model, trim, and base specifications.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Quote lines are proposals for specific SKUs; adding a foreign key to product.sku enables pricing and configuration consistency.',
    `vehicle_option_package_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_option_package. Business justification: Quote line for an option package should reference the canonical package entity for accurate pricing, warranty, and regulatory compliance.',
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
    `model_code` STRING COMMENT 'Manufacturer model code representing the configured vehicle variant. Includes base model, trim level, and factory option packages. Used for pricing and inventory lookup.',
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
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Order Accounting: each vehicle order must be tied to a legal entity (company code) for statutory reporting and consolidation.',
    `contact_point_id` BIGINT COMMENT 'Reference to the specific address where the vehicle will be delivered. Links to customer or dealer address master data.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Cost Allocation: orders are charged to a cost center for expense tracking and internal budgeting.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership through which the order was placed. Links to the dealer network master data.',
    `homologation_record_id` BIGINT COMMENT 'Foreign key linking to compliance.homologation_record. Business justification: Regulatory reporting requires each vehicle order to reference the homologation approval authorizing the model for the market.',
    `product_nameplate_id` BIGINT COMMENT 'Foreign key linking to product.nameplate. Business justification: Vehicle orders need nameplate reference to align production schedules and meet regulatory filing requirements.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Order Responsibility Report tracks which employee (sales rep) is accountable for each vehicle order.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle unit ordered. For stock orders, links to existing inventory. For build-to-order, links to the vehicle configuration that will be manufactured.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Profit Center Reporting: each order contributes to a profit center for profitability analysis per business unit.',
    `party_id` BIGINT COMMENT 'Reference to the customer who placed the vehicle order. Links to the customer master data.',
    `vehicle_party_id` BIGINT COMMENT 'Reference to the customer who placed the vehicle order. Links to the customer master data.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Order fulfillment tracks against Vehicle Program to manage production volume and delivery timelines.',
    `rep_id` BIGINT COMMENT 'Reference to the sales representative or sales agent who handled the order. Used for commission calculation and performance tracking.',
    `vehicle_sales_representative_rep_id` BIGINT COMMENT 'Reference to the sales representative or sales agent who handled the order. Used for commission calculation and performance tracking.',
    `vehicle_vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle unit ordered. For stock orders, links to existing inventory. For build-to-order, links to the vehicle configuration that will be manufactured.',
    `finance_contract_id` BIGINT COMMENT 'FK to the F&I finance contract associated with this order.',
    `actual_delivery_date` DATE COMMENT 'Actual date when the vehicle was delivered to the customer or dealer. Used for On-Time Delivery (OTD) performance measurement.',
    `build_week` STRING COMMENT 'Scheduled production week for the vehicle in ISO week format (YYYYWWW). Represents the planned Start of Production (SOP) week.. Valid values are `^(19|20)d{2}W(0[1-9]|[1-4][0-9]|5[0-3])$`',
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
    `production_plant_code` STRING COMMENT 'Code identifying the manufacturing plant assigned to build this vehicle. Used for production scheduling and capacity planning.. Valid values are `^[A-Z0-9]{3,6}$`',
    `region_code` STRING COMMENT 'Geographic sales region code where the order was placed. Used for regional sales performance analysis and territory management.. Valid values are `^[A-Z]{2,5}$`',
    `requested_delivery_date` DATE COMMENT 'Customer-requested date for vehicle delivery. Used for production planning and logistics scheduling.',
    `sales_channel` STRING COMMENT 'Channel through which the order was captured. Dealer for traditional dealership sales, direct for OEM-direct sales, online for e-commerce platform, fleet_sales for commercial fleet division, broker for third-party intermediaries.. Valid values are `dealer|direct|online|fleet_sales|broker`',
    `selling_price` DECIMAL(18,2) COMMENT 'Final agreed selling price for the vehicle after all discounts, incentives, rebates, and negotiations. Represents the actual transaction price.',
    `special_instructions` STRING COMMENT 'Free-text field for special handling instructions, customer requests, or delivery notes that require attention during order fulfillment.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total sales tax, value-added tax, or other applicable taxes calculated for the vehicle order based on delivery jurisdiction.',
    `total_amount` DECIMAL(18,2) COMMENT 'Total amount payable by the customer including selling price, taxes, fees, and any additional charges minus trade-in value.',
    `trade_in_value` DECIMAL(18,2) COMMENT 'Appraised value of the customer trade-in vehicle applied toward the purchase. Null if no trade-in is involved.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this order record was last modified in the data platform. Used for change tracking and audit trail.',
    `vehicle_configuration_code` STRING COMMENT 'Complete configuration code representing all selected options, packages, and features for the ordered vehicle. Encodes the full Bill of Materials (BOM) specification.. Valid values are `^[A-Z0-9]{10,30}$`',
    `vehicle_model_code` STRING COMMENT 'Internal model code identifying the base vehicle platform and variant. Used for production planning and parts management.. Valid values are `^[A-Z0-9]{5,15}$`',
    `vin` STRING COMMENT '17-character Vehicle Identification Number assigned to the ordered vehicle. May be null at order placement for build-to-order vehicles and populated when the vehicle enters production.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_vehicle_order PRIMARY KEY(`vehicle_order_id`)
) COMMENT 'Confirmed customer vehicle purchase order capturing the commercial commitment to buy a specific configured vehicle. Records order type (retail, fleet, government, export), ordered VIN or build-to-order configuration, agreed selling price, payment method, financing reference, delivery commitment date, and order status lifecycle (placed, confirmed, in-production, shipped, delivered). Interfaces with SAP SD sales order (VA01) and triggers manufacturing scheduling.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`order_line` (
    `order_line_id` BIGINT COMMENT 'Unique identifier for the order line item. Primary key for the order_line product.',
    `aftersales_trim_level_id` BIGINT COMMENT 'Foreign key linking to product.trim_level. Business justification: Order lines must reference exact trim level definition for accurate BOM generation and cost tracking; this FK is standard in manufacturing.',
    `configuration_id` BIGINT COMMENT 'Reference to the detailed vehicle configuration record capturing all selected options, packages, and specifications for this order line.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership responsible for this order line. Links to dealer network and channel management.',
    `fleet_contract_id` BIGINT COMMENT 'Reference to the fleet sales contract or commercial vehicle agreement governing this line item. Null for retail orders.',
    `fni_menu_product_id` BIGINT COMMENT 'FK to the F&I menu product sold on this line.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Revenue Posting: every order line maps to a GL account to generate journal entries for recognized revenue.',
    `rep_id` BIGINT COMMENT 'Reference to the sales representative or sales agent who captured this order line. Used for commission calculation and performance tracking.',
    `order_sales_representative_rep_id` BIGINT COMMENT 'Reference to the sales representative or sales agent who captured this order line. Used for commission calculation and performance tracking.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the trade-in vehicle appraisal record if this order line includes a trade-in transaction. Null if no trade-in.',
    `order_vehicle_vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle master record when line_type is vehicle. Links to vehicle configuration and specifications.',
    `order_vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle master record when line_type is vehicle. Links to vehicle configuration and specifications.',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Production scheduling uses Order Line to retrieve Part Master details for manufacturing execution.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Line‑level accountability requires the employee responsible for each order line.',
    `trade_in_id` BIGINT COMMENT 'Reference to the trade-in vehicle appraisal record if this order line includes a trade-in transaction. Null if no trade-in.',
    `vehicle_option_package_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_option_package. Business justification: Order line must reference option package entity to drive production planning, parts allocation, and warranty tracking.',
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
    `plant_code` STRING COMMENT 'Code identifying the manufacturing plant or assembly facility assigned to produce this vehicle unit.',
    `powertrain_type` STRING COMMENT 'Type of powertrain system. ICE=Internal Combustion Engine, HEV=Hybrid Electric Vehicle, PHEV=Plug-in Hybrid Electric Vehicle, BEV=Battery Electric Vehicle, FCEV=Fuel Cell Electric Vehicle.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `product_description` STRING COMMENT 'Human-readable description of the line item product or service. Provides business context for reporting and customer documentation.',
    `quantity` DECIMAL(18,2) COMMENT 'Ordered quantity for this line item. Typically 1 for vehicle units, may be greater than 1 for accessories, parts, or fleet orders.',
    `scheduled_production_date` DATE COMMENT 'Planned Start of Production (SOP) date for this vehicle unit. Applicable only for build-to-order vehicles.',
    `ship_date` DATE COMMENT 'Date when the line item was shipped from the manufacturing plant or distribution center to the dealer or customer.',
    `special_instructions` STRING COMMENT 'Free-text field capturing any special handling instructions, customer requests, or delivery notes specific to this order line.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount for this line item including sales tax, value-added tax, and any applicable excise taxes.',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the quantity field. EA=Each, SET=Set, KIT=Kit, HR=Hour (for service contracts), UNIT=Unit.. Valid values are `EA|SET|KIT|HR|UNIT`',
    `vin` STRING COMMENT '17-character Vehicle Identification Number assigned to this line item when available. May be null at order capture and populated during production allocation. Uniquely identifies the physical vehicle unit.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_order_line PRIMARY KEY(`order_line_id`)
) COMMENT 'Individual line item within a vehicle order representing a specific vehicle unit, accessory, extended warranty, or service contract. Captures VIN assignment (when available), model code, trim level, exterior/interior color, option packages, unit net price, quantity, and line fulfillment status. Supports multi-unit fleet orders with individual VIN-level tracking per line.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`sales_incentive_program` (
    `sales_incentive_program_id` BIGINT COMMENT 'Unique identifier for the sales_incentive_program data product (auto-inserted pre-linking).',
    `vehicle_program_id` BIGINT COMMENT 'add column vehicle_program_id (BIGINT) with FK to engineering.vehicle_program.vehicle_program_id - sales incentive programs target specific vehicle programs',
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
    CONSTRAINT pk_sales_incentive_program PRIMARY KEY(`sales_incentive_program_id`)
) COMMENT 'Master record for OEM-sponsored sales incentive programs including customer cash rebates, dealer cash allowances, low-APR financing offers, lease support, conquest bonuses, loyalty rewards, and fleet incentives. Captures program code, program type, eligible model year and nameplate, start and end dates, maximum incentive amount, funding source (OEM vs regional), stackability rules, and eligibility criteria. Managed centrally and distributed to dealer network.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`sales_incentive_claim` (
    `sales_incentive_claim_id` BIGINT COMMENT 'Unique identifier for the sales_incentive_claim data product (auto-inserted pre-linking).',
    `dealership_id` BIGINT COMMENT 'add column dealership_id (BIGINT) with FK to dealer.dealership.dealership_id - incentive claims are submitted by specific dealerships',
    `sales_incentive_program_id` BIGINT COMMENT 'Foreign key linking to sales.sales_incentive_program. Business justification: Link claim to internal incentive program for accurate incentive tracking.',
    `vin_registry_id` BIGINT COMMENT 'add column vin_registry_id (BIGINT) with FK to vehicle.vin_registry.vin_registry_id - incentive claims reference specific sold vehicles',
    CONSTRAINT pk_sales_incentive_claim PRIMARY KEY(`sales_incentive_claim_id`)
) COMMENT 'Transactional record of an incentive applied to a specific vehicle sale or lease transaction. Captures the incentive program applied, claimed amount, claim date, approving authority, claim status (submitted, approved, paid, rejected), dealer or direct channel submitting the claim, and supporting documentation references. Enables incentive spend tracking and reconciliation against program budgets.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` (
    `fleet_contract_id` BIGINT COMMENT 'Unique identifier for the fleet contract. Primary key for the fleet contract entity.',
    `customer_fleet_account_id` BIGINT COMMENT 'Reference to the fleet customer account that holds this contract. Links to the master fleet account entity.',
    `dealer_incentive_program_id` BIGINT COMMENT 'Reference to the fleet incentive program linked to this contract. Determines eligibility for manufacturer rebates and special financing.',
    `party_id` BIGINT COMMENT 'Reference to the primary customer entity associated with this fleet contract. May represent corporate buyer, government agency, or rental company.',
    `fleet_party_id` BIGINT COMMENT 'Reference to the primary customer entity associated with this fleet contract. May represent corporate buyer, government agency, or rental company.',
    `rep_id` BIGINT COMMENT 'Reference to the sales representative or account manager responsible for this fleet contract. Typically a dedicated fleet sales specialist.',
    `fleet_sales_representative_rep_id` BIGINT COMMENT 'Reference to the sales representative or account manager responsible for this fleet contract. Typically a dedicated fleet sales specialist.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Fleet Contract Management tracks the sales employee handling each fleet contract.',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` (
    `fleet_contract_line_id` BIGINT COMMENT 'Unique identifier for the fleet contract line item. Primary key for this entity.',
    `dealer_incentive_program_id` BIGINT COMMENT 'Reference to any manufacturer incentive program applied to this contract line (e.g., fleet rebate, volume discount program).',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership or distribution partner involved in fulfilling this contract line, if applicable.',
    `fleet_contract_id` BIGINT COMMENT 'Reference to the parent fleet contract under which this line item is allocated. Links this line to the master fleet agreement.',
    `rep_id` BIGINT COMMENT 'Reference to the sales representative or account manager responsible for this contract line.',
    `fleet_sales_representative_rep_id` BIGINT COMMENT 'Reference to the sales representative or account manager responsible for this contract line.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle master record representing the nameplate and configuration allocated in this line.',
    `fleet_vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle master record representing the nameplate and configuration allocated in this line.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Line‑level fleet contract tracking needs the employee responsible for each line.',
    `storage_location_id` BIGINT COMMENT 'Reference to the specific delivery location, distribution center, or customer facility where vehicles will be delivered.',
    `allocation_priority` STRING COMMENT 'The priority level for production allocation and delivery scheduling: standard, high, urgent, or critical. Influences manufacturing sequence and resource allocation.. Valid values are `standard|high|urgent|critical`',
    `amendment_notes` STRING COMMENT 'Free-text notes documenting any amendments or changes made to this contract line after initial creation.',
    `body_style` STRING COMMENT 'The body style or vehicle type (e.g., Sedan, SUV, Truck, Van, Coupe). Defines the physical configuration and use case category.',
    `cancellation_reason` STRING COMMENT 'The reason for cancellation if this contract line was cancelled. Captures business justification for contract line termination.',
    `created_by_user_code` STRING COMMENT 'The user ID of the person who created this contract line record. Audit trail for accountability.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this contract line record was first created in the system. Audit trail for record creation.',
    `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for all monetary values in this contract line (e.g., USD, EUR, CAD).. Valid values are `^[A-Z]{3}$`',
    `delivery_window_end_date` DATE COMMENT 'The latest date in the delivery window for vehicles under this contract line. Defines the end of the acceptable delivery period.',
    `delivery_window_start_date` DATE COMMENT 'The earliest date in the delivery window for vehicles under this contract line. Defines the beginning of the acceptable delivery period.',
    `destination_country_code` STRING COMMENT 'The three-letter ISO 3166-1 alpha-3 country code for the destination market of vehicles in this line (e.g., USA, CAN, MEX).. Valid values are `^[A-Z]{3}$`',
    `destination_region` STRING COMMENT 'The geographic region or sales territory where vehicles in this line will be delivered (e.g., Northeast, Southwest, Pacific).',
    `discount_percentage` DECIMAL(18,2) COMMENT 'The percentage discount applied to the MSRP to arrive at the unit contracted price. Represents fleet pricing concession.',
    `exterior_color_code` STRING COMMENT 'The OEM color code for the exterior paint finish specified for vehicles in this line.',
    `fleet_use_type` STRING COMMENT 'The intended use category for the fleet vehicles: commercial (business operations), rental (rental fleet), government (public sector), corporate (executive/employee), utility (service/maintenance), or emergency (police/fire/EMS).. Valid values are `commercial|rental|government|corporate|utility|emergency`',
    `fulfillment_status` STRING COMMENT 'The current fulfillment status of this contract line: pending (not yet started), in_production (vehicles being built), ready_for_delivery (built and awaiting shipment), partially_fulfilled (some units delivered), fully_fulfilled (all units delivered), or cancelled.. Valid values are `pending|in_production|ready_for_delivery|partially_fulfilled|fully_fulfilled|cancelled`',
    `interior_color_code` STRING COMMENT 'The OEM color code for the interior trim and upholstery specified for vehicles in this line.',
    `last_modified_by_user_code` STRING COMMENT 'The user ID of the person who last modified this contract line record. Audit trail for accountability.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this contract line record was last updated. Audit trail for record changes.',
    `line_number` STRING COMMENT 'Sequential line item number within the parent fleet contract. Used for ordering and referencing specific allocations within the contract.',
    `line_status` STRING COMMENT 'The current administrative status of this contract line: active (in force), on_hold (temporarily suspended), cancelled (terminated), completed (fully delivered and closed), or amended (modified after creation).. Valid values are `active|on_hold|cancelled|completed|amended`',
    `model_year` STRING COMMENT 'The model year (MY) of the vehicles allocated in this contract line. Represents the production year designation for the vehicle configuration.',
    `msrp` DECIMAL(18,2) COMMENT 'The Manufacturer Suggested Retail Price (MSRP) for the vehicle configuration in this line. Used as baseline for discount calculations.',
    `nameplate` STRING COMMENT 'The brand and model nameplate of the vehicle allocated in this line (e.g., F-150, Silverado, Camry). Represents the commercial product identity.',
    `planned_production_month` STRING COMMENT 'The planned production month for vehicles in this line, in YYYY-MM format. Aligns with manufacturing scheduling and capacity planning.. Valid values are `^d{4}-(0[1-9]|1[0-2])$`',
    `powertrain_type` STRING COMMENT 'The powertrain technology type for the vehicle: ICE (Internal Combustion Engine), EV (Electric Vehicle), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), or FCEV (Fuel Cell Electric Vehicle).. Valid values are `ICE|EV|HEV|PHEV|FCEV`',
    `quantity_committed` STRING COMMENT 'The total number of vehicle units committed under this contract line. Represents the contractual obligation for delivery.',
    `quantity_fulfilled` STRING COMMENT 'The number of vehicle units that have been delivered and fulfilled against this contract line to date.',
    `quantity_remaining` STRING COMMENT 'The number of vehicle units still pending delivery under this contract line. Calculated as quantity_committed minus quantity_fulfilled.',
    `regulatory_compliance_notes` STRING COMMENT 'Free-text notes documenting any special regulatory compliance requirements for vehicles in this line (e.g., CARB emissions, CAFE standards, safety certifications).',
    `requested_delivery_date` DATE COMMENT 'The customer-requested target delivery date for vehicles in this contract line. May differ from actual delivery schedule.',
    `special_equipment_codes` STRING COMMENT 'Comma-separated list of special equipment or option codes included in the vehicle configuration for this line (e.g., towing package, advanced safety features).',
    `total_line_value` DECIMAL(18,2) COMMENT 'The total monetary value of this contract line, calculated as quantity_committed multiplied by unit_contracted_price.',
    `trim_level` STRING COMMENT 'The specific trim or equipment level of the vehicle (e.g., Base, XLT, Limited, Platinum). Defines the feature set and equipment package.',
    `unit_contracted_price` DECIMAL(18,2) COMMENT 'The negotiated price per vehicle unit for this contract line. Represents the agreed-upon unit price before taxes and fees.',
    CONSTRAINT pk_fleet_contract_line PRIMARY KEY(`fleet_contract_line_id`)
) COMMENT 'Individual vehicle allocation line within a fleet contract specifying a particular nameplate, model year, trim, powertrain type (ICE/EV/HEV/PHEV), quantity committed, unit contracted price, and delivery window. Tracks fulfillment status per line against the parent fleet contract. Enables granular fleet order management and delivery scheduling.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` (
    `msrp_schedule_id` BIGINT COMMENT 'Unique identifier for the MSRP schedule record. Primary key.',
    `model_id` BIGINT COMMENT 'Reference to the vehicle nameplate and configuration this MSRP applies to.',
    `aftersales_nameplate_id` BIGINT COMMENT '',
    `adas_level` STRING COMMENT 'SAE automation level for ADAS features included in this configuration: Level 0 (no automation) through Level 5 (full automation). Impacts pricing and regulatory compliance.. Valid values are `level_0|level_1|level_2|level_3|level_4|level_5`',
    `advertising_fee` DECIMAL(18,2) COMMENT 'Regional or national advertising fee included in the MSRP to fund cooperative advertising programs. Disclosed separately on buyers order.',
    `approved_by` STRING COMMENT 'Name or user ID of the pricing manager or executive who approved this MSRP schedule for publication.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this MSRP schedule was approved for publication. Part of audit trail for pricing governance.',
    `base_msrp` DECIMAL(18,2) COMMENT 'The base MSRP for the vehicle configuration before destination charge, options, taxes, or fees. Expressed in the schedule currency.',
    `body_style` STRING COMMENT 'The body style of the vehicle configuration (sedan, coupe, SUV, truck, van, wagon, convertible, hatchback). [ENUM-REF-CANDIDATE: sedan|coupe|suv|truck|van|wagon|convertible|hatchback — 8 candidates stripped; promote to reference product]',
    `cafe_credit_value` DECIMAL(18,2) COMMENT 'CAFE credit or debit value for this vehicle configuration, used to calculate fleet-wide CAFE compliance. Positive for over-compliance, negative for under-compliance. Confidential regulatory data.',
    `country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code where this MSRP applies (e.g., USA, CAN, MEX, DEU).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this MSRP schedule record was first created in the system. Part of audit trail.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the MSRP amounts (e.g., USD, CAD, EUR, MXN).. Valid values are `^[A-Z]{3}$`',
    `destination_charge` DECIMAL(18,2) COMMENT 'Standard destination and delivery charge applied to transport the vehicle from manufacturing plant to dealer. Mandated by federal regulation to be uniform within a market region.',
    `drivetrain` STRING COMMENT 'Drivetrain configuration: FWD (Front-Wheel Drive), RWD (Rear-Wheel Drive), AWD (All-Wheel Drive), 4WD (Four-Wheel Drive).. Valid values are `fwd|rwd|awd|4wd`',
    `effective_date` DATE COMMENT 'The date from which this MSRP schedule becomes effective. Typically aligned with model year launch or mid-cycle pricing adjustments.',
    `engine_code` STRING COMMENT 'Internal engine code or designation (e.g., 2GR-FE, EcoBoost 3.5L V6). Links to engineering specifications.',
    `epa_fuel_economy_city` STRING COMMENT 'EPA-certified city fuel economy rating in miles per gallon (MPG) for ICE/HEV/PHEV, or MPGe (miles per gallon equivalent) for BEV/FCEV. Used for CAFE compliance and consumer disclosure.',
    `epa_fuel_economy_combined` STRING COMMENT 'EPA-certified combined fuel economy rating (55% city, 45% highway) in MPG or MPGe. Primary metric for CAFE and consumer comparison.',
    `epa_fuel_economy_highway` STRING COMMENT 'EPA-certified highway fuel economy rating in miles per gallon (MPG) or MPGe. Used for CAFE compliance and consumer disclosure.',
    `expiration_date` DATE COMMENT 'The date on which this MSRP schedule expires and is superseded by a new schedule. Null if currently active with no planned end date.',
    `gas_guzzler_tax` DECIMAL(18,2) COMMENT 'Federal gas guzzler tax applied to vehicles with EPA fuel economy below statutory thresholds. Zero if not applicable.',
    `holdback_amount` DECIMAL(18,2) COMMENT 'Manufacturer holdback amount paid to dealer after vehicle sale, typically 2-3% of MSRP. Used to support dealer cash flow and inventory financing. Confidential business data.',
    `invoice_price` DECIMAL(18,2) COMMENT 'The dealer invoice price (wholesale cost to dealer) for this vehicle configuration. Used for dealer margin calculations and incentive programs. Confidential business data.',
    `market_region` STRING COMMENT 'Geographic market region or sales territory where this MSRP schedule applies (e.g., USA, Canada, Mexico, Europe). MSRP may vary by region due to regulatory requirements, taxes, and market conditions.',
    `model_year` STRING COMMENT 'The model year (MY) for which this MSRP schedule is effective. Typically ranges from current year to next year.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this MSRP schedule record was last modified. Updated on any change to pricing, dates, or status.',
    `nameplate` STRING COMMENT 'The vehicle nameplate or model name (e.g., Camry, F-150, Model 3). Denormalized for reporting convenience.',
    `ncap_safety_rating` STRING COMMENT 'Overall NCAP safety rating (1-5 stars) for this vehicle configuration. Used for marketing and consumer safety disclosure. Null if not yet rated.',
    `notes` STRING COMMENT 'Free-text notes or comments about this MSRP schedule, such as rationale for mid-cycle adjustments, competitive positioning, or special market conditions.',
    `option_package_code` STRING COMMENT 'Code representing the factory-installed option package or bundle (e.g., Premium Package, Technology Package, Winter Package). May be null for base configuration.',
    `powertrain_type` STRING COMMENT 'The powertrain type: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), FCEV (Fuel Cell Electric Vehicle).. Valid values are `ice|hev|phev|bev|fcev`',
    `powertrain_warranty_miles` STRING COMMENT 'Extended powertrain warranty duration in miles (e.g., 60,000 miles). Covers engine, transmission, drivetrain components.',
    `powertrain_warranty_months` STRING COMMENT 'Extended powertrain warranty duration in months (e.g., 60 months / 5 years). Typically longer than bumper-to-bumper warranty.',
    `published_timestamp` TIMESTAMP COMMENT 'Date and time when this MSRP schedule was published to dealer systems and public-facing channels (website, configurator, dealer portals).',
    `schedule_number` STRING COMMENT 'Business identifier for the MSRP schedule, typically assigned at model year launch or mid-cycle refresh. Format: MSRP-NNNNNN.. Valid values are `^MSRP-[0-9]{6,10}$`',
    `schedule_status` STRING COMMENT 'Current lifecycle status of the MSRP schedule: draft (pending approval), active (currently in effect), superseded (replaced by newer schedule), archived (historical record).. Valid values are `draft|active|superseded|archived`',
    `schedule_type` STRING COMMENT 'Type of MSRP schedule: launch (initial model year pricing), mid_cycle (mid-year adjustment), promotional (temporary special pricing), fleet (commercial/fleet pricing).. Valid values are `launch|mid_cycle|promotional|fleet`',
    `total_msrp` DECIMAL(18,2) COMMENT 'Total MSRP including base price, destination charge, gas guzzler tax, and any mandatory fees. Excludes dealer-installed accessories and local taxes.',
    `transmission_type` STRING COMMENT 'Type of transmission: manual, automatic, CVT (Continuously Variable Transmission), DCT (Dual-Clutch Transmission).. Valid values are `manual|automatic|cvt|dct`',
    `trim_level` STRING COMMENT 'The trim level or grade of the vehicle (e.g., Base, LE, XLE, Limited, Platinum). Defines the standard equipment package.',
    `warranty_miles` STRING COMMENT 'Standard manufacturer warranty duration in miles (e.g., 36,000 miles). Warranty expires at the earlier of months or miles threshold.',
    `warranty_months` STRING COMMENT 'Standard manufacturer warranty duration in months (e.g., 36 months / 3 years). Used for warranty cost accrual and customer communication.',
    CONSTRAINT pk_msrp_schedule PRIMARY KEY(`msrp_schedule_id`)
) COMMENT 'Official Manufacturer Suggested Retail Price schedule for each vehicle nameplate, model year, trim level, and option package combination. Captures base MSRP, destination and delivery charge, gas guzzler tax (if applicable), effective date, market region, and currency. Serves as the pricing reference baseline for all quotes, orders, and incentive calculations. Updated at model year launch and mid-cycle adjustments.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`sales_territory` (
    `sales_territory_id` BIGINT COMMENT 'Unique identifier for the sales territory. Primary key.',
    `employee_id` BIGINT COMMENT 'FK to workforce.employee',
    `rep_id` BIGINT COMMENT 'Identifier of the sales manager responsible for this territory. Links to employee or sales representative master data.',
    `sales_employee_id` BIGINT COMMENT 'Identifier of the regional director overseeing this territory. Represents the next level of sales leadership hierarchy.',
    `tertiary_sales_regional_director_employee_id` BIGINT COMMENT 'Identifier of the regional director overseeing this territory. Represents the next level of sales leadership hierarchy.',
    `annual_quota_revenue` DECIMAL(18,2) COMMENT 'Annual revenue quota target for this territory in the base currency. Represents expected sales value including MSRP and incentives.',
    `annual_quota_units` STRING COMMENT 'Annual sales quota for this territory measured in vehicle units. Used for performance tracking and incentive calculation.',
    `competitive_intensity` STRING COMMENT 'Assessment of competitive pressure in the territory based on number of competing brands, dealer density, and market share dynamics.. Valid values are `low|medium|high|very_high`',
    `country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code where the territory operates (e.g., USA, CAN, MEX, DEU, CHN).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this territory record was first created in the system. Used for audit trail and data lineage tracking.',
    `dealer_count` STRING COMMENT 'Number of authorized dealerships operating within this territory. Used for dealer network density analysis and coverage planning.',
    `distribution_channel` STRING COMMENT 'Primary distribution channel used in this territory. Direct represents OEM-owned sales, dealer represents franchised network, fleet serves corporate buyers, online covers digital sales, and export handles international shipments.. Valid values are `direct|dealer|fleet|online|export`',
    `district_code` STRING COMMENT 'Code identifying the district within the region. Represents a mid-level geographic or organizational subdivision.. Valid values are `^[A-Z0-9]{2,8}$`',
    `district_name` STRING COMMENT 'Name of the district (e.g., Northeast District, Southern California District).',
    `effective_end_date` DATE COMMENT 'Date when this territory configuration expires or is superseded. Null for currently active territories. Supports territory history and audit trails.',
    `effective_start_date` DATE COMMENT 'Date when this territory configuration becomes active. Used for territory realignment and historical tracking.',
    `fiscal_year` STRING COMMENT 'Fiscal year for which the territory configuration and quotas are defined (e.g., FY2024, FY2025). Aligns with corporate financial planning cycles.. Valid values are `^FY[0-9]{4}$`',
    `household_count` STRING COMMENT 'Number of households in the territory. Key metric for retail automotive market potential analysis.',
    `incentive_program_code` STRING COMMENT 'Code of the primary sales incentive program applicable to this territory. Links to dealer incentive and rebate programs.. Valid values are `^[A-Z0-9]{4,12}$`',
    `language_code` STRING COMMENT 'Primary language code for customer communication and marketing materials in this territory (e.g., en, es, fr, de, zh). Follows ISO 639-1 two-letter codes.. Valid values are `^[a-z]{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this territory record. Supports change tracking and data quality monitoring.',
    `market_segment` STRING COMMENT 'Primary market segment focus for this territory. Determines product mix, pricing strategy, and customer targeting approach.. Valid values are `luxury|premium|mass_market|commercial|electric|performance`',
    `median_household_income` DECIMAL(18,2) COMMENT 'Median household income in the territory. Used for market segmentation and product mix planning (luxury vs. mass market).',
    `model_year_focus` STRING COMMENT 'Primary model year of vehicles being sold in this territory (e.g., MY2024, MY2025). Reflects inventory and product launch timing.. Valid values are `^MY[0-9]{4}$`',
    `modified_by_user` STRING COMMENT 'User ID or name of the person who last modified this territory record. Supports accountability and audit requirements.',
    `notes` STRING COMMENT 'Free-text notes capturing special considerations, territory-specific strategies, market conditions, or operational instructions for sales teams.',
    `population_count` STRING COMMENT 'Total population within the territory boundaries. Used for market sizing and potential customer base estimation.',
    `postal_code_range` STRING COMMENT 'Postal code or ZIP code ranges covered by this territory (e.g., 90001-90099, 91001-91199). Used for geographic assignment of leads and customers.',
    `priority` STRING COMMENT 'Strategic priority level assigned to this territory for resource allocation, investment, and management attention. Strategic territories receive highest focus and support.. Valid values are `strategic|high|medium|low`',
    `quota_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for quota and revenue targets (e.g., USD, EUR, CNY, JPY).. Valid values are `^[A-Z]{3}$`',
    `region_code` STRING COMMENT 'Code identifying the parent region in the geographic hierarchy (e.g., national, regional, district level). Used for roll-up reporting and regional performance tracking.. Valid values are `^[A-Z0-9]{2,8}$`',
    `region_name` STRING COMMENT 'Name of the parent region (e.g., North America, Western Europe, Asia Pacific).',
    `regulatory_region` STRING COMMENT 'Regulatory jurisdiction or compliance region (e.g., EPA, CARB, Euro NCAP, UNECE). Determines applicable emissions standards, safety requirements, and homologation rules.',
    `sales_manager_name` STRING COMMENT 'Full name of the sales manager assigned to this territory for quick reference and reporting.',
    `sales_office_code` STRING COMMENT 'Code of the primary sales office serving this territory. Links to SAP SD sales organization structure.. Valid values are `^[A-Z0-9]{3,8}$`',
    `sales_organization_code` STRING COMMENT 'SAP sales organization code responsible for this territory. Represents the legal entity or business unit managing sales operations.. Valid values are `^[A-Z0-9]{4}$`',
    `state_province_code` STRING COMMENT 'State or province code within the country (e.g., CA for California, ON for Ontario, TX for Texas). May contain multiple values if territory spans multiple states.. Valid values are `^[A-Z0-9]{2,6}$`',
    `territory_code` STRING COMMENT 'Business identifier code for the sales territory used across systems and reporting. Typically alphanumeric format following regional coding standards.. Valid values are `^[A-Z0-9]{3,12}$`',
    `territory_name` STRING COMMENT 'Full descriptive name of the sales territory (e.g., Northeast Region - Metro, California Fleet Sales Zone).',
    `territory_status` STRING COMMENT 'Current operational status of the territory. Active territories are operational, inactive are closed, suspended are temporarily paused, planned are future territories, consolidating are merging with others, and splitting are being divided.. Valid values are `active|inactive|suspended|planned|consolidating|splitting`',
    `territory_type` STRING COMMENT 'Classification of the territory by sales channel or customer segment. Retail serves individual consumers, fleet serves corporate fleet buyers, export covers international markets, commercial targets business customers, government serves public sector, and dealer_network represents indirect sales through franchised dealers.. Valid values are `retail|fleet|export|commercial|government|dealer_network`',
    `time_zone` STRING COMMENT 'Primary time zone for the territory (e.g., America/New_York, Europe/Berlin, Asia/Shanghai). Used for scheduling and operational coordination.',
    `vehicle_category_focus` STRING COMMENT 'Primary vehicle categories sold in this territory (e.g., SUV, Truck, Sedan, EV, Commercial Vehicles). Reflects regional demand patterns and product strategy.',
    `vehicle_registration_count` STRING COMMENT 'Total number of registered vehicles in the territory. Indicates market saturation and replacement demand potential.',
    `zone_code` STRING COMMENT 'Code identifying the zone within the district. Represents the most granular level of the territory hierarchy.. Valid values are `^[A-Z0-9]{2,8}$`',
    `zone_name` STRING COMMENT 'Name of the zone (e.g., Manhattan Zone, Orange County Zone).',
    CONSTRAINT pk_sales_territory PRIMARY KEY(`sales_territory_id`)
) COMMENT 'Geographic or channel-based sales territory definition used to assign sales representatives, dealers, and regional managers to specific market areas. Captures territory code, territory name, region hierarchy (national/regional/district/zone), assigned sales manager, territory type (retail/fleet/export), and effective dates. Supports regional sales performance tracking and quota allocation.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`rep` (
    `rep_id` BIGINT COMMENT 'Unique identifier for the OEM direct sales representative. Primary key.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to sales.channel. Business justification: Normalize channel reference; replace string attribute with FK to channel.',
    `employee_id` BIGINT COMMENT 'User identifier in Salesforce Automotive Cloud. Used to link sales activities, opportunities, and customer interactions to this representative.',
    `tertiary_rep_manager_employee_id` BIGINT COMMENT 'Employee identifier of the direct manager or regional sales manager overseeing this sales representative. Used for reporting hierarchy and approval workflows.',
    `sales_territory_id` BIGINT COMMENT 'Foreign key linking to sales.sales_territory. Business justification: Link sales_rep to its sales territory for proper reporting; replace string code with FK.',
    `active_status` BOOLEAN COMMENT 'Indicates whether the sales representative is currently active and eligible for lead assignment and quota tracking. False indicates inactive (terminated, on leave, or transferred out of sales).',
    `certification_expiry_date` DATE COMMENT 'Date when the current sales certification expires and recertification is required. Null if certification does not expire or is not required for the role.',
    `certification_status` STRING COMMENT 'Status of the representatives sales certification or training completion. Certified indicates all required product, compliance, and sales methodology training is current. Used for dealer-facing role authorization and advanced product sales eligibility.. Valid values are `certified|in_progress|expired|not_required`',
    `commission_plan_code` STRING COMMENT 'Identifier for the incentive compensation plan assigned to the representative. Links to commission structure, bonus tiers, and payout rules in the compensation management system.. Valid values are `^[A-Z0-9]{4,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this sales representative record was first created in the system. Used for audit trail and data lineage tracking.',
    `crm_user_code` STRING COMMENT 'User identifier in Salesforce Automotive Cloud. Used to link sales activities, opportunities, and customer interactions to this representative.',
    `dealer_count` STRING COMMENT 'Number of dealerships assigned to this representative for relationship management and sales support. Applicable primarily to retail field reps and dealer development roles.',
    `email_address` STRING COMMENT 'Primary corporate email address for the sales representative. Used for customer communication and system notifications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `first_name` STRING COMMENT 'Legal first name of the sales representative.',
    `fiscal_year` STRING COMMENT 'Fiscal year for which the current quota is assigned. Used for year-over-year performance comparison and quota planning.',
    `fleet_account_count` STRING COMMENT 'Number of fleet or commercial accounts assigned to this representative. Applicable primarily to fleet account managers and national account executives.',
    `hire_date` DATE COMMENT 'Date the sales representative was hired by the OEM. Used for tenure calculation and eligibility for tenure-based incentives.',
    `language_proficiency` STRING COMMENT 'Comma-separated list of languages the representative is proficient in (e.g., English, Spanish, Mandarin). Used for customer matching and international account assignment.',
    `last_name` STRING COMMENT 'Legal last name of the sales representative.',
    `mobile_number` STRING COMMENT 'Mobile phone number for field sales representative. Used for on-the-go communication and CRM mobile app access.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this sales representative record was last modified. Used for change tracking and data synchronization across systems.',
    `notes` STRING COMMENT 'Free-text field for additional information about the sales representative, such as special skills, awards, territory transition notes, or temporary assignment details.',
    `office_location` STRING COMMENT 'Primary office or branch location where the representative is based (e.g., Detroit HQ, Los Angeles Regional Office, Remote). Used for travel planning and regional coordination.',
    `performance_tier` STRING COMMENT 'Current performance classification based on quota attainment, customer satisfaction (NPS), and other KPIs. Used for recognition programs, incentive multipliers, and career development planning.. Valid values are `platinum|gold|silver|bronze|developing`',
    `phone_number` STRING COMMENT 'Primary business phone number for the sales representative. Used for dealer and customer contact.',
    `product_specialization` STRING COMMENT 'Primary product line or vehicle segment specialization (e.g., Electric Vehicles, Commercial Trucks, Luxury Sedans, SUVs, Performance Vehicles). Used for lead routing and expert assignment in Salesforce Automotive Cloud.',
    `quota_amount` DECIMAL(18,2) COMMENT 'Annual or period-based sales quota target assigned to the representative, expressed in the base currency. Used for performance measurement and incentive compensation calculation.',
    `quota_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the quota amount (e.g., USD, EUR, JPY). Supports multi-currency sales operations.. Valid values are `^[A-Z]{3}$`',
    `quota_period` STRING COMMENT 'Time period over which the quota is measured (annual, quarterly, or monthly). Aligns with fiscal year and performance review cycles.. Valid values are `annual|quarterly|monthly`',
    `region` STRING COMMENT 'Higher-level geographic region grouping multiple territories (e.g., North America, Europe, Asia Pacific, Latin America). Used for regional performance rollup and management hierarchy.',
    `sales_role` STRING COMMENT 'Functional sales role classification defining the representatives primary responsibility area. Retail field reps manage dealer relationships, fleet account managers handle commercial fleet sales, national account executives manage large enterprise accounts, export sales covers international markets, regional sales managers oversee territories, and dealer development focuses on dealer network expansion.. Valid values are `retail_field_rep|fleet_account_manager|national_account_executive|export_sales|regional_sales_manager|dealer_development`',
    `sales_start_date` DATE COMMENT 'Date the representative began their current sales role or territory assignment. May differ from hire_date if the employee transferred from another department or role.',
    `termination_date` DATE COMMENT 'Date the sales representatives employment or sales role ended. Null for active representatives. Used for historical performance analysis and territory reassignment.',
    `territory_name` STRING COMMENT 'Human-readable name of the assigned sales territory (e.g., Northeast Region, California Central, Germany South, National Fleet Accounts).',
    `work_arrangement` STRING COMMENT 'Primary work location arrangement. Field-based representatives spend majority of time visiting dealers or customers; office-based work from regional offices; hybrid split time; remote work from home.. Valid values are `field_based|office_based|hybrid|remote`',
    CONSTRAINT pk_rep PRIMARY KEY(`rep_id`)
) COMMENT 'Master record for OEM direct sales representatives and field sales personnel responsible for managing dealer relationships, fleet accounts, and direct sales channels. Captures employee reference, assigned territory, sales role (retail field rep, fleet account manager, national account executive, export sales), quota assignment, certification status, and active status. Distinct from dealer-side sales staff managed in the dealer domain.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`quota` (
    `quota_id` BIGINT COMMENT 'Unique identifier for the sales quota record. Primary key.',
    `rep_id` BIGINT COMMENT 'Foreign key reference to the entity assigned this quota. Interpretation depends on assignee_type: references sales_representative, dealership, territory, region, or team table.',
    `dealer_incentive_program_id` BIGINT COMMENT 'Foreign key reference to the incentive program associated with this quota. Null if quota is not tied to a specific incentive program.',
    `dealership_id` BIGINT COMMENT 'Foreign key reference to the dealership this quota is assigned to. Null if quota is not dealership-specific.',
    `employee_id` BIGINT COMMENT 'Foreign key reference to the entity assigned this quota. Interpretation depends on assignee_type: references sales_representative, dealership, territory, region, or team table.',
    `quota_rep_id` BIGINT COMMENT 'Foreign key reference to the individual sales representative this quota is assigned to. Null if quota is not individual-specific.',
    `quota_sales_representative_rep_id` BIGINT COMMENT 'Foreign key reference to the individual sales representative this quota is assigned to. Null if quota is not individual-specific.',
    `sales_territory_id` BIGINT COMMENT 'Foreign key reference to the sales territory this quota is assigned to. Null if quota is not territory-specific.',
    `approval_status` STRING COMMENT 'Approval workflow status for the quota: pending (awaiting approval), approved (management approved), rejected (not approved), revision_required (sent back for changes).. Valid values are `pending|approved|rejected|revision_required`',
    `approved_by` STRING COMMENT 'Name or identifier of the manager or executive who approved this quota. Null if not yet approved.',
    `approved_date` DATE COMMENT 'Date on which the quota was approved by management. Null if not yet approved.',
    `assignee_name` STRING COMMENT 'Human-readable name of the quota assignee (representative name, dealer name, territory name, etc.) for reporting and display purposes.',
    `assignee_type` STRING COMMENT 'Type of entity to which the quota is assigned: sales_representative (individual salesperson), dealer (dealership entity), territory (geographic sales territory), region (multi-territory region), district (sales district), zone (sales zone), team (sales team). [ENUM-REF-CANDIDATE: sales_representative|dealer|territory|region|district|zone|team — 7 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the quota record was first created in the system, in format yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `fiscal_month` STRING COMMENT 'Fiscal month within the fiscal year (M01 through M12). Null if quota is quarterly or annual.. Valid values are `^M(0[1-9]|1[0-2])$`',
    `fiscal_quarter` STRING COMMENT 'Fiscal quarter within the fiscal year (Q1, Q2, Q3, Q4). Null if quota is annual or monthly.. Valid values are `Q1|Q2|Q3|Q4`',
    `fiscal_year` STRING COMMENT 'Fiscal year for which the quota is assigned, in format FYYYYYYY (e.g., FY2024). Aligns with corporate fiscal calendar.. Valid values are `^FY[0-9]{4}$`',
    `incentive_eligible` BOOLEAN COMMENT 'Boolean flag indicating whether achievement of this quota makes the assignee eligible for incentive compensation (True) or is a non-incentivized target (False).',
    `model_year` STRING COMMENT 'Model year of vehicles covered by this quota (e.g., MY2024). Used when quota is specific to a model year production run. Null if quota spans multiple model years.. Valid values are `^MY[0-9]{4}$`',
    `modified_by` STRING COMMENT 'User identifier or name of the person who last modified the quota record.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the quota record was last modified, in format yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `quota_name` STRING COMMENT 'Descriptive name for the quota assignment, e.g., Q1 FY2024 Northeast Region EV Target or Annual MY2024 Fleet Sales Goal.',
    `notes` STRING COMMENT 'Free-text notes or comments regarding the quota assignment, special conditions, or context for sales management and reporting.',
    `period_end_date` DATE COMMENT 'End date of the quota performance period. Defines when quota measurement concludes.',
    `period_start_date` DATE COMMENT 'Start date of the quota performance period. Defines when quota measurement begins.',
    `powertrain_type` STRING COMMENT 'Powertrain type this quota applies to: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), FCEV (Fuel Cell Electric Vehicle), all (applies to all powertrains). Null if not powertrain-specific.. Valid values are `ICE|HEV|PHEV|BEV|FCEV|all`',
    `product_line` STRING COMMENT 'Specific product line or brand this quota applies to (e.g., premium brand, economy brand, commercial line). Null if quota applies to all product lines.',
    `quota_number` STRING COMMENT 'Human-readable business identifier for the quota assignment, typically following format QTA-YYYYNNNN.. Valid values are `^QTA-[0-9]{8}$`',
    `quota_status` STRING COMMENT 'Current lifecycle status of the quota: draft (under review), approved (management approved), active (in effect), suspended (temporarily paused), closed (period ended), cancelled (voided before completion).. Valid values are `draft|approved|active|suspended|closed|cancelled`',
    `quota_type` STRING COMMENT 'Classification of the quota by measurement type: unit_volume (vehicle units sold), revenue (dollar/currency target), ev_mix (Electric Vehicle penetration percentage), fleet_penetration (commercial fleet sales), market_share (regional market share target), model_mix (specific model line targets).. Valid values are `unit_volume|revenue|ev_mix|fleet_penetration|market_share|model_mix`',
    `region_code` STRING COMMENT 'Three-letter geographic region code where quota applies (e.g., USA, CAN, MEX, DEU, GBR, CHN, JPN). Follows ISO 3166-1 alpha-3 country codes or internal regional codes.. Valid values are `^[A-Z]{3}$`',
    `revision_number` STRING COMMENT 'Version number of the quota record, incremented each time the quota is revised or adjusted. Initial version is 1.',
    `revision_reason` STRING COMMENT 'Business reason for the most recent revision to the quota (e.g., Market conditions adjustment, Territory realignment, Product launch delay). Null if no revisions have been made.',
    `sales_channel` STRING COMMENT 'Sales channel this quota applies to: retail (individual consumer sales), fleet (corporate fleet sales), commercial (business sales), government (government contracts), direct (OEM direct sales), dealer_network (indirect dealer sales). Null if applies to all channels.. Valid values are `retail|fleet|commercial|government|direct|dealer_network`',
    `target_unit` STRING COMMENT 'Unit of measure for the target_value: units (vehicle count), currency codes (USD, EUR, GBP, JPY, CNY), percentage (for mix/share targets), market_points (for market share basis points). [ENUM-REF-CANDIDATE: units|usd|eur|gbp|jpy|cny|percentage|market_points — 8 candidates stripped; promote to reference product]',
    `target_value` DECIMAL(18,2) COMMENT 'Numeric target value for the quota. Interpretation depends on quota_type: unit count for unit_volume, currency amount for revenue, percentage for ev_mix or market_share.',
    `threshold_minimum` DECIMAL(18,2) COMMENT 'Minimum performance threshold (as percentage of target_value or absolute value) required for any incentive payout or recognition. Null if no minimum threshold applies.',
    `threshold_stretch` DECIMAL(18,2) COMMENT 'Stretch performance threshold (as percentage of target_value or absolute value) that triggers maximum incentive payout or recognition. Null if no stretch threshold applies.',
    `vehicle_segment` STRING COMMENT 'Vehicle segment or category this quota applies to (e.g., sedan, SUV, truck, commercial, luxury). Null if quota applies to all segments. [ENUM-REF-CANDIDATE: sedan|suv|truck|crossover|van|commercial|luxury|compact|midsize — promote to reference product]',
    `created_by` STRING COMMENT 'User identifier or name of the person who created the quota record.',
    CONSTRAINT pk_quota PRIMARY KEY(`quota_id`)
) COMMENT 'Sales volume and revenue quota assigned to a sales representative, dealer, sales territory, or regional team for a defined period (monthly, quarterly, annual). Captures quota type (unit volume, revenue, EV mix, fleet penetration), target value, model year or fiscal period, assigned entity type and reference, and quota approval status. Enables sales performance tracking against targets.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`activity` (
    `activity_id` BIGINT COMMENT 'Unique identifier for the sales activity record. Primary key.',
    `party_id` BIGINT COMMENT 'Reference to the customer account associated with this sales activity.',
    `activity_party_id` BIGINT COMMENT 'Reference to the customer account associated with this sales activity.',
    `rep_id` BIGINT COMMENT 'Reference to the sales representative who performed or is responsible for this sales activity.',
    `activity_sales_representative_rep_id` BIGINT COMMENT 'Reference to the sales representative who performed or is responsible for this sales activity.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle that was the subject of this sales activity, if applicable (e.g., test drive, demo).',
    `campaign_id` BIGINT COMMENT 'Reference to the marketing campaign that generated or is associated with this sales activity.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to sales.channel. Business justification: Channel identifies the sales channel used for the activity; a FK to sales.channel provides a controlled reference and eliminates the free‑text column.',
    `competitor_vehicle_id` BIGINT COMMENT 'Foreign key linking to sales.competitor_vehicle. Business justification: Standardize competitor vehicle reference; replace free‑text with FK to competitor_vehicle.',
    `dealer_contact_id` BIGINT COMMENT 'Reference to the specific contact person involved in this sales activity.',
    `contact_point_id` BIGINT COMMENT 'Reference to the specific contact person involved in this sales activity.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Activity logging audit needs the employee who created the sales activity.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership location where the sales activity took place or is associated with.',
    `sales_lead_id` BIGINT COMMENT 'Reference to the lead record associated with this sales activity, if the activity is related to a lead.',
    `opportunity_id` BIGINT COMMENT 'Reference to the opportunity record associated with this sales activity, if the activity is related to an opportunity.',
    `sales_territory_id` BIGINT COMMENT 'Foreign key linking to sales.sales_territory. Business justification: Sales activity occurs within a sales territory; linking to sales_territory enables consistent reporting and removes the free‑text territory column.',
    `activity_date` DATE COMMENT 'The date on which the sales activity occurred or is scheduled to occur.',
    `activity_number` STRING COMMENT 'Business-facing unique identifier for the sales activity, typically system-generated in format ACT-########.. Valid values are `^ACT-[0-9]{8}$`',
    `activity_status` STRING COMMENT 'Current lifecycle status of the sales activity indicating whether it is scheduled, in progress, completed, cancelled, no-show, or rescheduled.. Valid values are `scheduled|in_progress|completed|cancelled|no_show|rescheduled`',
    `activity_type` STRING COMMENT 'Classification of the sales activity indicating the nature of the interaction (call, email, test drive, demo, site visit, proposal presentation, follow-up, negotiation, or other). [ENUM-REF-CANDIDATE: call|email|meeting|test_drive|demo|site_visit|proposal_presentation|follow_up|negotiation|other — 10 candidates stripped; promote to reference product]',
    `competitor_mentioned` STRING COMMENT 'Name of any competitor brand or product mentioned by the customer during the sales activity.',
    `created_by_user_code` BIGINT COMMENT 'Reference to the user who created this sales activity record in the system.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this sales activity record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the estimated deal value (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `customer_sentiment` STRING COMMENT 'Qualitative assessment of the customers sentiment or attitude during the sales activity (very positive, positive, neutral, negative, very negative).. Valid values are `very_positive|positive|neutral|negative|very_negative`',
    `demo_completed` BOOLEAN COMMENT 'Boolean flag indicating whether a product demonstration was completed as part of this sales activity.',
    `activity_description` STRING COMMENT 'Detailed description or notes about the sales activity, capturing key discussion points, customer feedback, and action items.',
    `duration_minutes` STRING COMMENT 'The duration of the sales activity in minutes, calculated or manually entered.',
    `end_timestamp` TIMESTAMP COMMENT 'The precise date and time when the sales activity ended or is scheduled to end.',
    `estimated_deal_value` DECIMAL(18,2) COMMENT 'Estimated monetary value of the potential deal discussed or progressed during this sales activity, in the base currency.',
    `fiscal_quarter` STRING COMMENT 'Fiscal quarter in which the sales activity occurred (Q1, Q2, Q3, Q4).. Valid values are `Q1|Q2|Q3|Q4`',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the sales activity occurred, in format FY#### (e.g., FY2024).. Valid values are `^FY[0-9]{4}$`',
    `is_commercial_vehicle` BOOLEAN COMMENT 'Boolean flag indicating whether this sales activity involves a commercial vehicle.',
    `is_fleet_sale` BOOLEAN COMMENT 'Boolean flag indicating whether this sales activity is related to a fleet sale opportunity.',
    `location` STRING COMMENT 'Physical or virtual location where the sales activity took place (e.g., dealership showroom, customer site, online).',
    `model_year` STRING COMMENT 'Model year of the vehicle discussed in the sales activity, in format MY#### (e.g., MY2024).. Valid values are `^MY[0-9]{4}$`',
    `modified_by_user_code` BIGINT COMMENT 'Reference to the user who last modified this sales activity record in the system.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this sales activity record was last modified in the system.',
    `next_action` STRING COMMENT 'Description of the next planned action or follow-up step resulting from this sales activity.',
    `next_action_date` DATE COMMENT 'The scheduled date for the next follow-up action or activity.',
    `objection_raised` STRING COMMENT 'Description of any objections or concerns raised by the customer during the sales activity.',
    `objection_resolved` BOOLEAN COMMENT 'Boolean flag indicating whether the customers objection was successfully resolved during the activity.',
    `outcome` STRING COMMENT 'The result or outcome of the sales activity indicating whether it was successful, unsuccessful, pending, no contact made, customer interested, not interested, or callback requested. [ENUM-REF-CANDIDATE: successful|unsuccessful|pending|no_contact|interested|not_interested|callback_requested — 7 candidates stripped; promote to reference product]',
    `priority` STRING COMMENT 'Priority level assigned to the sales activity indicating its urgency and importance (low, medium, high, urgent).. Valid values are `low|medium|high|urgent`',
    `quote_presented` BOOLEAN COMMENT 'Boolean flag indicating whether a price quote or proposal was presented during this sales activity.',
    `region` STRING COMMENT 'Geographic sales region where the activity took place or is associated with.',
    `start_timestamp` TIMESTAMP COMMENT 'The precise date and time when the sales activity started or is scheduled to start.',
    `subject` STRING COMMENT 'Brief subject or title of the sales activity describing the purpose or topic of the interaction.',
    `test_drive_completed` BOOLEAN COMMENT 'Boolean flag indicating whether a test drive was completed as part of this sales activity.',
    CONSTRAINT pk_activity PRIMARY KEY(`activity_id`)
) COMMENT 'Record of a sales-related interaction or activity logged against a lead, opportunity, or customer account. Captures activity type (call, email, test drive, demo, site visit, proposal presentation), activity date and time, outcome, next action, associated opportunity or lead reference, and sales rep performing the activity. Sourced from Salesforce Automotive Cloud Activity/Task/Event objects. Supports pipeline velocity and conversion analysis.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`sales_test_drive` (
    `sales_test_drive_id` BIGINT COMMENT 'Unique identifier for the sales_test_drive data product (auto-inserted pre-linking).',
    `dealership_id` BIGINT COMMENT 'add column dealership_id (BIGINT) with FK to dealer.dealership.dealership_id - sales test drives occur at dealerships',
    `opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: A sales test drive is generated as part of a sales opportunity; adding opportunity_id FK links each test drive to its originating opportunity, eliminating the silo and enabling reporting across the sa',
    `vin_registry_id` BIGINT COMMENT 'add column vin_registry_id (BIGINT) with FK to vehicle.vin_registry.vin_registry_id - sales test drives involve specific vehicles',
    `dealer_test_drive_id` BIGINT COMMENT '',
    CONSTRAINT pk_sales_test_drive PRIMARY KEY(`sales_test_drive_id`)
) COMMENT 'Record of a scheduled or completed vehicle test drive event conducted with a prospect or customer. Captures prospect reference, vehicle VIN or demo vehicle identifier, nameplate and trim driven, test drive date and duration, conducting dealer or direct sales location, prospect feedback rating, and conversion outcome (converted to opportunity or not). Supports lead nurturing and conversion tracking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`trade_in` (
    `trade_in_id` BIGINT COMMENT 'Unique identifier for the trade-in transaction record.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership that appraised and accepted the trade-in vehicle.',
    `employee_id` BIGINT COMMENT 'Reference to the sales representative or appraiser who evaluated the trade-in vehicle.',
    `party_id` BIGINT COMMENT 'Reference to the customer who traded in the vehicle.',
    `trade_employee_id` BIGINT COMMENT 'Reference to the sales representative or appraiser who evaluated the trade-in vehicle.',
    `trade_party_id` BIGINT COMMENT 'Reference to the customer who traded in the vehicle.',
    `vehicle_order_id` BIGINT COMMENT 'Reference to the associated new vehicle purchase order for which this trade-in was accepted.',
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
    `vin` STRING COMMENT '17-character Vehicle Identification Number of the trade-in vehicle, uniquely identifying the vehicle being traded.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_trade_in PRIMARY KEY(`trade_in_id`)
) COMMENT 'Record of a customer vehicle trade-in evaluated and accepted as part of a new vehicle purchase transaction. Captures trade-in vehicle details (VIN, make, model, year, mileage, condition grade), appraised value, agreed trade-in allowance, appraisal date, appraising dealer, and disposition (wholesale auction, certified pre-owned, retail resale). Links to the associated vehicle order.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` (
    `delivery_appointment_id` BIGINT COMMENT 'Unique identifier for the delivery appointment record. Primary key for the delivery appointment entity.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership or delivery center where the vehicle handover will occur.',
    `party_id` BIGINT COMMENT 'Reference to the customer who will take delivery of the vehicle.',
    `employee_id` BIGINT COMMENT 'Reference to the sales representative or delivery specialist assigned to conduct the vehicle handover and customer orientation.',
    `delivery_party_id` BIGINT COMMENT 'Reference to the customer who will take delivery of the vehicle.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle unit being delivered, linked by VIN (Vehicle Identification Number).',
    `delivery_vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle unit being delivered, linked by VIN (Vehicle Identification Number).',
    `technician_id` BIGINT COMMENT 'Reference to the technician who performed the Pre-Delivery Inspection.',
    `primary_delivery_specialist_employee_id` BIGINT COMMENT 'Reference to the sales representative or delivery specialist assigned to conduct the vehicle handover and customer orientation.',
    `rescheduled_from_appointment_id` BIGINT COMMENT 'Reference to the previous delivery appointment if this appointment is a rescheduled version.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Appointment execution requires the shipment tracking number to confirm the correct vehicle is being delivered to the customer.',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`channel` (
    `channel_id` BIGINT COMMENT 'Unique identifier for the sales channel. Primary key.',
    `dealership_id` BIGINT COMMENT 'add column dealership_id (BIGINT) with FK to dealer.dealership.dealership_id - sales channels operate through dealer networks',
    `applicable_powertrain_types` STRING COMMENT 'Comma-separated list of powertrain types eligible for this channel (e.g., ICE, EV, HEV, PHEV, FCEV). Used for product eligibility and incentive program alignment.',
    `applicable_vehicle_types` STRING COMMENT 'Comma-separated list of vehicle types that can be sold through this channel (e.g., sedan, SUV, truck, EV, HEV, PHEV, commercial). Used for channel eligibility rules in lead and opportunity management.',
    `channel_category` STRING COMMENT 'Indicates whether the channel is direct (OEM-owned, no intermediary), indirect (dealer-mediated or third-party), or hybrid (combination of direct and indirect elements).. Valid values are `direct|indirect|hybrid`',
    `channel_status` STRING COMMENT 'Current operational status of the sales channel: active (currently operational), inactive (temporarily not in use), suspended (on hold pending review), planned (future channel not yet launched), discontinued (permanently retired).. Valid values are `active|inactive|suspended|planned|discontinued`',
    `channel_type` STRING COMMENT 'High-level classification of the sales channel: retail (traditional dealer), direct (OEM direct-to-consumer), fleet (commercial/fleet sales), government (public sector contracts), export (international/CKD/SKD), online (digital configurator/e-commerce), cpo (certified pre-owned). [ENUM-REF-CANDIDATE: retail|direct|fleet|government|export|online|cpo — 7 candidates stripped; promote to reference product]',
    `channel_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the sales channel (e.g., RETAIL_DEALER, DIRECT_CONSUMER, FLEET_COMM, GOVT, EXPORT_CKD, ONLINE_CONFIG, CPO). Used for operational reporting and system integration.. Valid values are `^[A-Z0-9_]{2,20}$`',
    `commission_model` STRING COMMENT 'Type of commission structure applied to this channel: fixed (flat fee per unit), percentage (percent of sale price), tiered (volume-based tiers), hybrid (combination), none (no commission, direct OEM).. Valid values are `fixed|percentage|tiered|hybrid|none`',
    `country_codes` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes where this channel operates (e.g., USA, CAN, MEX, DEU, GBR, CHN, JPN). Used for geographic sales attribution and regulatory compliance.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this sales channel record was first created in the system. Used for audit trail and data lineage.',
    `crm_integration_enabled` BOOLEAN COMMENT 'Boolean flag indicating whether this channel is integrated with the CRM system (Salesforce Automotive Cloud) for lead and opportunity tracking (True) or operates independently (False).',
    `default_commission_rate` DECIMAL(18,2) COMMENT 'Default commission rate percentage applied to sales through this channel (e.g., 3.50 for 3.5%). Null if commission model is fixed or none.',
    `channel_description` STRING COMMENT 'Detailed textual description of the sales channel, including its purpose, target customer segments, operational model, and any special characteristics or restrictions.',
    `distribution_channel` STRING COMMENT 'SAP SD distribution channel code associated with this sales channel. Used for order processing, pricing, and logistics routing.',
    `division` STRING COMMENT 'SAP SD division code representing the product line or business unit served by this channel (e.g., passenger vehicles, commercial vehicles, parts and accessories).',
    `dms_integration_enabled` BOOLEAN COMMENT 'Boolean flag indicating whether this channel is integrated with the Dealer Management System (CDK Global DMS) for inventory and order management (True) or not (False).',
    `effective_end_date` DATE COMMENT 'Date when this sales channel was or will be discontinued. Null for currently active channels with no planned end date.',
    `effective_start_date` DATE COMMENT 'Date when this sales channel became or will become operational. Used for temporal validity and historical reporting.',
    `erp_sales_channel_code` STRING COMMENT 'Corresponding sales channel code in the ERP system (SAP S/4HANA SD module). Used for order-to-cash integration and financial reporting.',
    `incentive_eligibility` STRING COMMENT 'Indicates whether sales through this channel are eligible for OEM incentive programs: eligible (fully eligible), ineligible (excluded from incentives), conditional (eligible under specific conditions).. Valid values are `eligible|ineligible|conditional`',
    `is_dealer_mediated` BOOLEAN COMMENT 'Boolean flag indicating whether this channel involves a dealer or distributor intermediary (True) or is a direct OEM channel (False). Used for dealer network analytics and commission calculations.',
    `is_direct_oem` BOOLEAN COMMENT 'Boolean flag indicating whether this channel is a direct OEM-owned channel (True) or an indirect dealer-mediated channel (False). Used for revenue attribution and margin analysis.',
    `lead_source_priority` STRING COMMENT 'Numeric priority ranking for lead routing to this channel (1 = highest priority). Used in lead assignment and opportunity allocation logic.',
    `market_region` STRING COMMENT 'Geographic market region(s) where this sales channel is applicable (e.g., North America, Europe, Asia-Pacific, Latin America, Middle East Africa). May be a comma-separated list for multi-region channels.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this sales channel record was last modified. Used for audit trail and change tracking.',
    `channel_name` STRING COMMENT 'Full descriptive name of the sales channel (e.g., Retail Dealer Network, Direct-to-Consumer, Fleet and Commercial Sales, Government Sales, Export/CKD, Online Configurator, Certified Pre-Owned).',
    `notes` STRING COMMENT 'Free-form notes or comments about the sales channel, including operational considerations, historical context, or special instructions.',
    `owner` STRING COMMENT 'Name or identifier of the business unit or individual responsible for managing this sales channel. Used for accountability and escalation.',
    `pricing_strategy` STRING COMMENT 'Pricing approach used in this channel: msrp (Manufacturer Suggested Retail Price with dealer negotiation), negotiated (fully negotiated pricing), fixed (no-haggle fixed price), dynamic (algorithm-driven pricing), auction (competitive bidding).. Valid values are `msrp|negotiated|fixed|dynamic|auction`',
    `sales_organization` STRING COMMENT 'SAP SD sales organization code responsible for this channel. Links to the organizational hierarchy for revenue reporting and territory management.',
    `supports_financing` BOOLEAN COMMENT 'Boolean flag indicating whether this channel offers financing options (True) or requires cash/external financing (False).',
    `supports_fleet_sales` BOOLEAN COMMENT 'Boolean flag indicating whether this channel supports fleet or commercial bulk sales (True) or is limited to individual retail sales (False).',
    `supports_leasing` BOOLEAN COMMENT 'Boolean flag indicating whether this channel offers leasing options (True) or does not support leasing (False).',
    `supports_online_configuration` BOOLEAN COMMENT 'Boolean flag indicating whether this channel supports online vehicle configuration and ordering (True) or requires in-person interaction (False).',
    `supports_trade_in` BOOLEAN COMMENT 'Boolean flag indicating whether this channel accepts trade-in vehicles as part of the transaction (True) or does not support trade-ins (False).',
    CONSTRAINT pk_channel PRIMARY KEY(`channel_id`)
) COMMENT 'Reference master defining the sales channels through which vehicles are sold, including retail dealer, direct-to-consumer, fleet/commercial, government, export/CKD, online configurator, and certified pre-owned channels. Captures channel code, channel name, channel type, applicable market regions, and whether the channel is direct (OEM) or indirect (dealer-mediated). Used for channel attribution across leads, opportunities, and orders.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` (
    `price_adjustment_id` BIGINT COMMENT 'Unique identifier for the price adjustment record. Primary key.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership applying or requesting the price adjustment.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Price Adjustment Posting: adjustments must be posted to a specific GL account for audit and financial impact tracking.',
    `party_id` BIGINT COMMENT 'Reference to the customer receiving the price adjustment.',
    `employee_id` BIGINT COMMENT 'Reference to the manager or executive who authorized this price adjustment.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle configuration or unit to which this price adjustment applies.',
    `price_vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle configuration or unit to which this price adjustment applies.',
    `quote_id` BIGINT COMMENT 'Reference to the sales quote to which this price adjustment applies.',
    `vehicle_order_id` BIGINT COMMENT 'Reference to the vehicle order to which this price adjustment applies.',
    `adjusted_price` DECIMAL(18,2) COMMENT 'The resulting price after this adjustment is applied. May be further adjusted by subsequent adjustments in the pricing waterfall.',
    `adjustment_amount` DECIMAL(18,2) COMMENT 'The monetary value of the price adjustment in the transaction currency. Negative values represent discounts or reductions; positive values represent surcharges or premiums (rare but possible for special equipment or expedited delivery).',
    `adjustment_category` STRING COMMENT 'High-level grouping of the adjustment type for reporting and analysis purposes. Distinguishes between manufacturer-funded incentives, dealer-funded discounts, and other adjustment sources. [ENUM-REF-CANDIDATE: manufacturer_incentive|dealer_discount|regional_program|customer_loyalty|fleet_commercial|employee_affiliate|promotional_campaign|competitive_response|inventory_management|executive_override — 10 candidates stripped; promote to reference product]',
    `adjustment_method` STRING COMMENT 'Method by which the adjustment is calculated: fixed dollar amount, percentage of MSRP or invoice, tiered based on volume or other criteria, or formula-based calculation.. Valid values are `fixed_amount|percentage|tiered|formula_based`',
    `adjustment_number` STRING COMMENT 'Business-facing unique reference number for the price adjustment, used for tracking and audit purposes.',
    `adjustment_percentage` DECIMAL(18,2) COMMENT 'The percentage rate of the price adjustment when the adjustment method is percentage-based. Stored as a decimal (e.g., 5.00 for 5%).',
    `adjustment_type` STRING COMMENT 'Classification of the price adjustment indicating the program or reason for the non-standard pricing. Includes dealer discretionary discounts, manufacturer-authorized regional allowances, conquest and loyalty programs, fleet volume discounts, employee purchase programs, and other special pricing categories. [ENUM-REF-CANDIDATE: dealer_discount|regional_allowance|conquest_bonus|loyalty_discount|fleet_volume_discount|employee_purchase_program|military_discount|first_responder_discount|college_graduate_discount|lease_subvention|finance_subvention|trade_assistance|competitive_conquest|model_year_clearance|inventory_reduction|executive_authorization — 16 candidates stripped; promote to reference product]',
    `applied_date` DATE COMMENT 'Date on which the price adjustment was actually applied to the quote or order.',
    `approval_date` DATE COMMENT 'Date on which the price adjustment was approved by the authorizing manager.',
    `approval_status` STRING COMMENT 'Current approval state of the price adjustment request. Tracks the adjustment through the authorization workflow.. Valid values are `pending|approved|rejected|expired|revoked`',
    `audit_date` DATE COMMENT 'Date on which this price adjustment was reviewed during an audit process.',
    `audit_flag` BOOLEAN COMMENT 'Indicates whether this price adjustment has been flagged for audit review due to unusual amount, authorization level, or other risk factors.',
    `audit_outcome` STRING COMMENT 'Result of the audit review for this price adjustment, if audited.. Valid values are `approved|exception_noted|corrective_action_required|fraudulent`',
    `authorization_level` STRING COMMENT 'The organizational level required to approve this price adjustment. Higher-value or non-standard adjustments require escalated authorization. [ENUM-REF-CANDIDATE: dealer_manager|regional_manager|zone_director|national_sales_director|vice_president|executive_authorization|automated_program — 7 candidates stripped; promote to reference product]',
    `base_price` DECIMAL(18,2) COMMENT 'The original price (MSRP or invoice price) before this adjustment is applied, providing context for the adjustment magnitude.',
    `cost_center` STRING COMMENT 'Cost center to which the financial impact of this price adjustment is allocated for internal accounting purposes.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this price adjustment record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the adjustment amount (e.g., USD, CAD, EUR, MXN).. Valid values are `^[A-Z]{3}$`',
    `effective_end_date` DATE COMMENT 'Date after which this price adjustment is no longer valid. Null for adjustments without expiration.',
    `effective_start_date` DATE COMMENT 'Date from which this price adjustment becomes valid and can be applied to transactions.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month or quarter) within the fiscal year when the adjustment was applied.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the price adjustment was applied, used for financial reporting and incentive accrual tracking.',
    `funding_source` STRING COMMENT 'Entity responsible for funding the price adjustment. Distinguishes between manufacturer-funded incentives and dealer-funded discounts.. Valid values are `manufacturer|dealer|shared|regional_marketing|national_advertising`',
    `gl_account` STRING COMMENT 'General ledger account code to which the price adjustment amount is posted for financial reporting.',
    `justification` STRING COMMENT 'Business rationale and supporting explanation for the price adjustment. Provides audit trail and context for non-standard pricing decisions.',
    `model_year` STRING COMMENT 'Model year of the vehicle to which this price adjustment applies. Adjustments often vary by model year for inventory clearance purposes.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this price adjustment record was last modified.',
    `notes` STRING COMMENT 'Additional free-text notes or comments related to the price adjustment, providing supplementary context beyond the structured justification field.',
    `program_code` STRING COMMENT 'Reference code for the manufacturer or dealer incentive program under which this adjustment is authorized, if applicable.',
    `program_name` STRING COMMENT 'Descriptive name of the incentive program associated with this price adjustment.',
    `region_code` STRING COMMENT 'Geographic sales region code where the adjustment is applicable. Regional allowances and programs vary by market.',
    `rejection_date` DATE COMMENT 'Date on which the price adjustment request was rejected, if applicable.',
    `rejection_reason` STRING COMMENT 'Explanation provided by the approving authority for rejecting the price adjustment request.',
    `sales_channel` STRING COMMENT 'Distribution channel through which the sale is being made. Different channels may have different adjustment authorization rules and limits. [ENUM-REF-CANDIDATE: retail|fleet|commercial|government|employee|direct|online|auction — 8 candidates stripped; promote to reference product]',
    `stacking_allowed` BOOLEAN COMMENT 'Indicates whether this price adjustment can be combined (stacked) with other adjustments and incentives. Some programs are mutually exclusive.',
    `submitting_user_code` BIGINT COMMENT 'Reference to the sales representative or dealer user who submitted the price adjustment request.',
    `territory_code` STRING COMMENT 'Sales territory code within the region where the adjustment is applicable.',
    `vin` STRING COMMENT '17-character unique identifier for the vehicle to which this price adjustment applies, if the vehicle has been assigned a VIN at the time of adjustment.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_price_adjustment PRIMARY KEY(`price_adjustment_id`)
) COMMENT 'Record of a price adjustment applied to a vehicle order or quote beyond standard MSRP and published incentive programs. Captures adjustment type (dealer discount, regional allowance, conquest bonus, loyalty discount, fleet volume discount, employee purchase program), adjustment amount or percentage, authorization level, approving manager, and justification. Provides audit trail for non-standard pricing decisions.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`order_status_event` (
    `order_status_event_id` BIGINT COMMENT 'Unique identifier for the order status event record. Primary key.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership or dealer location that placed or is fulfilling the order.',
    `employee_id` BIGINT COMMENT 'The user or system account that triggered the status change. May be a human user ID or a system service account identifier.',
    `party_id` BIGINT COMMENT 'Reference to the customer who placed the order. Enables customer-specific order tracking and communication.',
    `order_party_id` BIGINT COMMENT 'Reference to the customer who placed the order. Enables customer-specific order tracking and communication.',
    `vin_registry_id` BIGINT COMMENT 'Internal unique identifier for the vehicle master record associated with this order.',
    `order_vin_registry_id` BIGINT COMMENT 'Internal unique identifier for the vehicle master record associated with this order.',
    `vehicle_order_id` BIGINT COMMENT 'Reference to the vehicle order that experienced the status change. Links to the parent order entity.',
    `actual_delivery_date` DATE COMMENT 'The actual date when the vehicle was delivered to the dealer or customer. Populated when the order transitions to delivered status.',
    `actual_production_completion_date` DATE COMMENT 'The actual date when the vehicle completed assembly and exited the production line. Populated when the order transitions to built status.',
    `actual_production_start_date` DATE COMMENT 'The actual date when the vehicle entered the production line. Populated when the order transitions to in_production status.',
    `carrier_name` STRING COMMENT 'The name of the logistics carrier or transportation provider responsible for shipping the vehicle. Relevant for shipped and in_transit status events.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this order status event record was first created in the data system. Audit field for data lineage and compliance.',
    `delay_days` STRING COMMENT 'The number of days the order is delayed relative to the original schedule. Calculated when a status transition occurs later than planned.',
    `destination_location` STRING COMMENT 'The destination location where the vehicle is being delivered. Typically the dealership code or customer delivery address reference.',
    `estimated_delivery_date` DATE COMMENT 'The estimated date when the vehicle is expected to arrive at the dealer or customer location. Updated as the order progresses through logistics.',
    `event_notes` STRING COMMENT 'Free-text notes or comments associated with the status change event. Provides additional context or details not captured in structured fields.',
    `event_timestamp` TIMESTAMP COMMENT 'The precise date and time when the order status transition occurred in the source system. This is the business event time, distinct from audit timestamps.',
    `event_type` STRING COMMENT 'Classification of the status event. Distinguishes routine status progressions from exceptions, cancellations, or amendments.. Valid values are `status_change|milestone_reached|exception|cancellation|amendment`',
    `exception_flag` BOOLEAN COMMENT 'Indicates whether this status event represents an exception or deviation from the normal order fulfillment process. True if exception, False otherwise.',
    `exception_reason` STRING COMMENT 'Detailed explanation of the exception or deviation, if exception_flag is True. Examples include production delay, quality hold, parts shortage, logistics delay, customer request.',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the status event occurred. Used for financial and operational reporting alignment.',
    `model_year` STRING COMMENT 'The model year of the vehicle associated with the order. Used for product lifecycle and sales analytics.',
    `modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this order status event record was last modified in the data system. Audit field for data lineage and compliance.',
    `new_status` STRING COMMENT 'The order status after this transition event. Captures the to-state in the order lifecycle. Enables end-to-end order tracking through the fulfillment pipeline. [ENUM-REF-CANDIDATE: confirmed|scheduled_for_production|in_production|built|quality_released|shipped|in_transit|at_dealer|delivered|cancelled — 10 candidates stripped; promote to reference product]',
    `notification_channel` STRING COMMENT 'The communication channel used to notify the customer of the status change. Examples include email, SMS, mobile app push notification, customer portal, phone call.. Valid values are `email|sms|push|portal|phone|none`',
    `notification_sent_flag` BOOLEAN COMMENT 'Indicates whether a customer notification was sent for this status change event. True if notification sent, False otherwise.',
    `origin_location` STRING COMMENT 'The location from which the vehicle was shipped. Typically the manufacturing plant or distribution center code.',
    `plant_code` STRING COMMENT 'The code of the manufacturing plant or assembly facility where the vehicle is being produced. Relevant for production and post-production status events.',
    `previous_status` STRING COMMENT 'The order status immediately before this transition event. Captures the from-state in the order lifecycle. [ENUM-REF-CANDIDATE: placed|confirmed|scheduled_for_production|in_production|built|quality_released|shipped — 7 candidates stripped; promote to reference product]',
    `production_line` STRING COMMENT 'The specific production line or assembly line within the plant where the vehicle is being built. Captured during in-production status events.',
    `quality_release_date` DATE COMMENT 'The date when the vehicle passed final quality inspection and was released for shipment. Populated when the order transitions to quality_released status.',
    `region` STRING COMMENT 'The sales region or geographic market where the order is being fulfilled. Used for regional performance tracking and logistics planning.',
    `responsible_party` STRING COMMENT 'The business unit, department, or role responsible for the status transition. Examples include Production Planning, Manufacturing, Quality Assurance, Logistics, Dealer Network.',
    `sales_channel` STRING COMMENT 'The sales channel through which the order was placed. Examples include retail (dealer), fleet sales, commercial vehicle sales, direct-to-consumer, online sales.. Valid values are `retail|fleet|commercial|direct|online`',
    `scheduled_production_date` DATE COMMENT 'The planned date when the vehicle is scheduled to enter production. Populated when the order transitions to scheduled_for_production status.',
    `shipment_date` DATE COMMENT 'The date when the vehicle was shipped from the manufacturing plant or distribution center. Populated when the order transitions to shipped status.',
    `tracking_number` STRING COMMENT 'The tracking number or shipment reference provided by the carrier for end-to-end logistics visibility.',
    `triggering_system` STRING COMMENT 'The source system or application that initiated the status change event. Examples include SAP SD (Sales and Distribution), MES (Manufacturing Execution System), TMS (Transportation Management System), WMS (Warehouse Management System), DMS (Dealer Management System), Salesforce Automotive Cloud, or manual entry. [ENUM-REF-CANDIDATE: SAP_SD|MES|WMS|TMS|DMS|SALESFORCE|MANUAL — 7 candidates stripped; promote to reference product]',
    `triggering_user_code` STRING COMMENT 'The user or system account that triggered the status change. May be a human user ID or a system service account identifier.',
    `vin` STRING COMMENT 'The 17-character Vehicle Identification Number assigned to the vehicle associated with this order. Populated once the vehicle enters production and a VIN is assigned.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_order_status_event PRIMARY KEY(`order_status_event_id`)
) COMMENT 'Lifecycle status change event record for a vehicle order, capturing each transition through the order fulfillment pipeline (placed → confirmed → scheduled for production → in production → built → quality released → shipped → in transit → at dealer → delivered). Records event timestamp, previous status, new status, triggering system (SAP SD, MES, logistics), and responsible party. Enables end-to-end order tracking and customer communication.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`campaign` (
    `campaign_id` BIGINT COMMENT 'Unique surrogate key for the sales campaign record.',
    `employee_id` BIGINT COMMENT 'Identifier of the sales representative or manager responsible for the campaign.',
    `aftersales_nameplate_id` BIGINT COMMENT '',
    `owner_employee_id` BIGINT COMMENT 'Identifier of the sales representative or manager responsible for the campaign.',
    `actual_spent_amount` DECIMAL(18,2) COMMENT 'Total amount actually spent on the campaign to date.',
    `actual_spent_currency` STRING COMMENT 'ISO 4217 currency code for the actual spent amount.. Valid values are `^[A-Z]{3}$`',
    `budget_amount` DECIMAL(18,2) COMMENT 'Planned monetary budget allocated to the campaign.',
    `budget_currency` STRING COMMENT 'ISO 4217 currency code for the budget amount.. Valid values are `^[A-Z]{3}$`',
    `campaign_status` STRING COMMENT 'Current lifecycle state of the campaign.. Valid values are `planned|active|completed|cancelled|on_hold`',
    `campaign_type` STRING COMMENT 'Category of the campaign indicating its strategic purpose.. Valid values are `model_launch|clearance|seasonal|conquest|loyalty`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the campaign record was first created.',
    `dealer_participation_flag` BOOLEAN COMMENT 'Indicates whether dealers are required to participate in the campaign.',
    `campaign_description` STRING COMMENT 'Free‑form text describing the campaign goals, scope, and key messages.',
    `end_date` DATE COMMENT 'Date when the campaign is scheduled to end.',
    `kpi_market_share_actual` DECIMAL(18,2) COMMENT 'Observed market‑share percentage change achieved by the campaign.',
    `kpi_market_share_target` DECIMAL(18,2) COMMENT 'Target market‑share percentage increase for the nameplate during the campaign period.',
    `kpi_sales_volume_actual` STRING COMMENT 'Actual number of vehicles sold attributable to the campaign.',
    `kpi_sales_volume_target` STRING COMMENT 'Planned number of vehicles to be sold as a result of the campaign.',
    `marketing_channels` STRING COMMENT 'Primary channels used to deliver the campaign messaging.. Valid values are `dealer|online|direct|partner|mixed`',
    `campaign_name` STRING COMMENT 'Human‑readable name of the campaign used in reporting and UI.',
    `notes` STRING COMMENT 'Free‑form field for any supplemental information or remarks.',
    `objective` STRING COMMENT 'High‑level business objective the campaign aims to achieve (e.g., increase sales volume, improve market share).',
    `priority` STRING COMMENT 'Business priority assigned to the campaign.. Valid values are `low|medium|high`',
    `region_code` STRING COMMENT 'Three‑letter ISO code representing the primary geographic region of the campaign.. Valid values are `^[A-Z]{3}$`',
    `start_date` DATE COMMENT 'Date when the campaign becomes active.',
    `target_customer_segment` STRING COMMENT 'Customer segment the campaign is designed for.. Valid values are `fleet|consumer|luxury|commercial`',
    `target_model_year` STRING COMMENT 'Model year of the vehicle nameplate targeted by the campaign.',
    `target_nameplate` STRING COMMENT 'Vehicle nameplate (model family) that the campaign is aimed at.',
    `territory_code` STRING COMMENT 'Internal code for the sales territory covered by the campaign.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the campaign record.',
    CONSTRAINT pk_campaign PRIMARY KEY(`campaign_id`)
) COMMENT 'Master record for a structured sales and marketing campaign targeting specific customer segments, nameplates, or market regions to drive vehicle sales. Captures campaign name, campaign type (model launch, clearance, seasonal, conquest, loyalty), target nameplate and model year, target customer segment, campaign period, budget allocation, participating dealers or regions, and campaign objectives. Distinct from incentive programs — campaigns coordinate multi-channel outreach while incentive programs define financial offers.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`campaign_response` (
    `campaign_response_id` BIGINT COMMENT 'Unique identifier for the campaign response record. Primary key.',
    `party_id` BIGINT COMMENT 'Reference to the existing customer who responded to the campaign, if the respondent is an existing customer.',
    `campaign_id` BIGINT COMMENT 'Reference to the sales or marketing campaign that generated this response.',
    `campaign_party_id` BIGINT COMMENT 'Reference to the existing customer who responded to the campaign, if the respondent is an existing customer.',
    `rep_id` BIGINT COMMENT 'Reference to the sales representative assigned to follow up on this campaign response.',
    `campaign_sales_representative_rep_id` BIGINT COMMENT 'Reference to the sales representative assigned to follow up on this campaign response.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership assigned to follow up on this campaign response, or the dealership where the response was captured.',
    `individual_id` BIGINT COMMENT 'Reference to the prospect record if the respondent is a new prospect not yet in the customer master.',
    `opportunity_id` BIGINT COMMENT 'Reference to the opportunity record if this response was converted to a sales opportunity.',
    `sales_lead_id` BIGINT COMMENT 'Reference to the lead record if this response was converted to a lead.',
    `city` STRING COMMENT 'City where the respondent is located.',
    `conversion_date` DATE COMMENT 'The date when this campaign response was converted to a lead or opportunity.',
    `converted_to_lead` BOOLEAN COMMENT 'Indicates whether this campaign response was converted into a lead record (True/False).',
    `converted_to_opportunity` BOOLEAN COMMENT 'Indicates whether this campaign response was converted into a sales opportunity record (True/False).',
    `country_code` STRING COMMENT 'Three-letter ISO country code where the respondent is located.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this campaign response record was first created in the system.',
    `financing_interest` BOOLEAN COMMENT 'Indicates whether the respondent expressed interest in financing options (True/False).',
    `model_year_interest` STRING COMMENT 'The model year of the vehicle the respondent expressed interest in.',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time when this campaign response record was last modified or updated.',
    `opt_in_email` BOOLEAN COMMENT 'Indicates whether the respondent opted in to receive email communications (True/False).',
    `opt_in_phone` BOOLEAN COMMENT 'Indicates whether the respondent opted in to receive phone call communications (True/False).',
    `opt_in_sms` BOOLEAN COMMENT 'Indicates whether the respondent opted in to receive SMS communications (True/False).',
    `postal_code` STRING COMMENT 'Postal or ZIP code of the respondents location.',
    `powertrain_interest` STRING COMMENT 'The powertrain type the respondent expressed interest in: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), FCEV (Fuel Cell Electric Vehicle).. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `purchase_timeframe` STRING COMMENT 'The timeframe within which the respondent indicated they plan to purchase a vehicle (e.g., immediate, 1-3 months, 3-6 months, 6-12 months, over 12 months, undecided).. Valid values are `immediate|1_3_months|3_6_months|6_12_months|over_12_months|undecided`',
    `region_code` STRING COMMENT 'The sales region code where the campaign response originated or is assigned for follow-up.',
    `respondent_email` STRING COMMENT 'Email address of the individual who responded to the campaign.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `respondent_first_name` STRING COMMENT 'First name of the individual who responded to the campaign.',
    `respondent_last_name` STRING COMMENT 'Last name of the individual who responded to the campaign.',
    `respondent_phone` STRING COMMENT 'Phone number of the individual who responded to the campaign.',
    `response_channel` STRING COMMENT 'The channel through which the prospect or customer responded to the campaign (e.g., email click, web form submission, phone inquiry, dealer visit, mobile app, social media).. Valid values are `email|web_form|phone|dealer_visit|mobile_app|social_media`',
    `response_date` DATE COMMENT 'The calendar date when the prospect or customer responded to the campaign, used for day-level reporting and analytics.',
    `response_notes` STRING COMMENT 'Free-text notes or comments captured during the response or follow-up activities.',
    `response_number` STRING COMMENT 'Business-facing unique identifier or tracking number for the campaign response, used for reference and reporting purposes.',
    `response_score` STRING COMMENT 'Numeric score representing the quality or likelihood of conversion for this campaign response, typically calculated by lead scoring algorithms.',
    `response_source` STRING COMMENT 'The specific source or touchpoint that generated the response (e.g., email campaign name, landing page URL, event name, advertisement ID).',
    `response_status` STRING COMMENT 'Current lifecycle status of the campaign response (e.g., new, contacted, qualified, converted to lead or opportunity, disqualified, closed).. Valid values are `new|contacted|qualified|converted|disqualified|closed`',
    `response_timestamp` TIMESTAMP COMMENT 'The date and time when the prospect or customer responded to the campaign. This is the principal business event timestamp for this transaction.',
    `response_type` STRING COMMENT 'The type or nature of the response action taken by the prospect or customer (e.g., inquiry, test drive request, quote request, brochure download, event registration, callback request).. Valid values are `inquiry|test_drive_request|quote_request|brochure_download|event_registration|callback_request`',
    `state_province` STRING COMMENT 'State or province where the respondent is located.',
    `test_drive_requested` BOOLEAN COMMENT 'Indicates whether the respondent requested a test drive as part of their response (True/False).',
    `trade_in_interest` BOOLEAN COMMENT 'Indicates whether the respondent expressed interest in trading in an existing vehicle (True/False).',
    `utm_campaign` STRING COMMENT 'UTM campaign tracking parameter captured from the response URL for digital attribution.',
    `utm_medium` STRING COMMENT 'UTM medium tracking parameter captured from the response URL for digital attribution.',
    `utm_source` STRING COMMENT 'UTM source tracking parameter captured from the response URL for digital attribution.',
    `vehicle_interest_category` STRING COMMENT 'The category or body style of vehicle the respondent expressed interest in (e.g., sedan, SUV, truck, van, coupe, convertible, hatchback, wagon, commercial vehicle). [ENUM-REF-CANDIDATE: sedan|suv|truck|van|coupe|convertible|hatchback|wagon|commercial — 9 candidates stripped; promote to reference product]',
    `vehicle_model_interest` STRING COMMENT 'The specific vehicle model or nameplate the respondent expressed interest in.',
    CONSTRAINT pk_campaign_response PRIMARY KEY(`campaign_response_id`)
) COMMENT 'Record of a prospect or customer response to a sales campaign, capturing the response channel (email click, web form, dealer visit, phone inquiry), response date, responding individual reference, campaign attributed, and whether the response converted to a lead or opportunity. Enables campaign ROI measurement and attribution modeling.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` (
    `competitor_vehicle_id` BIGINT COMMENT 'Unique identifier for the competitor vehicle record in the competitive intelligence catalog.',
    `model_id` BIGINT COMMENT 'add column model_id (BIGINT) with FK to vehicle.model.model_id - competitor vehicles are benchmarked against own models',
    `adas_level` STRING COMMENT 'The SAE automation level of the competitor vehicles Advanced Driver Assistance Systems (ADAS) capabilities (Level 0 through Level 5).. Valid values are `none|level1|level2|level3|level4|level5`',
    `base_msrp` DECIMAL(18,2) COMMENT 'The manufacturer suggested retail price (MSRP) for the base trim level of the competitor vehicle, used for pricing comparison and competitive positioning.',
    `battery_capacity_kwh` DECIMAL(18,2) COMMENT 'The battery pack capacity in kilowatt-hours for electric and plug-in hybrid vehicles. Null for pure ICE vehicles.',
    `body_style` STRING COMMENT 'The body style configuration of the competitor vehicle (e.g., sedan, SUV, pickup truck). [ENUM-REF-CANDIDATE: sedan|coupe|hatchback|wagon|suv|crossover|pickup|van|convertible|roadster — 10 candidates stripped; promote to reference product]',
    `cargo_volume_cubic_ft` DECIMAL(18,2) COMMENT 'The cargo volume capacity in cubic feet, used for utility and practicality comparison.',
    `competitive_positioning` STRING COMMENT 'Classification of how this competitor vehicle positions against our portfolio: direct (head-to-head competitor), indirect (adjacent segment), or emerging (new market entrant).. Valid values are `direct|indirect|emerging`',
    `competitor_brand` STRING COMMENT 'The brand name of the competing Original Equipment Manufacturer (OEM) such as Toyota, Ford, BMW, Tesla, etc.',
    `competitor_vehicle_status` STRING COMMENT 'The current status of the competitor vehicle in the market: active (currently available), discontinued (no longer produced), upcoming (announced but not yet available), or rumored (unconfirmed future model).. Valid values are `active|discontinued|upcoming|rumored`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this competitor vehicle record was first created in the system.',
    `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for the base MSRP (e.g., USD, EUR, CAD).. Valid values are `^[A-Z]{3}$`',
    `data_source` STRING COMMENT 'The source of the competitive intelligence data (e.g., manufacturer website, automotive press, dealer intelligence, third-party research firm).',
    `discontinuation_date` DATE COMMENT 'The date when this competitor vehicle model was discontinued or end of production (EOP) was announced. Null if still in production.',
    `drivetrain_type` STRING COMMENT 'The drivetrain configuration: FWD (Front-Wheel Drive), RWD (Rear-Wheel Drive), AWD (All-Wheel Drive), or 4WD (Four-Wheel Drive).. Valid values are `fwd|rwd|awd|4wd`',
    `electric_range_miles` STRING COMMENT 'The all-electric driving range in miles for BEV and PHEV vehicles, based on EPA or WLTP testing standards.',
    `engine_displacement_liters` DECIMAL(18,2) COMMENT 'The engine displacement in liters for ICE or hybrid powertrains. Null for pure electric vehicles.',
    `fuel_economy_city_mpg` DECIMAL(18,2) COMMENT 'The EPA-rated city fuel economy in miles per gallon for ICE and hybrid vehicles.',
    `fuel_economy_combined_mpg` DECIMAL(18,2) COMMENT 'The EPA-rated combined fuel economy in miles per gallon for ICE and hybrid vehicles.',
    `fuel_economy_highway_mpg` DECIMAL(18,2) COMMENT 'The EPA-rated highway fuel economy in miles per gallon for ICE and hybrid vehicles.',
    `horsepower` STRING COMMENT 'The maximum horsepower output of the competitor vehicle powertrain, used for performance comparison.',
    `key_features` STRING COMMENT 'Comma-separated list of key feature highlights and differentiators of the competitor vehicle used in competitive battle cards and sales coaching (e.g., adaptive cruise control, panoramic sunroof, premium audio system).',
    `last_updated_date` DATE COMMENT 'The date when the competitor vehicle information was last updated by the sales strategy team.',
    `launch_date` DATE COMMENT 'The date when this competitor vehicle model was launched or introduced to the market.',
    `market_availability_region` STRING COMMENT 'The geographic regions or markets where this competitor vehicle is available for sale (e.g., North America, Europe, Asia-Pacific).',
    `model_year` STRING COMMENT 'The model year (MY) designation of the competitor vehicle, representing the production year classification used for marketing and regulatory purposes.',
    `modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this competitor vehicle record was last modified in the system.',
    `notes` STRING COMMENT 'Free-text notes capturing additional competitive intelligence, market insights, or strategic observations about this competitor vehicle.',
    `powertrain_type` STRING COMMENT 'The powertrain technology of the competitor vehicle: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), or FCEV (Fuel Cell Electric Vehicle).. Valid values are `ice|hev|phev|bev|fcev`',
    `safety_rating_ncap` STRING COMMENT 'The New Car Assessment Programme (NCAP) overall safety rating (e.g., 5-star, 4-star) from Euro NCAP, NHTSA, or other regional testing authority.',
    `seating_capacity` STRING COMMENT 'The maximum number of passengers the competitor vehicle can accommodate.',
    `torque_lb_ft` STRING COMMENT 'The maximum torque output in pound-feet, used for performance and capability comparison.',
    `towing_capacity_lbs` STRING COMMENT 'The maximum towing capacity in pounds when properly equipped, relevant for trucks and SUVs.',
    `transmission_type` STRING COMMENT 'The transmission type and configuration (e.g., 8-speed automatic, CVT, 6-speed manual, single-speed electric).',
    `vehicle_segment` STRING COMMENT 'The market segment classification of the competitor vehicle used for competitive positioning analysis. [ENUM-REF-CANDIDATE: compact|midsize|fullsize|luxury|suv|crossover|truck|van|sports|electric — 10 candidates stripped; promote to reference product]',
    `win_loss_relevance` STRING COMMENT 'The relevance level of this competitor vehicle in win/loss analysis and opportunity tracking: high (frequently encountered), medium (occasionally encountered), or low (rarely encountered).. Valid values are `high|medium|low`',
    CONSTRAINT pk_competitor_vehicle PRIMARY KEY(`competitor_vehicle_id`)
) COMMENT 'Reference catalog of competitor vehicles tracked for competitive intelligence in the sales process. Captures competitor brand, model name, model year, segment classification, powertrain type, base price, key feature highlights, and win/loss relevance. Used in opportunity management to record competitive situations and support sales rep coaching. Maintained by the sales strategy team.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`win_loss` (
    `win_loss_id` BIGINT COMMENT 'Unique identifier for the win/loss analysis record. Primary key.',
    `campaign_id` BIGINT COMMENT 'Reference to the marketing campaign that generated the lead, if applicable.',
    `dealer_incentive_program_id` BIGINT COMMENT 'Reference to the incentive program that was offered during the opportunity, if applicable.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership where the opportunity was managed.',
    `employee_id` BIGINT COMMENT 'Reference to the user who reviewed and approved the win/loss analysis.',
    `opportunity_id` BIGINT COMMENT 'Reference to the closed sales opportunity that this win/loss analysis documents.',
    `sales_territory_id` BIGINT COMMENT 'Reference to the sales territory where the opportunity was managed.',
    `party_id` BIGINT COMMENT 'Reference to the customer associated with the opportunity.',
    `win_party_id` BIGINT COMMENT 'Reference to the customer associated with the opportunity.',
    `rep_id` BIGINT COMMENT 'Reference to the sales representative who managed the opportunity and provided the win/loss analysis.',
    `win_sales_representative_rep_id` BIGINT COMMENT 'Reference to the sales representative who managed the opportunity and provided the win/loss analysis.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the vehicle configuration that was the subject of the opportunity.',
    `win_vin_registry_id` BIGINT COMMENT 'Reference to the vehicle configuration that was the subject of the opportunity.',
    `analysis_number` STRING COMMENT 'Business-facing unique identifier for the win/loss analysis record, used for tracking and reporting.',
    `analysis_status` STRING COMMENT 'Current status of the win/loss analysis record in the review workflow.. Valid values are `draft|submitted|reviewed|approved`',
    `competitor_brand` STRING COMMENT 'Name of the competitor brand that won the deal if the opportunity was lost. Null if won or no competitor identified.',
    `competitor_model` STRING COMMENT 'Specific vehicle model from the competitor that the customer selected instead of our offering.',
    `competitor_model_year` STRING COMMENT 'Model year of the competitor vehicle selected by the customer.',
    `competitor_price` DECIMAL(18,2) COMMENT 'Reported selling price of the competitor vehicle, if known. Used for competitive pricing analysis.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the win/loss analysis record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this record.. Valid values are `^[A-Z]{3}$`',
    `customer_decision_factor_availability` BOOLEAN COMMENT 'Indicates whether vehicle availability and delivery timing were a significant factor in the customers decision.',
    `customer_decision_factor_brand` BOOLEAN COMMENT 'Indicates whether brand reputation and loyalty were a significant factor in the customers decision.',
    `customer_decision_factor_features` BOOLEAN COMMENT 'Indicates whether vehicle features and specifications were a significant factor in the customers decision.',
    `customer_decision_factor_financing` BOOLEAN COMMENT 'Indicates whether financing terms and options were a significant factor in the customers decision.',
    `customer_decision_factor_price` BOOLEAN COMMENT 'Indicates whether price was a significant factor in the customers decision.',
    `customer_decision_factor_service` BOOLEAN COMMENT 'Indicates whether after-sales service and dealer support were a significant factor in the customers decision.',
    `deal_value` DECIMAL(18,2) COMMENT 'Total monetary value of the opportunity at the time of closure. For won deals, this is the actual sale amount; for lost deals, this is the estimated value.',
    `fiscal_quarter` STRING COMMENT 'Fiscal quarter in which the opportunity outcome was recorded.. Valid values are `Q1|Q2|Q3|Q4`',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the opportunity outcome was recorded, used for financial reporting and performance tracking.',
    `lead_source` STRING COMMENT 'Original source of the lead that generated this opportunity, used to evaluate marketing channel effectiveness.',
    `model_year` STRING COMMENT 'Model year of the vehicle that was the subject of the opportunity.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the win/loss analysis record was last modified.',
    `notes` STRING COMMENT 'Additional free-form notes and observations about the win/loss outcome, providing supplementary context for strategic analysis.',
    `opportunity_type` STRING COMMENT 'Type of sales opportunity: new vehicle purchase, used vehicle purchase, lease, or fleet contract.. Valid values are `new_vehicle|used_vehicle|lease|fleet`',
    `outcome` STRING COMMENT 'Final outcome of the sales opportunity: won (deal closed successfully), lost (customer chose competitor or declined), no_decision (customer postponed decision indefinitely), cancelled (opportunity withdrawn).. Valid values are `won|lost|no_decision|cancelled`',
    `outcome_date` DATE COMMENT 'Date when the final outcome was determined and the opportunity was closed.',
    `outcome_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the opportunity outcome was recorded in the system.',
    `primary_reason_code` STRING COMMENT 'Standardized code representing the primary reason for the win or loss outcome. Used for structured analysis and reporting.',
    `primary_reason_description` STRING COMMENT 'Detailed explanation of the primary reason for the outcome, providing context beyond the standardized code.',
    `region_code` STRING COMMENT 'Geographic region code where the opportunity was managed, used for regional performance analysis.',
    `reviewed_by_user_code` BIGINT COMMENT 'Reference to the user who reviewed and approved the win/loss analysis.',
    `reviewed_date` DATE COMMENT 'Date when the win/loss analysis was reviewed and approved.',
    `sales_channel` STRING COMMENT 'Channel through which the opportunity was pursued: retail (individual consumer), fleet (corporate fleet), commercial (business customer), direct (OEM direct sales), online (digital channel).. Valid values are `retail|fleet|commercial|direct|online`',
    `sales_rep_assessment` STRING COMMENT 'Qualitative assessment and commentary from the sales representative regarding the outcome, including insights on customer behavior, competitive dynamics, and lessons learned.',
    `secondary_reason_code` STRING COMMENT 'Standardized code for a contributing secondary reason for the outcome, if applicable.',
    `secondary_reason_description` STRING COMMENT 'Detailed explanation of the secondary contributing reason for the outcome.',
    CONSTRAINT pk_win_loss PRIMARY KEY(`win_loss_id`)
) COMMENT 'Record capturing the outcome analysis of a closed sales opportunity, documenting whether the deal was won or lost, primary reason for outcome, competitor vehicle selected (if lost), customer decision factors, deal value, and sales rep assessment. Provides structured win/loss intelligence to improve sales strategy, product positioning, and incentive program design.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`contract` (
    `contract_id` BIGINT COMMENT 'Unique identifier for the executed sales contract. Primary key for the sales contract entity.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Contracts must attach the specific compliance certification documents required for the vehicle sale.',
    `party_id` BIGINT COMMENT 'Reference to the customer who is the purchasing party in this sales contract. Links to the customer master data.',
    `contract_party_id` BIGINT COMMENT 'Reference to the customer who is the purchasing party in this sales contract. Links to the customer master data.',
    `rep_id` BIGINT COMMENT 'Reference to the sales representative who facilitated the contract execution. Links to employee or dealer personnel master data.',
    `contract_sales_representative_rep_id` BIGINT COMMENT 'Reference to the sales representative who facilitated the contract execution. Links to employee or dealer personnel master data.',
    `vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle being sold under this contract. Links to vehicle master data.',
    `contract_vin_registry_id` BIGINT COMMENT 'Reference to the specific vehicle being sold under this contract. Links to vehicle master data.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership that facilitated or executed the sales contract. Null for direct OEM (Original Equipment Manufacturer) sales.',
    `employee_id` BIGINT COMMENT 'Reference to the user or manager who provided final approval for the contract. Null for contracts not requiring approval.',
    `fleet_contract_id` BIGINT COMMENT 'Reference to the master fleet contract framework if this sales contract is executed under a pre-negotiated fleet agreement. Null for non-fleet transactions.',
    `vehicle_order_id` BIGINT COMMENT 'Reference to the vehicle order that preceded this contract. Links the contract to the original order placement.',
    `agreed_price` DECIMAL(18,2) COMMENT 'The final negotiated selling price for the vehicle as agreed in the contract, before taxes and fees.',
    `approval_date` DATE COMMENT 'Date when the contract received final internal approval from authorized personnel. Null for contracts not requiring approval.',
    `approved_by_user_code` BIGINT COMMENT 'Reference to the user or manager who provided final approval for the contract. Null for contracts not requiring approval.',
    `cancellation_date` DATE COMMENT 'Date when the contract was cancelled or voided. Null for active, completed, or terminated contracts.',
    `cancellation_reason` STRING COMMENT 'Explanation for why the contract was cancelled. Includes customer request, financing denial, vehicle unavailability, or other business reasons. Null for non-cancelled contracts.',
    `contract_date` DATE COMMENT 'The date when the sales contract was executed and became legally binding. This is the principal business event timestamp for the contract.',
    `contract_number` STRING COMMENT 'Externally-known unique business identifier for the sales contract. Used for customer communication, legal reference, and cross-system tracking.',
    `contract_status` STRING COMMENT 'Current lifecycle state of the sales contract. Draft indicates initial creation, pending approval awaits authorization, executed means signed by all parties, active indicates in-force, completed means fulfilled, cancelled means voided before execution, terminated means ended after execution. [ENUM-REF-CANDIDATE: draft|pending_approval|executed|active|completed|cancelled|terminated — 7 candidates stripped; promote to reference product]',
    `contract_type` STRING COMMENT 'Classification of the sales contract indicating the nature of the transaction. Retail purchase is standard consumer sale, lease is rental agreement, fleet purchase is bulk commercial order, government contract is public sector procurement, commercial sale is business-to-business transaction, demo sale is demonstrator vehicle sale.. Valid values are `retail_purchase|lease|fleet_purchase|government_contract|commercial_sale|demo_sale`',
    `contracting_party_name` STRING COMMENT 'Legal name of the selling party (OEM or dealership) as it appears on the contract. Used for legal documentation and compliance.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the contract record was first created in the system. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this contract.. Valid values are `^[A-Z]{3}$`',
    `customer_legal_name` STRING COMMENT 'Full legal name of the customer as it appears on the executed contract. May differ from customer master name for legal entities.',
    `delivery_date` DATE COMMENT 'Scheduled or actual date when the vehicle is to be delivered to the customer as specified in the contract.',
    `delivery_location` STRING COMMENT 'Physical location where the vehicle will be delivered to the customer. May be dealership address, customer address, or alternate location.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total discount applied to the MSRP (Manufacturer Suggested Retail Price) to arrive at the agreed price. Includes dealer discounts and negotiated reductions.',
    `document_reference` STRING COMMENT 'Reference identifier or URI to the physical or digital contract document stored in the document management system.',
    `down_payment_amount` DECIMAL(18,2) COMMENT 'Initial payment made by the customer at contract execution. Null for full financing or lease agreements with no down payment.',
    `effective_end_date` DATE COMMENT 'The date when the contract terms expire or the agreement concludes. Nullable for indefinite or single-transaction contracts.',
    `effective_start_date` DATE COMMENT 'The date when the contract terms become effective and obligations begin. May differ from contract date for future-dated agreements.',
    `fees_amount` DECIMAL(18,2) COMMENT 'Total additional fees included in the contract such as documentation fees, registration fees, delivery charges, and dealer administrative fees.',
    `financing_term_months` STRING COMMENT 'Duration of the financing or lease agreement in months. Null for cash purchases.',
    `financing_type` STRING COMMENT 'Method of payment or financing arrangement specified in the contract. Cash is full payment, loan is third-party financing, lease is rental agreement, captive finance is OEM financial services, third party finance is external lender, fleet finance is commercial fleet financing.. Valid values are `cash|loan|lease|captive_finance|third_party_finance|fleet_finance`',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the contract was executed. Used for financial reporting and sales performance tracking.',
    `incentive_amount` DECIMAL(18,2) COMMENT 'Total manufacturer or dealer incentives applied to this contract. Includes rebates, loyalty bonuses, conquest incentives, and promotional offers.',
    `interest_rate` DECIMAL(18,2) COMMENT 'Annual percentage rate (APR) for financed purchases. Expressed as a decimal (e.g., 0.0499 for 4.99%). Null for cash purchases and leases.',
    `model_year` STRING COMMENT 'Model year of the vehicle being sold. Represents the manufacturers designated year for the vehicle model, which may differ from calendar year.',
    `modified_timestamp` TIMESTAMP COMMENT 'System timestamp when the contract record was last modified. Used for audit trail and change tracking.',
    `monthly_payment_amount` DECIMAL(18,2) COMMENT 'Recurring monthly payment amount for financed or leased vehicles. Null for cash purchases.',
    `msrp` DECIMAL(18,2) COMMENT 'The manufacturers suggested retail price for the vehicle at the time of contract execution. Used for discount calculation and reporting.',
    `region_code` STRING COMMENT 'Geographic region code where the contract was executed. Used for regional sales reporting and compliance tracking.',
    `sales_channel` STRING COMMENT 'Distribution channel through which the sale was executed. Dealer retail is traditional dealership, direct OEM is manufacturer direct-to-consumer, fleet sales is commercial bulk, online is digital sales platform, auction is wholesale auction, broker is third-party intermediary.. Valid values are `dealer_retail|direct_oem|fleet_sales|online|auction|broker`',
    `signed_date` DATE COMMENT 'Date when all parties signed the contract and it became legally binding. May differ from contract date for backdated or future-dated agreements.',
    `special_terms` STRING COMMENT 'Free-text field capturing any special conditions, clauses, or negotiated terms specific to this contract that are not captured in standard fields.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total sales tax, value-added tax, or other government-mandated taxes applied to the transaction as specified in the contract.',
    `total_contract_value` DECIMAL(18,2) COMMENT 'The total amount payable by the customer including agreed price, taxes, fees, less trade-in value. This is the final contract obligation amount.',
    `trade_in_value` DECIMAL(18,2) COMMENT 'Agreed value of the customers trade-in vehicle applied as credit toward the purchase. Null if no trade-in is involved.',
    `vin` STRING COMMENT 'The 17-character unique identifier assigned to the vehicle being sold. Globally unique identifier per ISO 3779 standard.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `warranty_mileage_limit` STRING COMMENT 'Maximum mileage covered under warranty terms. Expressed in miles or kilometers depending on region. Null if no mileage limit applies.',
    `warranty_term_months` STRING COMMENT 'Duration of warranty coverage in months from delivery date. Null if no warranty is provided.',
    `warranty_type` STRING COMMENT 'Type of warranty coverage included in the contract. Standard is manufacturer base warranty, extended is purchased additional coverage, certified pre-owned is CPO (Certified Pre-Owned) program warranty, none for as-is sales.. Valid values are `standard|extended|certified_pre_owned|none`',
    CONSTRAINT pk_contract PRIMARY KEY(`contract_id`)
) COMMENT 'Executed legal sales contract between the OEM or dealer and the customer formalizing the vehicle purchase or lease agreement. Captures contract type (retail purchase, lease, fleet purchase agreement, government contract), contract date, contracting parties, vehicle reference, agreed terms (price, financing, warranty, delivery), contract status (draft, executed, cancelled, completed), and document reference. Distinct from fleet_contract which is a pre-execution commercial framework; this is the executed legal instrument per transaction.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` (
    `regional_sales_plan_id` BIGINT COMMENT 'Unique identifier for the regional sales plan record.',
    `employee_id` BIGINT COMMENT 'Identifier for the sales leader or manager responsible for this regional sales plan.',
    `regional_employee_id` BIGINT COMMENT 'Identifier for the sales leader or manager responsible for this regional sales plan.',
    `sales_territory_id` BIGINT COMMENT 'Foreign key linking to sales.sales_territory. Business justification: Regional sales plans are created for a specific sales territory; linking them via sales_territory_id provides the necessary hierarchy and removes the need to store territory code redundantly.',
    `tertiary_regional_created_by_user_employee_id` BIGINT COMMENT 'Identifier for the user who created this regional sales plan record.',
    `approval_date` DATE COMMENT 'Date when the regional sales plan was formally approved.',
    `approval_status` STRING COMMENT 'Current approval status of the regional sales plan in the governance workflow.. Valid values are `pending|approved|rejected|revision_required`',
    `approved_by_user_code` BIGINT COMMENT 'Identifier for the executive or authority who approved this regional sales plan.',
    `average_msrp` DECIMAL(18,2) COMMENT 'Average MSRP assumed for revenue planning calculations.',
    `body_style` STRING COMMENT 'Vehicle body style classification for detailed product mix planning.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code for the primary country within the region.',
    `created_by_user_code` BIGINT COMMENT 'Identifier for the user who created this regional sales plan record.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this regional sales plan record was first created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary values in this plan.',
    `dealer_network_code` BIGINT COMMENT 'Identifier for the dealer network or distribution channel associated with this regional plan.',
    `ev_penetration_target_percentage` DECIMAL(18,2) COMMENT 'Target percentage of electric vehicle sales within the total volume mix, supporting electrification strategy.',
    `ev_volume_units` STRING COMMENT 'Planned sales volume for battery electric vehicles.',
    `fiscal_quarter` STRING COMMENT 'Fiscal quarter within the fiscal year for quarterly planning granularity.. Valid values are `Q1|Q2|Q3|Q4`',
    `fiscal_year` STRING COMMENT 'Fiscal year for which this regional sales plan is defined, following the companys fiscal calendar.',
    `fleet_mix_percentage` DECIMAL(18,2) COMMENT 'Target percentage of total volume allocated to fleet and commercial sales channels.',
    `hev_volume_units` STRING COMMENT 'Planned sales volume for hybrid electric vehicles.',
    `ice_volume_units` STRING COMMENT 'Planned sales volume for internal combustion engine vehicles.',
    `incentive_budget_amount` DECIMAL(18,2) COMMENT 'Total incentive budget allocated to this regional sales plan for customer and dealer incentives.',
    `last_modified_by_user_code` BIGINT COMMENT 'Identifier for the user who last modified this regional sales plan record.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this regional sales plan record was last updated.',
    `market_zone` STRING COMMENT 'Sub-regional market zone or territory grouping within the broader sales region.',
    `minimum_volume_units` STRING COMMENT 'Minimum acceptable sales volume threshold for the planning period.',
    `model_year` STRING COMMENT 'Model year designation for vehicles covered by this sales plan, critical for product lifecycle planning.',
    `nameplate` STRING COMMENT 'Vehicle nameplate or model line covered by this regional sales plan.',
    `phev_volume_units` STRING COMMENT 'Planned sales volume for plug-in hybrid electric vehicles.',
    `plan_name` STRING COMMENT 'Descriptive name of the regional sales plan for identification and reporting purposes.',
    `plan_notes` STRING COMMENT 'Free-text notes capturing assumptions, constraints, and strategic context for the regional sales plan.',
    `plan_number` STRING COMMENT 'Business identifier for the regional sales plan, used for external reference and reporting.',
    `plan_status` STRING COMMENT 'Current lifecycle status of the regional sales plan in the approval and execution workflow.. Valid values are `draft|submitted|approved|active|closed|cancelled`',
    `plan_type` STRING COMMENT 'Classification of the sales plan by planning horizon and purpose.. Valid values are `annual|quarterly|monthly|strategic|tactical`',
    `planning_period_end_date` DATE COMMENT 'End date of the planning period covered by this regional sales plan.',
    `planning_period_start_date` DATE COMMENT 'Start date of the planning period covered by this regional sales plan.',
    `powertrain_type` STRING COMMENT 'Powertrain technology type for this plan segment. [ENUM-REF-CANDIDATE: ICE|EV|HEV|PHEV|FCEV|diesel|gasoline|hybrid — promote to reference product]',
    `region_code` STRING COMMENT 'Code identifying the sales region or market zone for which this plan is defined.',
    `region_name` STRING COMMENT 'Descriptive name of the sales region or market zone covered by this plan.',
    `retail_mix_percentage` DECIMAL(18,2) COMMENT 'Target percentage of total volume allocated to retail sales channels.',
    `revision_number` STRING COMMENT 'Version number tracking revisions and amendments to the regional sales plan.',
    `revision_reason` STRING COMMENT 'Business justification for revisions or amendments to the original plan.',
    `sales_channel` STRING COMMENT 'Primary sales channel for which this plan is defined.. Valid values are `retail|fleet|commercial|government|direct|dealer`',
    `stretch_volume_units` STRING COMMENT 'Stretch or aspirational sales volume target representing best-case scenario.',
    `target_revenue_amount` DECIMAL(18,2) COMMENT 'Planned revenue target for the region and planning period in the specified currency.',
    `target_volume_units` STRING COMMENT 'Planned sales volume in units for the region and planning period.',
    `vehicle_segment` STRING COMMENT 'Vehicle segment classification for planning and mix analysis. [ENUM-REF-CANDIDATE: sedan|suv|truck|van|coupe|hatchback|crossover|commercial — 8 candidates stripped; promote to reference product]',
    CONSTRAINT pk_regional_sales_plan PRIMARY KEY(`regional_sales_plan_id`)
) COMMENT 'Annual or quarterly sales volume and mix plan for a specific sales region or market zone, defining target unit volumes by nameplate, powertrain type (ICE/EV/HEV/PHEV), and channel. Captures planning period, region reference, planned volumes by model, EV penetration targets, revenue targets, and plan approval status. Supports top-down quota cascading and regional performance management. Distinct from individual quota records which are assigned to reps or dealers.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`dealer_rep_assignment` (
    `dealer_rep_assignment_id` BIGINT COMMENT 'Primary key for the DealerRepAssignment association',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to the dealership master record',
    `rep_id` BIGINT COMMENT 'Foreign key linking to the sales_rep master record',
    `end_date` DATE COMMENT 'Date the sales_rep assignment to the dealership ends (null if active)',
    `role` STRING COMMENT 'Specific sales role for this assignment (e.g., Retail Field Rep, Fleet Account Manager)',
    `start_date` DATE COMMENT 'Date the sales_rep assignment to the dealership begins',
    CONSTRAINT pk_dealer_rep_assignment PRIMARY KEY(`dealer_rep_assignment_id`)
) COMMENT 'Represents the assignment of a sales representative to a dealership, capturing the period of assignment and the specific role the rep plays for that dealership.. Existence Justification: OEM sales representatives are assigned to multiple dealerships, and each dealership can have multiple sales representatives. The assignment is actively managed by the business with start/end dates and a role for each rep‑dealership pairing, and the relationship is tracked as a standalone entity.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`sales_lead` (
    `sales_lead_id` BIGINT COMMENT 'Unique identifier for the sales lead record. Primary key.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Lead Assignment Process needs to record the employee responsible for each lead.',
    `campaign_id` BIGINT COMMENT 'Identifier of the marketing campaign that generated this lead, if applicable.',
    `opportunity_id` BIGINT COMMENT 'Identifier of the opportunity record created upon lead conversion. Null if not yet converted.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Associates leads with existing parties for referral tracking and lead conversion analysis in the Lead Management process.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealership assigned to this lead for follow-up and conversion.',
    `rep_id` BIGINT COMMENT 'Identifier of the sales representative or dealer contact assigned to follow up on this lead.',
    `sales_dealership_id` BIGINT COMMENT 'Identifier of the dealership assigned to this lead for follow-up and conversion.',
    `sales_rep_id` BIGINT COMMENT 'Identifier of the sales representative or dealer contact assigned to follow up on this lead.',
    `city` STRING COMMENT 'City where the lead is located.',
    `company_name` STRING COMMENT 'Name of the organization or company associated with the lead, applicable for fleet sales or commercial vehicle inquiries.',
    `converted_date` DATE COMMENT 'The date when the lead was converted into an opportunity. Null if not yet converted. Format: yyyy-MM-dd.',
    `country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code representing the leads country of residence or business location.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when the lead record was first created in the system. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the estimated budget amount.. Valid values are `^[A-Z]{3}$`',
    `email_address` STRING COMMENT 'Primary email address of the lead for digital communication and follow-up.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `estimated_budget_amount` DECIMAL(18,2) COMMENT 'Estimated budget or price range the lead has indicated for the vehicle purchase.',
    `financing_interest` BOOLEAN COMMENT 'Boolean flag indicating whether the lead is interested in financing or leasing options.',
    `first_name` STRING COMMENT 'The first name (given name) of the individual lead contact.',
    `last_contact_date` DATE COMMENT 'The date when the lead was last contacted by a sales representative. Format: yyyy-MM-dd.',
    `last_name` STRING COMMENT 'The last name (family name) of the individual lead contact.',
    `lead_number` STRING COMMENT 'Human-readable business identifier for the lead, typically auto-generated by the CRM system. Format: LEAD-NNNNNNNN.. Valid values are `^LEAD-[0-9]{8}$`',
    `lead_source` STRING COMMENT 'The origin channel through which the lead was captured (web inquiry, dealer walk-in, automotive event, customer referral, digital marketing campaign, phone inquiry).. Valid values are `web|dealer_walk_in|event|referral|digital_campaign|phone_inquiry`',
    `lead_status` STRING COMMENT 'Current lifecycle status of the lead in the sales pipeline (new, contacted, qualified, unqualified, converted to opportunity, lost).. Valid values are `new|contacted|qualified|unqualified|converted|lost`',
    `lead_type` STRING COMMENT 'Classification of the lead based on buyer category: individual consumer, fleet buyer, commercial enterprise, or government entity.. Valid values are `individual|fleet|commercial|government`',
    `lost_reason` STRING COMMENT 'Reason why the lead was marked as lost (e.g., purchased from competitor, no longer interested, unresponsive).',
    `mobile_number` STRING COMMENT 'Mobile phone number of the lead for SMS campaigns and mobile outreach.',
    `model_year_interest` STRING COMMENT 'The model year (MY) of the vehicle the lead is interested in purchasing.. Valid values are `^(20[2-9][0-9]|MY[2-9][0-9])$`',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time when the lead record was last modified. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `next_follow_up_date` DATE COMMENT 'Scheduled date for the next follow-up activity with the lead. Format: yyyy-MM-dd.',
    `notes` STRING COMMENT 'Free-text notes and comments captured by sales representatives regarding the leads preferences, objections, and conversation history.',
    `opt_in_email` BOOLEAN COMMENT 'Boolean flag indicating whether the lead has opted in to receive email marketing communications.',
    `opt_in_phone` BOOLEAN COMMENT 'Boolean flag indicating whether the lead has opted in to receive phone call communications.',
    `opt_in_sms` BOOLEAN COMMENT 'Boolean flag indicating whether the lead has opted in to receive SMS marketing communications.',
    `phone_number` STRING COMMENT 'Primary contact phone number for the lead. Used for outbound sales calls and follow-up.',
    `postal_code` STRING COMMENT 'Postal or ZIP code of the leads address, used for geographic segmentation and dealer assignment.',
    `purchase_timeframe` STRING COMMENT 'Expected timeframe within which the lead intends to make a purchase decision (immediate, within 30 days, within 90 days, within 6 months, or future/undecided).. Valid values are `immediate|within_30_days|within_90_days|within_6_months|future`',
    `qualification_score` STRING COMMENT 'Numeric score (0-100) representing the leads likelihood to convert, based on engagement, budget, authority, need, and timeline (BANT criteria).',
    `rating` STRING COMMENT 'Qualitative rating of the lead based on engagement and conversion potential: hot (high priority), warm (moderate interest), cold (low engagement).. Valid values are `hot|warm|cold`',
    `referral_source` STRING COMMENT 'Name or identifier of the person or entity that referred this lead, if applicable.',
    `region` STRING COMMENT 'Geographic region or sales territory where the lead is located (e.g., North America, Europe, Asia-Pacific).',
    `state_province` STRING COMMENT 'State or province where the lead is located.',
    `street_address` STRING COMMENT 'Street address of the lead, used for delivery and service planning.',
    `test_drive_requested` BOOLEAN COMMENT 'Boolean flag indicating whether the lead has requested a test drive.',
    `trade_in_interest` BOOLEAN COMMENT 'Boolean flag indicating whether the lead has expressed interest in trading in an existing vehicle as part of the purchase.',
    `unqualified_reason` STRING COMMENT 'Reason why the lead was marked as unqualified (e.g., no budget, no authority, no need, incorrect contact information).',
    `vehicle_interest_category` STRING COMMENT 'The powertrain category of vehicle the lead is interested in: ICE (Internal Combustion Engine), EV (Electric Vehicle), HEV (Hybrid Electric Vehicle), or PHEV (Plug-in Hybrid Electric Vehicle).. Valid values are `ICE|EV|HEV|PHEV`',
    `vehicle_model_interest` STRING COMMENT 'Specific vehicle model or model family the lead has expressed interest in (e.g., sedan, SUV, truck model name).',
    `web_form_code` STRING COMMENT 'Identifier of the web form or landing page through which the lead was captured, used for digital campaign attribution.',
    CONSTRAINT pk_sales_lead PRIMARY KEY(`sales_lead_id`)
) COMMENT 'Inbound or outbound sales lead representing an individual or organization expressing interest in purchasing a vehicle. Tracks lead source (web, dealer walk-in, event, referral, digital campaign), lead status, assigned owner, vehicle interest category (ICE, EV, HEV, PHEV), and qualification score. Feeds into opportunity pipeline upon qualification. Sourced from Salesforce Automotive Cloud Lead object.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`finance_contract` (
    `finance_contract_id` BIGINT COMMENT 'Surrogate primary key for finance_contract.',
    `credit_application_id` BIGINT COMMENT 'FK to the credit application backing this contract.',
    `party_id` BIGINT COMMENT 'FK to the customer party.',
    `dealership_id` BIGINT COMMENT 'FK to the dealership.',
    `vehicle_order_id` BIGINT COMMENT 'FK to the originating vehicle order in the sales flow.',
    `apr_rate` DECIMAL(18,2) COMMENT 'Annual percentage rate.',
    `created_timestamp` TIMESTAMP COMMENT 'Record creation timestamp.',
    `currency_code` STRING COMMENT 'ISO currency code.',
    `monthly_payment` DECIMAL(18,2) COMMENT 'Monthly payment amount.',
    `principal_amount` DECIMAL(18,2) COMMENT 'Financed principal amount.',
    `finance_contract_status` STRING COMMENT 'Lifecycle status.',
    `term_months` STRING COMMENT 'Financing term in months.',
    CONSTRAINT pk_finance_contract PRIMARY KEY(`finance_contract_id`)
) COMMENT 'Sales fni product connecting to the sales flow.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`lease_contract` (
    `lease_contract_id` BIGINT COMMENT 'Surrogate primary key for lease_contract.',
    `party_id` BIGINT COMMENT 'FK to the customer party.',
    `dealership_id` BIGINT COMMENT 'FK to the dealership.',
    `residual_value_schedule_id` BIGINT COMMENT 'FK to the residual value schedule.',
    `vehicle_order_id` BIGINT COMMENT 'FK to the originating vehicle order in the sales flow.',
    `annual_mileage_allowance` STRING COMMENT 'Contracted annual mileage allowance.',
    `created_timestamp` TIMESTAMP COMMENT 'Record creation timestamp.',
    `currency_code` STRING COMMENT 'ISO currency code.',
    `monthly_payment` DECIMAL(18,2) COMMENT 'Monthly lease payment.',
    `lease_contract_status` STRING COMMENT 'Lifecycle status.',
    `term_months` STRING COMMENT 'Lease term in months.',
    CONSTRAINT pk_lease_contract PRIMARY KEY(`lease_contract_id`)
) COMMENT 'Sales fni product connecting to the sales flow.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`insurance_policy` (
    `insurance_policy_id` BIGINT COMMENT 'Surrogate primary key for insurance_policy.',
    `party_id` BIGINT COMMENT 'FK to the customer party.',
    `dealership_id` BIGINT COMMENT 'FK to the dealership.',
    `vehicle_order_id` BIGINT COMMENT 'FK to the originating vehicle order in the sales flow.',
    `coverage_type` STRING COMMENT 'Type of insurance coverage.',
    `created_timestamp` TIMESTAMP COMMENT 'Record creation timestamp.',
    `currency_code` STRING COMMENT 'ISO currency code.',
    `effective_end_date` DATE COMMENT 'Policy end date.',
    `effective_start_date` DATE COMMENT 'Policy start date.',
    `policy_number` STRING COMMENT 'Insurance policy number.',
    `premium_amount` DECIMAL(18,2) COMMENT 'Policy premium amount.',
    `insurance_policy_status` STRING COMMENT 'Lifecycle status.',
    CONSTRAINT pk_insurance_policy PRIMARY KEY(`insurance_policy_id`)
) COMMENT 'Sales fni product connecting to the sales flow.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`fni_menu_product` (
    `fni_menu_product_id` BIGINT COMMENT 'Surrogate primary key for fni_menu_product.',
    `party_id` BIGINT COMMENT 'FK to the customer party.',
    `dealership_id` BIGINT COMMENT 'FK to the dealership.',
    `vehicle_order_id` BIGINT COMMENT 'FK to the originating vehicle order in the sales flow.',
    `created_timestamp` TIMESTAMP COMMENT 'Record creation timestamp.',
    `currency_code` STRING COMMENT 'ISO currency code.',
    `product_category` STRING COMMENT 'F&I product category.',
    `product_name` STRING COMMENT 'F&I menu product name.',
    `retail_price` DECIMAL(18,2) COMMENT 'Retail price of the product.',
    `fni_menu_product_status` STRING COMMENT 'Lifecycle status.',
    CONSTRAINT pk_fni_menu_product PRIMARY KEY(`fni_menu_product_id`)
) COMMENT 'Sales fni product connecting to the sales flow.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`credit_application` (
    `credit_application_id` BIGINT COMMENT 'Surrogate primary key for credit_application.',
    `party_id` BIGINT COMMENT 'FK to the customer party.',
    `dealership_id` BIGINT COMMENT 'FK to the dealership.',
    `vehicle_order_id` BIGINT COMMENT 'FK to the originating vehicle order in the sales flow.',
    `applicant_score` STRING COMMENT 'Credit score of the applicant.',
    `created_timestamp` TIMESTAMP COMMENT 'Record creation timestamp.',
    `currency_code` STRING COMMENT 'ISO currency code.',
    `decision_status` STRING COMMENT 'Credit decision status.',
    `requested_amount` DECIMAL(18,2) COMMENT 'Requested financing amount.',
    `credit_application_status` STRING COMMENT 'Lifecycle status.',
    `submitted_date` DATE COMMENT 'Application submission date.',
    CONSTRAINT pk_credit_application PRIMARY KEY(`credit_application_id`)
) COMMENT 'Sales fni product connecting to the sales flow.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`residual_value_schedule` (
    `residual_value_schedule_id` BIGINT COMMENT 'Surrogate primary key for residual_value_schedule.',
    `model_id` BIGINT COMMENT 'FK to the vehicle model.',
    `vehicle_order_id` BIGINT COMMENT 'FK to the originating vehicle order in the sales flow.',
    `created_timestamp` TIMESTAMP COMMENT 'Record creation timestamp.',
    `currency_code` STRING COMMENT 'ISO currency code.',
    `effective_date` DATE COMMENT 'Effective date of the schedule.',
    `residual_percentage` DECIMAL(18,2) COMMENT 'Residual value percentage.',
    `residual_value_schedule_status` STRING COMMENT 'Lifecycle status.',
    `term_months` STRING COMMENT 'Residual term in months.',
    CONSTRAINT pk_residual_value_schedule PRIMARY KEY(`residual_value_schedule_id`)
) COMMENT 'Sales fni product connecting to the sales flow.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`configurator_session` (
    `configurator_session_id` BIGINT COMMENT 'Surrogate primary key for configurator_session.',
    `configuration_id` BIGINT COMMENT 'FK to the built vehicle configuration.',
    `party_id` BIGINT COMMENT 'FK to the customer party.',
    `dealership_id` BIGINT COMMENT 'FK to the dealership.',
    `digital_sales_lead_id` BIGINT COMMENT 'FK to the digital sales lead generated.',
    `vehicle_order_id` BIGINT COMMENT 'FK to the originating vehicle order in the sales flow.',
    `created_timestamp` TIMESTAMP COMMENT 'Record creation timestamp.',
    `currency_code` STRING COMMENT 'ISO currency code.',
    `is_completed` BOOLEAN COMMENT 'Whether configuration completed.',
    `session_end_timestamp` TIMESTAMP COMMENT 'Session end time.',
    `session_start_timestamp` TIMESTAMP COMMENT 'Session start time.',
    `configurator_session_status` STRING COMMENT 'Lifecycle status.',
    CONSTRAINT pk_configurator_session PRIMARY KEY(`configurator_session_id`)
) COMMENT 'Sales digital product connecting to the sales flow.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`online_order` (
    `online_order_id` BIGINT COMMENT 'Surrogate primary key for online_order.',
    `party_id` BIGINT COMMENT 'FK to the customer party.',
    `dealership_id` BIGINT COMMENT 'FK to the dealership.',
    `ecommerce_cart_id` BIGINT COMMENT 'FK to the source e-commerce cart.',
    `vehicle_order_id` BIGINT COMMENT 'FK to the originating vehicle order in the sales flow.',
    `created_timestamp` TIMESTAMP COMMENT 'Record creation timestamp.',
    `currency_code` STRING COMMENT 'ISO currency code.',
    `order_number` STRING COMMENT 'Online order number.',
    `reservation_deposit` DECIMAL(18,2) COMMENT 'Online reservation deposit.',
    `online_order_status` STRING COMMENT 'Lifecycle status.',
    `total_amount` DECIMAL(18,2) COMMENT 'Total order amount.',
    CONSTRAINT pk_online_order PRIMARY KEY(`online_order_id`)
) COMMENT 'Sales digital product connecting to the sales flow.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`ecommerce_cart` (
    `ecommerce_cart_id` BIGINT COMMENT 'Surrogate primary key for ecommerce_cart.',
    `configurator_session_id` BIGINT COMMENT 'FK to the configurator session.',
    `party_id` BIGINT COMMENT 'FK to the customer party.',
    `dealership_id` BIGINT COMMENT 'FK to the dealership.',
    `vehicle_order_id` BIGINT COMMENT 'FK to the originating vehicle order in the sales flow.',
    `cart_status` STRING COMMENT 'Cart status.',
    `created_timestamp` TIMESTAMP COMMENT 'Record creation timestamp.',
    `currency_code` STRING COMMENT 'ISO currency code.',
    `ecommerce_cart_status` STRING COMMENT 'Lifecycle status.',
    `subtotal_amount` DECIMAL(18,2) COMMENT 'Cart subtotal.',
    CONSTRAINT pk_ecommerce_cart PRIMARY KEY(`ecommerce_cart_id`)
) COMMENT 'Sales digital product connecting to the sales flow.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`digital_sales_lead` (
    `digital_sales_lead_id` BIGINT COMMENT 'Surrogate primary key for digital_sales_lead.',
    `channel_id` BIGINT COMMENT 'FK to the sales channel that produced the lead.',
    `party_id` BIGINT COMMENT 'FK to the customer party.',
    `dealership_id` BIGINT COMMENT 'FK to the dealership.',
    `opportunity_id` BIGINT COMMENT 'FK to the sales opportunity the lead converts into.',
    `vehicle_order_id` BIGINT COMMENT 'FK to the originating vehicle order in the sales flow.',
    `created_timestamp` TIMESTAMP COMMENT 'Record creation timestamp.',
    `currency_code` STRING COMMENT 'ISO currency code.',
    `lead_score` STRING COMMENT 'Lead quality score.',
    `lead_source` STRING COMMENT 'Digital lead source.',
    `digital_sales_lead_status` STRING COMMENT 'Lifecycle status.',
    CONSTRAINT pk_digital_sales_lead PRIMARY KEY(`digital_sales_lead_id`)
) COMMENT 'Sales digital product connecting to the sales flow.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`sales`.`vehicle_subscription` (
    `vehicle_subscription_id` BIGINT COMMENT 'Surrogate primary key for vehicle_subscription.',
    `party_id` BIGINT COMMENT 'FK to the customer party.',
    `dealership_id` BIGINT COMMENT 'FK to the dealership.',
    `vehicle_order_id` BIGINT COMMENT 'FK to the originating vehicle order in the sales flow.',
    `vin_registry_id` BIGINT COMMENT 'FK to the subscribed vehicle.',
    `created_timestamp` TIMESTAMP COMMENT 'Record creation timestamp.',
    `currency_code` STRING COMMENT 'ISO currency code.',
    `monthly_fee` DECIMAL(18,2) COMMENT 'Monthly subscription fee.',
    `vehicle_subscription_status` STRING COMMENT 'Lifecycle status.',
    `subscription_end_date` DATE COMMENT 'Subscription end date.',
    `subscription_start_date` DATE COMMENT 'Subscription start date.',
    CONSTRAINT pk_vehicle_subscription PRIMARY KEY(`vehicle_subscription_id`)
) COMMENT 'Sales digital product connecting to the sales flow.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_automotive_v1`.`sales`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_opportunity_sales_representative_rep_id` FOREIGN KEY (`opportunity_sales_representative_rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_online_order_id` FOREIGN KEY (`online_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`online_order`(`online_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_opportunity_id` FOREIGN KEY (`opportunity_id`) REFERENCES `vibe_automotive_v1`.`sales`.`opportunity`(`opportunity_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_msrp_schedule_id` FOREIGN KEY (`msrp_schedule_id`) REFERENCES `vibe_automotive_v1`.`sales`.`msrp_schedule`(`msrp_schedule_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_quote_id` FOREIGN KEY (`quote_id`) REFERENCES `vibe_automotive_v1`.`sales`.`quote`(`quote_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_vehicle_sales_representative_rep_id` FOREIGN KEY (`vehicle_sales_representative_rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_finance_contract_id` FOREIGN KEY (`finance_contract_id`) REFERENCES `vibe_automotive_v1`.`sales`.`finance_contract`(`finance_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_fleet_contract_id` FOREIGN KEY (`fleet_contract_id`) REFERENCES `vibe_automotive_v1`.`sales`.`fleet_contract`(`fleet_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_fni_menu_product_id` FOREIGN KEY (`fni_menu_product_id`) REFERENCES `vibe_automotive_v1`.`sales`.`fni_menu_product`(`fni_menu_product_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_order_sales_representative_rep_id` FOREIGN KEY (`order_sales_representative_rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_trade_in_id` FOREIGN KEY (`trade_in_id`) REFERENCES `vibe_automotive_v1`.`sales`.`trade_in`(`trade_in_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_incentive_claim` ADD CONSTRAINT `fk_sales_sales_incentive_claim_sales_incentive_program_id` FOREIGN KEY (`sales_incentive_program_id`) REFERENCES `vibe_automotive_v1`.`sales`.`sales_incentive_program`(`sales_incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ADD CONSTRAINT `fk_sales_fleet_contract_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ADD CONSTRAINT `fk_sales_fleet_contract_fleet_sales_representative_rep_id` FOREIGN KEY (`fleet_sales_representative_rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ADD CONSTRAINT `fk_sales_fleet_contract_line_fleet_contract_id` FOREIGN KEY (`fleet_contract_id`) REFERENCES `vibe_automotive_v1`.`sales`.`fleet_contract`(`fleet_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ADD CONSTRAINT `fk_sales_fleet_contract_line_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ADD CONSTRAINT `fk_sales_fleet_contract_line_fleet_sales_representative_rep_id` FOREIGN KEY (`fleet_sales_representative_rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ADD CONSTRAINT `fk_sales_sales_territory_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ADD CONSTRAINT `fk_sales_rep_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_automotive_v1`.`sales`.`channel`(`channel_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ADD CONSTRAINT `fk_sales_rep_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `vibe_automotive_v1`.`sales`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ADD CONSTRAINT `fk_sales_quota_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ADD CONSTRAINT `fk_sales_quota_quota_rep_id` FOREIGN KEY (`quota_rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ADD CONSTRAINT `fk_sales_quota_quota_sales_representative_rep_id` FOREIGN KEY (`quota_sales_representative_rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ADD CONSTRAINT `fk_sales_quota_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `vibe_automotive_v1`.`sales`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_activity_sales_representative_rep_id` FOREIGN KEY (`activity_sales_representative_rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_automotive_v1`.`sales`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_automotive_v1`.`sales`.`channel`(`channel_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_competitor_vehicle_id` FOREIGN KEY (`competitor_vehicle_id`) REFERENCES `vibe_automotive_v1`.`sales`.`competitor_vehicle`(`competitor_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_sales_lead_id` FOREIGN KEY (`sales_lead_id`) REFERENCES `vibe_automotive_v1`.`sales`.`sales_lead`(`sales_lead_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_opportunity_id` FOREIGN KEY (`opportunity_id`) REFERENCES `vibe_automotive_v1`.`sales`.`opportunity`(`opportunity_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `vibe_automotive_v1`.`sales`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_test_drive` ADD CONSTRAINT `fk_sales_sales_test_drive_opportunity_id` FOREIGN KEY (`opportunity_id`) REFERENCES `vibe_automotive_v1`.`sales`.`opportunity`(`opportunity_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ADD CONSTRAINT `fk_sales_trade_in_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_rescheduled_from_appointment_id` FOREIGN KEY (`rescheduled_from_appointment_id`) REFERENCES `vibe_automotive_v1`.`sales`.`delivery_appointment`(`delivery_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ADD CONSTRAINT `fk_sales_price_adjustment_quote_id` FOREIGN KEY (`quote_id`) REFERENCES `vibe_automotive_v1`.`sales`.`quote`(`quote_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ADD CONSTRAINT `fk_sales_price_adjustment_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ADD CONSTRAINT `fk_sales_order_status_event_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ADD CONSTRAINT `fk_sales_campaign_response_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_automotive_v1`.`sales`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ADD CONSTRAINT `fk_sales_campaign_response_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ADD CONSTRAINT `fk_sales_campaign_response_campaign_sales_representative_rep_id` FOREIGN KEY (`campaign_sales_representative_rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ADD CONSTRAINT `fk_sales_campaign_response_opportunity_id` FOREIGN KEY (`opportunity_id`) REFERENCES `vibe_automotive_v1`.`sales`.`opportunity`(`opportunity_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ADD CONSTRAINT `fk_sales_campaign_response_sales_lead_id` FOREIGN KEY (`sales_lead_id`) REFERENCES `vibe_automotive_v1`.`sales`.`sales_lead`(`sales_lead_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ADD CONSTRAINT `fk_sales_win_loss_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_automotive_v1`.`sales`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ADD CONSTRAINT `fk_sales_win_loss_opportunity_id` FOREIGN KEY (`opportunity_id`) REFERENCES `vibe_automotive_v1`.`sales`.`opportunity`(`opportunity_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ADD CONSTRAINT `fk_sales_win_loss_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `vibe_automotive_v1`.`sales`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ADD CONSTRAINT `fk_sales_win_loss_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ADD CONSTRAINT `fk_sales_win_loss_win_sales_representative_rep_id` FOREIGN KEY (`win_sales_representative_rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ADD CONSTRAINT `fk_sales_contract_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ADD CONSTRAINT `fk_sales_contract_contract_sales_representative_rep_id` FOREIGN KEY (`contract_sales_representative_rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ADD CONSTRAINT `fk_sales_contract_fleet_contract_id` FOREIGN KEY (`fleet_contract_id`) REFERENCES `vibe_automotive_v1`.`sales`.`fleet_contract`(`fleet_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ADD CONSTRAINT `fk_sales_contract_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ADD CONSTRAINT `fk_sales_regional_sales_plan_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `vibe_automotive_v1`.`sales`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`dealer_rep_assignment` ADD CONSTRAINT `fk_sales_dealer_rep_assignment_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ADD CONSTRAINT `fk_sales_sales_lead_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_automotive_v1`.`sales`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ADD CONSTRAINT `fk_sales_sales_lead_opportunity_id` FOREIGN KEY (`opportunity_id`) REFERENCES `vibe_automotive_v1`.`sales`.`opportunity`(`opportunity_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ADD CONSTRAINT `fk_sales_sales_lead_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ADD CONSTRAINT `fk_sales_sales_lead_sales_rep_id` FOREIGN KEY (`sales_rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`finance_contract` ADD CONSTRAINT `fk_sales_finance_contract_credit_application_id` FOREIGN KEY (`credit_application_id`) REFERENCES `vibe_automotive_v1`.`sales`.`credit_application`(`credit_application_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`finance_contract` ADD CONSTRAINT `fk_sales_finance_contract_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`lease_contract` ADD CONSTRAINT `fk_sales_lease_contract_residual_value_schedule_id` FOREIGN KEY (`residual_value_schedule_id`) REFERENCES `vibe_automotive_v1`.`sales`.`residual_value_schedule`(`residual_value_schedule_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`lease_contract` ADD CONSTRAINT `fk_sales_lease_contract_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`insurance_policy` ADD CONSTRAINT `fk_sales_insurance_policy_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fni_menu_product` ADD CONSTRAINT `fk_sales_fni_menu_product_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`credit_application` ADD CONSTRAINT `fk_sales_credit_application_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`residual_value_schedule` ADD CONSTRAINT `fk_sales_residual_value_schedule_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`configurator_session` ADD CONSTRAINT `fk_sales_configurator_session_digital_sales_lead_id` FOREIGN KEY (`digital_sales_lead_id`) REFERENCES `vibe_automotive_v1`.`sales`.`digital_sales_lead`(`digital_sales_lead_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`configurator_session` ADD CONSTRAINT `fk_sales_configurator_session_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`online_order` ADD CONSTRAINT `fk_sales_online_order_ecommerce_cart_id` FOREIGN KEY (`ecommerce_cart_id`) REFERENCES `vibe_automotive_v1`.`sales`.`ecommerce_cart`(`ecommerce_cart_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`online_order` ADD CONSTRAINT `fk_sales_online_order_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`ecommerce_cart` ADD CONSTRAINT `fk_sales_ecommerce_cart_configurator_session_id` FOREIGN KEY (`configurator_session_id`) REFERENCES `vibe_automotive_v1`.`sales`.`configurator_session`(`configurator_session_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`ecommerce_cart` ADD CONSTRAINT `fk_sales_ecommerce_cart_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`digital_sales_lead` ADD CONSTRAINT `fk_sales_digital_sales_lead_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_automotive_v1`.`sales`.`channel`(`channel_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`digital_sales_lead` ADD CONSTRAINT `fk_sales_digital_sales_lead_opportunity_id` FOREIGN KEY (`opportunity_id`) REFERENCES `vibe_automotive_v1`.`sales`.`opportunity`(`opportunity_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`digital_sales_lead` ADD CONSTRAINT `fk_sales_digital_sales_lead_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_subscription` ADD CONSTRAINT `fk_sales_vehicle_subscription_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`sales` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_automotive_v1`.`sales` SET TAGS ('dbx_domain' = 'sales');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` SET TAGS ('dbx_subdomain' = 'revenue_pursuit');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `product_nameplate_id` SET TAGS ('dbx_business_glossary_term' = 'Nameplate Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `opportunity_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `opportunity_sales_representative_rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `opportunity_vehicle_model_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Owner Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle ID');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `territory` SET TAGS ('dbx_business_glossary_term' = 'Sales Territory');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `test_drive_completed` SET TAGS ('dbx_business_glossary_term' = 'Test Drive Completed');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `test_drive_date` SET TAGS ('dbx_business_glossary_term' = 'Test Drive Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `trade_in_value` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Value');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `vehicle_configuration` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration');
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ALTER COLUMN `win_reason` SET TAGS ('dbx_business_glossary_term' = 'Win Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` SET TAGS ('dbx_subdomain' = 'revenue_pursuit');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_id` SET TAGS ('dbx_business_glossary_term' = 'Quote Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Quote Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `product_nameplate_id` SET TAGS ('dbx_business_glossary_term' = 'Nameplate Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Opportunity Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `quote_vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `mobility_service_id` SET TAGS ('dbx_business_glossary_term' = 'Mobility Service Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `trade_in_vin` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `trade_in_vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `trade_in_vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ALTER COLUMN `trade_in_vin` SET TAGS ('dbx_pii_identifier' = 'true');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` SET TAGS ('dbx_subdomain' = 'revenue_pursuit');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `quote_line_id` SET TAGS ('dbx_business_glossary_term' = 'Quote Line Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `dealer_incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `msrp_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Msrp Schedule Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `quote_id` SET TAGS ('dbx_business_glossary_term' = 'Quote Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `quote_vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `vehicle_option_package_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Option Package Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ALTER COLUMN `model_code` SET TAGS ('dbx_business_glossary_term' = 'Model Code');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` SET TAGS ('dbx_subdomain' = 'revenue_pursuit');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` SET TAGS ('dbx_mvm_scope' = 'core');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `contact_point_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `contact_point_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `contact_point_id` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `homologation_record_id` SET TAGS ('dbx_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `product_nameplate_id` SET TAGS ('dbx_business_glossary_term' = 'Nameplate Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Order Sales Rep Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vehicle_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vehicle_sales_representative_rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vehicle_vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `build_week` SET TAGS ('dbx_business_glossary_term' = 'Build Week');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `build_week` SET TAGS ('dbx_value_regex' = '^(19|20)d{2}W(0[1-9]|[1-4][0-9]|5[0-3])$');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `production_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `production_plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,6}$');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vehicle_configuration_code` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vehicle_configuration_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10,30}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Model Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vehicle_model_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{5,15}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vin` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` SET TAGS ('dbx_subdomain' = 'revenue_pursuit');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `order_line_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `aftersales_trim_level_id` SET TAGS ('dbx_business_glossary_term' = 'Trim Level Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `order_sales_representative_rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `order_vehicle_vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `order_vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Sales Rep Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `trade_in_id` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vehicle_option_package_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Option Package Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `product_description` SET TAGS ('dbx_business_glossary_term' = 'Product Description');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Quantity');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `scheduled_production_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Production Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `ship_date` SET TAGS ('dbx_business_glossary_term' = 'Ship Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Instructions');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|SET|KIT|HR|UNIT');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_incentive_program` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_incentive_program` SET TAGS ('dbx_subdomain' = 'incentive_programs');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_incentive_program` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_incentive_program` ALTER COLUMN `sales_incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for sales_incentive_program');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_incentive_claim` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_incentive_claim` SET TAGS ('dbx_subdomain' = 'incentive_programs');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_incentive_claim` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_incentive_claim` ALTER COLUMN `sales_incentive_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for sales_incentive_claim');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_incentive_claim` ALTER COLUMN `sales_incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Incentive Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` SET TAGS ('dbx_subdomain' = 'commercial_fleet');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `customer_fleet_account_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Account Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `dealer_incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Incentive Program Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `fleet_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Sales Representative Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `fleet_sales_representative_rep_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Sales Representative Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Sales Rep Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` SET TAGS ('dbx_subdomain' = 'commercial_fleet');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `fleet_contract_line_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Line Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `dealer_incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `fleet_sales_representative_rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `fleet_vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Line Sales Rep Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Location Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `allocation_priority` SET TAGS ('dbx_business_glossary_term' = 'Allocation Priority');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `allocation_priority` SET TAGS ('dbx_value_regex' = 'standard|high|urgent|critical');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `amendment_notes` SET TAGS ('dbx_business_glossary_term' = 'Amendment Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `body_style` SET TAGS ('dbx_business_glossary_term' = 'Body Style');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Created By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `delivery_window_end_date` SET TAGS ('dbx_business_glossary_term' = 'Delivery Window End Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `delivery_window_start_date` SET TAGS ('dbx_business_glossary_term' = 'Delivery Window Start Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `destination_region` SET TAGS ('dbx_business_glossary_term' = 'Destination Region');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `exterior_color_code` SET TAGS ('dbx_business_glossary_term' = 'Exterior Color Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `fleet_use_type` SET TAGS ('dbx_business_glossary_term' = 'Fleet Use Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `fleet_use_type` SET TAGS ('dbx_value_regex' = 'commercial|rental|government|corporate|utility|emergency');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `fulfillment_status` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `fulfillment_status` SET TAGS ('dbx_value_regex' = 'pending|in_production|ready_for_delivery|partially_fulfilled|fully_fulfilled|cancelled');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `interior_color_code` SET TAGS ('dbx_business_glossary_term' = 'Interior Color Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `last_modified_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `last_modified_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `last_modified_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Line Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `line_status` SET TAGS ('dbx_business_glossary_term' = 'Line Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `line_status` SET TAGS ('dbx_value_regex' = 'active|on_hold|cancelled|completed|amended');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `msrp` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `nameplate` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Nameplate');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `planned_production_month` SET TAGS ('dbx_business_glossary_term' = 'Planned Production Month');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `planned_production_month` SET TAGS ('dbx_value_regex' = '^d{4}-(0[1-9]|1[0-2])$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ICE|EV|HEV|PHEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `quantity_committed` SET TAGS ('dbx_business_glossary_term' = 'Quantity Committed');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `quantity_fulfilled` SET TAGS ('dbx_business_glossary_term' = 'Quantity Fulfilled');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `quantity_remaining` SET TAGS ('dbx_business_glossary_term' = 'Quantity Remaining');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `regulatory_compliance_notes` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `special_equipment_codes` SET TAGS ('dbx_business_glossary_term' = 'Special Equipment Codes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `total_line_value` SET TAGS ('dbx_business_glossary_term' = 'Total Line Value');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `trim_level` SET TAGS ('dbx_business_glossary_term' = 'Trim Level');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ALTER COLUMN `unit_contracted_price` SET TAGS ('dbx_business_glossary_term' = 'Unit Contracted Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` SET TAGS ('dbx_subdomain' = 'incentive_programs');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `msrp_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Schedule ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `adas_level` SET TAGS ('dbx_business_glossary_term' = 'Advanced Driver Assistance Systems (ADAS) Level');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `adas_level` SET TAGS ('dbx_value_regex' = 'level_0|level_1|level_2|level_3|level_4|level_5');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `advertising_fee` SET TAGS ('dbx_business_glossary_term' = 'Advertising Fee');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `base_msrp` SET TAGS ('dbx_business_glossary_term' = 'Base Manufacturer Suggested Retail Price (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `body_style` SET TAGS ('dbx_business_glossary_term' = 'Body Style');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `cafe_credit_value` SET TAGS ('dbx_business_glossary_term' = 'Corporate Average Fuel Economy (CAFE) Credit Value');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `cafe_credit_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `destination_charge` SET TAGS ('dbx_business_glossary_term' = 'Destination and Delivery Charge');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `drivetrain` SET TAGS ('dbx_business_glossary_term' = 'Drivetrain Configuration');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `drivetrain` SET TAGS ('dbx_value_regex' = 'fwd|rwd|awd|4wd');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `engine_code` SET TAGS ('dbx_business_glossary_term' = 'Engine Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `epa_fuel_economy_city` SET TAGS ('dbx_business_glossary_term' = 'Environmental Protection Agency (EPA) Fuel Economy City');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `epa_fuel_economy_city` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `epa_fuel_economy_combined` SET TAGS ('dbx_business_glossary_term' = 'Environmental Protection Agency (EPA) Fuel Economy Combined');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `epa_fuel_economy_highway` SET TAGS ('dbx_business_glossary_term' = 'Environmental Protection Agency (EPA) Fuel Economy Highway');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `gas_guzzler_tax` SET TAGS ('dbx_business_glossary_term' = 'Gas Guzzler Tax');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `holdback_amount` SET TAGS ('dbx_business_glossary_term' = 'Dealer Holdback Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `holdback_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `invoice_price` SET TAGS ('dbx_business_glossary_term' = 'Dealer Invoice Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `invoice_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `market_region` SET TAGS ('dbx_business_glossary_term' = 'Market Region');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `nameplate` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Nameplate');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `ncap_safety_rating` SET TAGS ('dbx_business_glossary_term' = 'New Car Assessment Programme (NCAP) Safety Rating');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Schedule Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `option_package_code` SET TAGS ('dbx_business_glossary_term' = 'Option Package Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ice|hev|phev|bev|fcev');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `powertrain_warranty_miles` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Warranty Duration (Miles)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `powertrain_warranty_months` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Warranty Duration (Months)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `published_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Published Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `schedule_number` SET TAGS ('dbx_business_glossary_term' = 'MSRP Schedule Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `schedule_number` SET TAGS ('dbx_value_regex' = '^MSRP-[0-9]{6,10}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `schedule_status` SET TAGS ('dbx_business_glossary_term' = 'Schedule Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `schedule_status` SET TAGS ('dbx_value_regex' = 'draft|active|superseded|archived');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `schedule_type` SET TAGS ('dbx_business_glossary_term' = 'Schedule Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `schedule_type` SET TAGS ('dbx_value_regex' = 'launch|mid_cycle|promotional|fleet');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `total_msrp` SET TAGS ('dbx_business_glossary_term' = 'Total Manufacturer Suggested Retail Price (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `transmission_type` SET TAGS ('dbx_business_glossary_term' = 'Transmission Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `transmission_type` SET TAGS ('dbx_value_regex' = 'manual|automatic|cvt|dct');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `trim_level` SET TAGS ('dbx_business_glossary_term' = 'Trim Level');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `warranty_miles` SET TAGS ('dbx_business_glossary_term' = 'Warranty Duration (Miles)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ALTER COLUMN `warranty_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Duration (Months)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` SET TAGS ('dbx_subdomain' = 'territory_management');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `sales_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Territory ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Sales Manager Employee Id');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `employee_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Manager ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `sales_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Regional Director ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `sales_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `sales_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `tertiary_sales_regional_director_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Regional Director ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `tertiary_sales_regional_director_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `tertiary_sales_regional_director_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `annual_quota_revenue` SET TAGS ('dbx_business_glossary_term' = 'Annual Quota Revenue');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `annual_quota_units` SET TAGS ('dbx_business_glossary_term' = 'Annual Quota Units');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `competitive_intensity` SET TAGS ('dbx_business_glossary_term' = 'Competitive Intensity');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `competitive_intensity` SET TAGS ('dbx_value_regex' = 'low|medium|high|very_high');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `dealer_count` SET TAGS ('dbx_business_glossary_term' = 'Dealer Count');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = 'direct|dealer|fleet|online|export');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `district_code` SET TAGS ('dbx_business_glossary_term' = 'District Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `district_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,8}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `district_name` SET TAGS ('dbx_business_glossary_term' = 'District Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^FY[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `household_count` SET TAGS ('dbx_business_glossary_term' = 'Household Count');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `incentive_program_code` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `incentive_program_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `market_segment` SET TAGS ('dbx_business_glossary_term' = 'Market Segment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `market_segment` SET TAGS ('dbx_value_regex' = 'luxury|premium|mass_market|commercial|electric|performance');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `median_household_income` SET TAGS ('dbx_business_glossary_term' = 'Median Household Income');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `model_year_focus` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY) Focus');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `model_year_focus` SET TAGS ('dbx_value_regex' = '^MY[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Territory Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `population_count` SET TAGS ('dbx_business_glossary_term' = 'Population Count');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `postal_code_range` SET TAGS ('dbx_business_glossary_term' = 'Postal Code Range');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `postal_code_range` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `postal_code_range` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Territory Priority');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'strategic|high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `quota_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Quota Currency Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `quota_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,8}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `region_name` SET TAGS ('dbx_business_glossary_term' = 'Region Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `regulatory_region` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Region');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `sales_manager_name` SET TAGS ('dbx_business_glossary_term' = 'Sales Manager Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `sales_manager_name` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `sales_office_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Office Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `sales_office_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,8}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `state_province_code` SET TAGS ('dbx_business_glossary_term' = 'State or Province Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `state_province_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,6}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `state_province_code` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `territory_code` SET TAGS ('dbx_business_glossary_term' = 'Territory Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `territory_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,12}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `territory_name` SET TAGS ('dbx_business_glossary_term' = 'Territory Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `territory_status` SET TAGS ('dbx_business_glossary_term' = 'Territory Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `territory_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|planned|consolidating|splitting');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `territory_type` SET TAGS ('dbx_business_glossary_term' = 'Territory Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `territory_type` SET TAGS ('dbx_value_regex' = 'retail|fleet|export|commercial|government|dealer_network');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `time_zone` SET TAGS ('dbx_business_glossary_term' = 'Time Zone');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `vehicle_category_focus` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Category Focus');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `vehicle_registration_count` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Registration Count');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `zone_code` SET TAGS ('dbx_business_glossary_term' = 'Zone Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `zone_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,8}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ALTER COLUMN `zone_name` SET TAGS ('dbx_business_glossary_term' = 'Zone Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` SET TAGS ('dbx_subdomain' = 'territory_management');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Relationship Management (CRM) User ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `tertiary_rep_manager_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Manager Employee ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `tertiary_rep_manager_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `tertiary_rep_manager_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `sales_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Territory Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `active_status` SET TAGS ('dbx_business_glossary_term' = 'Active Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `certification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `certification_status` SET TAGS ('dbx_business_glossary_term' = 'Sales Certification Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `certification_status` SET TAGS ('dbx_value_regex' = 'certified|in_progress|expired|not_required');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `commission_plan_code` SET TAGS ('dbx_business_glossary_term' = 'Commission Plan Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `commission_plan_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `commission_plan_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `crm_user_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Relationship Management (CRM) User ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `crm_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `crm_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `dealer_count` SET TAGS ('dbx_business_glossary_term' = 'Assigned Dealer Count');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `email_address` SET TAGS ('dbx_business_glossary_term' = 'Email Address');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `email_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `first_name` SET TAGS ('dbx_business_glossary_term' = 'First Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `first_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `first_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `fleet_account_count` SET TAGS ('dbx_business_glossary_term' = 'Assigned Fleet Account Count');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `hire_date` SET TAGS ('dbx_business_glossary_term' = 'Hire Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `language_proficiency` SET TAGS ('dbx_business_glossary_term' = 'Language Proficiency');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `last_name` SET TAGS ('dbx_business_glossary_term' = 'Last Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `last_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `last_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `mobile_number` SET TAGS ('dbx_business_glossary_term' = 'Mobile Phone Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `mobile_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `mobile_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `office_location` SET TAGS ('dbx_business_glossary_term' = 'Office Location');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `performance_tier` SET TAGS ('dbx_business_glossary_term' = 'Performance Tier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `performance_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|developing');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `performance_tier` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Phone Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `product_specialization` SET TAGS ('dbx_business_glossary_term' = 'Product Specialization');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `quota_amount` SET TAGS ('dbx_business_glossary_term' = 'Sales Quota Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `quota_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `quota_currency` SET TAGS ('dbx_business_glossary_term' = 'Quota Currency Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `quota_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `quota_period` SET TAGS ('dbx_business_glossary_term' = 'Quota Period');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `quota_period` SET TAGS ('dbx_value_regex' = 'annual|quarterly|monthly');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Sales Region');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `sales_role` SET TAGS ('dbx_business_glossary_term' = 'Sales Role');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `sales_role` SET TAGS ('dbx_value_regex' = 'retail_field_rep|fleet_account_manager|national_account_executive|export_sales|regional_sales_manager|dealer_development');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `sales_start_date` SET TAGS ('dbx_business_glossary_term' = 'Sales Start Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Termination Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `territory_name` SET TAGS ('dbx_business_glossary_term' = 'Territory Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `work_arrangement` SET TAGS ('dbx_business_glossary_term' = 'Work Arrangement');
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ALTER COLUMN `work_arrangement` SET TAGS ('dbx_value_regex' = 'field_based|office_based|hybrid|remote');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` SET TAGS ('dbx_subdomain' = 'territory_management');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `quota_id` SET TAGS ('dbx_business_glossary_term' = 'Quota Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Assignee Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `dealer_incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assignee Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `quota_rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `quota_sales_representative_rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `sales_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Territory Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|revision_required');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approved Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `assignee_name` SET TAGS ('dbx_business_glossary_term' = 'Assignee Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `assignee_type` SET TAGS ('dbx_business_glossary_term' = 'Assignee Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `fiscal_month` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Month');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `fiscal_month` SET TAGS ('dbx_value_regex' = '^M(0[1-9]|1[0-2])$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `fiscal_quarter` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Quarter');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `fiscal_quarter` SET TAGS ('dbx_value_regex' = 'Q1|Q2|Q3|Q4');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^FY[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `incentive_eligible` SET TAGS ('dbx_business_glossary_term' = 'Incentive Eligible Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `model_year` SET TAGS ('dbx_value_regex' = '^MY[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `quota_name` SET TAGS ('dbx_business_glossary_term' = 'Quota Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Period End Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Period Start Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV|all');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `product_line` SET TAGS ('dbx_business_glossary_term' = 'Product Line');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `quota_number` SET TAGS ('dbx_business_glossary_term' = 'Quota Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `quota_number` SET TAGS ('dbx_value_regex' = '^QTA-[0-9]{8}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `quota_status` SET TAGS ('dbx_business_glossary_term' = 'Quota Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `quota_status` SET TAGS ('dbx_value_regex' = 'draft|approved|active|suspended|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `quota_type` SET TAGS ('dbx_business_glossary_term' = 'Quota Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `quota_type` SET TAGS ('dbx_value_regex' = 'unit_volume|revenue|ev_mix|fleet_penetration|market_share|model_mix');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Revision Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `revision_reason` SET TAGS ('dbx_business_glossary_term' = 'Revision Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `sales_channel` SET TAGS ('dbx_business_glossary_term' = 'Sales Channel');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `sales_channel` SET TAGS ('dbx_value_regex' = 'retail|fleet|commercial|government|direct|dealer_network');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `target_unit` SET TAGS ('dbx_business_glossary_term' = 'Target Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `target_value` SET TAGS ('dbx_business_glossary_term' = 'Target Value');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `threshold_minimum` SET TAGS ('dbx_business_glossary_term' = 'Threshold Minimum');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `threshold_stretch` SET TAGS ('dbx_business_glossary_term' = 'Threshold Stretch');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `vehicle_segment` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Segment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` SET TAGS ('dbx_subdomain' = 'revenue_pursuit');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `activity_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Activity ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `activity_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `activity_sales_representative_rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `competitor_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Competitor Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `dealer_contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `contact_point_id` SET TAGS ('dbx_business_glossary_term' = 'Contact ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Activity Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `sales_lead_id` SET TAGS ('dbx_business_glossary_term' = 'Lead ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `sales_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Territory Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `activity_date` SET TAGS ('dbx_business_glossary_term' = 'Activity Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `activity_number` SET TAGS ('dbx_business_glossary_term' = 'Activity Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `activity_number` SET TAGS ('dbx_value_regex' = '^ACT-[0-9]{8}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `activity_status` SET TAGS ('dbx_business_glossary_term' = 'Activity Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `activity_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|cancelled|no_show|rescheduled');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `activity_type` SET TAGS ('dbx_business_glossary_term' = 'Activity Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `competitor_mentioned` SET TAGS ('dbx_business_glossary_term' = 'Competitor Mentioned');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `customer_sentiment` SET TAGS ('dbx_business_glossary_term' = 'Customer Sentiment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `customer_sentiment` SET TAGS ('dbx_value_regex' = 'very_positive|positive|neutral|negative|very_negative');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `demo_completed` SET TAGS ('dbx_business_glossary_term' = 'Demo Completed Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `activity_description` SET TAGS ('dbx_business_glossary_term' = 'Activity Description');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Duration in Minutes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Activity End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `estimated_deal_value` SET TAGS ('dbx_business_glossary_term' = 'Estimated Deal Value');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `fiscal_quarter` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Quarter');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `fiscal_quarter` SET TAGS ('dbx_value_regex' = 'Q1|Q2|Q3|Q4');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^FY[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `is_commercial_vehicle` SET TAGS ('dbx_business_glossary_term' = 'Commercial Vehicle Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `is_fleet_sale` SET TAGS ('dbx_business_glossary_term' = 'Fleet Sale Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `location` SET TAGS ('dbx_business_glossary_term' = 'Activity Location');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `model_year` SET TAGS ('dbx_value_regex' = '^MY[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `modified_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `modified_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `modified_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `next_action` SET TAGS ('dbx_business_glossary_term' = 'Next Action');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `next_action_date` SET TAGS ('dbx_business_glossary_term' = 'Next Action Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `objection_raised` SET TAGS ('dbx_business_glossary_term' = 'Objection Raised');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `objection_resolved` SET TAGS ('dbx_business_glossary_term' = 'Objection Resolved Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `outcome` SET TAGS ('dbx_business_glossary_term' = 'Activity Outcome');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Activity Priority');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|urgent');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `quote_presented` SET TAGS ('dbx_business_glossary_term' = 'Quote Presented Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Sales Region');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Activity Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `subject` SET TAGS ('dbx_business_glossary_term' = 'Activity Subject');
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ALTER COLUMN `test_drive_completed` SET TAGS ('dbx_business_glossary_term' = 'Test Drive Completed Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_test_drive` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_test_drive` SET TAGS ('dbx_subdomain' = 'revenue_pursuit');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_test_drive` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_test_drive` SET TAGS ('dbx_ssot_reference' = 'dealer.dealer_test_drive.dealer_test_drive_id');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_test_drive` ALTER COLUMN `sales_test_drive_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for sales_test_drive');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_test_drive` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` SET TAGS ('dbx_subdomain' = 'revenue_pursuit');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `trade_in_id` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Appraiser Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `trade_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Appraiser Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `trade_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `trade_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `trade_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Identifier');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` SET TAGS ('dbx_subdomain' = 'revenue_pursuit');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Appointment Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Specialist Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `delivery_vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `technician_id` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Technician Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `primary_delivery_specialist_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Specialist Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `primary_delivery_specialist_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `primary_delivery_specialist_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `rescheduled_from_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Rescheduled From Appointment Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `rescheduled_from_appointment_id` SET TAGS ('dbx_self_reference' = 'rescheduled_from');
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` SET TAGS ('dbx_subdomain' = 'territory_management');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `applicable_powertrain_types` SET TAGS ('dbx_business_glossary_term' = 'Applicable Powertrain Types');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `applicable_vehicle_types` SET TAGS ('dbx_business_glossary_term' = 'Applicable Vehicle Types');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `channel_category` SET TAGS ('dbx_business_glossary_term' = 'Channel Category');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `channel_category` SET TAGS ('dbx_value_regex' = 'direct|indirect|hybrid');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `channel_status` SET TAGS ('dbx_business_glossary_term' = 'Channel Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `channel_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|planned|discontinued');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `channel_type` SET TAGS ('dbx_business_glossary_term' = 'Channel Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `channel_code` SET TAGS ('dbx_business_glossary_term' = 'Channel Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `channel_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `commission_model` SET TAGS ('dbx_business_glossary_term' = 'Commission Model');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `commission_model` SET TAGS ('dbx_value_regex' = 'fixed|percentage|tiered|hybrid|none');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `country_codes` SET TAGS ('dbx_business_glossary_term' = 'Country Codes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `crm_integration_enabled` SET TAGS ('dbx_business_glossary_term' = 'CRM (Customer Relationship Management) Integration Enabled');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `default_commission_rate` SET TAGS ('dbx_business_glossary_term' = 'Default Commission Rate Percentage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `channel_description` SET TAGS ('dbx_business_glossary_term' = 'Channel Description');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `dms_integration_enabled` SET TAGS ('dbx_business_glossary_term' = 'DMS (Dealer Management System) Integration Enabled');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `erp_sales_channel_code` SET TAGS ('dbx_business_glossary_term' = 'ERP (Enterprise Resource Planning) Sales Channel Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `incentive_eligibility` SET TAGS ('dbx_business_glossary_term' = 'Incentive Eligibility');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `incentive_eligibility` SET TAGS ('dbx_value_regex' = 'eligible|ineligible|conditional');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `is_dealer_mediated` SET TAGS ('dbx_business_glossary_term' = 'Is Dealer Mediated Channel');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `is_direct_oem` SET TAGS ('dbx_business_glossary_term' = 'Is Direct OEM (Original Equipment Manufacturer) Channel');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `lead_source_priority` SET TAGS ('dbx_business_glossary_term' = 'Lead Source Priority');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `market_region` SET TAGS ('dbx_business_glossary_term' = 'Market Region');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `channel_name` SET TAGS ('dbx_business_glossary_term' = 'Channel Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `owner` SET TAGS ('dbx_business_glossary_term' = 'Channel Owner');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `pricing_strategy` SET TAGS ('dbx_business_glossary_term' = 'Pricing Strategy');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `pricing_strategy` SET TAGS ('dbx_value_regex' = 'msrp|negotiated|fixed|dynamic|auction');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `supports_financing` SET TAGS ('dbx_business_glossary_term' = 'Supports Financing');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `supports_fleet_sales` SET TAGS ('dbx_business_glossary_term' = 'Supports Fleet Sales');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `supports_leasing` SET TAGS ('dbx_business_glossary_term' = 'Supports Leasing');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `supports_online_configuration` SET TAGS ('dbx_business_glossary_term' = 'Supports Online Configuration');
ALTER TABLE `vibe_automotive_v1`.`sales`.`channel` ALTER COLUMN `supports_trade_in` SET TAGS ('dbx_business_glossary_term' = 'Supports Trade-In');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` SET TAGS ('dbx_subdomain' = 'incentive_programs');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `price_adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Price Adjustment Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approving Manager Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `price_vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `quote_id` SET TAGS ('dbx_business_glossary_term' = 'Quote Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Order Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `adjusted_price` SET TAGS ('dbx_business_glossary_term' = 'Adjusted Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `adjustment_amount` SET TAGS ('dbx_business_glossary_term' = 'Price Adjustment Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `adjustment_category` SET TAGS ('dbx_business_glossary_term' = 'Price Adjustment Category');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `adjustment_method` SET TAGS ('dbx_business_glossary_term' = 'Price Adjustment Method');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `adjustment_method` SET TAGS ('dbx_value_regex' = 'fixed_amount|percentage|tiered|formula_based');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `adjustment_number` SET TAGS ('dbx_business_glossary_term' = 'Price Adjustment Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `adjustment_percentage` SET TAGS ('dbx_business_glossary_term' = 'Price Adjustment Percentage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `adjustment_type` SET TAGS ('dbx_business_glossary_term' = 'Price Adjustment Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `applied_date` SET TAGS ('dbx_business_glossary_term' = 'Applied Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|expired|revoked');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `audit_date` SET TAGS ('dbx_business_glossary_term' = 'Audit Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `audit_flag` SET TAGS ('dbx_business_glossary_term' = 'Audit Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `audit_outcome` SET TAGS ('dbx_business_glossary_term' = 'Audit Outcome');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `audit_outcome` SET TAGS ('dbx_value_regex' = 'approved|exception_noted|corrective_action_required|fraudulent');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `authorization_level` SET TAGS ('dbx_business_glossary_term' = 'Authorization Level');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `base_price` SET TAGS ('dbx_business_glossary_term' = 'Base Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `funding_source` SET TAGS ('dbx_business_glossary_term' = 'Funding Source');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `funding_source` SET TAGS ('dbx_value_regex' = 'manufacturer|dealer|shared|regional_marketing|national_advertising');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `gl_account` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `justification` SET TAGS ('dbx_business_glossary_term' = 'Price Adjustment Justification');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Price Adjustment Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `program_code` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `program_name` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Region Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `rejection_date` SET TAGS ('dbx_business_glossary_term' = 'Rejection Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `sales_channel` SET TAGS ('dbx_business_glossary_term' = 'Sales Channel');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `stacking_allowed` SET TAGS ('dbx_business_glossary_term' = 'Stacking Allowed Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `submitting_user_code` SET TAGS ('dbx_business_glossary_term' = 'Submitting User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `submitting_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `submitting_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `territory_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Territory Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` SET TAGS ('dbx_subdomain' = 'revenue_pursuit');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `order_status_event_id` SET TAGS ('dbx_business_glossary_term' = 'Order Status Event Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Triggering User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `order_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `order_vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Order Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `actual_production_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Production Completion Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `actual_production_start_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Production Start Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `carrier_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `delay_days` SET TAGS ('dbx_business_glossary_term' = 'Delay Days');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `destination_location` SET TAGS ('dbx_business_glossary_term' = 'Destination Location');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `estimated_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `event_notes` SET TAGS ('dbx_business_glossary_term' = 'Event Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `event_type` SET TAGS ('dbx_business_glossary_term' = 'Event Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `event_type` SET TAGS ('dbx_value_regex' = 'status_change|milestone_reached|exception|cancellation|amendment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `exception_flag` SET TAGS ('dbx_business_glossary_term' = 'Exception Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `exception_reason` SET TAGS ('dbx_business_glossary_term' = 'Exception Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `new_status` SET TAGS ('dbx_business_glossary_term' = 'New Order Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `notification_channel` SET TAGS ('dbx_business_glossary_term' = 'Notification Channel');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `notification_channel` SET TAGS ('dbx_value_regex' = 'email|sms|push|portal|phone|none');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `notification_sent_flag` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Sent Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `origin_location` SET TAGS ('dbx_business_glossary_term' = 'Origin Location');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `previous_status` SET TAGS ('dbx_business_glossary_term' = 'Previous Order Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `production_line` SET TAGS ('dbx_business_glossary_term' = 'Production Line');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `quality_release_date` SET TAGS ('dbx_business_glossary_term' = 'Quality Release Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Sales Region');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `responsible_party` SET TAGS ('dbx_business_glossary_term' = 'Responsible Party');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `sales_channel` SET TAGS ('dbx_business_glossary_term' = 'Sales Channel');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `sales_channel` SET TAGS ('dbx_value_regex' = 'retail|fleet|commercial|direct|online');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `scheduled_production_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Production Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `shipment_date` SET TAGS ('dbx_business_glossary_term' = 'Shipment Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Shipment Tracking Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `triggering_system` SET TAGS ('dbx_business_glossary_term' = 'Triggering System');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `triggering_user_code` SET TAGS ('dbx_business_glossary_term' = 'Triggering User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `triggering_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `triggering_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` SET TAGS ('dbx_subdomain' = 'revenue_pursuit');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Campaign Identifier (SCID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Owner Identifier (COI)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `owner_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Owner Identifier (COI)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `owner_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `owner_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `actual_spent_amount` SET TAGS ('dbx_business_glossary_term' = 'Actual Spent Amount (ASA)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `actual_spent_currency` SET TAGS ('dbx_business_glossary_term' = 'Actual Spent Currency Code (ASCC)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `actual_spent_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Budget Amount (BA)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `budget_currency` SET TAGS ('dbx_business_glossary_term' = 'Budget Currency Code (BCC)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `budget_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `campaign_status` SET TAGS ('dbx_business_glossary_term' = 'Campaign Status (CS)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `campaign_status` SET TAGS ('dbx_value_regex' = 'planned|active|completed|cancelled|on_hold');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `campaign_type` SET TAGS ('dbx_business_glossary_term' = 'Campaign Type (CT)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `campaign_type` SET TAGS ('dbx_value_regex' = 'model_launch|clearance|seasonal|conquest|loyalty');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (RCT)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `dealer_participation_flag` SET TAGS ('dbx_business_glossary_term' = 'Dealer Participation Flag (DPF)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `campaign_description` SET TAGS ('dbx_business_glossary_term' = 'Campaign Description (CD)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Campaign End Date (CED)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `kpi_market_share_actual` SET TAGS ('dbx_business_glossary_term' = 'Market Share Actual KPI (MSA)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `kpi_market_share_target` SET TAGS ('dbx_business_glossary_term' = 'Market Share Target KPI (MSTK)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `kpi_sales_volume_actual` SET TAGS ('dbx_business_glossary_term' = 'Sales Volume Actual KPI (SVA)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `kpi_sales_volume_target` SET TAGS ('dbx_business_glossary_term' = 'Sales Volume Target KPI (SVTK)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `marketing_channels` SET TAGS ('dbx_business_glossary_term' = 'Marketing Channels (MC)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `marketing_channels` SET TAGS ('dbx_value_regex' = 'dealer|online|direct|partner|mixed');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `campaign_name` SET TAGS ('dbx_business_glossary_term' = 'Campaign Name (CN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Additional Notes (AN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `objective` SET TAGS ('dbx_business_glossary_term' = 'Campaign Objective (CO)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Campaign Priority (CP)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region ISO 3166-1 Alpha-3 Code (RIC)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Campaign Start Date (CSD)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `target_customer_segment` SET TAGS ('dbx_business_glossary_term' = 'Target Customer Segment (TCS)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `target_customer_segment` SET TAGS ('dbx_value_regex' = 'fleet|consumer|luxury|commercial');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `target_model_year` SET TAGS ('dbx_business_glossary_term' = 'Target Model Year (TMY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `target_nameplate` SET TAGS ('dbx_business_glossary_term' = 'Target Vehicle Nameplate (TVN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `territory_code` SET TAGS ('dbx_business_glossary_term' = 'Territory Code (TC)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp (RUT)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` SET TAGS ('dbx_subdomain' = 'revenue_pursuit');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `campaign_response_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Response Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `campaign_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `campaign_sales_representative_rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `individual_id` SET TAGS ('dbx_business_glossary_term' = 'Prospect Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `sales_lead_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `city` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `conversion_date` SET TAGS ('dbx_business_glossary_term' = 'Conversion Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `converted_to_lead` SET TAGS ('dbx_business_glossary_term' = 'Converted to Lead Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `converted_to_opportunity` SET TAGS ('dbx_business_glossary_term' = 'Converted to Opportunity Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `financing_interest` SET TAGS ('dbx_business_glossary_term' = 'Financing Interest Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `model_year_interest` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY) Interest');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `opt_in_email` SET TAGS ('dbx_business_glossary_term' = 'Email Opt-In Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `opt_in_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `opt_in_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `opt_in_phone` SET TAGS ('dbx_business_glossary_term' = 'Phone Opt-In Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `opt_in_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `opt_in_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `opt_in_sms` SET TAGS ('dbx_business_glossary_term' = 'SMS Opt-In Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `postal_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `powertrain_interest` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Interest');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `powertrain_interest` SET TAGS ('dbx_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `purchase_timeframe` SET TAGS ('dbx_business_glossary_term' = 'Purchase Timeframe');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `purchase_timeframe` SET TAGS ('dbx_value_regex' = 'immediate|1_3_months|3_6_months|6_12_months|over_12_months|undecided');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `respondent_email` SET TAGS ('dbx_business_glossary_term' = 'Respondent Email Address');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `respondent_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `respondent_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `respondent_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `respondent_first_name` SET TAGS ('dbx_business_glossary_term' = 'Respondent First Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `respondent_first_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `respondent_first_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `respondent_last_name` SET TAGS ('dbx_business_glossary_term' = 'Respondent Last Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `respondent_last_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `respondent_last_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `respondent_phone` SET TAGS ('dbx_business_glossary_term' = 'Respondent Phone Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `respondent_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `respondent_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `response_channel` SET TAGS ('dbx_business_glossary_term' = 'Response Channel');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `response_channel` SET TAGS ('dbx_value_regex' = 'email|web_form|phone|dealer_visit|mobile_app|social_media');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `response_date` SET TAGS ('dbx_business_glossary_term' = 'Response Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `response_notes` SET TAGS ('dbx_business_glossary_term' = 'Response Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `response_number` SET TAGS ('dbx_business_glossary_term' = 'Campaign Response Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `response_score` SET TAGS ('dbx_business_glossary_term' = 'Response Quality Score');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `response_source` SET TAGS ('dbx_business_glossary_term' = 'Response Source');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `response_status` SET TAGS ('dbx_business_glossary_term' = 'Response Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `response_status` SET TAGS ('dbx_value_regex' = 'new|contacted|qualified|converted|disqualified|closed');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `response_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Response Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `response_type` SET TAGS ('dbx_business_glossary_term' = 'Response Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `response_type` SET TAGS ('dbx_value_regex' = 'inquiry|test_drive_request|quote_request|brochure_download|event_registration|callback_request');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State or Province');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `state_province` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `test_drive_requested` SET TAGS ('dbx_business_glossary_term' = 'Test Drive Requested Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `trade_in_interest` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Interest Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `utm_campaign` SET TAGS ('dbx_business_glossary_term' = 'UTM Campaign Parameter');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `utm_medium` SET TAGS ('dbx_business_glossary_term' = 'UTM Medium Parameter');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `utm_source` SET TAGS ('dbx_business_glossary_term' = 'UTM Source Parameter');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `vehicle_interest_category` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Interest Category');
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ALTER COLUMN `vehicle_model_interest` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Model Interest');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` SET TAGS ('dbx_subdomain' = 'territory_management');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `competitor_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Competitor Vehicle ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `adas_level` SET TAGS ('dbx_business_glossary_term' = 'Advanced Driver Assistance Systems (ADAS) Level');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `adas_level` SET TAGS ('dbx_value_regex' = 'none|level1|level2|level3|level4|level5');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `base_msrp` SET TAGS ('dbx_business_glossary_term' = 'Base Manufacturer Suggested Retail Price (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `battery_capacity_kwh` SET TAGS ('dbx_business_glossary_term' = 'Battery Capacity (Kilowatt-Hours)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `battery_capacity_kwh` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `body_style` SET TAGS ('dbx_business_glossary_term' = 'Body Style Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `cargo_volume_cubic_ft` SET TAGS ('dbx_business_glossary_term' = 'Cargo Volume (Cubic Feet)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `competitive_positioning` SET TAGS ('dbx_business_glossary_term' = 'Competitive Positioning Classification');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `competitive_positioning` SET TAGS ('dbx_value_regex' = 'direct|indirect|emerging');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `competitor_brand` SET TAGS ('dbx_business_glossary_term' = 'Competitor Brand Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `competitor_vehicle_status` SET TAGS ('dbx_business_glossary_term' = 'Competitor Vehicle Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `competitor_vehicle_status` SET TAGS ('dbx_value_regex' = 'active|discontinued|upcoming|rumored');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `data_source` SET TAGS ('dbx_business_glossary_term' = 'Data Source Reference');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `discontinuation_date` SET TAGS ('dbx_business_glossary_term' = 'Discontinuation Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `drivetrain_type` SET TAGS ('dbx_business_glossary_term' = 'Drivetrain Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `drivetrain_type` SET TAGS ('dbx_value_regex' = 'fwd|rwd|awd|4wd');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `electric_range_miles` SET TAGS ('dbx_business_glossary_term' = 'Electric Range (Miles)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `engine_displacement_liters` SET TAGS ('dbx_business_glossary_term' = 'Engine Displacement (Liters)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `fuel_economy_city_mpg` SET TAGS ('dbx_business_glossary_term' = 'Fuel Economy City (Miles Per Gallon)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `fuel_economy_city_mpg` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `fuel_economy_combined_mpg` SET TAGS ('dbx_business_glossary_term' = 'Fuel Economy Combined (Miles Per Gallon)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `fuel_economy_highway_mpg` SET TAGS ('dbx_business_glossary_term' = 'Fuel Economy Highway (Miles Per Gallon)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `horsepower` SET TAGS ('dbx_business_glossary_term' = 'Horsepower Rating');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `key_features` SET TAGS ('dbx_business_glossary_term' = 'Key Feature Highlights');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `last_updated_date` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `launch_date` SET TAGS ('dbx_business_glossary_term' = 'Market Launch Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `market_availability_region` SET TAGS ('dbx_business_glossary_term' = 'Market Availability Region');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Competitive Intelligence Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ice|hev|phev|bev|fcev');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `safety_rating_ncap` SET TAGS ('dbx_business_glossary_term' = 'Safety Rating (NCAP)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `seating_capacity` SET TAGS ('dbx_business_glossary_term' = 'Seating Capacity');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `seating_capacity` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `torque_lb_ft` SET TAGS ('dbx_business_glossary_term' = 'Torque (Pound-Feet)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `towing_capacity_lbs` SET TAGS ('dbx_business_glossary_term' = 'Towing Capacity (Pounds)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `towing_capacity_lbs` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `transmission_type` SET TAGS ('dbx_business_glossary_term' = 'Transmission Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `vehicle_segment` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Segment Classification');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `win_loss_relevance` SET TAGS ('dbx_business_glossary_term' = 'Win/Loss Analysis Relevance');
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ALTER COLUMN `win_loss_relevance` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` SET TAGS ('dbx_subdomain' = 'revenue_pursuit');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` SET TAGS ('dbx_analytics_ready' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `win_loss_id` SET TAGS ('dbx_business_glossary_term' = 'Win Loss Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `dealer_incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reviewed By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `sales_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Territory Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `win_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `win_sales_representative_rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `win_vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `analysis_number` SET TAGS ('dbx_business_glossary_term' = 'Win Loss Analysis Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `analysis_status` SET TAGS ('dbx_business_glossary_term' = 'Analysis Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `analysis_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|reviewed|approved');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `competitor_brand` SET TAGS ('dbx_business_glossary_term' = 'Competitor Brand');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `competitor_model` SET TAGS ('dbx_business_glossary_term' = 'Competitor Model');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `competitor_model_year` SET TAGS ('dbx_business_glossary_term' = 'Competitor Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `competitor_price` SET TAGS ('dbx_business_glossary_term' = 'Competitor Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `customer_decision_factor_availability` SET TAGS ('dbx_business_glossary_term' = 'Customer Decision Factor - Availability');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `customer_decision_factor_brand` SET TAGS ('dbx_business_glossary_term' = 'Customer Decision Factor - Brand');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `customer_decision_factor_features` SET TAGS ('dbx_business_glossary_term' = 'Customer Decision Factor - Features');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `customer_decision_factor_financing` SET TAGS ('dbx_business_glossary_term' = 'Customer Decision Factor - Financing');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `customer_decision_factor_price` SET TAGS ('dbx_business_glossary_term' = 'Customer Decision Factor - Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `customer_decision_factor_service` SET TAGS ('dbx_business_glossary_term' = 'Customer Decision Factor - Service');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `deal_value` SET TAGS ('dbx_business_glossary_term' = 'Deal Value');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `fiscal_quarter` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Quarter');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `fiscal_quarter` SET TAGS ('dbx_value_regex' = 'Q1|Q2|Q3|Q4');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `lead_source` SET TAGS ('dbx_business_glossary_term' = 'Lead Source');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Analysis Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `opportunity_type` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `opportunity_type` SET TAGS ('dbx_value_regex' = 'new_vehicle|used_vehicle|lease|fleet');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `outcome` SET TAGS ('dbx_business_glossary_term' = 'Sales Outcome');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `outcome` SET TAGS ('dbx_value_regex' = 'won|lost|no_decision|cancelled');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `outcome_date` SET TAGS ('dbx_business_glossary_term' = 'Outcome Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `outcome_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Outcome Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `primary_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Primary Reason Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `primary_reason_description` SET TAGS ('dbx_business_glossary_term' = 'Primary Reason Description');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `reviewed_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Reviewed By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `reviewed_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `reviewed_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `reviewed_date` SET TAGS ('dbx_business_glossary_term' = 'Reviewed Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `sales_channel` SET TAGS ('dbx_business_glossary_term' = 'Sales Channel');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `sales_channel` SET TAGS ('dbx_value_regex' = 'retail|fleet|commercial|direct|online');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `sales_rep_assessment` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative Assessment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `secondary_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Secondary Reason Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`win_loss` ALTER COLUMN `secondary_reason_description` SET TAGS ('dbx_business_glossary_term' = 'Secondary Reason Description');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` SET TAGS ('dbx_subdomain' = 'revenue_pursuit');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Contract Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `contract_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `contract_sales_representative_rep_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Representative Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `contract_vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `agreed_price` SET TAGS ('dbx_business_glossary_term' = 'Agreed Price');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `approved_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Approved By User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `approved_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `approved_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `cancellation_date` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `contract_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `contract_status` SET TAGS ('dbx_business_glossary_term' = 'Contract Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_business_glossary_term' = 'Contract Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_value_regex' = 'retail_purchase|lease|fleet_purchase|government_contract|commercial_sale|demo_sale');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `contracting_party_name` SET TAGS ('dbx_business_glossary_term' = 'Contracting Party Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `customer_legal_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Legal Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `customer_legal_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `customer_legal_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `delivery_location` SET TAGS ('dbx_business_glossary_term' = 'Delivery Location');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `document_reference` SET TAGS ('dbx_business_glossary_term' = 'Document Reference');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `down_payment_amount` SET TAGS ('dbx_business_glossary_term' = 'Down Payment Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `fees_amount` SET TAGS ('dbx_business_glossary_term' = 'Fees Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `financing_term_months` SET TAGS ('dbx_business_glossary_term' = 'Financing Term in Months');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `financing_type` SET TAGS ('dbx_business_glossary_term' = 'Financing Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `financing_type` SET TAGS ('dbx_value_regex' = 'cash|loan|lease|captive_finance|third_party_finance|fleet_finance');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `incentive_amount` SET TAGS ('dbx_business_glossary_term' = 'Incentive Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `interest_rate` SET TAGS ('dbx_business_glossary_term' = 'Interest Rate');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `monthly_payment_amount` SET TAGS ('dbx_business_glossary_term' = 'Monthly Payment Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `msrp` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `sales_channel` SET TAGS ('dbx_business_glossary_term' = 'Sales Channel');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `sales_channel` SET TAGS ('dbx_value_regex' = 'dealer_retail|direct_oem|fleet_sales|online|auction|broker');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `signed_date` SET TAGS ('dbx_business_glossary_term' = 'Signed Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `special_terms` SET TAGS ('dbx_business_glossary_term' = 'Special Terms');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `total_contract_value` SET TAGS ('dbx_business_glossary_term' = 'Total Contract Value');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `trade_in_value` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Value');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `warranty_mileage_limit` SET TAGS ('dbx_business_glossary_term' = 'Warranty Mileage Limit');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `warranty_term_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Term in Months');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `warranty_type` SET TAGS ('dbx_business_glossary_term' = 'Warranty Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ALTER COLUMN `warranty_type` SET TAGS ('dbx_value_regex' = 'standard|extended|certified_pre_owned|none');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` SET TAGS ('dbx_subdomain' = 'territory_management');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `regional_sales_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Regional Sales Plan ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Plan Owner ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `regional_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Plan Owner ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `regional_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `regional_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `sales_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Territory Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `tertiary_regional_created_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `tertiary_regional_created_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `tertiary_regional_created_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|revision_required');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `approved_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `approved_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `approved_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `average_msrp` SET TAGS ('dbx_business_glossary_term' = 'Average Manufacturer Suggested Retail Price (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `average_msrp` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `body_style` SET TAGS ('dbx_business_glossary_term' = 'Body Style');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `created_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `dealer_network_code` SET TAGS ('dbx_business_glossary_term' = 'Dealer Network ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `ev_penetration_target_percentage` SET TAGS ('dbx_business_glossary_term' = 'Electric Vehicle (EV) Penetration Target Percentage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `ev_volume_units` SET TAGS ('dbx_business_glossary_term' = 'Electric Vehicle (EV) Volume Units');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `fiscal_quarter` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Quarter');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `fiscal_quarter` SET TAGS ('dbx_value_regex' = 'Q1|Q2|Q3|Q4');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `fleet_mix_percentage` SET TAGS ('dbx_business_glossary_term' = 'Fleet Mix Percentage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `hev_volume_units` SET TAGS ('dbx_business_glossary_term' = 'Hybrid Electric Vehicle (HEV) Volume Units');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `ice_volume_units` SET TAGS ('dbx_business_glossary_term' = 'Internal Combustion Engine (ICE) Volume Units');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `incentive_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Incentive Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `incentive_budget_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `last_modified_by_user_code` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User ID');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `last_modified_by_user_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `last_modified_by_user_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `market_zone` SET TAGS ('dbx_business_glossary_term' = 'Market Zone');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `minimum_volume_units` SET TAGS ('dbx_business_glossary_term' = 'Minimum Volume Units');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `nameplate` SET TAGS ('dbx_business_glossary_term' = 'Nameplate');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `phev_volume_units` SET TAGS ('dbx_business_glossary_term' = 'Plug-in Hybrid Electric Vehicle (PHEV) Volume Units');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Plan Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `plan_notes` SET TAGS ('dbx_business_glossary_term' = 'Plan Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Plan Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_business_glossary_term' = 'Plan Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|approved|active|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Plan Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'annual|quarterly|monthly|strategic|tactical');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `planning_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Planning Period End Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `planning_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planning Period Start Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `region_name` SET TAGS ('dbx_business_glossary_term' = 'Region Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `retail_mix_percentage` SET TAGS ('dbx_business_glossary_term' = 'Retail Mix Percentage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `revision_number` SET TAGS ('dbx_business_glossary_term' = 'Revision Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `revision_reason` SET TAGS ('dbx_business_glossary_term' = 'Revision Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `sales_channel` SET TAGS ('dbx_business_glossary_term' = 'Sales Channel');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `sales_channel` SET TAGS ('dbx_value_regex' = 'retail|fleet|commercial|government|direct|dealer');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `stretch_volume_units` SET TAGS ('dbx_business_glossary_term' = 'Stretch Volume Units');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `target_revenue_amount` SET TAGS ('dbx_business_glossary_term' = 'Target Revenue Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `target_revenue_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `target_volume_units` SET TAGS ('dbx_business_glossary_term' = 'Target Volume Units');
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ALTER COLUMN `vehicle_segment` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Segment');
ALTER TABLE `vibe_automotive_v1`.`sales`.`dealer_rep_assignment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`dealer_rep_assignment` SET TAGS ('dbx_subdomain' = 'territory_management');
ALTER TABLE `vibe_automotive_v1`.`sales`.`dealer_rep_assignment` SET TAGS ('dbx_association_edges' = 'sales.sales_rep,dealer.dealership');
ALTER TABLE `vibe_automotive_v1`.`sales`.`dealer_rep_assignment` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`dealer_rep_assignment` ALTER COLUMN `dealer_rep_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Dealerrepassignment - Dealer Rep Assignment Id');
ALTER TABLE `vibe_automotive_v1`.`sales`.`dealer_rep_assignment` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealerrepassignment - Dealership Id');
ALTER TABLE `vibe_automotive_v1`.`sales`.`dealer_rep_assignment` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Dealerrepassignment - Sales Rep Id');
ALTER TABLE `vibe_automotive_v1`.`sales`.`dealer_rep_assignment` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment End Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`dealer_rep_assignment` ALTER COLUMN `role` SET TAGS ('dbx_business_glossary_term' = 'Assignment Role');
ALTER TABLE `vibe_automotive_v1`.`sales`.`dealer_rep_assignment` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment Start Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` SET TAGS ('dbx_subdomain' = 'revenue_pursuit');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `sales_lead_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Assigned Owner Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Converted Opportunity Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Dealer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `rep_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Owner Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `sales_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Dealer Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `sales_rep_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Owner Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `city` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `company_name` SET TAGS ('dbx_business_glossary_term' = 'Company Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `converted_date` SET TAGS ('dbx_business_glossary_term' = 'Lead Converted Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Lead Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `email_address` SET TAGS ('dbx_business_glossary_term' = 'Lead Email Address');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `email_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `estimated_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Estimated Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `financing_interest` SET TAGS ('dbx_business_glossary_term' = 'Financing Interest Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `first_name` SET TAGS ('dbx_business_glossary_term' = 'Lead First Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `first_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `first_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `last_contact_date` SET TAGS ('dbx_business_glossary_term' = 'Last Contact Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `last_name` SET TAGS ('dbx_business_glossary_term' = 'Lead Last Name');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `last_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `last_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `lead_number` SET TAGS ('dbx_business_glossary_term' = 'Lead Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `lead_number` SET TAGS ('dbx_value_regex' = '^LEAD-[0-9]{8}$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `lead_source` SET TAGS ('dbx_business_glossary_term' = 'Lead Source');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `lead_source` SET TAGS ('dbx_value_regex' = 'web|dealer_walk_in|event|referral|digital_campaign|phone_inquiry');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `lead_status` SET TAGS ('dbx_business_glossary_term' = 'Lead Status');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `lead_status` SET TAGS ('dbx_value_regex' = 'new|contacted|qualified|unqualified|converted|lost');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `lead_type` SET TAGS ('dbx_business_glossary_term' = 'Lead Type');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `lead_type` SET TAGS ('dbx_value_regex' = 'individual|fleet|commercial|government');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `lost_reason` SET TAGS ('dbx_business_glossary_term' = 'Lost Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `mobile_number` SET TAGS ('dbx_business_glossary_term' = 'Lead Mobile Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `mobile_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `mobile_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `model_year_interest` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY) Interest');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `model_year_interest` SET TAGS ('dbx_value_regex' = '^(20[2-9][0-9]|MY[2-9][0-9])$');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Lead Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `next_follow_up_date` SET TAGS ('dbx_business_glossary_term' = 'Next Follow-Up Date');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Lead Notes');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `opt_in_email` SET TAGS ('dbx_business_glossary_term' = 'Email Opt-In Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `opt_in_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `opt_in_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `opt_in_phone` SET TAGS ('dbx_business_glossary_term' = 'Phone Opt-In Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `opt_in_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `opt_in_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `opt_in_sms` SET TAGS ('dbx_business_glossary_term' = 'SMS (Short Message Service) Opt-In Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Lead Phone Number');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `postal_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `purchase_timeframe` SET TAGS ('dbx_business_glossary_term' = 'Purchase Timeframe');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `purchase_timeframe` SET TAGS ('dbx_value_regex' = 'immediate|within_30_days|within_90_days|within_6_months|future');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `qualification_score` SET TAGS ('dbx_business_glossary_term' = 'Lead Qualification Score');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `rating` SET TAGS ('dbx_business_glossary_term' = 'Lead Rating');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `rating` SET TAGS ('dbx_value_regex' = 'hot|warm|cold');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `referral_source` SET TAGS ('dbx_business_glossary_term' = 'Referral Source');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Lead Region');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State or Province');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `state_province` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `street_address` SET TAGS ('dbx_business_glossary_term' = 'Street Address');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `street_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `street_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `test_drive_requested` SET TAGS ('dbx_business_glossary_term' = 'Test Drive Requested Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `trade_in_interest` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Interest Flag');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `unqualified_reason` SET TAGS ('dbx_business_glossary_term' = 'Unqualified Reason');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `vehicle_interest_category` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Interest Category');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `vehicle_interest_category` SET TAGS ('dbx_value_regex' = 'ICE|EV|HEV|PHEV');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `vehicle_model_interest` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Model Interest');
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ALTER COLUMN `web_form_code` SET TAGS ('dbx_business_glossary_term' = 'Web Form Identifier');
ALTER TABLE `vibe_automotive_v1`.`sales`.`finance_contract` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`finance_contract` SET TAGS ('dbx_subdomain' = 'financial_insurance');
ALTER TABLE `vibe_automotive_v1`.`sales`.`lease_contract` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`lease_contract` SET TAGS ('dbx_subdomain' = 'financial_insurance');
ALTER TABLE `vibe_automotive_v1`.`sales`.`insurance_policy` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`insurance_policy` SET TAGS ('dbx_subdomain' = 'financial_insurance');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fni_menu_product` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`fni_menu_product` SET TAGS ('dbx_subdomain' = 'financial_insurance');
ALTER TABLE `vibe_automotive_v1`.`sales`.`credit_application` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`credit_application` SET TAGS ('dbx_subdomain' = 'financial_insurance');
ALTER TABLE `vibe_automotive_v1`.`sales`.`residual_value_schedule` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`residual_value_schedule` SET TAGS ('dbx_subdomain' = 'financial_insurance');
ALTER TABLE `vibe_automotive_v1`.`sales`.`configurator_session` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`configurator_session` SET TAGS ('dbx_subdomain' = 'digital_commerce');
ALTER TABLE `vibe_automotive_v1`.`sales`.`online_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`online_order` SET TAGS ('dbx_subdomain' = 'digital_commerce');
ALTER TABLE `vibe_automotive_v1`.`sales`.`ecommerce_cart` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`ecommerce_cart` SET TAGS ('dbx_subdomain' = 'digital_commerce');
ALTER TABLE `vibe_automotive_v1`.`sales`.`digital_sales_lead` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`digital_sales_lead` SET TAGS ('dbx_subdomain' = 'digital_commerce');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_subscription` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_subscription` SET TAGS ('dbx_subdomain' = 'digital_commerce');
