-- Schema for Domain: dealer | Business:  | Version: v2_ecm
-- Generated on: 2026-07-14 02:32:20

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`dealer` COMMENT 'Dealer network management including dealer profiles, franchise agreements, territory assignments, and dealer performance scorecards. Manages dealer inventory allocation, vehicle allocation rules, dealer incentive programs, and DMS (Dealer Management System) integration. Tracks dealer sales performance, customer satisfaction scores, service capacity, and parts inventory at dealer locations. Supports both OEM-owned and independent franchise dealer models. Integrates with CDK Global DMS.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealership` (
    `dealership_id` BIGINT COMMENT 'Unique surrogate identifier for each dealer location in the OEM franchise network. Primary key for the dealership master record and the enterprise Single Source of Truth (SSOT) for dealer identity.',
    `account_id` BIGINT COMMENT 'Foreign key linking to billing.billing_account. Business justification: Required for finance: each dealership must be linked to its primary billing account for invoice generation and payment reconciliation, a standard practice in automotive dealer finance operations.',
    `company_code_id` BIGINT COMMENT 'Foreign key linking to finance.company_code. Business justification: Financial consolidation reports require each dealership to be assigned to a legal company code for statutory reporting; dealers know their company code.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Expense allocation and internal budgeting are performed per dealership via a dedicated cost center; required for cost‑center expense statements.',
    `payment_term_id` BIGINT COMMENT 'Foreign key linking to billing.payment_term. Business justification: Required for billing: dealership default payment terms are needed for all invoices, enabling consistent net‑due days and discount calculations per dealer.',
    `dealer_region_id` BIGINT COMMENT 'Foreign key linking to dealer.dealer_region. Business justification: Dealerships are assigned to a region; add dealer_region_id FK to link each dealership to its region.',
    `activation_date` DATE COMMENT 'Date on which the dealership was formally activated in the OEM dealer network and became eligible to receive vehicle allocations and participate in OEM programs.',
    `adas_certified` BOOLEAN COMMENT 'Indicates whether the dealership is certified to perform Advanced Driver Assistance Systems (ADAS) calibration and repair. Required for servicing vehicles equipped with cameras, radar, and LiDAR-based safety systems.',
    `address_line1` STRING COMMENT 'Primary street address of the dealership physical location. Used for logistics, customer navigation, regulatory filings, and Pre-Delivery Inspection (PDI) vehicle delivery coordination.',
    `address_line2` STRING COMMENT 'Secondary address line for the dealership (suite, unit, building number). Supplements address_line1 for precise location identification.',
    `cdk_dealer_code` STRING COMMENT 'Unique dealer identifier assigned within the CDK Global Dealer Management System (DMS). This is the integration key used for all data exchanges between the OEM lakehouse and the CDK DMS platform including inventory, F&I, and service scheduling feeds.. Valid values are `^[A-Z0-9]{4,20}$`',
    `channel_classification` STRING COMMENT 'Categorizes the dealers primary sales channel model. Retail covers traditional showroom sales; fleet covers B2B volume sales; agency model covers OEM-set pricing arrangements; export covers cross-border sales points.. Valid values are `retail|fleet|wholesale|online|agency|export`',
    `city` STRING COMMENT 'City in which the dealership is physically located. Used for geographic market analysis, territory assignment, and customer proximity reporting.',
    `country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code for the country in which the dealership is physically located (e.g., USA, CAN, MEX, GBR, DEU). Drives regulatory compliance, currency, and tax treatment.. Valid values are `^[A-Z]{3}$`',
    `deactivation_date` DATE COMMENT 'Date on which the dealership was deactivated or terminated from the OEM dealer network. Nullable for currently active dealers. Used for franchise termination tracking and regulatory reporting.',
    `dealer_code` STRING COMMENT 'Externally-known alphanumeric code assigned by the OEM to uniquely identify the dealer location across all enterprise systems including SAP SD, CDK Global DMS, and Salesforce Automotive Cloud. Used on all inter-system communications, vehicle allocations, and incentive programs.. Valid values are `^[A-Z0-9]{4,12}$`',
    `dealer_status` STRING COMMENT 'Current lifecycle status of the dealership within the OEM franchise network. Controls eligibility for vehicle allocation, incentive programs, and DMS integration. [ENUM-REF-CANDIDATE: active|inactive|suspended|pending_approval|terminated|under_review — promote to reference product]. Valid values are `active|inactive|suspended|pending_approval|terminated|under_review`',
    `dealer_tier` STRING COMMENT 'OEM-assigned performance tier classification for the dealership based on annual sales volume, customer satisfaction scores, and compliance metrics. Determines eligibility for premium vehicle allocations, co-op marketing funds, and incentive program tiers.. Valid values are `platinum|gold|silver|bronze|standard`',
    `dms_go_live_date` DATE COMMENT 'Date on which the CDK Global DMS integration for this dealership went live and began transmitting data to the OEM enterprise systems. Used for integration tenure tracking and data completeness assessments.',
    `dms_integration_status` STRING COMMENT 'Current status of the CDK Global DMS data integration feed for this dealership. Indicates whether real-time inventory, sales, and service data is flowing correctly into the OEM lakehouse.. Valid values are `active|inactive|pending_setup|error|suspended`',
    `ev_certified` BOOLEAN COMMENT 'Indicates whether the dealership has completed OEM Electric Vehicle (EV) certification requirements including technician training, charging infrastructure installation, and EV-specific tooling. Required for allocation of BEV and PHEV models.',
    `ev_charger_count` STRING COMMENT 'Number of EV charging stations installed at the dealership for customer and demo vehicle use. Relevant for EV certification compliance and customer experience reporting.',
    `franchise_agreement_number` STRING COMMENT 'Reference number of the active franchise agreement between the OEM and the dealer entity. Used to link the dealership master record to the franchise agreement contract for legal and compliance purposes.',
    `franchise_expiry_date` DATE COMMENT 'Date on which the current franchise agreement is scheduled to expire or must be renewed. Nullable for perpetual agreements. Triggers renewal workflow when within the notice period.',
    `franchise_start_date` DATE COMMENT 'Date on which the current franchise agreement between the OEM and the dealer became effective. Used for tenure calculations, renewal scheduling, and performance baseline setting.',
    `franchise_type` STRING COMMENT 'Classification of the dealers franchise arrangement with the OEM. Distinguishes OEM-owned (captive) outlets from independent franchise dealers, authorized repairers, fleet-only points, used vehicle specialists, and satellite locations. [ENUM-REF-CANDIDATE: oem_owned|independent_franchise|authorized_repairer|fleet_only|used_vehicle_only|satellite — promote to reference product]. Valid values are `oem_owned|independent_franchise|authorized_repairer|fleet_only|used_vehicle_only|satellite`',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate (WGS 84 decimal degrees) of the dealership location. Enables spatial analytics, territory mapping, and customer proximity calculations for dealer locator services.',
    `legal_name` STRING COMMENT 'Full registered legal name of the dealer entity as recorded with the relevant state or national business registry. Used for franchise agreements, regulatory filings, and financial settlements.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate (WGS 84 decimal degrees) of the dealership location. Enables spatial analytics, territory mapping, and customer proximity calculations for dealer locator services.',
    `lot_capacity` STRING COMMENT 'Maximum number of vehicles that can be stored on the dealer lot (outdoor inventory storage). Used for vehicle allocation limits, inventory aging analysis, and logistics planning.',
    `market_region_code` STRING COMMENT 'OEM-defined market region code to which this dealership belongs (e.g., NORTHEAST, MIDWEST, SOUTHWEST, WEST, SOUTHEAST). Used for territory management, regional incentive programs, and sales performance reporting.. Valid values are `^[A-Z]{2,10}$`',
    `new_vehicle_sales_capacity` STRING COMMENT 'OEM-assessed annual new vehicle sales capacity (unit count) for this dealership based on facility size, staffing, and market area. Used as the denominator for allocation planning and sales target setting.',
    `oem_brand_codes` STRING COMMENT 'Pipe-delimited list of OEM brand codes (e.g., BRAND_A|BRAND_B) that this dealership is franchised to sell and service. A single dealer point may hold multi-brand authorizations (e.g., passenger car and commercial vehicle brands).',
    `ownership_group_name` STRING COMMENT 'Name of the dealer group or automotive retail group that owns this dealership location (e.g., AutoNation, Penske, Lithia). Enables group-level performance aggregation, consolidated incentive calculations, and multi-point dealer management.',
    `parts_warehouse_area_sqm` DECIMAL(18,2) COMMENT 'Total floor area in square metres of the dealerships parts storage facility. Used for parts inventory capacity planning, MRP replenishment calculations, and Just-in-Time (JIT) parts delivery scheduling.',
    `pdi_certified` BOOLEAN COMMENT 'Indicates whether the dealership is certified to perform Pre-Delivery Inspection (PDI) on new vehicles prior to customer handover. PDI certification is required for new vehicle delivery authorization.',
    `postal_code` STRING COMMENT 'Postal or ZIP code of the dealerships physical location. Used for geographic market segmentation, territory boundary analysis, and customer catchment area reporting.. Valid values are `^[A-Z0-9 -]{3,10}$`',
    `primary_email` STRING COMMENT 'Primary business email address for the dealership used for OEM communications, vehicle allocation notifications, incentive program updates, and Technical Service Bulletin (TSB) distribution.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `primary_phone` STRING COMMENT 'Main switchboard or primary contact telephone number for the dealership. Used for OEM-to-dealer communications, customer service escalations, and directory listings.. Valid values are `^+?[0-9s-().]{7,20}$`',
    `principal_contact_email` STRING COMMENT 'Email address of the primary OEM relationship contact at the dealership. Used for franchise communications, incentive program notifications, and regulatory bulletin distribution.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `principal_contact_name` STRING COMMENT 'Full name of the primary OEM relationship contact at the dealership (typically the Dealer Principal or General Manager). Used for OEM communications, franchise agreement correspondence, and escalation routing.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the dealership master record was first created in the enterprise data platform. Follows ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). Used for data lineage, audit trail, and record age analysis.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the dealership master record in the enterprise data platform. Follows ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). Used for change detection, data freshness monitoring, and audit compliance.',
    `sales_district_code` STRING COMMENT 'OEM-defined sales district code representing the sub-regional territory assignment for this dealership. Used for district sales manager (DSM) alignment, vehicle allocation quotas, and performance benchmarking.. Valid values are `^[A-Z0-9]{2,10}$`',
    `sap_customer_number` STRING COMMENT 'SAP S/4HANA customer master number (SD module) assigned to this dealership for vehicle order processing, invoicing, and financial settlement. Links dealership to SAP SD sales orders and FI accounts receivable.. Valid values are `^[0-9]{6,10}$`',
    `service_bay_count` STRING COMMENT 'Total number of service bays available at the dealership for vehicle maintenance and repair operations. Used for after-sales capacity planning, warranty repair throughput analysis, and service scheduling optimization.',
    `showroom_display_capacity` STRING COMMENT 'Maximum number of vehicles that can be displayed simultaneously in the dealership showroom. Used for vehicle allocation planning, demo fleet sizing, and facility investment decisions.',
    `state_province_code` STRING COMMENT 'ISO 3166-2 state or province code for the dealerships physical location (e.g., CA, TX, NY, ON). Used for CAFE compliance reporting, CARB emissions zone classification, and state-level dealer franchise law compliance.. Valid values are `^[A-Z]{2,5}$`',
    `trading_name` STRING COMMENT 'The public-facing doing business as (DBA) name of the dealership as displayed to customers, on signage, and in marketing materials. May differ from the legal entity name.',
    `used_vehicle_sales_capacity` STRING COMMENT 'OEM-assessed annual used vehicle sales capacity (unit count) for this dealership. Used for certified pre-owned (CPO) program eligibility and used vehicle allocation planning.',
    `warranty_authorized` BOOLEAN COMMENT 'Indicates whether the dealership is authorized to perform OEM warranty repairs and submit warranty claims. Drives warranty claim processing eligibility in SAP and CDK DMS.',
    `website_url` STRING COMMENT 'Public-facing website URL for the dealership. Used for digital marketing integration, online inventory syndication, and customer-facing dealer locator services.. Valid values are `^https?://[^s]{3,255}$`',
    CONSTRAINT pk_dealership PRIMARY KEY(`dealership_id`)
) COMMENT 'Master record for each dealer location in the OEM franchise network. Captures dealer legal entity, DMS (Dealer Management System) integration identifiers (CDK Global), franchise type (OEM-owned vs independent), physical address, contact details, operational status, market region, and channel classification. This is the SSOT for dealer identity across the enterprise.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` (
    `franchise_agreement_id` BIGINT COMMENT 'Unique identifier for the franchise agreement record. Primary key.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealer entity that is party to this franchise agreement.',
    `franchise_dealership_id` BIGINT COMMENT 'Reference to the dealer entity that is party to this franchise agreement.',
    `agreement_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all financial terms in the franchise agreement (quotas, fees, investment requirements). Example: USD, EUR, JPY.. Valid values are `^[A-Z]{3}$`',
    `agreement_document_url` STRING COMMENT 'Secure URL or file path to the digitally stored franchise agreement contract document (PDF or scanned image).',
    `agreement_name` STRING COMMENT 'Human-readable name or title of the franchise agreement, typically including dealer name and location.',
    `agreement_number` STRING COMMENT 'Externally-known unique business identifier for the franchise agreement. Format: FA-NNNNNNNN.. Valid values are `^FA-[0-9]{8}$`',
    `agreement_status` STRING COMMENT 'Current lifecycle status of the franchise agreement: draft (being negotiated), pending approval (awaiting OEM sign-off), active (in force), suspended (temporarily inactive), terminated (ended before expiration), or expired (reached end date).. Valid values are `draft|pending_approval|active|suspended|terminated|expired`',
    `agreement_type` STRING COMMENT 'Classification of the franchise agreement based on its purpose: new franchise grant, renewal of existing agreement, amendment to terms, territory expansion, or termination agreement.. Valid values are `new_franchise|renewal|amendment|expansion|termination`',
    `allocation_priority_tier` STRING COMMENT 'Priority tier for vehicle inventory allocation. Higher tiers receive preferential allocation of high-demand models and limited-production vehicles. Tier 1 = highest priority.. Valid values are `tier_1|tier_2|tier_3|tier_4|standard`',
    `authorized_nameplates` STRING COMMENT 'Comma-separated list of vehicle nameplates (brands, model lines) that the dealer is authorized to sell under this franchise agreement. Examples: Sedan, SUV, Truck, EV (Electric Vehicle), HEV (Hybrid Electric Vehicle).',
    `authorized_vehicle_lines` STRING COMMENT 'Specific vehicle lines or series the dealer is authorized to sell, such as luxury, commercial, electric, or performance segments.',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the franchise agreement automatically renews at expiration unless either party provides notice. True = auto-renews, False = requires explicit renewal.',
    `certified_pre_owned_authorized_flag` BOOLEAN COMMENT 'Indicates whether the dealer is authorized to sell OEM-certified pre-owned vehicles under the manufacturers CPO program. True = authorized, False = not authorized.',
    `commercial_fleet_authorized_flag` BOOLEAN COMMENT 'Indicates whether the dealer is authorized to sell vehicles to commercial fleet customers and participate in fleet sales programs. True = authorized, False = not authorized.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this franchise agreement record was first created in the system. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `customer_satisfaction_target_score` DECIMAL(18,2) COMMENT 'Minimum Net Promoter Score (NPS) or customer satisfaction score the dealer must achieve to maintain franchise agreement in good standing. Typically measured on a scale of 0-100.',
    `dealer_signatory_name` STRING COMMENT 'Full name of the dealer authorized representative (typically dealer principal or owner) who signed the franchise agreement.',
    `digital_retailing_required_flag` BOOLEAN COMMENT 'Indicates whether the dealer must offer digital retailing capabilities (online sales, virtual showroom, e-commerce) as required by the franchise agreement. True = required, False = optional.',
    `dms_integration_required_flag` BOOLEAN COMMENT 'Indicates whether the dealer must integrate their DMS (Dealer Management System) with OEM systems for real-time inventory, sales, and service data sharing. True = required, False = optional.',
    `effective_date` DATE COMMENT 'Date when the franchise agreement becomes legally binding and operational. Marks the start of the dealers franchise rights and obligations.',
    `ev_charging_infrastructure_required_flag` BOOLEAN COMMENT 'Indicates whether the dealer must install and maintain EV (Electric Vehicle) charging infrastructure at their facility as a condition of selling electric or hybrid vehicles. True = required, False = optional.',
    `exclusive_territory_flag` BOOLEAN COMMENT 'Indicates whether the dealer has exclusive rights to sell in the assigned territory. True = exclusive (no other dealers in territory), False = non-exclusive (shared territory).',
    `expiration_date` DATE COMMENT 'Date when the franchise agreement is scheduled to end. Nullable for open-ended or perpetual agreements subject to performance review.',
    `facility_investment_requirement_amount` DECIMAL(18,2) COMMENT 'Minimum capital expenditure (CapEx) the dealer must invest in facility improvements, showroom standards, service equipment, and infrastructure to meet OEM brand standards.',
    `franchise_tier` STRING COMMENT 'Tier or level of the franchise agreement indicating dealer status, privileges, and performance expectations. Higher tiers typically receive preferential allocation and incentives.. Valid values are `platinum|gold|silver|bronze|standard`',
    `governing_law_jurisdiction` STRING COMMENT 'Legal jurisdiction and governing law that applies to the franchise agreement, typically the state or country where the dealer operates or where the OEM is headquartered.',
    `incentive_program_eligibility_flag` BOOLEAN COMMENT 'Indicates whether the dealer is eligible to participate in OEM dealer incentive programs, volume bonuses, and performance rewards. True = eligible, False = not eligible.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this franchise agreement record was last updated in the system. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `minimum_sales_quota_annual` STRING COMMENT 'Minimum number of vehicle units the dealer must sell annually to maintain franchise agreement in good standing. Performance obligation defined in agreement.',
    `minimum_service_capacity` STRING COMMENT 'Minimum number of vehicles the dealer must be capable of servicing per month to meet franchise agreement service obligations.',
    `notice_period_days` STRING COMMENT 'Number of days advance notice required by either party to terminate or not renew the franchise agreement. Typical values are 30, 60, 90, or 180 days.',
    `oem_signatory_name` STRING COMMENT 'Full name of the OEM authorized representative who signed the franchise agreement on behalf of the manufacturer.',
    `ownership_model` STRING COMMENT 'Classification of dealer ownership structure: OEM (Original Equipment Manufacturer) owned, independent franchise, joint venture, or corporate store.. Valid values are `oem_owned|independent_franchise|joint_venture|corporate_store`',
    `parts_inventory_requirement_amount` DECIMAL(18,2) COMMENT 'Minimum dollar value of OEM (Original Equipment Manufacturer) parts inventory the dealer must maintain at all times to meet franchise agreement obligations.',
    `performance_review_frequency` STRING COMMENT 'Frequency at which the OEM conducts formal performance reviews of the dealer against franchise agreement obligations and performance metrics.. Valid values are `monthly|quarterly|semi_annual|annual`',
    `recall_service_authorized_flag` BOOLEAN COMMENT 'Indicates whether the dealer is authorized to perform recall repairs and service campaigns issued by the OEM or NHTSA (National Highway Traffic Safety Administration). True = authorized, False = not authorized.',
    `renewal_date` DATE COMMENT 'Date when the franchise agreement was last renewed or is scheduled for renewal review. Used for tracking renewal cycles.',
    `renewal_term_months` STRING COMMENT 'Duration in months for each renewal period of the franchise agreement. Typical values are 12, 24, 36, or 60 months.',
    `signed_date` DATE COMMENT 'Date when the franchise agreement was formally signed by both the dealer and OEM authorized representatives, making it legally binding.',
    `termination_date` DATE COMMENT 'Actual date when the franchise agreement was terminated, if applicable. Populated only for agreements that ended before their scheduled expiration.',
    `termination_reason` STRING COMMENT 'Detailed explanation of why the franchise agreement was terminated early, including performance issues, dealer request, market consolidation, or regulatory compliance.',
    `territory_description` STRING COMMENT 'Textual description of the geographic territory assigned to the dealer under this franchise agreement, including cities, counties, postal codes, or radius from dealer location.',
    `territory_radius_km` DECIMAL(18,2) COMMENT 'Radius in kilometers from the dealers primary location defining the franchise territory boundary, if territory is defined by radius rather than geographic boundaries.',
    `training_certification_required_flag` BOOLEAN COMMENT 'Indicates whether dealer staff must complete OEM-mandated training and certification programs as a condition of the franchise agreement. True = required, False = optional.',
    `warranty_administration_authorized_flag` BOOLEAN COMMENT 'Indicates whether the dealer is authorized to process and submit warranty claims on behalf of customers under OEM warranty programs. True = authorized, False = not authorized.',
    CONSTRAINT pk_franchise_agreement PRIMARY KEY(`franchise_agreement_id`)
) COMMENT 'Formal franchise contract between the OEM and an independent or OEM-owned dealer. Tracks agreement effective dates, expiration, renewal terms, franchise tier, authorized vehicle lines (nameplates), territory rights, performance obligations, and agreement status. Supports both new franchise grants and renewals.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` (
    `dealer_territory_id` BIGINT COMMENT 'Unique identifier for the dealer territory assignment. Primary key.',
    `franchise_agreement_id` BIGINT COMMENT 'Reference to the franchise agreement that governs this territory assignment. Links territory rights to contractual terms.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Territory planning aligns with the legal jurisdiction for emissions and safety regulations; linking enables jurisdiction‑specific reporting.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Territory manager assignment needed for territory performance reporting and incentive eligibility.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership that owns or is assigned this territory.',
    `sales_territory_id` BIGINT COMMENT 'SSOT reference to sales.sales_territory (cross-domain duplicate reconciliation; sales designated SSOT owner for territory).',
    `allocation_quota_percentage` DECIMAL(18,2) COMMENT 'Percentage of regional or national vehicle allocation assigned to this territory. Sum of all territory percentages within a region should equal 100.',
    `approval_date` DATE COMMENT 'Date when the territory assignment or modification was formally approved by OEM (Original Equipment Manufacturer) management.',
    `approved_by` STRING COMMENT 'Name or identifier of the OEM (Original Equipment Manufacturer) executive or manager who approved this territory assignment or modification.',
    `city_list` STRING COMMENT 'Comma-separated list of cities or municipalities included in the territory coverage area.',
    `competitive_intensity_rating` STRING COMMENT 'Assessment of competitive pressure within the territory based on number of competing brands, dealer density, and market saturation.. Valid values are `low|medium|high|very_high`',
    `country_code` STRING COMMENT 'Three-letter ISO country code for the territory location (e.g., USA, CAN, MEX).. Valid values are `^[A-Z]{3}$`',
    `county_region` STRING COMMENT 'County, district, or regional subdivision name within the state/province that defines part of the territory boundary.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this territory assignment record was first created in the system. Audit trail for data lineage.',
    `dms_integration_status` STRING COMMENT 'Status of territory data synchronization with the dealers DMS (Dealer Management System), specifically CDK Global DMS. Indicates whether territory boundaries are reflected in dealer systems.. Valid values are `integrated|pending|failed|not_applicable`',
    `dms_last_sync_timestamp` TIMESTAMP COMMENT 'Timestamp of the last successful synchronization of territory data with the dealers DMS (Dealer Management System). Used to monitor data freshness and integration health.',
    `effective_end_date` DATE COMMENT 'Date when the territory assignment expires or is terminated. Null indicates an open-ended assignment.',
    `effective_start_date` DATE COMMENT 'Date when the territory assignment becomes active and the dealer assumes responsibility for the defined area.',
    `geographic_boundary_description` STRING COMMENT 'Textual description of territory boundaries using landmarks, highways, or natural features (e.g., North of I-40, East of Highway 101).',
    `household_count_estimate` STRING COMMENT 'Estimated number of households within the territory. Used for market penetration analysis and vehicle allocation planning.',
    `incentive_program_eligibility_flag` BOOLEAN COMMENT 'Indicates whether dealers in this territory are eligible for special OEM (Original Equipment Manufacturer) incentive programs or bonuses. True = eligible; False = not eligible.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this territory assignment record was last updated. Tracks the most recent change to any field in the record.',
    `last_review_date` DATE COMMENT 'Date when the territory assignment was last reviewed or audited by OEM (Original Equipment Manufacturer) management. Used to track compliance with periodic review requirements.',
    `manager_email` STRING COMMENT 'Email address of the OEM (Original Equipment Manufacturer) territory manager. Used for dealer communications and escalations.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `manager_name` STRING COMMENT 'Name of the OEM (Original Equipment Manufacturer) regional or territory manager responsible for overseeing this territory and dealer relationship.',
    `manager_phone` STRING COMMENT 'Contact phone number for the OEM (Original Equipment Manufacturer) territory manager.',
    `market_segment_classification` STRING COMMENT 'Classification of the territory market type based on population density and urbanization level. Influences vehicle mix allocation and marketing strategies.. Valid values are `urban|suburban|rural|metro|mixed`',
    `modification_reason` STRING COMMENT 'Business justification for the most recent change to the territory assignment (e.g., market expansion, dealer consolidation, performance adjustment).',
    `next_review_date` DATE COMMENT 'Scheduled date for the next territory assignment review. Ensures regular evaluation of territory boundaries and dealer performance.',
    `overlap_allowed_flag` BOOLEAN COMMENT 'Indicates whether this territory can overlap with other dealer territories. True allows shared coverage; False enforces exclusive boundaries.',
    `overlap_rule_description` STRING COMMENT 'Business rules governing how overlapping territories are managed, including priority rules, customer assignment logic, and conflict resolution procedures.',
    `performance_benchmark_group` STRING COMMENT 'Peer group or cohort used for dealer performance benchmarking. Territories with similar characteristics are grouped for fair comparison.',
    `population_estimate` STRING COMMENT 'Estimated total population within the territory boundaries. Used for market sizing and dealer performance benchmarking.',
    `postal_code_list` STRING COMMENT 'Comma-separated or range-based list of postal/zip codes included in the territory (e.g., 90001-90099,91000). Used for precise geographic allocation.',
    `primary_area_of_responsibility` STRING COMMENT 'Geographic description of the core territory where the dealer has primary sales and service responsibility. May include city names, county boundaries, or regional descriptors.',
    `sales_potential_index` DECIMAL(18,2) COMMENT 'Numeric index representing the relative sales potential of the territory compared to a baseline (e.g., 100 = average, 150 = 50% above average). Used for vehicle allocation and quota setting.',
    `special_program_notes` STRING COMMENT 'Free-text notes describing any special programs, pilot initiatives, or unique conditions applicable to this territory (e.g., EV (Electric Vehicle) launch market, rural incentive zone).',
    `state_province_code` STRING COMMENT 'Two or three-letter code for the state, province, or administrative region (e.g., CA, TX, ON).. Valid values are `^[A-Z]{2,3}$`',
    `territory_code` STRING COMMENT 'Unique alphanumeric code identifying the territory within the dealer network. Used for vehicle allocation and market planning.. Valid values are `^[A-Z0-9]{3,12}$`',
    `territory_name` STRING COMMENT 'Business-friendly name or description of the territory (e.g., Metro East Region, Downtown District).',
    `territory_status` STRING COMMENT 'Current lifecycle status of the territory assignment. Active territories are operational; pending awaits approval; suspended is temporarily halted; terminated is closed.. Valid values are `active|inactive|pending|suspended|under_review|terminated`',
    `territory_type` STRING COMMENT 'Classification of territory assignment model: exclusive (single dealer), shared (multiple dealers), open (no restrictions), primary (main responsibility), secondary (backup coverage), overlay (special program).. Valid values are `exclusive|shared|open|primary|secondary|overlay`',
    `vehicle_allocation_priority` STRING COMMENT 'Priority ranking for vehicle inventory allocation to this territory. Lower numbers indicate higher priority. Used during supply constraints.',
    CONSTRAINT pk_dealer_territory PRIMARY KEY(`dealer_territory_id`)
) COMMENT 'Geographic sales territory assigned to a dealership. Defines primary area of responsibility (PAR), zip/postal code coverage, county or region boundaries, territory type (exclusive, shared, open), effective dates, and overlap rules. Used for vehicle allocation, market representation planning, and dealer performance benchmarking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` (
    `dealer_certification_id` BIGINT COMMENT 'Unique identifier for the dealer certification record. Primary key.',
    `compliance_emissions_certification_id` BIGINT COMMENT 'SSOT reference to compliance.compliance_emissions_certification (cross-domain duplicate reconciliation; compliance designated SSOT owner for certification).',
    `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_obligation. Business justification: Regulatory compliance requires each dealer certification to be linked to the specific compliance obligation it satisfies, enabling audit of certification against obligations.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership that holds this certification. Links to the dealer master record.',
    `allocation_eligibility_flag` BOOLEAN COMMENT 'Indicates whether this certification makes the dealer eligible for preferential vehicle allocation (e.g., EV-certified dealers receive priority allocation of electric vehicles).',
    `annual_maintenance_cost_amount` DECIMAL(18,2) COMMENT 'Estimated annual cost to maintain this certification, including renewal fees, ongoing training, and audit costs. Expressed in the OEMs reporting currency.',
    `audit_outcome` STRING COMMENT 'Result of the most recent audit (e.g., passed, passed with conditions, failed). Determines whether certification remains in good standing.. Valid values are `PASSED|PASSED_WITH_CONDITIONS|FAILED|NOT_APPLICABLE`',
    `audit_required_flag` BOOLEAN COMMENT 'Indicates whether the dealer must undergo periodic audits to maintain this certification.',
    `audit_score` DECIMAL(18,2) COMMENT 'Numerical score or rating achieved in the most recent audit (e.g., 0-100 scale, or percentage). Reflects compliance quality and performance.',
    `authorized_vehicle_lines` STRING COMMENT 'Comma-separated list of vehicle model lines or platforms the dealer is authorized to sell or service under this certification (e.g., Model S, Model X, Model 3 for EV certification).',
    `certification_level` STRING COMMENT 'Tier or grade of certification achieved by the dealer within a tiered program (e.g., Bronze, Silver, Gold, Platinum). Higher levels may unlock additional benefits.. Valid values are `BRONZE|SILVER|GOLD|PLATINUM|ELITE|STANDARD`',
    `certification_name` STRING COMMENT 'Full descriptive name of the certification program or credential (e.g., Electric Vehicle Sales and Service Certification, Advanced Driver Assistance Systems Authorized Service Center).',
    `certification_number` STRING COMMENT 'Unique alphanumeric identifier assigned by the issuing body for this certification. Externally-known business identifier.. Valid values are `^[A-Z0-9]{8,20}$`',
    `certification_status` STRING COMMENT 'Current lifecycle status of the certification. Determines whether the dealer is currently authorized under this certification program.. Valid values are `ACTIVE|EXPIRED|SUSPENDED|PENDING_RENEWAL|REVOKED|UNDER_REVIEW`',
    `certification_type` STRING COMMENT 'Category of certification awarded to the dealer. Defines the specialized capability or program enrollment (e.g., EV-certified dealer, ADAS service authorization, luxury brand certification).. Valid values are `EV_CERTIFIED|ADAS_SERVICE|LUXURY_BRAND|COMMERCIAL_VEHICLE|HYBRID_SPECIALIST|PERFORMANCE_TUNING`',
    `compliance_standard` STRING COMMENT 'Name of the industry standard or regulatory framework this certification demonstrates compliance with (e.g., IATF 16949, ISO 9001, EPA emissions standards, NHTSA safety standards).',
    `cost_amount` DECIMAL(18,2) COMMENT 'Total cost incurred by the dealer to obtain this certification, including training, equipment, facility upgrades, and application fees. Expressed in the OEMs reporting currency.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this certification record was first created in the system. Audit trail for data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this record (e.g., USD, EUR, JPY).. Valid values are `^[A-Z]{3}$`',
    `effective_date` DATE COMMENT 'Date from which the certification becomes active and the dealer is authorized to operate under this certification. May differ from issue date if there is a grace period.',
    `equipment_requirements` STRING COMMENT 'Description of specialized tools, diagnostic equipment, or technology the dealer must possess for this certification (e.g., high-voltage battery diagnostic tools, ADAS radar calibration systems).',
    `expiry_date` DATE COMMENT 'Date when the certification expires and the dealer must renew to maintain authorization. Nullable for certifications with no expiration.',
    `facility_requirements` STRING COMMENT 'Description of physical facility requirements the dealer must meet for this certification (e.g., dedicated EV charging bays, ADAS calibration equipment, climate-controlled service area).',
    `geographic_scope` STRING COMMENT 'Geographic coverage level of this certification (e.g., global, regional, national, state/provincial, local). Defines where the certification is recognized.. Valid values are `GLOBAL|REGIONAL|NATIONAL|STATE_PROVINCIAL|LOCAL`',
    `incentive_eligibility_flag` BOOLEAN COMMENT 'Indicates whether this certification qualifies the dealer for special incentive programs, rebates, or performance bonuses.',
    `issue_date` DATE COMMENT 'Date when the certification was originally issued to the dealer. Marks the start of the certification validity period.',
    `issuing_body` STRING COMMENT 'Name of the organization or authority that issued the certification (e.g., OEM corporate, IATF, SAE International, regional OEM division).',
    `issuing_body_type` STRING COMMENT 'Classification of the entity that issued the certification (e.g., OEM corporate, industry association, regulatory body, third-party auditor).. Valid values are `OEM_CORPORATE|INDUSTRY_ASSOCIATION|REGULATORY_BODY|THIRD_PARTY_AUDITOR|REGIONAL_OEM`',
    `last_audit_date` DATE COMMENT 'Date of the most recent audit conducted for this certification. Used to track audit compliance and schedule next audit.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this certification record was most recently updated. Audit trail for data lineage and change tracking.',
    `last_renewal_date` DATE COMMENT 'Date of the most recent renewal or recertification event. Tracks ongoing compliance and re-qualification.',
    `minimum_certified_technicians` STRING COMMENT 'Minimum number of technicians who must hold individual certification credentials for the dealer to maintain this certification.',
    `next_audit_due_date` DATE COMMENT 'Date by which the next audit must be completed to maintain certification compliance.',
    `next_renewal_due_date` DATE COMMENT 'Date by which the dealer must complete renewal requirements to maintain active certification status. Used for proactive renewal management.',
    `notes` STRING COMMENT 'Free-text field for additional comments, special conditions, or contextual information about this certification record.',
    `personnel_requirements` STRING COMMENT 'Description of staffing requirements for this certification (e.g., minimum number of certified technicians, specific role qualifications, training credentials).',
    `reinstatement_date` DATE COMMENT 'Date when a previously suspended certification was reinstated to active status. Nullable if never suspended or not yet reinstated.',
    `renewal_frequency_months` STRING COMMENT 'Number of months between required renewal cycles for this certification (e.g., 12 for annual, 24 for biennial, 36 for triennial).',
    `revocation_date` DATE COMMENT 'Date when the certification was permanently revoked. Nullable if never revoked.',
    `revocation_reason` STRING COMMENT 'Explanation of why the certification was permanently revoked, if applicable (e.g., serious compliance violations, fraudulent activity, repeated failures). Nullable if never revoked.',
    `suspension_date` DATE COMMENT 'Date when the certification was suspended. Nullable if never suspended.',
    `suspension_reason` STRING COMMENT 'Explanation of why the certification was suspended, if applicable (e.g., failed audit, non-compliance with training requirements, facility deficiencies). Nullable if never suspended.',
    `training_completion_date` DATE COMMENT 'Date when the dealer completed the required training program for this certification. Nullable if training is not required or not yet completed.',
    `training_required_flag` BOOLEAN COMMENT 'Indicates whether dealer personnel must complete specific training programs to obtain or maintain this certification.',
    CONSTRAINT pk_dealer_certification PRIMARY KEY(`dealer_certification_id`)
) COMMENT 'Tracks OEM-issued certifications and program enrollments for a dealership, such as EV-certified dealer, ADAS service authorization, luxury brand certification, and IATF 16949 compliance status. Includes certification type, issuing body, issue date, expiry date, renewal requirements, and current status. Drives eligibility for vehicle allocation and incentive programs.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` (
    `vehicle_allocation_id` BIGINT COMMENT 'Unique surrogate identifier for each vehicle allocation record linking a specific vehicle unit or allocation batch from OEM manufacturing output to a dealership inventory pipeline.',
    `production_order_id` BIGINT COMMENT 'Reference to the manufacturing production order that produced the allocated vehicle units. Links manufacturing output to dealer allocation pipeline.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Allocation planning reports require linking each allocated vehicle to its SKU for capacity, cost, and compliance tracking.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership receiving this vehicle allocation. Links to the dealer master record in the dealer network.',
    `vehicle_dealership_id` BIGINT COMMENT 'Reference to the dealership receiving this vehicle allocation. Links to the dealer master record in the dealer network.',
    `acceptance_deadline` DATE COMMENT 'Date by which the dealer must formally accept or reject this allocation. Failure to respond by this date may result in automatic acceptance or reallocation per OEM dealer agreement terms.',
    `acceptance_timestamp` TIMESTAMP COMMENT 'Exact timestamp when the dealer formally accepted this vehicle allocation via the dealer portal or DMS integration. Provides precise audit trail for dealer commitment.',
    `accepted_quantity` STRING COMMENT 'Number of vehicle units formally accepted by the dealer from this allocation. May be less than allocated_quantity if the dealer partially accepts or rejects units.',
    `actual_delivery_date` DATE COMMENT 'Actual date the allocated vehicle(s) were physically delivered to and received by the dealership. Used for On-Time Delivery (OTD) performance measurement and dealer satisfaction tracking.',
    `allocation_batch_number` STRING COMMENT 'Identifier grouping multiple allocation records issued in the same OEM allocation run or production release cycle. Enables batch-level tracking, reporting, and dealer communication.',
    `allocation_date` DATE COMMENT 'The business event date on which the OEM formally allocated the vehicle unit(s) to the dealership. Represents the principal real-world event time for this transaction.',
    `allocation_number` STRING COMMENT 'Externally-known business identifier for this allocation transaction, used in dealer communications, DMS integration, and OEM-dealer correspondence. Format: ALLOC-{MY}-{sequence}.. Valid values are `^ALLOC-[0-9]{4}-[0-9]{6}$`',
    `allocation_rule_code` STRING COMMENT 'Code identifying the specific allocation rule or algorithm applied to determine this dealers vehicle entitlement (e.g., turn-and-earn, market share, historical sales, regional quota). Drives transparency and auditability of allocation decisions.',
    `allocation_status` STRING COMMENT 'Current lifecycle state of the vehicle allocation record. Tracks progression from OEM-initiated pending through dealer acceptance or rejection to final delivery confirmation.. Valid values are `pending|confirmed|accepted|rejected|cancelled|delivered`',
    `allocation_type` STRING COMMENT 'Classification of the allocation purpose: standard retail inventory, priority customer order fulfillment, constrained supply allocation, fleet customer, dealer demonstrator vehicle, or loaner vehicle program.. Valid values are `standard|priority|constrained|fleet|demo|loaner`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this allocation record was first captured in the system. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts in this allocation record (MSRP, dealer invoice price, incentive amounts). Supports multi-currency dealer networks in international markets.. Valid values are `^[A-Z]{3}$`',
    `dealer_invoice_price` DECIMAL(18,2) COMMENT 'The price at which the OEM invoices the dealer for the allocated vehicle, net of holdback and before dealer incentives. Represents the dealers cost basis for inventory financing and margin calculation.',
    `dms_reference_number` STRING COMMENT 'The corresponding allocation or stock order reference number in the dealers CDK Global Dealer Management System (DMS). Enables end-to-end reconciliation between OEM allocation records and dealer inventory systems.',
    `estimated_delivery_date` DATE COMMENT 'Estimated date the allocated vehicle(s) are expected to arrive at the dealership. Calculated based on production schedule, transport lead time, and PDI processing time. Communicated to dealers for inventory planning.',
    `hold_code` STRING COMMENT 'Code indicating any active hold placed on the allocated vehicle(s) preventing retail sale (e.g., safety recall hold, quality hold, regulatory compliance hold, stop-sale order). Null when no hold is active. [ENUM-REF-CANDIDATE: safety_recall|quality_hold|regulatory|stop_sale|tsb_hold|other — promote to reference product]',
    `incentive_amount` DECIMAL(18,2) COMMENT 'Monetary value of the dealer incentive or bonus applicable to this specific allocation record. Represents the financial benefit to the dealer for accepting and retailing this vehicle.',
    `incentive_program_code` STRING COMMENT 'Code identifying the OEM dealer incentive program applicable to this allocation (e.g., volume bonus, stair-step program, conquest incentive). Links to the dealer incentive program master for payout calculation.',
    `is_customer_order` BOOLEAN COMMENT 'Indicates whether this allocation is fulfilling a specific retail customer order (sold order) rather than being allocated to dealer stock inventory. Drives order fulfillment priority and customer communication workflows.',
    `msrp` DECIMAL(18,2) COMMENT 'Manufacturer Suggested Retail Price (MSRP) for the allocated vehicle unit in the base transaction currency. Used for dealer invoice calculation, incentive program application, and consumer pricing guidance.',
    `notes` STRING COMMENT 'Free-text field for additional operational notes, special handling instructions, or dealer-specific comments associated with this allocation record. Used by zone managers and dealer relations teams.',
    `pdi_completed` BOOLEAN COMMENT 'Indicates whether the Pre-Delivery Inspection (PDI) has been completed for the allocated vehicle(s) at the dealership. Required before vehicle can be retailed to a customer.',
    `pdi_required` BOOLEAN COMMENT 'Indicates whether a Pre-Delivery Inspection (PDI) is required for the allocated vehicle(s) before retail handover. Drives dealer service scheduling and PDI cost recovery processes.',
    `port_of_entry_code` STRING COMMENT 'Code identifying the port or processing compound through which imported or CKD/SKD vehicles pass before onward delivery to the dealer. Relevant for international allocation flows and customs compliance.. Valid values are `^[A-Z]{3,5}$`',
    `priority_tier` STRING COMMENT 'Dealer priority tier assigned for this allocation cycle, determining precedence when vehicle supply is constrained. Tier 1 dealers receive first allocation rights based on performance metrics, sales volume, or strategic importance.. Valid values are `tier_1|tier_2|tier_3|tier_4`',
    `production_plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility where the allocated vehicle(s) were or will be produced. Used for logistics routing, transport cost calculation, and supply chain traceability.. Valid values are `^[A-Z0-9]{2,6}$`',
    `region_code` STRING COMMENT 'OEM regional zone code (e.g., NORTHEAST, SOUTHEAST, CENTRAL, WEST) grouping territories for macro-level allocation planning, regional incentive programs, and zone manager oversight.. Valid values are `^[A-Z]{2,5}$`',
    `rejection_reason_code` STRING COMMENT 'Standardized code indicating the dealers reason for rejecting this allocation (e.g., excess inventory, wrong specification, cash flow constraints, market demand mismatch). Null when allocation is accepted. [ENUM-REF-CANDIDATE: excess_inventory|wrong_spec|cash_flow|demand_mismatch|facility_capacity|other — promote to reference product]',
    `scheduled_production_date` DATE COMMENT 'Planned date on which the allocated vehicle unit(s) are scheduled to enter the production line. Derived from the Start of Production (SOP) schedule and used for delivery window planning.',
    `source_system_code` STRING COMMENT 'Identifies the operational system of record that originated this allocation record. Supports data lineage, reconciliation, and multi-system integration auditing across SAP S/4HANA SD, CDK Global DMS, and Salesforce Automotive Cloud.. Valid values are `SAP_SD|CDK_DMS|SALESFORCE|MES|MANUAL`',
    `territory_code` STRING COMMENT 'OEM-defined sales territory code within which the dealer operates. Used for regional allocation quota management, zone-level supply balancing, and territory performance reporting.. Valid values are `^[A-Z0-9]{2,10}$`',
    `transport_mode` STRING COMMENT 'Primary mode of transportation used to deliver the allocated vehicle(s) from the production plant or port of entry to the dealership. Drives logistics cost allocation and delivery lead time estimation.. Valid values are `rail|truck|ship|compound`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this allocation record. Supports change tracking, audit compliance, and incremental data pipeline processing.',
    `vin` STRING COMMENT '17-character Vehicle Identification Number (VIN) assigned to a specific vehicle unit within this allocation. Populated for unit-level allocations; null for batch-level allocations where VINs are not yet assigned.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_vehicle_allocation PRIMARY KEY(`vehicle_allocation_id`)
) COMMENT 'Records the OEMs allocation of specific vehicle units (by VIN or allocation batch) to a dealership for a given model year and production period. Captures allocation quantity, nameplate, trim, powertrain type (ICE/HEV/PHEV/EV), allocation rule applied, priority tier, acceptance status, and delivery window. Core operational record linking manufacturing output to dealer inventory pipeline.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` (
    `allocation_rule_id` BIGINT COMMENT 'Unique surrogate identifier for the vehicle allocation rule record in the dealer network management system.',
    `dealer_incentive_program_id` BIGINT COMMENT 'Reference to the dealer incentive program that this allocation rule is linked to. When allocation_basis is incentive-based, dealers enrolled in the referenced program receive preferential allocation treatment.',
    `superseded_by_rule_allocation_rule_id` BIGINT COMMENT 'Reference to the allocation_rule_id of the newer rule that replaces this rule when it is superseded. Null if this rule has not been replaced. Enables rule lineage tracking across model year and program transitions.',
    `allocation_basis` STRING COMMENT 'The primary metric or data source used to calculate each dealers share of the total allocation pool under this rule. Retail sales uses prior-period retail units sold; wholesale_orders uses dealer order history; days_supply targets a specific inventory days-supply level; market_share uses regional market penetration; scorecard_rank uses the dealer performance scorecard ranking.. Valid values are `retail_sales|wholesale_orders|days_supply|market_share|scorecard_rank`',
    `allocation_cycle` STRING COMMENT 'Frequency at which the allocation engine applies this rule to generate vehicle_allocation records. Determines the cadence of dealer inventory replenishment under this rule.. Valid values are `weekly|biweekly|monthly|quarterly`',
    `approval_status` STRING COMMENT 'Workflow approval status of the allocation rule. Rules must be approved before transitioning to active status. Supports multi-level OEM approval workflows for allocation policy governance.. Valid values are `pending|approved|rejected|under_review`',
    `approved_by` STRING COMMENT 'Name or employee ID of the OEM personnel who approved this allocation rule for activation. Supports audit trail and governance requirements.',
    `approved_date` DATE COMMENT 'Calendar date on which this allocation rule received final approval and was authorized for activation in the allocation engine.',
    `body_style` STRING COMMENT 'Body style segment to which this allocation rule applies. Used to enforce model mix targets across the dealer network. all indicates the rule applies regardless of body style. [ENUM-REF-CANDIDATE: sedan|suv|truck|van|coupe|convertible|wagon|all — 8 candidates stripped; promote to reference product]',
    `carryover_allowed` BOOLEAN COMMENT 'Indicates whether unallocated units from a prior cycle can be carried over and added to the next cycles pool under this rule. True enables carryover; False requires the pool to be reset each cycle.',
    `conflict_resolution` STRING COMMENT 'Method used by the allocation engine when this rule conflicts with another active rule for the same dealer and nameplate. Highest_priority applies the rule with the highest priority_weight; sum combines allocations; average takes the mean; manual flags for human review.. Valid values are `highest_priority|lowest_priority|sum|average|manual`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this allocation rule record was first created in the system, in ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). Supports audit trail and data lineage requirements.',
    `dealer_tier` STRING COMMENT 'Dealer performance tier classification to which this rule applies. Tier 1 dealers (top performers) typically receive preferential allocation; Tier 2 and Tier 3 receive proportionally lower allocations. all applies the rule across all tiers.. Valid values are `tier_1|tier_2|tier_3|all`',
    `effective_from` DATE COMMENT 'The calendar date from which this allocation rule becomes active and is applied by the allocation engine to generate vehicle_allocation records. Aligns with OEM model year launch or program start dates.',
    `effective_until` DATE COMMENT 'The calendar date after which this allocation rule is no longer applied by the allocation engine. Null indicates an open-ended rule with no defined expiry. Typically aligned with model year end or program end dates.',
    `eop_date` DATE COMMENT 'End of Production (EOP) date for the model year and nameplate covered by this rule. Allocation rules are typically deactivated at or after EOP to manage wind-down inventory distribution.',
    `external_rule_ref` STRING COMMENT 'The rule identifier or document reference as recorded in the originating source system (e.g., SAP condition record number, CDK rule ID). Enables cross-system reconciliation and traceability.',
    `franchise_type` STRING COMMENT 'Dealer franchise model to which this rule applies: OEM-owned (factory store), independent franchise, dual franchise (carrying multiple OEM brands), or all for rules spanning all franchise types.. Valid values are `oem_owned|independent_franchise|dual_franchise|all`',
    `lookback_period_days` STRING COMMENT 'Number of historical days used to calculate the allocation basis metric (e.g., 90 days of retail sales history). Defines the rolling window for performance-based and volume-based allocation calculations.',
    `max_allocation_units` STRING COMMENT 'Maximum number of vehicle units that can be allocated to a qualifying dealer under this rule per allocation cycle. Prevents over-concentration of inventory at high-volume dealers and supports equitable network distribution.',
    `min_allocation_units` STRING COMMENT 'Minimum number of vehicle units that must be allocated to a qualifying dealer under this rule per allocation cycle. Ensures floor-level inventory support for smaller dealers and contractual franchise minimums.',
    `min_csi_score` DECIMAL(18,2) COMMENT 'Minimum Customer Satisfaction Index (CSI) score a dealer must maintain to qualify for allocation under this rule. CSI is measured via OEM customer surveys post-purchase and post-service. Dealers below this threshold may be excluded or receive reduced allocation.',
    `min_scorecard_score` DECIMAL(18,2) COMMENT 'Minimum dealer performance scorecard score required for a dealer to qualify for allocation under this rule. Used for performance-based rules to restrict allocation to dealers meeting OEM performance standards.',
    `model_mix_target_pct` DECIMAL(18,2) COMMENT 'Target percentage of the allocated units that should be of the specified nameplate or powertrain type within the dealers total inventory mix. Used for model_mix rule types to enforce portfolio balance (e.g., 20% EV mix target).',
    `model_year` STRING COMMENT 'The vehicle Model Year (MY) to which this allocation rule applies, expressed as a four-digit calendar year (e.g., 2024, 2025). Aligns with OEM production planning cycles and SAP S/4HANA PP model year configuration.',
    `nameplate_code` STRING COMMENT 'OEM-assigned code identifying the vehicle nameplate (model line) to which this allocation rule applies (e.g., F-150, Silverado, Camry, Model 3). Corresponds to the nameplate/model line in the PLM system.',
    `override_allowed` BOOLEAN COMMENT 'Indicates whether authorized OEM personnel can manually override the allocation quantities generated by this rule for individual dealers. Supports exception handling for special dealer circumstances.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or assembly plant that is the source of vehicles allocated under this rule. Ties the allocation rule to a specific production source for supply chain planning.. Valid values are `^[A-Z0-9]{2,10}$`',
    `powertrain_type` STRING COMMENT 'Powertrain technology segment to which this rule applies: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), FCEV (Fuel Cell Electric Vehicle), or all for rules spanning all powertrain types. Supports EV transition planning and CAFE compliance allocation strategies.. Valid values are `ICE|HEV|PHEV|BEV|FCEV|all`',
    `priority_weight` DECIMAL(18,2) COMMENT 'Numeric weighting factor (0.00–100.00) assigned to this rule when multiple allocation rules apply simultaneously. Higher weights cause the allocation engine to favor this rule over lower-weighted rules during conflict resolution.',
    `region_code` STRING COMMENT 'OEM-defined sales region code to which this allocation rule applies (e.g., NE for Northeast, MW for Midwest, SW for Southwest). Drives geographic allocation logic and territory-based distribution. Null indicates a national rule.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `rule_code` STRING COMMENT 'Externally-known alphanumeric business identifier for the allocation rule, used in dealer communications, DMS integration, and allocation engine references (e.g., ALLOC-VOL-2024-001).. Valid values are `^[A-Z0-9_-]{3,30}$`',
    `rule_description` STRING COMMENT 'Free-text narrative description of the allocation rules business purpose, special conditions, or exceptions. Provides context for allocation analysts and dealer network managers reviewing rule configurations.',
    `rule_name` STRING COMMENT 'Human-readable descriptive name for the allocation rule, used in reporting dashboards and dealer portal displays (e.g., Q1 2024 F-Series Volume Allocation - Northeast Region).',
    `rule_status` STRING COMMENT 'Current lifecycle state of the allocation rule. Draft rules are under review; active rules are used by the allocation engine; suspended rules are temporarily paused; expired rules have passed their effective end date; cancelled rules have been voided before activation.. Valid values are `draft|active|suspended|expired|cancelled`',
    `rule_type` STRING COMMENT 'Classification of the allocation rule governing how vehicles are distributed. Volume-based uses historical sales volume; performance-based uses dealer scorecard metrics; geographic uses territory boundaries; model_mix enforces nameplate portfolio balance; incentive_based ties allocation to dealer incentive program participation; priority_based uses explicit dealer priority tiers. [ENUM-REF-CANDIDATE: volume_based|performance_based|geographic|model_mix|incentive_based|priority_based — promote to reference product]. Valid values are `volume_based|performance_based|geographic|model_mix|incentive_based|priority_based`',
    `sop_date` DATE COMMENT 'Start of Production (SOP) date for the model year and nameplate covered by this rule. Used to align allocation rule activation with production availability and prevent premature dealer allocation commitments.',
    `stackable` BOOLEAN COMMENT 'Indicates whether this allocation rule can be combined (stacked) with other active allocation rules for the same dealer, nameplate, and model year. Non-stackable rules are applied exclusively when triggered.',
    `target_days_supply` DECIMAL(18,2) COMMENT 'Target inventory days-supply level that this allocation rule aims to achieve at qualifying dealers. Days supply = (current inventory units) / (average daily retail sales rate). Used when allocation_basis is days_supply.',
    `total_pool_units` STRING COMMENT 'Total number of vehicle units available in the allocation pool governed by this rule for the current allocation cycle. The allocation engine distributes these units across qualifying dealers according to the rule logic.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this allocation rule record, in ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). Used for change detection in ETL pipelines and audit compliance.',
    `version_number` STRING COMMENT 'Sequential version number of this allocation rule, incremented each time the rule parameters are materially modified. Supports rule change history tracking and audit compliance.',
    `zone_code` STRING COMMENT 'Sub-regional distribution zone code within the sales region to which this rule applies. Zones represent finer geographic groupings of dealers used for allocation granularity below the region level.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    CONSTRAINT pk_allocation_rule PRIMARY KEY(`allocation_rule_id`)
) COMMENT 'Business rules governing how vehicles are distributed across the dealer network. Defines rule type (volume-based, performance-based, geographic, model mix), applicable nameplates, MY (Model Year), priority weighting, minimum and maximum allocation thresholds, and effective period. Used by the allocation engine to generate vehicle_allocation records.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` (
    `dealer_inventory_id` BIGINT COMMENT 'Unique surrogate identifier for each dealer inventory record in the Silver Layer lakehouse. Primary key for this data product.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Inventory Turnover Optimization monitors connectivity status of inventory vehicles to prioritize sales of connected models.',
    `finished_vehicle_stock_id` BIGINT COMMENT 'Foreign key linking to inventory.finished_vehicle_stock. Business justification: REQUIRED: Allocation traceability report needs to map each dealer inventory record to the originating finished‑vehicle stock for compliance and recall tracking.',
    `homologation_record_id` BIGINT COMMENT 'Foreign key linking to compliance.homologation_record. Business justification: Inventory management must ensure each stocked vehicle model is homologated for the market; linking inventory to homologation records supports compliance checks.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Inventory manager ownership is tracked for inventory reconciliation and loss prevention reporting.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership that physically holds or is allocated this inventory unit. Sourced from CDK Global DMS dealer master.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Inventory management report requires linking each dealer inventory record to the SKU definition for pricing, specs, warranty and compliance.',
    `vehicle_build_id` BIGINT COMMENT 'Foreign key linking to manufacturing.vehicle_build. Business justification: Needed for Vehicle Traceability report, connecting each inventory record to its exact build record for warranty and recall actions.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Inventory allocation report needs to know which OEM vehicle order supplied each stocked vehicle.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Dealer inventory management report requires each inventory record to be linked to the VIN registry for warranty, recall, and compliance tracking.',
    `acquisition_cost` DECIMAL(18,2) COMMENT 'The dealers total landed cost for this vehicle unit, including invoice price, transportation/destination charges, PDI costs, and any dealer-installed accessories. Used for gross profit calculation and inventory valuation.',
    `allocation_order_number` STRING COMMENT 'The OEM-assigned order or allocation number associated with this vehicle unit, linking the dealer inventory record back to the factory production order. Used for order tracking, allocation management, and OEM-dealer reconciliation.',
    `asking_price` DECIMAL(18,2) COMMENT 'The dealers current advertised or asking retail price for this vehicle unit. May differ from MSRP due to market adjustments, dealer markups, or promotional discounts. Updated dynamically based on market conditions and days-on-lot.',
    `body_style` STRING COMMENT 'The vehicle body style classification (e.g., sedan, SUV, pickup truck, van). Used for inventory segmentation, lot management, and sales reporting. [ENUM-REF-CANDIDATE: sedan|coupe|SUV|crossover|pickup_truck|van|minivan|wagon|convertible|hatchback — promote to reference product]',
    `certified_pre_owned` BOOLEAN COMMENT 'Indicates whether this used vehicle unit has been certified under the OEMs Certified Pre-Owned (CPO) program, meeting specific age, mileage, inspection, and reconditioning standards. True = CPO certified; False = not CPO certified. CPO vehicles carry extended warranty coverage and premium pricing.',
    `days_on_lot` STRING COMMENT 'The number of calendar days this vehicle unit has been physically present on the dealers lot since the received date. A key inventory aging metric used to trigger price adjustments, incentive programs, and wholesale decisions. Aged inventory (typically >60 days) incurs floor plan interest costs.',
    `dms_record_reference` STRING COMMENT 'The source system record identifier from CDK Global DMS for this inventory unit. Used for data lineage, reconciliation, and incremental load processing between the DMS source and the Silver Layer lakehouse.',
    `drivetrain` STRING COMMENT 'Drivetrain configuration of the vehicle: FWD (Front-Wheel Drive), RWD (Rear-Wheel Drive), AWD (All-Wheel Drive), or 4WD (Four-Wheel Drive). Key inventory search and customer preference attribute.. Valid values are `FWD|RWD|AWD|4WD`',
    `engine_description` STRING COMMENT 'Descriptive label for the engine or powertrain configuration (e.g., 2.5L 4-Cylinder, 3.5L V6 EcoBoost, 75 kWh Electric Motor). Supports customer consultation and technical service identification.',
    `estimated_arrival_date` DATE COMMENT 'The estimated date the vehicle unit is expected to arrive at the dealership from the OEM or transport carrier. Relevant for in-transit inventory. Used for customer pre-order management and lot planning.',
    `exterior_color_code` STRING COMMENT 'OEM-assigned paint/exterior color code for this vehicle unit (e.g., NH-883P for Sonic Gray Pearl). Used for inventory search, customer matching, and lot locator functions within CDK Global DMS.',
    `exterior_color_name` STRING COMMENT 'Human-readable marketing name of the exterior paint color (e.g., Sonic Gray Pearl, Midnight Black Metallic). Used for customer-facing display and sales consultation.',
    `floor_plan_date` DATE COMMENT 'The date on which floor plan financing commenced for this vehicle unit. Used to calculate accrued floor plan interest costs and curtailment schedules. Null for vehicles not financed via floor plan.',
    `floor_plan_lender` STRING COMMENT 'Name of the financial institution providing floor plan (wholesale) financing for this vehicle unit (e.g., Ford Motor Credit, Ally Financial, Chase Auto Finance). Floor plan financing is the short-term credit line dealers use to fund vehicle inventory.',
    `fuel_economy_city_mpg` DECIMAL(18,2) COMMENT 'EPA-rated city fuel economy for this vehicle configuration in miles per gallon (MPG), or MPGe for electric/hybrid vehicles. Required disclosure on the Monroney label and used for CAFE compliance reporting.',
    `fuel_economy_highway_mpg` DECIMAL(18,2) COMMENT 'EPA-rated highway fuel economy for this vehicle configuration in miles per gallon (MPG), or MPGe for electric/hybrid vehicles. Required disclosure on the Monroney label and used for CAFE compliance reporting.',
    `in_service_date` DATE COMMENT 'The date the vehicle was placed into service (sold and delivered to a retail customer, or placed into demo/loaner service). Marks the start of the OEM warranty period. Null if the vehicle has not yet been placed in service.',
    `interior_color_code` STRING COMMENT 'OEM-assigned interior color/trim code for this vehicle unit (e.g., BK for Black). Used for inventory matching and customer preference alignment.',
    `interior_color_name` STRING COMMENT 'Human-readable marketing name of the interior color and material (e.g., Black Leather, Sandstone Cloth). Used for customer-facing display and sales consultation.',
    `inventory_status` STRING COMMENT 'Current disposition status of the vehicle unit within the dealer inventory lifecycle. available = on-lot and saleable; sold = retail sale completed; demo = dealer demonstration unit; loaner = service loaner vehicle; in_transit = allocated but not yet physically received; reserved = held for a specific customer; wholesale = designated for wholesale/auction disposal. [ENUM-REF-CANDIDATE: available|sold|demo|loaner|in_transit|reserved|wholesale — promote to reference product]',
    `inventory_type` STRING COMMENT 'Classification of the vehicle unit by its condition and ownership history: new = new vehicle never titled; used = previously owned/titled vehicle; certified_pre_owned = OEM-certified used vehicle meeting specific age/mileage criteria; demo = dealer demonstration vehicle; loaner = service loaner vehicle. Governs applicable pricing, warranty, and financing programs.. Valid values are `new|used|certified_pre_owned|demo|loaner`',
    `invoice_price` DECIMAL(18,2) COMMENT 'The OEM invoice price charged to the dealer for this vehicle unit, representing the dealers acquisition cost from the manufacturer before holdback, dealer cash, or other incentives. Confidential commercial pricing data.',
    `last_price_update_date` DATE COMMENT 'The date on which the asking price for this vehicle unit was most recently updated in the CDK Global DMS. Used to track pricing strategy cadence and ensure market-aligned pricing for aged inventory.',
    `location_code` STRING COMMENT 'The physical lot or storage location code within the dealership where this vehicle is parked (e.g., LOT-A-12, SHOWROOM-3, OVERFLOW-B). Used for lot management, vehicle locator, and PDI workflow routing within CDK Global DMS.',
    `msrp` DECIMAL(18,2) COMMENT 'The Manufacturer Suggested Retail Price (MSRP) for this specific vehicle unit including all factory-installed options and packages, expressed in the local currency (USD). Established by the OEM and used as the baseline for dealer pricing and incentive calculations.',
    `odometer_reading` STRING COMMENT 'Current odometer reading of the vehicle in miles at the time of inventory check-in or last update. Critical for used, demo, and loaner vehicles to determine CPO eligibility, warranty coverage, and pricing. For new vehicles, reflects delivery mileage.',
    `pdi_completed` BOOLEAN COMMENT 'Indicates whether the Pre-Delivery Inspection (PDI) has been completed for this vehicle unit. PDI is a mandatory dealer quality check performed before vehicle delivery to a customer, verifying all systems, fluids, and accessories meet OEM standards. True = PDI completed; False = PDI pending.',
    `pdi_completed_date` DATE COMMENT 'The date on which the Pre-Delivery Inspection (PDI) was completed and signed off by the dealers service technician. Null if PDI has not yet been performed.',
    `recall_campaign_number` STRING COMMENT 'The NHTSA-assigned recall campaign number if this vehicle is subject to an active safety recall (e.g., 23V-123). Null if no active recall. Used for recall remedy tracking and regulatory reporting.',
    `recall_hold` BOOLEAN COMMENT 'Indicates whether this vehicle unit is subject to an active NHTSA safety recall that prevents retail sale or delivery until the recall remedy has been performed. True = vehicle is on recall hold and cannot be sold; False = no active recall hold. Critical for regulatory compliance and consumer safety.',
    `received_date` DATE COMMENT 'The date the vehicle unit was physically received and checked into the dealers inventory from the OEM transport carrier or trade-in. Marks the start of the days-on-lot aging clock and floor plan financing period.',
    `record_created_timestamp` TIMESTAMP COMMENT 'The timestamp when this dealer inventory record was first created in the Silver Layer lakehouse, in ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). Supports audit trail and data lineage requirements.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this dealer inventory record was most recently updated in the Silver Layer lakehouse, in ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). Supports change tracking, incremental processing, and audit trail requirements.',
    `source_type` STRING COMMENT 'Indicates how the dealer acquired this vehicle unit: factory_order = ordered directly from OEM; dealer_trade = acquired via dealer-to-dealer trade; auction = purchased at wholesale auction; trade_in = accepted as customer trade-in; fleet_return = returned from fleet/rental program; lease_return = returned at end of lease term.. Valid values are `factory_order|dealer_trade|auction|trade_in|fleet_return|lease_return`',
    `stock_number` STRING COMMENT 'Dealer-assigned internal stock number used within the CDK Global DMS to identify and locate this vehicle on the lot. Unique within a dealership but not globally unique.',
    `transmission_type` STRING COMMENT 'Type of transmission fitted to the vehicle: automatic, manual, CVT (Continuously Variable Transmission), DCT (Dual-Clutch Transmission), or single_speed (for BEV). Used for inventory filtering and customer preference matching.. Valid values are `automatic|manual|CVT|DCT|single_speed`',
    `transport_status` STRING COMMENT 'Current transportation status for vehicles in the delivery pipeline from OEM plant to dealership: not_shipped = awaiting dispatch from plant; in_transit = en route via carrier; delivered = arrived at dealer; rail = currently on rail transport; truck = currently on truck transport.. Valid values are `not_shipped|in_transit|delivered|rail|truck`',
    `window_sticker_url` STRING COMMENT 'URL link to the digital Monroney window sticker (required by the Automobile Information Disclosure Act) for this vehicle unit, hosted by the OEM or a third-party service. Contains MSRP, standard equipment, options, fuel economy ratings, and safety information.',
    CONSTRAINT pk_dealer_inventory PRIMARY KEY(`dealer_inventory_id`)
) COMMENT 'Real-time inventory of vehicles physically on-hand or in-transit at a dealership. Tracks VIN, nameplate, model year, trim, exterior/interior color, powertrain, days-on-lot, acquisition cost, current asking price, inventory status (available, sold, demo, loaner, in-transit), and PDI (Pre-Delivery Inspection) completion flag. Sourced from CDK Global DMS inventory module.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` (
    `parts_inventory_id` BIGINT COMMENT 'Unique surrogate identifier for each parts inventory record at the dealer location. Primary key for the dealer parts inventory entity in the Silver Layer lakehouse.',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: Traceability for recalls and quality requires linking each dealer part stock item to its inbound part record.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealer location where this parts inventory record is maintained. Links to the dealer master entity in the dealer domain.',
    `parts_dealership_id` BIGINT COMMENT 'Reference to the dealer location where this parts inventory record is maintained. Links to the dealer master entity in the dealer domain.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Needed for Parts Inventory Management to associate each part stock with its supplying vendor for ordering, pricing, and compliance.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: Parts pricing, valuation and regulatory compliance reports require linking dealer parts stock to the master SKU definition.',
    `spare_parts_catalog_id` BIGINT COMMENT 'Foreign key linking to asset.spare_parts_catalog. Business justification: Parts inventory must reference the master parts catalog for pricing, compliance, and warranty reporting; this is required for the Parts Pricing & Compliance Report.',
    `average_monthly_demand` DECIMAL(18,2) COMMENT 'Rolling average monthly sales or usage quantity for this part at the dealer location, as calculated and stored by the CDK DMS parts analysis engine. Used for reorder point setting and stocking level optimization. Stored as a DMS-sourced field, not a lakehouse-computed metric.',
    `bin_location` STRING COMMENT 'Physical storage bin, shelf, or rack location code within the dealer parts warehouse or stockroom where this part is stored. Used by parts staff for picking, receiving, and cycle counting. Managed within CDK Global DMS warehouse management.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `core_charge_amount` DECIMAL(18,2) COMMENT 'The refundable deposit amount charged to the customer for the return of the old/used core part. Applicable only when is_core_part is true. Tracked separately in CDK DMS for core deposit liability accounting.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this parts inventory record was first created in the CDK Global DMS parts module. Represents the business record creation event, not the ETL load time. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code applicable to all monetary price fields (dealer cost price, list price, retail price) for this parts inventory record. Supports multi-currency dealer networks in international markets.. Valid values are `^[A-Z]{3}$`',
    `dealer_cost_price` DECIMAL(18,2) COMMENT 'The price at which the dealer procures this part from the OEM or authorized distributor, net of any dealer program discounts. Used for gross margin calculation and parts profitability analysis. Confidential commercial pricing data.',
    `inventory_snapshot_date` DATE COMMENT 'The business date as of which this inventory record reflects the parts quantities and status. Represents the effective date of the CDK DMS data extract loaded into the Silver Layer. Enables point-in-time inventory reporting and trend analysis.',
    `inventory_status` STRING COMMENT 'Current lifecycle status of the part in the dealer inventory. Active parts are available for sale and service. Discontinued parts are no longer manufactured. Superseded parts have been replaced by a newer part number. Backordered parts are on order but not yet received. Restricted parts require special authorization. Obsolete parts are no longer supported. [ENUM-REF-CANDIDATE: active|discontinued|superseded|backordered|restricted|obsolete — promote to reference product]. Valid values are `active|discontinued|superseded|backordered|restricted|obsolete`',
    `is_core_part` BOOLEAN COMMENT 'Indicates whether this part has a core charge associated with it, requiring the customer to return the old/used part (core) for a refund. Common for remanufactured parts such as alternators, starters, and brake calipers. Drives core deposit tracking in CDK DMS.',
    `is_hazardous_material` BOOLEAN COMMENT 'Indicates whether this part or fluid is classified as a hazardous material requiring special handling, storage, and disposal procedures under EPA, DOT, and OSHA regulations. Affects shipping documentation and storage bin assignment.',
    `is_serialized` BOOLEAN COMMENT 'Indicates whether individual units of this part are tracked by unique serial number for warranty, recall, and traceability purposes. Serialized parts (e.g., ECUs, airbag modules) require serial number capture at point of sale and installation.',
    `last_count_date` DATE COMMENT 'Date on which the most recent physical inventory count or cycle count was performed for this part at the dealer location. Used to assess inventory accuracy and schedule next count per IATF 16949 inventory control requirements.',
    `last_receipt_date` DATE COMMENT 'Date on which the most recent stock receipt (goods receipt) was posted for this part at the dealer location. Used to assess inventory freshness, identify slow-moving stock, and support cycle count scheduling.',
    `last_sale_date` DATE COMMENT 'Date on which this part was most recently sold or issued from the dealers parts inventory, either over the parts counter or via a repair order. Key metric for identifying slow-moving and non-moving (dead stock) inventory.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this parts inventory record in the CDK Global DMS, including quantity adjustments, price updates, bin location changes, or status changes. Used for change detection in incremental Silver Layer loads.',
    `lead_time_days` STRING COMMENT 'Expected number of calendar days from purchase order placement to receipt of this part at the dealer location. Used to set reorder points and manage customer promise dates for back-ordered parts.',
    `list_price` DECIMAL(18,2) COMMENT 'OEM published list price for this part as defined in the official parts price book. Serves as the baseline for retail pricing and customer quotations at the parts counter. Updated periodically via OEM price file updates in CDK DMS.',
    `lost_sales_quantity` DECIMAL(18,2) COMMENT 'Cumulative quantity of lost sales recorded for this part when a customer requested the part but it was not available in stock. Tracked in CDK DMS to support stocking level adjustments and identify demand not captured by sales history.',
    `maximum_stock_level` DECIMAL(18,2) COMMENT 'Upper inventory limit for this part at the dealer location. Prevents over-stocking and excess capital tied up in slow-moving parts. Used in conjunction with reorder point for min-max inventory management in CDK DMS.',
    `model_year_applicability` STRING COMMENT 'The vehicle Model Year (MY) range for which this part is applicable, expressed as a single year (e.g., 2022) or a range (e.g., 2019-2024). Used by parts counter staff to verify fitment and avoid incorrect part installation.. Valid values are `^[0-9]{4}(-[0-9]{4})?$`',
    `months_supply` DECIMAL(18,2) COMMENT 'Number of months the current on-hand quantity is expected to last based on the trailing average monthly demand. Sourced directly from CDK DMS parts analysis module. Used to identify overstocked and understocked parts for return-to-OEM decisions.',
    `oem_part_number` STRING COMMENT 'The official OEM-assigned part number as defined in the parts catalog and PLM system. This is the primary catalog identifier used for ordering, supersession tracking, and warranty claims. Sourced from Siemens Teamcenter PLM and SAP MM material master.. Valid values are `^[A-Z0-9-]{4,25}$`',
    `parts_classification` STRING COMMENT 'High-level classification category of the part used for inventory segmentation, reporting, and stocking strategy. Categories include mechanical (engine, drivetrain, suspension), body (panels, glass, trim), electrical (ECU, sensors, wiring), accessories (OEM-approved add-ons), fluids, and consumables. [ENUM-REF-CANDIDATE: mechanical|body|electrical|accessories|fluids|consumables — promote to reference product]. Valid values are `mechanical|body|electrical|accessories|fluids|consumables`',
    `parts_group_code` STRING COMMENT 'OEM-defined parts group or commodity code that further classifies the part within the parts classification hierarchy. Used for bulk ordering, supplier management, and warranty analysis. Aligns with SAP MM material group.. Valid values are `^[A-Z0-9]{2,10}$`',
    `quantity_available` DECIMAL(18,2) COMMENT 'Net quantity available for immediate sale or service fulfillment, calculated as quantity on hand minus quantity reserved. Represents the unreserved, physically present stock. Stored as a business field from CDK DMS to avoid real-time recalculation in reporting.',
    `quantity_on_hand` DECIMAL(18,2) COMMENT 'Current physical quantity of the part available in the dealers parts stockroom as recorded in the CDK DMS. Represents the actual counted or system-tracked stock level used for service fulfillment and parts counter sales.',
    `quantity_on_order` DECIMAL(18,2) COMMENT 'Total quantity of this part currently on open purchase orders submitted to the OEM or aftermarket supplier but not yet received at the dealer. Used for demand planning and avoiding duplicate orders.',
    `quantity_reserved` DECIMAL(18,2) COMMENT 'Quantity of this part that has been reserved or allocated to open repair orders, customer back-orders, or service appointments but not yet consumed. Reduces available-to-promise quantity for new service requests.',
    `recall_campaign_number` STRING COMMENT 'NHTSA or OEM-assigned recall campaign identifier associated with this part when recall_flag is true. Used to link parts inventory to specific recall campaigns for compliance tracking and OEM reimbursement claims.. Valid values are `^[A-Z0-9-]{4,20}$`',
    `recall_flag` BOOLEAN COMMENT 'Indicates whether this part is associated with an active NHTSA safety recall or OEM field action. Recall-flagged parts may have restricted sale or mandatory installation requirements. Supports compliance with NHTSA recall management obligations.',
    `reorder_point` DECIMAL(18,2) COMMENT 'Minimum stock level threshold at which a replenishment order should be triggered for this part. When quantity on hand falls to or below this level, the DMS generates a replenishment recommendation. Set based on historical demand and lead time.',
    `reorder_quantity` DECIMAL(18,2) COMMENT 'Standard order quantity to be placed when the reorder point is reached. Represents the economic order quantity (EOQ) or OEM-mandated minimum order quantity for this part at this dealer location.',
    `retail_price` DECIMAL(18,2) COMMENT 'Dealer-set retail selling price for this part at the parts counter or in service repair orders. May differ from OEM list price based on dealer markup strategy, local market conditions, or promotional pricing.',
    `sku` STRING COMMENT 'Dealer-level Stock Keeping Unit (SKU) code used within the CDK Global DMS parts module for inventory tracking, bin management, and point-of-sale transactions. May differ from OEM part number when dealer applies local stocking codes.. Valid values are `^[A-Z0-9-]{4,30}$`',
    `storage_condition` STRING COMMENT 'Required storage condition for this part to maintain quality and safety compliance. Drives bin assignment and warehouse layout decisions. Flammable and hazardous parts require segregated storage per EPA and DOT regulations.. Valid values are `ambient|refrigerated|flammable|controlled|outdoor`',
    `superseded_by_date` DATE COMMENT 'The date on which this part number was officially superseded by the superseding part number as communicated by the OEM. Used to manage transition inventory and inform service advisors of part number changes.',
    `superseding_part_number` STRING COMMENT 'The OEM part number that replaces this part when it has been superseded. Populated when inventory_status is superseded. Enables the parts counter to automatically redirect orders to the current valid part number. Part of the supersession chain managed in the OEM parts catalog.. Valid values are `^[A-Z0-9-]{4,25}$`',
    `supplier_part_number` STRING COMMENT 'The part number assigned by the OEM distributor or aftermarket supplier for cross-reference purposes. Used when ordering from non-OEM sources or when the dealer stocks approved aftermarket alternatives alongside OEM parts.. Valid values are `^[A-Z0-9-]{4,30}$`',
    `unit_of_measure` STRING COMMENT 'Standard unit of measure in which the part is stocked, ordered, and sold. EA (each) is most common for discrete parts; KG/L for fluids and chemicals; SET/PAIR for grouped components. Aligns with SAP MM base unit of measure. [ENUM-REF-CANDIDATE: EA|KG|L|M|SET|BOX|PAIR|ROLL — 8 candidates stripped; promote to reference product]',
    `vehicle_model_applicability` STRING COMMENT 'Comma-separated list of vehicle model names or platform codes for which this part is applicable (e.g., F-150, Explorer, Mustang). Supports fitment verification at the parts counter and in service repair order creation.',
    `warranty_eligible` BOOLEAN COMMENT 'Indicates whether this part is eligible for OEM warranty claim submission when installed during a warranty repair. Non-warranty-eligible parts (e.g., customer-pay accessories) are excluded from warranty billing to the OEM.',
    CONSTRAINT pk_parts_inventory PRIMARY KEY(`parts_inventory_id`)
) COMMENT 'Dealer-level parts and accessories inventory managed through the CDK Global DMS parts module. Tracks OEM part number, SKU, description, quantity on hand, quantity on order, bin location, reorder point, supersession chain, price, and parts classification (mechanical, body, electrical, accessories). Supports service operations and parts counter sales.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` (
    `retail_sale_id` BIGINT COMMENT 'Unique surrogate identifier for each retail vehicle sale transaction record in the dealer domain. Primary key for the retail_sale data product.',
    `opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Retail sale conversion analysis links the final sale back to the originating sales opportunity for win‑loss tracking.',
    `party_id` BIGINT COMMENT 'Reference to the retail customer (buyer) who purchased the vehicle. Links to the customer master record.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership that executed the retail sale transaction. Links to the dealer master record in the dealer domain.',
    `retail_dealership_id` BIGINT COMMENT 'Reference to the dealership that executed the retail sale transaction. Links to the dealer master record in the dealer domain.',
    `employee_id` BIGINT COMMENT 'Reference to the dealership salesperson (finance and insurance associate or sales consultant) who managed and closed the retail deal.',
    `retail_party_id` BIGINT COMMENT 'Reference to the retail customer (buyer) who purchased the vehicle. Links to the customer master record.',
    `retail_salesperson_employee_id` BIGINT COMMENT 'Reference to the dealership salesperson (finance and insurance associate or sales consultant) who managed and closed the retail deal.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Retail sale transaction must reference the SKU for warranty registration, service history, and post‑sale reporting.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Retail sale reporting and warranty registration depend on linking the sold vehicle to its VIN registry entry.',
    `apr` DECIMAL(18,2) COMMENT 'The Annual Percentage Rate (APR) on the retail installment contract as disclosed to the customer under Regulation Z. Expressed as a decimal (e.g., 0.0699 for 6.99%). Null for cash and lease deals.',
    `back_end_gross` DECIMAL(18,2) COMMENT 'Gross profit earned from F&I products and dealer reserve on the financing (back-end), representing the total F&I department contribution to the deal. Key dealer profitability metric.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the retail sale record was first created in the data platform (Silver Layer ingestion). Conforms to ISO 8601 format yyyy-MM-ddTHH:mm:ss.SSSXXX. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts in this retail sale record (e.g., USD, CAD, EUR). Supports multi-market dealer network operations.. Valid values are `^[A-Z]{3}$`',
    `deal_number` STRING COMMENT 'Externally-known alphanumeric deal reference number assigned by the CDK Global DMS F&I module at the time the deal is opened. Used for cross-referencing with dealer records, lender submissions, and OEM reporting.. Valid values are `^[A-Z0-9-]{4,20}$`',
    `deal_status` STRING COMMENT 'Current lifecycle state of the retail sale deal. draft indicates deal is being structured; pending indicates awaiting lender funding approval; funded indicates lender has funded the deal; unwound indicates a previously funded deal that was reversed; cancelled indicates deal was voided before funding.. Valid values are `draft|pending|funded|unwound|cancelled`',
    `delivery_date` DATE COMMENT 'The date the vehicle was physically delivered to the customer following Pre-Delivery Inspection (PDI). May differ from sale_date when delivery is deferred. Used for warranty start date determination and OEM retail reporting.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total discount applied to the vehicle sale, calculated as MSRP minus sale price. Includes dealer discounts, OEM incentive discounts, and employee pricing adjustments. Used for dealer margin analysis and OEM incentive reconciliation.',
    `dms_deal_reference` STRING COMMENT 'The native deal identifier assigned by the CDK Global DMS F&I module. Used for source system traceability, reconciliation, and integration with downstream OEM reporting and lender portals.',
    `doc_fee` DECIMAL(18,2) COMMENT 'Dealer-charged documentation and processing fee included in the deal. Subject to state-level regulatory caps in many jurisdictions. Disclosed on the buyers order.',
    `down_payment` DECIMAL(18,2) COMMENT 'Cash down payment made by the customer at the time of sale, excluding trade-in allowance. Reduces the amount financed. Used for deal structure analysis and lender submission.',
    `fi_product_revenue` DECIMAL(18,2) COMMENT 'Total gross revenue generated from Finance and Insurance (F&I) aftermarket products sold as part of the deal, including extended service contracts, GAP insurance, paint protection, tire and wheel protection, and credit life/disability insurance.',
    `finance_amount` DECIMAL(18,2) COMMENT 'The total amount financed by the customer under the retail installment contract, including vehicle price, F&I products, taxes, and fees, less down payment and trade-in allowance. Null for cash deals.',
    `financing_type` STRING COMMENT 'The method by which the customer is financing the vehicle purchase. cash = outright purchase; retail_finance = retail installment contract through a lender; lease = closed-end consumer lease; balloon = balloon payment retail contract.. Valid values are `cash|retail_finance|lease|balloon`',
    `fleet_sale` BOOLEAN COMMENT 'Indicates whether the vehicle was sold as part of a fleet or commercial account transaction rather than a retail consumer sale. Fleet sales are tracked separately for CAFE compliance, OEM fleet incentive programs, and sales mix reporting.',
    `front_end_gross` DECIMAL(18,2) COMMENT 'Gross profit earned on the vehicle sale itself (front-end), calculated as sale price minus dealer invoice cost and pack. Excludes F&I product revenue. Key dealer profitability metric reported in DMS and OEM dealer scorecards.',
    `lender_name` STRING COMMENT 'Name of the financial institution (captive finance company, bank, credit union) that approved and funded the retail installment contract or lease. Null for cash deals. Used for lender mix reporting and dealer reserve analysis.',
    `loan_term_months` STRING COMMENT 'The contractual term of the retail installment contract expressed in months (e.g., 36, 48, 60, 72, 84). Used for lender mix analysis, payment affordability reporting, and portfolio risk assessment.',
    `model_year` STRING COMMENT 'The Model Year (MY) of the vehicle sold, as defined by the OEM and NHTSA. Used for CAFE compliance reporting, incentive program eligibility, and sales mix analytics.',
    `monthly_payment` DECIMAL(18,2) COMMENT 'The customers contracted monthly payment amount under the retail installment contract or lease agreement. Used for affordability analysis and customer financial profiling.',
    `msrp_amount` DECIMAL(18,2) COMMENT 'The Manufacturer Suggested Retail Price (MSRP) of the vehicle as stickered, inclusive of all factory-installed options and destination charges. Expressed in the local currency (USD). Used as the baseline for discount calculation, incentive reporting, and dealer margin analysis.',
    `oem_incentive_amount` DECIMAL(18,2) COMMENT 'Total value of OEM-funded customer incentives applied to the deal, including cash-back rebates, conquest bonuses, loyalty bonuses, and special program pricing. Sourced from OEM incentive program data and reconciled against dealer statements.',
    `oem_program_code` STRING COMMENT 'OEM-assigned program code identifying the specific incentive or sales program under which the vehicle was sold (e.g., employee pricing, conquest, loyalty, fleet, rental). Used for OEM incentive claim submission and program performance reporting.',
    `pdi_completed` BOOLEAN COMMENT 'Indicates whether the Pre-Delivery Inspection (PDI) was completed and signed off by the dealer technician prior to vehicle delivery to the customer. PDI completion is required for warranty activation and OEM delivery standards compliance.',
    `sale_date` DATE COMMENT 'The calendar date on which the retail vehicle sale was consummated — i.e., the date the buyer signed the retail installment contract or cash purchase agreement. This is the principal business event date used for sales reporting, OEM incentive eligibility, and regulatory compliance.',
    `sale_price` DECIMAL(18,2) COMMENT 'The agreed-upon selling price of the vehicle as negotiated between the dealer and the customer, before trade-in allowance, taxes, and fees. This is the gross capitalized cost for lease deals or the selling price for retail finance and cash deals.',
    `sales_tax_amount` DECIMAL(18,2) COMMENT 'State and local sales tax assessed on the vehicle sale transaction. Calculated based on the taxable selling price and the applicable jurisdiction tax rate. Used for tax remittance reporting and deal cost reconciliation.',
    `stock_number` STRING COMMENT 'Dealer-assigned inventory stock number for the vehicle unit at the time of sale. Used for dealer inventory management and reconciliation with CDK Global DMS inventory records.',
    `trade_in_allowance` DECIMAL(18,2) COMMENT 'The agreed trade-in value credited to the customer for a vehicle traded in as part of the deal. Reduces the amount financed or cash due. Null if no trade-in vehicle was involved in the transaction.',
    `trade_in_payoff_amount` DECIMAL(18,2) COMMENT 'The outstanding loan or lease payoff balance on the customers trade-in vehicle at the time of the deal. If payoff exceeds trade-in allowance, the difference (negative equity) is typically rolled into the new deal.',
    `trade_in_vin` STRING COMMENT 'The 17-character VIN of the customers trade-in vehicle, if applicable. Used for used vehicle inventory intake, auction disposition tracking, and trade-in equity analysis.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `updated_timestamp` TIMESTAMP COMMENT 'The timestamp when the retail sale record was last modified in the data platform, reflecting deal amendments, status changes, or corrections sourced from CDK Global DMS. Conforms to ISO 8601 format yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `vehicle_condition` STRING COMMENT 'Condition classification of the vehicle at point of sale. new indicates a new, untitled vehicle; used indicates a previously titled vehicle; certified_pre_owned indicates a manufacturer-certified pre-owned vehicle meeting OEM CPO program standards.. Valid values are `new|used|certified_pre_owned`',
    `warranty_start_date` DATE COMMENT 'The date on which the OEM new vehicle limited warranty period commences, typically aligned with the delivery_date or sale_date per OEM warranty policy. Used for warranty claim eligibility determination.',
    CONSTRAINT pk_retail_sale PRIMARY KEY(`retail_sale_id`)
) COMMENT 'Records the retail sale of a new or used vehicle by a dealership to an end customer. Captures VIN, sale date, sale price, MSRP, discount amount, trade-in details, financing type (cash, retail finance, lease), F&I products sold, salesperson, and deal status. Sourced from CDK Global DMS F&I module. SSOT for dealer-level vehicle sales transactions.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` (
    `dealer_service_appointment_id` BIGINT COMMENT 'Unique identifier for the dealer_service_appointment data product (auto-inserted pre-linking).',
    `aftersales_service_appointment_id` BIGINT COMMENT 'Foreign key linking to aftersales.service_appointment. Business justification: Business process: Dealer DMS schedules service appointments; aftersales processes them. Linking ensures appointment sync for parts, labor, and warranty tracking.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Service Appointment Optimization uses real‑time vehicle location from the connected vehicle; required for scheduling and parts readiness.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Dealer service appointments belong to a dealership; add dealership_id FK to link to dealership and remove redundant dealer_id column.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Service appointment scheduling needs to associate the customer (party) with the appointment for service history and follow‑up.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Service appointments are assigned to a service advisor; required for labor costing and service KPI dashboards.',
    `test_event_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_test_event. Business justification: Service appointments that include emissions or safety testing are recorded as compliance test events; linking captures that relationship.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Service appointment scheduling must reference the specific vehicle VIN to allocate resources and track service history.',
    CONSTRAINT pk_dealer_service_appointment PRIMARY KEY(`dealer_service_appointment_id`)
) COMMENT 'Scheduled service appointments at a dealership for vehicle maintenance, warranty repair, recall service, or customer-pay work. Tracks appointment date/time, customer, VIN, service type, advisor assigned, estimated duration, appointment status (scheduled, checked-in, in-progress, completed, no-show), and transportation option (loaner, shuttle, wait). Sourced from CDK Global DMS service scheduling module.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` (
    `dealer_repair_order_id` BIGINT COMMENT 'Unique identifier for the dealer_repair_order data product (auto-inserted pre-linking).',
    `aftersales_repair_order_id` BIGINT COMMENT 'Foreign key linking to aftersales.repair_order. Business justification: Process: Dealer creates a repair order in DMS; it must reference the central aftersales repair order for warranty validation and labor costing.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Repair Order Diagnostic Integration pulls live diagnostic data from the connected vehicle to streamline repair workflow.',
    `maintenance_order_id` BIGINT COMMENT 'Foreign key linking to asset.maintenance_order. Business justification: Dealer repair orders are executed using the plants maintenance order system, enabling unified cost, warranty, and downtime analysis.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Repair orders must be linked to the owning customer for warranty claim processing and regulatory reporting.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Repair orders must record the technician performing work for warranty compliance and labor allocation.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Repair orders must be tied to the VIN registry to manage warranty repairs and parts usage per vehicle.',
    CONSTRAINT pk_dealer_repair_order PRIMARY KEY(`dealer_repair_order_id`)
) COMMENT 'Detailed repair order (RO) record for each vehicle service event at a dealership. Captures RO number, open/close dates, VIN, mileage-in, complaint/cause/correction (3C), labor operations, technician assignments, parts consumed, warranty vs customer-pay vs internal split, total labor hours, total parts cost, and RO status. Core operational record for dealer service operations sourced from CDK Global DMS.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` (
    `dealer_incentive_program_id` BIGINT COMMENT 'Unique surrogate identifier for the OEM-sponsored dealer incentive program record in the Databricks Silver Layer.',
    `aftersales_nameplate_id` BIGINT COMMENT '',
    `sales_incentive_program_id` BIGINT COMMENT 'SSOT reference to sales.sales_incentive_program (cross-domain duplicate reconciliation; sales designated SSOT owner for incentive_program).',
    `vehicle_program_id` BIGINT COMMENT 'add column vehicle_program_id (BIGINT) with FK to engineering.vehicle_program.vehicle_program_id - dealer incentive programs target specific vehicle programs',
    `announcement_date` DATE COMMENT 'Date on which the incentive program was formally announced to the dealer network via the dealer portal or official OEM communications. Precedes effective_start_date to allow dealer preparation.',
    `approved_by` STRING COMMENT 'Name or employee ID of the OEM finance or sales leadership authority who formally approved this incentive program. Required for SOX compliance and internal audit purposes.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the incentive program was formally approved by OEM finance and sales leadership, transitioning from draft to active status. Required for SOX compliance audit trail.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the incentive program record was first created in the OEM system of record (Salesforce Automotive Cloud or SAP S/4HANA). Formatted as yyyy-MM-ddTHH:mm:ss.SSSXXX per enterprise data standards.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts in this incentive program (e.g., USD, CAD, EUR, MXN). Supports multi-market OEM operations.. Valid values are `^[A-Z]{3}$`',
    `dealer_tier_eligibility` STRING COMMENT 'Specifies which dealer performance tier classification is eligible to participate in this program. Platinum/Gold/Silver/Bronze tiers are OEM-assigned based on prior-year sales volume and CSI scores. All indicates no tier restriction.. Valid values are `all|platinum|gold|silver|bronze`',
    `dealer_type_eligibility` STRING COMMENT 'Restricts program participation to specific dealer ownership models: franchise dealers, OEM-owned stores, or independent dealers. All applies to both OEM-owned and independent franchise dealer models.. Valid values are `all|franchise|oem_owned|independent`',
    `dms_program_reference` STRING COMMENT 'The corresponding program identifier as recorded in CDK Global DMS used by dealer locations. Enables reconciliation between OEM master incentive records and dealer-side DMS reporting.. Valid values are `^[A-Z0-9_-]{1,50}$`',
    `effective_end_date` DATE COMMENT 'Calendar date on which the incentive program measurement period closes and no further dealer performance accrual is accepted. Nullable for open-ended programs.',
    `effective_start_date` DATE COMMENT 'Calendar date on which the incentive program becomes active and dealers begin accruing credit toward performance tiers. Aligns with the measurement period start.',
    `eligible_dealer_count` STRING COMMENT 'Number of dealer locations determined to be eligible for participation in this incentive program at the time of program launch. Used for budget planning and program reach analysis by OEM sales operations.',
    `eligible_nameplates` STRING COMMENT 'Pipe-delimited list of vehicle nameplates (brand/model lines) eligible for this incentive program (e.g., F-150|Mustang Mach-E|Explorer). Null if program applies to all nameplates. Managed in Salesforce Automotive Cloud vehicle catalog.',
    `eligible_powertrain_types` STRING COMMENT 'Powertrain technology types eligible for this program. ICE (Internal Combustion Engine), EV (Electric Vehicle), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), or all. Critical for EV adoption incentive programs aligned with CAFE and EPA compliance targets.. Valid values are `ICE|EV|HEV|PHEV|all`',
    `floor_plan_rate_pct` DECIMAL(18,2) COMMENT 'For floor plan assistance programs, the percentage of dealer inventory financing cost subsidized by the OEM. Expressed as an annual percentage rate (APR) subsidy. Null for non-floor-plan program types.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the incentive program record in the source system. Used for incremental data pipeline processing and audit trail in the Databricks Silver Layer.',
    `max_payout_amount` DECIMAL(18,2) COMMENT 'The maximum total monetary payout a single dealer can earn under this incentive program during the measurement period. Acts as a cap to control OEM financial exposure. Null if no cap is defined.',
    `measurement_period_type` STRING COMMENT 'Defines the cadence over which dealer performance is measured for incentive qualification. Monthly and quarterly are most common for volume bonuses; annual for loyalty programs; custom for special campaigns.. Valid values are `monthly|quarterly|annual|custom`',
    `min_dealer_tenure_months` STRING COMMENT 'Minimum number of months a dealer must have been an active franchisee to be eligible for this program. Ensures new dealers meet a baseline operational maturity requirement.',
    `model_year` STRING COMMENT 'The vehicle Model Year (MY) to which this incentive program applies. Restricts eligible vehicles to a specific MY production cycle (e.g., MY2024, MY2025). Null if program applies across all model years.. Valid values are `^(19|20)d{2}$`',
    `oem_program_sponsor` STRING COMMENT 'Name or organizational unit of the OEM department sponsoring and funding this incentive program (e.g., North America Sales Operations, EV Business Unit, Truck Division). Used for internal cost allocation.',
    `payout_date` DATE COMMENT 'Scheduled calendar date on which OEM processes and disburses earned incentive payments to qualifying dealers. May differ from effective_end_date due to reconciliation periods.',
    `payout_structure_type` STRING COMMENT 'Defines how the incentive payout is calculated. Flat bonus: fixed dollar amount per tier. Per unit: dollar amount multiplied by units sold. Percentage of MSRP (Manufacturer Suggested Retail Price): payout as a percentage of vehicle MSRP. Percentage of invoice: payout as a percentage of dealer invoice price.. Valid values are `flat_bonus|per_unit|percentage_of_msrp|percentage_of_invoice`',
    `performance_metric` STRING COMMENT 'The primary KPI used to measure dealer performance for this incentive program. Units sold for volume bonuses; NPS (Net Promoter Score) or CSAT score for satisfaction bonuses; EV units sold for EV adoption programs; PDI (Pre-Delivery Inspection) compliance rate for quality programs. [ENUM-REF-CANDIDATE: units_sold|nps_score|csat_score|ev_units_sold|market_share_pct|pdi_compliance_rate|revenue|floor_plan_days — promote to reference product]. Valid values are `units_sold|nps_score|csat_score|ev_units_sold|market_share_pct|pdi_compliance_rate`',
    `program_code` STRING COMMENT 'Externally-known alphanumeric code assigned by OEM regional sales operations to uniquely identify the incentive program across systems including Salesforce Automotive Cloud and CDK Global DMS.. Valid values are `^[A-Z0-9_-]{3,30}$`',
    `program_description` STRING COMMENT 'Detailed narrative description of the program objectives, eligibility rules, and payout mechanics as communicated to the dealer network. Sourced from OEM regional sales operations documentation.',
    `program_manager_name` STRING COMMENT 'Full name of the OEM regional sales operations manager responsible for administering this incentive program. Used for dealer escalation and program governance.',
    `program_name` STRING COMMENT 'Human-readable name of the dealer incentive program (e.g., Q3 2024 EV Adoption Bonus, Stair-Step Volume Bonus – Truck MY2024). Used in dealer communications and DMS reporting.',
    `program_status` STRING COMMENT 'Current lifecycle state of the incentive program. Draft: under design by OEM regional sales ops. Active: open for dealer participation and accrual. Suspended: temporarily paused. Closed: measurement period ended, payouts being processed. Cancelled: terminated before completion.. Valid values are `draft|active|suspended|closed|cancelled`',
    `program_type` STRING COMMENT 'Classification of the incentive program structure. Volume bonus rewards unit sales thresholds; stair-step provides escalating payouts per tier; CSAT bonus rewards customer satisfaction scores; EV adoption incentivizes electric vehicle sales; floor plan assistance subsidizes dealer inventory financing costs; market representation rewards geographic coverage. [ENUM-REF-CANDIDATE: volume_bonus|stair_step|csat_bonus|ev_adoption|floor_plan_assistance|market_representation|loyalty_retention|conquest — promote to reference product]. Valid values are `volume_bonus|stair_step|csat_bonus|ev_adoption|floor_plan_assistance|market_representation`',
    `region_code` STRING COMMENT 'OEM-defined regional sales territory code identifying the geographic scope of the incentive program (e.g., NE, SE, MW, SW, W, NATIONAL). Managed by OEM regional sales operations.. Valid values are `^[A-Z]{2,10}$`',
    `requires_pdi_compliance` BOOLEAN COMMENT 'Indicates whether the dealer must maintain a minimum PDI (Pre-Delivery Inspection) compliance rate as a prerequisite for incentive eligibility. True enforces PDI compliance gating; False means PDI compliance is not a condition.',
    `requires_training_certification` BOOLEAN COMMENT 'Indicates whether dealer sales or service staff must hold current OEM-mandated training certifications (e.g., EV product training, ADAS certification) as an eligibility prerequisite for this program.',
    `retroactive_flag` BOOLEAN COMMENT 'Indicates whether the stair-step payout structure applies retroactively to all units sold once a higher tier is achieved (True), or only incrementally to units sold above each threshold (False). Critical for stair-step program financial modeling.',
    `salesforce_program_reference` STRING COMMENT 'The Salesforce Automotive Cloud record ID for this incentive program. Enables bi-directional synchronization between the Databricks Silver Layer and Salesforce CRM for dealer portal visibility.. Valid values are `^[a-zA-Z0-9]{15,18}$`',
    `stackable_flag` BOOLEAN COMMENT 'Indicates whether this incentive program can be combined (stacked) with other concurrent OEM incentive programs for the same dealer and vehicle. True allows stacking; False means the program is mutually exclusive with other programs.',
    `terms_version` STRING COMMENT 'Version identifier of the program terms and conditions document (e.g., v1.0, v2.1). Tracks amendments to program rules and ensures dealers are evaluated against the correct version of terms.. Valid values are `^vd+.d+$`',
    `tier1_payout_amount` DECIMAL(18,2) COMMENT 'Monetary payout amount (in program currency) awarded to dealers achieving Tier 1 performance threshold. May represent a flat bonus or per-unit amount depending on payout_structure_type.',
    `tier1_threshold` DECIMAL(18,2) COMMENT 'Minimum performance metric value a dealer must achieve to qualify for Tier 1 (entry-level) payout. Units depend on performance_metric (e.g., number of vehicles sold, NPS score points).',
    `tier2_payout_amount` DECIMAL(18,2) COMMENT 'Monetary payout amount (in program currency) awarded to dealers achieving Tier 2 performance threshold. Null if program has fewer than 2 tiers.',
    `tier2_threshold` DECIMAL(18,2) COMMENT 'Minimum performance metric value a dealer must achieve to qualify for Tier 2 payout. Must be greater than tier1_threshold. Null if program has fewer than 2 tiers.',
    `tier3_payout_amount` DECIMAL(18,2) COMMENT 'Monetary payout amount (in program currency) awarded to dealers achieving Tier 3 performance threshold. Null if program has fewer than 3 tiers.',
    `tier3_threshold` DECIMAL(18,2) COMMENT 'Minimum performance metric value a dealer must achieve to qualify for Tier 3 payout. Must be greater than tier2_threshold. Null if program has fewer than 3 tiers.',
    `tier_count` STRING COMMENT 'Number of performance tiers defined within this incentive program (e.g., 3 for Bronze/Silver/Gold, 5 for stair-step programs). Determines the granularity of the payout structure.',
    `total_program_budget` DECIMAL(18,2) COMMENT 'Total OEM-allocated budget for this incentive program across all participating dealers. Used by OEM regional sales operations for financial planning and CapEx/OpEx tracking in SAP S/4HANA CO.',
    CONSTRAINT pk_dealer_incentive_program PRIMARY KEY(`dealer_incentive_program_id`)
) COMMENT 'OEM-sponsored dealer incentive and bonus programs including volume bonuses, stair-step programs, customer satisfaction bonuses, EV adoption incentives, and floor plan assistance. Defines program name, type, eligible nameplates, MY, performance tiers, payout structure, measurement period, and eligibility criteria. Managed by OEM regional sales operations.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` (
    `dealer_incentive_claim_id` BIGINT COMMENT 'Unique system-generated identifier for each dealer incentive claim record. Primary key for the incentive_claim data product.',
    `dealer_incentive_program_id` BIGINT COMMENT 'Reference to the OEM incentive program against which this claim is submitted. Links to the incentive program master record.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealer submitting this incentive claim. Links to the dealer master record in the dealer domain.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the OEM staff member who reviewed and approved or rejected the claim. Supports audit trail, segregation of duties compliance, and workload reporting for the dealer incentive operations team.',
    `sales_incentive_claim_id` BIGINT COMMENT 'SSOT reference to sales.sales_incentive_claim (cross-domain duplicate reconciliation; sales designated SSOT owner for incentive_claim).',
    `accrual_posted` BOOLEAN COMMENT 'Indicates whether a financial accrual has been posted in SAP FI for this incentive claim liability. True = accrual posted; False = accrual not yet posted. Used for period-end financial close management and EBITDA reporting accuracy.',
    `adjustment_amount` DECIMAL(18,2) COMMENT 'Net monetary adjustment applied by the OEM during claim review, representing the difference between claimed_amount and approved_amount. A negative value indicates a reduction; positive indicates an upward correction. Supports audit trail and dispute resolution.',
    `adjustment_reason` STRING COMMENT 'Reason code explaining why the approved_amount differs from the claimed_amount. Populated by the OEM reviewer when an adjustment is applied. [ENUM-REF-CANDIDATE: ineligible_units|duplicate_claim|missing_evidence|calculation_error|program_cap_exceeded|other — promote to reference product]. Valid values are `ineligible_units|duplicate_claim|missing_evidence|calculation_error|program_cap_exceeded|other`',
    `approved_amount` DECIMAL(18,2) COMMENT 'Monetary amount approved by the OEM after review and validation of the dealers claim. May differ from claimed_amount due to adjustments, disallowed units, or partial approvals. This is the amount committed for payment processing in SAP FI.',
    `approved_units` STRING COMMENT 'Number of vehicle units or qualifying transactions validated and approved by the OEM reviewer. May be less than claimed_units if some units are found ineligible during audit. Used to calculate the approved_amount for volume-based programs.',
    `claim_number` STRING COMMENT 'Externally visible, human-readable unique claim reference number assigned at submission. Used by dealers and OEM finance teams to track and reference the claim across systems including CDK Global DMS and SAP FI.. Valid values are `^CLM-[0-9]{4}-[0-9]{6}$`',
    `claim_period_end_date` DATE COMMENT 'End date of the performance or sales period covered by this incentive claim. Defines the close of the measurement window. Together with claim_period_start_date, establishes the claim period boundary for audit and reconciliation.',
    `claim_period_start_date` DATE COMMENT 'Start date of the performance or sales period covered by this incentive claim. Defines the beginning of the measurement window for which the dealer is claiming the incentive.',
    `claim_status` STRING COMMENT 'Current workflow state of the incentive claim through the OEM review and payment lifecycle. Valid states: submitted (initial dealer submission), under_review (OEM audit in progress), approved (claim validated and approved for payment), rejected (claim denied), paid (payment disbursed via SAP FI), cancelled (withdrawn by dealer or voided by OEM).. Valid values are `submitted|under_review|approved|rejected|paid|cancelled`',
    `claim_type` STRING COMMENT 'Category of incentive claim being submitted, reflecting the nature of the OEM incentive program. [ENUM-REF-CANDIDATE: volume_bonus|retail_incentive|floor_plan|marketing_support|customer_satisfaction|parts_sales|service_absorption — promote to reference product]',
    `claimed_amount` DECIMAL(18,2) COMMENT 'Gross monetary amount claimed by the dealer against the incentive program, expressed in the transaction currency. This is the dealer-submitted figure prior to OEM review and approval. Used for financial accrual and liability estimation.',
    `claimed_metric_unit` STRING COMMENT 'Unit of measure for the claimed_metric_value field, indicating how the performance metric is expressed (e.g., units for vehicle count, percentage for service absorption rate, score for NPS/CSI, amount for revenue-based claims).. Valid values are `units|percentage|score|amount_usd|amount_local`',
    `claimed_metric_value` DECIMAL(18,2) COMMENT 'The quantitative performance metric value being claimed by the dealer, applicable for non-unit-based programs such as customer satisfaction scores (NPS), service absorption rates, or parts sales amounts. Complements claimed_units for metric-driven incentive types.',
    `claimed_units` STRING COMMENT 'Number of vehicle units or qualifying transactions the dealer is claiming against the incentive program for the claim period. Applicable for volume-based incentive programs such as volume bonus and retail incentive programs.',
    `cost_center_code` STRING COMMENT 'SAP CO cost center code to which the incentive payout is charged. Used for internal cost allocation and management accounting of dealer incentive expenditure by brand, region, or program type.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the market in which the dealer operates and the claim is filed. Supports multi-market OEM operations and ensures correct regulatory and tax treatment of incentive payouts.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the incentive claim record was first created in the system. Represents the audit creation time (distinct from submission_date which is the business event date). Used for data lineage, audit trail, and Silver layer ingestion tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this claim (claimed_amount, approved_amount, paid_amount). Supports multi-currency dealer networks operating in different markets.. Valid values are `^[A-Z]{3}$`',
    `dealer_contact_email` STRING COMMENT 'Email address of the dealer representative responsible for this claim. Used for claim status notifications, evidence requests, and dispute correspondence. Classified as confidential PII per GDPR and applicable privacy regulations.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `dealer_contact_name` STRING COMMENT 'Name of the dealer-side representative who submitted or is responsible for this incentive claim. Used for communication, follow-up, and audit correspondence between OEM and dealer.',
    `dispute_date` DATE COMMENT 'Date on which the dealer formally raised a dispute against the OEMs claim decision. Populated only when dispute_flag is True. Used to track dispute aging and compliance with contractual dispute resolution timelines.',
    `dispute_flag` BOOLEAN COMMENT 'Indicates whether the dealer has formally disputed the OEMs decision on this claim (e.g., disputed rejection or adjusted amount). True = claim is under dispute; False = no dispute raised. Triggers escalation workflow in Salesforce Automotive Cloud.',
    `dispute_resolution_notes` STRING COMMENT 'Free-text notes documenting the outcome and resolution of a dealer dispute on this claim. Captures the agreed resolution, any revised approved amount, and the basis for the final decision. Supports audit trail and dealer relationship management.',
    `dms_claim_reference` STRING COMMENT 'Claim reference number as recorded in the dealers CDK Global DMS system. Enables cross-system reconciliation between the OEMs incentive claim record and the dealers own DMS records. Critical for audit and dispute resolution.',
    `evidence_document_ref` STRING COMMENT 'Reference identifier or URL pointing to the supporting evidence package submitted by the dealer with the claim (e.g., sales invoices, PDI records, customer satisfaction survey results, parts purchase orders). Stored in the document management system linked from CDK Global DMS or Salesforce Automotive Cloud.',
    `evidence_verified` BOOLEAN COMMENT 'Indicates whether the OEM reviewer has verified the supporting evidence submitted with the claim. True = evidence reviewed and confirmed valid; False = evidence not yet verified or found insufficient. Used to gate claim approval workflow.',
    `gl_account_code` STRING COMMENT 'SAP FI general ledger account code used to classify the incentive payout for financial reporting. Ensures correct P&L treatment of dealer incentive costs in accordance with IFRS 15 and OEM chart of accounts.',
    `model_year` STRING COMMENT 'The vehicle model year (MY) associated with the units or transactions being claimed. Used to align incentive claims with specific model year programs and OEM production cycles (e.g., MY2024, MY2025).',
    `paid_amount` DECIMAL(18,2) COMMENT 'Actual monetary amount disbursed to the dealer for this claim. May differ from approved_amount due to netting, offsets, or partial payment arrangements. Populated upon payment confirmation from SAP FI.',
    `payment_date` DATE COMMENT 'Date on which the approved incentive amount was disbursed to the dealers bank account. Populated upon payment confirmation from SAP FI. Used for cash flow reporting and dealer payment aging analysis.',
    `payment_reference` STRING COMMENT 'SAP FI payment document number or bank transfer reference assigned when the approved claim is paid. Links the incentive claim to the corresponding financial transaction in SAP FI Accounts Payable for reconciliation and audit.',
    `powertrain_type` STRING COMMENT 'Powertrain technology category of the vehicles covered by this claim. Values: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), EV (Electric Vehicle), FCEV (Fuel Cell Electric Vehicle). Used to track EV/electrification incentive program uptake and CAFE compliance reporting.. Valid values are `ICE|HEV|PHEV|EV|FCEV`',
    `program_quarter` STRING COMMENT 'Fiscal quarter of the OEM incentive program period covered by this claim (Q1–Q4). Used for quarterly accrual reporting, dealer performance benchmarking, and incentive budget variance analysis.. Valid values are `Q1|Q2|Q3|Q4`',
    `program_year` STRING COMMENT 'Fiscal or calendar year of the OEM incentive program under which this claim is filed. Used to segregate claims by annual program cycle for budget tracking, accrual management, and year-end financial close in SAP FI.',
    `region_code` STRING COMMENT 'OEM sales region or zone code to which the submitting dealer belongs. Used for regional incentive program management, territory-based performance benchmarking, and regional finance reporting.',
    `rejection_reason` STRING COMMENT 'Free-text or coded explanation provided by the OEM reviewer when a claim is rejected (claim_status = rejected). Documents the specific grounds for denial to support dealer dispute resolution and compliance with IATF 16949 dealer management requirements.',
    `review_date` DATE COMMENT 'Date on which the OEM completed the review of the incentive claim and updated the claim_status to approved or rejected. Used for SLA tracking of claim processing turnaround time.',
    `sap_fi_document_number` STRING COMMENT 'SAP FI accounting document number generated when the incentive claim liability or payment is posted in the general ledger. Provides direct traceability between the incentive claim and the SAP FI financial posting for audit and reconciliation purposes.',
    `submission_date` DATE COMMENT 'Calendar date on which the dealer formally submitted the incentive claim to the OEM. This is the principal business event date for the claim lifecycle and is used for period-end cut-off and aging analysis.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the incentive claim record. Tracks the last modification for change data capture (CDC), audit trail, and Silver layer incremental processing in the Databricks Lakehouse.',
    `vehicle_line_code` STRING COMMENT 'OEM product line or nameplate code identifying the vehicle model family associated with this claim (e.g., F-150, Silverado, Model 3). Used to segment incentive claims by vehicle line for program performance analysis and brand-level reporting.',
    CONSTRAINT pk_dealer_incentive_claim PRIMARY KEY(`dealer_incentive_claim_id`)
) COMMENT 'Individual dealer claims submitted against OEM incentive programs. Tracks claim submission date, program, claim period, claimed units or metric, supporting evidence, claim status (submitted, under review, approved, rejected, paid), approved amount, and payment reference. Integrates with SAP FI for payout processing.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` (
    `performance_scorecard_id` BIGINT COMMENT 'Unique identifier for the dealer performance scorecard record.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealer being evaluated in this scorecard.',
    `performance_dealership_id` BIGINT COMMENT 'Reference to the dealer being evaluated in this scorecard.',
    `comments` STRING COMMENT 'Additional notes or commentary from the OEM regarding the dealers performance during this period.',
    `composite_score` DECIMAL(18,2) COMMENT 'The overall weighted composite performance score combining all KPI categories (sales, service, parts, customer satisfaction, facility standards) used for franchise compliance and incentive eligibility.',
    `composite_score_benchmark` DECIMAL(18,2) COMMENT 'The minimum composite score required for franchise compliance and incentive program eligibility.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this scorecard record was first created in the system.',
    `csi_benchmark` DECIMAL(18,2) COMMENT 'The target or industry benchmark CSI score the dealer is expected to meet or exceed.',
    `csi_score` DECIMAL(18,2) COMMENT 'The Customer Satisfaction Index score measuring overall customer satisfaction with sales and service experience, typically on a scale of 0-100 or 0-1000 depending on OEM methodology.',
    `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for all monetary amounts in this scorecard.. Valid values are `^[A-Z]{3}$`',
    `days_supply` STRING COMMENT 'The average number of days of inventory on hand at the dealer based on current sales rate.',
    `dms_integration_source` STRING COMMENT 'The Dealer Management System from which raw performance data was extracted for this scorecard.. Valid values are `CDK_Global|Reynolds_Reynolds|Dealertrack|ADP|Other`',
    `facility_standards_score` DECIMAL(18,2) COMMENT 'The score measuring dealer compliance with OEM facility image and standards requirements (showroom, service bays, signage, etc.).',
    `fiscal_quarter` STRING COMMENT 'The fiscal quarter (1-4) to which this scorecard period belongs, if applicable.',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this scorecard period belongs.',
    `franchise_compliance_status` STRING COMMENT 'The dealers franchise agreement compliance status based on this scorecards performance results.. Valid values are `compliant|non_compliant|probation|warning`',
    `incentive_eligibility_flag` BOOLEAN COMMENT 'Indicates whether the dealer met the minimum performance thresholds to qualify for OEM incentive programs during this scorecard period.',
    `inventory_turn_rate` DECIMAL(18,2) COMMENT 'The number of times the dealers new vehicle inventory was sold and replaced during the scorecard period, calculated as sales divided by average inventory.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this scorecard record was last updated.',
    `market_share_pct` DECIMAL(18,2) COMMENT 'The dealers share of total new vehicle sales in their assigned territory or market area during the scorecard period.',
    `new_vehicle_sales_actual` STRING COMMENT 'The actual number of new vehicles sold by the dealer during the scorecard period.',
    `new_vehicle_sales_attainment_pct` DECIMAL(18,2) COMMENT 'The percentage of the new vehicle sales objective achieved by the dealer (actual/objective * 100).',
    `new_vehicle_sales_objective` STRING COMMENT 'The target number of new vehicles the dealer was expected to sell during the scorecard period.',
    `nps_benchmark` DECIMAL(18,2) COMMENT 'The target or industry benchmark NPS score the dealer is expected to meet or exceed.',
    `nps_score` DECIMAL(18,2) COMMENT 'The Net Promoter Score measuring customer loyalty and likelihood to recommend the dealer, calculated as percentage of promoters minus percentage of detractors.',
    `parts_fill_rate_pct` DECIMAL(18,2) COMMENT 'The percentage of parts orders fulfilled from dealer inventory without backorder during the scorecard period.',
    `parts_revenue_actual` DECIMAL(18,2) COMMENT 'The actual parts department revenue generated during the scorecard period.',
    `parts_revenue_objective` DECIMAL(18,2) COMMENT 'The target parts department revenue for the scorecard period.',
    `performance_tier` STRING COMMENT 'The performance tier classification assigned to the dealer based on composite score and key metrics.. Valid values are `platinum|gold|silver|bronze|standard`',
    `period_type` STRING COMMENT 'The frequency of the scorecard evaluation period.. Valid values are `monthly|quarterly|annual`',
    `published_date` DATE COMMENT 'The date this scorecard was officially published and communicated to the dealer.',
    `reviewer_name` STRING COMMENT 'The name of the OEM regional manager or analyst who reviewed and approved this scorecard.',
    `scorecard_period_end_date` DATE COMMENT 'The last day of the evaluation period covered by this scorecard.',
    `scorecard_period_start_date` DATE COMMENT 'The first day of the evaluation period covered by this scorecard (monthly or quarterly).',
    `scorecard_status` STRING COMMENT 'The current status of this scorecard record in its lifecycle.. Valid values are `draft|published|final|revised`',
    `service_absorption_rate_pct` DECIMAL(18,2) COMMENT 'The percentage of fixed operations expenses covered by service and parts gross profit, a key profitability metric for dealer operations.',
    `service_revenue_actual` DECIMAL(18,2) COMMENT 'The actual service department revenue generated during the scorecard period.',
    `service_revenue_objective` DECIMAL(18,2) COMMENT 'The target service department revenue for the scorecard period.',
    `training_compliance_pct` DECIMAL(18,2) COMMENT 'The percentage of required OEM training programs completed by dealer staff during the scorecard period.',
    `used_vehicle_sales_actual` STRING COMMENT 'The actual number of used vehicles sold by the dealer during the scorecard period.',
    `used_vehicle_sales_attainment_pct` DECIMAL(18,2) COMMENT 'The percentage of the used vehicle sales objective achieved by the dealer.',
    `used_vehicle_sales_objective` STRING COMMENT 'The target number of used vehicles the dealer was expected to sell during the scorecard period.',
    `warranty_claim_approval_rate_pct` DECIMAL(18,2) COMMENT 'The percentage of warranty claims submitted by the dealer that were approved by the OEM during the scorecard period.',
    CONSTRAINT pk_performance_scorecard PRIMARY KEY(`performance_scorecard_id`)
) COMMENT 'Periodic (monthly/quarterly) dealer performance scorecard capturing KPIs across sales, service, parts, customer satisfaction, and facility standards. Tracks new vehicle sales vs objective, used vehicle sales, service absorption rate, CSI (Customer Satisfaction Index) score, NPS (Net Promoter Score), parts fill rate, and overall composite score. Used for franchise compliance and incentive eligibility determination.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` (
    `csi_survey_id` BIGINT COMMENT 'Unique identifier for the CSI survey response record.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer location where the customer interaction occurred that triggered this survey.',
    `csi_dealership_id` BIGINT COMMENT 'Identifier of the dealer location where the customer interaction occurred that triggered this survey.',
    `dealer_order_id` BIGINT COMMENT 'Identifier of the dealer order associated with this survey, if the survey is related to a sales transaction.',
    `csi_repair_order_id` BIGINT COMMENT 'Identifier of the repair order associated with this survey, if the survey is related to a service transaction.',
    `individual_id` BIGINT COMMENT 'Identifier of the customer who completed the survey.',
    `party_id` BIGINT COMMENT 'Identifier of the customer who completed the survey.',
    `vin_registry_id` BIGINT COMMENT 'Identifier of the vehicle associated with the customer interaction that triggered this survey.',
    `complaint_category` STRING COMMENT 'Category code classifying the nature of the customer complaint if complaint_flag is True (e.g., service_quality, pricing, staff_behavior, facility_issue).',
    `complaint_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) whether the survey response contains a customer complaint requiring follow-up action.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this survey record was first created in the system.',
    `days_to_response` STRING COMMENT 'Number of days between the customer interaction date and the survey completion date.',
    `dealer_performance_impact_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) whether this survey response will be included in the dealers official performance scorecard and franchise compliance review.',
    `delivery_process_score` DECIMAL(18,2) COMMENT 'Customer satisfaction score for the vehicle delivery process, applicable to sales satisfaction surveys.',
    `facility_cleanliness_score` DECIMAL(18,2) COMMENT 'Customer satisfaction score for the cleanliness and appearance of the dealership facility.',
    `follow_up_completed_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) whether the required follow-up action has been completed.',
    `follow_up_completion_date` DATE COMMENT 'Date when the follow-up action was completed, if applicable.',
    `follow_up_required_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) whether the survey response requires dealer or OEM follow-up contact with the customer.',
    `interaction_date` DATE COMMENT 'Date of the original customer interaction (sales delivery, service completion, etc.) that triggered this survey.',
    `market_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code identifying the geographic market where the survey was conducted.. Valid values are `^[A-Z]{3}$`',
    `nps_category` STRING COMMENT 'Classification of the customer based on NPS score: promoter (9-10), passive (7-8), or detractor (0-6).. Valid values are `promoter|passive|detractor`',
    `nps_score` STRING COMMENT 'Net Promoter Score indicating customer likelihood to recommend the dealer or brand, typically on a 0-10 scale.',
    `oem_program_compliant_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) whether the survey response meets OEM CSI program compliance thresholds for dealer performance evaluation.',
    `overall_satisfaction_score` DECIMAL(18,2) COMMENT 'Overall customer satisfaction score, typically on a scale (e.g., 1-5, 1-10, or 0-100) as defined by the OEM CSI program.',
    `pricing_transparency_score` DECIMAL(18,2) COMMENT 'Customer satisfaction score for the transparency and fairness of pricing communicated during the transaction.',
    `problem_resolution_score` DECIMAL(18,2) COMMENT 'Customer satisfaction score for how effectively any issues or concerns were resolved.',
    `response_channel` STRING COMMENT 'Channel through which the customer submitted the survey response (email, phone, SMS, web portal, mobile app, postal mail, or in-person at dealership). [ENUM-REF-CANDIDATE: email|phone|sms|web|mobile_app|mail|in_person — 7 candidates stripped; promote to reference product]',
    `sales_consultant_score` DECIMAL(18,2) COMMENT 'Customer satisfaction score for the sales consultant interaction, applicable to sales satisfaction surveys.',
    `sales_region_code` STRING COMMENT 'Code identifying the OEM sales region or district to which the dealer belongs for regional performance aggregation.',
    `sentiment_category` STRING COMMENT 'Categorical classification of the verbatim comment sentiment: positive, neutral, negative, or mixed.. Valid values are `positive|neutral|negative|mixed`',
    `sentiment_score` DECIMAL(18,2) COMMENT 'Automated sentiment analysis score derived from the verbatim comment, typically ranging from -1 (negative) to +1 (positive).',
    `service_advisor_score` DECIMAL(18,2) COMMENT 'Customer satisfaction score for the service advisor interaction, applicable to service satisfaction surveys.',
    `service_quality_score` DECIMAL(18,2) COMMENT 'Customer satisfaction score for the quality of service work performed, applicable to service satisfaction surveys.',
    `service_timeliness_score` DECIMAL(18,2) COMMENT 'Customer satisfaction score for the timeliness of service completion, applicable to service satisfaction surveys.',
    `staff_courtesy_score` DECIMAL(18,2) COMMENT 'Customer satisfaction score for the courtesy and professionalism of dealership staff.',
    `survey_completion_percentage` DECIMAL(18,2) COMMENT 'Percentage of survey questions answered by the customer, indicating survey completion rate (0-100).',
    `survey_date` DATE COMMENT 'Date when the customer completed the survey.',
    `survey_language_code` STRING COMMENT 'Two-letter ISO 639-1 language code indicating the language in which the survey was presented and completed.. Valid values are `^[a-z]{2}$`',
    `survey_program_code` STRING COMMENT 'Code identifying the specific OEM CSI survey program or campaign under which this survey was administered.',
    `survey_status` STRING COMMENT 'Status of the survey response: completed (fully answered), partial (incomplete), abandoned (started but not submitted), or invalid (failed validation).. Valid values are `completed|partial|abandoned|invalid`',
    `survey_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the customer submitted the survey response.',
    `survey_type` STRING COMMENT 'Type of CSI survey indicating the customer interaction being evaluated (sales, service, delivery, parts, general, or Pre-Delivery Inspection).. Valid values are `sales_satisfaction|service_satisfaction|delivery_satisfaction|parts_satisfaction|general_satisfaction|pdi_satisfaction`',
    `survey_vendor_code` STRING COMMENT 'Code identifying the third-party vendor or platform that administered the survey (e.g., Medallia, Qualtrics, internal OEM system).',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this survey record was last updated in the system.',
    `vehicle_condition_score` DECIMAL(18,2) COMMENT 'Customer satisfaction score for the condition of the vehicle at delivery or service completion.',
    `verbatim_comment` STRING COMMENT 'Free-text comment provided by the customer describing their experience, concerns, or suggestions.',
    `vin` STRING COMMENT '17-character Vehicle Identification Number of the vehicle associated with this survey response.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_csi_survey PRIMARY KEY(`csi_survey_id`)
) COMMENT 'Customer Satisfaction Index (CSI) survey responses collected post-sales and post-service at the dealership level. Captures survey type (sales satisfaction, service satisfaction), survey date, response channel, individual question scores, verbatim comments, overall satisfaction score, and OEM program compliance flag. Feeds dealer performance scorecards and franchise compliance reviews.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` (
    `service_capacity_id` BIGINT COMMENT 'Unique identifier for the service capacity configuration record. Primary key.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealer location that owns this service capacity configuration.',
    `service_dealership_id` BIGINT COMMENT 'Reference to the dealer location that owns this service capacity configuration.',
    `a_tech_headcount` STRING COMMENT 'Number of A-level (master) technicians certified for complex diagnostics, ECU (Electronic Control Unit) programming, and advanced repair work.',
    `adas_certified_tech_count` STRING COMMENT 'Number of technicians certified for ADAS calibration, sensor diagnostics, and autonomous driving system service.',
    `adas_service_bays` STRING COMMENT 'Number of service bays equipped with ADAS (Advanced Driver Assistance Systems) calibration equipment for sensor alignment and diagnostic work.',
    `available_labor_hours_per_day` DECIMAL(18,2) COMMENT 'Total productive labor hours available per day across all technicians, calculated as (technician headcount × hours per shift × efficiency factor). Used for service appointment scheduling and capacity utilization analysis.',
    `avg_ro_cycle_time_hours` DECIMAL(18,2) COMMENT 'Average time in hours from RO (Repair Order) open to close. Used for scheduling optimization and capacity planning.',
    `b_tech_headcount` STRING COMMENT 'Number of B-level (journeyman) technicians certified for general maintenance and standard repair operations.',
    `body_shop_bays` STRING COMMENT 'Number of service bays designated for collision repair, body work, and paint operations.',
    `body_shop_tech_count` STRING COMMENT 'Number of technicians certified for collision repair, body work, and paint operations.',
    `c_tech_headcount` STRING COMMENT 'Number of C-level (apprentice) technicians performing basic maintenance tasks and assisting senior technicians.',
    `capacity_config_code` STRING COMMENT 'Business identifier for the service capacity configuration, typically used in DMS (Dealer Management System) integration and capacity planning reports.. Valid values are `^[A-Z0-9]{6,12}$`',
    `capacity_notes` STRING COMMENT 'Free-text notes regarding capacity constraints, planned expansions, seasonal adjustments, or special considerations for service scheduling.',
    `capacity_status` STRING COMMENT 'Current operational status of the service capacity configuration. Active indicates normal operations, seasonal indicates temporary capacity adjustments, reduced/expanded indicate capacity changes, under_review indicates pending capacity assessment.. Valid values are `active|inactive|seasonal|reduced|expanded|under_review`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this service capacity configuration record was first created in the system.',
    `current_capacity_utilization_pct` DECIMAL(18,2) COMMENT 'Current utilization rate of service capacity expressed as a percentage. Calculated as (actual labor hours used / available labor hours) × 100. Used for capacity planning and scheduling optimization.',
    `customer_pay_capacity_pct` DECIMAL(18,2) COMMENT 'Percentage of total service capacity allocated for customer pay (non-warranty) repair orders. Typically 60-70% of total capacity.',
    `diagnostic_equipment_level` STRING COMMENT 'Classification of diagnostic equipment capability. Basic: OBD scanners. Standard: factory scan tools. Advanced: ECU programming and ADAS calibration. Premium: full factory diagnostic suite with remote technical assistance.. Valid values are `basic|standard|advanced|premium`',
    `dms_capacity_record_reference` STRING COMMENT 'External identifier for this capacity configuration in the source DMS system. Used for data lineage and integration reconciliation.',
    `dms_system_code` STRING COMMENT 'Code identifying the DMS platform used by the dealer for service scheduling and capacity management. Primary integration point for capacity data synchronization.. Valid values are `CDK|REYNOLDS|DEALERTRACK|ADP|PBS|OTHER`',
    `effective_end_date` DATE COMMENT 'Date when this service capacity configuration expires or is superseded. Nullable for open-ended configurations.',
    `effective_start_date` DATE COMMENT 'Date when this service capacity configuration becomes effective. Used for capacity planning and scheduling optimization.',
    `ev_certified_tech_count` STRING COMMENT 'Number of technicians holding OEM (Original Equipment Manufacturer) certification for EV, HEV, and PHEV high-voltage system service and repair.',
    `ev_service_bays` STRING COMMENT 'Number of service bays equipped and certified for EV (Electric Vehicle), HEV (Hybrid Electric Vehicle), and PHEV (Plug-in Hybrid Electric Vehicle) service work.',
    `express_service_bays` STRING COMMENT 'Number of service bays designated for quick service operations such as oil changes, tire rotations, and PDI (Pre-Delivery Inspection).',
    `general_service_bays` STRING COMMENT 'Number of service bays designated for general maintenance and repair work on ICE (Internal Combustion Engine) vehicles.',
    `has_mobile_service_capability` BOOLEAN COMMENT 'Indicates whether the dealer offers mobile service capability for on-site customer vehicle service and OTA updates.',
    `hours_per_shift` DECIMAL(18,2) COMMENT 'Standard duration of each work shift in hours, typically 8.0 or 10.0 hours.',
    `internal_capacity_pct` DECIMAL(18,2) COMMENT 'Percentage of total service capacity allocated for internal work including PDI (Pre-Delivery Inspection), loaner maintenance, and dealer-owned vehicle service. Typically 10-15% of total capacity.',
    `last_capacity_review_date` DATE COMMENT 'Date of the most recent capacity assessment and configuration review. Used for capacity planning governance and audit trails.',
    `loaner_fleet_size` STRING COMMENT 'Total number of loaner vehicles available for customer use during service appointments. Used for customer satisfaction and service capacity planning.',
    `loaner_fleet_utilization_pct` DECIMAL(18,2) COMMENT 'Current utilization rate of the loaner fleet expressed as a percentage. Calculated as (loaners in use / total loaner fleet size) × 100.',
    `max_daily_appointments` STRING COMMENT 'Maximum number of service appointments that can be scheduled per day based on bay capacity, technician availability, and average repair order duration.',
    `mobile_service_technician_count` STRING COMMENT 'Number of technicians dedicated to mobile service operations. Null if mobile service is not offered.',
    `next_capacity_review_date` DATE COMMENT 'Scheduled date for the next capacity assessment and configuration review. Typically quarterly or semi-annually.',
    `operating_days_per_week` STRING COMMENT 'Number of days per week the service department operates. Typically 5 or 6 days for most dealers.',
    `parts_inventory_capacity_sqft` DECIMAL(18,2) COMMENT 'Total square footage of parts storage capacity at the dealer service location. Used for parts inventory planning and JIT (Just-in-Time) delivery optimization.',
    `shifts_per_day` STRING COMMENT 'Number of work shifts operated per day (1 for single shift, 2 for double shift operations).',
    `specialty_certifications` STRING COMMENT 'Comma-separated list of specialty certifications held by the service department, such as EV, ADAS, body shop, OBD (On-Board Diagnostics), TPMS (Tire Pressure Monitoring System), OTA (Over-the-Air Update) programming. Used for service capability assessment and customer routing.',
    `target_capacity_utilization_pct` DECIMAL(18,2) COMMENT 'Target utilization rate for optimal service department performance, typically 80-85%. Used for capacity planning and performance scorecards.',
    `total_service_bays` STRING COMMENT 'Total number of physical service bays available at the dealer service department for vehicle maintenance and repair work.',
    `total_technician_headcount` STRING COMMENT 'Total number of certified technicians employed at the dealer service department across all skill levels.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this service capacity configuration record was last modified. Used for change tracking and audit trails.',
    `warranty_work_capacity_pct` DECIMAL(18,2) COMMENT 'Percentage of total service capacity allocated for warranty and recall work. Typically 20-30% of total capacity.',
    CONSTRAINT pk_service_capacity PRIMARY KEY(`service_capacity_id`)
) COMMENT 'Dealer service department capacity configuration including number of service bays, technician headcount by skill level (A/B/C tech), available labor hours per day, specialty certifications (EV, ADAS, body shop), loaner fleet size, and current utilization rate. Used for service appointment scheduling optimization and capacity planning.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` (
    `floor_plan_id` BIGINT COMMENT 'Unique identifier for the floor plan financing record.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealer holding this floor plan financing arrangement.',
    `floor_dealership_id` BIGINT COMMENT 'Reference to the dealer holding this floor plan financing arrangement.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Floor‑plan financing is calculated per SKU to reflect cost, interest, and regulatory limits.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Floor plan financing is per‑vehicle; linking to VIN registry enables accurate interest calculation and balance tracking.',
    `account_number` STRING COMMENT 'Unique account number assigned by the financing institution to the dealers floor plan credit facility.',
    `aged_inventory_flag` BOOLEAN COMMENT 'Boolean indicator flagging vehicles that have exceeded the aging threshold defined in the floor plan agreement (typically 90, 120, or 180 days). True indicates aged inventory requiring attention.',
    `aging_threshold_days` STRING COMMENT 'Number of days after which inventory is considered aged per the floor plan agreement terms. Triggers curtailment requirements or OEM assistance programs.',
    `audit_status` STRING COMMENT 'Result status of the most recent floor plan audit. Passed indicates compliance; failed indicates discrepancies; pending indicates audit in progress; not_required indicates no audit needed; exception indicates special circumstances.. Valid values are `passed|failed|pending|not_required|exception`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this floor plan financing record was first created in the system.',
    `credit_line_amount` DECIMAL(18,2) COMMENT 'Total credit line amount approved by the financing institution for the dealers floor plan facility. Represents the maximum borrowing capacity.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts in this floor plan record (e.g., USD, EUR, CAD).. Valid values are `^[A-Z]{3}$`',
    `curtailment_amount` DECIMAL(18,2) COMMENT 'Required curtailment payment amount for aged inventory, typically a percentage of the original financed amount after a specified aging period (e.g., 90 or 120 days).',
    `curtailment_due_date` DATE COMMENT 'Scheduled date by which the dealer must make a curtailment payment (partial paydown) on aged inventory per the floor plan agreement terms.',
    `curtailment_paid_flag` BOOLEAN COMMENT 'Boolean indicator of whether the required curtailment payment has been made by the dealer. True indicates paid; False indicates outstanding.',
    `daily_interest_amount` DECIMAL(18,2) COMMENT 'Daily interest accrual amount calculated based on the outstanding balance and interest rate. Used for dealer financial health monitoring.',
    `days_in_inventory` STRING COMMENT 'Number of days the vehicle has been in dealer inventory under floor plan financing, calculated from financing start date to current date or sale date.',
    `dealer_invoice_amount` DECIMAL(18,2) COMMENT 'Original dealer invoice amount for the vehicle, typically the basis for the floor plan financed amount.',
    `default_date` DATE COMMENT 'Date when the dealer was declared in default on floor plan obligations for this vehicle. Null if no default has occurred.',
    `default_flag` BOOLEAN COMMENT 'Boolean indicator of whether the dealer has defaulted on floor plan payments for this vehicle. True indicates default; False indicates current status.',
    `dms_floor_plan_reference` STRING COMMENT 'External identifier for this floor plan record in the dealers DMS (e.g., CDK Global). Used for system integration and reconciliation.',
    `financing_end_date` DATE COMMENT 'Date when floor plan financing for this vehicle unit was terminated, either through retail sale and payoff or other resolution.',
    `financing_institution_code` STRING COMMENT 'Internal or industry-standard code identifying the financing institution for system integration and reporting.',
    `financing_institution_name` STRING COMMENT 'Name of the financial institution or captive finance company providing the floor plan credit line (e.g., OEM captive finance, third-party lender).',
    `financing_start_date` DATE COMMENT 'Date when floor plan financing for this vehicle unit commenced. Typically the date the vehicle was received into dealer inventory and financed.',
    `floor_plan_status` STRING COMMENT 'Current lifecycle status of the floor plan financing record. Active indicates ongoing financing; paid_off indicates vehicle sold and financing settled; defaulted indicates payment failure; suspended indicates temporary hold; pending_audit indicates under review; curtailed indicates partial paydown required.. Valid values are `active|paid_off|defaulted|suspended|pending_audit|curtailed`',
    `interest_rate_pct` DECIMAL(18,2) COMMENT 'Annual interest rate percentage charged by the financing institution on the outstanding floor plan balance for this vehicle.',
    `last_audit_date` DATE COMMENT 'Date of the most recent floor plan audit conducted by the financing institution or OEM to verify physical inventory and compliance with financing terms.',
    `msrp_amount` DECIMAL(18,2) COMMENT 'Manufacturer Suggested Retail Price for the financed vehicle. Used for margin analysis and dealer financial health assessment.',
    `next_audit_date` DATE COMMENT 'Scheduled date for the next floor plan audit. Used for audit planning and dealer notification.',
    `notes` STRING COMMENT 'Free-text field for additional notes, comments, or special circumstances related to this floor plan financing record (e.g., audit exceptions, payment arrangements, OEM approvals).',
    `oem_assistance_amount` DECIMAL(18,2) COMMENT 'Dollar amount of OEM assistance provided for this floor plan record, such as interest rate buy-down or direct payment subsidy.',
    `oem_assistance_program_code` STRING COMMENT 'Code identifying any OEM floor plan assistance program applied to this vehicle (e.g., interest subsidy, extended aging allowance, special financing terms for slow-moving models).',
    `outstanding_balance_amount` DECIMAL(18,2) COMMENT 'Current outstanding principal balance owed to the financing institution for this specific vehicle unit. Updated upon curtailment payments and final payoff.',
    `payoff_amount` DECIMAL(18,2) COMMENT 'Total amount paid to the financing institution to settle the floor plan obligation for this vehicle, including principal and accrued interest.',
    `payoff_date` DATE COMMENT 'Date when the floor plan financing for this vehicle was fully paid off, typically upon retail sale or dealer buyout.',
    `per_unit_floor_plan_cost` DECIMAL(18,2) COMMENT 'The financed amount for this individual vehicle unit, typically equal to dealer invoice or a percentage thereof. Basis for interest calculation.',
    `sap_document_number` STRING COMMENT 'SAP financial document number associated with the floor plan financing transaction in the OEMs ERP system (SAP S/4HANA FI module).',
    `total_interest_paid` DECIMAL(18,2) COMMENT 'Cumulative interest amount paid to the financing institution over the life of the floor plan financing for this vehicle unit.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this floor plan financing record was last modified. Used for audit trail and data lineage tracking.',
    CONSTRAINT pk_floor_plan PRIMARY KEY(`floor_plan_id`)
) COMMENT 'Dealer vehicle floor plan financing records tracking the financing of new vehicle inventory. Captures financing institution, credit line amount, outstanding balance, per-unit floor plan cost, curtailment schedule, aged inventory flags, and floor plan audit dates. Critical for dealer financial health monitoring and OEM floor plan assistance program administration.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` (
    `demo_vehicle_id` BIGINT COMMENT 'Unique identifier for the demo vehicle record. Primary key.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer location where this demo vehicle is assigned.',
    `demo_dealership_id` BIGINT COMMENT 'Identifier of the dealer location where this demo vehicle is assigned.',
    `employee_id` BIGINT COMMENT 'Identifier of the salesperson to whom this demo vehicle is assigned.',
    `primary_demo_employee_id` BIGINT COMMENT 'Identifier of the salesperson to whom this demo vehicle is assigned.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Demo vehicle program tracks specific SKU to manage feature availability, warranty coverage, and cost recovery.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Demo vehicle assignment and usage reporting require linking to the VIN registry for compliance and mileage tracking.',
    `accident_count` STRING COMMENT 'Number of reported accidents or incidents involving this demo vehicle during the demo period.',
    `assigned_salesperson_name` STRING COMMENT 'Full name of the salesperson or sales manager assigned to this demo vehicle.',
    `assignment_type` STRING COMMENT 'Type of assignment indicating how the demo vehicle is being used.. Valid values are `salesperson|sales_manager|general_manager|showroom_floor|test_drive_pool`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this demo vehicle record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts.. Valid values are `^[A-Z]{3}$`',
    `current_odometer_km` STRING COMMENT 'Most recent odometer reading in kilometers for the demo vehicle.',
    `demo_designation_date` DATE COMMENT 'Date when the vehicle was officially designated as a demo unit.',
    `demo_end_date` DATE COMMENT 'Scheduled or actual date when the demo vehicle program period ends or ended.',
    `demo_period_months` STRING COMMENT 'Duration of the demo vehicle program assignment in months.',
    `demo_start_date` DATE COMMENT 'Date when the demo vehicle program period began for this unit.',
    `demo_status` STRING COMMENT 'Current lifecycle status of the demo vehicle program assignment.. Valid values are `active|inactive|retired|converted_to_sale|returned_to_stock|auctioned`',
    `demo_usage_type` STRING COMMENT 'Primary usage type for this demo vehicle.. Valid values are `test_drive|loaner|executive_use|sales_staff_use|showroom_display`',
    `disposition_date` DATE COMMENT 'Date when the demo vehicle was disposed of or transitioned out of the demo program.',
    `disposition_type` STRING COMMENT 'Final disposition of the demo vehicle at the end of the demo program period.. Valid values are `converted_to_used_sale|returned_to_stock|auctioned|transferred_to_another_dealer|scrapped`',
    `floor_plan_interest_amount` DECIMAL(18,2) COMMENT 'Total floor plan interest cost incurred by the dealer for this demo vehicle during the demo period.',
    `incentive_amount` DECIMAL(18,2) COMMENT 'OEM incentive amount provided to the dealer for maintaining this demo vehicle.',
    `insurance_policy_number` STRING COMMENT 'Insurance policy number covering this demo vehicle during the demo period.',
    `mileage_allowance_km` STRING COMMENT 'Maximum allowed mileage in kilometers for the demo vehicle during the demo period per OEM policy.',
    `mileage_overage_km` STRING COMMENT 'Calculated mileage overage in kilometers beyond the allowance, if any.',
    `odometer_at_designation_km` STRING COMMENT 'Odometer reading in kilometers when the vehicle was designated as a demo unit.',
    `oem_program_code` STRING COMMENT 'OEM-assigned program code for the demo vehicle program under which this vehicle is registered.',
    `pdi_completed_flag` BOOLEAN COMMENT 'Indicates whether Pre-Delivery Inspection was completed for this demo vehicle.',
    `pdi_completion_date` DATE COMMENT 'Date when Pre-Delivery Inspection was completed.',
    `recall_campaign_numbers` STRING COMMENT 'Comma-separated list of recall campaign numbers applicable to this demo vehicle.',
    `sale_price_amount` DECIMAL(18,2) COMMENT 'Actual sale price if the demo vehicle was converted to a used vehicle sale.',
    `service_record_count` STRING COMMENT 'Total number of service or maintenance records for this demo vehicle during the demo period.',
    `stock_number` STRING COMMENT 'Dealer-assigned inventory stock number for this demo vehicle.',
    `test_drive_count` STRING COMMENT 'Total number of customer test drives conducted with this demo vehicle.',
    `transmission_type` STRING COMMENT 'Type of transmission installed in the demo vehicle.. Valid values are `manual|automatic|cvt|dct|amt`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this demo vehicle record was last updated.',
    CONSTRAINT pk_demo_vehicle PRIMARY KEY(`demo_vehicle_id`)
) COMMENT 'Dealer demonstrator vehicle program records tracking vehicles designated as demos for test drives and sales staff use. Captures VIN, demo designation date, assigned salesperson or manager, mileage allowance, demo period end date, demo status, and disposition (converted to used sale, returned to stock, auctioned). Governed by OEM demo vehicle policy.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealer_test_drive` (
    `dealer_test_drive_id` BIGINT COMMENT 'Unique identifier for the dealer_test_drive data product (auto-inserted pre-linking).',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Test Drive Telemetry Tracking captures vehicle performance data during customer test drives for quality analysis.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Dealer test drives belong to a dealership; add dealership_id FK to link to dealership and remove redundant dealer_id column.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Test‑drive assignments are recorded to the employee conducting the drive for compliance and sales tracking.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Test‑drive records must reference the interested customer to track conversion rates and follow‑up communications.',
    `sales_test_drive_id` BIGINT COMMENT 'SSOT reference to sales.sales_test_drive (cross-domain duplicate reconciliation; sales designated SSOT owner for test_drive).',
    CONSTRAINT pk_dealer_test_drive PRIMARY KEY(`dealer_test_drive_id`)
) COMMENT 'Records of customer test drive events conducted at a dealership. Captures test drive date/time, VIN driven, customer identifier, salesperson, duration, route type, customer feedback captured, and follow-up action scheduled. Supports sales funnel tracking and connects to lead management in Salesforce Automotive Cloud.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealer_parts_order` (
    `dealer_parts_order_id` BIGINT COMMENT 'Unique identifier for the dealer_parts_order data product (auto-inserted pre-linking).',
    `aftersales_parts_order_id` BIGINT COMMENT 'Foreign key linking to aftersales.parts_order. Business justification: Decision: Dealer parts order must reference the aftersales parts order entity that holds supplier, line‑item, and delivery details.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Parts orders must reference the compliance document certifying part suitability for regulated vehicles, required for audit trails.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Parts orders are often placed for a specific customers vehicle; linking enables parts‑to‑customer analytics and service cost allocation.',
    CONSTRAINT pk_dealer_parts_order PRIMARY KEY(`dealer_parts_order_id`)
) COMMENT 'Dealer parts replenishment orders placed with the OEM parts distribution center or aftermarket suppliers. Tracks order date, order type (emergency, stock, special order), line items with OEM part numbers, quantities ordered, quantities received, backorder status, estimated arrival date, and order total. Sourced from CDK Global DMS parts ordering module.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealer_warranty_claim` (
    `dealer_warranty_claim_id` BIGINT COMMENT 'Unique identifier for the dealer_warranty_claim data product (auto-inserted pre-linking).',
    `aftersales_warranty_claim_id` BIGINT COMMENT 'Foreign key linking to aftersales.warranty_claim. Business justification: Report: Dealer‑submitted warranty claim reports need to point to the authoritative aftersales warranty claim record for audit and reimbursement.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Warranty claims are processed by a specific employee; required for claim audit trails and productivity metrics.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Warranty Claim Validation requires telematics evidence from the connected vehicle to confirm usage and fault conditions.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Warranty claim handling and compliance reporting require the claimant party to be identified.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Warranty Claim Processing requires identifying the supplier responsible for the defective component to route claims and track warranty liabilities.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Warranty claim processing needs the VIN registry reference to verify coverage and claim eligibility.',
    CONSTRAINT pk_dealer_warranty_claim PRIMARY KEY(`dealer_warranty_claim_id`)
) COMMENT 'Warranty claims submitted by the dealership to the OEM for reimbursement of warranty repair labor and parts. Captures VIN, repair order reference, failure date, mileage at failure, DTC (Diagnostic Trouble Code), causal part number, labor operation codes, claimed labor hours, claimed parts cost, submission date, OEM adjudication status (approved, rejected, partially approved), and reimbursement amount.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` (
    `recall_completion_id` BIGINT COMMENT 'Unique identifier for the recall completion record. Primary key for the recall completion transaction.',
    `party_id` BIGINT COMMENT 'Identifier of the customer who owns the vehicle at the time of recall completion.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer location that performed the recall remediation work.',
    `recall_dealership_id` BIGINT COMMENT 'Identifier of the dealer location that performed the recall remediation work.',
    `recall_party_id` BIGINT COMMENT 'Identifier of the customer who owns the vehicle at the time of recall completion.',
    `dealer_order_id` BIGINT COMMENT 'Identifier of the repair order under which the recall work was performed.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the technician who performed the recall remediation work. Used for quality tracking and reimbursement validation.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Recall completion tracking must reference the VIN registry to ensure the correct vehicle is marked as completed.',
    `campaign_type` STRING COMMENT 'Classification of the recall or campaign. Safety recalls are NHTSA-mandated, service campaigns are voluntary OEM actions, TSB (Technical Service Bulletin) are informational fixes.. Valid values are `safety_recall|service_campaign|field_service_action|customer_satisfaction_program|emissions_recall|tsb`',
    `completion_date` DATE COMMENT 'Date when the recall remediation work was completed and the vehicle was returned to the customer. Used for NHTSA compliance reporting and OEM recall closure tracking.',
    `completion_number` STRING COMMENT 'Business identifier for the recall completion transaction, typically generated by the DMS or OEM recall management system.',
    `completion_status` STRING COMMENT 'Current status of the recall completion work. Completed indicates full remediation; incomplete or parts_pending indicate work not yet finished.. Valid values are `completed|incomplete|in_progress|parts_pending|customer_declined|not_applicable`',
    `completion_timestamp` TIMESTAMP COMMENT 'Precise date and time when the recall work was marked complete in the DMS system.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this recall completion record was first created in the data system. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this record (e.g., USD, EUR, CAD).. Valid values are `^[A-Z]{3}$`',
    `customer_notification_date` DATE COMMENT 'Date when the customer was notified that the recall work was completed. Used for customer satisfaction tracking and communication audit.',
    `customer_notification_method` STRING COMMENT 'Method used to notify the customer of recall completion: email, SMS, phone call, postal mail, or in-person at dealer.. Valid values are `email|sms|phone|mail|in_person`',
    `dms_transaction_reference` STRING COMMENT 'Unique transaction identifier from the CDK Global DMS system. Used for data lineage and reconciliation between DMS and OEM systems.',
    `labor_amount` DECIMAL(18,2) COMMENT 'Total labor cost for the recall work, calculated based on labor hours and dealer labor rate. Used for OEM reimbursement to dealer.',
    `labor_hours` DECIMAL(18,2) COMMENT 'Total labor hours spent on the recall remediation work. Used for dealer reimbursement calculation and efficiency analysis.',
    `model` STRING COMMENT 'Specific model designation of the vehicle that received recall work.',
    `model_year` STRING COMMENT 'Model year of the vehicle that received the recall work. Used for recall eligibility verification and reporting.',
    `nameplate` STRING COMMENT 'Brand or nameplate of the vehicle (e.g., F-150, Camry, Silverado). Used to segment recall completion rates by product line.',
    `nhtsa_report_date` DATE COMMENT 'Date when the recall completion was reported to NHTSA. Required for compliance tracking and audit trails.',
    `nhtsa_report_flag` BOOLEAN COMMENT 'Indicates whether this recall completion has been reported to NHTSA as required for safety recalls. True means reported; false means not yet reported or not required.',
    `odometer_reading` STRING COMMENT 'Vehicle odometer reading at the time of recall completion, typically in kilometers or miles. Used for warranty validation and vehicle history tracking.',
    `odometer_unit` STRING COMMENT 'Unit of measure for the odometer reading: km (kilometers) or mi (miles).. Valid values are `km|mi`',
    `parts_amount` DECIMAL(18,2) COMMENT 'Total cost of parts used in the recall remediation. OEM reimburses dealer for parts at wholesale cost.',
    `parts_quantity_list` STRING COMMENT 'Comma-separated or pipe-separated list of quantities corresponding to parts_used_list. Used for parts consumption analysis.',
    `parts_used_list` STRING COMMENT 'Comma-separated or pipe-separated list of part numbers used in the recall remediation. Used for parts consumption tracking and inventory replenishment.',
    `post_repair_inspection_notes` STRING COMMENT 'Technician notes from the post-repair inspection confirming that the recall remediation was successful and the vehicle is safe to operate.',
    `powertrain_type` STRING COMMENT 'Type of powertrain: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), FCEV (Fuel Cell Electric Vehicle). Some recalls are powertrain-specific.. Valid values are `ice|hev|phev|bev|fcev`',
    `pre_repair_inspection_notes` STRING COMMENT 'Technician notes from the pre-repair inspection documenting the condition of the vehicle and the recall-related issue before remediation.',
    `quality_verification_date` DATE COMMENT 'Date when the quality verification or audit of the recall work was performed.',
    `quality_verification_flag` BOOLEAN COMMENT 'Indicates whether the recall work was subject to quality verification or audit by the dealer service manager or OEM field representative. True means verified; false means not verified.',
    `quality_verifier_name` STRING COMMENT 'Name of the person who performed the quality verification or audit of the recall work (typically service manager or OEM field representative).',
    `recall_campaign_number` STRING COMMENT 'Official recall or service campaign number issued by NHTSA or the OEM. Used to track which specific safety recall or service action was completed.',
    `reimbursement_claim_number` STRING COMMENT 'Claim number submitted by the dealer to the OEM for reimbursement of recall work. Links to the OEM financial system for payment processing.',
    `reimbursement_paid_date` DATE COMMENT 'Date when the OEM paid the dealer for the recall work. Used for dealer cash flow analysis and OEM financial reporting.',
    `reimbursement_status` STRING COMMENT 'Status of the dealer reimbursement claim. Pending indicates claim submitted but not yet reviewed; approved means claim validated; paid means funds transferred to dealer.. Valid values are `pending|approved|paid|rejected|under_review`',
    `remedy_description` STRING COMMENT 'Detailed description of the remediation work performed to address the recall. Includes parts replaced, adjustments made, software updates applied, etc.',
    `sublet_amount` DECIMAL(18,2) COMMENT 'Cost of any sublet or outsourced work required to complete the recall (e.g., specialized welding, paint work). Reimbursable by OEM if pre-approved.',
    `technician_certification_number` STRING COMMENT 'Certification or license number of the technician. Some recalls require certified technicians to perform the work.',
    `technician_name` STRING COMMENT 'Full name of the technician who completed the recall work. Used for performance tracking and quality audits.',
    `total_reimbursement_amount` DECIMAL(18,2) COMMENT 'Total amount claimed by the dealer for reimbursement from the OEM, including labor, parts, and sublet costs.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this recall completion record was last modified. Used for change tracking and audit trail.',
    CONSTRAINT pk_recall_completion PRIMARY KEY(`recall_completion_id`)
) COMMENT 'Tracks the completion of NHTSA safety recalls and OEM service campaigns at the dealer level. Records recall/campaign number, VIN remediated, completion date, technician, parts used, labor time, reimbursement claimed, and completion status. Supports NHTSA compliance reporting and OEM recall closure rate monitoring.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` (
    `dms_integration_log_id` BIGINT COMMENT 'Unique identifier for each DMS integration event log entry. Primary key for the integration log table.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealership for which this integration event occurred. Links to the dealer master data.',
    `dms_dealership_id` BIGINT COMMENT 'Identifier of the dealership for which this integration event occurred. Links to the dealer master data.',
    `authentication_method` STRING COMMENT 'Authentication mechanism used to verify dealer DMS identity and authorize data access during synchronization.. Valid values are `oauth2|api_key|certificate|basic_auth`',
    `business_impact_severity` STRING COMMENT 'Assessment of business impact severity if this sync event failed. Critical failures affect customer-facing operations; low impact affects reporting only.. Valid values are `critical|high|medium|low|none`',
    `compression_enabled_flag` BOOLEAN COMMENT 'Indicates whether data compression was enabled for this synchronization event to optimize bandwidth usage.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this integration log record was first created in the OEM data platform. Used for audit trail and data lineage.',
    `data_freshness_lag_minutes` STRING COMMENT 'Time difference in minutes between when data was last updated in the OEM system and when it was synchronized to the dealer DMS. Key metric for monitoring data currency.',
    `dealer_code` STRING COMMENT 'OEM-assigned unique code identifying the dealership. Used for business reporting and dealer network management.',
    `dealer_name` STRING COMMENT 'Legal business name of the dealership. Denormalized for reporting convenience and to support historical tracking if dealer names change.',
    `dms_endpoint_url` STRING COMMENT 'The specific CDK Global DMS API endpoint URL used for this synchronization event. Identifies the dealer system instance and integration point.',
    `dms_transaction_reference` STRING COMMENT 'Unique transaction identifier generated by the CDK Global DMS for this sync event. Used for end-to-end traceability and support escalation.',
    `dms_version` STRING COMMENT 'Version number of the CDK Global DMS software running at the dealership. Used to track compatibility and feature availability.',
    `encryption_protocol` STRING COMMENT 'Security protocol used to encrypt data during transmission between OEM platform and dealer DMS. Ensures data confidentiality and integrity.. Valid values are `TLS_1_2|TLS_1_3|SSL_3_0`',
    `error_category` STRING COMMENT 'Classification of the error type encountered during synchronization. Used for root cause analysis and troubleshooting dealer connectivity issues.. Valid values are `connectivity|validation|timeout|authentication|data_format|business_rule`',
    `error_message` STRING COMMENT 'Detailed error message or description returned by the DMS or integration middleware. Provides technical details for troubleshooting failed sync events.',
    `escalation_required_flag` BOOLEAN COMMENT 'Indicates whether this failed sync event requires escalation to dealer support or OEM integration team for manual intervention.',
    `escalation_timestamp` TIMESTAMP COMMENT 'Date and time when this sync failure was escalated to support teams. Null if no escalation occurred or sync succeeded.',
    `integration_batch_reference` STRING COMMENT 'Unique batch identifier assigned to group related synchronization events. Used to correlate multiple sync operations within a single integration cycle.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this integration log record was last updated. Tracks changes to sync status, retry attempts, or resolution information.',
    `max_retry_attempts` STRING COMMENT 'Maximum number of retry attempts configured for this sync event type before escalation or manual intervention is required.',
    `next_retry_timestamp` TIMESTAMP COMMENT 'Scheduled date and time for the next automatic retry attempt if the current sync failed. Null if no retry is scheduled or sync succeeded.',
    `oem_transaction_reference` STRING COMMENT 'Unique transaction identifier generated by the OEM integration platform for this sync event. Used for internal traceability and audit.',
    `payload_size_kb` DECIMAL(18,2) COMMENT 'Size of the data payload transmitted during this sync event measured in kilobytes. Used to monitor bandwidth utilization and identify large transfers.',
    `record_count_failed` STRING COMMENT 'Number of records that failed to synchronize due to validation errors, connectivity issues, or data quality problems.',
    `record_count_received` STRING COMMENT 'Total number of records successfully received and acknowledged by the dealer DMS. Used to validate completeness of data transfer.',
    `record_count_sent` STRING COMMENT 'Total number of records transmitted from the OEM platform to the dealer DMS during this sync event. Applicable for push operations.',
    `region_code` STRING COMMENT 'Geographic region code where the dealership is located. Used for regional performance analysis and connectivity monitoring.',
    `resolution_notes` STRING COMMENT 'Free-text notes documenting the root cause and resolution steps taken for failed sync events. Used for knowledge management and trend analysis.',
    `resolution_timestamp` TIMESTAMP COMMENT 'Date and time when a failed sync event was resolved and data synchronization completed successfully. Used to calculate mean time to resolution.',
    `retry_attempt_number` STRING COMMENT 'Sequential number indicating which retry attempt this represents for a failed synchronization. Zero indicates the initial attempt.',
    `sla_compliance_flag` BOOLEAN COMMENT 'Indicates whether this synchronization event met the defined SLA target for duration and success rate. Used for dealer performance scorecards.',
    `sla_target_duration_seconds` STRING COMMENT 'Target synchronization duration in seconds as defined in the dealer integration SLA. Used to measure performance against contractual commitments.',
    `sync_duration_seconds` STRING COMMENT 'Total elapsed time in seconds from sync initiation to completion or failure. Used to monitor DMS performance and identify slow connections.',
    `sync_event_type` STRING COMMENT 'Type of data synchronization event between OEM platform and CDK Global DMS. Indicates the direction and nature of data flow (push from OEM or pull from dealer).. Valid values are `inventory_push|ro_pull|sales_pull|parts_pull|customer_pull|warranty_push`',
    `sync_status` STRING COMMENT 'Current status of the synchronization event indicating whether data transfer completed successfully, partially succeeded, or failed.. Valid values are `success|partial|failed|pending|timeout`',
    `sync_timestamp` TIMESTAMP COMMENT 'Date and time when the synchronization event was initiated. This is the principal business event timestamp for the integration log entry.',
    CONSTRAINT pk_dms_integration_log PRIMARY KEY(`dms_integration_log_id`)
) COMMENT 'Business-level integration event log tracking data synchronization events between the OEM data platform and CDK Global DMS at each dealership. Captures sync event type (inventory push, RO pull, sales pull, parts pull), dealership, sync timestamp, record count, sync status (success, partial, failed), and error category. This is a BUSINESS operational record — not an IT log — used to monitor dealer data freshness and DMS connectivity health for business operations.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` (
    `facility_standard_id` BIGINT COMMENT 'Unique identifier for the facility standard compliance record. Primary key for this entity.',
    `employee_id` BIGINT COMMENT 'Employee identifier for the OEM assessor. Links to HR system for auditor qualification tracking.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership being assessed for facility standards compliance.',
    `facility_dealership_id` BIGINT COMMENT 'Reference to the dealership being assessed for facility standards compliance.',
    `franchise_agreement_id` BIGINT COMMENT 'Reference to the franchise agreement under which this facility standard assessment is conducted. Links to contract terms and compliance obligations.',
    `allocation_eligibility_impact_flag` BOOLEAN COMMENT 'Indicates whether non-compliance with this facility standard affects the dealers vehicle allocation eligibility. True = may reduce allocation, False = no allocation impact.',
    `assessment_date` DATE COMMENT 'Date when the facility standards assessment was conducted. Primary business event timestamp for this compliance record.',
    `assessment_method` STRING COMMENT 'Methodology used to conduct the facility standards assessment. On_site = physical inspection, remote = video/virtual tour, hybrid = combination, photographic_evidence = dealer-submitted photos reviewed by OEM, self_assessment = dealer self-evaluation with OEM verification.. Valid values are `on_site|remote|hybrid|photographic_evidence|self_assessment`',
    `assessment_number` STRING COMMENT 'Business identifier for the facility standards assessment. Unique reference number used in communications and reporting.',
    `assessment_report_url` STRING COMMENT 'Link to the detailed facility standards assessment report document stored in the document management system. Contains photos, detailed findings, and recommendations.',
    `assessment_type` STRING COMMENT 'Purpose and context of the facility standards assessment. Initial = new dealer onboarding, annual = scheduled yearly review, renewal = franchise renewal evaluation, spot_check = unscheduled compliance verification, post_remediation = follow-up after deficiency correction, franchise_application = pre-approval assessment.. Valid values are `initial|annual|renewal|spot_check|post_remediation|franchise_application`',
    `assessor_certification_number` STRING COMMENT 'Professional certification number of the assessor, demonstrating qualification to conduct facility standards audits.',
    `assessor_name` STRING COMMENT 'Full name of the OEM representative or third-party auditor who conducted the facility standards assessment.',
    `compliance_score` DECIMAL(18,2) COMMENT 'Quantitative compliance rating expressed as a percentage (0.00 to 100.00). Calculated based on weighted assessment criteria and deficiency severity. Used for franchise renewal decisions and dealer performance scorecards.',
    `compliance_status` STRING COMMENT 'Current compliance state for this facility standard. Compliant = meets all requirements, non_compliant = fails to meet standards, conditional = compliant with minor exceptions, pending_review = assessment submitted awaiting approval, remediation_required = deficiencies identified requiring correction, waived = exemption granted by OEM.. Valid values are `compliant|non_compliant|conditional|pending_review|remediation_required|waived`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this facility standard compliance record was first created in the system. Audit trail for record lifecycle tracking.',
    `critical_deficiency_count` STRING COMMENT 'Number of critical deficiencies identified. Critical deficiencies are those that pose safety risks, violate regulatory requirements, or severely impact brand image.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this record.. Valid values are `^[A-Z]{3}$`',
    `dealer_response_notes` STRING COMMENT 'Dealers formal response to the assessment findings, including planned remediation actions, timelines, and any disputes or clarifications.',
    `deficiency_count` STRING COMMENT 'Total number of deficiency items identified during the assessment. Includes all severity levels (critical, major, minor).',
    `deficiency_description` STRING COMMENT 'Detailed narrative description of all deficiency items identified during the assessment. Includes specific observations, locations, and non-compliance details.',
    `dms_integration_status` STRING COMMENT 'Status of data synchronization with the dealers DMS system (CDK Global). Indicates whether facility standards compliance data has been successfully shared with the dealers operational system.. Valid values are `synced|pending|failed|not_applicable`',
    `dms_last_sync_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent successful data synchronization with the dealers DMS system.',
    `estimated_investment_amount` DECIMAL(18,2) COMMENT 'Estimated cost for the dealer to achieve full compliance with this facility standard. Used for facility investment planning and franchise renewal negotiations.',
    `franchise_renewal_impact_flag` BOOLEAN COMMENT 'Indicates whether this facility standard assessment result will be considered in the next franchise renewal decision. True = impacts renewal, False = informational only.',
    `incentive_eligibility_impact_flag` BOOLEAN COMMENT 'Indicates whether non-compliance with this facility standard affects the dealers eligibility for OEM incentive programs. True = may disqualify from incentives, False = no incentive impact.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this facility standard compliance record was most recently updated. Audit trail for change tracking.',
    `major_deficiency_count` STRING COMMENT 'Number of major deficiencies identified. Major deficiencies significantly impact customer experience or operational efficiency but are not safety-critical.',
    `minor_deficiency_count` STRING COMMENT 'Number of minor deficiencies identified. Minor deficiencies are cosmetic or procedural issues with minimal business impact.',
    `next_assessment_due_date` DATE COMMENT 'Scheduled date for the next facility standards assessment. Frequency determined by standard type, compliance history, and franchise agreement terms.',
    `oem_reviewer_notes` STRING COMMENT 'Internal OEM notes regarding the assessment, remediation progress, or special considerations. Used for franchise management and dealer relationship tracking.',
    `passing_threshold_score` DECIMAL(18,2) COMMENT 'Minimum compliance score required to achieve compliant status for this standard type. Threshold may vary by standard category and dealer tier.',
    `photographic_evidence_url` STRING COMMENT 'Link to photographic documentation of facility conditions at time of assessment. Used for compliance verification and historical tracking.',
    `remediation_completion_date` DATE COMMENT 'Date when all required corrective actions were completed by the dealer. Verified through post-remediation assessment or photographic evidence.',
    `remediation_deadline` DATE COMMENT 'Date by which all identified deficiencies must be corrected. Failure to meet this deadline may result in franchise penalties or suspension.',
    `remediation_required_flag` BOOLEAN COMMENT 'Indicates whether corrective action is required to address identified deficiencies. True = remediation mandatory, False = no action required or waived.',
    `remediation_status` STRING COMMENT 'Current state of corrective action for identified deficiencies. Tracks progress from identification through verification of completion.. Valid values are `not_started|in_progress|completed|verified|overdue|extension_granted`',
    `remediation_verification_date` DATE COMMENT 'Date when OEM verified that remediation actions were completed satisfactorily. May involve on-site re-inspection or remote verification.',
    `standard_category` STRING COMMENT 'High-level grouping of the facility standard type for reporting and analysis purposes.. Valid values are `brand_identity|infrastructure|customer_experience|operational|technology`',
    `standard_type` STRING COMMENT 'Category of facility standard being assessed. CI = Corporate Identity (brand visual standards), signage (exterior/interior signage compliance), showroom (sales floor layout and presentation), service_drive (service reception area standards), ev_charging (Electric Vehicle charging infrastructure), parts_department (parts storage and display), body_shop (collision repair facility standards), customer_lounge (waiting area amenities), digital_experience (digital tools and kiosks). [ENUM-REF-CANDIDATE: CI|signage|showroom|service_drive|ev_charging|parts_department|body_shop|customer_lounge|digital_experience — 9 candidates stripped; promote to reference product]',
    `waiver_expiry_date` DATE COMMENT 'Date when the granted waiver expires and full compliance is required. Null indicates permanent waiver.',
    `waiver_granted_flag` BOOLEAN COMMENT 'Indicates whether the OEM granted a waiver or exemption for this facility standard. True = waiver approved, False = no waiver.',
    `waiver_reason` STRING COMMENT 'Business justification for granting a facility standards waiver. May include market conditions, dealer financial hardship, facility constraints, or strategic considerations.',
    CONSTRAINT pk_facility_standard PRIMARY KEY(`facility_standard_id`)
) COMMENT 'OEM facility and brand standards compliance records for each dealership. Tracks facility standard type (CI — Corporate Identity, signage, showroom, service drive, EV charging infrastructure), assessment date, compliance status, deficiency items, remediation deadline, and compliance score. Used for franchise renewal decisions and facility investment planning.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` (
    `used_vehicle_appraisal_id` BIGINT COMMENT 'Unique identifier for the used vehicle appraisal record. Primary key for this entity.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the dealership staff member who conducted the appraisal.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Appraisal systems need the SKU to derive baseline market value, warranty status, and compliance data.',
    `party_id` BIGINT COMMENT 'Identifier of the customer who owns the vehicle being appraised for trade-in or sale.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealership where the appraisal was conducted.',
    `used_dealership_id` BIGINT COMMENT 'Identifier of the dealership where the appraisal was conducted.',
    `used_party_id` BIGINT COMMENT 'Identifier of the customer who owns the vehicle being appraised for trade-in or sale.',
    `accident_history_flag` BOOLEAN COMMENT 'Indicates whether the vehicle has a reported accident history based on vehicle history report or customer disclosure.',
    `appraisal_date` DATE COMMENT 'Date when the vehicle appraisal was conducted at the dealership.',
    `appraisal_number` STRING COMMENT 'Unique business identifier for the appraisal transaction, typically generated by the DMS (Dealer Management System) or appraisal tool.',
    `appraisal_source_channel` STRING COMMENT 'Channel through which the appraisal was initiated: walk_in (customer walked into dealership), appointment (scheduled appraisal), online_submission (customer submitted online), phone_inquiry (customer called), service_drive (initiated during service visit).. Valid values are `walk_in|appointment|online_submission|phone_inquiry|service_drive`',
    `appraisal_status` STRING COMMENT 'Current lifecycle status of the appraisal: pending (in progress), completed (appraisal finished), accepted (customer accepted trade-in offer), declined (customer declined offer), expired (offer validity period lapsed).. Valid values are `pending|completed|accepted|declined|expired`',
    `appraisal_timestamp` TIMESTAMP COMMENT 'Precise date and time when the appraisal was completed, including time zone information.',
    `appraisal_tool_used` STRING COMMENT 'Third-party valuation tool or system used to determine vehicle value: Manheim MMR (Manheim Market Report), Black Book, KBB (Kelley Blue Book), NADA (National Automobile Dealers Association), Galves, or internal proprietary tool.. Valid values are `manheim_mmr|black_book|kbb|nada|galves|internal`',
    `appraised_value_amount` DECIMAL(18,2) COMMENT 'Final appraised value determined by the dealer after considering market value, vehicle condition, and local market factors.',
    `appraiser_name` STRING COMMENT 'Full name of the dealership employee who performed the appraisal.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this appraisal record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this appraisal (e.g., USD, CAD, EUR).. Valid values are `^[A-Z]{3}$`',
    `customer_requested_amount` DECIMAL(18,2) COMMENT 'Trade-in value amount initially requested or expected by the customer, if disclosed during appraisal.',
    `disposition_decision` STRING COMMENT 'Final decision on the disposition of the appraised vehicle: accepted_trade (customer accepted trade-in offer), declined_trade (customer declined offer), wholesale (vehicle to be sent to auction), retail_inventory (vehicle to be added to dealer used inventory), pending (decision not yet made).. Valid values are `accepted_trade|declined_trade|wholesale|retail_inventory|pending`',
    `equity_amount` DECIMAL(18,2) COMMENT 'Calculated equity in the vehicle (appraised value minus payoff amount). Positive equity means the vehicle is worth more than owed; negative equity means the customer owes more than the vehicle is worth.',
    `exterior_condition_notes` STRING COMMENT 'Detailed notes on the exterior condition, including paint quality, body damage, dents, scratches, rust, and glass condition.',
    `interior_condition_notes` STRING COMMENT 'Detailed notes on the interior condition, including upholstery wear, dashboard condition, electronics functionality, and cleanliness.',
    `linked_deal_number` STRING COMMENT 'Deal or sales transaction number in the DMS (Dealer Management System) if this appraisal was linked to a new or used vehicle purchase.',
    `market_value_amount` DECIMAL(18,2) COMMENT 'Estimated market value of the vehicle based on the appraisal tool, representing the fair market price for retail or wholesale.',
    `mechanical_condition_notes` STRING COMMENT 'Detailed notes on the mechanical condition of the vehicle, including engine, transmission, brakes, suspension, and other systems.',
    `model_year` STRING COMMENT 'Model year of the vehicle being appraised, representing the year designation assigned by the manufacturer.',
    `odometer_unit` STRING COMMENT 'Unit of measure for the odometer reading: miles or kilometers.. Valid values are `miles|kilometers`',
    `offer_expiration_date` DATE COMMENT 'Date when the trade-in offer expires and is no longer valid, typically 3-7 days from appraisal date.',
    `payoff_amount` DECIMAL(18,2) COMMENT 'Outstanding loan or lease payoff amount owed by the customer on the vehicle being appraised, if applicable. This is customer financial information.',
    `reconditioning_cost_estimate` DECIMAL(18,2) COMMENT 'Estimated cost to recondition the vehicle for resale, including repairs, detailing, and PDI (Pre-Delivery Inspection) work.',
    `retail_estimate_amount` DECIMAL(18,2) COMMENT 'Estimated retail asking price if the vehicle were to be added to dealer used vehicle inventory.',
    `service_records_available_flag` BOOLEAN COMMENT 'Indicates whether the customer provided documented service and maintenance records for the vehicle.',
    `tire_condition` STRING COMMENT 'Assessment of tire condition and remaining tread life: excellent (like new), good (adequate tread), fair (moderate wear), poor (low tread), replacement_needed (below safe threshold).. Valid values are `excellent|good|fair|poor|replacement_needed`',
    `title_status` STRING COMMENT 'Legal title status of the vehicle: clean (no issues), salvage (total loss), rebuilt (repaired salvage), lemon (manufacturer buyback), flood (flood damage), hail (hail damage).. Valid values are `clean|salvage|rebuilt|lemon|flood|hail`',
    `trade_in_allowance_amount` DECIMAL(18,2) COMMENT 'Trade-in allowance amount offered to the customer, which may differ from appraised value due to negotiation or deal structuring in F&I (Finance and Insurance) process.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this appraisal record was last modified or updated.',
    `vin` STRING COMMENT '17-character Vehicle Identification Number uniquely identifying the vehicle being appraised. VIN is considered PII as it can be traced to an individual owner.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `wholesale_estimate_amount` DECIMAL(18,2) COMMENT 'Estimated wholesale auction value if the vehicle were to be sent to wholesale rather than retailed.',
    CONSTRAINT pk_used_vehicle_appraisal PRIMARY KEY(`used_vehicle_appraisal_id`)
) COMMENT 'Trade-in and used vehicle appraisal records conducted at the dealership. Captures appraisal date, VIN, year/make/model, mileage, condition grade, appraiser, appraisal tool used (e.g., Manheim, Black Book, KBB), appraised value, trade-in allowance offered, and disposition decision (accepted trade, declined, wholesale). Supports F&I deal structuring and used vehicle inventory acquisition.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealership_quality_assessment` (
    `dealership_quality_assessment_id` BIGINT COMMENT 'Primary key for the DealershipQualityAssessment association',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to the dealership',
    `standard_id` BIGINT COMMENT 'Foreign key linking to the quality standard',
    `assessment_date` DATE COMMENT 'Date the assessment was performed',
    `assessment_type` STRING COMMENT 'Type of assessment (e.g., initial, follow‑up, audit)',
    `compliance_score` DECIMAL(18,2) COMMENT 'Numeric score representing overall compliance',
    `compliance_status` STRING COMMENT 'Resulting compliance status (e.g., compliant, non‑compliant)',
    `deficiency_count` STRING COMMENT 'Number of deficiencies identified in the assessment',
    CONSTRAINT pk_dealership_quality_assessment PRIMARY KEY(`dealership_quality_assessment_id`)
) COMMENT 'This association captures each compliance assessment linking a dealership to a quality standard. It records when the assessment occurred, its type, the resulting compliance status, score, and any deficiencies identified.. Existence Justification: Dealerships must comply with multiple quality standards, and each quality standard applies to many dealerships. The compliance process is captured in assessment records that include dates, types, scores, and deficiency counts, which are actively created, updated, and deleted by quality teams.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` (
    `dealer_order_id` BIGINT COMMENT 'Unique surrogate identifier for each dealer order record in the lakehouse silver layer. Primary key for the dealer_order data product.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Order‑to‑OTA Mapping links each vehicle order to its connected vehicle record for OTA update eligibility tracking.',
    `party_id` BIGINT COMMENT 'Reference to the retail customer for whom this order is placed. Populated for retail (customer-specific) orders; null for stock orders.',
    `dealer_party_id` BIGINT COMMENT 'Reference to the retail customer for whom this order is placed. Populated for retail (customer-specific) orders; null for stock orders.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership that placed this order. Links to the dealer master record in the dealer domain.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Required for Dealer Order Fulfillment report linking each dealer order to the corresponding purchase order for cost, delivery, and compliance tracking.',
    `production_order_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_order. Business justification: Required for Dealer Order Fulfillment report linking each dealer order to the specific production order that will build the vehicle.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Dealer order processing and financing depend on the exact SKU to calculate MSRP, incentives, and regulatory compliance.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Dealer order reconciliation report matches each dealer purchase order to the OEM vehicle order that fulfills it.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Dealer order processing must associate each order with the specific VIN to enable production tracking and post‑sale service.',
    `actual_delivery_date` DATE COMMENT 'The actual date the vehicle was physically delivered to the dealership. Used to calculate On-Time Delivery (OTD) performance against the confirmed delivery date.',
    `actual_ship_date` DATE COMMENT 'The actual date the vehicle departed the production plant or port for transit to the dealership. Used to measure logistics performance and update OTD tracking.',
    `allocation_pool_code` STRING COMMENT 'Code identifying the vehicle allocation pool or program from which this order is fulfilled (e.g., regional allocation, fleet pool, dealer stock pool). Governs allocation rules and constraints.',
    `body_style` STRING COMMENT 'The body style classification of the ordered vehicle. Used for production scheduling, logistics planning, and sales mix reporting. [ENUM-REF-CANDIDATE: sedan|coupe|SUV|truck|van|wagon|convertible — 7 candidates stripped; promote to reference product]',
    `cancellation_reason_code` STRING COMMENT 'Code identifying the reason for order cancellation (e.g., customer withdrawal, dealer over-allocation, duplicate order). Populated only when order_status is cancelled.',
    `confirmed_delivery_date` DATE COMMENT 'The OEM-confirmed delivery date communicated back to the dealer after production scheduling. May differ from the requested delivery date.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the dealer order record was first created in the system. Audit trail field conforming to IATF 16949 data traceability requirements.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on this order (e.g., USD, EUR, CAD). Enables multi-currency reporting across dealer networks in different markets.. Valid values are `^[A-Z]{3}$`',
    `days_late` STRING COMMENT 'Number of calendar days the actual delivery date exceeded the confirmed delivery date. Zero or negative values indicate on-time or early delivery. Used for OTD variance analysis and dealer penalty calculations.',
    `dealer_invoice_amount` DECIMAL(18,2) COMMENT 'The wholesale invoice price charged by the OEM to the dealer for this vehicle order. Represents the net amount the dealer pays before any holdback or incentive adjustments.',
    `dms_order_number` STRING COMMENT 'Order reference number assigned by the CDK Global Dealer Management System at the dealership level. Enables reconciliation between OEM and dealer systems.',
    `estimated_ship_date` DATE COMMENT 'The estimated date the vehicle is expected to depart the production plant or port for transit to the dealership. Used for logistics planning and dealer communication.',
    `exterior_color_code` STRING COMMENT 'OEM-assigned paint color code for the exterior of the ordered vehicle. Used for production scheduling, paint shop sequencing, and inventory matching.',
    `hold_reason_code` STRING COMMENT 'Code indicating the reason an order has been placed on hold, such as parts shortage, regulatory hold, credit hold, or customer change request. Null when order is not on hold.',
    `homologation_variant` STRING COMMENT 'The regulatory homologation variant code specifying market-specific compliance configurations (e.g., US-spec, EU-spec, CARB-spec). Ensures the vehicle meets applicable NHTSA, EPA, UNECE, or CARB standards for the destination market.',
    `incentive_amount` DECIMAL(18,2) COMMENT 'Total OEM incentive or discount amount applied to this order, including dealer cash, consumer cash, and program incentives. Reduces the effective dealer cost.',
    `interior_color_code` STRING COMMENT 'OEM-assigned interior trim and color code for the ordered vehicle. Used for production configuration and dealer inventory matching.',
    `market_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the market where the vehicle will be sold. Determines applicable regulatory standards (NHTSA, EPA, CARB, Euro NCAP, UNECE), homologation requirements, and pricing.. Valid values are `^[A-Z]{3}$`',
    `msrp_amount` DECIMAL(18,2) COMMENT 'The Manufacturer Suggested Retail Price (MSRP) for the fully configured vehicle as ordered, in the base currency. Represents the gross base amount before dealer adjustments, incentives, or taxes.',
    `notes` STRING COMMENT 'Free-text notes or special instructions associated with the order, entered by the dealer or OEM order management team. May include customer preferences, special handling requirements, or escalation notes.',
    `order_date` DATE COMMENT 'The calendar date on which the dealer submitted the order to the OEM. This is the principal business event date for the order transaction.',
    `order_source` STRING COMMENT 'The channel or system through which the dealer order was submitted to the OEM: dealer portal, CDK Global DMS integration, EDI transmission, manual entry, or API.. Valid values are `dealer_portal|dms|edi|manual|api`',
    `order_status` STRING COMMENT 'Current lifecycle state of the dealer order tracking progression from submission through delivery. [ENUM-REF-CANDIDATE: submitted|confirmed|scheduled|produced|shipped|delivered|cancelled — promote to reference product]',
    `order_type` STRING COMMENT 'Classification of the order indicating whether it is a dealer stock replenishment order, a retail customer-specific order, a demonstration vehicle order, a fleet order, or a courtesy vehicle order.. Valid values are `stock|retail|demo|fleet|courtesy`',
    `otd_flag` BOOLEAN COMMENT 'Indicates whether the vehicle was delivered on or before the confirmed delivery date. True = delivered on time; False = delivered late. Core metric for OTD performance reporting and dealer satisfaction.',
    `pdi_completed_date` DATE COMMENT 'The date on which the Pre-Delivery Inspection (PDI) was completed at the dealership. Null if PDI has not yet been performed.',
    `pdi_required` BOOLEAN COMMENT 'Indicates whether a Pre-Delivery Inspection (PDI) is required before the vehicle is handed over to the customer. True = PDI mandatory; False = PDI not required.',
    `priority_code` STRING COMMENT 'Priority classification assigned to the order for production scheduling and allocation purposes. Higher priority orders are scheduled earlier in the production sequence.. Valid values are `standard|priority|urgent|allocation`',
    `production_plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility assigned to produce the vehicle for this order. Determined during production scheduling.',
    `production_week` STRING COMMENT 'ISO 8601 production week (e.g., 2025-W23) in which the vehicle is scheduled to be built. Used for production scheduling, capacity planning, and OTD tracking.. Valid values are `^d{4}-W(0[1-9]|[1-4]d|5[0-3])$`',
    `requested_delivery_date` DATE COMMENT 'The date by which the dealer has requested the vehicle to be delivered to the dealership. Used for On-Time Delivery (OTD) target setting and production scheduling.',
    `sales_region_code` STRING COMMENT 'OEM sales region code associated with the ordering dealer. Used for regional sales performance reporting, allocation management, and incentive program eligibility.',
    `sap_sales_order_number` STRING COMMENT 'Externally-known SAP SD sales order number assigned by the OEM ERP system upon order confirmation. Used for cross-system traceability between the lakehouse and SAP S/4HANA.',
    `shipping_method` STRING COMMENT 'The logistics mode used to transport the vehicle from the production plant to the dealership: rail, truck (auto carrier), ocean vessel, or a combination.. Valid values are `rail|truck|vessel|mixed`',
    `transmission_type` STRING COMMENT 'The transmission type specified for the ordered vehicle: automatic, manual, Continuously Variable Transmission (CVT), or Dual-Clutch Transmission (DCT).. Valid values are `automatic|manual|CVT|DCT`',
    `updated_timestamp` TIMESTAMP COMMENT 'The timestamp when the dealer order record was most recently modified. Used for change tracking, data lineage, and incremental ETL processing in the Databricks lakehouse.',
    CONSTRAINT pk_dealer_order PRIMARY KEY(`dealer_order_id`)
) COMMENT 'Dealer stock orders and customer-specific vehicle orders placed by the dealership with the OEM. Captures order type (stock vs retail), nameplate, MY, configuration (trim, options, packages), order date, requested delivery date, order status (submitted, confirmed, scheduled, produced, shipped, delivered), and OTD (On-Time Delivery) tracking. Integrates with SAP SD and CDK Global DMS.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` (
    `dealer_contact_id` BIGINT COMMENT 'Unique identifier for the dealer contact record. Primary key.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership where this contact is employed. Links to the dealer master record.',
    `active_flag` BOOLEAN COMMENT 'Indicates whether the contact is currently active and employed at the dealership. True if active; False if terminated, retired, or on extended leave.',
    `certification_expiry_date` DATE COMMENT 'The date when the contacts current OEM certification expires and recertification is required. Null if certification is not required or not yet obtained.',
    `certification_status` STRING COMMENT 'The current status of the contacts OEM certification or training requirements. Certified indicates all required certifications are current; in_progress indicates training underway; expired indicates recertification needed; not_required indicates role does not require certification; not_certified indicates certification required but not yet obtained.. Valid values are `certified|in_progress|expired|not_required|not_certified`',
    `communication_preference` STRING COMMENT 'The contacts preferred method of communication for OEM notifications and updates. Options include email, phone, mobile, fax, or portal messaging.. Valid values are `email|phone|mobile|fax|portal`',
    `contact_role` STRING COMMENT 'The functional role or position of the contact at the dealership. Includes dealer principal, general manager, sales manager, service manager, parts manager, and F&I (Finance and Insurance) manager.. Valid values are `dealer_principal|general_manager|sales_manager|service_manager|parts_manager|fi_manager`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this dealer contact record was first created in the system. Used for audit trail and data lineage.',
    `data_source_system` STRING COMMENT 'The name of the source system from which this dealer contact record originated. Typically CDK Global DMS (Dealer Management System), Salesforce Automotive Cloud, or other dealer management platforms.',
    `dealer_portal_access_flag` BOOLEAN COMMENT 'Indicates whether the contact has been granted access to the OEM dealer portal for ordering, inventory management, warranty claims, and communications. True if access is granted; False if not.',
    `department` STRING COMMENT 'The department or functional area within the dealership where the contact works. Includes sales, service, parts, F&I (Finance and Insurance), administration, and management.. Valid values are `sales|service|parts|finance_insurance|administration|management`',
    `email_address` STRING COMMENT 'Primary business email address for the dealer contact. Used for OEM (Original Equipment Manufacturer) communications, training enrollment, and dealer portal access.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `emergency_contact_name` STRING COMMENT 'The name of the person to contact in case of an emergency involving this dealer contact.',
    `emergency_contact_phone` STRING COMMENT 'The phone number of the emergency contact person for this dealer contact.',
    `fax_number` STRING COMMENT 'Fax number for the dealer contact, if still in use for document transmission.',
    `first_name` STRING COMMENT 'The given name of the dealer contact person.',
    `hire_date` DATE COMMENT 'The date when the contact was hired or started employment at the dealership. Used to calculate tenure and eligibility for OEM programs.',
    `job_title` STRING COMMENT 'The official job title or designation of the contact at the dealership, which may differ from the standardized contact role.',
    `language_preference` STRING COMMENT 'The preferred language for communications with the contact. Uses ISO 639-2 three-letter language codes (ENG=English, SPA=Spanish, FRE=French, GER=German, ITA=Italian, POR=Portuguese, CHI=Chinese, JPN=Japanese, KOR=Korean, ARA=Arabic). [ENUM-REF-CANDIDATE: ENG|SPA|FRE|GER|ITA|POR|CHI|JPN|KOR|ARA — 10 candidates stripped; promote to reference product]',
    `last_name` STRING COMMENT 'The family name or surname of the dealer contact person.',
    `last_training_date` DATE COMMENT 'The date when the contact last completed an OEM training course or certification program.',
    `middle_name` STRING COMMENT 'The middle name or initial of the dealer contact person, if applicable.',
    `mobile_number` STRING COMMENT 'Mobile phone number for the dealer contact, used for urgent communications and field operations.',
    `notes` STRING COMMENT 'Free-form text field for additional notes, comments, or special instructions related to the dealer contact. May include communication preferences, special requirements, or historical context.',
    `phone_number` STRING COMMENT 'Primary business phone number for the dealer contact. Includes country code, area code, and extension if applicable.',
    `portal_last_login_timestamp` TIMESTAMP COMMENT 'The date and time when the contact last logged into the OEM dealer portal. Used to monitor engagement and identify inactive users.',
    `portal_user_code` STRING COMMENT 'The unique user identifier or login name for the contact in the OEM dealer portal system. Used for authentication and access management.',
    `primary_contact_flag` BOOLEAN COMMENT 'Indicates whether this contact is the primary point of contact for their role at the dealership. True if primary; False if secondary or backup contact.',
    `tenure_years` DECIMAL(18,2) COMMENT 'The number of years the contact has been employed at the dealership, calculated from hire date. Used for experience assessment and program eligibility.',
    `termination_date` DATE COMMENT 'The date when the contacts employment at the dealership ended. Null if the contact is still active.',
    `termination_reason` STRING COMMENT 'The reason for the contacts departure from the dealership. Includes resignation, retirement, termination, transfer to another location, or other reasons.. Valid values are `resignation|retirement|termination|transfer|other`',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and time when this dealer contact record was last modified. Used for audit trail and change tracking.',
    CONSTRAINT pk_dealer_contact PRIMARY KEY(`dealer_contact_id`)
) COMMENT 'Key personnel contacts at a dealership including dealer principal, general manager, sales manager, service manager, parts manager, and F&I manager. Tracks role, contact details, tenure, certification status, and active flag. Supports OEM communications, training enrollment, and dealer portal access management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` (
    `dealer_region_id` BIGINT COMMENT 'Unique identifier for the dealer region. Primary key for the dealer region entity.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Regional performance and compliance metrics are governed by jurisdiction; the link supports region‑level regulatory analytics.',
    `allocation_quota_percentage` DECIMAL(18,2) COMMENT 'Percentage of total OEM production allocated to this region. Sum of all region percentages equals 100%. Used for production planning and dealer inventory distribution.',
    `approval_date` DATE COMMENT 'Date when the current region configuration or most recent change was formally approved by management.',
    `approved_by` STRING COMMENT 'Name or employee ID of the executive who approved the current region configuration or most recent change.',
    `city_list` STRING COMMENT 'Comma-separated list of major cities included in this dealer region for reference and marketing purposes.',
    `competitive_intensity_rating` STRING COMMENT 'Assessment of competitive pressure from other OEMs in this region. Influences incentive programs and marketing investment.. Valid values are `low|moderate|high|very_high`',
    `country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code representing the primary country for this region (e.g., USA, CAN, MEX).. Valid values are `^[A-Z]{3}$`',
    `county_region_list` STRING COMMENT 'Comma-separated list of county or regional administrative divisions included in this dealer region for granular territory definition.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this dealer region record was first created in the system. Used for audit trail and data lineage.',
    `dealer_count` STRING COMMENT 'Total number of active dealerships assigned to this region. Used for capacity planning and regional performance benchmarking.',
    `district_code` STRING COMMENT 'Code identifying the district within the region. Districts are sub-regional organizational units that group dealerships for field management.. Valid values are `^[A-Z0-9]{2,10}$`',
    `district_name` STRING COMMENT 'Full name of the district within the region.',
    `dms_integration_status` STRING COMMENT 'Status of integration between this region and the CDK Global DMS. Active indicates successful data synchronization; error indicates integration issues requiring attention.. Valid values are `active|inactive|pending|error`',
    `dms_last_sync_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent successful data synchronization between this region and the CDK Global DMS. Used for monitoring integration health.',
    `effective_end_date` DATE COMMENT 'Date when this region configuration ceased to be effective. Null for currently active regions. Used for historical analysis and territory reorganization tracking.',
    `effective_start_date` DATE COMMENT 'Date when this region configuration became effective. Used for historical tracking and territory change management.',
    `geographic_boundary_description` STRING COMMENT 'Textual description of the geographic boundaries defining this region (e.g., bordered by Interstate 5 to the west, state line to the east). Used when precise coordinates are not available.',
    `household_count_estimate` BIGINT COMMENT 'Estimated number of households within the region. Used for market penetration and vehicle ownership forecasting.',
    `incentive_program_eligibility_flag` BOOLEAN COMMENT 'Indicates whether dealers in this region are eligible for special OEM incentive programs. True if eligible, false otherwise.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this dealer region record was most recently updated. Used for change tracking and data quality monitoring.',
    `last_review_date` DATE COMMENT 'Date of the most recent formal review of this regions boundaries, performance targets, and organizational alignment.',
    `market_segment_classification` STRING COMMENT 'Classification of the regions primary market segment based on population density and economic characteristics. Influences product mix and marketing strategy.. Valid values are `urban|suburban|rural|mixed`',
    `modification_reason` STRING COMMENT 'Business justification for the most recent change to this regions configuration (e.g., market consolidation, dealer network expansion, territory realignment).',
    `next_review_date` DATE COMMENT 'Scheduled date for the next formal review of this regions configuration and performance. Used for governance and planning cycles.',
    `performance_benchmark_group` STRING COMMENT 'Code identifying the peer group used for performance benchmarking. Regions in the same group are compared for scorecard evaluation.',
    `population_estimate` BIGINT COMMENT 'Estimated total population within the geographic boundaries of this region. Used for market sizing and sales potential analysis.',
    `postal_code_range` STRING COMMENT 'Description of postal code ranges covered by this region (e.g., 90000-93999 for Southern California). Used for territory assignment and customer routing.',
    `region_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the region within the OEM organizational hierarchy. Used for reporting and system integration.. Valid values are `^[A-Z0-9]{2,10}$`',
    `region_name` STRING COMMENT 'Full business name of the dealer region (e.g., Northeast Region, California Coastal, Mid-Atlantic).',
    `region_status` STRING COMMENT 'Current lifecycle status of the dealer region. Active regions are operational; inactive regions are temporarily suspended; pending regions are being established; consolidating regions are merging with others; dissolved regions have been permanently closed.. Valid values are `active|inactive|pending|consolidating|dissolved`',
    `region_type` STRING COMMENT 'Classification of the region based on organizational structure: geographic (physical territory), market (customer segment focus), strategic (special initiative), or operational (functional alignment).. Valid values are `geographic|market|strategic|operational`',
    `regional_manager_email` STRING COMMENT 'Primary email address of the regional manager for business communication and escalation.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `regional_manager_name` STRING COMMENT 'Full name of the regional manager assigned to oversee dealer performance, allocation, and field operations in this region.',
    `regional_manager_phone` STRING COMMENT 'Primary phone number of the regional manager for dealer support and escalation.',
    `sales_potential_index` DECIMAL(18,2) COMMENT 'Indexed score (0-100) representing the relative sales potential of this region compared to national average. Used for allocation planning and performance benchmarking.',
    `salesforce_region_code` STRING COMMENT 'External identifier for this region in the Salesforce Automotive Cloud system. Used for cross-system reconciliation and dealer portal integration.',
    `sap_sales_org_code` STRING COMMENT 'SAP S/4HANA sales organization code mapped to this dealer region. Used for order processing, billing, and financial reporting integration.. Valid values are `^[A-Z0-9]{4}$`',
    `special_program_notes` STRING COMMENT 'Free-text notes describing any special programs, initiatives, or considerations applicable to this region (e.g., EV infrastructure pilot, fleet sales focus).',
    `state_province_list` STRING COMMENT 'Comma-separated list of state or province codes covered by this region (e.g., CA,NV,AZ for a Western US region).',
    `vehicle_allocation_priority` STRING COMMENT 'Priority ranking (1=highest) for vehicle allocation to this region during supply constraints. Based on market size, strategic importance, and historical performance.',
    `zone_code` STRING COMMENT 'Code identifying the parent zone to which this region belongs. Zones are higher-level organizational units that aggregate multiple regions.. Valid values are `^[A-Z0-9]{2,10}$`',
    `zone_name` STRING COMMENT 'Full name of the parent zone (e.g., Eastern Zone, Western Zone, Central Zone).',
    CONSTRAINT pk_dealer_region PRIMARY KEY(`dealer_region_id`)
) COMMENT 'OEM regional and zone organizational hierarchy for dealer network management. Defines region name, zone, district, regional manager assignment, geographic boundaries, and the set of dealerships within each region. Used for regional performance aggregation, allocation management, and field sales team alignment.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ADD CONSTRAINT `fk_dealer_dealership_dealer_region_id` FOREIGN KEY (`dealer_region_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_region`(`dealer_region_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ADD CONSTRAINT `fk_dealer_franchise_agreement_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ADD CONSTRAINT `fk_dealer_franchise_agreement_franchise_dealership_id` FOREIGN KEY (`franchise_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ADD CONSTRAINT `fk_dealer_dealer_territory_franchise_agreement_id` FOREIGN KEY (`franchise_agreement_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`franchise_agreement`(`franchise_agreement_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ADD CONSTRAINT `fk_dealer_dealer_territory_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ADD CONSTRAINT `fk_dealer_dealer_certification_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ADD CONSTRAINT `fk_dealer_vehicle_allocation_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ADD CONSTRAINT `fk_dealer_vehicle_allocation_vehicle_dealership_id` FOREIGN KEY (`vehicle_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ADD CONSTRAINT `fk_dealer_allocation_rule_dealer_incentive_program_id` FOREIGN KEY (`dealer_incentive_program_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_incentive_program`(`dealer_incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ADD CONSTRAINT `fk_dealer_allocation_rule_superseded_by_rule_allocation_rule_id` FOREIGN KEY (`superseded_by_rule_allocation_rule_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`allocation_rule`(`allocation_rule_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ADD CONSTRAINT `fk_dealer_parts_inventory_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ADD CONSTRAINT `fk_dealer_parts_inventory_parts_dealership_id` FOREIGN KEY (`parts_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_retail_dealership_id` FOREIGN KEY (`retail_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ADD CONSTRAINT `fk_dealer_dealer_service_appointment_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ADD CONSTRAINT `fk_dealer_dealer_incentive_claim_dealer_incentive_program_id` FOREIGN KEY (`dealer_incentive_program_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_incentive_program`(`dealer_incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ADD CONSTRAINT `fk_dealer_dealer_incentive_claim_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ADD CONSTRAINT `fk_dealer_performance_scorecard_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ADD CONSTRAINT `fk_dealer_performance_scorecard_performance_dealership_id` FOREIGN KEY (`performance_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ADD CONSTRAINT `fk_dealer_csi_survey_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ADD CONSTRAINT `fk_dealer_csi_survey_csi_dealership_id` FOREIGN KEY (`csi_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ADD CONSTRAINT `fk_dealer_csi_survey_dealer_order_id` FOREIGN KEY (`dealer_order_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_order`(`dealer_order_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ADD CONSTRAINT `fk_dealer_csi_survey_csi_repair_order_id` FOREIGN KEY (`csi_repair_order_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_order`(`dealer_order_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ADD CONSTRAINT `fk_dealer_service_capacity_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ADD CONSTRAINT `fk_dealer_service_capacity_service_dealership_id` FOREIGN KEY (`service_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ADD CONSTRAINT `fk_dealer_floor_plan_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ADD CONSTRAINT `fk_dealer_floor_plan_floor_dealership_id` FOREIGN KEY (`floor_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ADD CONSTRAINT `fk_dealer_demo_vehicle_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ADD CONSTRAINT `fk_dealer_demo_vehicle_demo_dealership_id` FOREIGN KEY (`demo_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_test_drive` ADD CONSTRAINT `fk_dealer_dealer_test_drive_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ADD CONSTRAINT `fk_dealer_recall_completion_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ADD CONSTRAINT `fk_dealer_recall_completion_recall_dealership_id` FOREIGN KEY (`recall_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ADD CONSTRAINT `fk_dealer_recall_completion_dealer_order_id` FOREIGN KEY (`dealer_order_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_order`(`dealer_order_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ADD CONSTRAINT `fk_dealer_dms_integration_log_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ADD CONSTRAINT `fk_dealer_dms_integration_log_dms_dealership_id` FOREIGN KEY (`dms_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ADD CONSTRAINT `fk_dealer_facility_standard_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ADD CONSTRAINT `fk_dealer_facility_standard_facility_dealership_id` FOREIGN KEY (`facility_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ADD CONSTRAINT `fk_dealer_facility_standard_franchise_agreement_id` FOREIGN KEY (`franchise_agreement_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`franchise_agreement`(`franchise_agreement_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ADD CONSTRAINT `fk_dealer_used_vehicle_appraisal_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ADD CONSTRAINT `fk_dealer_used_vehicle_appraisal_used_dealership_id` FOREIGN KEY (`used_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership_quality_assessment` ADD CONSTRAINT `fk_dealer_dealership_quality_assessment_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ADD CONSTRAINT `fk_dealer_dealer_order_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ADD CONSTRAINT `fk_dealer_dealer_contact_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`dealer` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_automotive_v1`.`dealer` SET TAGS ('dbx_domain' = 'dealer');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` SET TAGS ('dbx_subdomain' = 'network_management');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Company Code Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `dealer_region_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Region Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `activation_date` SET TAGS ('dbx_business_glossary_term' = 'Dealer Network Activation Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `adas_certified` SET TAGS ('dbx_business_glossary_term' = 'Advanced Driver Assistance Systems (ADAS) Certified Dealer Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Dealer Street Address Line 1');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Dealer Street Address Line 2');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `cdk_dealer_code` SET TAGS ('dbx_business_glossary_term' = 'CDK Global Dealer Management System (DMS) Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `cdk_dealer_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,20}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `channel_classification` SET TAGS ('dbx_business_glossary_term' = 'Sales Channel Classification');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `channel_classification` SET TAGS ('dbx_value_regex' = 'retail|fleet|wholesale|online|agency|export');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'Dealer City');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code (ISO 3166-1 Alpha-3)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `deactivation_date` SET TAGS ('dbx_business_glossary_term' = 'Dealer Network Deactivation Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `dealer_code` SET TAGS ('dbx_business_glossary_term' = 'Dealer Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `dealer_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `dealer_status` SET TAGS ('dbx_business_glossary_term' = 'Dealer Operational Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `dealer_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|pending_approval|terminated|under_review');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `dealer_tier` SET TAGS ('dbx_business_glossary_term' = 'Dealer Performance Tier');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `dealer_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `dms_go_live_date` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Go-Live Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `dms_integration_status` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Integration Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `dms_integration_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_setup|error|suspended');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `ev_certified` SET TAGS ('dbx_business_glossary_term' = 'Electric Vehicle (EV) Certified Dealer Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `ev_charger_count` SET TAGS ('dbx_business_glossary_term' = 'Electric Vehicle (EV) Charger Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `franchise_agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `franchise_agreement_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `franchise_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `franchise_start_date` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Start Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `franchise_type` SET TAGS ('dbx_business_glossary_term' = 'Franchise Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `franchise_type` SET TAGS ('dbx_value_regex' = 'oem_owned|independent_franchise|authorized_repairer|fleet_only|used_vehicle_only|satellite');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Dealer Geolocation Latitude');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `legal_name` SET TAGS ('dbx_business_glossary_term' = 'Dealer Legal Entity Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `legal_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Dealer Geolocation Longitude');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `lot_capacity` SET TAGS ('dbx_business_glossary_term' = 'Dealer Lot Vehicle Capacity');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `lot_capacity` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `market_region_code` SET TAGS ('dbx_business_glossary_term' = 'Market Region Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `market_region_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `new_vehicle_sales_capacity` SET TAGS ('dbx_business_glossary_term' = 'New Vehicle Annual Sales Capacity');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `new_vehicle_sales_capacity` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `oem_brand_codes` SET TAGS ('dbx_business_glossary_term' = 'Authorized OEM Brand Codes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `ownership_group_name` SET TAGS ('dbx_business_glossary_term' = 'Dealer Ownership Group Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `ownership_group_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `parts_warehouse_area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Parts Warehouse Area (Square Metres)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `pdi_certified` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Certified Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Dealer Postal Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `postal_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9 -]{3,10}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `primary_email` SET TAGS ('dbx_business_glossary_term' = 'Dealer Primary Email Address');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `primary_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `primary_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `primary_email` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `primary_phone` SET TAGS ('dbx_business_glossary_term' = 'Dealer Primary Phone Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `primary_phone` SET TAGS ('dbx_value_regex' = '^+?[0-9s-().]{7,20}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `primary_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `primary_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `principal_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Dealer Principal Contact Email Address');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `principal_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `principal_contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `principal_contact_email` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `principal_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Dealer Principal Contact Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `principal_contact_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `principal_contact_name` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `sales_district_code` SET TAGS ('dbx_business_glossary_term' = 'Sales District Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `sales_district_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `sap_customer_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Customer Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `sap_customer_number` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `service_bay_count` SET TAGS ('dbx_business_glossary_term' = 'Service Bay Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `showroom_display_capacity` SET TAGS ('dbx_business_glossary_term' = 'Showroom Display Vehicle Capacity');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `showroom_display_capacity` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `state_province_code` SET TAGS ('dbx_business_glossary_term' = 'State or Province Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `state_province_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,5}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `state_province_code` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `trading_name` SET TAGS ('dbx_business_glossary_term' = 'Dealer Trading Name (DBA)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `used_vehicle_sales_capacity` SET TAGS ('dbx_business_glossary_term' = 'Used Vehicle Annual Sales Capacity');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `used_vehicle_sales_capacity` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `warranty_authorized` SET TAGS ('dbx_business_glossary_term' = 'OEM Warranty Repair Authorization Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `website_url` SET TAGS ('dbx_business_glossary_term' = 'Dealer Website URL');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `website_url` SET TAGS ('dbx_value_regex' = '^https?://[^s]{3,255}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` SET TAGS ('dbx_subdomain' = 'network_management');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `franchise_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `franchise_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `agreement_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `agreement_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `agreement_document_url` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Document URL');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `agreement_document_url` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `agreement_name` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_value_regex' = '^FA-[0-9]{8}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `agreement_status` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `agreement_status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|active|suspended|terminated|expired');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'new_franchise|renewal|amendment|expansion|termination');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `allocation_priority_tier` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Allocation Priority Tier');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `allocation_priority_tier` SET TAGS ('dbx_value_regex' = 'tier_1|tier_2|tier_3|tier_4|standard');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `authorized_nameplates` SET TAGS ('dbx_business_glossary_term' = 'Authorized Vehicle Nameplates');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `authorized_vehicle_lines` SET TAGS ('dbx_business_glossary_term' = 'Authorized Vehicle Lines');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Auto-Renewal Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `certified_pre_owned_authorized_flag` SET TAGS ('dbx_business_glossary_term' = 'Certified Pre-Owned (CPO) Authorized Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `commercial_fleet_authorized_flag` SET TAGS ('dbx_business_glossary_term' = 'Commercial Fleet Sales Authorized Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `customer_satisfaction_target_score` SET TAGS ('dbx_business_glossary_term' = 'Customer Satisfaction Target Score (NPS)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `dealer_signatory_name` SET TAGS ('dbx_business_glossary_term' = 'Dealer Signatory Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `digital_retailing_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Digital Retailing Required Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `dms_integration_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Integration Required Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Effective Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `ev_charging_infrastructure_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Electric Vehicle (EV) Charging Infrastructure Required Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `exclusive_territory_flag` SET TAGS ('dbx_business_glossary_term' = 'Exclusive Territory Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `facility_investment_requirement_amount` SET TAGS ('dbx_business_glossary_term' = 'Facility Investment Requirement Amount (CapEx)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `facility_investment_requirement_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `franchise_tier` SET TAGS ('dbx_business_glossary_term' = 'Franchise Tier');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `franchise_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `governing_law_jurisdiction` SET TAGS ('dbx_business_glossary_term' = 'Governing Law Jurisdiction');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `incentive_program_eligibility_flag` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Eligibility Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `minimum_sales_quota_annual` SET TAGS ('dbx_business_glossary_term' = 'Minimum Annual Sales Quota (Units)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `minimum_service_capacity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Service Capacity (Vehicles per Month)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `minimum_service_capacity` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Notice Period (Days)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `oem_signatory_name` SET TAGS ('dbx_business_glossary_term' = 'OEM (Original Equipment Manufacturer) Signatory Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `ownership_model` SET TAGS ('dbx_business_glossary_term' = 'Ownership Model');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `ownership_model` SET TAGS ('dbx_value_regex' = 'oem_owned|independent_franchise|joint_venture|corporate_store');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `parts_inventory_requirement_amount` SET TAGS ('dbx_business_glossary_term' = 'Parts Inventory Requirement Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `parts_inventory_requirement_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `performance_review_frequency` SET TAGS ('dbx_business_glossary_term' = 'Performance Review Frequency');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `performance_review_frequency` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annual|annual');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `recall_service_authorized_flag` SET TAGS ('dbx_business_glossary_term' = 'Recall Service Authorized Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `renewal_date` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Renewal Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `renewal_term_months` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Renewal Term (Months)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `signed_date` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Signed Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Termination Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Termination Reason');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `territory_description` SET TAGS ('dbx_business_glossary_term' = 'Franchise Territory Description');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `territory_radius_km` SET TAGS ('dbx_business_glossary_term' = 'Franchise Territory Radius (Kilometers)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `training_certification_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Training Certification Required Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `warranty_administration_authorized_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Administration Authorized Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` SET TAGS ('dbx_subdomain' = 'network_management');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `dealer_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Territory Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `franchise_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Territory Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `allocation_quota_percentage` SET TAGS ('dbx_business_glossary_term' = 'Allocation Quota Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `city_list` SET TAGS ('dbx_business_glossary_term' = 'City List');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `city_list` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `competitive_intensity_rating` SET TAGS ('dbx_business_glossary_term' = 'Competitive Intensity Rating');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `competitive_intensity_rating` SET TAGS ('dbx_value_regex' = 'low|medium|high|very_high');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `county_region` SET TAGS ('dbx_business_glossary_term' = 'County or Region');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `dms_integration_status` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Integration Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `dms_integration_status` SET TAGS ('dbx_value_regex' = 'integrated|pending|failed|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `dms_last_sync_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Last Synchronization Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `geographic_boundary_description` SET TAGS ('dbx_business_glossary_term' = 'Geographic Boundary Description');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `household_count_estimate` SET TAGS ('dbx_business_glossary_term' = 'Household Count Estimate');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `incentive_program_eligibility_flag` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Eligibility Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `manager_email` SET TAGS ('dbx_business_glossary_term' = 'Territory Manager Email Address');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `manager_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `manager_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `manager_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `manager_name` SET TAGS ('dbx_business_glossary_term' = 'Territory Manager Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `manager_name` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `manager_phone` SET TAGS ('dbx_business_glossary_term' = 'Territory Manager Phone Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `manager_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `manager_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `market_segment_classification` SET TAGS ('dbx_business_glossary_term' = 'Market Segment Classification');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `market_segment_classification` SET TAGS ('dbx_value_regex' = 'urban|suburban|rural|metro|mixed');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `modification_reason` SET TAGS ('dbx_business_glossary_term' = 'Modification Reason');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `overlap_allowed_flag` SET TAGS ('dbx_business_glossary_term' = 'Territory Overlap Allowed Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `overlap_rule_description` SET TAGS ('dbx_business_glossary_term' = 'Overlap Rule Description');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `performance_benchmark_group` SET TAGS ('dbx_business_glossary_term' = 'Performance Benchmark Group');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `population_estimate` SET TAGS ('dbx_business_glossary_term' = 'Population Estimate');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `postal_code_list` SET TAGS ('dbx_business_glossary_term' = 'Postal Code List');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `postal_code_list` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `postal_code_list` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `primary_area_of_responsibility` SET TAGS ('dbx_business_glossary_term' = 'Primary Area of Responsibility (PAR)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `sales_potential_index` SET TAGS ('dbx_business_glossary_term' = 'Sales Potential Index');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `special_program_notes` SET TAGS ('dbx_business_glossary_term' = 'Special Program Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `state_province_code` SET TAGS ('dbx_business_glossary_term' = 'State or Province Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `state_province_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `state_province_code` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `territory_code` SET TAGS ('dbx_business_glossary_term' = 'Territory Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `territory_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,12}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `territory_name` SET TAGS ('dbx_business_glossary_term' = 'Territory Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `territory_status` SET TAGS ('dbx_business_glossary_term' = 'Territory Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `territory_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|suspended|under_review|terminated');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `territory_type` SET TAGS ('dbx_business_glossary_term' = 'Territory Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `territory_type` SET TAGS ('dbx_value_regex' = 'exclusive|shared|open|primary|secondary|overlay');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ALTER COLUMN `vehicle_allocation_priority` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Allocation Priority');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` SET TAGS ('dbx_subdomain' = 'network_management');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `dealer_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Certification Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Obligation Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `allocation_eligibility_flag` SET TAGS ('dbx_business_glossary_term' = 'Allocation Eligibility Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `annual_maintenance_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Annual Maintenance Cost Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `annual_maintenance_cost_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `audit_outcome` SET TAGS ('dbx_business_glossary_term' = 'Audit Outcome');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `audit_outcome` SET TAGS ('dbx_value_regex' = 'PASSED|PASSED_WITH_CONDITIONS|FAILED|NOT_APPLICABLE');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `audit_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Audit Required Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `audit_score` SET TAGS ('dbx_business_glossary_term' = 'Audit Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `authorized_vehicle_lines` SET TAGS ('dbx_business_glossary_term' = 'Authorized Vehicle Lines');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `certification_level` SET TAGS ('dbx_business_glossary_term' = 'Certification Level');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `certification_level` SET TAGS ('dbx_value_regex' = 'BRONZE|SILVER|GOLD|PLATINUM|ELITE|STANDARD');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `certification_name` SET TAGS ('dbx_business_glossary_term' = 'Certification Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `certification_number` SET TAGS ('dbx_business_glossary_term' = 'Certification Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `certification_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `certification_status` SET TAGS ('dbx_business_glossary_term' = 'Certification Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `certification_status` SET TAGS ('dbx_value_regex' = 'ACTIVE|EXPIRED|SUSPENDED|PENDING_RENEWAL|REVOKED|UNDER_REVIEW');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `certification_type` SET TAGS ('dbx_business_glossary_term' = 'Certification Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `certification_type` SET TAGS ('dbx_value_regex' = 'EV_CERTIFIED|ADAS_SERVICE|LUXURY_BRAND|COMMERCIAL_VEHICLE|HYBRID_SPECIALIST|PERFORMANCE_TUNING');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Certification Cost Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `cost_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `equipment_requirements` SET TAGS ('dbx_business_glossary_term' = 'Equipment Requirements');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `facility_requirements` SET TAGS ('dbx_business_glossary_term' = 'Facility Requirements');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_business_glossary_term' = 'Geographic Scope');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_value_regex' = 'GLOBAL|REGIONAL|NATIONAL|STATE_PROVINCIAL|LOCAL');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `incentive_eligibility_flag` SET TAGS ('dbx_business_glossary_term' = 'Incentive Eligibility Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Issue Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `issuing_body` SET TAGS ('dbx_business_glossary_term' = 'Issuing Body');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `issuing_body_type` SET TAGS ('dbx_business_glossary_term' = 'Issuing Body Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `issuing_body_type` SET TAGS ('dbx_value_regex' = 'OEM_CORPORATE|INDUSTRY_ASSOCIATION|REGULATORY_BODY|THIRD_PARTY_AUDITOR|REGIONAL_OEM');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Last Audit Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `last_renewal_date` SET TAGS ('dbx_business_glossary_term' = 'Last Renewal Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `minimum_certified_technicians` SET TAGS ('dbx_business_glossary_term' = 'Minimum Certified Technicians');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `next_audit_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Audit Due Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `next_renewal_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Renewal Due Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `personnel_requirements` SET TAGS ('dbx_business_glossary_term' = 'Personnel Requirements');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `reinstatement_date` SET TAGS ('dbx_business_glossary_term' = 'Reinstatement Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `renewal_frequency_months` SET TAGS ('dbx_business_glossary_term' = 'Renewal Frequency in Months');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `revocation_date` SET TAGS ('dbx_business_glossary_term' = 'Revocation Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `revocation_reason` SET TAGS ('dbx_business_glossary_term' = 'Revocation Reason');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `suspension_date` SET TAGS ('dbx_business_glossary_term' = 'Suspension Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `suspension_reason` SET TAGS ('dbx_business_glossary_term' = 'Suspension Reason');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `training_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Training Completion Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ALTER COLUMN `training_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Training Required Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` SET TAGS ('dbx_subdomain' = 'inventory_operations');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `vehicle_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Allocation ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `production_order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `vehicle_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `acceptance_deadline` SET TAGS ('dbx_business_glossary_term' = 'Acceptance Deadline');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `acceptance_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Acceptance Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `accepted_quantity` SET TAGS ('dbx_business_glossary_term' = 'Accepted Quantity');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `allocation_batch_number` SET TAGS ('dbx_business_glossary_term' = 'Allocation Batch Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `allocation_date` SET TAGS ('dbx_business_glossary_term' = 'Allocation Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `allocation_number` SET TAGS ('dbx_business_glossary_term' = 'Allocation Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `allocation_number` SET TAGS ('dbx_value_regex' = '^ALLOC-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `allocation_rule_code` SET TAGS ('dbx_business_glossary_term' = 'Allocation Rule Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `allocation_status` SET TAGS ('dbx_business_glossary_term' = 'Allocation Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `allocation_status` SET TAGS ('dbx_value_regex' = 'pending|confirmed|accepted|rejected|cancelled|delivered');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `allocation_type` SET TAGS ('dbx_business_glossary_term' = 'Allocation Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `allocation_type` SET TAGS ('dbx_value_regex' = 'standard|priority|constrained|fleet|demo|loaner');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `dealer_invoice_price` SET TAGS ('dbx_business_glossary_term' = 'Dealer Invoice Price');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `dealer_invoice_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `dms_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Reference Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `estimated_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `hold_code` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Hold Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `incentive_amount` SET TAGS ('dbx_business_glossary_term' = 'Incentive Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `incentive_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `incentive_program_code` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `is_customer_order` SET TAGS ('dbx_business_glossary_term' = 'Customer Order Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `msrp` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `msrp` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Allocation Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `pdi_completed` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Completed Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `pdi_required` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Required Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `port_of_entry_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Entry Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `port_of_entry_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3,5}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `priority_tier` SET TAGS ('dbx_business_glossary_term' = 'Priority Tier');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `priority_tier` SET TAGS ('dbx_value_regex' = 'tier_1|tier_2|tier_3|tier_4');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `production_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `production_plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,6}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,5}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `rejection_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `scheduled_production_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Production Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `source_system_code` SET TAGS ('dbx_value_regex' = 'SAP_SD|CDK_DMS|SALESFORCE|MES|MANUAL');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `territory_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Territory Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `territory_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'rail|truck|ship|compound');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` SET TAGS ('dbx_subdomain' = 'network_management');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `allocation_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Allocation Rule ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `dealer_incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Incentive Program ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `superseded_by_rule_allocation_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Allocation Rule ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `allocation_basis` SET TAGS ('dbx_business_glossary_term' = 'Allocation Basis');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `allocation_basis` SET TAGS ('dbx_value_regex' = 'retail_sales|wholesale_orders|days_supply|market_share|scorecard_rank');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `allocation_cycle` SET TAGS ('dbx_business_glossary_term' = 'Allocation Cycle');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `allocation_cycle` SET TAGS ('dbx_value_regex' = 'weekly|biweekly|monthly|quarterly');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|under_review');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `body_style` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Body Style');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `carryover_allowed` SET TAGS ('dbx_business_glossary_term' = 'Carryover Allocation Allowed');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `conflict_resolution` SET TAGS ('dbx_business_glossary_term' = 'Conflict Resolution Method');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `conflict_resolution` SET TAGS ('dbx_value_regex' = 'highest_priority|lowest_priority|sum|average|manual');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `dealer_tier` SET TAGS ('dbx_business_glossary_term' = 'Dealer Tier');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `dealer_tier` SET TAGS ('dbx_value_regex' = 'tier_1|tier_2|tier_3|all');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `eop_date` SET TAGS ('dbx_business_glossary_term' = 'End of Production (EOP) Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `external_rule_ref` SET TAGS ('dbx_business_glossary_term' = 'External Rule Reference');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `franchise_type` SET TAGS ('dbx_business_glossary_term' = 'Franchise Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `franchise_type` SET TAGS ('dbx_value_regex' = 'oem_owned|independent_franchise|dual_franchise|all');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `lookback_period_days` SET TAGS ('dbx_business_glossary_term' = 'Lookback Period (Days)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `max_allocation_units` SET TAGS ('dbx_business_glossary_term' = 'Maximum Allocation Units');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `min_allocation_units` SET TAGS ('dbx_business_glossary_term' = 'Minimum Allocation Units');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `min_csi_score` SET TAGS ('dbx_business_glossary_term' = 'Minimum Customer Satisfaction Index (CSI) Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `min_scorecard_score` SET TAGS ('dbx_business_glossary_term' = 'Minimum Dealer Scorecard Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `model_mix_target_pct` SET TAGS ('dbx_business_glossary_term' = 'Model Mix Target Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `nameplate_code` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Nameplate Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `override_allowed` SET TAGS ('dbx_business_glossary_term' = 'Manual Override Allowed');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV|all');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `priority_weight` SET TAGS ('dbx_business_glossary_term' = 'Priority Weight');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Region Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `rule_code` SET TAGS ('dbx_business_glossary_term' = 'Allocation Rule Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `rule_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,30}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `rule_description` SET TAGS ('dbx_business_glossary_term' = 'Allocation Rule Description');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `rule_name` SET TAGS ('dbx_business_glossary_term' = 'Allocation Rule Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `rule_status` SET TAGS ('dbx_business_glossary_term' = 'Allocation Rule Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `rule_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|cancelled');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `rule_type` SET TAGS ('dbx_business_glossary_term' = 'Allocation Rule Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `rule_type` SET TAGS ('dbx_value_regex' = 'volume_based|performance_based|geographic|model_mix|incentive_based|priority_based');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `sop_date` SET TAGS ('dbx_business_glossary_term' = 'Start of Production (SOP) Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `stackable` SET TAGS ('dbx_business_glossary_term' = 'Rule Stackable Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `target_days_supply` SET TAGS ('dbx_business_glossary_term' = 'Target Days Supply');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `total_pool_units` SET TAGS ('dbx_business_glossary_term' = 'Total Allocation Pool Units');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Rule Version Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `zone_code` SET TAGS ('dbx_business_glossary_term' = 'Distribution Zone Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`allocation_rule` ALTER COLUMN `zone_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` SET TAGS ('dbx_subdomain' = 'inventory_operations');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `dealer_inventory_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Inventory ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `finished_vehicle_stock_id` SET TAGS ('dbx_business_glossary_term' = 'Finished Vehicle Stock Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `homologation_record_id` SET TAGS ('dbx_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Inventory Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `vehicle_build_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Build Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `allocation_order_number` SET TAGS ('dbx_business_glossary_term' = 'OEM Allocation Order Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `asking_price` SET TAGS ('dbx_business_glossary_term' = 'Current Asking Price');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `asking_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `body_style` SET TAGS ('dbx_business_glossary_term' = 'Body Style');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `certified_pre_owned` SET TAGS ('dbx_business_glossary_term' = 'Certified Pre-Owned (CPO) Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `days_on_lot` SET TAGS ('dbx_business_glossary_term' = 'Days on Lot');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `dms_record_reference` SET TAGS ('dbx_business_glossary_term' = 'DMS Record ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `drivetrain` SET TAGS ('dbx_business_glossary_term' = 'Drivetrain Configuration');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `drivetrain` SET TAGS ('dbx_value_regex' = 'FWD|RWD|AWD|4WD');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `engine_description` SET TAGS ('dbx_business_glossary_term' = 'Engine Description');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `estimated_arrival_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated Arrival Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `exterior_color_code` SET TAGS ('dbx_business_glossary_term' = 'Exterior Color Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `exterior_color_name` SET TAGS ('dbx_business_glossary_term' = 'Exterior Color Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `floor_plan_date` SET TAGS ('dbx_business_glossary_term' = 'Floor Plan Start Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `floor_plan_lender` SET TAGS ('dbx_business_glossary_term' = 'Floor Plan Lender');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `floor_plan_lender` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `fuel_economy_city_mpg` SET TAGS ('dbx_business_glossary_term' = 'City Fuel Economy (MPG)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `fuel_economy_city_mpg` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `fuel_economy_highway_mpg` SET TAGS ('dbx_business_glossary_term' = 'Highway Fuel Economy (MPG)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `in_service_date` SET TAGS ('dbx_business_glossary_term' = 'In-Service Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `interior_color_code` SET TAGS ('dbx_business_glossary_term' = 'Interior Color Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `interior_color_name` SET TAGS ('dbx_business_glossary_term' = 'Interior Color Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `inventory_status` SET TAGS ('dbx_business_glossary_term' = 'Inventory Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `inventory_type` SET TAGS ('dbx_business_glossary_term' = 'Inventory Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `inventory_type` SET TAGS ('dbx_value_regex' = 'new|used|certified_pre_owned|demo|loaner');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `invoice_price` SET TAGS ('dbx_business_glossary_term' = 'Invoice Price');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `invoice_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `last_price_update_date` SET TAGS ('dbx_business_glossary_term' = 'Last Price Update Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `location_code` SET TAGS ('dbx_business_glossary_term' = 'Lot Location Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `msrp` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `msrp` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `odometer_reading` SET TAGS ('dbx_business_glossary_term' = 'Odometer Reading (Miles)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `pdi_completed` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Completed Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `pdi_completed_date` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Completion Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `recall_campaign_number` SET TAGS ('dbx_business_glossary_term' = 'NHTSA Recall Campaign Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `recall_hold` SET TAGS ('dbx_business_glossary_term' = 'Recall Hold Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `received_date` SET TAGS ('dbx_business_glossary_term' = 'Received Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `source_type` SET TAGS ('dbx_business_glossary_term' = 'Inventory Source Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `source_type` SET TAGS ('dbx_value_regex' = 'factory_order|dealer_trade|auction|trade_in|fleet_return|lease_return');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `stock_number` SET TAGS ('dbx_business_glossary_term' = 'Dealer Stock Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `transmission_type` SET TAGS ('dbx_business_glossary_term' = 'Transmission Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `transmission_type` SET TAGS ('dbx_value_regex' = 'automatic|manual|CVT|DCT|single_speed');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `transport_status` SET TAGS ('dbx_business_glossary_term' = 'Transport Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `transport_status` SET TAGS ('dbx_value_regex' = 'not_shipped|in_transit|delivered|rail|truck');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `window_sticker_url` SET TAGS ('dbx_business_glossary_term' = 'Window Sticker URL (Monroney Label)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` SET TAGS ('dbx_subdomain' = 'inventory_operations');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `parts_inventory_id` SET TAGS ('dbx_business_glossary_term' = 'Parts Inventory ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `parts_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `spare_parts_catalog_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Catalog Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `average_monthly_demand` SET TAGS ('dbx_business_glossary_term' = 'Average Monthly Demand');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `bin_location` SET TAGS ('dbx_business_glossary_term' = 'Bin Location');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `bin_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `core_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Core Charge Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `dealer_cost_price` SET TAGS ('dbx_business_glossary_term' = 'Dealer Cost Price');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `dealer_cost_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `inventory_snapshot_date` SET TAGS ('dbx_business_glossary_term' = 'Inventory Snapshot Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `inventory_status` SET TAGS ('dbx_business_glossary_term' = 'Inventory Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `inventory_status` SET TAGS ('dbx_value_regex' = 'active|discontinued|superseded|backordered|restricted|obsolete');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `is_core_part` SET TAGS ('dbx_business_glossary_term' = 'Core Part Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `is_hazardous_material` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `is_serialized` SET TAGS ('dbx_business_glossary_term' = 'Serialized Part Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `last_count_date` SET TAGS ('dbx_business_glossary_term' = 'Last Physical Count Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `last_receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Last Receipt Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `last_sale_date` SET TAGS ('dbx_business_glossary_term' = 'Last Sale Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time Days');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `list_price` SET TAGS ('dbx_business_glossary_term' = 'List Price');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `lost_sales_quantity` SET TAGS ('dbx_business_glossary_term' = 'Lost Sales Quantity');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `maximum_stock_level` SET TAGS ('dbx_business_glossary_term' = 'Maximum Stock Level');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `model_year_applicability` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY) Applicability');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `model_year_applicability` SET TAGS ('dbx_value_regex' = '^[0-9]{4}(-[0-9]{4})?$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `months_supply` SET TAGS ('dbx_business_glossary_term' = 'Months Supply');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `oem_part_number` SET TAGS ('dbx_business_glossary_term' = 'Original Equipment Manufacturer (OEM) Part Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `oem_part_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{4,25}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `parts_classification` SET TAGS ('dbx_business_glossary_term' = 'Parts Classification');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `parts_classification` SET TAGS ('dbx_value_regex' = 'mechanical|body|electrical|accessories|fluids|consumables');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `parts_group_code` SET TAGS ('dbx_business_glossary_term' = 'Parts Group Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `parts_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `quantity_available` SET TAGS ('dbx_business_glossary_term' = 'Quantity Available');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `quantity_on_hand` SET TAGS ('dbx_business_glossary_term' = 'Quantity On Hand');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `quantity_on_order` SET TAGS ('dbx_business_glossary_term' = 'Quantity On Order');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `quantity_reserved` SET TAGS ('dbx_business_glossary_term' = 'Quantity Reserved');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `recall_campaign_number` SET TAGS ('dbx_business_glossary_term' = 'Recall Campaign Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `recall_campaign_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{4,20}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `recall_flag` SET TAGS ('dbx_business_glossary_term' = 'Recall Part Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `reorder_point` SET TAGS ('dbx_business_glossary_term' = 'Reorder Point');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `reorder_quantity` SET TAGS ('dbx_business_glossary_term' = 'Reorder Quantity');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `retail_price` SET TAGS ('dbx_business_glossary_term' = 'Retail Price');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `sku` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{4,30}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `storage_condition` SET TAGS ('dbx_business_glossary_term' = 'Storage Condition');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `storage_condition` SET TAGS ('dbx_value_regex' = 'ambient|refrigerated|flammable|controlled|outdoor');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `superseded_by_date` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `superseding_part_number` SET TAGS ('dbx_business_glossary_term' = 'Superseding Part Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `superseding_part_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{4,25}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `supplier_part_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Part Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `supplier_part_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{4,30}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `vehicle_model_applicability` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Model Applicability');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `warranty_eligible` SET TAGS ('dbx_business_glossary_term' = 'Warranty Eligible Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` SET TAGS ('dbx_subdomain' = 'sales_performance');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `retail_sale_id` SET TAGS ('dbx_business_glossary_term' = 'Retail Sale ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `retail_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Salesperson ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `retail_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `retail_salesperson_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Salesperson ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `retail_salesperson_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `retail_salesperson_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `apr` SET TAGS ('dbx_business_glossary_term' = 'Annual Percentage Rate (APR)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `apr` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `back_end_gross` SET TAGS ('dbx_business_glossary_term' = 'Back-End Gross Profit');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `back_end_gross` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `deal_number` SET TAGS ('dbx_business_glossary_term' = 'Deal Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `deal_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{4,20}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `deal_status` SET TAGS ('dbx_business_glossary_term' = 'Deal Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `deal_status` SET TAGS ('dbx_value_regex' = 'draft|pending|funded|unwound|cancelled');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `discount_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `dms_deal_reference` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Deal ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `doc_fee` SET TAGS ('dbx_business_glossary_term' = 'Documentation Fee');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `down_payment` SET TAGS ('dbx_business_glossary_term' = 'Down Payment Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `down_payment` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `down_payment` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `fi_product_revenue` SET TAGS ('dbx_business_glossary_term' = 'Finance and Insurance (F&I) Product Revenue');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `fi_product_revenue` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `finance_amount` SET TAGS ('dbx_business_glossary_term' = 'Finance Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `finance_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `finance_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `financing_type` SET TAGS ('dbx_business_glossary_term' = 'Financing Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `financing_type` SET TAGS ('dbx_value_regex' = 'cash|retail_finance|lease|balloon');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `fleet_sale` SET TAGS ('dbx_business_glossary_term' = 'Fleet Sale Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `front_end_gross` SET TAGS ('dbx_business_glossary_term' = 'Front-End Gross Profit');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `front_end_gross` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `lender_name` SET TAGS ('dbx_business_glossary_term' = 'Lender Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `loan_term_months` SET TAGS ('dbx_business_glossary_term' = 'Loan Term (Months)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `monthly_payment` SET TAGS ('dbx_business_glossary_term' = 'Monthly Payment Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `monthly_payment` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `monthly_payment` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `msrp_amount` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `msrp_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `oem_incentive_amount` SET TAGS ('dbx_business_glossary_term' = 'OEM Incentive Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `oem_incentive_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `oem_program_code` SET TAGS ('dbx_business_glossary_term' = 'OEM Incentive Program Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `pdi_completed` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Completed Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `sale_date` SET TAGS ('dbx_business_glossary_term' = 'Sale Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `sale_price` SET TAGS ('dbx_business_glossary_term' = 'Sale Price');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `sale_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `sale_price` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `sales_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Sales Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `stock_number` SET TAGS ('dbx_business_glossary_term' = 'Dealer Stock Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `trade_in_allowance` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Allowance');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `trade_in_allowance` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `trade_in_payoff_amount` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Payoff Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `trade_in_payoff_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `trade_in_vin` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `trade_in_vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `vehicle_condition` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Condition');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `vehicle_condition` SET TAGS ('dbx_value_regex' = 'new|used|certified_pre_owned');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Start Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` SET TAGS ('dbx_subdomain' = 'service_execution');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `dealer_service_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for dealer_service_appointment');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `aftersales_service_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Aftersales Service Appointment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Service Advisor Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `test_event_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Test Event Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` SET TAGS ('dbx_subdomain' = 'service_execution');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `dealer_repair_order_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for dealer_repair_order');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `aftersales_repair_order_id` SET TAGS ('dbx_business_glossary_term' = 'Aftersales Repair Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `maintenance_order_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Technician Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` SET TAGS ('dbx_subdomain' = 'sales_performance');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `dealer_incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `announcement_date` SET TAGS ('dbx_business_glossary_term' = 'Program Announcement Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Program Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `dealer_tier_eligibility` SET TAGS ('dbx_business_glossary_term' = 'Dealer Tier Eligibility');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `dealer_tier_eligibility` SET TAGS ('dbx_value_regex' = 'all|platinum|gold|silver|bronze');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `dealer_type_eligibility` SET TAGS ('dbx_business_glossary_term' = 'Dealer Type Eligibility');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `dealer_type_eligibility` SET TAGS ('dbx_value_regex' = 'all|franchise|oem_owned|independent');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `dms_program_reference` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Program ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `dms_program_reference` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,50}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Program Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Program Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `eligible_dealer_count` SET TAGS ('dbx_business_glossary_term' = 'Eligible Dealer Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `eligible_nameplates` SET TAGS ('dbx_business_glossary_term' = 'Eligible Nameplates');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `eligible_powertrain_types` SET TAGS ('dbx_business_glossary_term' = 'Eligible Powertrain Types');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `eligible_powertrain_types` SET TAGS ('dbx_value_regex' = 'ICE|EV|HEV|PHEV|all');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `floor_plan_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Floor Plan Assistance Rate Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `floor_plan_rate_pct` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `max_payout_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Program Payout Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `max_payout_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `measurement_period_type` SET TAGS ('dbx_business_glossary_term' = 'Measurement Period Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `measurement_period_type` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|annual|custom');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `min_dealer_tenure_months` SET TAGS ('dbx_business_glossary_term' = 'Minimum Dealer Tenure Months');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `model_year` SET TAGS ('dbx_value_regex' = '^(19|20)d{2}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `oem_program_sponsor` SET TAGS ('dbx_business_glossary_term' = 'OEM Program Sponsor');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `payout_date` SET TAGS ('dbx_business_glossary_term' = 'Program Payout Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `payout_structure_type` SET TAGS ('dbx_business_glossary_term' = 'Payout Structure Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `payout_structure_type` SET TAGS ('dbx_value_regex' = 'flat_bonus|per_unit|percentage_of_msrp|percentage_of_invoice');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `performance_metric` SET TAGS ('dbx_business_glossary_term' = 'Performance Metric');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `performance_metric` SET TAGS ('dbx_value_regex' = 'units_sold|nps_score|csat_score|ev_units_sold|market_share_pct|pdi_compliance_rate');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `program_code` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `program_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,30}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `program_description` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Description');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `program_manager_name` SET TAGS ('dbx_business_glossary_term' = 'Program Manager Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `program_manager_name` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `program_name` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `program_status` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `program_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|closed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `program_type` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `program_type` SET TAGS ('dbx_value_regex' = 'volume_bonus|stair_step|csat_bonus|ev_adoption|floor_plan_assistance|market_representation');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'OEM Sales Region Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `requires_pdi_compliance` SET TAGS ('dbx_business_glossary_term' = 'Requires Pre-Delivery Inspection (PDI) Compliance');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `requires_training_certification` SET TAGS ('dbx_business_glossary_term' = 'Requires Training Certification');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `retroactive_flag` SET TAGS ('dbx_business_glossary_term' = 'Retroactive Payout Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `salesforce_program_reference` SET TAGS ('dbx_business_glossary_term' = 'Salesforce Automotive Cloud Program ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `salesforce_program_reference` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9]{15,18}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `stackable_flag` SET TAGS ('dbx_business_glossary_term' = 'Stackable Program Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `terms_version` SET TAGS ('dbx_business_glossary_term' = 'Program Terms and Conditions Version');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `terms_version` SET TAGS ('dbx_value_regex' = '^vd+.d+$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `tier1_payout_amount` SET TAGS ('dbx_business_glossary_term' = 'Tier 1 Payout Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `tier1_payout_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `tier1_threshold` SET TAGS ('dbx_business_glossary_term' = 'Tier 1 Performance Threshold');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `tier2_payout_amount` SET TAGS ('dbx_business_glossary_term' = 'Tier 2 Payout Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `tier2_payout_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `tier2_threshold` SET TAGS ('dbx_business_glossary_term' = 'Tier 2 Performance Threshold');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `tier3_payout_amount` SET TAGS ('dbx_business_glossary_term' = 'Tier 3 Payout Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `tier3_payout_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `tier3_threshold` SET TAGS ('dbx_business_glossary_term' = 'Tier 3 Performance Threshold');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `tier_count` SET TAGS ('dbx_business_glossary_term' = 'Performance Tier Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `total_program_budget` SET TAGS ('dbx_business_glossary_term' = 'Total Program Budget');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ALTER COLUMN `total_program_budget` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` SET TAGS ('dbx_subdomain' = 'sales_performance');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `dealer_incentive_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Incentive Claim ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `dealer_incentive_program_id` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reviewer Employee ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `accrual_posted` SET TAGS ('dbx_business_glossary_term' = 'Accrual Posted Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `adjustment_amount` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `adjustment_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `adjustment_reason` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Reason');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `adjustment_reason` SET TAGS ('dbx_value_regex' = 'ineligible_units|duplicate_claim|missing_evidence|calculation_error|program_cap_exceeded|other');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `approved_amount` SET TAGS ('dbx_business_glossary_term' = 'Approved Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `approved_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `approved_units` SET TAGS ('dbx_business_glossary_term' = 'Approved Units');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `claim_number` SET TAGS ('dbx_business_glossary_term' = 'Claim Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `claim_number` SET TAGS ('dbx_value_regex' = '^CLM-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `claim_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Claim Period End Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `claim_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Claim Period Start Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `claim_status` SET TAGS ('dbx_business_glossary_term' = 'Claim Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `claim_status` SET TAGS ('dbx_value_regex' = 'submitted|under_review|approved|rejected|paid|cancelled');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `claim_type` SET TAGS ('dbx_business_glossary_term' = 'Claim Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `claimed_amount` SET TAGS ('dbx_business_glossary_term' = 'Claimed Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `claimed_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `claimed_metric_unit` SET TAGS ('dbx_business_glossary_term' = 'Claimed Metric Unit');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `claimed_metric_unit` SET TAGS ('dbx_value_regex' = 'units|percentage|score|amount_usd|amount_local');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `claimed_metric_value` SET TAGS ('dbx_business_glossary_term' = 'Claimed Metric Value');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `claimed_units` SET TAGS ('dbx_business_glossary_term' = 'Claimed Units');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `dealer_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Dealer Contact Email Address');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `dealer_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `dealer_contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `dealer_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `dealer_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Dealer Contact Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `dealer_contact_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `dealer_contact_name` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `dispute_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `dispute_resolution_notes` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `dms_claim_reference` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Claim Reference');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `evidence_document_ref` SET TAGS ('dbx_business_glossary_term' = 'Evidence Document Reference');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `evidence_verified` SET TAGS ('dbx_business_glossary_term' = 'Evidence Verified Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `paid_amount` SET TAGS ('dbx_business_glossary_term' = 'Paid Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `paid_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `payment_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `payment_reference` SET TAGS ('dbx_business_glossary_term' = 'Payment Reference');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ICE|HEV|PHEV|EV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `program_quarter` SET TAGS ('dbx_business_glossary_term' = 'Program Quarter');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `program_quarter` SET TAGS ('dbx_value_regex' = 'Q1|Q2|Q3|Q4');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `program_year` SET TAGS ('dbx_business_glossary_term' = 'Program Year');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `review_date` SET TAGS ('dbx_business_glossary_term' = 'Review Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `sap_fi_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Financial (FI) Document Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'Claim Submission Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ALTER COLUMN `vehicle_line_code` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Line Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` SET TAGS ('dbx_subdomain' = 'sales_performance');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `performance_scorecard_id` SET TAGS ('dbx_business_glossary_term' = 'Performance Scorecard ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `performance_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Comments');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `composite_score` SET TAGS ('dbx_business_glossary_term' = 'Composite Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `composite_score_benchmark` SET TAGS ('dbx_business_glossary_term' = 'Composite Score Benchmark');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `csi_benchmark` SET TAGS ('dbx_business_glossary_term' = 'Customer Satisfaction Index (CSI) Benchmark');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `csi_score` SET TAGS ('dbx_business_glossary_term' = 'Customer Satisfaction Index (CSI) Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `days_supply` SET TAGS ('dbx_business_glossary_term' = 'Days Supply');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `dms_integration_source` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Integration Source');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `dms_integration_source` SET TAGS ('dbx_value_regex' = 'CDK_Global|Reynolds_Reynolds|Dealertrack|ADP|Other');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `facility_standards_score` SET TAGS ('dbx_business_glossary_term' = 'Facility Standards Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `fiscal_quarter` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Quarter');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year (FY)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `franchise_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Franchise Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `franchise_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|probation|warning');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `incentive_eligibility_flag` SET TAGS ('dbx_business_glossary_term' = 'Incentive Eligibility Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `inventory_turn_rate` SET TAGS ('dbx_business_glossary_term' = 'Inventory Turn Rate');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `market_share_pct` SET TAGS ('dbx_business_glossary_term' = 'Market Share Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `new_vehicle_sales_actual` SET TAGS ('dbx_business_glossary_term' = 'New Vehicle Sales Actual');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `new_vehicle_sales_attainment_pct` SET TAGS ('dbx_business_glossary_term' = 'New Vehicle Sales Attainment Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `new_vehicle_sales_objective` SET TAGS ('dbx_business_glossary_term' = 'New Vehicle Sales Objective');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `nps_benchmark` SET TAGS ('dbx_business_glossary_term' = 'Net Promoter Score (NPS) Benchmark');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `nps_score` SET TAGS ('dbx_business_glossary_term' = 'Net Promoter Score (NPS)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `parts_fill_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Parts Fill Rate Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `parts_revenue_actual` SET TAGS ('dbx_business_glossary_term' = 'Parts Revenue Actual');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `parts_revenue_objective` SET TAGS ('dbx_business_glossary_term' = 'Parts Revenue Objective');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `performance_tier` SET TAGS ('dbx_business_glossary_term' = 'Performance Tier');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `performance_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `period_type` SET TAGS ('dbx_business_glossary_term' = 'Period Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `period_type` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|annual');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `published_date` SET TAGS ('dbx_business_glossary_term' = 'Published Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `reviewer_name` SET TAGS ('dbx_business_glossary_term' = 'Reviewer Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `scorecard_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Scorecard Period End Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `scorecard_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Scorecard Period Start Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `scorecard_status` SET TAGS ('dbx_business_glossary_term' = 'Scorecard Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `scorecard_status` SET TAGS ('dbx_value_regex' = 'draft|published|final|revised');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `service_absorption_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Service Absorption Rate Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `service_revenue_actual` SET TAGS ('dbx_business_glossary_term' = 'Service Revenue Actual');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `service_revenue_objective` SET TAGS ('dbx_business_glossary_term' = 'Service Revenue Objective');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `training_compliance_pct` SET TAGS ('dbx_business_glossary_term' = 'Training Compliance Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `used_vehicle_sales_actual` SET TAGS ('dbx_business_glossary_term' = 'Used Vehicle Sales Actual');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `used_vehicle_sales_attainment_pct` SET TAGS ('dbx_business_glossary_term' = 'Used Vehicle Sales Attainment Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `used_vehicle_sales_objective` SET TAGS ('dbx_business_glossary_term' = 'Used Vehicle Sales Objective');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`performance_scorecard` ALTER COLUMN `warranty_claim_approval_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Approval Rate Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` SET TAGS ('dbx_subdomain' = 'sales_performance');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `csi_survey_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Satisfaction Index (CSI) Survey ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `csi_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `dealer_order_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Order ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `csi_repair_order_id` SET TAGS ('dbx_business_glossary_term' = 'Repair Order (RO) ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `individual_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `complaint_category` SET TAGS ('dbx_business_glossary_term' = 'Complaint Category');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `complaint_flag` SET TAGS ('dbx_business_glossary_term' = 'Complaint Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `days_to_response` SET TAGS ('dbx_business_glossary_term' = 'Days to Response');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `dealer_performance_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Dealer Performance Impact Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `delivery_process_score` SET TAGS ('dbx_business_glossary_term' = 'Delivery Process Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `facility_cleanliness_score` SET TAGS ('dbx_business_glossary_term' = 'Facility Cleanliness Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `follow_up_completed_flag` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Completed Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `follow_up_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Completion Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `follow_up_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Required Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `interaction_date` SET TAGS ('dbx_business_glossary_term' = 'Interaction Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `market_code` SET TAGS ('dbx_business_glossary_term' = 'Market Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `market_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `nps_category` SET TAGS ('dbx_business_glossary_term' = 'Net Promoter Score (NPS) Category');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `nps_category` SET TAGS ('dbx_value_regex' = 'promoter|passive|detractor');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `nps_score` SET TAGS ('dbx_business_glossary_term' = 'Net Promoter Score (NPS)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `oem_program_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'Original Equipment Manufacturer (OEM) Program Compliant Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `overall_satisfaction_score` SET TAGS ('dbx_business_glossary_term' = 'Overall Satisfaction Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `pricing_transparency_score` SET TAGS ('dbx_business_glossary_term' = 'Pricing Transparency Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `problem_resolution_score` SET TAGS ('dbx_business_glossary_term' = 'Problem Resolution Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `response_channel` SET TAGS ('dbx_business_glossary_term' = 'Response Channel');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `sales_consultant_score` SET TAGS ('dbx_business_glossary_term' = 'Sales Consultant Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `sales_region_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Region Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `sentiment_category` SET TAGS ('dbx_business_glossary_term' = 'Sentiment Category');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `sentiment_category` SET TAGS ('dbx_value_regex' = 'positive|neutral|negative|mixed');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `sentiment_score` SET TAGS ('dbx_business_glossary_term' = 'Sentiment Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `service_advisor_score` SET TAGS ('dbx_business_glossary_term' = 'Service Advisor Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `service_quality_score` SET TAGS ('dbx_business_glossary_term' = 'Service Quality Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `service_timeliness_score` SET TAGS ('dbx_business_glossary_term' = 'Service Timeliness Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `staff_courtesy_score` SET TAGS ('dbx_business_glossary_term' = 'Staff Courtesy Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `survey_completion_percentage` SET TAGS ('dbx_business_glossary_term' = 'Survey Completion Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `survey_date` SET TAGS ('dbx_business_glossary_term' = 'Survey Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `survey_language_code` SET TAGS ('dbx_business_glossary_term' = 'Survey Language Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `survey_language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `survey_program_code` SET TAGS ('dbx_business_glossary_term' = 'Survey Program Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `survey_status` SET TAGS ('dbx_business_glossary_term' = 'Survey Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `survey_status` SET TAGS ('dbx_value_regex' = 'completed|partial|abandoned|invalid');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `survey_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Survey Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `survey_type` SET TAGS ('dbx_business_glossary_term' = 'Survey Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `survey_type` SET TAGS ('dbx_value_regex' = 'sales_satisfaction|service_satisfaction|delivery_satisfaction|parts_satisfaction|general_satisfaction|pdi_satisfaction');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `survey_vendor_code` SET TAGS ('dbx_business_glossary_term' = 'Survey Vendor Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `vehicle_condition_score` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Condition Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `verbatim_comment` SET TAGS ('dbx_business_glossary_term' = 'Verbatim Comment');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` SET TAGS ('dbx_subdomain' = 'service_execution');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `service_capacity_id` SET TAGS ('dbx_business_glossary_term' = 'Service Capacity ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `service_capacity_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `service_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `a_tech_headcount` SET TAGS ('dbx_business_glossary_term' = 'A-Level Technician Headcount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `adas_certified_tech_count` SET TAGS ('dbx_business_glossary_term' = 'Advanced Driver Assistance Systems (ADAS) Certified Technician Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `adas_service_bays` SET TAGS ('dbx_business_glossary_term' = 'Advanced Driver Assistance Systems (ADAS) Service Bays');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `available_labor_hours_per_day` SET TAGS ('dbx_business_glossary_term' = 'Available Labor Hours Per Day');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `avg_ro_cycle_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Average Repair Order (RO) Cycle Time Hours');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `b_tech_headcount` SET TAGS ('dbx_business_glossary_term' = 'B-Level Technician Headcount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `body_shop_bays` SET TAGS ('dbx_business_glossary_term' = 'Body Shop Service Bays');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `body_shop_tech_count` SET TAGS ('dbx_business_glossary_term' = 'Body Shop Technician Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `c_tech_headcount` SET TAGS ('dbx_business_glossary_term' = 'C-Level Technician Headcount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `capacity_config_code` SET TAGS ('dbx_business_glossary_term' = 'Service Capacity Configuration Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `capacity_config_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `capacity_config_code` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `capacity_notes` SET TAGS ('dbx_business_glossary_term' = 'Service Capacity Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `capacity_notes` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `capacity_status` SET TAGS ('dbx_business_glossary_term' = 'Service Capacity Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `capacity_status` SET TAGS ('dbx_value_regex' = 'active|inactive|seasonal|reduced|expanded|under_review');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `capacity_status` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `current_capacity_utilization_pct` SET TAGS ('dbx_business_glossary_term' = 'Current Capacity Utilization Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `current_capacity_utilization_pct` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `customer_pay_capacity_pct` SET TAGS ('dbx_business_glossary_term' = 'Customer Pay Capacity Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `customer_pay_capacity_pct` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `diagnostic_equipment_level` SET TAGS ('dbx_business_glossary_term' = 'Diagnostic Equipment Level');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `diagnostic_equipment_level` SET TAGS ('dbx_value_regex' = 'basic|standard|advanced|premium');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `dms_capacity_record_reference` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Capacity Record ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `dms_capacity_record_reference` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `dms_system_code` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) System Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `dms_system_code` SET TAGS ('dbx_value_regex' = 'CDK|REYNOLDS|DEALERTRACK|ADP|PBS|OTHER');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Capacity Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Capacity Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `ev_certified_tech_count` SET TAGS ('dbx_business_glossary_term' = 'Electric Vehicle (EV) Certified Technician Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `ev_service_bays` SET TAGS ('dbx_business_glossary_term' = 'Electric Vehicle (EV) Service Bays');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `express_service_bays` SET TAGS ('dbx_business_glossary_term' = 'Express Service Bays');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `general_service_bays` SET TAGS ('dbx_business_glossary_term' = 'General Service Bays');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `has_mobile_service_capability` SET TAGS ('dbx_business_glossary_term' = 'Has Mobile Service Capability');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `has_mobile_service_capability` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `has_mobile_service_capability` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `hours_per_shift` SET TAGS ('dbx_business_glossary_term' = 'Hours Per Shift');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `internal_capacity_pct` SET TAGS ('dbx_business_glossary_term' = 'Internal Capacity Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `internal_capacity_pct` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `last_capacity_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Capacity Review Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `last_capacity_review_date` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `loaner_fleet_size` SET TAGS ('dbx_business_glossary_term' = 'Loaner Fleet Size');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `loaner_fleet_utilization_pct` SET TAGS ('dbx_business_glossary_term' = 'Loaner Fleet Utilization Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `max_daily_appointments` SET TAGS ('dbx_business_glossary_term' = 'Maximum Daily Appointments');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `mobile_service_technician_count` SET TAGS ('dbx_business_glossary_term' = 'Mobile Service Technician Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `mobile_service_technician_count` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `mobile_service_technician_count` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `next_capacity_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Capacity Review Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `next_capacity_review_date` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `operating_days_per_week` SET TAGS ('dbx_business_glossary_term' = 'Operating Days Per Week');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `parts_inventory_capacity_sqft` SET TAGS ('dbx_business_glossary_term' = 'Parts Inventory Capacity Square Feet');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `parts_inventory_capacity_sqft` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `shifts_per_day` SET TAGS ('dbx_business_glossary_term' = 'Shifts Per Day');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `specialty_certifications` SET TAGS ('dbx_business_glossary_term' = 'Specialty Certifications');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `target_capacity_utilization_pct` SET TAGS ('dbx_business_glossary_term' = 'Target Capacity Utilization Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `target_capacity_utilization_pct` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `total_service_bays` SET TAGS ('dbx_business_glossary_term' = 'Total Service Bays');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `total_technician_headcount` SET TAGS ('dbx_business_glossary_term' = 'Total Technician Headcount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `warranty_work_capacity_pct` SET TAGS ('dbx_business_glossary_term' = 'Warranty Work Capacity Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`service_capacity` ALTER COLUMN `warranty_work_capacity_pct` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` SET TAGS ('dbx_subdomain' = 'inventory_operations');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `floor_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Floor Plan ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `floor_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `account_number` SET TAGS ('dbx_business_glossary_term' = 'Floor Plan Account Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `account_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `account_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `aged_inventory_flag` SET TAGS ('dbx_business_glossary_term' = 'Aged Inventory Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `aging_threshold_days` SET TAGS ('dbx_business_glossary_term' = 'Aging Threshold Days');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `audit_status` SET TAGS ('dbx_business_glossary_term' = 'Audit Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `audit_status` SET TAGS ('dbx_value_regex' = 'passed|failed|pending|not_required|exception');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `credit_line_amount` SET TAGS ('dbx_business_glossary_term' = 'Credit Line Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `credit_line_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `curtailment_amount` SET TAGS ('dbx_business_glossary_term' = 'Curtailment Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `curtailment_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `curtailment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Curtailment Due Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `curtailment_paid_flag` SET TAGS ('dbx_business_glossary_term' = 'Curtailment Paid Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `daily_interest_amount` SET TAGS ('dbx_business_glossary_term' = 'Daily Interest Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `daily_interest_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `days_in_inventory` SET TAGS ('dbx_business_glossary_term' = 'Days in Inventory');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `dealer_invoice_amount` SET TAGS ('dbx_business_glossary_term' = 'Dealer Invoice Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `dealer_invoice_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `default_date` SET TAGS ('dbx_business_glossary_term' = 'Default Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `default_flag` SET TAGS ('dbx_business_glossary_term' = 'Default Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `dms_floor_plan_reference` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Floor Plan ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `financing_end_date` SET TAGS ('dbx_business_glossary_term' = 'Financing End Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `financing_institution_code` SET TAGS ('dbx_business_glossary_term' = 'Financing Institution Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `financing_institution_name` SET TAGS ('dbx_business_glossary_term' = 'Financing Institution Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `financing_start_date` SET TAGS ('dbx_business_glossary_term' = 'Financing Start Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `floor_plan_status` SET TAGS ('dbx_business_glossary_term' = 'Floor Plan Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `floor_plan_status` SET TAGS ('dbx_value_regex' = 'active|paid_off|defaulted|suspended|pending_audit|curtailed');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `interest_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Interest Rate Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `interest_rate_pct` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Last Audit Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `msrp_amount` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `next_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Next Audit Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `oem_assistance_amount` SET TAGS ('dbx_business_glossary_term' = 'Original Equipment Manufacturer (OEM) Assistance Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `oem_assistance_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `oem_assistance_program_code` SET TAGS ('dbx_business_glossary_term' = 'Original Equipment Manufacturer (OEM) Assistance Program Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `outstanding_balance_amount` SET TAGS ('dbx_business_glossary_term' = 'Outstanding Balance Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `outstanding_balance_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `payoff_amount` SET TAGS ('dbx_business_glossary_term' = 'Payoff Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `payoff_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `payoff_date` SET TAGS ('dbx_business_glossary_term' = 'Payoff Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `per_unit_floor_plan_cost` SET TAGS ('dbx_business_glossary_term' = 'Per-Unit Floor Plan Cost');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `per_unit_floor_plan_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `sap_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Document Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `total_interest_paid` SET TAGS ('dbx_business_glossary_term' = 'Total Interest Paid');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `total_interest_paid` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` SET TAGS ('dbx_subdomain' = 'inventory_operations');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `demo_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Demo Vehicle ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `demo_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Salesperson ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `primary_demo_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Salesperson ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `primary_demo_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `primary_demo_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `accident_count` SET TAGS ('dbx_business_glossary_term' = 'Accident Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `assigned_salesperson_name` SET TAGS ('dbx_business_glossary_term' = 'Assigned Salesperson Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `assigned_salesperson_name` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `assignment_type` SET TAGS ('dbx_business_glossary_term' = 'Demo Assignment Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `assignment_type` SET TAGS ('dbx_value_regex' = 'salesperson|sales_manager|general_manager|showroom_floor|test_drive_pool');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `current_odometer_km` SET TAGS ('dbx_business_glossary_term' = 'Current Odometer Reading in Kilometers');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `demo_designation_date` SET TAGS ('dbx_business_glossary_term' = 'Demo Designation Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `demo_end_date` SET TAGS ('dbx_business_glossary_term' = 'Demo Program End Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `demo_period_months` SET TAGS ('dbx_business_glossary_term' = 'Demo Period Duration in Months');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `demo_start_date` SET TAGS ('dbx_business_glossary_term' = 'Demo Program Start Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `demo_status` SET TAGS ('dbx_business_glossary_term' = 'Demo Vehicle Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `demo_status` SET TAGS ('dbx_value_regex' = 'active|inactive|retired|converted_to_sale|returned_to_stock|auctioned');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `demo_usage_type` SET TAGS ('dbx_business_glossary_term' = 'Demo Usage Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `demo_usage_type` SET TAGS ('dbx_value_regex' = 'test_drive|loaner|executive_use|sales_staff_use|showroom_display');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `disposition_date` SET TAGS ('dbx_business_glossary_term' = 'Disposition Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `disposition_type` SET TAGS ('dbx_business_glossary_term' = 'Disposition Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `disposition_type` SET TAGS ('dbx_value_regex' = 'converted_to_used_sale|returned_to_stock|auctioned|transferred_to_another_dealer|scrapped');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `floor_plan_interest_amount` SET TAGS ('dbx_business_glossary_term' = 'Floor Plan Interest Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `floor_plan_interest_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `incentive_amount` SET TAGS ('dbx_business_glossary_term' = 'OEM Incentive Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_business_glossary_term' = 'Insurance Policy Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `mileage_allowance_km` SET TAGS ('dbx_business_glossary_term' = 'Mileage Allowance in Kilometers');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `mileage_overage_km` SET TAGS ('dbx_business_glossary_term' = 'Mileage Overage in Kilometers');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `odometer_at_designation_km` SET TAGS ('dbx_business_glossary_term' = 'Odometer Reading at Designation in Kilometers');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `oem_program_code` SET TAGS ('dbx_business_glossary_term' = 'OEM Demo Program Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `pdi_completed_flag` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Completed Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `pdi_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Completion Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `recall_campaign_numbers` SET TAGS ('dbx_business_glossary_term' = 'Recall Campaign Numbers');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `sale_price_amount` SET TAGS ('dbx_business_glossary_term' = 'Sale Price Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `service_record_count` SET TAGS ('dbx_business_glossary_term' = 'Service Record Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `stock_number` SET TAGS ('dbx_business_glossary_term' = 'Dealer Stock Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `test_drive_count` SET TAGS ('dbx_business_glossary_term' = 'Test Drive Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `transmission_type` SET TAGS ('dbx_business_glossary_term' = 'Transmission Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `transmission_type` SET TAGS ('dbx_value_regex' = 'manual|automatic|cvt|dct|amt');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_test_drive` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_test_drive` SET TAGS ('dbx_subdomain' = 'sales_performance');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_test_drive` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_test_drive` ALTER COLUMN `dealer_test_drive_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for dealer_test_drive');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_test_drive` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_test_drive` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_test_drive` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Test Drive Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_test_drive` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_test_drive` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_test_drive` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_parts_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_parts_order` SET TAGS ('dbx_subdomain' = 'service_execution');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_parts_order` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_parts_order` ALTER COLUMN `dealer_parts_order_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for dealer_parts_order');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_parts_order` ALTER COLUMN `aftersales_parts_order_id` SET TAGS ('dbx_business_glossary_term' = 'Aftersales Parts Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_parts_order` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_parts_order` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_warranty_claim` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_warranty_claim` SET TAGS ('dbx_subdomain' = 'service_execution');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_warranty_claim` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_warranty_claim` ALTER COLUMN `dealer_warranty_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for dealer_warranty_claim');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_warranty_claim` ALTER COLUMN `aftersales_warranty_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Aftersales Warranty Claim Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_warranty_claim` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Claim Processor Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_warranty_claim` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_warranty_claim` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_warranty_claim` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_warranty_claim` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_warranty_claim` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_warranty_claim` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` SET TAGS ('dbx_subdomain' = 'service_execution');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `recall_completion_id` SET TAGS ('dbx_business_glossary_term' = 'Recall Completion ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `recall_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `recall_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `dealer_order_id` SET TAGS ('dbx_business_glossary_term' = 'Repair Order (RO) ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Technician Employee ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `campaign_type` SET TAGS ('dbx_business_glossary_term' = 'Campaign Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `campaign_type` SET TAGS ('dbx_value_regex' = 'safety_recall|service_campaign|field_service_action|customer_satisfaction_program|emissions_recall|tsb');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `completion_date` SET TAGS ('dbx_business_glossary_term' = 'Completion Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `completion_number` SET TAGS ('dbx_business_glossary_term' = 'Recall Completion Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `completion_status` SET TAGS ('dbx_business_glossary_term' = 'Completion Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `completion_status` SET TAGS ('dbx_value_regex' = 'completed|incomplete|in_progress|parts_pending|customer_declined|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `completion_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Completion Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `customer_notification_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `customer_notification_method` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Method');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `customer_notification_method` SET TAGS ('dbx_value_regex' = 'email|sms|phone|mail|in_person');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `dms_transaction_reference` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Transaction ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `labor_amount` SET TAGS ('dbx_business_glossary_term' = 'Labor Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `labor_hours` SET TAGS ('dbx_business_glossary_term' = 'Labor Hours');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `model` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Model');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `nameplate` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Nameplate');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `nhtsa_report_date` SET TAGS ('dbx_business_glossary_term' = 'National Highway Traffic Safety Administration (NHTSA) Report Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `nhtsa_report_flag` SET TAGS ('dbx_business_glossary_term' = 'National Highway Traffic Safety Administration (NHTSA) Report Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `odometer_reading` SET TAGS ('dbx_business_glossary_term' = 'Odometer Reading');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `odometer_unit` SET TAGS ('dbx_business_glossary_term' = 'Odometer Unit');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `odometer_unit` SET TAGS ('dbx_value_regex' = 'km|mi');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `parts_amount` SET TAGS ('dbx_business_glossary_term' = 'Parts Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `parts_quantity_list` SET TAGS ('dbx_business_glossary_term' = 'Parts Quantity List');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `parts_used_list` SET TAGS ('dbx_business_glossary_term' = 'Parts Used List');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `post_repair_inspection_notes` SET TAGS ('dbx_business_glossary_term' = 'Post-Repair Inspection Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ice|hev|phev|bev|fcev');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `pre_repair_inspection_notes` SET TAGS ('dbx_business_glossary_term' = 'Pre-Repair Inspection Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `quality_verification_date` SET TAGS ('dbx_business_glossary_term' = 'Quality Verification Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `quality_verification_flag` SET TAGS ('dbx_business_glossary_term' = 'Quality Verification Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `quality_verifier_name` SET TAGS ('dbx_business_glossary_term' = 'Quality Verifier Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `recall_campaign_number` SET TAGS ('dbx_business_glossary_term' = 'Recall Campaign Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `reimbursement_claim_number` SET TAGS ('dbx_business_glossary_term' = 'Reimbursement Claim Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `reimbursement_paid_date` SET TAGS ('dbx_business_glossary_term' = 'Reimbursement Paid Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `reimbursement_status` SET TAGS ('dbx_business_glossary_term' = 'Reimbursement Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `reimbursement_status` SET TAGS ('dbx_value_regex' = 'pending|approved|paid|rejected|under_review');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `remedy_description` SET TAGS ('dbx_business_glossary_term' = 'Remedy Description');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `sublet_amount` SET TAGS ('dbx_business_glossary_term' = 'Sublet Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `technician_certification_number` SET TAGS ('dbx_business_glossary_term' = 'Technician Certification Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `technician_name` SET TAGS ('dbx_business_glossary_term' = 'Technician Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `total_reimbursement_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Reimbursement Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` SET TAGS ('dbx_subdomain' = 'network_management');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `dms_integration_log_id` SET TAGS ('dbx_business_glossary_term' = 'DMS (Dealer Management System) Integration Log ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `dms_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `authentication_method` SET TAGS ('dbx_business_glossary_term' = 'Authentication Method');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `authentication_method` SET TAGS ('dbx_value_regex' = 'oauth2|api_key|certificate|basic_auth');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `business_impact_severity` SET TAGS ('dbx_business_glossary_term' = 'Business Impact Severity');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `business_impact_severity` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|none');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `compression_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'Compression Enabled Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `data_freshness_lag_minutes` SET TAGS ('dbx_business_glossary_term' = 'Data Freshness Lag in Minutes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `dealer_code` SET TAGS ('dbx_business_glossary_term' = 'Dealer Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `dealer_name` SET TAGS ('dbx_business_glossary_term' = 'Dealer Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `dms_endpoint_url` SET TAGS ('dbx_business_glossary_term' = 'DMS (Dealer Management System) Endpoint URL');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `dms_endpoint_url` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `dms_transaction_reference` SET TAGS ('dbx_business_glossary_term' = 'DMS (Dealer Management System) Transaction ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `dms_version` SET TAGS ('dbx_business_glossary_term' = 'DMS (Dealer Management System) Version');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `encryption_protocol` SET TAGS ('dbx_business_glossary_term' = 'Encryption Protocol');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `encryption_protocol` SET TAGS ('dbx_value_regex' = 'TLS_1_2|TLS_1_3|SSL_3_0');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `error_category` SET TAGS ('dbx_business_glossary_term' = 'Error Category');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `error_category` SET TAGS ('dbx_value_regex' = 'connectivity|validation|timeout|authentication|data_format|business_rule');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `error_message` SET TAGS ('dbx_business_glossary_term' = 'Error Message');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `escalation_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Escalation Required Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `escalation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Escalation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `integration_batch_reference` SET TAGS ('dbx_business_glossary_term' = 'Integration Batch ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `max_retry_attempts` SET TAGS ('dbx_business_glossary_term' = 'Maximum Retry Attempts');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `next_retry_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Next Retry Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `oem_transaction_reference` SET TAGS ('dbx_business_glossary_term' = 'OEM (Original Equipment Manufacturer) Transaction ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `payload_size_kb` SET TAGS ('dbx_business_glossary_term' = 'Payload Size in Kilobytes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `record_count_failed` SET TAGS ('dbx_business_glossary_term' = 'Record Count Failed');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `record_count_received` SET TAGS ('dbx_business_glossary_term' = 'Record Count Received');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `record_count_sent` SET TAGS ('dbx_business_glossary_term' = 'Record Count Sent');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `resolution_notes` SET TAGS ('dbx_business_glossary_term' = 'Resolution Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `resolution_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Resolution Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `retry_attempt_number` SET TAGS ('dbx_business_glossary_term' = 'Retry Attempt Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `sla_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'SLA (Service Level Agreement) Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `sla_target_duration_seconds` SET TAGS ('dbx_business_glossary_term' = 'SLA (Service Level Agreement) Target Duration in Seconds');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `sync_duration_seconds` SET TAGS ('dbx_business_glossary_term' = 'Synchronization Duration in Seconds');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `sync_event_type` SET TAGS ('dbx_business_glossary_term' = 'Synchronization Event Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `sync_event_type` SET TAGS ('dbx_value_regex' = 'inventory_push|ro_pull|sales_pull|parts_pull|customer_pull|warranty_push');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `sync_status` SET TAGS ('dbx_business_glossary_term' = 'Synchronization Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `sync_status` SET TAGS ('dbx_value_regex' = 'success|partial|failed|pending|timeout');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dms_integration_log` ALTER COLUMN `sync_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Synchronization Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` SET TAGS ('dbx_subdomain' = 'network_management');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `facility_standard_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Standard ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assessor Employee ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `facility_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `franchise_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `allocation_eligibility_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Allocation Eligibility Impact Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Assessment Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `assessment_method` SET TAGS ('dbx_business_glossary_term' = 'Assessment Method');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `assessment_method` SET TAGS ('dbx_value_regex' = 'on_site|remote|hybrid|photographic_evidence|self_assessment');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `assessment_number` SET TAGS ('dbx_business_glossary_term' = 'Assessment Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `assessment_report_url` SET TAGS ('dbx_business_glossary_term' = 'Assessment Report URL');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `assessment_type` SET TAGS ('dbx_business_glossary_term' = 'Assessment Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `assessment_type` SET TAGS ('dbx_value_regex' = 'initial|annual|renewal|spot_check|post_remediation|franchise_application');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `assessor_certification_number` SET TAGS ('dbx_business_glossary_term' = 'Assessor Certification Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `assessor_name` SET TAGS ('dbx_business_glossary_term' = 'Assessor Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `compliance_score` SET TAGS ('dbx_business_glossary_term' = 'Compliance Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|conditional|pending_review|remediation_required|waived');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `critical_deficiency_count` SET TAGS ('dbx_business_glossary_term' = 'Critical Deficiency Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `dealer_response_notes` SET TAGS ('dbx_business_glossary_term' = 'Dealer Response Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `deficiency_count` SET TAGS ('dbx_business_glossary_term' = 'Deficiency Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `deficiency_description` SET TAGS ('dbx_business_glossary_term' = 'Deficiency Description');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `dms_integration_status` SET TAGS ('dbx_business_glossary_term' = 'DMS (Dealer Management System) Integration Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `dms_integration_status` SET TAGS ('dbx_value_regex' = 'synced|pending|failed|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `dms_last_sync_timestamp` SET TAGS ('dbx_business_glossary_term' = 'DMS (Dealer Management System) Last Sync Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `estimated_investment_amount` SET TAGS ('dbx_business_glossary_term' = 'Estimated Investment Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `estimated_investment_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `franchise_renewal_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Franchise Renewal Impact Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `incentive_eligibility_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Incentive Eligibility Impact Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `major_deficiency_count` SET TAGS ('dbx_business_glossary_term' = 'Major Deficiency Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `minor_deficiency_count` SET TAGS ('dbx_business_glossary_term' = 'Minor Deficiency Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `next_assessment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Assessment Due Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `oem_reviewer_notes` SET TAGS ('dbx_business_glossary_term' = 'OEM (Original Equipment Manufacturer) Reviewer Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `passing_threshold_score` SET TAGS ('dbx_business_glossary_term' = 'Passing Threshold Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `photographic_evidence_url` SET TAGS ('dbx_business_glossary_term' = 'Photographic Evidence URL');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `remediation_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Remediation Completion Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `remediation_deadline` SET TAGS ('dbx_business_glossary_term' = 'Remediation Deadline');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `remediation_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Remediation Required Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `remediation_status` SET TAGS ('dbx_business_glossary_term' = 'Remediation Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `remediation_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|verified|overdue|extension_granted');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `remediation_verification_date` SET TAGS ('dbx_business_glossary_term' = 'Remediation Verification Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `standard_category` SET TAGS ('dbx_business_glossary_term' = 'Standard Category');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `standard_category` SET TAGS ('dbx_value_regex' = 'brand_identity|infrastructure|customer_experience|operational|technology');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `standard_type` SET TAGS ('dbx_business_glossary_term' = 'Facility Standard Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `waiver_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Waiver Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `waiver_granted_flag` SET TAGS ('dbx_business_glossary_term' = 'Waiver Granted Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ALTER COLUMN `waiver_reason` SET TAGS ('dbx_business_glossary_term' = 'Waiver Reason');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` SET TAGS ('dbx_subdomain' = 'inventory_operations');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `used_vehicle_appraisal_id` SET TAGS ('dbx_business_glossary_term' = 'Used Vehicle Appraisal ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Appraiser Employee ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `used_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `used_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `accident_history_flag` SET TAGS ('dbx_business_glossary_term' = 'Accident History Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `appraisal_date` SET TAGS ('dbx_business_glossary_term' = 'Appraisal Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `appraisal_number` SET TAGS ('dbx_business_glossary_term' = 'Appraisal Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `appraisal_source_channel` SET TAGS ('dbx_business_glossary_term' = 'Appraisal Source Channel');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `appraisal_source_channel` SET TAGS ('dbx_value_regex' = 'walk_in|appointment|online_submission|phone_inquiry|service_drive');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `appraisal_status` SET TAGS ('dbx_business_glossary_term' = 'Appraisal Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `appraisal_status` SET TAGS ('dbx_value_regex' = 'pending|completed|accepted|declined|expired');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `appraisal_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Appraisal Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `appraisal_tool_used` SET TAGS ('dbx_business_glossary_term' = 'Appraisal Tool Used');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `appraisal_tool_used` SET TAGS ('dbx_value_regex' = 'manheim_mmr|black_book|kbb|nada|galves|internal');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `appraised_value_amount` SET TAGS ('dbx_business_glossary_term' = 'Appraised Value Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `appraiser_name` SET TAGS ('dbx_business_glossary_term' = 'Appraiser Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `customer_requested_amount` SET TAGS ('dbx_business_glossary_term' = 'Customer Requested Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `disposition_decision` SET TAGS ('dbx_business_glossary_term' = 'Disposition Decision');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `disposition_decision` SET TAGS ('dbx_value_regex' = 'accepted_trade|declined_trade|wholesale|retail_inventory|pending');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `equity_amount` SET TAGS ('dbx_business_glossary_term' = 'Equity Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `equity_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `equity_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `exterior_condition_notes` SET TAGS ('dbx_business_glossary_term' = 'Exterior Condition Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `interior_condition_notes` SET TAGS ('dbx_business_glossary_term' = 'Interior Condition Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `linked_deal_number` SET TAGS ('dbx_business_glossary_term' = 'Linked Deal Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `market_value_amount` SET TAGS ('dbx_business_glossary_term' = 'Market Value Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `mechanical_condition_notes` SET TAGS ('dbx_business_glossary_term' = 'Mechanical Condition Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `odometer_unit` SET TAGS ('dbx_business_glossary_term' = 'Odometer Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `odometer_unit` SET TAGS ('dbx_value_regex' = 'miles|kilometers');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `offer_expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Offer Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `payoff_amount` SET TAGS ('dbx_business_glossary_term' = 'Loan Payoff Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `payoff_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `payoff_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `reconditioning_cost_estimate` SET TAGS ('dbx_business_glossary_term' = 'Reconditioning Cost Estimate');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `retail_estimate_amount` SET TAGS ('dbx_business_glossary_term' = 'Retail Estimate Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `service_records_available_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Records Available Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `tire_condition` SET TAGS ('dbx_business_glossary_term' = 'Tire Condition');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `tire_condition` SET TAGS ('dbx_value_regex' = 'excellent|good|fair|poor|replacement_needed');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `title_status` SET TAGS ('dbx_business_glossary_term' = 'Title Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `title_status` SET TAGS ('dbx_value_regex' = 'clean|salvage|rebuilt|lemon|flood|hail');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `trade_in_allowance_amount` SET TAGS ('dbx_business_glossary_term' = 'Trade-In Allowance Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ALTER COLUMN `wholesale_estimate_amount` SET TAGS ('dbx_business_glossary_term' = 'Wholesale Estimate Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership_quality_assessment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership_quality_assessment` SET TAGS ('dbx_subdomain' = 'service_execution');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership_quality_assessment` SET TAGS ('dbx_association_edges' = 'dealer.dealership,quality.quality_standard');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership_quality_assessment` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership_quality_assessment` ALTER COLUMN `dealership_quality_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Dealershipqualityassessment - Assessment Id');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership_quality_assessment` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealershipqualityassessment - Dealership Id');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership_quality_assessment` ALTER COLUMN `standard_id` SET TAGS ('dbx_business_glossary_term' = 'Dealershipqualityassessment - Quality Standard Id');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership_quality_assessment` ALTER COLUMN `assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Assessment Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership_quality_assessment` ALTER COLUMN `assessment_type` SET TAGS ('dbx_business_glossary_term' = 'Assessment Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership_quality_assessment` ALTER COLUMN `compliance_score` SET TAGS ('dbx_business_glossary_term' = 'Compliance Score');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership_quality_assessment` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership_quality_assessment` ALTER COLUMN `deficiency_count` SET TAGS ('dbx_business_glossary_term' = 'Deficiency Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` SET TAGS ('dbx_subdomain' = 'inventory_operations');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `dealer_order_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Order ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `dealer_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `production_order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `actual_ship_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Ship Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `allocation_pool_code` SET TAGS ('dbx_business_glossary_term' = 'Allocation Pool Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `body_style` SET TAGS ('dbx_business_glossary_term' = 'Body Style');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `cancellation_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `confirmed_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `days_late` SET TAGS ('dbx_business_glossary_term' = 'Days Late');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `dealer_invoice_amount` SET TAGS ('dbx_business_glossary_term' = 'Dealer Invoice Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `dealer_invoice_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `dms_order_number` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Order Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `estimated_ship_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated Ship Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `exterior_color_code` SET TAGS ('dbx_business_glossary_term' = 'Exterior Color Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `hold_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Hold Reason Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `homologation_variant` SET TAGS ('dbx_business_glossary_term' = 'Homologation Variant');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `incentive_amount` SET TAGS ('dbx_business_glossary_term' = 'Incentive Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `incentive_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `interior_color_code` SET TAGS ('dbx_business_glossary_term' = 'Interior Color Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `market_code` SET TAGS ('dbx_business_glossary_term' = 'Market Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `market_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `msrp_amount` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Amount');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `msrp_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Order Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `order_date` SET TAGS ('dbx_business_glossary_term' = 'Order Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `order_source` SET TAGS ('dbx_business_glossary_term' = 'Order Source');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `order_source` SET TAGS ('dbx_value_regex' = 'dealer_portal|dms|edi|manual|api');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `order_status` SET TAGS ('dbx_business_glossary_term' = 'Order Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `order_type` SET TAGS ('dbx_business_glossary_term' = 'Order Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `order_type` SET TAGS ('dbx_value_regex' = 'stock|retail|demo|fleet|courtesy');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `otd_flag` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery (OTD) Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `pdi_completed_date` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Completed Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `pdi_required` SET TAGS ('dbx_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Required Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `priority_code` SET TAGS ('dbx_business_glossary_term' = 'Order Priority Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `priority_code` SET TAGS ('dbx_value_regex' = 'standard|priority|urgent|allocation');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `production_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `production_week` SET TAGS ('dbx_business_glossary_term' = 'Production Week');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `production_week` SET TAGS ('dbx_value_regex' = '^d{4}-W(0[1-9]|[1-4]d|5[0-3])$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `sales_region_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Region Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `sap_sales_order_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Sales Order Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `shipping_method` SET TAGS ('dbx_business_glossary_term' = 'Shipping Method');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `shipping_method` SET TAGS ('dbx_value_regex' = 'rail|truck|vessel|mixed');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `transmission_type` SET TAGS ('dbx_business_glossary_term' = 'Transmission Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `transmission_type` SET TAGS ('dbx_value_regex' = 'automatic|manual|CVT|DCT');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` SET TAGS ('dbx_subdomain' = 'network_management');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `dealer_contact_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Contact Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `active_flag` SET TAGS ('dbx_business_glossary_term' = 'Active Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `certification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `certification_status` SET TAGS ('dbx_business_glossary_term' = 'Contact Certification Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `certification_status` SET TAGS ('dbx_value_regex' = 'certified|in_progress|expired|not_required|not_certified');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `communication_preference` SET TAGS ('dbx_business_glossary_term' = 'Communication Preference');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `communication_preference` SET TAGS ('dbx_value_regex' = 'email|phone|mobile|fax|portal');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `contact_role` SET TAGS ('dbx_business_glossary_term' = 'Contact Role');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `contact_role` SET TAGS ('dbx_value_regex' = 'dealer_principal|general_manager|sales_manager|service_manager|parts_manager|fi_manager');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `data_source_system` SET TAGS ('dbx_business_glossary_term' = 'Data Source System');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `dealer_portal_access_flag` SET TAGS ('dbx_business_glossary_term' = 'Dealer Portal Access Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `department` SET TAGS ('dbx_business_glossary_term' = 'Contact Department');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `department` SET TAGS ('dbx_value_regex' = 'sales|service|parts|finance_insurance|administration|management');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `email_address` SET TAGS ('dbx_business_glossary_term' = 'Contact Email Address');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `email_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Phone Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `fax_number` SET TAGS ('dbx_business_glossary_term' = 'Contact Fax Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `fax_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `fax_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `first_name` SET TAGS ('dbx_business_glossary_term' = 'Contact First Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `first_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `first_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `hire_date` SET TAGS ('dbx_business_glossary_term' = 'Contact Hire Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `job_title` SET TAGS ('dbx_business_glossary_term' = 'Contact Job Title');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `language_preference` SET TAGS ('dbx_business_glossary_term' = 'Language Preference');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `last_name` SET TAGS ('dbx_business_glossary_term' = 'Contact Last Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `last_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `last_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `last_training_date` SET TAGS ('dbx_business_glossary_term' = 'Last Training Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `middle_name` SET TAGS ('dbx_business_glossary_term' = 'Contact Middle Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `middle_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `middle_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `mobile_number` SET TAGS ('dbx_business_glossary_term' = 'Contact Mobile Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `mobile_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `mobile_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Contact Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Contact Phone Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `portal_last_login_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Portal Last Login Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `portal_user_code` SET TAGS ('dbx_business_glossary_term' = 'Portal User Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `portal_user_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `portal_user_code` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `primary_contact_flag` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `tenure_years` SET TAGS ('dbx_business_glossary_term' = 'Contact Tenure in Years');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Contact Termination Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Contact Termination Reason');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `termination_reason` SET TAGS ('dbx_value_regex' = 'resignation|retirement|termination|transfer|other');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_contact` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` SET TAGS ('dbx_subdomain' = 'network_management');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `dealer_region_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Region ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `allocation_quota_percentage` SET TAGS ('dbx_business_glossary_term' = 'Allocation Quota Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `city_list` SET TAGS ('dbx_business_glossary_term' = 'City List');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `city_list` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `competitive_intensity_rating` SET TAGS ('dbx_business_glossary_term' = 'Competitive Intensity Rating');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `competitive_intensity_rating` SET TAGS ('dbx_value_regex' = 'low|moderate|high|very_high');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `county_region_list` SET TAGS ('dbx_business_glossary_term' = 'County or Region List');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `dealer_count` SET TAGS ('dbx_business_glossary_term' = 'Dealer Count');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `district_code` SET TAGS ('dbx_business_glossary_term' = 'District Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `district_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `district_name` SET TAGS ('dbx_business_glossary_term' = 'District Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `dms_integration_status` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Integration Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `dms_integration_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|error');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `dms_last_sync_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Last Sync Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `geographic_boundary_description` SET TAGS ('dbx_business_glossary_term' = 'Geographic Boundary Description');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `household_count_estimate` SET TAGS ('dbx_business_glossary_term' = 'Household Count Estimate');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `incentive_program_eligibility_flag` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Eligibility Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `market_segment_classification` SET TAGS ('dbx_business_glossary_term' = 'Market Segment Classification');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `market_segment_classification` SET TAGS ('dbx_value_regex' = 'urban|suburban|rural|mixed');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `modification_reason` SET TAGS ('dbx_business_glossary_term' = 'Modification Reason');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `performance_benchmark_group` SET TAGS ('dbx_business_glossary_term' = 'Performance Benchmark Group');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `population_estimate` SET TAGS ('dbx_business_glossary_term' = 'Population Estimate');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `postal_code_range` SET TAGS ('dbx_business_glossary_term' = 'Postal Code Range');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `postal_code_range` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `postal_code_range` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `region_name` SET TAGS ('dbx_business_glossary_term' = 'Region Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `region_status` SET TAGS ('dbx_business_glossary_term' = 'Region Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `region_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|consolidating|dissolved');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `region_type` SET TAGS ('dbx_business_glossary_term' = 'Region Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `region_type` SET TAGS ('dbx_value_regex' = 'geographic|market|strategic|operational');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `regional_manager_email` SET TAGS ('dbx_business_glossary_term' = 'Regional Manager Email Address');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `regional_manager_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `regional_manager_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `regional_manager_email` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `regional_manager_name` SET TAGS ('dbx_business_glossary_term' = 'Regional Manager Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `regional_manager_name` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `regional_manager_phone` SET TAGS ('dbx_business_glossary_term' = 'Regional Manager Phone Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `regional_manager_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `regional_manager_phone` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `sales_potential_index` SET TAGS ('dbx_business_glossary_term' = 'Sales Potential Index');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `salesforce_region_code` SET TAGS ('dbx_business_glossary_term' = 'Salesforce Region ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `sap_sales_org_code` SET TAGS ('dbx_business_glossary_term' = 'SAP Sales Organization Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `sap_sales_org_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `special_program_notes` SET TAGS ('dbx_business_glossary_term' = 'Special Program Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `state_province_list` SET TAGS ('dbx_business_glossary_term' = 'State or Province List');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `state_province_list` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `vehicle_allocation_priority` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Allocation Priority');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `zone_code` SET TAGS ('dbx_business_glossary_term' = 'Zone Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `zone_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ALTER COLUMN `zone_name` SET TAGS ('dbx_business_glossary_term' = 'Zone Name');
