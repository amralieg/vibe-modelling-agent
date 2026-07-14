-- Schema for Domain: dealer | Business: Automotive | Version: v2_mvm
-- Generated on: 2026-07-14 04:30:40

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`dealer` COMMENT 'Dealer network management including dealer profiles, franchise agreements, territory assignments, and dealer performance scorecards. Manages dealer inventory allocation, vehicle allocation rules, dealer incentive programs, and DMS (Dealer Management System) integration. Tracks dealer sales performance, customer satisfaction scores, service capacity, and parts inventory at dealer locations. Supports both OEM-owned and independent franchise dealer models. Integrates with CDK Global DMS.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealership` (
    `dealership_id` BIGINT COMMENT 'Unique surrogate identifier for each dealer location in the OEM franchise network. Primary key for the dealership master record and the enterprise Single Source of Truth (SSOT) for dealer identity.',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`territory` (
    `territory_id` BIGINT COMMENT 'Unique identifier for the dealer territory assignment. Primary key.',
    `franchise_agreement_id` BIGINT COMMENT 'Reference to the franchise agreement that governs this territory assignment. Links territory rights to contractual terms.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership that owns or is assigned this territory.',
    `allocation_quota_percentage` DECIMAL(18,2) COMMENT 'Percentage of regional or national vehicle allocation assigned to this territory. Sum of all territory percentages within a region should equal 100.',
    `approval_date` DATE COMMENT 'Date when the territory assignment or modification was formally approved by OEM (Original Equipment Manufacturer) management.',
    `approved_by` STRING COMMENT 'Name or identifier of the OEM (Original Equipment Manufacturer) executive or manager who approved this territory assignment or modification.',
    `city_list` STRING COMMENT 'Comma-separated list of cities or municipalities included in the territory coverage area.',
    `territory_code` STRING COMMENT 'Unique alphanumeric code identifying the territory within the dealer network. Used for vehicle allocation and market planning.. Valid values are `^[A-Z0-9]{3,12}$`',
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
    `territory_name` STRING COMMENT 'Business-friendly name or description of the territory (e.g., Metro East Region, Downtown District).',
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
    `territory_status` STRING COMMENT 'Current lifecycle status of the territory assignment. Active territories are operational; pending awaits approval; suspended is temporarily halted; terminated is closed.. Valid values are `active|inactive|pending|suspended|under_review|terminated`',
    `territory_type` STRING COMMENT 'Classification of territory assignment model: exclusive (single dealer), shared (multiple dealers), open (no restrictions), primary (main responsibility), secondary (backup coverage), overlay (special program).. Valid values are `exclusive|shared|open|primary|secondary|overlay`',
    `vehicle_allocation_priority` STRING COMMENT 'Priority ranking for vehicle inventory allocation to this territory. Lower numbers indicate higher priority. Used during supply constraints.',
    CONSTRAINT pk_territory PRIMARY KEY(`territory_id`)
) COMMENT 'Geographic sales territory assigned to a dealership. Defines primary area of responsibility (PAR), zip/postal code coverage, county or region boundaries, territory type (exclusive, shared, open), effective dates, and overlap rules. Used for vehicle allocation, market representation planning, and dealer performance benchmarking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` (
    `vehicle_allocation_id` BIGINT COMMENT 'Unique surrogate identifier for each vehicle allocation record linking a specific vehicle unit or allocation batch from OEM manufacturing output to a dealership inventory pipeline.',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.configuration. Business justification: Allocation planning and OEM-to-dealer order matching require linking each allocation record to the specific vehicle configuration ordered. Used in allocation mix reporting, ZEV mandate compliance trac',
    `fleet_contract_id` BIGINT COMMENT 'Foreign key linking to sales.fleet_contract. Business justification: Fleet contract allocations pre-assign vehicles against a fleet_contract. Fleet volume fulfillment tracking, OEM fleet program reporting, and allocation priority management require linking vehicle_allo',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership receiving this vehicle allocation. Links to the dealer master record in the dealer network.',
    `territory_id` BIGINT COMMENT 'Foreign key linking to dealer.dealer_territory. Business justification: Vehicle allocations are assigned to specific dealer territories as part of OEM allocation rules. vehicle_allocation has a territory_code string field that is a denormalized reference to dealer_territo',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Order-to-allocation matching is a core production and logistics process. Allocation fulfillment status, committed delivery date management, and OEM order bank reporting require directly linking vehicl',
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
    `transport_mode` STRING COMMENT 'Primary mode of transportation used to deliver the allocated vehicle(s) from the production plant or port of entry to the dealership. Drives logistics cost allocation and delivery lead time estimation.. Valid values are `rail|truck|ship|compound`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this allocation record. Supports change tracking, audit compliance, and incremental data pipeline processing.',
    `vin` STRING COMMENT '17-character Vehicle Identification Number (VIN) assigned to a specific vehicle unit within this allocation. Populated for unit-level allocations; null for batch-level allocations where VINs are not yet assigned.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_vehicle_allocation PRIMARY KEY(`vehicle_allocation_id`)
) COMMENT 'Records the OEMs allocation of specific vehicle units (by VIN or allocation batch) to a dealership for a given model year and production period. Captures allocation quantity, nameplate, trim, powertrain type (ICE/HEV/PHEV/EV), allocation rule applied, priority tier, acceptance status, and delivery window. Core operational record linking manufacturing output to dealer inventory pipeline.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` (
    `dealer_inventory_id` BIGINT COMMENT 'Unique surrogate identifier for each dealer inventory record in the Silver Layer lakehouse. Primary key for this data product.',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.configuration. Business justification: DMS window sticker generation, customer-facing spec display, and build feasibility checks require linking each inventory unit to its OEM configuration. This is a standard DMS integration process; deal',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Inventory management must ensure each stocked vehicle model is homologated for the market; linking inventory to homologation records supports compliance checks.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Inventory manager ownership is tracked for inventory reconciliation and loss prevention reporting.',
    `powertrain_variant_id` BIGINT COMMENT 'Foreign key linking to vehicle.powertrain_variant. Business justification: EV dealer readiness reporting, ZEV mandate compliance tracking, and electrification mix analysis at dealer level require linking inventory units to their powertrain variant. dealer_inventory.engine_de',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership that physically holds or is allocated this inventory unit. Sourced from CDK Global DMS dealer master.',
    `stock_transfer_order_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_transfer_order. Business justification: Vehicle logistics receiving process: when a vehicle arrives at a dealer lot via an OEM stock transfer, the dealer_inventory record must reference the originating stock_transfer_order for receiving rec',
    `vehicle_allocation_id` BIGINT COMMENT 'Foreign key linking to dealer.vehicle_allocation. Business justification: A dealer inventory record is created when an allocated vehicle arrives at the dealership. Linking dealer_inventory to vehicle_allocation via vehicle_allocation_id normalizes the supply-chain provenanc',
    `vehicle_build_id` BIGINT COMMENT 'Foreign key linking to manufacturing.vehicle_build. Business justification: Needed for Vehicle Traceability report, connecting each inventory record to its exact build record for warranty and recall actions.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Inventory allocation report needs to know which OEM vehicle order supplied each stocked vehicle.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Dealer inventory management report requires each inventory record to be linked to the VIN registry for warranty, recall, and compliance tracking.',
    `acquisition_cost` DECIMAL(18,2) COMMENT 'The dealers total landed cost for this vehicle unit, including invoice price, transportation/destination charges, PDI costs, and any dealer-installed accessories. Used for gross profit calculation and inventory valuation.',
    `asking_price` DECIMAL(18,2) COMMENT 'The dealers current advertised or asking retail price for this vehicle unit. May differ from MSRP due to market adjustments, dealer markups, or promotional discounts. Updated dynamically based on market conditions and days-on-lot.',
    `body_style` STRING COMMENT 'The vehicle body style classification (e.g., sedan, SUV, pickup truck, van). Used for inventory segmentation, lot management, and sales reporting. [ENUM-REF-CANDIDATE: sedan|coupe|SUV|crossover|pickup_truck|van|minivan|wagon|convertible|hatchback — promote to reference product]',
    `certified_pre_owned` BOOLEAN COMMENT 'Indicates whether this used vehicle unit has been certified under the OEMs Certified Pre-Owned (CPO) program, meeting specific age, mileage, inspection, and reconditioning standards. True = CPO certified; False = not CPO certified. CPO vehicles carry extended warranty coverage and premium pricing.',
    `days_on_lot` STRING COMMENT 'The number of calendar days this vehicle unit has been physically present on the dealers lot since the received date. A key inventory aging metric used to trigger price adjustments, incentive programs, and wholesale decisions. Aged inventory (typically >60 days) incurs floor plan interest costs.',
    `dms_record_reference` STRING COMMENT 'The source system record identifier from CDK Global DMS for this inventory unit. Used for data lineage, reconciliation, and incremental load processing between the DMS source and the Silver Layer lakehouse.',
    `drivetrain` STRING COMMENT 'Drivetrain configuration of the vehicle: FWD (Front-Wheel Drive), RWD (Rear-Wheel Drive), AWD (All-Wheel Drive), or 4WD (Four-Wheel Drive). Key inventory search and customer preference attribute.. Valid values are `FWD|RWD|AWD|4WD`',
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
    `service_part_id` BIGINT COMMENT 'Foreign key linking to aftersales.service_part. Business justification: Dealer parts inventory must reference the aftersales service_part catalog for parts pricing, warranty eligibility validation, and repair order fulfillment. A DMS domain expert expects dealer stock rec',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: Parts pricing, valuation and regulatory compliance reports require linking dealer parts stock to the master SKU definition.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Parts inventory must reference the master parts catalog for pricing, compliance, and warranty reporting; this is required for the Parts Pricing & Compliance Report.',
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
    `fleet_contract_id` BIGINT COMMENT 'Foreign key linking to sales.fleet_contract. Business justification: Fleet retail sales execute under a fleet_contract. Fleet volume utilization tracking, OEM fleet incentive reconciliation, and contract fulfillment reporting require linking each fleet retail_sale to i',
    `dealer_inventory_id` BIGINT COMMENT 'Foreign key linking to dealer.dealer_inventory. Business justification: A retail sale disposes of a specific dealer inventory unit. Linking retail_sale to dealer_inventory via dealer_inventory_id establishes the direct relationship between the sale transaction and the phy',
    `loyalty_membership_id` BIGINT COMMENT 'Foreign key linking to customer.loyalty_membership. Business justification: OEM loyalty programs require retail_sale to be associated with a loyalty_membership_id for points posting, tier qualification, and audit reporting at point of sale. This is a named business process in',
    `msrp_pricing_id` BIGINT COMMENT 'Foreign key linking to vehicle.msrp_pricing. Business justification: OEM incentive program reconciliation and dealer margin audits require matching each retail transaction to the official MSRP pricing record. retail_sale.msrp_amount is a denormalized copy; a FK to msrp',
    `opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Retail sale conversion analysis links the final sale back to the originating sales opportunity for win‑loss tracking.',
    `organization_account_id` BIGINT COMMENT 'Foreign key linking to customer.customer_fleet_account. Business justification: Fleet sales (retail_sale.fleet_sale=true) must reference the customer_fleet_account for fleet billing, volume discount program tracking, and OEM fleet incentive reconciliation. This is a named B2B sal',
    `plant_id` BIGINT COMMENT 'Reference to the dealership salesperson (finance and insurance associate or sales consultant) who managed and closed the retail deal.',
    `party_id` BIGINT COMMENT 'Reference to the retail customer (buyer) who purchased the vehicle. Links to the customer master record.',
    `dealership_id` BIGINT COMMENT 'Reference to the dealership that executed the retail sale transaction. Links to the dealer master record in the dealer domain.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Retail sale transaction must reference the SKU for warranty registration, service history, and post‑sale reporting.',
    `trade_in_id` BIGINT COMMENT 'Foreign key linking to sales.trade_in. Business justification: A retail deal includes a trade-in. Net deal calculation, trade-in allowance reconciliation, and title processing require linking retail_sale to the trade_in record. retail_sale.trade_in_vin is a denor',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: A retail sale finalizes a vehicle_order. Revenue recognition, order-to-delivery reconciliation, and OEM retail reporting all require tracing the DMS deal back to the originating vehicle_order. No exis',
    `vehicle_warranty_id` BIGINT COMMENT 'Foreign key linking to aftersales.vehicle_warranty. Business justification: At point of sale, the retail_sale activates a vehicle warranty record. Linking retail_sale to vehicle_warranty enables warranty start date validation, CPO warranty assignment, F&I product warranty reg',
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
    `oem_incentive_amount` DECIMAL(18,2) COMMENT 'Total value of OEM-funded customer incentives applied to the deal, including cash-back rebates, conquest bonuses, loyalty bonuses, and special program pricing. Sourced from OEM incentive program data and reconciled against dealer statements.',
    `oem_program_code` STRING COMMENT 'OEM-assigned program code identifying the specific incentive or sales program under which the vehicle was sold (e.g., employee pricing, conquest, loyalty, fleet, rental). Used for OEM incentive claim submission and program performance reporting.',
    `pdi_completed` BOOLEAN COMMENT 'Indicates whether the Pre-Delivery Inspection (PDI) was completed and signed off by the dealer technician prior to vehicle delivery to the customer. PDI completion is required for warranty activation and OEM delivery standards compliance.',
    `sale_date` DATE COMMENT 'The calendar date on which the retail vehicle sale was consummated — i.e., the date the buyer signed the retail installment contract or cash purchase agreement. This is the principal business event date used for sales reporting, OEM incentive eligibility, and regulatory compliance.',
    `sale_price` DECIMAL(18,2) COMMENT 'The agreed-upon selling price of the vehicle as negotiated between the dealer and the customer, before trade-in allowance, taxes, and fees. This is the gross capitalized cost for lease deals or the selling price for retail finance and cash deals.',
    `sales_tax_amount` DECIMAL(18,2) COMMENT 'State and local sales tax assessed on the vehicle sale transaction. Calculated based on the taxable selling price and the applicable jurisdiction tax rate. Used for tax remittance reporting and deal cost reconciliation.',
    `stock_number` STRING COMMENT 'Dealer-assigned inventory stock number for the vehicle unit at the time of sale. Used for dealer inventory management and reconciliation with CDK Global DMS inventory records.',
    `trade_in_allowance` DECIMAL(18,2) COMMENT 'The agreed trade-in value credited to the customer for a vehicle traded in as part of the deal. Reduces the amount financed or cash due. Null if no trade-in vehicle was involved in the transaction.',
    `trade_in_payoff_amount` DECIMAL(18,2) COMMENT 'The outstanding loan or lease payoff balance on the customers trade-in vehicle at the time of the deal. If payoff exceeds trade-in allowance, the difference (negative equity) is typically rolled into the new deal.',
    `updated_timestamp` TIMESTAMP COMMENT 'The timestamp when the retail sale record was last modified in the data platform, reflecting deal amendments, status changes, or corrections sourced from CDK Global DMS. Conforms to ISO 8601 format yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `vehicle_condition` STRING COMMENT 'Condition classification of the vehicle at point of sale. new indicates a new, untitled vehicle; used indicates a previously titled vehicle; certified_pre_owned indicates a manufacturer-certified pre-owned vehicle meeting OEM CPO program standards.. Valid values are `new|used|certified_pre_owned`',
    `warranty_start_date` DATE COMMENT 'The date on which the OEM new vehicle limited warranty period commences, typically aligned with the delivery_date or sale_date per OEM warranty policy. Used for warranty claim eligibility determination.',
    CONSTRAINT pk_retail_sale PRIMARY KEY(`retail_sale_id`)
) COMMENT 'Records the retail sale of a new or used vehicle by a dealership to an end customer. Captures VIN, sale date, sale price, MSRP, discount amount, trade-in details, financing type (cash, retail finance, lease), F&I products sold, salesperson, and deal status. Sourced from CDK Global DMS F&I module. SSOT for dealer-level vehicle sales transactions.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` (
    `dealer_service_appointment_id` BIGINT COMMENT 'Unique identifier for the dealer_service_appointment data product (auto-inserted pre-linking).',
    `aftersales_service_appointment_id` BIGINT COMMENT 'Foreign key linking to aftersales.service_appointment. Business justification: Business process: Dealer DMS schedules service appointments; aftersales processes them. Linking ensures appointment sync for parts, labor, and warranty tracking.',
    `case_id` BIGINT COMMENT 'Foreign key linking to customer.case. Business justification: Service appointments are created to resolve open customer cases (complaints, warranty issues, recall campaigns). Case management systems schedule dealer appointments for field resolution; this FK enab',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Dealer service appointments belong to a dealership; add dealership_id FK to link to dealership and remove redundant dealer_id column.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Service appointment scheduling needs to associate the customer (party) with the appointment for service history and follow‑up.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Service appointments are assigned to a service advisor; required for labor costing and service KPI dashboards.',
    `vehicle_ownership_id` BIGINT COMMENT 'Foreign key linking to customer.vehicle_ownership. Business justification: Service advisors pull the vehicle ownership record at appointment check-in to verify warranty status, ownership type, insurance, and service history. This is a standard DMS workflow. The existing vin_',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Service appointment scheduling must reference the specific vehicle VIN to allocate resources and track service history.',
    CONSTRAINT pk_dealer_service_appointment PRIMARY KEY(`dealer_service_appointment_id`)
) COMMENT 'Scheduled service appointments at a dealership for vehicle maintenance, warranty repair, recall service, or customer-pay work. Tracks appointment date/time, customer, VIN, service type, advisor assigned, estimated duration, appointment status (scheduled, checked-in, in-progress, completed, no-show), and transportation option (loaner, shuttle, wait). Sourced from CDK Global DMS service scheduling module.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` (
    `dealer_repair_order_id` BIGINT COMMENT 'Unique identifier for the dealer_repair_order data product (auto-inserted pre-linking).',
    `case_id` BIGINT COMMENT 'Foreign key linking to customer.case. Business justification: Repair orders are frequently opened to resolve a customer case (warranty claim, complaint, recall). Linking dealer_repair_order to customer.case enables case-to-repair traceability required for warran',
    `dealer_service_appointment_id` BIGINT COMMENT 'Foreign key linking to dealer.dealer_service_appointment. Business justification: A repair order is typically generated from a service appointment — the appointment is the scheduling event and the repair order is the execution record. Adding dealer_service_appointment_id to dealer_',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Repair orders must record the technician performing work for warranty compliance and labor allocation.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Repair orders must be linked to the owning customer for warranty claim processing and regulatory reporting.',
    `service_parts_stock_id` BIGINT COMMENT 'Foreign key linking to inventory.service_parts_stock. Business justification: Aftersales parts consumption process: a dealer repair order draws parts from a specific service_parts_stock location. This link enables inventory depletion posting, warranty parts traceability, and pa',
    `vehicle_ownership_id` BIGINT COMMENT 'Foreign key linking to customer.vehicle_ownership. Business justification: Repair orders require ownership record validation for warranty coverage determination, lien holder notification, and title-state-specific compliance. Technicians and warranty administrators need direc',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Repair orders must be tied to the VIN registry to manage warranty repairs and parts usage per vehicle.',
    CONSTRAINT pk_dealer_repair_order PRIMARY KEY(`dealer_repair_order_id`)
) COMMENT 'Detailed repair order (RO) record for each vehicle service event at a dealership. Captures RO number, open/close dates, VIN, mileage-in, complaint/cause/correction (3C), labor operations, technician assignments, parts consumed, warranty vs customer-pay vs internal split, total labor hours, total parts cost, and RO status. Core operational record for dealer service operations sourced from CDK Global DMS.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` (
    `demo_vehicle_id` BIGINT COMMENT 'Unique identifier for the demo vehicle record. Primary key.',
    `dealer_inventory_id` BIGINT COMMENT 'Foreign key linking to dealer.dealer_inventory. Business justification: A demo vehicle is a specific dealer inventory unit designated for the demonstrator program. Linking demo_vehicle to dealer_inventory via dealer_inventory_id establishes the relationship between the de',
    `opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Demo vehicles are assigned to support specific sales opportunities for test drives. opportunity.test_drive_completed and test_drive_date tracking, demo program ROI reporting, and opportunity-to-demo c',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer location where this demo vehicle is assigned.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Demo vehicle program tracks specific SKU to manage feature availability, warranty coverage, and cost recovery.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Demo vehicles are sold at end of demo period and converted to a vehicle_order. Demo disposition tracking, OEM demo program reconciliation, and retail conversion reporting require linking demo_vehicle ',
    `vehicle_warranty_id` BIGINT COMMENT 'Foreign key linking to aftersales.vehicle_warranty. Business justification: Demo vehicles carry OEM factory warranty coverage throughout the demo period. Linking demo_vehicle to vehicle_warranty enables warranty status validation during service events, warranty transfer eligi',
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

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ADD CONSTRAINT `fk_dealer_franchise_agreement_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ADD CONSTRAINT `fk_dealer_territory_franchise_agreement_id` FOREIGN KEY (`franchise_agreement_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`franchise_agreement`(`franchise_agreement_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ADD CONSTRAINT `fk_dealer_territory_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ADD CONSTRAINT `fk_dealer_vehicle_allocation_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ADD CONSTRAINT `fk_dealer_vehicle_allocation_territory_id` FOREIGN KEY (`territory_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`territory`(`territory_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_vehicle_allocation_id` FOREIGN KEY (`vehicle_allocation_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`vehicle_allocation`(`vehicle_allocation_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ADD CONSTRAINT `fk_dealer_parts_inventory_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_dealer_inventory_id` FOREIGN KEY (`dealer_inventory_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_inventory`(`dealer_inventory_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ADD CONSTRAINT `fk_dealer_dealer_service_appointment_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ADD CONSTRAINT `fk_dealer_dealer_repair_order_dealer_service_appointment_id` FOREIGN KEY (`dealer_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_service_appointment`(`dealer_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ADD CONSTRAINT `fk_dealer_dealer_repair_order_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ADD CONSTRAINT `fk_dealer_demo_vehicle_dealer_inventory_id` FOREIGN KEY (`dealer_inventory_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_inventory`(`dealer_inventory_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ADD CONSTRAINT `fk_dealer_demo_vehicle_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`dealer` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_automotive_v1`.`dealer` SET TAGS ('dbx_domain' = 'dealer');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` SET TAGS ('dbx_subdomain' = 'network_management');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership ID');
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
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `franchise_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
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
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` SET TAGS ('dbx_subdomain' = 'network_management');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `territory_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Territory Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `franchise_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Franchise Agreement Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `allocation_quota_percentage` SET TAGS ('dbx_business_glossary_term' = 'Allocation Quota Percentage');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `city_list` SET TAGS ('dbx_business_glossary_term' = 'City List');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `city_list` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `territory_code` SET TAGS ('dbx_business_glossary_term' = 'Territory Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `territory_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,12}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `competitive_intensity_rating` SET TAGS ('dbx_business_glossary_term' = 'Competitive Intensity Rating');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `competitive_intensity_rating` SET TAGS ('dbx_value_regex' = 'low|medium|high|very_high');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `county_region` SET TAGS ('dbx_business_glossary_term' = 'County or Region');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `dms_integration_status` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Integration Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `dms_integration_status` SET TAGS ('dbx_value_regex' = 'integrated|pending|failed|not_applicable');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `dms_last_sync_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Dealer Management System (DMS) Last Synchronization Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `geographic_boundary_description` SET TAGS ('dbx_business_glossary_term' = 'Geographic Boundary Description');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `household_count_estimate` SET TAGS ('dbx_business_glossary_term' = 'Household Count Estimate');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `incentive_program_eligibility_flag` SET TAGS ('dbx_business_glossary_term' = 'Incentive Program Eligibility Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `manager_email` SET TAGS ('dbx_business_glossary_term' = 'Territory Manager Email Address');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `manager_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `manager_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `manager_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `manager_name` SET TAGS ('dbx_business_glossary_term' = 'Territory Manager Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `manager_name` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `manager_phone` SET TAGS ('dbx_business_glossary_term' = 'Territory Manager Phone Number');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `manager_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `manager_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `market_segment_classification` SET TAGS ('dbx_business_glossary_term' = 'Market Segment Classification');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `market_segment_classification` SET TAGS ('dbx_value_regex' = 'urban|suburban|rural|metro|mixed');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `modification_reason` SET TAGS ('dbx_business_glossary_term' = 'Modification Reason');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `territory_name` SET TAGS ('dbx_business_glossary_term' = 'Territory Name');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `overlap_allowed_flag` SET TAGS ('dbx_business_glossary_term' = 'Territory Overlap Allowed Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `overlap_rule_description` SET TAGS ('dbx_business_glossary_term' = 'Overlap Rule Description');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `performance_benchmark_group` SET TAGS ('dbx_business_glossary_term' = 'Performance Benchmark Group');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `population_estimate` SET TAGS ('dbx_business_glossary_term' = 'Population Estimate');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `postal_code_list` SET TAGS ('dbx_business_glossary_term' = 'Postal Code List');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `postal_code_list` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `postal_code_list` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `primary_area_of_responsibility` SET TAGS ('dbx_business_glossary_term' = 'Primary Area of Responsibility (PAR)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `sales_potential_index` SET TAGS ('dbx_business_glossary_term' = 'Sales Potential Index');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `special_program_notes` SET TAGS ('dbx_business_glossary_term' = 'Special Program Notes');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `state_province_code` SET TAGS ('dbx_business_glossary_term' = 'State or Province Code');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `state_province_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `state_province_code` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `territory_status` SET TAGS ('dbx_business_glossary_term' = 'Territory Status');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `territory_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|suspended|under_review|terminated');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `territory_type` SET TAGS ('dbx_business_glossary_term' = 'Territory Type');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `territory_type` SET TAGS ('dbx_value_regex' = 'exclusive|shared|open|primary|secondary|overlay');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`territory` ALTER COLUMN `vehicle_allocation_priority` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Allocation Priority');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` SET TAGS ('dbx_subdomain' = 'inventory_operations');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `vehicle_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Allocation ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `territory_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Territory Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'rail|truck|ship|compound');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` SET TAGS ('dbx_subdomain' = 'inventory_operations');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `dealer_inventory_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Inventory ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Inventory Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `powertrain_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Variant Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `stock_transfer_order_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Transfer Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `vehicle_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Allocation Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `vehicle_build_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Build Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `asking_price` SET TAGS ('dbx_business_glossary_term' = 'Current Asking Price');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `asking_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `body_style` SET TAGS ('dbx_business_glossary_term' = 'Body Style');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `certified_pre_owned` SET TAGS ('dbx_business_glossary_term' = 'Certified Pre-Owned (CPO) Flag');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `days_on_lot` SET TAGS ('dbx_business_glossary_term' = 'Days on Lot');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `dms_record_reference` SET TAGS ('dbx_business_glossary_term' = 'DMS Record ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `drivetrain` SET TAGS ('dbx_business_glossary_term' = 'Drivetrain Configuration');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ALTER COLUMN `drivetrain` SET TAGS ('dbx_value_regex' = 'FWD|RWD|AWD|4WD');
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
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `parts_inventory_id` SET TAGS ('dbx_business_glossary_term' = 'Parts Inventory ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `service_part_id` SET TAGS ('dbx_business_glossary_term' = 'Service Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Catalog Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` SET TAGS ('dbx_subdomain' = 'sales_transactions');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `retail_sale_id` SET TAGS ('dbx_business_glossary_term' = 'Retail Sale ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `dealer_inventory_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Inventory Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Membership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `msrp_pricing_id` SET TAGS ('dbx_business_glossary_term' = 'Msrp Pricing Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `organization_account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Fleet Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Salesperson ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `trade_in_id` SET TAGS ('dbx_business_glossary_term' = 'Trade In Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `vehicle_warranty_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Warranty Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `vehicle_condition` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Condition');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `vehicle_condition` SET TAGS ('dbx_value_regex' = 'new|used|certified_pre_owned');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Start Date');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` SET TAGS ('dbx_subdomain' = 'service_delivery');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `dealer_service_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for dealer_service_appointment');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `aftersales_service_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Aftersales Service Appointment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `case_id` SET TAGS ('dbx_business_glossary_term' = 'Case Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Service Advisor Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `vehicle_ownership_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Ownership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` SET TAGS ('dbx_subdomain' = 'service_delivery');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `dealer_repair_order_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for dealer_repair_order');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `case_id` SET TAGS ('dbx_business_glossary_term' = 'Case Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `dealer_service_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Service Appointment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Technician Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `dealership_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `service_parts_stock_id` SET TAGS ('dbx_business_glossary_term' = 'Service Parts Stock Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `vehicle_ownership_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Ownership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` SET TAGS ('dbx_subdomain' = 'sales_transactions');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `demo_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Demo Vehicle ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `dealer_inventory_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Inventory Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ALTER COLUMN `vehicle_warranty_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Warranty Id (Foreign Key)');
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
