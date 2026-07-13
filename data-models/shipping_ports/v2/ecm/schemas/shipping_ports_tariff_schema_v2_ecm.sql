-- Schema for Domain: tariff | Business: Shipping_Ports | Version: v2_ecm
-- Generated on: 2026-07-13 08:38:31

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`tariff` COMMENT 'Owns the complete port services pricing catalog including THC (Terminal Handling Charges), wharfage (WHR), pilotage fees, demurrage (DMG), detention (DET), PIL, BAF, CAF, storage tariffs, and SLA-linked service rate cards. Covers rate cards, pricing rules, discount structures, and tariff schedules. SSOT for all commercial pricing and tariff definitions.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` (
    `port_tariff_id` BIGINT COMMENT 'Unique identifier for the port tariff schedule record. Primary key.',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: Port tariffs require national regulatory approval (approval_authority, regulatory_filing_required_flag). Country context determines jurisdiction, regulatory framework, currency regulations, and intern',
    `superseded_by_tariff_port_tariff_id` BIGINT COMMENT 'Reference to the port_tariff_id of the newer tariff schedule that replaces this one. Null if this is the current active schedule.',
    `trade_restriction_id` BIGINT COMMENT 'Foreign key linking to compliance.trade_restriction. Business justification: Port tariffs must reference trade restrictions to exclude embargoed goods, sanctioned parties from standard tariff application. Regulatory compliance requirement for port authorities.',
    `un_locode_id` BIGINT COMMENT 'Foreign key linking to masterdata.un_locode. Business justification: Port tariffs are published for specific UN LOCODE locations. Tariff schedules must reference the standardized port location code for regulatory filing, publication, and enforcement. Essential for tari',
    `applicable_cargo_types` STRING COMMENT 'Comma-separated list of cargo types to which this tariff applies (e.g., FCL, LCL, Breakbulk, Dangerous Goods, Reefer). Null if applicable to all cargo types.',
    `applicable_container_types` STRING COMMENT 'Comma-separated list of container types to which this tariff applies (e.g., 20GP, 40GP, 40HC, 45HC, Reefer, Tank, Flat Rack). Null if not container-specific.',
    `applicable_movement_types` STRING COMMENT 'Comma-separated list of cargo movement types to which this tariff applies (e.g., Import, Export, Transshipment, Empty Repositioning, Restow). Null if applicable to all movements.',
    `applicable_terminal_zones` STRING COMMENT 'Comma-separated list of terminal zones, berths, or container yards to which this tariff applies (e.g., Zone A, Berth 1-5, CY North). Null if applicable port-wide.',
    `applicable_trade_lanes` STRING COMMENT 'Comma-separated list of trade lanes or routes to which this tariff applies (e.g., Asia-Europe, Transpacific, Intra-Asia). Null if applicable to all lanes.',
    `applicable_vessel_categories` STRING COMMENT 'Comma-separated list of vessel types or categories to which this tariff applies (e.g., Container, Bulk Carrier, Tanker, RoRo). Null if applicable to all vessel types.',
    `approval_authority` STRING COMMENT 'Name of the regulatory body or internal authority that approved this tariff schedule (e.g., Port Authority Board, National Maritime Safety Authority, Finance Committee).',
    `approval_date` DATE COMMENT 'Date on which the tariff schedule received regulatory or port authority board approval.',
    `approval_reference_number` STRING COMMENT 'Official reference or filing number assigned by the approval authority for audit and compliance tracking.',
    `base_rate_amount` DECIMAL(18,2) COMMENT 'Base rate amount for this tariff schedule. Interpretation depends on charge_type: per TEU for THC, per tonne for WHR, per movement for pilotage, per day for storage/DMG/DET. Null if tariff uses complex multi-tier pricing defined in tariff_item.',
    `charge_type` STRING COMMENT 'Discriminator identifying the category of port charge. THC=Terminal Handling Charge, WHR=Wharfage, PILOTAGE=Pilotage fees, TOWAGE=Towage services, MOORING=Mooring services, PORT_DUES=Port dues (light/conservancy/anchorage), STORAGE=Container storage, DMG=Demurrage, DET=Detention, BAF=Bunker Adjustment Factor, CAF=Currency Adjustment Factor, PIL=Port Infrastructure Levy. New charge types added as new rows. [ENUM-REF-CANDIDATE: THC|WHR|PILOTAGE|TOWAGE|MOORING|PORT_DUES|STORAGE|DMG|DET|BAF|CAF|PIL — 12 candidates stripped; promote to reference product]',
    `created_by_user` STRING COMMENT 'Username or identifier of the user who created this tariff schedule record.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this tariff schedule record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which tariff rates are denominated (e.g., USD, EUR, GBP, SGD).. Valid values are `^[A-Z]{3}$`',
    `discount_eligible_flag` BOOLEAN COMMENT 'Indicates whether this tariff schedule is eligible for volume discounts, loyalty discounts, or promotional pricing. True=Eligible, False=Fixed pricing only.',
    `dwt_band_max` DECIMAL(18,2) COMMENT 'Maximum vessel Deadweight Tonnage for towage or mooring tariffs that are banded by cargo capacity. Null if not DWT-banded or open-ended.',
    `dwt_band_min` DECIMAL(18,2) COMMENT 'Minimum vessel Deadweight Tonnage for towage or mooring tariffs that are banded by cargo capacity. Null if not DWT-banded.',
    `effective_from_date` DATE COMMENT 'Date from which this tariff schedule becomes binding and applicable to port operations and billing.',
    `effective_to_date` DATE COMMENT 'Date on which this tariff schedule ceases to be applicable. Nullable for open-ended schedules.',
    `escalation_structure` STRING COMMENT 'Pricing escalation model for storage, demurrage, or detention charges. FLAT=Single rate throughout, TIERED=Rate increases at defined day thresholds, PROGRESSIVE=Rate increases daily or weekly.. Valid values are `FLAT|TIERED|PROGRESSIVE`',
    `free_time_days` STRING COMMENT 'Number of free days allowed before demurrage or storage charges begin to accrue. Applicable to DMG, DET, and STORAGE charge types. Null if no free time applies.',
    `grt_band_max` DECIMAL(18,2) COMMENT 'Maximum vessel Gross Registered Tonnage for port dues, pilotage, or towage tariffs that are banded by vessel tonnage. Null if not tonnage-banded or open-ended.',
    `grt_band_min` DECIMAL(18,2) COMMENT 'Minimum vessel Gross Registered Tonnage for port dues, pilotage, or towage tariffs that are banded by vessel tonnage. Null if not tonnage-banded.',
    `last_modified_by_user` STRING COMMENT 'Username or identifier of the user who last modified this tariff schedule record.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this tariff schedule record was last updated in the system.',
    `loa_band_max_meters` DECIMAL(18,2) COMMENT 'Maximum vessel Length Overall in meters for pilotage, towage, or mooring tariffs that are banded by vessel size. Null if not size-banded or open-ended.',
    `loa_band_min_meters` DECIMAL(18,2) COMMENT 'Minimum vessel Length Overall in meters for pilotage, towage, or mooring tariffs that are banded by vessel size. Null if not size-banded.',
    `maximum_charge_amount` DECIMAL(18,2) COMMENT 'Maximum charge amount cap that applies regardless of calculated charge. Used for regulatory compliance or customer protection. Null if no cap applies.',
    `minimum_charge_amount` DECIMAL(18,2) COMMENT 'Minimum charge amount that applies regardless of calculated charge. Used to ensure minimum revenue per transaction or vessel call. Null if no minimum applies.',
    `notes` STRING COMMENT 'Additional notes, clarifications, or special instructions related to the application of this tariff schedule. May include references to related schedules or regulatory requirements.',
    `public_tariff_flag` BOOLEAN COMMENT 'Indicates whether this tariff schedule is publicly published and available to all port users, or is a confidential negotiated rate. True=Public tariff, False=Confidential/negotiated rate.',
    `publication_date` DATE COMMENT 'Date on which the tariff schedule was officially published to customers, shipping lines, and stakeholders.',
    `rate_unit_of_measure` STRING COMMENT 'Unit of measure for the tariff rate. PER_TEU=Per Twenty-foot Equivalent Unit, PER_FEU=Per Forty-foot Equivalent Unit, PER_CONTAINER=Per container regardless of size, PER_TONNE=Per metric tonne, PER_CBM=Per cubic meter, PER_MOVEMENT=Per handling movement, PER_HOUR=Per hour, PER_DAY=Per day, PER_CALL=Per vessel call, LUMP_SUM=Fixed amount. [ENUM-REF-CANDIDATE: PER_TEU|PER_FEU|PER_CONTAINER|PER_TONNE|PER_CBM|PER_MOVEMENT|PER_HOUR|PER_DAY|PER_CALL|LUMP_SUM — 10 candidates stripped; promote to reference product]',
    `regulatory_filing_required_flag` BOOLEAN COMMENT 'Indicates whether this tariff schedule requires formal filing with or approval from a regulatory authority before implementation. True=Regulatory filing required, False=Internal approval sufficient.',
    `sla_linked_flag` BOOLEAN COMMENT 'Indicates whether this tariff is linked to specific Service Level Agreement performance commitments. True=SLA-linked with performance guarantees, False=Standard tariff without SLA.',
    `tariff_description` STRING COMMENT 'Detailed description of the tariff schedule including scope, applicability conditions, calculation methodology, and any special terms or exclusions.',
    `tariff_schedule_code` STRING COMMENT 'Externally published unique code identifying this tariff schedule (e.g., THC-2024-Q1, PIL-ZONE-A-2024). Used in billing systems, customer communications, and regulatory filings.. Valid values are `^[A-Z0-9]{6,12}$`',
    `tariff_schedule_name` STRING COMMENT 'Human-readable name of the tariff schedule (e.g., Terminal Handling Charges - Container Import 2024, Pilotage Fees - LOA Band 200-300m).',
    `tariff_status` STRING COMMENT 'Current lifecycle status of the tariff schedule. DRAFT=Under development, PENDING_APPROVAL=Submitted for regulatory approval, APPROVED=Approved but not yet effective, PUBLISHED=Published to stakeholders, ACTIVE=Currently in force, SUSPENDED=Temporarily inactive, SUPERSEDED=Replaced by newer schedule, ARCHIVED=Historical record. [ENUM-REF-CANDIDATE: DRAFT|PENDING_APPROVAL|APPROVED|PUBLISHED|ACTIVE|SUSPENDED|SUPERSEDED|ARCHIVED — 8 candidates stripped; promote to reference product]',
    CONSTRAINT pk_port_tariff PRIMARY KEY(`port_tariff_id`)
) COMMENT 'Master catalog of all port tariff schedules published by the port authority, organized by charge type discriminator. Supported charge types include THC (Terminal Handling Charges by container type/movement/zone), wharfage (WHR by cargo type/HS code/tonnage), pilotage (by LOA/GRT band/zone/time), towage (by GRT/DWT band/tug count/operation type), mooring (by LOA band/gang count/time), port dues (light dues, conservancy, anchorage by vessel GRT/flag), storage (by container status/type/zone with escalating bands), demurrage (DMG by container type/day with free time and escalation), and detention (DET for off-terminal equipment retention). Each record defines a named tariff schedule with its charge type classification, effective period, applicable trade lanes, vessel categories, cargo types, terminal zones, regulatory approval status, and filing reference. New charge types are added as new rows with a charge_type discriminator — no schema changes required. Supports multiple concurrent schedules per charge type. This is the SSOT for all tariff schedule definitions — individual charge amounts are held in tariff_item.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`item` (
    `item_id` BIGINT COMMENT 'Unique identifier for the tariff item. Primary key for the tariff item entity.',
    `charge_event_id` BIGINT COMMENT 'Foreign key linking to billing.charge_event. Business justification: Tariff items define pricing rules; charge_events are the actual application of those tariffs to billable events. This FK enables tracking which tariff item was applied to generate each charge. Tempora',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Tariff line items apply to specific cargo commodities (cargo_type_applicability). HS code classification determines applicable charges, handling requirements, and regulatory compliance. Critical for t',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: Tariff items apply commodity-specific charges based on HS codes (dangerous goods surcharges, refrigerated cargo handling fees). Core charge calculation process distinct from wharfage.',
    `demurrage_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.demurrage_schedule. Business justification: When tariff_item charge_category is demurrage (DMG), this FK links to the demurrage schedule defining tiered daily rates after free time expires. Resolves demurrage_schedule silo.',
    `detention_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.detention_schedule. Business justification: When tariff_item charge_category is detention (DET), this FK links to the detention schedule defining equipment detention charges. Resolves detention_schedule silo.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Every tariff item posts revenue to a specific GL account when invoiced. Revenue recognition and financial statement preparation require mapping each charge type (wharfage, pilotage, storage) to its co',
    `mooring_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.mooring_tariff. Business justification: When tariff_item charge_category is mooring, this FK links to the mooring tariff defining line-handling service charges. Resolves mooring_tariff silo.',
    `pilotage_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.pilotage_tariff. Business justification: When tariff_item charge_category is pilotage, this FK links to the pilotage tariff defining vessel-based pilotage fees. Resolves pilotage_tariff silo.',
    `port_dues_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.port_dues_schedule. Business justification: When tariff_item charge_category is port dues, this FK links to the port dues schedule defining statutory vessel call charges. Resolves port_dues_schedule silo.',
    `port_tariff_id` BIGINT COMMENT 'Reference to the parent tariff schedule that contains this tariff item. Links the item to its governing rate card or pricing schedule.',
    `service_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.service_code. Business justification: Tariff items price specific port services. Currently tariff_item has service_type as a string. Adding FK to masterdata.service_code provides standardized service definitions, billing_basis, tax_code, ',
    `storage_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.storage_tariff. Business justification: When tariff_item charge_category is storage, this FK links to the storage tariff defining progressive daily storage rates by container type and zone. Resolves storage_tariff silo.',
    `thc_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.thc_schedule. Business justification: tariff_item defines a billable charge within port_tariff. When the charge_category is THC (Terminal Handling Charge), this FK links to the detailed THC schedule that defines the rate structure by cont',
    `towage_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.towage_tariff. Business justification: When tariff_item charge_category is towage, this FK links to the towage tariff defining tug assistance charges by vessel size and operation type. Resolves towage_tariff silo.',
    `wharfage_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.wharfage_schedule. Business justification: When tariff_item charge_category is wharfage (WHR), this FK links to the wharfage schedule defining cargo-based port dues. Resolves wharfage_schedule silo and enables navigation from charge definition',
    `approval_status` STRING COMMENT 'Approval workflow status for this tariff item. Pending items await management approval, approved items are authorized for use, rejected items require revision.. Valid values are `pending|approved|rejected`',
    `approved_by` STRING COMMENT 'Name or identifier of the person who approved this tariff item for publication and use.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this tariff item was approved for use.',
    `charge_basis` STRING COMMENT 'The calculation method for the charge (e.g., per unit, per day, per move, flat rate, percentage of cargo value). [ENUM-REF-CANDIDATE: per_unit|per_day|per_move|per_gang|per_hour|per_shift|per_vessel_call|flat_rate|percentage — 9 candidates stripped; promote to reference product]',
    `charge_category` STRING COMMENT 'High-level classification of the charge type for grouping and reporting purposes. [ENUM-REF-CANDIDATE: terminal_handling|wharfage|pilotage|towage|storage|demurrage|detention|infrastructure|bunker_adjustment|currency_adjustment|service_fee — 11 candidates stripped; promote to reference product]',
    `charge_code` STRING COMMENT 'Unique alphanumeric code identifying the type of charge (e.g., THC, WHR, DMG, DET, PIL, BAF, CAF). Used as the billing system reference for this tariff item.. Valid values are `^[A-Z0-9]{3,10}$`',
    `charge_description` STRING COMMENT 'Detailed description of the tariff item, including applicability conditions, service scope, and any special terms or exclusions.',
    `charge_name` STRING COMMENT 'Human-readable name of the charge (e.g., Terminal Handling Charge, Wharfage, Pilotage Fee, Demurrage, Detention, Port Infrastructure Levy).',
    `container_size_applicability` STRING COMMENT 'Specifies which container sizes this tariff item applies to (20ft for TEU, 40ft for FEU, 45ft for high-cube, all for any size).. Valid values are `20ft|40ft|45ft|all`',
    `container_type_applicability` STRING COMMENT 'Comma-separated list of container types to which this tariff item applies (e.g., standard, refrigerated, open_top, flat_rack, tank). Empty means applies to all container types. [ENUM-REF-CANDIDATE: standard|refrigerated|open_top|flat_rack|tank|platform|ventilated — promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this tariff item record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the rate amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `dangerous_goods_flag` BOOLEAN COMMENT 'Indicates whether this tariff item applies specifically to dangerous goods (IMDG cargo). True means this rate is for dangerous goods only; False means it applies to general cargo.',
    `effective_from_date` DATE COMMENT 'Date from which this tariff item becomes active and applicable for billing. Part of the tariff items temporal validity window.',
    `effective_to_date` DATE COMMENT 'Date until which this tariff item remains active and applicable for billing. Null indicates the tariff item is open-ended and remains active until superseded.',
    `escalation_tier_1_days` STRING COMMENT 'Number of days after free time expires when the first escalation tier rate applies (used for storage, demurrage, detention with escalating daily rates).',
    `escalation_tier_1_rate` DECIMAL(18,2) COMMENT 'Rate amount for the first escalation tier (days beyond free time up to escalation_tier_1_days).',
    `escalation_tier_2_days` STRING COMMENT 'Number of days after tier 1 expires when the second escalation tier rate applies.',
    `escalation_tier_2_rate` DECIMAL(18,2) COMMENT 'Rate amount for the second escalation tier (days beyond tier 1 up to escalation_tier_2_days).',
    `escalation_tier_3_days` STRING COMMENT 'Number of days after tier 2 expires when the third escalation tier rate applies.',
    `escalation_tier_3_rate` DECIMAL(18,2) COMMENT 'Rate amount for the third escalation tier (days beyond tier 2 up to escalation_tier_3_days).',
    `fcl_lcl_applicability` STRING COMMENT 'Indicates whether this tariff item applies to Full Container Load (FCL) shipments, Less than Container Load (LCL) shipments, or both.. Valid values are `FCL|LCL|both`',
    `free_time_days` STRING COMMENT 'Number of free days allowed before charges begin to accrue (applicable to storage, demurrage, and detention charges). Zero means charges start immediately.',
    `import_export_direction` STRING COMMENT 'Specifies whether this tariff item applies to import cargo, export cargo, transshipment cargo, or all directions.. Valid values are `import|export|transshipment|all`',
    `item_status` STRING COMMENT 'Current lifecycle status of the tariff item. Draft items are under review, active items are in use, suspended items are temporarily inactive, expired items are past their effective date, superseded items have been replaced by newer versions.. Valid values are `draft|active|suspended|expired|superseded`',
    `maximum_charge` DECIMAL(18,2) COMMENT 'The maximum charge that will be applied regardless of calculated amount. Caps the price for the service.',
    `minimum_charge` DECIMAL(18,2) COMMENT 'The minimum charge that will be applied regardless of calculated amount. Ensures a floor price for the service.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this tariff item record was last modified or updated.',
    `rate_amount` DECIMAL(18,2) COMMENT 'The base rate or price per unit of measure for this tariff item. Expressed in the currency specified in the tariff schedule.',
    `rate_band_amount_1` DECIMAL(18,2) COMMENT 'Rate amount applied to units within the first rate band (up to rate_band_threshold_1).',
    `rate_band_amount_2` DECIMAL(18,2) COMMENT 'Rate amount applied to units within the second rate band (between threshold_1 and threshold_2).',
    `rate_band_amount_3` DECIMAL(18,2) COMMENT 'Rate amount applied to units within the third rate band (between threshold_2 and threshold_3).',
    `rate_band_threshold_1` DECIMAL(18,2) COMMENT 'First threshold value for tiered pricing. Units below or equal to this threshold are charged at rate_band_amount_1.',
    `rate_band_threshold_2` DECIMAL(18,2) COMMENT 'Second threshold value for tiered pricing. Units above threshold_1 and below or equal to this threshold are charged at rate_band_amount_2.',
    `rate_band_threshold_3` DECIMAL(18,2) COMMENT 'Third threshold value for tiered pricing. Units above threshold_2 and below or equal to this threshold are charged at rate_band_amount_3.',
    `rounding_precision` STRING COMMENT 'Number of decimal places to which the charge should be rounded (e.g., 0 for whole numbers, 2 for cents).',
    `rounding_rule` STRING COMMENT 'Specifies how calculated charges should be rounded (e.g., round up to nearest whole unit, round down, round to nearest, no rounding).. Valid values are `round_up|round_down|round_nearest|no_rounding`',
    `sla_service_level` STRING COMMENT 'Service level tier associated with this tariff item (e.g., standard, express, premium). Used for SLA-linked rate cards where pricing varies by committed service level.. Valid values are `standard|express|premium`',
    `tiered_pricing_flag` BOOLEAN COMMENT 'Indicates whether this tariff item uses tiered or banded pricing (True) or a flat rate (False). When True, rate bands and thresholds apply.',
    `trade_lane_applicability` STRING COMMENT 'Comma-separated list of trade lanes or routes to which this tariff item applies (e.g., asia_europe, transatlantic, intra_asia). Empty means applies to all trade lanes.',
    `unit_of_measure` STRING COMMENT 'The unit by which the charge is calculated and billed (e.g., TEU for Twenty-foot Equivalent Unit, FEU for Forty-foot Equivalent Unit, GRT for Gross Registered Tonnage, LOA for Length Overall, CBM for Cubic Meter). [ENUM-REF-CANDIDATE: TEU|FEU|GRT|NRT|LOA|CBM|tonne|day|move|gang|hour|shift|container|vessel_call — 14 candidates stripped; promote to reference product]',
    `vessel_type_applicability` STRING COMMENT 'Comma-separated list of vessel types to which this tariff item applies (e.g., container, bulk, tanker, RoRo, general_cargo). Empty means applies to all vessel types. [ENUM-REF-CANDIDATE: container|bulk|tanker|roro|general_cargo|cruise|ferry|barge — promote to reference product]',
    CONSTRAINT pk_item PRIMARY KEY(`item_id`)
) COMMENT 'Individual line-item charge definition within a port tariff schedule. Represents a single billable service rate (e.g., THC per TEU by container type, wharfage per GRT by cargo category, pilotage per LOA band by zone, storage per day per TEU by escalation tier, towage per GRT band by operation type). Captures the charge code, unit of measure (TEU, FEU, GRT, LOA, CBM, tonne, day, move, gang), charge basis, rate amount, minimum charge, maximum charge, rounding rules, vessel/cargo/trade applicability conditions, and rate band thresholds for tiered pricing. Forms the atomic pricing unit referenced by rate cards, pricing rules, and the billing engine.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` (
    `rate_card_id` BIGINT COMMENT 'Unique identifier for the rate card. Primary key.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Major customer rate cards require assigned account managers who own the commercial relationship, negotiate terms, monitor volume commitments, and handle escalations. This is standard practice in marit',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Rate cards are negotiated pricing instruments implementing commercial agreements. Every rate card in port operations is governed by a master agreement defining commercial terms, parties, payment condi',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Rate cards are assigned to cost centres for revenue tracking and profitability analysis. Monthly P&L reporting by cost centre requires linking negotiated customer rates to the delivering cost centre f',
    `customs_broker_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_broker. Business justification: Negotiated rate cards for customs brokers who are high-volume port service users. Real commercial relationship in maritime logistics for freight forwarding services.',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Negotiated rate cards are customer-specific contracts with shipping lines. Shipping lines are major port customers with volume commitments, SLA requirements, and preferential pricing. Essential for co',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the specific customer or shipping line to which this rate card applies. Null if rate card is segment-based rather than customer-specific.',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Rate cards drive revenue streams tracked by profit centre for segment reporting. Executive dashboards showing revenue by business unit/terminal require linking rate cards to profit centres for accurat',
    `superseded_by_rate_card_id` BIGINT COMMENT 'Reference to the newer rate card that replaces this one. Null if this rate card is still current or has not been superseded.',
    `approval_status` STRING COMMENT 'Current workflow status of the rate card in the approval and lifecycle process. Draft = under construction, pending_approval = submitted for review, approved = authorized but not yet active, active = currently in use, expired = past expiry date, superseded = replaced by newer version. [ENUM-REF-CANDIDATE: draft|pending_approval|approved|rejected|active|expired|superseded — 7 candidates stripped; promote to reference product]',
    `approved_by` STRING COMMENT 'Name or identifier of the commercial manager or authority who approved this rate card for use.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the rate card was formally approved.',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether this rate card automatically renews upon expiry (True) or requires explicit renewal negotiation (False).',
    `billing_frequency` STRING COMMENT 'Frequency at which charges under this rate card are invoiced to the customer.. Valid values are `per_transaction|daily|weekly|monthly|quarterly`',
    `committed_volume_teu` DECIMAL(18,2) COMMENT 'Committed container volume in TEU that the customer agrees to handle under this rate card during the contract period. Applicable to volume-based rate cards.',
    `crane_productivity_target_moves_per_hour` DECIMAL(18,2) COMMENT 'Target crane productivity in container moves per hour committed under SLA-linked rate cards. Null for non-SLA rate cards.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this rate card record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which all rates on this rate card are denominated (e.g., USD, EUR, SGD).. Valid values are `^[A-Z]{3}$`',
    `customer_segment` STRING COMMENT 'Target customer tier or segment to which this rate card applies (e.g., tier_1 for top-tier shipping lines, sme for small-medium enterprises).. Valid values are `tier_1|tier_2|tier_3|vip|standard|sme`',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Overall discount percentage applied to base tariff rates in this rate card (e.g., 15.00 represents a 15% discount). Null if no blanket discount applies.',
    `effective_date` DATE COMMENT 'Date from which this rate card becomes active and applicable for billing and pricing calculations.',
    `escalation_clause` STRING COMMENT 'Description of rate escalation terms, such as annual CPI adjustments, fuel surcharge indexing, or fixed percentage increases (e.g., 3% annual escalation on anniversary date).',
    `expiry_date` DATE COMMENT 'Date on which this rate card ceases to be valid. Null for open-ended rate cards that remain active until explicitly superseded.',
    `gate_processing_time_target_minutes` DECIMAL(18,2) COMMENT 'Target gate processing time in minutes for truck transactions committed under SLA-linked rate cards. Null for non-SLA rate cards.',
    `measurement_period` STRING COMMENT 'Time period over which SLA performance is measured and assessed (e.g., monthly average, per vessel call). Null for non-SLA rate cards.. Valid values are `daily|weekly|monthly|quarterly|per_call`',
    `minimum_commitment_amount` DECIMAL(18,2) COMMENT 'Minimum revenue or volume commitment required from the customer to qualify for this rate card pricing. Null if no minimum commitment applies.',
    `modified_by` STRING COMMENT 'Identifier or name of the user or system that last modified this rate card record.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this rate card record was last modified.',
    `rate_card_name` STRING COMMENT 'Human-readable name of the rate card, typically describing the customer segment, trade lane, or service tier (e.g., Asia-Europe Premium SLA Gold Tier, Standard Container Handling - Tier 1 Customers).',
    `notes` STRING COMMENT 'Free-text field for additional commercial notes, special conditions, or clarifications related to this rate card.',
    `notice_period_days` STRING COMMENT 'Number of days advance notice required to terminate or amend this rate card.',
    `payment_terms` STRING COMMENT 'Payment terms applicable to invoices generated under this rate card (e.g., Net 30 days, Net 15 days, Prepayment required).',
    `penalty_clause_description` STRING COMMENT 'Textual description of penalty terms applicable if SLA performance targets are not met (e.g., 5% rate reduction for each hour beyond target turnaround time). Null for non-SLA rate cards.',
    `premium_clause_description` STRING COMMENT 'Textual description of premium or bonus terms applicable if SLA performance targets are exceeded (e.g., 3% rate premium for turnaround time 20% faster than target). Null for non-SLA rate cards.',
    `premium_percentage` DECIMAL(18,2) COMMENT 'Overall premium percentage applied to base tariff rates in this rate card for expedited or premium services (e.g., 10.00 represents a 10% premium). Null if no premium applies.',
    `rate_card_number` STRING COMMENT 'Externally-known unique business identifier for the rate card, used in commercial documentation and billing references.. Valid values are `^RC-[A-Z0-9]{6,12}$`',
    `rate_card_type` STRING COMMENT 'Classification of the rate card: standard (published rates), sla_linked (performance-based pricing with SLA tiers), promotional (temporary discount rates), spot (one-time negotiated rates), contract (long-term agreement rates).. Valid values are `standard|sla_linked|promotional|spot|contract`',
    `service_type` STRING COMMENT 'Type of port service covered by this rate card (e.g., Container Handling, Vessel Berthing, Pilotage, Storage, THC). May reference multiple service types if rate card is comprehensive. [ENUM-REF-CANDIDATE: container_handling|vessel_berthing|pilotage|towage|storage|thc|wharfage|demurrage|detention|pil|baf|caf — promote to reference product]',
    `sla_tier` STRING COMMENT 'Service performance tier applicable to SLA-linked rate cards, defining the level of service commitment and associated pricing (gold = highest service level, bronze = basic service level). Null for non-SLA rate cards.. Valid values are `gold|silver|bronze|platinum|standard`',
    `trade_lane` STRING COMMENT 'Geographic trade route or lane to which this rate card applies (e.g., Asia-Europe, Transpacific, Intra-Asia). Null if rate card is not trade-lane specific.',
    `version` STRING COMMENT 'Version identifier for the rate card, enabling tracking of amendments and revisions over time (e.g., v1.0, 2.1).. Valid values are `^v?[0-9]+.[0-9]+(.[0-9]+)?$`',
    `vessel_turnaround_time_target_hours` DECIMAL(18,2) COMMENT 'Target vessel turnaround time in hours committed under SLA-linked rate cards. Null for non-SLA rate cards.',
    `created_by` STRING COMMENT 'Identifier or name of the user or system that created this rate card record.',
    CONSTRAINT pk_rate_card PRIMARY KEY(`rate_card_id`)
) COMMENT 'Negotiated or published rate card defining specific pricing applicable to a customer segment, shipping line, cargo owner, or trade lane. A rate card references one or more tariff items and overrides or discounts the base tariff rates for a defined period. Supports standard commercial rate cards and SLA-linked rate cards with service performance tiers (Gold/Silver/Bronze), committed KPIs (vessel turnaround time, crane productivity moves/hour, gate processing time), penalty/premium clauses, measurement periods, and escalation clauses. Captures rate card name, version, effective and expiry dates, applicable customer tier, trade lane, service type, SLA tier (if applicable), currency, approval workflow status, and link to originating tariff_negotiation. An SLA tier discriminator distinguishes standard rate cards from performance-linked rate cards — no separate entity required. Serves as the commercial pricing instrument linking the tariff catalog to customer agreements and SLA-based billing adjustments.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` (
    `rate_card_line_id` BIGINT COMMENT 'Unique identifier for the rate card line. Primary key for this entity.',
    `bunker_adjustment_id` BIGINT COMMENT 'Foreign key linking to tariff.bunker_adjustment. Business justification: rate_card_line has baf_applicable_flag indicating Bunker Adjustment Factor applies, but no FK to the specific BAF record. Adding this FK links the line to the applicable bunker_adjustment (BAF) record',
    `currency_adjustment_id` BIGINT COMMENT 'Foreign key linking to tariff.currency_adjustment. Business justification: rate_card_line has caf_applicable_flag indicating Currency Adjustment Factor applies, but no FK to the specific CAF record. Adding this FK links the line to the applicable currency_adjustment (CAF) re',
    `employee_id` BIGINT COMMENT 'Identifier of the user or role who approved this rate card line, particularly for overrides or exceptions. Supports audit and compliance requirements.',
    `item_id` BIGINT COMMENT 'Foreign key linking to tariff.tariff_item. Business justification: rate_card_line currently has tariff_item_code (STRING) for business reference, but needs a proper FK to tariff_item to link negotiated rates to the master tariff item definition. This enables joining ',
    `rate_card_id` BIGINT COMMENT 'Reference to the parent rate card that contains this line item. Links this pricing line to the overall commercial rate card agreement.',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Rate card lines specify zone-differentiated pricing (restricted area access fees, high-security zone cargo handling surcharges, customs-controlled area storage premiums). Commercial systems link line ',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when this rate card line was approved for use. Critical for audit trail and compliance with pricing governance policies.',
    `baf_applicable_flag` BOOLEAN COMMENT 'Indicates whether the Bunker Adjustment Factor (BAF) surcharge is applicable to this rate card line. BAF compensates for fuel cost fluctuations. True if BAF applies, False otherwise.',
    `billing_frequency` STRING COMMENT 'Frequency at which charges based on this rate card line are billed. Values include per_event (billed per occurrence), daily (daily billing), weekly (weekly billing), monthly (monthly billing), quarterly (quarterly billing), annual (annual billing).. Valid values are `per_event|daily|weekly|monthly|quarterly|annual`',
    `caf_applicable_flag` BOOLEAN COMMENT 'Indicates whether the Currency Adjustment Factor (CAF) surcharge is applicable to this rate card line. CAF compensates for currency exchange rate fluctuations. True if CAF applies, False otherwise.',
    `cargo_type` STRING COMMENT 'Type of cargo to which this rate card line applies. Values include general (general cargo), bulk (dry bulk), liquid (liquid bulk), container (containerized), roro (roll-on roll-off), breakbulk (break bulk), dangerous (IMDG dangerous goods), refrigerated (reefer cargo). Null if rate applies to all cargo types. [ENUM-REF-CANDIDATE: general|bulk|liquid|container|roro|breakbulk|dangerous|refrigerated — 8 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this rate card line record was first created in the system. Part of the audit trail for data lineage and compliance.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which the unit rate is denominated (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Percentage discount applied to the base unit rate for this line. Used for volume discounts, promotional pricing, or negotiated rate reductions. Null if no discount applies.',
    `effective_from_date` DATE COMMENT 'The date from which this rate card line becomes effective and can be applied to billing. Part of the temporal validity window for this pricing line.',
    `effective_to_date` DATE COMMENT 'The date until which this rate card line remains effective. Null indicates an open-ended validity period. Part of the temporal validity window for this pricing line.',
    `free_time_days` STRING COMMENT 'Number of free days allowed before charges such as storage, demurrage, or detention begin to accrue. Commonly used for container storage and cargo dwell time pricing. Null if not applicable.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this rate card line record was last modified. Part of the audit trail for data lineage and compliance.',
    `line_sequence_number` STRING COMMENT 'Sequential ordering number of this line within the parent rate card. Used for display and processing order.',
    `line_status` STRING COMMENT 'Current lifecycle status of this rate card line. Values: draft (under negotiation), active (in effect and billable), suspended (temporarily inactive), expired (validity period ended), superseded (replaced by newer version), cancelled (terminated before expiry).. Valid values are `draft|active|suspended|expired|superseded|cancelled`',
    `maximum_quantity` DECIMAL(18,2) COMMENT 'The maximum quantity threshold for this rate to apply. Used for tiered pricing structures where different rates apply to different volume bands. Null if no maximum applies.',
    `minimum_quantity` DECIMAL(18,2) COMMENT 'The minimum quantity threshold for this rate to apply. Used for minimum charge enforcement or tiered pricing structures. Null if no minimum applies.',
    `notes` STRING COMMENT 'Free-form text field for additional notes, comments, or special instructions related to this rate card line. Used for business context that does not fit structured fields.',
    `override_reason_code` STRING COMMENT 'Code indicating the reason for any manual override or exception to standard pricing rules for this line. Examples include VOLUME_DISCOUNT, STRATEGIC_CUSTOMER, PROMOTIONAL, SERVICE_RECOVERY, COMPETITIVE_MATCH. Null if no override applies.. Valid values are `^[A-Z0-9_]{2,20}$`',
    `override_reason_description` STRING COMMENT 'Detailed textual explanation of the reason for any pricing override or exception applied to this rate card line. Provides audit trail and business justification.',
    `penalty_rate` DECIMAL(18,2) COMMENT 'The penalty rate per unit applied when service levels are not met or when charges such as demurrage or detention are incurred. Null if no penalty applies to this line.',
    `service_category` STRING COMMENT 'High-level category of the port service covered by this rate card line. Values include handling (cargo/container handling), storage (yard/warehouse storage), pilotage (marine pilotage), towage (tug services), mooring (mooring services), security (ISPS security services), documentation (customs/trade documentation), inspection (cargo inspection), other (miscellaneous services). [ENUM-REF-CANDIDATE: handling|storage|pilotage|towage|mooring|security|documentation|inspection|other — 9 candidates stripped; promote to reference product]',
    `service_description` STRING COMMENT 'Detailed textual description of the service or charge covered by this rate card line. Provides business context for the tariff item.',
    `sla_target_hours` DECIMAL(18,2) COMMENT 'The target service delivery time in hours associated with this rate card line, if the pricing is linked to a Service Level Agreement (SLA). Used for SLA-linked service rate cards. Null if no SLA applies.',
    `surcharge_applicable_flag` BOOLEAN COMMENT 'Indicates whether additional surcharges (such as BAF, CAF, or other adjustment factors) are applicable to this rate card line. True if surcharges apply, False otherwise.',
    `tax_applicable_flag` BOOLEAN COMMENT 'Indicates whether taxes (such as VAT, GST, or other local taxes) are applicable to this rate card line. True if taxes apply, False otherwise.',
    `tax_rate_percentage` DECIMAL(18,2) COMMENT 'The tax rate percentage applicable to this rate card line, if taxes apply. Null if no tax applies or tax is calculated externally.',
    `terminal_code` STRING COMMENT 'Code identifying the specific terminal or berth where this rate applies. Used when pricing varies by terminal location within the port. Null if rate applies port-wide.. Valid values are `^[A-Z0-9]{2,10}$`',
    `tier_threshold_lower` DECIMAL(18,2) COMMENT 'Lower bound of the quantity tier for tiered pricing. When quantity falls within this tier, the specified unit rate applies. Null for flat-rate pricing.',
    `tier_threshold_upper` DECIMAL(18,2) COMMENT 'Upper bound of the quantity tier for tiered pricing. When quantity falls within this tier, the specified unit rate applies. Null for flat-rate pricing or open-ended top tier.',
    `unit_of_measure` STRING COMMENT 'The unit of measure for which the unit rate applies. Common values include TEU (Twenty-foot Equivalent Unit), FEU (Forty-foot Equivalent Unit), TON (metric ton or deadweight tonnage), CBM (Cubic Meter), MOVE (container move), HOUR (hourly rate), DAY (daily rate), CALL (per vessel call), UNIT (per equipment unit), CONTAINER (per container), SHIPMENT (per shipment). [ENUM-REF-CANDIDATE: TEU|FEU|TON|CBM|MOVE|HOUR|DAY|CALL|UNIT|CONTAINER|SHIPMENT — 11 candidates stripped; promote to reference product]',
    `unit_rate` DECIMAL(18,2) COMMENT 'The negotiated rate per unit of measure for this tariff item. Represents the base price before any quantity-based discounts or surcharges.',
    `vessel_size_category` STRING COMMENT 'Vessel size category to which this rate applies, used for vessel-related charges such as pilotage, towage, or berth fees. Values include feeder (small feeder vessels), panamax (Panamax class), post_panamax (Post-Panamax), new_panamax (New Panamax), ultra_large (Ultra Large Container Vessels), all (applies to all vessel sizes). Null if not vessel-specific.. Valid values are `feeder|panamax|post_panamax|new_panamax|ultra_large|all`',
    CONSTRAINT pk_rate_card_line PRIMARY KEY(`rate_card_line_id`)
) COMMENT 'Individual pricing line within a rate card, specifying the negotiated rate for a specific tariff item, service, or charge code. Captures the unit rate, unit of measure, minimum quantity, maximum quantity, tiered pricing thresholds, surcharge applicability (BAF, CAF), and override reason. Enables granular rate management at the charge-code level within a commercial rate card.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` (
    `thc_schedule_id` BIGINT COMMENT 'Unique identifier for the THC schedule record. Primary key.',
    `port_tariff_id` BIGINT COMMENT 'add column port_tariff_id (BIGINT) with FK to tariff.port_tariff.port_tariff_id - THC schedules are governed by the overarching port tariff',
    `supersedes_schedule_thc_schedule_id` BIGINT COMMENT 'Reference to the previous THC schedule ID that this schedule replaces or supersedes. Null if this is the initial version.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: THC (Terminal Handling Charges) vary by terminal zone. Currently thc_schedule has terminal_zone as a string code. Adding FK to infrastructure.terminal_zone provides referential integrity and enables j',
    `approval_status` STRING COMMENT 'Current approval status of the THC schedule in the tariff management workflow. Only approved schedules are active for billing.. Valid values are `draft|pending_approval|approved|rejected|suspended|archived`',
    `approved_by` STRING COMMENT 'Username or identifier of the tariff manager or authorized person who approved this schedule.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this THC schedule was approved. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `base_rate_amount` DECIMAL(18,2) COMMENT 'Base THC rate amount per container or TEU before any adjustments, surcharges, or discounts. Expressed in the schedule currency.',
    `cargo_category` STRING COMMENT 'Category of cargo handled. FCL (Full Container Load), LCL (Less than Container Load), RoRo (Roll-on Roll-off), LoLo (Lift-on Lift-off), breakbulk, or bulk cargo.. Valid values are `fcl|lcl|roro|lolo|breakbulk|bulk`',
    `container_size_teu` DECIMAL(18,2) COMMENT 'Container size expressed in TEU for standardized capacity and billing calculations. 20ft = 1.0 TEU, 40ft = 2.0 TEU, 45ft = 2.25 TEU.',
    `container_type` STRING COMMENT 'Type of container to which this THC rate applies. Includes standard dry containers (20ft, 40ft), high cube (HC), reefer (RF), and specialized types (open top, flat rack, out-of-gauge).. Valid values are `20ft|40ft|40ft_hc|45ft_hc|reefer|open_top`',
    `contract_reference` STRING COMMENT 'Reference to specific customer contract or service agreement if this THC schedule is contract-specific. Null for published general tariff rates.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this THC schedule record was first created in the system. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the THC rate (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `customer_segment` STRING COMMENT 'Target customer segment for this THC rate (e.g., shipping lines, freight forwarders, direct shippers, government). May be null for general applicability.',
    `dangerous_goods_surcharge` DECIMAL(18,2) COMMENT 'Additional surcharge amount applied for handling dangerous goods (IMDG classified cargo). Zero if not applicable.',
    `discount_eligible_flag` BOOLEAN COMMENT 'Indicates whether this THC rate is eligible for volume discounts or promotional pricing. True if eligible, False otherwise.',
    `effective_from_date` DATE COMMENT 'Date from which this THC schedule becomes effective and applicable to billing operations. Format: yyyy-MM-dd.',
    `effective_to_date` DATE COMMENT 'Date until which this THC schedule remains effective. Null indicates open-ended validity. Format: yyyy-MM-dd.',
    `filing_date` DATE COMMENT 'Date when this THC schedule was filed with the regulatory authority. Format: yyyy-MM-dd.',
    `maximum_charge_amount` DECIMAL(18,2) COMMENT 'Maximum THC amount cap for this schedule. Null indicates no cap. Used for rate protection agreements.',
    `minimum_charge_amount` DECIMAL(18,2) COMMENT 'Minimum THC amount that will be charged regardless of calculated rate. Ensures cost recovery for low-volume transactions.',
    `modified_by` STRING COMMENT 'Username or identifier of the user who last modified this THC schedule record.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this THC schedule record was last modified. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `movement_type` STRING COMMENT 'Type of container movement through the terminal. Import (vessel to land), export (land to vessel), transshipment (vessel to vessel), coastal (domestic), or empty repositioning.. Valid values are `import|export|transshipment|coastal|empty_repositioning`',
    `notes` STRING COMMENT 'Free-text notes or special conditions associated with this THC schedule. May include handling instructions, exclusions, or clarifications.',
    `oversize_surcharge` DECIMAL(18,2) COMMENT 'Additional surcharge for handling out-of-gauge (OOG) or oversize containers that require special handling equipment or procedures. Zero if not applicable.',
    `peak_season_surcharge` DECIMAL(18,2) COMMENT 'Additional surcharge applied during peak shipping seasons or high-volume periods. Zero if not applicable.',
    `published_date` DATE COMMENT 'Date when this THC schedule was published to customers. Null if not yet published. Format: yyyy-MM-dd.',
    `published_flag` BOOLEAN COMMENT 'Indicates whether this THC schedule has been published to customers and external systems. True if published, False if internal-only.',
    `rate_unit` STRING COMMENT 'Unit of measure for the THC rate. Typically per container, per TEU (Twenty-foot Equivalent Unit), per FEU (Forty-foot Equivalent Unit), per move, or per metric ton.. Valid values are `per_container|per_teu|per_feu|per_move|per_ton`',
    `reefer_surcharge` DECIMAL(18,2) COMMENT 'Additional surcharge amount for handling refrigerated (reefer) containers requiring power and temperature monitoring. Zero if not applicable.',
    `regulatory_filing_reference` STRING COMMENT 'Reference number or identifier for the regulatory tariff filing with port authority or maritime regulatory body. Required for compliance and audit purposes.',
    `schedule_code` STRING COMMENT 'Business identifier for the THC schedule, used in billing systems and tariff publications. Format: THC-<alphanumeric>.. Valid values are `^THC-[A-Z0-9]{6,12}$`',
    `schedule_name` STRING COMMENT 'Descriptive name of the THC schedule for business users and reporting purposes.',
    `service_level` STRING COMMENT 'Service level tier associated with this THC rate. Different service levels may have different handling priorities and rates.. Valid values are `standard|express|priority|economy`',
    `trade_lane` STRING COMMENT 'Specific trade lane or shipping route to which this THC rate applies (e.g., Asia-Europe, Transpacific, Transatlantic). May be null for general applicability.',
    `version_number` STRING COMMENT 'Version number of this THC schedule. Incremented with each amendment or revision to maintain change history.',
    `created_by` STRING COMMENT 'Username or identifier of the user who created this THC schedule record.',
    CONSTRAINT pk_thc_schedule PRIMARY KEY(`thc_schedule_id`)
) COMMENT 'Terminal Handling Charge (THC) schedule defining the applicable THC rates by container type (20ft, 40ft, HC, RF, OOG), cargo category (FCL, LCL, RoRo, LoLo), movement type (import, export, transshipment, coastal), and terminal zone. Captures base THC rate per TEU/FEU, effective period, trade lane applicability, and regulatory filing reference. The SSOT for THC pricing used by the billing engine and TOS (NAVIS N4) charge calculation modules.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` (
    `wharfage_schedule_id` BIGINT COMMENT 'Unique identifier for the wharfage tariff schedule record. Primary key.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Wharfage charges are berth-specific. Currently wharfage_schedule has berth_zone as a string. Adding FK to infrastructure.berth enables proper berth-based pricing and joins to berth attributes (berth_t',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Wharfage charges are commodity-specific (cargo_type, commodity_description attributes). HS code classification drives rate determination, handling requirements, and regulatory compliance. Links denorm',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: Wharfage charges vary by commodity (HS code). Currently wharfage_schedule has hs_code_category as a string. Adding FK to compliance.hs_code enables proper commodity-based pricing and joins to HS code ',
    `superseded_by_schedule_wharfage_schedule_id` BIGINT COMMENT 'Reference to the wharfage_schedule_id that supersedes this tariff entry. Populated when a new version replaces this schedule.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Wharfage charges apply to cargo handled through specific terminal zones. Complements existing berth FK by adding cargo handling location. Required for zone-specific wharfage billing in cargo operation',
    `approval_authority` STRING COMMENT 'Name of the regulatory body, port authority, or internal governance entity that approved this wharfage tariff schedule.',
    `approval_date` DATE COMMENT 'Date on which this wharfage tariff schedule was officially approved by the relevant authority.',
    `approval_reference_number` STRING COMMENT 'Official reference number or document identifier from the approval authority for this wharfage tariff schedule. Used for regulatory compliance and audit trails.',
    `baf_applicable_flag` BOOLEAN COMMENT 'Indicates whether Bunker Adjustment Factor surcharge is applicable to this wharfage rate to account for fuel cost fluctuations.',
    `caf_applicable_flag` BOOLEAN COMMENT 'Indicates whether Currency Adjustment Factor surcharge is applicable to this wharfage rate to account for exchange rate fluctuations.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this wharfage tariff schedule record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the wharfage rate (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `dangerous_goods_flag` BOOLEAN COMMENT 'Indicates whether this wharfage rate applies to dangerous goods cargo classified under IMDG (International Maritime Dangerous Goods) Code. May attract surcharges.',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Percentage discount applied to the base wharfage rate for qualifying cargo or customers (e.g., volume discounts, loyalty discounts, promotional rates).',
    `effective_from_date` DATE COMMENT 'Date from which this wharfage tariff schedule entry becomes active and applicable for billing.',
    `effective_to_date` DATE COMMENT 'Date until which this wharfage tariff schedule entry remains active. Null indicates open-ended validity.',
    `exemption_condition` STRING COMMENT 'Description of conditions under which wharfage charges are exempted (e.g., transshipment cargo not leaving port, government cargo, humanitarian aid, military cargo). Populated only when exemption_flag is True.',
    `exemption_flag` BOOLEAN COMMENT 'Indicates whether this tariff entry represents an exemption condition (True) or a standard chargeable rate (False).',
    `imdg_class` STRING COMMENT 'IMDG classification for dangerous goods to which this wharfage rate applies (e.g., Class 1 Explosives, Class 3 Flammable Liquids). Populated only when dangerous_goods_flag is True.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this wharfage tariff schedule record was last updated in the system.',
    `minimum_charge` DECIMAL(18,2) COMMENT 'Minimum wharfage charge threshold per transaction or shipment. Applied when calculated charge falls below this amount.',
    `notes` STRING COMMENT 'Additional notes, conditions, or clarifications regarding the application of this wharfage tariff schedule. May include special instructions for billing or exceptions.',
    `oversized_cargo_flag` BOOLEAN COMMENT 'Indicates whether this wharfage rate applies to oversized or out-of-gauge cargo exceeding standard dimensions.',
    `publication_date` DATE COMMENT 'Date on which this wharfage tariff schedule was published and made available to port users and stakeholders.',
    `rate_per_unit` DECIMAL(18,2) COMMENT 'Wharfage charge rate per unit of measure. Base rate before any adjustments, surcharges, or discounts.',
    `refrigerated_cargo_flag` BOOLEAN COMMENT 'Indicates whether this wharfage rate applies to refrigerated (reefer) cargo requiring temperature-controlled handling.',
    `sla_service_level` STRING COMMENT 'Service level tier associated with this wharfage rate. Different service levels may have different rates based on guaranteed turnaround times and priority handling.. Valid values are `standard|express|premium`',
    `surcharge_percentage` DECIMAL(18,2) COMMENT 'Percentage surcharge applied to the base wharfage rate for special handling requirements (e.g., dangerous goods, oversized cargo, peak season).',
    `tariff_code` STRING COMMENT 'Unique business identifier for the wharfage tariff schedule entry. Used for external reference and billing system integration.. Valid values are `^WHR-[A-Z0-9]{6,12}$`',
    `tariff_name` STRING COMMENT 'Human-readable name of the wharfage tariff schedule entry describing the cargo category and applicable conditions.',
    `tariff_status` STRING COMMENT 'Current lifecycle status of the wharfage tariff schedule entry. Only active tariffs are used for billing calculations.. Valid values are `draft|pending_approval|active|suspended|superseded|expired`',
    `tariff_version` STRING COMMENT 'Version number of the wharfage tariff schedule. Incremented with each revision to maintain historical tracking and audit trail.. Valid values are `^[0-9]{1,3}.[0-9]{1,3}$`',
    `trade_direction` STRING COMMENT 'Direction of cargo movement to which this wharfage rate applies. Import (inbound international), export (outbound international), coastal (domestic), or transshipment (in-transit).. Valid values are `import|export|coastal|transshipment`',
    `unit_of_measure` STRING COMMENT 'Unit of measure for wharfage charge calculation. TEU (Twenty-foot Equivalent Unit), FEU (Forty-foot Equivalent Unit), tonne (metric ton), CBM (Cubic Meter), unit (per item), or revenue tonne (whichever is greater between weight and volume).. Valid values are `tonne|cbm|teu|feu|unit|revenue_tonne`',
    `vessel_type` STRING COMMENT 'Type of vessel to which this wharfage rate applies. Different vessel types may attract different wharfage rates based on port policy. [ENUM-REF-CANDIDATE: container_vessel|bulk_carrier|tanker|roro_vessel|general_cargo|cruise_ship|feeder_vessel — 7 candidates stripped; promote to reference product]',
    `volume_break_lower_limit` DECIMAL(18,2) COMMENT 'Lower volume threshold (in CBM - Cubic Meters) for tiered wharfage pricing. Cargo volume at or above this limit qualifies for this rate tier.',
    `volume_break_upper_limit` DECIMAL(18,2) COMMENT 'Upper volume threshold (in CBM - Cubic Meters) for tiered wharfage pricing. Cargo volume below this limit qualifies for this rate tier. Null indicates no upper limit.',
    `weight_break_lower_limit` DECIMAL(18,2) COMMENT 'Lower weight threshold (in tonnes) for tiered wharfage pricing. Cargo weight at or above this limit qualifies for this rate tier.',
    `weight_break_upper_limit` DECIMAL(18,2) COMMENT 'Upper weight threshold (in tonnes) for tiered wharfage pricing. Cargo weight below this limit qualifies for this rate tier. Null indicates no upper limit.',
    CONSTRAINT pk_wharfage_schedule PRIMARY KEY(`wharfage_schedule_id`)
) COMMENT 'Wharfage (WHR) tariff schedule defining port dues levied on cargo passing over the wharf. Captures wharfage rates by cargo type, HS Code category, unit of measure (tonne, CBM, TEU), vessel type, trade direction (import/export/coastal), and berth zone. Includes minimum wharfage thresholds, exemption conditions (e.g., transshipment cargo), and regulatory approval references. Feeds directly into the billing domain for WHR charge generation.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` (
    `pilotage_tariff_id` BIGINT COMMENT 'Unique identifier for the pilotage tariff record. Primary key.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Pilotage charges depend on destination berth characteristics (draft, LOA capacity, tidal constraints). Commercial pilotage tariffs reference specific berths for rate determination. Required for berth-',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Pilotage tariffs vary by channel depth, width, and navigational complexity. Port tariff schedules routinely specify channel-specific pilotage rates for billing and regulatory compliance. Essential for',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Pilotage services are location-specific (port_zone attribute). Different zones within port have different pilotage requirements, distances, and rates. Links to port location master for zone-based tari',
    `superseded_by_tariff_pilotage_tariff_id` BIGINT COMMENT 'Reference to the pilotage_tariff_id that replaces this tariff when status is superseded. Creates a chain of tariff versions for historical tracking. Nullable if tariff is current or not superseded.',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Pilotage tariffs vary by vessel type (container, tanker, bulk, etc.). Currently pilotage_tariff has vessel_type_restriction as a string. Adding FK to masterdata.vessel_type enables proper type-based p',
    `approved_by` STRING COMMENT 'Name or identifier of the port authority official or commercial manager who approved this tariff for publication. Audit field for governance and accountability. Nullable if approval workflow not required.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when this tariff was officially approved for use. Distinct from created_timestamp as tariffs may be drafted before approval. Nullable if approval workflow not required.',
    `base_pilotage_fee` DECIMAL(18,2) COMMENT 'Base charge amount for the pilotage service before any surcharges or adjustments. Represents the standard fee for the defined vessel size band, zone, and time category. Currency is defined at port level (typically USD or local currency).',
    `billing_frequency` STRING COMMENT 'Frequency at which pilotage charges under this tariff are invoiced. Per_service means immediate billing after each pilotage, monthly and quarterly indicate consolidated billing periods for high-volume customers.. Valid values are `per_service|monthly|quarterly`',
    `cancellation_fee` DECIMAL(18,2) COMMENT 'Fixed charge applied when a confirmed pilotage service is cancelled by the vessel within the cancellation notice period. Compensates for pilot mobilization costs. Nullable if no cancellation charges apply.',
    `cancellation_notice_hours` STRING COMMENT 'Minimum number of hours advance notice required to cancel a pilotage booking without incurring cancellation fees. Cancellations within this window trigger the cancellation_fee.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this pilotage tariff record was first created in the system. Audit field for record lifecycle tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this tariff (e.g., USD, EUR, GBP). All fees and charges are denominated in this currency.. Valid values are `^[A-Z]{3}$`',
    `dangerous_goods_surcharge` DECIMAL(18,2) COMMENT 'Additional charge applied when piloting vessels carrying dangerous goods or hazardous materials as classified under IMDG Code. Reflects additional risk and certification requirements. Nullable if no dangerous goods surcharges apply.',
    `discount_eligible_flag` BOOLEAN COMMENT 'Indicates whether this tariff is eligible for volume discounts, loyalty discounts, or contractual rate reductions. True if discounts can be applied, false if this is a fixed non-discountable rate.',
    `distance_based_flag` BOOLEAN COMMENT 'Indicates whether this tariff includes distance-based pricing components. True if charges vary by nautical miles traveled, false if charges are fixed per service regardless of distance.',
    `dwt_band_max_tons` DECIMAL(18,2) COMMENT 'Maximum Deadweight Tonnage (DWT) in tons for which this tariff applies. Nullable for open-ended upper bands. Defines the upper boundary of the deadweight segment.',
    `dwt_band_min_tons` DECIMAL(18,2) COMMENT 'Minimum Deadweight Tonnage (DWT) in tons for which this tariff applies. DWT is the measure of how much weight a vessel can safely carry (cargo, fuel, crew, provisions). Used for cargo vessel tariff segmentation.',
    `effective_from_date` DATE COMMENT 'Date from which this pilotage tariff becomes valid and applicable for billing. Tariff cannot be applied to services before this date.',
    `effective_to_date` DATE COMMENT 'Date until which this pilotage tariff remains valid. Nullable for open-ended tariffs. After this date, the tariff is no longer applicable for new services.',
    `extraordinary_conditions_surcharge` DECIMAL(18,2) COMMENT 'Additional charge applied for pilotage under extraordinary conditions such as severe weather, restricted visibility, emergency situations, or vessels with special handling requirements. Nullable if no extraordinary surcharges apply.',
    `grt_band_max_tons` DECIMAL(18,2) COMMENT 'Maximum Gross Registered Tonnage (GRT) in tons for which this tariff applies. Nullable for open-ended upper bands. Defines the upper boundary of the tonnage segment.',
    `grt_band_min_tons` DECIMAL(18,2) COMMENT 'Minimum Gross Registered Tonnage (GRT) in tons for which this tariff applies. GRT is a measure of the overall internal volume of a vessel. Used as an alternative or complementary vessel size metric for tariff segmentation.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this pilotage tariff record was last updated. Audit field for change tracking and data lineage.',
    `loa_band_max_meters` DECIMAL(18,2) COMMENT 'Maximum vessel Length Overall (LOA) in meters for which this tariff applies. Nullable for open-ended upper bands (e.g., over 300m). Defines the upper boundary of the vessel size segment.',
    `loa_band_min_meters` DECIMAL(18,2) COMMENT 'Minimum vessel Length Overall (LOA) in meters for which this tariff applies. LOA is the maximum length of a vessels hull measured parallel to the waterline. Used to segment tariffs by vessel size.',
    `maximum_charge` DECIMAL(18,2) COMMENT 'Maximum total charge for the pilotage service regardless of calculated fees. Ensures a ceiling price for the service. Nullable if no maximum applies.',
    `minimum_charge` DECIMAL(18,2) COMMENT 'Minimum total charge for the pilotage service regardless of calculated fees. Ensures a floor price for the service. Nullable if no minimum applies.',
    `notes` STRING COMMENT 'Free-text field for additional tariff conditions, special instructions, exemptions, or clarifications that do not fit structured fields. Used for communicating tariff nuances to billing and operations teams.',
    `pilotage_tariff_status` STRING COMMENT 'Current lifecycle status of the pilotage tariff. Active tariffs are in use, inactive are retired, suspended are temporarily not applicable, pending_approval awaits regulatory approval, superseded have been replaced by newer versions.. Valid values are `active|inactive|suspended|pending_approval|superseded`',
    `pilotage_type` STRING COMMENT 'Classification of pilotage service type. Harbour pilotage covers port entry/exit, coastal pilotage covers coastal navigation, river pilotage covers inland waterways, shifting covers vessel movements between berths within the port.. Valid values are `harbour|coastal|river|shifting|berthing|unberthing`',
    `rate_per_nautical_mile` DECIMAL(18,2) COMMENT 'Charge per nautical mile for distance-based pilotage tariffs. Applied in addition to or instead of base_pilotage_fee depending on tariff structure. Nullable if distance_based_flag is false.',
    `regulatory_approval_reference` STRING COMMENT 'Reference number or identifier of the regulatory approval or port authority authorization for this tariff. Links to official tariff approval documentation. Nullable if no formal approval reference exists.',
    `service_category` STRING COMMENT 'Indicates whether the pilotage service is compulsory (mandated by port authority), voluntary (optional for vessel), or extraordinary (special circumstances requiring additional pilot expertise).. Valid values are `compulsory|voluntary|extraordinary`',
    `sla_response_time_minutes` STRING COMMENT 'Committed maximum response time in minutes from pilotage request to pilot boarding, as defined in the service level agreement. Used for performance monitoring and SLA compliance tracking. Nullable if no SLA applies.',
    `tariff_code` STRING COMMENT 'Unique business identifier for the pilotage tariff, used in billing systems and rate cards. Externally visible code for referencing this tariff in commercial documents.. Valid values are `^[A-Z0-9]{6,12}$`',
    `tariff_name` STRING COMMENT 'Human-readable name of the pilotage tariff, describing the service and applicable conditions (e.g., Harbour Pilotage - Day Rate - LOA 150-200m).',
    `tariff_version` STRING COMMENT 'Version number of this tariff definition, following semantic versioning (e.g., 1.0, 2.1). Incremented when tariff rates or conditions are updated. Enables tariff change tracking and audit trail.. Valid values are `^[0-9]{1,3}.[0-9]{1,3}$`',
    `tax_applicable_flag` BOOLEAN COMMENT 'Indicates whether taxes (VAT, GST, or other applicable taxes) should be applied to charges under this tariff. True if taxable, false if tax-exempt. Tax rates are defined separately in tax configuration.',
    `time_of_day_category` STRING COMMENT 'Time period classification for differential pricing. Day rates apply during standard business hours, night rates apply outside business hours, weekend and public holiday rates apply on non-working days. Reflects premium charges for off-hours pilotage services.. Valid values are `day|night|weekend|public_holiday`',
    `waiting_time_surcharge_per_hour` DECIMAL(18,2) COMMENT 'Additional charge per hour when pilot is required to wait beyond the scheduled boarding time due to vessel delays. Applied when vessel is not ready for pilotage at the agreed time. Nullable if no waiting time charges apply.',
    CONSTRAINT pk_pilotage_tariff PRIMARY KEY(`pilotage_tariff_id`)
) COMMENT 'Pilotage fee tariff defining charges for compulsory and voluntary pilotage services. Rates are structured by vessel LOA band, GRT band, DWT band, port zone (inbound, outbound, shifting), time of day (day/night/weekend), and pilotage type (harbour, coastal, river). Captures base pilotage fee, waiting time surcharge, cancellation fee, and extraordinary pilotage conditions. Aligned with marine pilotage scheduling in the VTMS and marine domain.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` (
    `storage_tariff_id` BIGINT COMMENT 'Unique identifier for the storage tariff schedule record. Primary key.',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: Storage rates vary by commodity classification per HS code. Dangerous goods (IMDG class) and refrigerated cargo require special storage zones with premium rates. Real operational pricing.',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Storage rates differentiate by container size/type (container_size_type attribute). Links to ISO container specifications for accurate TEU calculation, yard space allocation, and standardized billing.',
    `superseded_by_tariff_storage_tariff_id` BIGINT COMMENT 'Reference to the storage tariff ID that replaces this tariff schedule, enabling version lineage tracking. Null if current version.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Container storage charges are zone-specific based on zone type, ground slot capacity, reefer availability, and hazmat approval. Direct operational link for storage billing. Replaces denormalized stora',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Warehouse storage tariffs depend on facility type, temperature control, bonded status, and floor load capacity. Natural link for cargo storage billing in CFS and bonded warehouse operations. Essential',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Storage tariffs vary by zone security classification (public yard vs. restricted customs zone vs. high-security dangerous goods area). Warehouse billing systems link tariff schedules to zones to deter',
    `approval_date` DATE COMMENT 'Date when this storage tariff schedule was officially approved by authorized commercial management.',
    `approved_by` STRING COMMENT 'Name or identifier of the authorized person who approved this storage tariff schedule.',
    `billing_frequency` STRING COMMENT 'Frequency at which storage charges are calculated and invoiced. On_exit = charges billed when container leaves storage.. Valid values are `daily|weekly|monthly|on_exit`',
    `cargo_type` STRING COMMENT 'Classification of cargo type for tariff applicability. IMDG = International Maritime Dangerous Goods, RoRo = Roll-on Roll-off.. Valid values are `general|bulk|breakbulk|roro|project|imdg`',
    `container_status` STRING COMMENT 'Operational status of the container determining applicable storage rates. Import = inbound cargo awaiting pickup, Export = outbound cargo awaiting vessel loading, Transshipment = cargo in transit between vessels, Empty = empty container, Laden = loaded container.. Valid values are `import|export|transshipment|empty|laden`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this storage tariff record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which storage rates are denominated (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `customer_tier` STRING COMMENT 'Customer service tier classification determining preferential rates and free storage periods. Premium = top-tier customers with volume commitments, Standard = regular contract customers, Basic = occasional customers, Spot = one-time transactions.. Valid values are `premium|standard|basic|spot`',
    `demurrage_conversion_day` STRING COMMENT 'Day number at which storage charges convert to demurrage charges, if demurrage linkage is enabled. Null if no conversion applies.',
    `demurrage_linkage_flag` BOOLEAN COMMENT 'Indicates whether this storage tariff is linked to demurrage charges. True = storage charges convert to or trigger demurrage after specified period, False = standalone storage charges only.',
    `effective_from_date` DATE COMMENT 'Date from which this storage tariff schedule becomes applicable for billing purposes.',
    `effective_to_date` DATE COMMENT 'Date until which this storage tariff schedule remains applicable. Null indicates open-ended validity.',
    `free_storage_days` STRING COMMENT 'Number of calendar days of free storage allowed before storage charges commence. Varies by container status, customer tier, and cargo type.',
    `grace_period_hours` STRING COMMENT 'Number of hours grace period allowed before the first storage day is counted, accommodating operational delays in cargo pickup.',
    `imdg_class` STRING COMMENT 'IMDG hazard classification code for dangerous goods requiring special storage handling and premium rates (e.g., Class 1 Explosives, Class 3 Flammable Liquids).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this storage tariff record was last updated in the system.',
    `maximum_charge_amount` DECIMAL(18,2) COMMENT 'Maximum storage charge cap amount that can be billed, protecting customers from excessive charges during extended storage periods.',
    `minimum_charge_amount` DECIMAL(18,2) COMMENT 'Minimum storage charge amount that will be billed regardless of calculated daily rate, ensuring cost recovery for administrative overhead.',
    `notes` STRING COMMENT 'Additional notes, special conditions, or exceptions applicable to this storage tariff schedule.',
    `public_holiday_charge_flag` BOOLEAN COMMENT 'Indicates whether storage charges apply on public holidays. True = holidays are chargeable days, False = holidays excluded from storage day count.',
    `rate_band_1_daily_rate` DECIMAL(18,2) COMMENT 'Daily storage charge amount for rate band 1, expressed in the tariff currency.',
    `rate_band_1_end_day` STRING COMMENT 'Ending day number (inclusive) for the first storage rate band.',
    `rate_band_1_start_day` STRING COMMENT 'Starting day number (inclusive) for the first storage rate band, typically immediately after free storage period expires.',
    `rate_band_2_daily_rate` DECIMAL(18,2) COMMENT 'Daily storage charge amount for rate band 2, typically higher than band 1 to incentivize cargo movement.',
    `rate_band_2_end_day` STRING COMMENT 'Ending day number (inclusive) for the second storage rate band. Null indicates open-ended band.',
    `rate_band_2_start_day` STRING COMMENT 'Starting day number (inclusive) for the second storage rate band, typically with escalated rates.',
    `rate_band_3_daily_rate` DECIMAL(18,2) COMMENT 'Daily storage charge amount for rate band 3, typically the highest rate for long-term storage.',
    `rate_band_3_end_day` STRING COMMENT 'Ending day number (inclusive) for the third storage rate band. Null indicates open-ended band.',
    `rate_band_3_start_day` STRING COMMENT 'Starting day number (inclusive) for the third storage rate band, for extended storage periods.',
    `rate_unit` STRING COMMENT 'Unit of measure for storage rate calculation. TEU = Twenty-foot Equivalent Unit, FEU = Forty-foot Equivalent Unit, CBM = Cubic Meter.. Valid values are `per_teu|per_feu|per_container|per_ton|per_cbm`',
    `tariff_code` STRING COMMENT 'Unique business identifier for the storage tariff schedule, used in billing and commercial documentation.. Valid values are `^[A-Z0-9]{6,12}$`',
    `tariff_description` STRING COMMENT 'Detailed description of the storage tariff terms, conditions, and applicability scope.',
    `tariff_name` STRING COMMENT 'Descriptive name of the storage tariff schedule for business reference and reporting.',
    `tariff_status` STRING COMMENT 'Current lifecycle status of the storage tariff schedule. Active = currently in use, Inactive = temporarily disabled, Pending = approved but not yet effective, Superseded = replaced by newer version, Archived = historical record only.. Valid values are `active|inactive|pending|superseded|archived`',
    `tariff_version` STRING COMMENT 'Version number of the storage tariff schedule for change tracking and audit purposes (e.g., 1.0, 2.1).. Valid values are `^[0-9]+.[0-9]+$`',
    `tax_applicable_flag` BOOLEAN COMMENT 'Indicates whether tax (VAT, GST, or other applicable sales tax) should be applied to storage charges. True = taxable, False = tax-exempt.',
    `weekend_charge_flag` BOOLEAN COMMENT 'Indicates whether storage charges apply on weekends. True = weekends are chargeable days, False = weekends excluded from storage day count.',
    CONSTRAINT pk_storage_tariff PRIMARY KEY(`storage_tariff_id`)
) COMMENT 'Container and cargo storage tariff schedule defining free storage periods and progressive daily storage rates. Captures free days by container status (import, export, transshipment, empty), container type (20ft, 40ft, HC, RF, OOG, IMO/IMDG), storage zone (CY, CFS, ICD), and customer tier. Defines escalating rate bands (e.g., days 1-5 free, days 6-10 rate band 1, days 11+ rate band 2), currency, and applicable demurrage linkage. Critical for yard revenue management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` (
    `demurrage_schedule_id` BIGINT COMMENT 'Unique identifier for the demurrage schedule record. Primary key.',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Demurrage charges apply to specific container equipment types (container_size_type attribute). Standardized container specifications required for accurate free-time calculation, rate tier application,',
    `port_tariff_id` BIGINT COMMENT 'add column port_tariff_id (BIGINT) with FK to tariff.port_tariff.port_tariff_id - demurrage schedules are part of the overall port tariff structure',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Demurrage free time and rates vary by terminal zone operational characteristics, congestion levels, and handling capacity. Zone-specific demurrage policies are standard practice for container terminal',
    `approval_date` DATE COMMENT 'Date on which this demurrage schedule was formally approved by the authorized commercial or executive authority.',
    `approved_by` STRING COMMENT 'Name or identifier of the person or role who approved this demurrage schedule for activation.',
    `calculation_method` STRING COMMENT 'Method used to calculate demurrage days: calendar days (all days including weekends and holidays), working days (excludes weekends), or business days (excludes weekends and public holidays).. Valid values are `calendar_days|working_days|business_days`',
    `cargo_type` STRING COMMENT 'Type of cargo to which this demurrage schedule applies. FCL = Full Container Load, LCL = Less than Container Load, RoRo = Roll-on Roll-off. ALL indicates schedule applies to all cargo types.. Valid values are `FCL|LCL|breakbulk|bulk|roro|ALL`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this demurrage schedule record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which demurrage rates are denominated (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `customer_tier` STRING COMMENT 'Customer service tier or segment to which this demurrage schedule applies, enabling differentiated free time and rates by customer relationship level.. Valid values are `platinum|gold|silver|bronze|standard`',
    `demurrage_schedule_status` STRING COMMENT 'Current lifecycle status of the demurrage schedule. Active schedules are applied to billing; draft schedules are under review; suspended schedules are temporarily inactive; expired schedules are past their validity period; archived schedules are retained for historical reference only.. Valid values are `draft|active|suspended|expired|archived`',
    `dispute_resolution_terms` STRING COMMENT 'Terms and conditions governing dispute resolution for demurrage charges under this schedule, including escalation procedures and arbitration clauses.',
    `effective_from_date` DATE COMMENT 'Date from which this demurrage schedule becomes applicable and enforceable for billing purposes.',
    `effective_to_date` DATE COMMENT 'Date until which this demurrage schedule remains valid. Nullable for open-ended schedules.',
    `free_time_days` STRING COMMENT 'Number of calendar days allowed before demurrage charges begin to accrue. This is the grace period during which no demurrage is charged.',
    `grace_period_hours` STRING COMMENT 'Additional grace period in hours beyond the free time days before demurrage calculation begins. Allows for intra-day flexibility.',
    `holiday_exclusion_flag` BOOLEAN COMMENT 'Indicates whether public holidays are excluded from demurrage day calculations. True = holidays excluded, False = holidays included.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this demurrage schedule record was last updated or modified.',
    `maximum_demurrage_cap` DECIMAL(18,2) COMMENT 'Maximum total demurrage amount that can be charged per unit under this schedule, regardless of overstay duration. Nullable if no cap applies.',
    `notes` STRING COMMENT 'Free-text notes providing additional context, special conditions, or exceptions applicable to this demurrage schedule.',
    `prorated_calculation_flag` BOOLEAN COMMENT 'Indicates whether partial days are prorated in demurrage calculations. True = partial days are prorated hourly, False = partial days are rounded up to full days.',
    `rate_tier_1_amount` DECIMAL(18,2) COMMENT 'Daily demurrage charge amount for the first rate tier, applied per unit (container, vessel, or cargo unit) per day.',
    `rate_tier_1_days` STRING COMMENT 'Number of days in the first demurrage rate tier after free time expires. Demurrage escalates through tiers to incentivize prompt cargo movement.',
    `rate_tier_2_amount` DECIMAL(18,2) COMMENT 'Daily demurrage charge amount for the second rate tier, typically higher than tier 1 to escalate pressure for cargo removal. Nullable if only one tier is defined.',
    `rate_tier_2_days` STRING COMMENT 'Number of days in the second demurrage rate tier. Nullable if only one tier is defined.',
    `rate_tier_3_amount` DECIMAL(18,2) COMMENT 'Daily demurrage charge amount for the third rate tier, typically the highest escalation level. Nullable if fewer than three tiers are defined.',
    `rate_tier_3_days` STRING COMMENT 'Number of days in the third demurrage rate tier. Nullable if fewer than three tiers are defined.',
    `schedule_code` STRING COMMENT 'Business identifier for the demurrage schedule, used in billing and tariff documentation. Externally visible code.. Valid values are `^[A-Z0-9]{6,20}$`',
    `schedule_name` STRING COMMENT 'Human-readable name of the demurrage schedule for business reference and reporting.',
    `schedule_type` STRING COMMENT 'Classification of demurrage schedule by asset type: container demurrage for TEU/FEU overstay, vessel demurrage for berth overstay, cargo demurrage for cargo dwell time, or equipment demurrage for terminal equipment.. Valid values are `container|vessel|cargo|equipment`',
    `sla_reference_code` STRING COMMENT 'Reference code linking this demurrage schedule to a specific Service Level Agreement (SLA) with a customer or customer segment. Nullable if not SLA-linked.',
    `tariff_publication_reference` STRING COMMENT 'Reference to the official tariff publication document or section where this demurrage schedule is published for regulatory and customer transparency.',
    `trade_lane` STRING COMMENT 'Specific trade route or geographic lane to which this demurrage schedule applies (e.g., Asia-Europe, Transpacific). Nullable if schedule applies globally.',
    `waiver_authority_level` STRING COMMENT 'Organizational authority level required to approve waivers or reductions of demurrage charges under this schedule.. Valid values are `terminal_manager|commercial_director|ceo|none`',
    `weekend_exclusion_flag` BOOLEAN COMMENT 'Indicates whether weekends are excluded from demurrage day calculations. True = weekends excluded, False = weekends included.',
    CONSTRAINT pk_demurrage_schedule PRIMARY KEY(`demurrage_schedule_id`)
) COMMENT 'Demurrage (DMG) charge schedule defining the daily rates applied when containers or vessels exceed the agreed free time or laytime at the terminal or berth. Captures demurrage rate per container type per day, free time allowance by trade lane and customer tier, escalation tiers, maximum demurrage cap, currency, and applicable dispute resolution rules. Distinct from detention (DET) which applies to equipment off-terminal. Feeds into billing domain for DMG invoice generation.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` (
    `detention_schedule_id` BIGINT COMMENT 'Unique identifier for the detention charge schedule record. Primary key.',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Detention schedules specify rates by container type and equipment category. ISO container master provides standardized specifications for detention calculation, equipment tracking, and billing. Essent',
    `superseded_by_schedule_detention_schedule_id` BIGINT COMMENT 'Reference to the detention schedule that replaces this one when status is superseded. Maintains lineage of schedule evolution.',
    `approval_status` STRING COMMENT 'Approval workflow status for the detention schedule. Schedules must be approved before activation.. Valid values are `pending|approved|rejected`',
    `approved_by` STRING COMMENT 'Username or identifier of the authorized person who approved this detention schedule for use.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the detention schedule was approved for activation.',
    `billing_frequency` STRING COMMENT 'Frequency at which detention charges are invoiced to customers. Daily accrual but may be billed in batches.. Valid values are `daily|weekly|monthly|per_occurrence`',
    `calculation_method` STRING COMMENT 'Method used to calculate detention days. Calendar days include weekends and holidays; working days exclude them.. Valid values are `calendar_days|working_days|business_days`',
    `cargo_type` STRING COMMENT 'Type of cargo for which detention rates apply. FCL (Full Container Load) and LCL (Less than Container Load) are primary categories.. Valid values are `FCL|LCL|breakbulk|RoRo|bulk|dangerous_goods`',
    `contract_reference` STRING COMMENT 'Reference to the commercial contract or SLA (Service Level Agreement) under which this detention schedule is defined.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this detention schedule record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which detention rates are denominated. Typically USD for international maritime operations.. Valid values are `^[A-Z]{3}$`',
    `customer_tier` STRING COMMENT 'Customer service tier or segment to which this detention schedule applies. Premium customers may receive preferential rates or extended free time.. Valid values are `premium|standard|occasional|spot`',
    `detention_schedule_status` STRING COMMENT 'Current lifecycle status of the detention schedule. Only active schedules are used in billing calculations.. Valid values are `draft|active|suspended|expired|superseded`',
    `effective_date` DATE COMMENT 'Date from which this detention schedule becomes active and applicable to new equipment releases.',
    `expiry_date` DATE COMMENT 'Date on which this detention schedule ceases to be applicable. Nullable for open-ended schedules.',
    `free_time_days` STRING COMMENT 'Number of calendar days the equipment may be retained outside the terminal gate without incurring detention charges. Free time begins when equipment exits the terminal.',
    `grace_period_hours` STRING COMMENT 'Additional grace period in hours before detention charges begin after free time expires. Provides operational flexibility.',
    `holiday_charge_applicable` BOOLEAN COMMENT 'Indicates whether detention charges apply on public holidays. Some schedules waive charges on recognized port holidays.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this detention schedule record was last updated or modified.',
    `maximum_detention_cap` DECIMAL(18,2) COMMENT 'Maximum total detention charge that can be assessed per container regardless of duration. Protects customers from unlimited liability in exceptional circumstances.',
    `notes` STRING COMMENT 'Free-text notes providing additional context, special conditions, or business rules applicable to this detention schedule.',
    `proration_rule` STRING COMMENT 'Rule for prorating detention charges for partial days. Determines whether partial days are charged at full rate, prorated hourly, or rounded.. Valid values are `full_day|hourly_proration|half_day_rounding`',
    `published_date` DATE COMMENT 'Date when this detention schedule was officially published and communicated to customers and stakeholders.',
    `rate_tier_1_amount` DECIMAL(18,2) COMMENT 'Daily detention charge amount for the first rate tier. Applied per container per day during tier 1 period.',
    `rate_tier_1_days` STRING COMMENT 'Number of days in the first detention rate tier after free time expires. Typically days 1-5 of chargeable detention.',
    `rate_tier_2_amount` DECIMAL(18,2) COMMENT 'Daily detention charge amount for the second rate tier. Typically higher than tier 1 to incentivize prompt equipment return.',
    `rate_tier_2_days` STRING COMMENT 'Number of days in the second detention rate tier. Typically days 6-10 of chargeable detention with escalated rates.',
    `rate_tier_3_amount` DECIMAL(18,2) COMMENT 'Daily detention charge amount for the third and subsequent rate tiers. Highest rate to strongly incentivize equipment return.',
    `rate_tier_3_days` STRING COMMENT 'Number of days in the third detention rate tier. Typically days 11+ of chargeable detention with maximum escalation.',
    `schedule_code` STRING COMMENT 'Business identifier for the detention schedule, used in billing and tariff documentation. Externally-known unique code.. Valid values are `^DET-[A-Z0-9]{6,12}$`',
    `schedule_name` STRING COMMENT 'Human-readable name of the detention schedule for business reference and reporting.',
    `service_line` STRING COMMENT 'Shipping line or service route to which this detention schedule applies. Different carriers may have negotiated different rates.',
    `trade_direction` STRING COMMENT 'Direction of cargo movement to which this detention schedule applies. Rates may differ between import and export operations.. Valid values are `import|export|transshipment|empty_repositioning`',
    `version_number` STRING COMMENT 'Version number of this detention schedule. Incremented when schedule is revised to maintain audit trail of rate changes.',
    `waiver_eligible` BOOLEAN COMMENT 'Indicates whether detention charges under this schedule are eligible for waiver or dispute resolution processes.',
    `weekend_charge_applicable` BOOLEAN COMMENT 'Indicates whether detention charges apply on weekends. Some schedules waive charges on Saturdays and Sundays.',
    CONSTRAINT pk_detention_schedule PRIMARY KEY(`detention_schedule_id`)
) COMMENT 'Detention (DET) charge schedule defining daily rates applied when port equipment (containers, chassis) is retained by the customer beyond the agreed free period outside the terminal gate. Captures detention rate per container type per day, free time allowance, escalation tiers, maximum detention cap, applicable trade direction (import/export), and currency. Distinct from demurrage (DMG) which applies within the terminal. Managed in NAVIS N4 billing module.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` (
    `surcharge_rule_id` BIGINT COMMENT 'Unique identifier for the surcharge rule record. Primary key.',
    `port_tariff_id` BIGINT COMMENT 'add column port_tariff_id (BIGINT) with FK to tariff.port_tariff.port_tariff_id - surcharge rules modify base tariffs and must reference the applicable tariff',
    `superseded_by_rule_surcharge_rule_id` BIGINT COMMENT 'Reference to the surcharge_rule_id that supersedes this rule. Null if this is the current active version. Enables navigation through rule version history.',
    `applicability_conditions` STRING COMMENT 'Free-text description of specific conditions under which this surcharge applies (e.g., applies only during peak season months, applies when fuel price exceeds threshold, applies to vessels over 50,000 DWT). Captures business rules not covered by structured fields.',
    `approval_status` STRING COMMENT 'Current approval and lifecycle status of the surcharge rule: DRAFT (under development), PENDING_APPROVAL (submitted for review), APPROVED (approved but not yet effective), ACTIVE (currently in effect), SUSPENDED (temporarily inactive), EXPIRED (past effective_to_date), CANCELLED (permanently withdrawn). [ENUM-REF-CANDIDATE: DRAFT|PENDING_APPROVAL|APPROVED|ACTIVE|SUSPENDED|EXPIRED|CANCELLED — 7 candidates stripped; promote to reference product]',
    `approved_by` STRING COMMENT 'Name or identifier of the user or authority who approved this surcharge rule for publication. Null if not yet approved.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this surcharge rule was approved. Null if not yet approved. Supports audit trail and compliance verification.',
    `billing_frequency` STRING COMMENT 'Frequency at which this surcharge is billed: PER_TRANSACTION (charged on each applicable transaction), MONTHLY (aggregated and billed monthly), QUARTERLY, ANNUALLY. Defines billing cycle for the surcharge.. Valid values are `PER_TRANSACTION|MONTHLY|QUARTERLY|ANNUALLY`',
    `calculation_base` STRING COMMENT 'The base amount upon which percentage-based surcharges are calculated: FREIGHT (ocean freight charges), THC (Terminal Handling Charges), BASE_TARIFF (base port tariff), TOTAL_CHARGES (sum of all charges before surcharge), CARGO_VALUE (declared cargo value). Applicable when calculation_method is PERCENTAGE_OF_BASE.. Valid values are `FREIGHT|THC|BASE_TARIFF|TOTAL_CHARGES|CARGO_VALUE`',
    `calculation_method` STRING COMMENT 'Method used to calculate the surcharge amount: FLAT_FEE (fixed amount per transaction), PERCENTAGE_OF_BASE (percentage of base tariff or freight), PER_UNIT (amount per TEU/FEU/ton), TIERED (rate varies by volume bands), INDEX_LINKED (calculated from external index reference).. Valid values are `FLAT_FEE|PERCENTAGE_OF_BASE|PER_UNIT|TIERED|INDEX_LINKED`',
    `calculation_priority` STRING COMMENT 'Numeric priority order for applying this surcharge when multiple surcharges are applicable (lower numbers calculated first). Ensures consistent calculation sequence when compounding is allowed.',
    `cargo_type_applicability` STRING COMMENT 'Types of cargo to which this surcharge applies: FCL (Full Container Load), LCL (Less than Container Load), BREAKBULK, RORO (Roll-on Roll-off), DANGEROUS (IMDG), REEFER (Refrigerated), OOG (Out-of-Gauge), ALL. Defines cargo classification scope for the surcharge. [ENUM-REF-CANDIDATE: FCL|LCL|BREAKBULK|RORO|DANGEROUS|REEFER|OOG|ALL — 8 candidates stripped; promote to reference product]',
    `compounding_allowed` BOOLEAN COMMENT 'Indicates whether this surcharge can be compounded with other surcharges (true) or must be calculated independently on the base amount only (false). Affects multi-surcharge calculation order and logic.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this surcharge rule record was first created in the system. Part of audit trail.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the surcharge rate (e.g., USD, EUR, SGD). Applicable when rate_amount represents a monetary value.. Valid values are `^[A-Z]{3}$`',
    `currency_pair` STRING COMMENT 'Currency pair for CAF (Currency Adjustment Factor) surcharges in format BASE/QUOTE (e.g., USD/EUR, EUR/SGD). Indicates the exchange rate relationship used for currency adjustment calculations. Applicable only for CAF surcharge types.. Valid values are `^[A-Z]{3}/[A-Z]{3}$`',
    `effective_from_date` DATE COMMENT 'Start date from which this surcharge rule becomes active and applicable to transactions. Part of the time-series versioning for surcharge rules.',
    `effective_to_date` DATE COMMENT 'End date until which this surcharge rule remains active. Null indicates the rule is currently active with no defined end date. Part of the time-series versioning for surcharge rules.',
    `exemption_criteria` STRING COMMENT 'Conditions under which this surcharge may be waived or exempted (e.g., government vessels exempt, long-term contract customers exempt, vessels with cold ironing capability exempt from environmental surcharge).',
    `index_reference_name` STRING COMMENT 'Name of the external index or benchmark used for index-linked surcharges (e.g., Platts Singapore Fuel Oil 380, MOPS Singapore, Bloomberg Commodity Index). Used primarily for BAF calculations. Null if not index-linked.',
    `index_reference_url` STRING COMMENT 'URL or reference location for the external index source used in index-linked surcharge calculations. Enables audit trail and verification of index values.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this surcharge rule record was last modified. Updated on any change to the record. Part of audit trail.',
    `maximum_charge` DECIMAL(18,2) COMMENT 'Maximum surcharge amount that can be applied regardless of calculated value. Ensures a ceiling charge for the surcharge. Null if no maximum applies.',
    `minimum_charge` DECIMAL(18,2) COMMENT 'Minimum surcharge amount that must be applied regardless of calculated value. Ensures a floor charge for the surcharge. Null if no minimum applies.',
    `notes` STRING COMMENT 'Internal notes and comments about this surcharge rule for operational reference. Not published to customers. May include rationale for rate changes, special handling instructions, or historical context.',
    `notice_period_days` STRING COMMENT 'Number of days advance notice required before this surcharge becomes effective. Ensures compliance with contractual or regulatory notice requirements.',
    `proration_method` STRING COMMENT 'Method for prorating the surcharge when applicable period is partial: NONE (no proration, full charge applies), DAILY (prorated by days), MONTHLY (prorated by months), PROPORTIONAL (prorated by usage or volume). Applicable for time-based or usage-based surcharges.. Valid values are `NONE|DAILY|MONTHLY|PROPORTIONAL`',
    `publication_authority` STRING COMMENT 'Entity or regulatory body that published or mandated this surcharge (e.g., Port Authority, Shipping Line, Government Agency, Industry Association). Establishes the source of authority for the surcharge.',
    `published_date` DATE COMMENT 'Date when this surcharge rule was officially published and communicated to customers and stakeholders. May differ from effective_from_date to allow advance notice period.',
    `rate_amount` DECIMAL(18,2) COMMENT 'Numeric rate value for the surcharge. Interpretation depends on calculation_method: flat fee amount, percentage value (e.g., 5.5 for 5.5%), or per-unit rate. Null if index-linked calculation is used.',
    `rate_percentage` DECIMAL(18,2) COMMENT 'Percentage rate for surcharges calculated as percentage of base amount (e.g., 3.5000 represents 3.5%). Used when calculation_method is PERCENTAGE_OF_BASE. Null for non-percentage methods.',
    `regulatory_reference` STRING COMMENT 'Reference to the regulation, tariff schedule, or legal instrument that authorizes or mandates this surcharge (e.g., Port Tariff Schedule 2024, ISPS Code Amendment, Government Gazette No. 12345).',
    `rule_code` STRING COMMENT 'Business identifier code for the surcharge rule (e.g., BAF_2024_Q1, CAF_USD_EUR, ISPS_SECURITY). Used for external reference and integration with billing systems.. Valid values are `^[A-Z0-9_-]{3,20}$`',
    `service_type_applicability` STRING COMMENT 'Port services to which this surcharge applies (e.g., Wharfage, Pilotage, Towage, Storage, ALL). Pipe-separated list if multiple services apply. Null indicates applicability to all services.',
    `surcharge_name` STRING COMMENT 'Full descriptive name of the surcharge for display and reporting purposes (e.g., Bunker Adjustment Factor - Asia Pacific, Currency Adjustment Factor USD/EUR).',
    `surcharge_type` STRING COMMENT 'Discriminator identifying the category of surcharge: BAF (Bunker Adjustment Factor), CAF (Currency Adjustment Factor), PIL (Port Infrastructure Levy), ISPS (International Ship and Port Facility Security), PEAK_SEASON, IMDG (International Maritime Dangerous Goods), OOG (Out-of-Gauge), COLD_IRONING, THC_ADJUSTMENT (Terminal Handling Charge Adjustment), CONGESTION, REEFER (Refrigerated Container), SECURITY. [ENUM-REF-CANDIDATE: BAF|CAF|PIL|ISPS|PEAK_SEASON|IMDG|OOG|COLD_IRONING|THC_ADJUSTMENT|CONGESTION|REEFER|SECURITY — 12 candidates stripped; promote to reference product]',
    `trade_lane_scope` STRING COMMENT 'Geographic or trade lane scope to which this surcharge applies (e.g., Asia-Pacific, Trans-Pacific, Europe-Asia, Intra-Asia, ALL). Defines the routing or origin-destination pairs covered by this surcharge rule.',
    `unit_of_measure` STRING COMMENT 'Unit of measure for per-unit surcharges: TEU (Twenty-foot Equivalent Unit), FEU (Forty-foot Equivalent Unit), TON (metric ton), CBM (Cubic Meter), CONTAINER, VESSEL_CALL, TRANSACTION. Null for percentage-based or flat-fee surcharges. [ENUM-REF-CANDIDATE: TEU|FEU|TON|CBM|CONTAINER|VESSEL_CALL|TRANSACTION — 7 candidates stripped; promote to reference product]',
    `version_number` STRING COMMENT 'Version number of this surcharge rule. Incremented each time the rule is revised. Supports time-series versioning and historical reconstruction for billing disputes and audits.',
    `vessel_type_applicability` STRING COMMENT 'Types of vessels to which this surcharge applies (e.g., Container, Bulk Carrier, Tanker, RoRo, ALL). Pipe-separated list if multiple types apply. Null indicates applicability to all vessel types.',
    CONSTRAINT pk_surcharge_rule PRIMARY KEY(`surcharge_rule_id`)
) COMMENT 'Unified definition of all applicable surcharges and adjustment factors layered on top of base tariff rates, maintained as versioned time-series records. Covers BAF (Bunker Adjustment Factor) with fuel index references (Platts, MOPS, Singapore), calculation method (flat per TEU or percentage), and trade lane scope; CAF (Currency Adjustment Factor) with currency pair, percentage, and calculation base (percentage of freight or THC); PIL (Port Infrastructure Levy); ISPS security surcharge; peak season surcharge; hazardous cargo (IMDG) surcharge; OOG (out-of-gauge) surcharge; cold ironing surcharge; and any other periodic or conditional surcharge. Each record defines the surcharge type discriminator, calculation method (flat fee, percentage of base, per unit), rate amount or percentage, applicable index reference, effective period, trade lane scope, vessel type applicability, publication authority, and applicability conditions. New surcharge types are added as new rows — no schema changes required. Enables historical surcharge reconstruction for billing disputes and audit.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` (
    `discount_scheme_id` BIGINT COMMENT 'Unique identifier for the discount scheme. Primary key.',
    `port_tariff_id` BIGINT COMMENT 'add column port_tariff_id (BIGINT) with FK to tariff.port_tariff.port_tariff_id - discount schemes must reference which port tariff they apply against',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Discount schemes require designated owners with approval authority to evaluate customer requests, verify eligibility criteria, authorize exceptions, monitor scheme utilization, and conduct periodic re',
    `applicable_charge_codes` STRING COMMENT 'Comma-separated list of tariff charge codes to which this discount applies (e.g., THC, WHR, DMG, DET, PIL, BAF, CAF). Empty means applies to all charges.',
    `approval_authority` STRING COMMENT 'Name or role of the authority who approved this discount scheme (e.g., Commercial Director, CFO, Pricing Committee). Required for governance and audit trail.',
    `approval_date` DATE COMMENT 'Date on which this discount scheme was formally approved by the designated authority.',
    `approval_reference` STRING COMMENT 'Reference number or document identifier for the approval decision (e.g., board resolution number, approval memo reference).',
    `auto_apply_flag` BOOLEAN COMMENT 'Indicates whether this discount should be automatically applied when eligibility criteria are met (True) or requires manual application by billing staff (False).',
    `billing_system_code` STRING COMMENT 'Code used to identify this discount scheme in the billing system (e.g., NAVIS N4, SAP S/4HANA). Enables integration and automated discount application.',
    `cargo_type_restriction` STRING COMMENT 'Comma-separated list of cargo types to which this discount applies (e.g., containerized, breakbulk, roro, liquid_bulk, dry_bulk). Empty means no cargo type restriction.',
    `combinable_with_other_discounts` BOOLEAN COMMENT 'Indicates whether this discount can be combined with other discount schemes on the same transaction. True allows stacking, False requires exclusive application.',
    `contract_reference` STRING COMMENT 'Reference to the master service contract or commercial agreement under which this discount scheme is granted. Links discount to contractual obligations.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this discount scheme record was first created in the system. Used for audit trail and data lineage.',
    `customer_tier_eligibility` STRING COMMENT 'Customer tier classification that is eligible for this discount scheme. Defines which customer segments can access this pricing benefit. [ENUM-REF-CANDIDATE: all|tier_1|tier_2|tier_3|vip|strategic|standard — 7 candidates stripped; promote to reference product]',
    `customer_type_eligibility` STRING COMMENT 'Comma-separated list of customer types eligible for this discount (e.g., shipping_line, freight_forwarder, cargo_owner, nvocc). Empty means all customer types are eligible.',
    `discount_category` STRING COMMENT 'Business classification of the discount scheme: promotional campaign, contractual agreement, volume incentive, loyalty reward, seasonal offer, or strategic partnership discount.. Valid values are `promotional|contractual|volume|loyalty|seasonal|strategic`',
    `discount_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for flat rate discounts. Null for percentage or free days discount types.. Valid values are `^[A-Z]{3}$`',
    `discount_type` STRING COMMENT 'Classification of the discount mechanism: percentage reduction, flat rate deduction, free storage days, tiered pricing, volume-based rebate, or loyalty-based incentive.. Valid values are `percentage|flat_rate|free_days|tiered|volume_based|loyalty_based`',
    `discount_value` DECIMAL(18,2) COMMENT 'Numeric value of the discount. Interpretation depends on discount_type: percentage (e.g., 15.00 for 15%), flat rate (monetary amount), or number of free days.',
    `effective_from_date` DATE COMMENT 'Date from which this discount scheme becomes active and can be applied to qualifying transactions.',
    `effective_to_date` DATE COMMENT 'Date on which this discount scheme expires and is no longer applicable. Null indicates an open-ended scheme with no expiration.',
    `maximum_discount_cap` DECIMAL(18,2) COMMENT 'Maximum monetary value of discount that can be applied per transaction or period, regardless of calculated discount amount. Null means no cap applies.',
    `minimum_charge_threshold` DECIMAL(18,2) COMMENT 'Minimum charge amount below which the discount cannot be applied. Ensures discounts are only given on transactions above a certain value.',
    `modified_by` STRING COMMENT 'User ID or name of the person who last modified this discount scheme record. Maintains accountability for changes.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this discount scheme record was last modified. Tracks the most recent update for audit and change management purposes.',
    `notes` STRING COMMENT 'Free-text field for additional notes, special conditions, or business context related to this discount scheme.',
    `priority_rank` STRING COMMENT 'Numeric priority ranking for discount application when multiple schemes are eligible. Lower numbers indicate higher priority (1 = highest priority).',
    `promotional_campaign_code` STRING COMMENT 'Reference code linking this discount to a specific marketing or promotional campaign. Used for tracking campaign effectiveness and ROI.',
    `requires_customer_request` BOOLEAN COMMENT 'Indicates whether the customer must explicitly request this discount (True) or if it can be applied proactively by the port (False).',
    `retroactive_application_allowed` BOOLEAN COMMENT 'Indicates whether this discount can be applied retroactively to past transactions within the effective period (True) or only to future transactions (False).',
    `scheme_code` STRING COMMENT 'Unique business identifier code for the discount scheme, used for external reference and integration with billing systems.. Valid values are `^[A-Z0-9_-]{3,20}$`',
    `scheme_description` STRING COMMENT 'Detailed description of the discount scheme including its purpose, eligibility criteria, and business rationale.',
    `scheme_name` STRING COMMENT 'Full descriptive name of the discount scheme for business user identification and reporting purposes.',
    `scheme_status` STRING COMMENT 'Current lifecycle status of the discount scheme: draft (being designed), pending approval (awaiting authorization), active (in use), suspended (temporarily inactive), expired (past effective date), or cancelled (terminated before expiration).. Valid values are `draft|pending_approval|active|suspended|expired|cancelled`',
    `sla_linked_flag` BOOLEAN COMMENT 'Indicates whether this discount is tied to Service Level Agreement (SLA) performance metrics. True means discount is conditional on meeting service standards.',
    `sla_performance_metric` STRING COMMENT 'Description of the SLA performance metric that must be met for this discount to apply (e.g., vessel turnaround time < 24 hours, container dwell time < 5 days).',
    `terminal_restriction` STRING COMMENT 'Comma-separated list of terminal codes where this discount is valid. Empty means discount applies across all port terminals.',
    `threshold_period` STRING COMMENT 'Time period over which the threshold is measured and evaluated: per vessel call, monthly, quarterly, annually, or over the entire contract term.. Valid values are `per_call|monthly|quarterly|annually|contract_term`',
    `threshold_type` STRING COMMENT 'Type of qualifying threshold that must be met to earn the discount: TEU (Twenty-foot Equivalent Unit) volume, vessel call frequency, cargo tonnage, revenue value, container count, or none for unconditional discounts.. Valid values are `teu_volume|call_frequency|cargo_tonnage|revenue_value|container_count|none`',
    `threshold_unit` STRING COMMENT 'Unit of measure for the threshold value: TEU (Twenty-foot Equivalent Unit), FEU (Forty-foot Equivalent Unit), vessel calls, metric tonnes (MT), cubic meters (CBM), container count, or currency. [ENUM-REF-CANDIDATE: TEU|FEU|calls|tonnes|MT|CBM|containers|USD|EUR — 9 candidates stripped; promote to reference product]',
    `threshold_value` DECIMAL(18,2) COMMENT 'Numeric threshold value that must be met or exceeded to qualify for the discount. Interpretation depends on threshold_type (e.g., 1000 TEU, 12 calls, 50000 tonnes).',
    `vessel_type_restriction` STRING COMMENT 'Comma-separated list of vessel types eligible for this discount (e.g., container_ship, bulk_carrier, tanker, roro_vessel). Empty means no vessel type restriction.',
    `created_by` STRING COMMENT 'User ID or name of the person who created this discount scheme record. Required for governance and accountability.',
    CONSTRAINT pk_discount_scheme PRIMARY KEY(`discount_scheme_id`)
) COMMENT 'Commercial discount scheme defining volume-based, loyalty-based, or promotional discounts applicable to port service charges. Captures discount scheme name, discount type (percentage, flat rate, free days), applicable tariff items or charge codes, qualifying thresholds (TEU volume, call frequency, cargo tonnage), customer tier eligibility, effective period, and approval authority. Enables the port to offer competitive pricing to high-volume shipping lines and cargo owners.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` (
    `sla_rate_card_id` BIGINT COMMENT 'Unique identifier for the SLA rate card. Primary key.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: SLA-based rate cards with performance targets (vessel turnaround time, crane productivity, gate processing) require designated service managers to monitor KPIs, coordinate operational delivery, handle',
    `rate_card_id` BIGINT COMMENT 'Reference to the SLA rate card that supersedes this one. Nullable if this is the current version.',
    `applicable_customer_segment` STRING COMMENT 'Customer segment or classification to which this SLA rate card applies (e.g., Tier 1 Shipping Lines, Freight Forwarders, All Customers). Nullable if universally applicable.',
    `approved_by` STRING COMMENT 'Name or identifier of the authority who approved this SLA rate card for publication.',
    `approved_date` DATE COMMENT 'Date when this SLA rate card was officially approved for use.',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether this SLA rate card automatically renews at the end of its term (True/False).',
    `base_rate_amount` DECIMAL(18,2) COMMENT 'Base pricing amount for the service under this SLA tier, before premiums or penalties.',
    `berth_allocation_response_time_target_hours` DECIMAL(18,2) COMMENT 'Committed Key Performance Indicator (KPI) for berth allocation response time in hours from vessel pre-arrival notification.',
    `billing_frequency` STRING COMMENT 'Frequency at which charges under this SLA rate card are invoiced (Per Transaction, Weekly, Bi-Weekly, Monthly, Quarterly).. Valid values are `Per Transaction|Weekly|Bi-Weekly|Monthly|Quarterly`',
    `crane_productivity_target_moves_per_hour` DECIMAL(18,2) COMMENT 'Committed Key Performance Indicator (KPI) for Ship-to-Shore (STS) crane productivity measured in container moves per hour.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this SLA rate card record was first created in the system.',
    `discount_eligibility_flag` BOOLEAN COMMENT 'Indicates whether this SLA rate card is eligible for additional volume or loyalty discounts (True/False).',
    `dispute_resolution_process` STRING COMMENT 'Textual description of the process for resolving disputes related to SLA performance measurement or billing adjustments.',
    `effective_from_date` DATE COMMENT 'Date when this SLA rate card becomes effective and applicable for billing.',
    `effective_to_date` DATE COMMENT 'Date when this SLA rate card expires or is superseded. Nullable for open-ended rate cards.',
    `escalation_clause` STRING COMMENT 'Textual description of rate escalation terms, including triggers for rate adjustments (e.g., annual CPI adjustment, fuel surcharge clauses, Bunker Adjustment Factor (BAF), Currency Adjustment Factor (CAF)).',
    `escalation_frequency` STRING COMMENT 'Frequency at which rate escalation is applied (Monthly, Quarterly, Semi-Annual, Annual, None).. Valid values are `Monthly|Quarterly|Semi-Annual|Annual|None`',
    `escalation_index_type` STRING COMMENT 'Type of index used for automatic rate escalation (CPI, Fuel Index, Currency Exchange, Fixed Percentage, None).. Valid values are `CPI|Fuel Index|Currency Exchange|Fixed Percentage|None`',
    `force_majeure_clause` STRING COMMENT 'Textual description of force majeure conditions under which SLA performance obligations are suspended (e.g., natural disasters, labor strikes, port closures).',
    `gate_processing_time_target_minutes` DECIMAL(18,2) COMMENT 'Committed Key Performance Indicator (KPI) for truck gate processing time in minutes, from entry to exit.',
    `geographic_scope` STRING COMMENT 'Geographic scope or terminal location where this SLA rate card is applicable (e.g., All Terminals, Container Terminal A, Bulk Terminal B). Nullable if universally applicable.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this SLA rate card record was last modified.',
    `maximum_volume_cap` DECIMAL(18,2) COMMENT 'Maximum volume cap for this SLA rate card, beyond which different pricing applies. Nullable if no cap applies.',
    `measurement_period` STRING COMMENT 'Time period over which SLA performance is measured and evaluated (Per Transaction, Daily, Weekly, Monthly, Quarterly, Annual).. Valid values are `Per Transaction|Daily|Weekly|Monthly|Quarterly|Annual`',
    `minimum_volume_commitment` DECIMAL(18,2) COMMENT 'Minimum volume commitment required to qualify for this SLA rate card, measured in the rate unit of measure. Nullable if no minimum applies.',
    `notes` STRING COMMENT 'Additional notes, comments, or special instructions related to this SLA rate card.',
    `notice_period_days` STRING COMMENT 'Number of days advance notice required for termination or modification of this SLA rate card.',
    `payment_terms_days` STRING COMMENT 'Number of days allowed for payment after invoice date under this SLA rate card.',
    `penalty_percentage` DECIMAL(18,2) COMMENT 'Percentage penalty (discount) applied to base rate when SLA performance targets are not met. Nullable if no penalty applies.',
    `performance_reporting_frequency` STRING COMMENT 'Frequency at which SLA performance reports are provided to customers (Real-Time, Daily, Weekly, Monthly, Quarterly).. Valid values are `Real-Time|Daily|Weekly|Monthly|Quarterly`',
    `premium_percentage` DECIMAL(18,2) COMMENT 'Percentage premium applied to base rate when SLA performance targets are met or exceeded. Nullable if no premium applies.',
    `rate_card_code` STRING COMMENT 'Externally-known unique business identifier for the SLA rate card, used in contracts and billing systems.. Valid values are `^[A-Z0-9]{6,20}$`',
    `rate_card_name` STRING COMMENT 'Human-readable name of the SLA rate card (e.g., Gold Tier - Express Container Handling, Silver Tier - Standard Vessel Turnaround).',
    `rate_card_status` STRING COMMENT 'Current lifecycle status of the SLA rate card (Draft, Active, Suspended, Expired, Superseded).. Valid values are `Draft|Active|Suspended|Expired|Superseded`',
    `rate_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the rate amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `rate_unit_of_measure` STRING COMMENT 'Unit of measure for the rate pricing (Per TEU, Per FEU, Per Move, Per Hour, Per Vessel Call, Per Ton, Per CBM, Per Day). [ENUM-REF-CANDIDATE: Per TEU|Per FEU|Per Move|Per Hour|Per Vessel Call|Per Ton|Per CBM|Per Day — 8 candidates stripped; promote to reference product]',
    `service_category` STRING COMMENT 'Category of port service covered by this SLA rate card (Vessel Operations, Container Handling, Cargo Operations, Pilotage, Towage, Berth Services, Gate Operations, Yard Management). [ENUM-REF-CANDIDATE: Vessel Operations|Container Handling|Cargo Operations|Pilotage|Towage|Berth Services|Gate Operations|Yard Management — 8 candidates stripped; promote to reference product]',
    `service_exclusions` STRING COMMENT 'Textual description of services or scenarios explicitly excluded from this SLA rate card (e.g., Excludes dangerous goods handling, Excludes overtime charges).',
    `sla_tier` STRING COMMENT 'Classification tier of the SLA defining the service performance level (Gold, Silver, Bronze, Platinum, Standard, Premium).. Valid values are `Gold|Silver|Bronze|Platinum|Standard|Premium`',
    `version_number` STRING COMMENT 'Version number of this SLA rate card, following semantic versioning (e.g., 1.0, 2.1).. Valid values are `^[0-9]+.[0-9]+$`',
    `vessel_turnaround_time_target_hours` DECIMAL(18,2) COMMENT 'Committed Key Performance Indicator (KPI) for vessel turnaround time in hours, from Estimated Time of Berthing (ETB) to Actual Time of Departure (ATD).',
    CONSTRAINT pk_sla_rate_card PRIMARY KEY(`sla_rate_card_id`)
) COMMENT 'Service Level Agreement (SLA)-linked rate card defining pricing tied to guaranteed service performance metrics. Captures SLA tier (Gold, Silver, Bronze), committed KPIs (vessel turnaround time, crane productivity moves/hour, gate processing time), associated rate premiums or penalties, measurement period, and escalation clauses. Links commercial pricing to operational performance commitments, enabling SLA-based billing adjustments in the billing domain.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` (
    `exception_id` BIGINT COMMENT 'Unique identifier for the tariff exception record. Primary key.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Tariff exceptions are contractual deviations from standard tariffs granted under specific agreement terms. Exceptions require agreement context for approval authority, validity period, and commercial ',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Tariff exceptions often granted for specific berth limitations (draft restrictions, crane unavailability, shore power issues). Commercial negotiations reference berth capabilities for rate adjustments',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Tariff exceptions (discounts/waivers) impact cost centre profitability and require tracking for performance measurement. Cost centre managers need visibility into revenue variances caused by approved ',
    `import_export_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.import_export_permit. Business justification: Tariff exceptions granted based on valid import/export permits (duty relief for temporary imports, re-exports under customs regimes). Real customs clearance procedure.',
    `item_id` BIGINT COMMENT 'Reference to the standard published tariff item or schedule from which this exception deviates.',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the specific customer to whom this tariff exception applies.',
    `employee_id` BIGINT COMMENT 'Reference to the user who created this tariff exception record in the system.',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Exceptions affect profit centre performance and must be tracked for segment reporting. Financial controllers require exception tracking by profit centre to explain revenue variances in management repo',
    `project_id` BIGINT COMMENT 'Foreign key linking to infrastructure.infrastructure_project. Business justification: Promotional tariffs during new infrastructure commissioning. Commercial practice to incentivize use of new berths, terminals, or channels through temporary rate reductions. Links exceptions to capital',
    `quaternary_exception_revoked_by_user_employee_id` BIGINT COMMENT 'Reference to the user who revoked this tariff exception, if applicable.',
    `rate_card_id` BIGINT COMMENT 'Reference to the rate card under which this exception was granted, if applicable.',
    `shipment_id` BIGINT COMMENT 'Reference to the specific cargo consignment to which this exception applies, if applicable.',
    `tertiary_exception_modified_by_user_employee_id` BIGINT COMMENT 'Reference to the user who last modified this tariff exception record.',
    `call_id` BIGINT COMMENT 'Reference to the specific vessel call for which this exception was granted, if applicable.',
    `application_scope` STRING COMMENT 'Defines the scope of applicability for this exception: whether it applies to a single transaction, all transactions within a vessel call, all transactions under a customer agreement, specific cargo types, trade lanes, or a defined time period.. Valid values are `single_transaction|vessel_call|customer_agreement|cargo_type|trade_lane|time_period`',
    `approval_authority` STRING COMMENT 'Name or title of the individual or committee with authority who approved this tariff exception.',
    `approval_date` DATE COMMENT 'Date on which this tariff exception was formally approved by the designated authority.',
    `audit_trail_reference` STRING COMMENT 'Reference to external audit trail or approval workflow documentation supporting this exception decision.',
    `cargo_type` STRING COMMENT 'Type of cargo to which this exception applies, if the exception is cargo-specific (e.g., containerized, bulk, RoRo, dangerous goods).',
    `conditional_clause` STRING COMMENT 'Any conditional terms or clauses that must be satisfied for this exception to remain valid (e.g., performance targets, volume thresholds, payment terms).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this tariff exception record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this exception record.. Valid values are `^[A-Z]{3}$`',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Percentage discount applied to the standard rate, if the exception is structured as a percentage reduction.',
    `effective_date` DATE COMMENT 'Date from which this tariff exception becomes valid and applicable for billing and invoicing purposes.',
    `exception_number` STRING COMMENT 'Externally-known unique reference number assigned to this tariff exception for tracking and audit purposes.',
    `exception_status` STRING COMMENT 'Current lifecycle status of the tariff exception indicating its approval and validity state. [ENUM-REF-CANDIDATE: draft|pending_approval|approved|active|expired|revoked|rejected — 7 candidates stripped; promote to reference product]',
    `exception_type` STRING COMMENT 'Classification of the type of tariff exception granted. Indicates the nature of the deviation from standard published tariff. [ENUM-REF-CANDIDATE: rate_waiver|rate_discount|free_day_extension|surcharge_exemption|thc_waiver|dmg_waiver|det_waiver|storage_waiver — 8 candidates stripped; promote to reference product]',
    `expiry_date` DATE COMMENT 'Date on which this tariff exception ceases to be valid. Null indicates an open-ended exception subject to manual revocation.',
    `free_days_granted` STRING COMMENT 'Extended number of free days granted under this exception before storage or demurrage charges apply.',
    `free_days_standard` STRING COMMENT 'Number of free days allowed under the standard published tariff before storage or demurrage charges apply.',
    `justification` STRING COMMENT 'Detailed business justification and rationale for granting this tariff exception, including commercial, operational, or strategic reasons.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this tariff exception record was last modified in the system.',
    `notes` STRING COMMENT 'Additional free-text notes or comments regarding this tariff exception, including special instructions or context.',
    `rate_amount` DECIMAL(18,2) COMMENT 'The approved exceptional rate amount granted under this exception, in the specified currency. May be zero for full waivers.',
    `revenue_commitment_amount` DECIMAL(18,2) COMMENT 'Minimum revenue commitment amount that the customer must meet to qualify for this exception, in the specified currency.',
    `revocation_date` DATE COMMENT 'Date on which this tariff exception was revoked, if applicable.',
    `revocation_reason` STRING COMMENT 'Reason for revoking this tariff exception before its natural expiry, if applicable.',
    `service_type` STRING COMMENT 'Type of port service to which this exception applies (e.g., THC, wharfage, pilotage, storage, demurrage, detention).',
    `standard_rate_amount` DECIMAL(18,2) COMMENT 'The standard published tariff rate amount from which this exception deviates, in the specified currency.',
    `trade_lane` STRING COMMENT 'Specific trade lane or shipping route to which this exception applies, if trade-lane-specific.',
    `validity_period_days` STRING COMMENT 'Number of days for which this exception remains valid, calculated from the effective date.',
    `volume_commitment_teu` DECIMAL(18,2) COMMENT 'Minimum volume commitment in TEU that the customer must meet to qualify for this exception, if applicable.',
    `waiver_amount` DECIMAL(18,2) COMMENT 'Absolute monetary amount waived under this exception, in the specified currency.',
    CONSTRAINT pk_exception PRIMARY KEY(`exception_id`)
) COMMENT 'Record of approved exceptions or derogations from the standard published tariff, granted to specific customers, vessel calls, or cargo consignments. Captures exception type (rate waiver, free day extension, surcharge exemption), approved rate or concession, justification, approving authority, validity period, and reference to the originating tariff item or schedule. Provides an auditable trail of all non-standard pricing decisions applied outside the published tariff.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` (
    `pricing_rule_id` BIGINT COMMENT 'Unique identifier for the pricing rule. Primary key.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Pricing rules implement agreement-specific commercial logic. Customer-specific pricing rules are defined in and governed by master agreements, enabling automated pricing execution that honors contract',
    `rate_card_id` BIGINT COMMENT 'Specific rate card identifier that this pricing rule selects or modifies when trigger conditions are met.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Dynamic pricing rules based on berth availability, draft restrictions, shore power availability, and crane capacity. Real-time tariff adjustments depend on berth operational status. Required for berth',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Pricing rules are often scoped to specific cost centres (e.g., terminal-specific automated pricing). Pricing governance and audit trails require linking automated pricing rules to the responsible cost',
    `employee_id` BIGINT COMMENT 'Identifier of the user who approved this pricing rule for activation.',
    `port_community_participant_id` BIGINT COMMENT 'Specific customer identifier to which this pricing rule applies. Null indicates the rule applies to all customers meeting other trigger conditions.',
    `port_tariff_id` BIGINT COMMENT 'Specific port tariff identifier that this pricing rule selects or modifies when trigger conditions are met.',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Pricing rules drive revenue for specific profit centres and must be linked for profitability analysis. Financial planning and revenue forecasting require understanding which automated pricing rules ap',
    `superseded_by_rule_pricing_rule_id` BIGINT COMMENT 'Identifier of the pricing rule that supersedes this rule, establishing version lineage and rule evolution history.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Automated pricing rules trigger based on terminal zone characteristics (hazmat approval, customs control, reefer capacity, security level). Replaces denormalized trigger_terminal_zone with proper FK f',
    `trade_restriction_id` BIGINT COMMENT 'Foreign key linking to compliance.trade_restriction. Business justification: Pricing rules must exclude restricted/prohibited goods from standard tariff application. Compliance requirement to prevent handling of embargoed cargo at port facilities.',
    `approval_required_flag` BOOLEAN COMMENT 'Indicates whether this pricing rule requires management approval before it can be activated and used in billing calculations.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this pricing rule was approved for activation.',
    `auto_apply_flag` BOOLEAN COMMENT 'Indicates whether this pricing rule is automatically applied by the billing engine when trigger conditions are met, or requires manual approval.',
    `conflict_resolution_strategy` STRING COMMENT 'Strategy used to resolve conflicts when multiple pricing rules with the same priority could apply to the same billable event.. Valid values are `highest_priority|lowest_charge|highest_charge|most_specific|customer_favorable`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this pricing rule record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for amounts defined in this pricing rule.. Valid values are `^[A-Z]{3}$`',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Percentage discount applied by this pricing rule when trigger conditions are met.',
    `effective_from_date` DATE COMMENT 'Date from which the pricing rule becomes active and applicable to billing calculations.',
    `effective_to_date` DATE COMMENT 'Date until which the pricing rule remains active. Null indicates open-ended applicability.',
    `free_time_days` STRING COMMENT 'Number of free days allowed before demurrage or detention charges apply, as defined by this pricing rule.',
    `maximum_charge_amount` DECIMAL(18,2) COMMENT 'Maximum charge amount cap enforced by this pricing rule, ensuring that no charge exceeds this threshold regardless of calculation.',
    `minimum_charge_amount` DECIMAL(18,2) COMMENT 'Minimum charge amount enforced by this pricing rule, ensuring that no charge falls below this threshold regardless of calculation.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this pricing rule record was last modified.',
    `notes` STRING COMMENT 'Additional notes, comments, or special instructions related to the pricing rule for operational reference.',
    `priority_order` STRING COMMENT 'Numeric priority ranking used for conflict resolution when multiple pricing rules could apply to the same billable event. Lower numbers indicate higher priority.',
    `rule_code` STRING COMMENT 'Unique business identifier code for the pricing rule, used for external reference and system integration.. Valid values are `^[A-Z0-9_-]{4,20}$`',
    `rule_description` STRING COMMENT 'Detailed textual description of the pricing rule purpose, business rationale, and application context for business user reference.',
    `rule_expression` STRING COMMENT 'Formal expression or decision logic defining the rule conditions and calculation formula, stored in a structured or semi-structured format for execution by the billing engine.',
    `rule_name` STRING COMMENT 'Human-readable name of the pricing rule describing its purpose and application context.',
    `rule_status` STRING COMMENT 'Current lifecycle status of the pricing rule indicating whether it is in use, pending approval, or retired.. Valid values are `draft|active|suspended|expired|superseded`',
    `rule_type` STRING COMMENT 'Classification of the pricing rule logic type determining how charges are calculated or tariffs are selected. [ENUM-REF-CANDIDATE: tiered_pricing|conditional_surcharge|minimum_charge_enforcement|free_period_calculation|tariff_selection|applicability_matrix|conflict_resolution — 7 candidates stripped; promote to reference product]',
    `sla_linked_flag` BOOLEAN COMMENT 'Indicates whether this pricing rule is linked to SLA performance metrics, affecting rate selection based on service delivery.',
    `surcharge_percentage` DECIMAL(18,2) COMMENT 'Percentage surcharge applied by this pricing rule when trigger conditions are met (e.g., BAF, CAF, peak season surcharge).',
    `trigger_cargo_type` STRING COMMENT 'Cargo type condition that triggers the applicability of this pricing rule (e.g., containerized, bulk, RoRo, dangerous goods). Pipe-separated list for multiple values.',
    `trigger_cargo_weight_max_kg` DECIMAL(18,2) COMMENT 'Maximum cargo weight threshold in kilograms that triggers the applicability of this pricing rule. Used for weight-based tiered pricing.',
    `trigger_cargo_weight_min_kg` DECIMAL(18,2) COMMENT 'Minimum cargo weight threshold in kilograms that triggers the applicability of this pricing rule. Used for weight-based tiered pricing.',
    `trigger_container_type` STRING COMMENT 'Container type condition that triggers the applicability of this pricing rule (e.g., 20ft dry, 40ft dry, 40ft high cube, reefer, tank, flat rack). Pipe-separated list for multiple values.',
    `trigger_customer_segment` STRING COMMENT 'Customer segment condition that triggers the applicability of this pricing rule (e.g., shipping line, freight forwarder, cargo owner, government). Pipe-separated list for multiple values.',
    `trigger_grt_max` DECIMAL(18,2) COMMENT 'Maximum gross registered tonnage that triggers the applicability of this pricing rule. Used for vessel tonnage-based pricing.',
    `trigger_grt_min` DECIMAL(18,2) COMMENT 'Minimum gross registered tonnage that triggers the applicability of this pricing rule. Used for vessel tonnage-based pricing.',
    `trigger_loa_max_meters` DECIMAL(18,2) COMMENT 'Maximum vessel length overall in meters that triggers the applicability of this pricing rule. Used for vessel size-based pricing.',
    `trigger_loa_min_meters` DECIMAL(18,2) COMMENT 'Minimum vessel length overall in meters that triggers the applicability of this pricing rule. Used for vessel size-based pricing.',
    `trigger_service_type` STRING COMMENT 'Service type condition that triggers the applicability of this pricing rule (e.g., THC, wharfage, pilotage, demurrage, detention, storage). Pipe-separated list for multiple values.',
    `trigger_trade_direction` STRING COMMENT 'Trade direction condition that triggers the applicability of this pricing rule, determining whether the cargo is inbound, outbound, or in transit.. Valid values are `import|export|transshipment|coastal|empty_repositioning`',
    `trigger_trade_lane` STRING COMMENT 'Trade lane or route condition that triggers the applicability of this pricing rule (e.g., Asia-Europe, Transpacific, Transatlantic). Pipe-separated list for multiple values.',
    `trigger_vessel_class` STRING COMMENT 'Vessel class or category condition that triggers the applicability of this pricing rule (e.g., feeder, panamax, post-panamax, ULCV). Pipe-separated list for multiple values.',
    `trigger_volume_max_teu` DECIMAL(18,2) COMMENT 'Maximum volume threshold in TEU that triggers the applicability of this pricing rule. Used for volume-based tiered pricing.',
    `trigger_volume_min_teu` DECIMAL(18,2) COMMENT 'Minimum volume threshold in TEU that triggers the applicability of this pricing rule. Used for volume-based tiered pricing or minimum commitment enforcement.',
    CONSTRAINT pk_pricing_rule PRIMARY KEY(`pricing_rule_id`)
) COMMENT 'Configurable business rule defining conditional logic for charge calculation, rate selection, tariff applicability, and conflict resolution. Captures rule name, rule type (tiered pricing, conditional surcharge, minimum charge enforcement, free period calculation, tariff selection, applicability matrix, conflict resolution), trigger conditions (cargo type, vessel class, trade direction, customer segment, terminal zone, service type, trade lane), priority order for conflict resolution when multiple tariffs could apply, effective period, and rule expression or decision logic. Includes the full applicability matrix specifying which tariff applies to which combination of customer segment, vessel type, cargo category, trade lane, terminal zone, and service type — serving as the deterministic tariff selection engine. Used by the billing engine and TOS charge calculation to select the correct tariff and rate for each billable event without ambiguity. New applicability dimensions are added as rule conditions — no separate entity required.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` (
    `free_time_allowance_id` BIGINT COMMENT 'Primary key for free_time_allowance',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Free time allowances are contractual concessions negotiated in agreements, granting customers extended free periods before demurrage/detention charges apply. Essential for demurrage calculation, contr',
    `container_type_id` BIGINT COMMENT 'add column container_type_id (BIGINT) with FK to masterdata.container_type.container_type_id - free time allowances vary by container type (reefer vs dry, 20ft vs 40ft)',
    `port_tariff_id` BIGINT COMMENT 'Reference to the parent port tariff schedule under which this free time allowance is defined.',
    `rate_card_id` BIGINT COMMENT 'Reference to the rate card that governs this free time allowance, if applicable to customer-specific agreements.',
    `superseded_by_allowance_free_time_allowance_id` BIGINT COMMENT 'Reference to the newer free time allowance rule that replaces this one, if applicable. Null if not superseded.',
    `allowance_code` STRING COMMENT 'Unique business identifier code for this free time allowance rule, used in billing and operational systems.. Valid values are `^[A-Z0-9_-]{3,20}$`',
    `allowance_name` STRING COMMENT 'Descriptive name of the free time allowance rule for business users and reporting.',
    `applicable_charge_type` STRING COMMENT 'The type of charge that commences after the free time expires: storage, demurrage (DMG), detention (DET), wharfage (WHR), or THC (Terminal Handling Charge).. Valid values are `storage|demurrage|detention|wharfage|thc`',
    `approval_status` STRING COMMENT 'Approval workflow status for this free time allowance rule: pending (awaiting approval), approved (authorized for use), or rejected (not authorized).. Valid values are `pending|approved|rejected`',
    `approved_by` STRING COMMENT 'Name or identifier of the authority or user who approved this free time allowance rule.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this free time allowance rule was approved.',
    `auto_apply_flag` BOOLEAN COMMENT 'Indicates whether this free time allowance is automatically applied by the billing system when conditions are met. True means automatic application.',
    `calculation_basis` STRING COMMENT 'Basis for calculating free time: calendar days (all days including weekends and holidays), working days (excludes weekends), or business days (excludes weekends and public holidays).. Valid values are `calendar_days|working_days|business_days`',
    `cargo_type` STRING COMMENT 'Type of cargo to which this free time applies: FCL (Full Container Load), LCL (Less than Container Load), breakbulk, RoRo (Roll-on Roll-off), LoLo (Lift-on Lift-off), bulk, or all types. [ENUM-REF-CANDIDATE: fcl|lcl|breakbulk|roro|lolo|bulk|all_types — 7 candidates stripped; promote to reference product]',
    `container_type` STRING COMMENT 'Type of container to which this free time allowance applies: standard TEU (Twenty-foot Equivalent Unit), standard FEU (Forty-foot Equivalent Unit), high cube 40ft, high cube 45ft, reefer 20ft, reefer 40ft, open top, flat rack, tank, or all types. [ENUM-REF-CANDIDATE: standard_20|standard_40|high_cube_40|high_cube_45|reefer_20|reefer_40|open_top|flat_rack|tank|all_types — 10 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this free time allowance record was first created in the system.',
    `customer_tier` STRING COMMENT 'Customer service tier or segment to which this free time allowance applies, reflecting volume commitments and SLA (Service Level Agreement) levels.. Valid values are `platinum|gold|silver|bronze|standard|all_tiers`',
    `dangerous_goods_flag` BOOLEAN COMMENT 'Indicates whether this free time allowance applies to dangerous goods cargo classified under IMDG (International Maritime Dangerous Goods Code). True means it applies to dangerous goods.',
    `effective_date` DATE COMMENT 'The date from which this free time allowance rule becomes active and applicable to new transactions.',
    `end_trigger_event` STRING COMMENT 'The operational event that ends the free time period: gate-out, vessel loading, container pickup, or expiry of the allocated free days.. Valid values are `gate_out|vessel_loading|container_pickup|expiry_of_free_days`',
    `expiry_date` DATE COMMENT 'The date on which this free time allowance rule ceases to be active. Null indicates an open-ended rule.',
    `free_days` STRING COMMENT 'Number of free days granted before storage, demurrage (DMG), or detention (DET) charges commence.',
    `free_time_allowance_status` STRING COMMENT 'Current lifecycle status of the free time allowance rule: draft (under review), active (in use), suspended (temporarily inactive), expired (past expiry date), or superseded (replaced by newer rule).. Valid values are `draft|active|suspended|expired|superseded`',
    `free_time_type` STRING COMMENT 'Category of free time allowance: import free days (container dwell before storage charges), export free days (pre-shipment dwell), transshipment free days (in-transit dwell), equipment free days (chassis/equipment rental grace period), storage free days (yard storage grace), or demurrage free days (vessel delay grace).. Valid values are `import_free_days|export_free_days|transshipment_free_days|equipment_free_days|storage_free_days|demurrage_free_days`',
    `holiday_exclusion_flag` BOOLEAN COMMENT 'Indicates whether public holidays are excluded from the free time calculation. True means holidays do not count toward free days.',
    `maximum_volume_teu` DECIMAL(18,2) COMMENT 'Maximum volume in TEU (Twenty-foot Equivalent Unit) to which this free time allowance applies. Null if no maximum cap exists.',
    `minimum_volume_teu` DECIMAL(18,2) COMMENT 'Minimum committed volume in TEU (Twenty-foot Equivalent Unit) required to qualify for this free time allowance. Null if no minimum applies.',
    `modified_by` STRING COMMENT 'Identifier of the user or system that last modified this free time allowance record.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this free time allowance record was last modified.',
    `notes` STRING COMMENT 'Additional business notes, comments, or special conditions related to this free time allowance rule.',
    `priority_order` STRING COMMENT 'Numeric priority for rule evaluation when multiple free time allowances could apply to the same transaction. Lower numbers indicate higher priority.',
    `reefer_cargo_flag` BOOLEAN COMMENT 'Indicates whether this free time allowance applies to refrigerated (reefer) cargo. True means it applies to reefer containers.',
    `start_trigger_event` STRING COMMENT 'The operational event that triggers the start of the free time period: vessel discharge, gate-in, customs release, delivery order (D/O) issue, container available for pickup, or berth departure.. Valid values are `vessel_discharge|gate_in|customs_release|delivery_order_issue|container_available|berth_departure`',
    `terminal_zone` STRING COMMENT 'Specific terminal zone or CY (Container Yard) area to which this free time allowance applies. Null indicates all zones.',
    `trade_lane` STRING COMMENT 'Specific trade lane or shipping route to which this free time allowance applies (e.g., Asia-Europe, Transpacific, Intra-Asia). Null indicates all trade lanes.',
    `vessel_category` STRING COMMENT 'Category of vessel to which this free time allowance applies: feeder, panamax, post-panamax, ultra-large container vessel, or all categories.. Valid values are `feeder|panamax|post_panamax|ultra_large|all_categories`',
    `weekend_exclusion_flag` BOOLEAN COMMENT 'Indicates whether weekends (Saturday and Sunday) are excluded from the free time calculation. True means weekends do not count toward free days.',
    `created_by` STRING COMMENT 'Identifier of the user or system that created this free time allowance record.',
    CONSTRAINT pk_free_time_allowance PRIMARY KEY(`free_time_allowance_id`)
) COMMENT 'Master definition of free time periods granted to customers before storage, demurrage, or detention charges commence. Captures free time type (import free days, export free days, transshipment free days, equipment free days), applicable container type, trade lane, customer tier, number of free days, calculation basis (calendar days vs. working days), and holiday exclusion rules. The SSOT for free time parameters consumed by the storage, demurrage, and detention charge engines.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` (
    `towage_tariff_id` BIGINT COMMENT 'Unique identifier for the towage tariff record. Primary key.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Towage requirements and pricing depend on channel width, depth, current, and navigational difficulty. Operational practice links towage tariffs to specific channels for tug assignment and billing. Cri',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Towage operations are zone-specific (port_zone attribute). Rates vary by operational area, distance, and tug requirements within port. Links to location master for zone-based tariff calculation and to',
    `superseded_by_tariff_towage_tariff_id` BIGINT COMMENT 'Reference to the towage tariff record that replaces this tariff when it expires or is superseded by a new version.',
    `approval_authority` STRING COMMENT 'Name of the regulatory body, port authority, or internal governance entity that approved this towage tariff schedule.',
    `approval_date` DATE COMMENT 'Date on which this towage tariff schedule was officially approved by the designated authority.',
    `approval_reference_number` STRING COMMENT 'Official reference number or document identifier for the regulatory or governance approval of this towage tariff.',
    `base_towage_fee_amount` DECIMAL(18,2) COMMENT 'Base charge amount for the towage operation before any adjustments, surcharges, or time-based premiums.',
    `cancellation_fee_amount` DECIMAL(18,2) COMMENT 'Fee charged when a scheduled towage operation is cancelled within the notice period, compensating for tug mobilization and opportunity cost.',
    `cancellation_notice_period_hours` STRING COMMENT 'Minimum number of hours advance notice required to cancel a towage booking without incurring the cancellation fee.',
    `cargo_type_restriction` STRING COMMENT 'Specific cargo type or International Maritime Dangerous Goods (IMDG) class for which this towage tariff applies, if the rate varies by cargo hazard level. Null indicates no cargo-specific restriction.',
    `created_by_user` STRING COMMENT 'Username or identifier of the user who created this towage tariff record.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this towage tariff record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which the towage tariff rates are denominated.. Valid values are `^[A-Z]{3}$`',
    `discount_eligible_flag` BOOLEAN COMMENT 'Indicates whether this towage tariff rate is eligible for volume discounts, loyalty discounts, or negotiated rate exceptions.',
    `dwt_band_max` DECIMAL(18,2) COMMENT 'Maximum Deadweight Tonnage of vessel for which this towage tariff rate applies. Null indicates no upper limit.',
    `dwt_band_min` DECIMAL(18,2) COMMENT 'Minimum Deadweight Tonnage of vessel for which this towage tariff rate applies. DWT is the weight a vessel can safely carry including cargo, fuel, crew, and provisions.',
    `effective_from_date` DATE COMMENT 'Date from which this towage tariff becomes applicable and enforceable for billing purposes.',
    `effective_to_date` DATE COMMENT 'Date until which this towage tariff remains valid. Null indicates open-ended validity.',
    `escalation_clause` STRING COMMENT 'Description of the automatic rate escalation mechanism tied to inflation indices, fuel costs (Bunker Adjustment Factor - BAF), or currency fluctuations (Currency Adjustment Factor - CAF).',
    `extraordinary_conditions_surcharge_pct` DECIMAL(18,2) COMMENT 'Percentage surcharge applied to the base towage fee for operations conducted under extraordinary conditions such as severe weather, restricted visibility, or emergency response.',
    `free_standby_time_minutes` STRING COMMENT 'Number of minutes of tug standby time included in the base towage fee before standby charges apply.',
    `grt_band_max` DECIMAL(18,2) COMMENT 'Maximum Gross Registered Tonnage of vessel for which this towage tariff rate applies. Null indicates no upper limit.',
    `grt_band_min` DECIMAL(18,2) COMMENT 'Minimum Gross Registered Tonnage of vessel for which this towage tariff rate applies. GRT is the total internal volume of a vessel.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this towage tariff record was last updated or modified.',
    `loa_band_max_meters` DECIMAL(18,2) COMMENT 'Maximum vessel Length Overall in meters for which this towage tariff rate applies. Null indicates no upper limit.',
    `loa_band_min_meters` DECIMAL(18,2) COMMENT 'Minimum vessel Length Overall in meters for which this towage tariff rate applies. LOA is the maximum length of a vessels hull measured parallel to the waterline.',
    `maximum_charge_amount` DECIMAL(18,2) COMMENT 'Maximum billable amount cap for a towage operation under this tariff, if applicable. Null indicates no cap.',
    `minimum_charge_amount` DECIMAL(18,2) COMMENT 'Minimum billable amount for a towage operation regardless of calculated rate, ensuring cost recovery for tug mobilization.',
    `modified_by_user` STRING COMMENT 'Username or identifier of the user who last modified this towage tariff record.',
    `notes` STRING COMMENT 'Additional notes, special conditions, or clarifications regarding the application of this towage tariff.',
    `number_of_tugs_required` STRING COMMENT 'Standard number of tug vessels required for the towage operation under this tariff, based on vessel size and port conditions.',
    `operation_type` STRING COMMENT 'Type of towage operation covered by this tariff: berthing (vessel arrival to berth), unberthing (vessel departure from berth), shifting (vessel movement between berths), emergency (unscheduled assistance), escort (harbor transit), or standby (tug on standby).. Valid values are `berthing|unberthing|shifting|emergency|escort|standby`',
    `publication_date` DATE COMMENT 'Date on which this towage tariff schedule was published and made available to port users and stakeholders.',
    `rate_unit_of_measure` STRING COMMENT 'Unit of measure for the towage tariff rate calculation: per operation (flat fee), per hour (time-based), per tug (per vessel), per GRT, or per DWT.. Valid values are `per_operation|per_hour|per_tug|per_grt|per_dwt`',
    `sla_linked_flag` BOOLEAN COMMENT 'Indicates whether this towage tariff is linked to a Service Level Agreement with performance guarantees and potential penalties or rebates.',
    `standby_time_rate_per_hour` DECIMAL(18,2) COMMENT 'Hourly rate charged when tugs are on standby awaiting vessel readiness or operational clearance beyond the included free standby time.',
    `tariff_code` STRING COMMENT 'Unique business identifier for the towage tariff schedule, used for external reference and billing system integration.. Valid values are `^TOW-[A-Z0-9]{6,12}$`',
    `tariff_name` STRING COMMENT 'Descriptive name of the towage tariff schedule for business user identification.',
    `tariff_status` STRING COMMENT 'Current lifecycle status of the towage tariff schedule in the approval and publication workflow. [ENUM-REF-CANDIDATE: draft|pending_approval|approved|active|suspended|expired|superseded — 7 candidates stripped; promote to reference product]',
    `tariff_version` STRING COMMENT 'Version number of the towage tariff schedule, incremented with each revision or amendment.. Valid values are `^[0-9]{1,3}.[0-9]{1,3}$`',
    `time_of_day_category` STRING COMMENT 'Time period classification for towage operations affecting the applicable rate: standard hours (normal business hours), after hours, night shift, weekend, or public holiday.. Valid values are `standard_hours|after_hours|night|weekend|public_holiday`',
    `tug_bollard_pull_min_tonnes` DECIMAL(18,2) COMMENT 'Minimum bollard pull capacity in tonnes required for tugs performing this towage operation. Bollard pull is the pulling force a tug can exert.',
    `vessel_type_category` STRING COMMENT 'Category of vessel to which this towage tariff applies (e.g., container, bulk carrier, tanker, RoRo, cruise, general cargo). Null indicates applicability to all vessel types.',
    CONSTRAINT pk_towage_tariff PRIMARY KEY(`towage_tariff_id`)
) COMMENT 'Towage service tariff defining charges for tug assistance during vessel berthing, unberthing, and shifting operations. Rates are structured by vessel GRT band, DWT band, number of tugs required, tug bollard pull rating, operation type (berthing, unberthing, shifting, emergency), time of day, and port zone. Captures base towage fee, standby time rate, cancellation fee, and extraordinary towage conditions. Aligned with marine towage operations in the marine domain.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` (
    `mooring_tariff_id` BIGINT COMMENT 'Unique identifier for the mooring tariff record. Primary key.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Mooring services are berth-specific operations. Tariffs reference berth bollard capacity, fender systems, and mooring gang requirements for rate calculation. Direct operational link for mooring servic',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Mooring services are berth/zone-specific (berth_zone attribute). Location determines mooring gang requirements, equipment availability, and rates. Links to port location master for berth-specific tari',
    `employee_id` BIGINT COMMENT 'Identifier of the user or authority who approved this mooring tariff for operational use.',
    `superseded_by_tariff_mooring_tariff_id` BIGINT COMMENT 'Reference to the newer mooring tariff record that replaces this one, maintaining tariff version history and lineage.',
    `tertiary_mooring_modified_by_user_employee_id` BIGINT COMMENT 'Identifier of the user who last modified this mooring tariff record.',
    `approval_date` DATE COMMENT 'Date on which this mooring tariff was officially approved for implementation.',
    `approval_status` STRING COMMENT 'Current approval state of the tariff: pending (awaiting review), approved (authorized for use), or rejected (not authorized).. Valid values are `pending|approved|rejected`',
    `base_mooring_fee` DECIMAL(18,2) COMMENT 'Standard charge amount for the mooring or unmooring service under normal conditions, excluding surcharges and additional fees.',
    `cancellation_fee` DECIMAL(18,2) COMMENT 'Charge applied when a scheduled mooring service is cancelled within the notice period, compensating for crew mobilization costs.',
    `cancellation_notice_hours` STRING COMMENT 'Minimum number of hours advance notice required to cancel a mooring service without incurring the cancellation fee.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this mooring tariff record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which all tariff amounts are denominated.. Valid values are `^[A-Z]{3}$`',
    `customer_tier` STRING COMMENT 'Customer segmentation level for differential pricing: standard (public tariff), preferred (volume customer), premium (strategic account), or contract (negotiated rate).. Valid values are `standard|preferred|premium|contract`',
    `discount_eligible_flag` BOOLEAN COMMENT 'Indicates whether this tariff rate is eligible for additional volume discounts or promotional adjustments.',
    `effective_from_date` DATE COMMENT 'Date from which this mooring tariff becomes valid and applicable for billing purposes.',
    `effective_to_date` DATE COMMENT 'Date until which this mooring tariff remains valid. Null indicates open-ended validity.',
    `escalation_clause` STRING COMMENT 'Description of automatic rate adjustment provisions based on inflation indices, fuel costs, or other economic factors.',
    `free_waiting_time_minutes` STRING COMMENT 'Grace period in minutes during which no waiting time surcharge is applied before the mooring gang begins work.',
    `grt_band_max` DECIMAL(18,2) COMMENT 'Maximum gross registered tonnage for this tariff band. Null indicates no upper limit for the band.',
    `grt_band_min` DECIMAL(18,2) COMMENT 'Minimum gross registered tonnage for this tariff band. GRT is the total internal volume of a vessel expressed in register tons.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this mooring tariff record was most recently updated or modified.',
    `loa_band_max_meters` DECIMAL(18,2) COMMENT 'Maximum vessel length overall in meters for this tariff band. Null indicates no upper limit for the band.',
    `loa_band_min_meters` DECIMAL(18,2) COMMENT 'Minimum vessel length overall in meters for this tariff band. LOA is the maximum length of a vessels hull measured parallel to the waterline.',
    `maximum_charge_cap` DECIMAL(18,2) COMMENT 'Maximum billable amount ceiling for the mooring service to protect customers from excessive charges in extended operations. Null indicates no cap.',
    `minimum_charge_amount` DECIMAL(18,2) COMMENT 'Minimum billable amount for the mooring service regardless of actual time or resources used, ensuring cost recovery for mobilization.',
    `mooring_gang_count` STRING COMMENT 'Number of mooring gangs (line-handling crews) deployed for the service covered by this tariff rate.',
    `mooring_type` STRING COMMENT 'Classification of mooring configuration: conventional (alongside berth), buoy mooring, single-point mooring (SPM), multi-buoy, or dolphin mooring.. Valid values are `conventional|buoy|single_point|multi_buoy|dolphin`',
    `notes` STRING COMMENT 'Free-text field for additional comments, clarifications, or internal documentation regarding this mooring tariff.',
    `public_tariff_flag` BOOLEAN COMMENT 'Indicates whether this tariff is publicly published and available to all customers, or is a private negotiated rate.',
    `publication_date` DATE COMMENT 'Date on which this tariff was published or made available to customers and stakeholders.',
    `rate_unit_of_measure` STRING COMMENT 'Unit basis for the tariff rate calculation: per operation (single mooring event), per gang (crew unit), per hour (time-based), or per line (individual mooring line).. Valid values are `per_operation|per_gang|per_hour|per_line`',
    `regulatory_filing_required_flag` BOOLEAN COMMENT 'Indicates whether this tariff must be filed with or approved by maritime regulatory authorities before implementation.',
    `service_type` STRING COMMENT 'Type of mooring service covered by this tariff: mooring (arrival line-handling), unmooring (departure line-handling), or combined (both services).. Valid values are `mooring|unmooring|combined`',
    `sla_linked_flag` BOOLEAN COMMENT 'Indicates whether this tariff is tied to specific service level agreement performance metrics, with potential penalties or credits for non-compliance.',
    `sla_response_time_minutes` STRING COMMENT 'Committed maximum time in minutes from service request to mooring gang arrival at vessel, applicable when SLA is linked.',
    `special_conditions` STRING COMMENT 'Additional terms, restrictions, or requirements that apply to this mooring tariff, such as weather limitations or equipment prerequisites.',
    `tariff_code` STRING COMMENT 'Unique business identifier code for the mooring tariff schedule, used for external reference and billing system integration.. Valid values are `^[A-Z0-9]{6,12}$`',
    `tariff_name` STRING COMMENT 'Descriptive name of the mooring tariff schedule for business user identification and reporting purposes.',
    `tariff_status` STRING COMMENT 'Current lifecycle status of the mooring tariff: draft (under development), active (in use), suspended (temporarily inactive), expired (past validity), or superseded (replaced by newer version).. Valid values are `draft|active|suspended|expired|superseded`',
    `tariff_version` STRING COMMENT 'Version number of this tariff schedule in major.minor format, enabling tracking of tariff evolution and changes over time.. Valid values are `^[0-9]{1,3}.[0-9]{1,3}$`',
    `time_of_day_category` STRING COMMENT 'Time period classification for differential pricing: day (standard business hours), night (after-hours), weekend, or holiday operations.. Valid values are `day|night|weekend|holiday`',
    `trade_lane` STRING COMMENT 'Specific trade route or shipping lane to which this tariff applies, enabling route-specific pricing strategies.',
    `vessel_category` STRING COMMENT 'Classification of vessel type to which this tariff applies: container ship, bulk carrier, tanker, roll-on roll-off (RoRo), general cargo, cruise ship, or naval vessel. [ENUM-REF-CANDIDATE: container|bulk|tanker|roro|general_cargo|cruise|naval — 7 candidates stripped; promote to reference product]',
    `waiting_time_surcharge_per_hour` DECIMAL(18,2) COMMENT 'Additional charge per hour when mooring gang is on standby waiting for vessel readiness or berth availability beyond the free waiting period.',
    CONSTRAINT pk_mooring_tariff PRIMARY KEY(`mooring_tariff_id`)
) COMMENT 'Mooring and unmooring service tariff defining charges for line-handling services during vessel arrival and departure. Rates are structured by vessel LOA band, GRT band, mooring type (conventional, buoy, single-point), time of day (day/night/weekend/holiday), and number of mooring gangs deployed. Captures base mooring fee, waiting time surcharge, and cancellation fee. Supports marine services billing in the marine and billing domains.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` (
    `port_dues_schedule_id` BIGINT COMMENT 'Unique identifier for the port dues schedule record. Primary key for this entity.',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Anchorage dues are standard maritime charges for vessels at anchorage. Dues vary by anchorage area designation, security zone, and holding duration. Essential for anchorage-specific billing in vessel ',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Port dues often calculated based on berth utilization, berth depth, and LOA capacity. Regulatory filings and tariff schedules reference specific berths for dues calculation. Required for berth-specifi',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: Port dues are national-level charges subject to country-specific regulations, international maritime conventions (SOLAS, MARPOL), and trade agreements. Country context determines regulatory framework,',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Port dues schedules include ISPS security levies tied to facility security level. Real cost recovery mechanism for maritime security compliance mandated by SOLAS.',
    `flag_state_id` BIGINT COMMENT 'Foreign key linking to masterdata.flag_state. Business justification: Port dues often have flag state differentials (flag_state attribute). Bilateral maritime agreements, reciprocity arrangements, and flag state performance affect rates. Links to flag state master for t',
    `employee_id` BIGINT COMMENT 'Identifier of the user who created this port dues schedule record in the system. Required for audit trail and accountability.',
    `superseded_by_schedule_port_dues_schedule_id` BIGINT COMMENT 'Reference to the port dues schedule that replaces this schedule. Nullable for current active schedules. Maintains version history and audit trail for regulatory compliance.',
    `approval_date` DATE COMMENT 'Date on which the regulatory authority officially approved this port dues schedule for implementation.',
    `base_rate_amount` DECIMAL(18,2) COMMENT 'Base monetary amount for the port dues charge before any discounts, surcharges, or adjustments. Represents the standard statutory rate for the defined vessel classification and dues type.',
    `call_frequency_discount_percentage` DECIMAL(18,2) COMMENT 'Percentage discount applied to port dues for vessels meeting the call frequency tier criteria. Incentivizes regular service commitments and port loyalty.',
    `call_frequency_tier` STRING COMMENT 'Classification tier based on vessel call frequency at the port. First call applies to vessels making their inaugural visit, regular applies to standard service schedules, frequent applies to high-frequency callers, and premium applies to vessels with committed service agreements. Higher frequency tiers may attract discounted dues rates.. Valid values are `first_call|regular|frequent|premium`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this port dues schedule record was first created in the system. Part of mandatory audit trail for regulatory compliance.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which the port dues are denominated and payable.. Valid values are `^[A-Z]{3}$`',
    `dangerous_goods_surcharge_percentage` DECIMAL(18,2) COMMENT 'Additional percentage surcharge applied to port dues for vessels carrying International Maritime Dangerous Goods (IMDG) classified cargo. Reflects additional risk management and safety oversight costs.',
    `dues_type` STRING COMMENT 'Classification of the statutory port dues charge type levied on vessels. Light dues cover navigational aids, conservancy dues cover channel maintenance, port entry fee is the basic vessel call charge, anchorage dues apply to vessels at anchor, navigation dues cover vessel traffic services, and pilotage dues cover mandatory pilotage services.. Valid values are `light_dues|conservancy_dues|port_entry_fee|anchorage_dues|navigation_dues|pilotage_dues`',
    `effective_from_date` DATE COMMENT 'Date from which this port dues schedule becomes legally binding and applicable to vessel calls. Aligns with regulatory publication requirements.',
    `effective_to_date` DATE COMMENT 'Date until which this port dues schedule remains valid. Nullable for open-ended schedules subject to regulatory review.',
    `environmental_levy_percentage` DECIMAL(18,2) COMMENT 'Percentage levy added to port dues to fund environmental protection initiatives, emissions monitoring, and compliance with MARPOL (Marine Pollution Convention) requirements.',
    `exemption_criteria` STRING COMMENT 'Detailed description of the criteria under which vessels may be exempt from port dues under this schedule. Typically includes naval vessels, government vessels on official duty, vessels in distress, and humanitarian mission vessels.',
    `exemption_flag` BOOLEAN COMMENT 'Indicates whether this dues schedule includes provisions for exemptions. True if certain vessel categories (e.g., naval vessels, emergency response vessels, vessels in distress) may be exempt from dues under this schedule.',
    `grt_band_max` DECIMAL(18,2) COMMENT 'Maximum Gross Registered Tonnage for the vessel size band to which this dues schedule applies. Nullable for open-ended upper bands.',
    `grt_band_min` DECIMAL(18,2) COMMENT 'Minimum Gross Registered Tonnage for the vessel size band to which this dues schedule applies. GRT is the primary metric for vessel-based port dues calculation.',
    `late_payment_penalty_percentage` DECIMAL(18,2) COMMENT 'Percentage penalty applied to overdue port dues payments. Calculated as a percentage of the outstanding amount per period (typically per month or per day).',
    `loa_band_max_meters` DECIMAL(18,2) COMMENT 'Maximum vessel Length Overall in meters for this dues schedule band. Nullable for open-ended upper bands.',
    `loa_band_min_meters` DECIMAL(18,2) COMMENT 'Minimum vessel Length Overall in meters for this dues schedule band. LOA may be used as a supplementary classification criterion for berth allocation and dues calculation.',
    `maximum_charge_amount` DECIMAL(18,2) COMMENT 'Maximum port dues charge amount applicable as a cap. Protects large vessel operators from excessive dues and maintains port competitiveness for mega-vessels.',
    `measurement_period_days` STRING COMMENT 'Number of days over which call frequency is measured for discount eligibility. Typically 30, 90, or 365 days depending on service agreement terms.',
    `minimum_calls_per_period` STRING COMMENT 'Minimum number of vessel calls required within the measurement period to qualify for the call frequency discount. Used to enforce service commitment thresholds.',
    `minimum_charge_amount` DECIMAL(18,2) COMMENT 'Minimum port dues charge amount applicable regardless of calculated rate. Ensures a floor revenue per vessel call for small vessels where tonnage-based calculation would yield negligible amounts.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this port dues schedule record was last modified in the system. Part of mandatory audit trail for regulatory compliance and version control.',
    `notes` STRING COMMENT 'Free-text field for additional notes, special conditions, or clarifications regarding the application of this port dues schedule. May include references to specific regulatory provisions or commercial agreements.',
    `nrt_band_max` DECIMAL(18,2) COMMENT 'Maximum Net Registered Tonnage for the vessel size band. Nullable for open-ended upper bands.',
    `nrt_band_min` DECIMAL(18,2) COMMENT 'Minimum Net Registered Tonnage for the vessel size band. NRT represents the earning capacity of the vessel and may be used as an alternative or supplementary metric for dues calculation in some jurisdictions.',
    `payment_terms_days` STRING COMMENT 'Number of days from vessel departure or invoice date within which port dues must be paid. Standard terms are typically 7, 14, or 30 days depending on customer credit standing.',
    `port_dues_schedule_status` STRING COMMENT 'Current lifecycle status of the port dues schedule. Draft schedules are under development, active schedules are in force, suspended schedules are temporarily inactive, expired schedules have passed their validity period, superseded schedules have been replaced by newer versions, and withdrawn schedules have been permanently removed.. Valid values are `draft|active|suspended|expired|superseded|withdrawn`',
    `publication_date` DATE COMMENT 'Date on which this port dues schedule was published in the official gazette or public tariff book. Statutory port dues must be publicly disclosed prior to enforcement.',
    `rate_unit_of_measure` STRING COMMENT 'Unit of measure for the base rate calculation. Per GRT and per NRT are tonnage-based, per call is a flat fee per vessel visit, per meter LOA is length-based, per day applies to anchorage dues, and flat fee is a fixed charge regardless of vessel size.. Valid values are `per_grt|per_nrt|per_call|per_meter_loa|per_day|flat_fee`',
    `regulatory_approval_reference` STRING COMMENT 'Official reference number or gazette notification number issued by the regulatory authority approving this port dues schedule. Required for legal enforceability and audit compliance.',
    `regulatory_authority` STRING COMMENT 'Name of the government or regulatory body that has jurisdiction over this port dues schedule. Port dues are statutory charges requiring regulatory approval and oversight.',
    `schedule_code` STRING COMMENT 'Unique business identifier code for the port dues schedule, used for external reference and regulatory reporting.. Valid values are `^[A-Z0-9]{6,20}$`',
    `schedule_name` STRING COMMENT 'Descriptive name of the port dues schedule for business identification and reporting purposes.',
    `security_levy_percentage` DECIMAL(18,2) COMMENT 'Percentage levy added to port dues to fund International Ship and Port Facility Security (ISPS) Code compliance measures and port security infrastructure.',
    `trade_type` STRING COMMENT 'Classification of trade type for which this dues schedule applies. International trade involves cross-border cargo, coastal trade is between domestic ports, domestic trade is within national waters, cabotage is domestic cargo carriage reserved for national flag vessels, and transshipment involves cargo transfer without customs clearance.. Valid values are `international|coastal|domestic|cabotage|transshipment`',
    `vessel_type` STRING COMMENT 'Classification of vessel type to which this dues schedule applies. Different vessel types may attract different dues rates based on port usage patterns and infrastructure requirements. [ENUM-REF-CANDIDATE: container|bulk_carrier|tanker|roro|general_cargo|passenger|fishing|naval|yacht — 9 candidates stripped; promote to reference product]',
    CONSTRAINT pk_port_dues_schedule PRIMARY KEY(`port_dues_schedule_id`)
) COMMENT 'Port dues (port call charges) schedule defining the statutory charges levied on vessels calling at the port. Captures dues type (light dues, conservancy dues, port entry fee, anchorage dues), vessel classification (GRT band, vessel type, flag state), trade type (international, coastal, domestic), call frequency discounts, and regulatory authority reference. Distinct from cargo-based wharfage; port dues are vessel-based charges payable by the shipowner or agent per vessel call.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` (
    `applicability_id` BIGINT COMMENT 'Unique identifier for the tariff applicability rule. Primary key for the tariff applicability matrix.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Applicability rules determine which tariffs apply under which agreement contexts. Agreement-specific applicability rules enable contract-based pricing determination, ensuring correct tariff selection ',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Applicability rules filter by cargo category and type. Commodity codes provide standardized cargo classification for tariff rule evaluation. Links denormalized cargo attributes to commodity master for',
    `container_type_id` BIGINT COMMENT 'add column container_type_id (BIGINT) with FK to masterdata.container_type.container_type_id - tariff applicability rules frequently depend on container type',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Tariff applicability rules are customer-segment specific (customer_segment attribute). Shipping lines represent major customer segments with negotiated rates and service levels. Links to shipping line',
    `un_locode_id` BIGINT COMMENT 'Foreign key linking to masterdata.un_locode. Business justification: Applicability rules specify port_of_origin for trade lane-based tariff filtering. UN LOCODE provides standardized location references for origin/destination routing. Essential for trade lane tariff ap',
    `port_community_participant_id` BIGINT COMMENT 'Specific customer to which this tariff applies. Null if the rule applies to a segment or all customers. Enables customer-specific negotiated rates.',
    `port_tariff_id` BIGINT COMMENT 'Reference to the port tariff schedule that this applicability rule applies to. Links to the published tariff schedule containing base rates and charge structures.',
    `employee_id` BIGINT COMMENT 'Reference to the user who created this applicability rule record. Required for audit trail and data governance.',
    `rate_card_id` BIGINT COMMENT 'Reference to the negotiated rate card that this applicability rule applies to. Links to customer-specific or segment-specific rate cards with SLA-linked pricing.',
    `superseded_by_rule_applicability_id` BIGINT COMMENT 'Reference to the applicability rule that supersedes this one. Used for version control and historical tariff tracking.',
    `tertiary_applicability_modified_by_user_employee_id` BIGINT COMMENT 'Reference to the user who last modified this applicability rule record. Required for audit trail and change tracking.',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Applicability rules can target specific vessels (vessel_size_category, loa/grt ranges). Vessel master provides actual specifications for rule evaluation. Enables vessel-specific tariff exceptions, pre',
    `vessel_type_id` BIGINT COMMENT 'add column vessel_type_id (BIGINT) with FK to masterdata.vessel_type.vessel_type_id - tariff applicability rules frequently depend on vessel type classification',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Tariff applicability rules specify which security zones trigger which charges (e.g., wharfage applies only in customs-controlled zones, restricted area access fee applies in MARSEC 2+ zones). Bill',
    `applicability_status` STRING COMMENT 'Current lifecycle status of the applicability rule. Only active rules are used by the billing engine for tariff selection.. Valid values are `draft|pending_approval|active|suspended|expired|superseded`',
    `approval_required_flag` BOOLEAN COMMENT 'Indicates whether application of this tariff requires manual approval before billing. True for exceptional or high-value tariffs.',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when this applicability rule was approved. Required for audit trail and regulatory compliance.',
    `auto_apply_flag` BOOLEAN COMMENT 'Indicates whether this applicability rule is automatically applied by the billing engine or requires manual selection. True enables automated billing.',
    `conflict_resolution_order` STRING COMMENT 'Secondary ordering criterion for conflict resolution when multiple rules have the same priority. Used in conjunction with rule_priority for deterministic tariff selection.',
    `container_size_teu` DECIMAL(18,2) COMMENT 'Container size in TEU to which this tariff applies. Standard values are 1.0 for 20-foot and 2.0 for 40-foot containers. Used for volume-based pricing.',
    `container_type` STRING COMMENT 'Specific container type to which this tariff applies. Container type impacts handling charges, storage rates, and equipment requirements. [ENUM-REF-CANDIDATE: standard_20|standard_40|high_cube_40|reefer|tank|open_top|flat_rack|all_types — 8 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this applicability rule record was first created in the system. Required for audit trail and data lineage.',
    `dangerous_goods_class` STRING COMMENT 'IMDG dangerous goods classification to which this tariff applies. Dangerous goods require specialized handling and attract premium charges.. Valid values are `^(class_[1-9]|non_dg|all_classes)$`',
    `effective_from_date` DATE COMMENT 'Date from which this applicability rule becomes active. Used for temporal tariff management and billing period control.',
    `effective_to_date` DATE COMMENT 'Date until which this applicability rule remains active. Null indicates open-ended applicability. Used for tariff expiration and renewal management.',
    `exclusion_flag` BOOLEAN COMMENT 'Indicates whether this rule defines an exclusion (tariff does NOT apply) rather than an inclusion. Used for negative matching in complex tariff matrices.',
    `grt_max` DECIMAL(18,2) COMMENT 'Maximum gross registered tonnage for this tariff to apply. Null indicates no upper limit. Enables GRT-based tariff banding.',
    `grt_min` DECIMAL(18,2) COMMENT 'Minimum gross registered tonnage for this tariff to apply. GRT is used for port dues and regulatory fee calculation.',
    `loa_max_meters` DECIMAL(18,2) COMMENT 'Maximum vessel length overall in meters for this tariff to apply. Null indicates no upper limit. Used for vessel size-based tariff banding.',
    `loa_min_meters` DECIMAL(18,2) COMMENT 'Minimum vessel length overall in meters for this tariff to apply. LOA is a key dimension for berth allocation and wharfage calculation.',
    `load_status` STRING COMMENT 'Container load status to which this tariff applies. FCL (Full Container Load) and LCL (Less than Container Load) have different handling and pricing models.. Valid values are `fcl|lcl|empty|all_statuses`',
    `maximum_volume_teu` DECIMAL(18,2) COMMENT 'Maximum volume in TEU for this tariff to apply. Null indicates no upper limit. Used for volume-based tariff banding.',
    `minimum_volume_teu` DECIMAL(18,2) COMMENT 'Minimum committed volume in TEU for this tariff to apply. Used for volume-based discount tiers and contract enforcement.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this applicability rule record was last modified. Required for audit trail and change tracking.',
    `movement_type` STRING COMMENT 'Type of cargo movement to which this tariff applies. Movement type impacts handling complexity, documentation requirements, and pricing.. Valid values are `import|export|transshipment|empty_repositioning|all_movements`',
    `notes` STRING COMMENT 'Free-text notes providing additional context, special conditions, or business rationale for this applicability rule.',
    `port_of_destination` STRING COMMENT 'UN/LOCODE of the port of discharge to which this tariff applies. Null indicates applicability to all destination ports. Used for origin-destination pricing matrices.. Valid values are `^[A-Z]{5}$`',
    `rule_code` STRING COMMENT 'Unique business identifier for the applicability rule. Used for external reference and billing engine configuration.. Valid values are `^[A-Z0-9]{6,20}$`',
    `rule_name` STRING COMMENT 'Descriptive name for the applicability rule, summarizing the combination of dimensions it covers (e.g., Premium Container - Asia Trade Lane - Terminal A).',
    `rule_priority` STRING COMMENT 'Priority order for conflict resolution when multiple tariff applicability rules match a billable event. Lower numbers indicate higher priority. Used by billing engine to deterministically select the correct tariff.',
    `service_type` STRING COMMENT 'Type of port service to which this tariff applies. Service type determines the charge calculation method and billing rules. [ENUM-REF-CANDIDATE: thc|wharfage|pilotage|towage|storage|demurrage|detention|all_services — 8 candidates stripped; promote to reference product]',
    `sla_tier` STRING COMMENT 'SLA tier to which this tariff applies. SLA tier determines service commitments, performance targets, and premium pricing.. Valid values are `premium|standard|basic|all_tiers`',
    `terminal_zone` STRING COMMENT 'Specific terminal zone or berth area to which this tariff applies (e.g., Terminal A, Container Berth 1-3, Bulk Terminal). Terminal zone determines operational costs and service capabilities.',
    `trade_lane` STRING COMMENT 'Trade lane or route to which this tariff applies (e.g., Asia-Europe, Transpacific, Intra-Asia). Trade lane determines service levels, competitive positioning, and pricing strategies.',
    `vessel_size_category` STRING COMMENT 'Vessel size classification to which this tariff applies. Size category impacts berth allocation, crane requirements, and handling complexity.. Valid values are `feeder|panamax|post_panamax|new_panamax|ultra_large|all_sizes`',
    `vessel_type` STRING COMMENT 'Type of vessel to which this tariff applies. Vessel type determines applicable port services, berth requirements, and handling charges. [ENUM-REF-CANDIDATE: container|bulk_carrier|tanker|roro|general_cargo|cruise|naval|all_types — 8 candidates stripped; promote to reference product]',
    CONSTRAINT pk_applicability PRIMARY KEY(`applicability_id`)
) COMMENT 'Association entity defining the applicability matrix for tariff schedules and rate cards — specifying which tariff applies to which combination of customer segment, vessel type, cargo category, trade lane, terminal zone, and service type. Captures applicability rule priority, effective period, and conflict resolution order when multiple tariffs could apply. Enables the billing engine to deterministically select the correct tariff for any given billable event without ambiguity.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` (
    `currency_adjustment_id` BIGINT COMMENT 'Unique identifier for the currency adjustment factor record. Primary key for the currency adjustment entity.',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: CAF adjustments are tied to currency pairs and exchange rate movements between trading countries (base_currency_code, adjustment_currency_code). Country context determines applicable exchange rates, c',
    `port_tariff_id` BIGINT COMMENT 'add column port_tariff_id (BIGINT) with FK to tariff.port_tariff.port_tariff_id - CAF adjustments apply to specific tariff structures',
    `employee_id` BIGINT COMMENT 'Identifier of the user or authority who approved this CAF rate for publication and application. Critical for audit trail and accountability.',
    `superseded_by_caf_currency_adjustment_id` BIGINT COMMENT 'Reference to the newer CAF record that replaces this one. Enables time-series tracking of CAF rate evolution and historical rate reconstruction.',
    `tertiary_currency_modified_by_user_employee_id` BIGINT COMMENT 'Identifier of the user who last modified this CAF rate record. Supports change tracking and accountability.',
    `adjustment_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code representing the currency for which the adjustment factor is being applied to compensate for exchange rate fluctuations.. Valid values are `^[A-Z]{3}$`',
    `approval_status` STRING COMMENT 'The approval workflow status of the CAF rate record, indicating whether it has been reviewed and authorized by the appropriate tariff authority.. Valid values are `pending|approved|rejected|withdrawn`',
    `approval_timestamp` TIMESTAMP COMMENT 'The date and time when this CAF rate was officially approved. Establishes the point at which the rate became authorized for use.',
    `auto_apply_flag` BOOLEAN COMMENT 'Indicates whether this CAF should be automatically applied by the billing system to eligible charges, or requires manual application. True for automatic application.',
    `base_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code representing the base currency in which tariff rates are published (e.g., USD, EUR, SGD).. Valid values are `^[A-Z]{3}$`',
    `billing_system_code` STRING COMMENT 'The charge code or identifier used in the billing system (e.g., NAVIS N4, SAP) to apply this CAF to invoices. Enables system integration and automated billing.',
    `caf_code` STRING COMMENT 'Externally-known unique business identifier for the CAF rate record, used in tariff publications and billing system references.. Valid values are `^CAF-[A-Z0-9]{6,12}$`',
    `caf_name` STRING COMMENT 'Human-readable descriptive name for the CAF rate schedule, typically including currency pair and period reference.',
    `caf_percentage` DECIMAL(18,2) COMMENT 'The percentage surcharge or discount applied to base tariff rates to compensate for currency exchange rate fluctuations. Positive values represent surcharges, negative values represent discounts.',
    `calculation_basis` STRING COMMENT 'Defines the base amount to which the CAF percentage is applied: freight charges only, Terminal Handling Charges (THC) only, total charges, or base tariff rates.. Valid values are `freight_charge|thc_charge|total_charge|base_tariff`',
    `cargo_type_scope` STRING COMMENT 'Defines the cargo categories to which this CAF applies. Allows differentiated currency adjustments for different cargo handling operations. [ENUM-REF-CANDIDATE: all|containerized|breakbulk|liquid_bulk|dry_bulk|roro|general_cargo — 7 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this CAF rate record was first created in the system. Critical for audit trail and data lineage.',
    `currency_adjustment_status` STRING COMMENT 'Current lifecycle status of the CAF rate record indicating whether it is in draft, awaiting approval, actively applied to billing, temporarily suspended, expired, or superseded by a newer rate.. Valid values are `draft|pending_approval|active|suspended|expired|superseded`',
    `current_exchange_rate` DECIMAL(18,2) COMMENT 'The current market exchange rate at the time of CAF calculation or publication. Used in conjunction with reference rate to determine adjustment percentage.',
    `customer_tier_scope` STRING COMMENT 'Defines the customer segments or tiers to which this CAF applies. Allows differentiated currency adjustments based on customer relationship and volume commitments. [ENUM-REF-CANDIDATE: all|tier_1|tier_2|tier_3|premium|standard|spot — 7 candidates stripped; promote to reference product]',
    `dispute_resolution_terms` STRING COMMENT 'Contractual terms and procedures for resolving disputes related to CAF application, including arbitration clauses and escalation processes.',
    `effective_from_date` DATE COMMENT 'The date from which this CAF rate becomes applicable to vessel calls and cargo movements. Aligns with tariff publication cycles and regulatory filing requirements.',
    `effective_to_date` DATE COMMENT 'The date until which this CAF rate remains valid. Nullable for open-ended rates that remain in effect until superseded.',
    `exchange_rate_date` DATE COMMENT 'The date on which the current exchange rate was captured or fixed for CAF calculation purposes. Critical for audit trail and dispute resolution.',
    `exchange_rate_reference` STRING COMMENT 'The source or benchmark exchange rate used to calculate the CAF percentage (e.g., Central Bank rate, OANDA average, Bloomberg fixing). Provides transparency for rate justification.',
    `maximum_caf_amount` DECIMAL(18,2) COMMENT 'The maximum absolute currency adjustment amount that can be charged, capping exposure for large transactions. Provides cost predictability for customers.',
    `minimum_caf_amount` DECIMAL(18,2) COMMENT 'The minimum absolute currency adjustment amount that will be charged, regardless of calculated percentage. Ensures administrative costs are covered for small transactions.',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time when this CAF rate record was last modified. Enables change tracking and audit compliance.',
    `notes` STRING COMMENT 'Free-text field for additional comments, special conditions, or contextual information about this CAF rate that does not fit structured fields.',
    `notice_period_days` STRING COMMENT 'The number of days advance notice provided to customers before this CAF becomes effective. Ensures compliance with contractual and regulatory notice requirements.',
    `publication_date` DATE COMMENT 'The date on which this CAF rate was officially published or announced to customers and stakeholders. Establishes notice period compliance.',
    `publication_reference` STRING COMMENT 'Reference to the official tariff publication, circular, or notice in which this CAF was announced. Critical for regulatory compliance and customer communication.',
    `reference_exchange_rate` DECIMAL(18,2) COMMENT 'The baseline exchange rate used as the reference point for calculating currency adjustment. Deviations from this rate trigger CAF adjustments.',
    `regulatory_approval_date` DATE COMMENT 'The date on which regulatory authorities approved this CAF rate for implementation. Required for jurisdictions with mandatory tariff approval processes.',
    `regulatory_filing_reference` STRING COMMENT 'Reference number or identifier for the regulatory filing submission if this CAF required government or port authority approval.',
    `regulatory_filing_required_flag` BOOLEAN COMMENT 'Indicates whether this CAF rate must be filed with port authorities or regulatory bodies before implementation. True if regulatory approval is mandatory.',
    `service_type_scope` STRING COMMENT 'Specifies the port services to which this CAF applies, such as container handling, wharfage, pilotage, or all services. Enables selective application of currency adjustments.',
    `trade_lane_scope` STRING COMMENT 'Defines the geographic trade lanes or routes to which this CAF applies (e.g., Asia-Europe, Transpacific, Intra-Asia). May be ALL for global application or specific lane codes.',
    `version_number` STRING COMMENT 'Sequential version number for this CAF rate schedule. Increments with each revision to support change tracking and audit requirements.',
    `vessel_category_scope` STRING COMMENT 'Specifies the vessel types or size categories to which this CAF applies (e.g., container vessels, bulk carriers, tankers, all vessels). Enables vessel-specific currency adjustments.',
    CONSTRAINT pk_currency_adjustment PRIMARY KEY(`currency_adjustment_id`)
) COMMENT 'CAF (Currency Adjustment Factor) rate record defining the periodic currency surcharge applied to base tariff rates to compensate for exchange rate fluctuations. Captures the applicable currency pair, CAF percentage, effective period, calculation base (percentage of freight or THC), trade lane scope, and publication reference. Managed as a time-series of CAF adjustments enabling historical rate reconstruction for billing disputes and audit.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` (
    `bunker_adjustment_id` BIGINT COMMENT 'Unique identifier for the bunker adjustment factor record. Primary key.',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: BAF rates vary by bunker fuel pricing regions. Country/region determines applicable fuel index, pricing zone, and adjustment calculation methodology. Links to country master for region-based BAF appli',
    `port_tariff_id` BIGINT COMMENT 'add column port_tariff_id (BIGINT) with FK to tariff.port_tariff.port_tariff_id - BAF adjustments apply to specific tariff structures',
    `employee_id` BIGINT COMMENT 'Identifier of the user or system account that created this BAF record.',
    `superseded_by_baf_bunker_adjustment_id` BIGINT COMMENT 'Reference to the bunker_adjustment_id of the BAF record that supersedes this one, enabling time-series tracking. Nullable if current.',
    `applicable_service_types` STRING COMMENT 'Comma-separated list of port service types to which this BAF applies (e.g., THC, wharfage, pilotage, towage, all services).',
    `approval_authority` STRING COMMENT 'Name or role of the authority that approved this BAF rate (e.g., Port Director, Tariff Committee, Regulatory Commission).',
    `approval_date` DATE COMMENT 'Date on which this BAF rate was formally approved by the designated authority.',
    `approval_reference_number` STRING COMMENT 'Official reference number or document identifier associated with the approval of this BAF rate.',
    `baf_code` STRING COMMENT 'Unique business identifier code for the BAF rate record, used for external reference and publication.. Valid values are `^BAF-[A-Z0-9]{6,12}$`',
    `baf_name` STRING COMMENT 'Descriptive name of the bunker adjustment factor rate, typically including the applicable period and scope.',
    `baf_rate_amount` DECIMAL(18,2) COMMENT 'The monetary value of the BAF surcharge. Interpretation depends on calculation_method (e.g., USD per TEU for flat rates, percentage value for percentage-based).',
    `baf_type` STRING COMMENT 'Classification of the BAF rate based on its purpose and application scope (standard, emergency, seasonal, trade lane specific, vessel specific, temporary).. Valid values are `standard|emergency|seasonal|trade_lane_specific|vessel_specific|temporary`',
    `bunker_adjustment_status` STRING COMMENT 'Current lifecycle status of the BAF rate record (draft, pending approval, approved, active, suspended, expired, superseded). [ENUM-REF-CANDIDATE: draft|pending_approval|approved|active|suspended|expired|superseded — 7 candidates stripped; promote to reference product]',
    `calculation_method` STRING COMMENT 'Method used to calculate the BAF charge: flat rate per TEU, flat rate per FEU, percentage of base tariff rate, tiered structure, or custom formula.. Valid values are `flat_per_teu|flat_per_feu|percentage_of_base|tiered|formula_based`',
    `cargo_type_applicability` STRING COMMENT 'Comma-separated list of cargo types to which this BAF applies (e.g., FCL, LCL, breakbulk, bulk, liquid, all types).',
    `container_type_applicability` STRING COMMENT 'Comma-separated list of container types to which this BAF applies (e.g., standard, reefer, dangerous goods, oversized, all types).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this BAF record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which the BAF rate is denominated (e.g., USD, EUR, SGD).. Valid values are `^[A-Z]{3}$`',
    `customer_tier_eligibility` STRING COMMENT 'Comma-separated list of customer tiers or segments to which this BAF applies (e.g., tier_1, tier_2, tier_3, all_customers).',
    `dwt_band_max` DECIMAL(18,2) COMMENT 'Maximum Deadweight Tonnage (DWT) for which this BAF rate applies. Nullable if no maximum.',
    `dwt_band_min` DECIMAL(18,2) COMMENT 'Minimum Deadweight Tonnage (DWT) for which this BAF rate applies. Nullable if no minimum.',
    `effective_from_date` DATE COMMENT 'Date from which this BAF rate becomes applicable and enforceable for billing purposes.',
    `effective_to_date` DATE COMMENT 'Date until which this BAF rate remains valid. Nullable for open-ended rates.',
    `exemption_conditions` STRING COMMENT 'Description of conditions under which customers or transactions may be exempt from this BAF surcharge.',
    `fuel_index_reference` STRING COMMENT 'The fuel price index or benchmark used as the basis for calculating the BAF rate (e.g., Platts Singapore, MOPS, IFO380, VLSFO, MGO, Brent, WTI, or custom index). [ENUM-REF-CANDIDATE: platts|mops|ifo380|vlsfo|mgo|brent|wti|custom — 8 candidates stripped; promote to reference product]',
    `fuel_index_value` DECIMAL(18,2) COMMENT 'The actual fuel price index value (in USD per metric ton or other unit) at the time of BAF calculation or publication.',
    `grt_band_max` DECIMAL(18,2) COMMENT 'Maximum Gross Registered Tonnage (GRT) for which this BAF rate applies. Nullable if no maximum.',
    `grt_band_min` DECIMAL(18,2) COMMENT 'Minimum Gross Registered Tonnage (GRT) for which this BAF rate applies. Nullable if no minimum.',
    `loa_band_max_meters` DECIMAL(18,2) COMMENT 'Maximum vessel length overall (LOA) in meters for which this BAF rate applies. Nullable if no maximum.',
    `loa_band_min_meters` DECIMAL(18,2) COMMENT 'Minimum vessel length overall (LOA) in meters for which this BAF rate applies. Nullable if no minimum.',
    `maximum_charge_amount` DECIMAL(18,2) COMMENT 'Maximum charge amount cap for the BAF surcharge. Nullable if no cap applies.',
    `minimum_charge_amount` DECIMAL(18,2) COMMENT 'Minimum charge amount that will be applied regardless of calculated BAF value. Nullable if no minimum.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this BAF record was last modified.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next review of this BAF rate.',
    `notes` STRING COMMENT 'Additional notes, comments, or special instructions related to this BAF rate record.',
    `publication_authority` STRING COMMENT 'Name of the authority or organization that published or mandated this BAF rate (e.g., port authority, shipping line consortium, regulatory body).',
    `publication_date` DATE COMMENT 'Date on which this BAF rate was officially published or announced to stakeholders.',
    `rate_unit_of_measure` STRING COMMENT 'Unit of measure for the BAF rate (per TEU, per FEU, per container, per ton, per CBM, percentage, per vessel call). [ENUM-REF-CANDIDATE: per_teu|per_feu|per_container|per_ton|per_cbm|percentage|per_vessel_call — 7 candidates stripped; promote to reference product]',
    `regulatory_filing_reference` STRING COMMENT 'Reference number or identifier of the regulatory filing associated with this BAF rate, if applicable.',
    `regulatory_filing_required_flag` BOOLEAN COMMENT 'Indicates whether this BAF rate requires filing with a regulatory authority (True) or not (False).',
    `review_frequency` STRING COMMENT 'Frequency at which this BAF rate is reviewed and potentially updated (monthly, quarterly, semi-annual, annual, event-driven, continuous).. Valid values are `monthly|quarterly|semi_annual|annual|event_driven|continuous`',
    `trade_lane_scope` STRING COMMENT 'Comma-separated list or description of trade lanes to which this BAF applies (e.g., Asia-Europe, Transpacific, Intra-Asia, All Lanes).',
    `version_number` STRING COMMENT 'Version number of this BAF rate record, incremented with each revision to support historical tracking.',
    `vessel_size_category` STRING COMMENT 'Vessel size category to which this BAF applies (feeder, Panamax, Post-Panamax, New Panamax, Suezmax, Ultra Large, all sizes). [ENUM-REF-CANDIDATE: feeder|panamax|post_panamax|new_panamax|suezmax|ultra_large|all_sizes — 7 candidates stripped; promote to reference product]',
    `vessel_type_applicability` STRING COMMENT 'Comma-separated list of vessel types to which this BAF applies (e.g., container, bulk, tanker, RoRo, general cargo, all types).',
    CONSTRAINT pk_bunker_adjustment PRIMARY KEY(`bunker_adjustment_id`)
) COMMENT 'BAF (Bunker Adjustment Factor) rate record defining the periodic fuel surcharge applied to port and shipping tariffs to compensate for bunker fuel price volatility. Captures BAF rate, applicable fuel index reference (Platts, MOPS), effective period, trade lane scope, vessel type applicability, calculation method (flat per TEU or percentage of base rate), and publication authority. Maintained as a time-series enabling accurate historical charge reconstruction.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` (
    `negotiation_id` BIGINT COMMENT 'Unique identifier for the tariff or rate negotiation record. Primary key.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Tariff negotiations culminate in binding agreements. The negotiation process tracks commercial discussions that result in formal agreements governing negotiated rates. Critical for commercial negotiat',
    `counter_negotiation_id` BIGINT COMMENT 'Self-referencing FK on negotiation (counter_negotiation_id)',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Commercial negotiations occur with shipping line customers for volume-based discounts, SLA-linked pricing, and service commitments. Links negotiation records to customer master for contract lifecycle ',
    `participant_account_id` BIGINT COMMENT 'add column participant_account_id (BIGINT) with FK to customer.participant_account.participant_account_id - tariff negotiations are conducted with a specific customer account',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the customer (shipping line, cargo owner, terminal operator) involved in this negotiation.',
    `employee_id` BIGINT COMMENT 'Reference to the user who provided final approval for this negotiation.',
    `rate_card_id` BIGINT COMMENT 'Reference to the rate card created as a result of this successful negotiation.',
    `tertiary_negotiation_modified_by_user_employee_id` BIGINT COMMENT 'Reference to the user who last modified this negotiation record.',
    `approval_authority_level` STRING COMMENT 'Level of authority required to approve this negotiation based on materiality and deviation from standard terms.. Valid values are `commercial_manager|head_of_commercial|cfo|ceo|board`',
    `approval_date` DATE COMMENT 'Date when the negotiation was formally approved by the designated authority.',
    `approval_required_flag` BOOLEAN COMMENT 'Indicates whether this negotiation requires formal approval from senior management or commercial committee.',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the negotiated agreement automatically renews at expiry unless terminated.',
    `cargo_type` STRING COMMENT 'Type of cargo covered by this negotiation (e.g., containerized, bulk, breakbulk, RoRo, liquid bulk).',
    `commercial_justification` STRING COMMENT 'Detailed business rationale and justification for the proposed rates and terms, including competitive analysis and strategic considerations.',
    `commitment_period_months` STRING COMMENT 'Duration in months for which the volume or revenue commitment applies.',
    `competitor_benchmark_rate` DECIMAL(18,2) COMMENT 'Competitive benchmark rate from rival ports used as reference during negotiation.',
    `confidentiality_level` STRING COMMENT 'Classification of the confidentiality level for this negotiation and its terms.. Valid values are `public|internal|confidential|highly_confidential`',
    `container_type` STRING COMMENT 'Specific container type applicable to this negotiation if service is container-related.. Valid values are `standard|reefer|tank|flat_rack|open_top|high_cube`',
    `counter_offer_rate_amount` DECIMAL(18,2) COMMENT 'The counter-offer rate amount proposed by the customer in response to the ports proposal.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this negotiation record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this negotiation.. Valid values are `^[A-Z]{3}$`',
    `customer_segment` STRING COMMENT 'Segmentation tier of the customer for pricing and service differentiation purposes.. Valid values are `tier_1|tier_2|tier_3|strategic|transactional|spot`',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Percentage discount from standard tariff rates being negotiated.',
    `effective_from_date` DATE COMMENT 'Date from which the negotiated rates and terms become effective.',
    `effective_to_date` DATE COMMENT 'Date until which the negotiated rates and terms remain valid.',
    `escalation_clause` STRING COMMENT 'Description of any rate escalation mechanism agreed upon (e.g., CPI-linked, fuel-indexed, annual percentage increase).',
    `final_agreed_rate_amount` DECIMAL(18,2) COMMENT 'The final rate amount agreed upon by both parties after negotiation completion.',
    `initiated_date` DATE COMMENT 'Date when the negotiation was formally initiated.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this negotiation record was last updated.',
    `negotiation_status` STRING COMMENT 'Current lifecycle status of the negotiation process. [ENUM-REF-CANDIDATE: draft|in_progress|under_review|approved|rejected|withdrawn|completed|superseded — 8 candidates stripped; promote to reference product]',
    `negotiation_type` STRING COMMENT 'Classification of the negotiation based on its purpose and scope. [ENUM-REF-CANDIDATE: new_contract|renewal|amendment|exception|volume_discount|sla_linked|ad_hoc — 7 candidates stripped; promote to reference product]',
    `notes` STRING COMMENT 'Free-text notes capturing key discussion points, customer concerns, and negotiation dynamics throughout the process.',
    `notice_period_days` STRING COMMENT 'Number of days advance notice required for termination or material changes to the agreement.',
    `payment_terms_days` STRING COMMENT 'Number of days allowed for payment after invoice date as negotiated.',
    `penalty_clause_description` STRING COMMENT 'Description of penalties applicable if committed volumes or service levels are not met.',
    `premium_percentage` DECIMAL(18,2) COMMENT 'Percentage premium above standard tariff rates being negotiated for enhanced service levels.',
    `proposed_rate_amount` DECIMAL(18,2) COMMENT 'The rate amount proposed by the port in the current negotiation round.',
    `rate_unit_of_measure` STRING COMMENT 'Unit of measure for the negotiated rate (e.g., per TEU, per GRT, per move, per hour, per tonne).',
    `reference_number` STRING COMMENT 'Business-facing unique reference number assigned to this negotiation for tracking and communication purposes.',
    `revenue_commitment_amount` DECIMAL(18,2) COMMENT 'Minimum revenue commitment amount offered by the customer over the contract period.',
    `risk_assessment` STRING COMMENT 'Assessment of commercial risk associated with the negotiated terms (e.g., revenue impact, customer credit risk, volume uncertainty).. Valid values are `low|medium|high|critical`',
    `round` STRING COMMENT 'Sequential counter indicating the current round of negotiation (1 for initial proposal, incremented for each counter-offer cycle).',
    `service_type` STRING COMMENT 'Type of port service being negotiated (e.g., THC, wharfage, pilotage, demurrage, storage, detention).',
    `sla_tier` STRING COMMENT 'Service level tier associated with the negotiated rates, defining performance commitments.. Valid values are `standard|premium|platinum|express`',
    `termination_clause` STRING COMMENT 'Terms and conditions under which either party may terminate the negotiated agreement.',
    `trade_lane` STRING COMMENT 'Specific trade lane or route to which the negotiated rates apply.',
    `volume_commitment_teu` DECIMAL(18,2) COMMENT 'Minimum volume commitment in TEU offered by the customer as part of the negotiation terms.',
    CONSTRAINT pk_negotiation PRIMARY KEY(`negotiation_id`)
) COMMENT 'Record of a tariff or rate negotiation between the port and a customer (shipping line, cargo owner, terminal operator). Captures negotiation reference, parties involved, proposed rates, counter-offers, negotiation rounds, commercial justification, volume commitments offered, final agreed terms, and link to resulting rate card or exception. Provides audit trail for how commercial pricing decisions were reached and supports internal governance review.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` (
    `tariff_version_id` BIGINT COMMENT 'Unique identifier for the tariff version record. Primary key for the tariff version entity.',
    `port_tariff_id` BIGINT COMMENT 'Reference to the parent tariff schedule that this version belongs to. Links to the master tariff schedule entity.',
    `primary_superseded_by_version_id` BIGINT COMMENT 'Reference to the tariff version that replaced this version. Enables forward navigation through version history and supports audit trail reconstruction.',
    `approval_authority` STRING COMMENT 'Name of the regulatory body, port authority board, or executive authority that approved this tariff version (e.g., National Maritime Safety Authority, Port Authority Board, Chief Commercial Officer).',
    `approval_date` DATE COMMENT 'Date when this tariff version received formal approval from the designated authority (regulatory body, port authority board, or management).',
    `approval_reference_number` STRING COMMENT 'Official reference number or filing identifier assigned by the approval authority. Used for regulatory compliance tracking and audit trail.',
    `change_category` STRING COMMENT 'Primary category of change represented by this version. Enables classification and analysis of tariff evolution patterns.. Valid values are `rate_increase|rate_decrease|new_service|service_removal|policy_change|correction`',
    `change_summary` STRING COMMENT 'Comprehensive narrative description of changes introduced in this version. Details rate adjustments, new services added, discontinued services, policy modifications, and rationale for changes.',
    `consultation_end_date` DATE COMMENT 'Date when the public consultation period closed for this tariff version. Null if no consultation was required.',
    `consultation_start_date` DATE COMMENT 'Date when the public consultation period began for this tariff version. Null if no consultation was required.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this tariff version record was first created in the system. Distinct from draft_date which represents business event timing.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the estimated revenue impact amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `document_reference` STRING COMMENT 'Reference identifier or URI to the official tariff document (PDF, legal text, gazette publication) associated with this version. Enables retrieval of the authoritative source document.',
    `draft_date` DATE COMMENT 'Date when this tariff version was initially drafted and entered into the version control system.',
    `effective_date` DATE COMMENT 'Date from which this tariff version becomes legally binding and applicable to all port services and transactions. Critical for billing system cutover and retroactive billing corrections.',
    `effective_time` TIMESTAMP COMMENT 'Precise timestamp when this tariff version becomes effective. Used when tariff changes must take effect at a specific time (e.g., midnight UTC, start of business day).',
    `estimated_revenue_impact_amount` DECIMAL(18,2) COMMENT 'Projected annual revenue impact of this tariff version in the ports base currency. Positive values indicate revenue increase, negative values indicate decrease.',
    `expiry_date` DATE COMMENT 'Date when this tariff version ceases to be valid and is superseded by a newer version. Null for currently active versions with no planned end date.',
    `impact_assessment_completed` BOOLEAN COMMENT 'Indicates whether a formal business impact assessment was conducted for this tariff version. True for major changes requiring financial and operational impact analysis.',
    `legal_review_completed` BOOLEAN COMMENT 'Indicates whether this tariff version underwent formal legal review for compliance with maritime law, competition law, and contractual obligations.',
    `legal_reviewer_name` STRING COMMENT 'Name of the legal counsel or legal department representative who reviewed and approved this tariff version for legal compliance.',
    `modified_by` STRING COMMENT 'Username or identifier of the system user who last modified this tariff version record. Supports audit trail and change tracking.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this tariff version record was last modified in the system. Tracks the most recent update to any field in the record.',
    `notes` STRING COMMENT 'Additional free-text notes, comments, or internal documentation related to this tariff version. Captures context not covered by structured fields.',
    `notice_period_days` STRING COMMENT 'Number of days advance notice provided between publication and effective date. Ensures compliance with regulatory requirements for stakeholder notification (typically 30-90 days).',
    `public_consultation_required` BOOLEAN COMMENT 'Indicates whether this tariff version required a public consultation period before approval. True for major tariff changes affecting broad stakeholder groups.',
    `publication_channel` STRING COMMENT 'Comma-separated list of channels through which this tariff version was published (e.g., Official Gazette, Port Website, PCS EDI Broadcast, Customer Portal). Supports compliance with notification requirements.',
    `publication_date` DATE COMMENT 'Date when this tariff version was officially published and made available to stakeholders through designated channels (gazette, website, Port Community System).',
    `regulatory_filing_date` DATE COMMENT 'Date when this tariff version was formally filed with the regulatory authority. Required for compliance tracking when regulatory_filing_required is true.',
    `regulatory_filing_reference` STRING COMMENT 'Official filing reference number or docket number assigned by the regulatory authority. Used for compliance documentation and audit purposes.',
    `regulatory_filing_required` BOOLEAN COMMENT 'Indicates whether this tariff version required formal filing with a regulatory authority. True for versions subject to government oversight, false for internal commercial adjustments.',
    `retroactive_billing_allowed` BOOLEAN COMMENT 'Indicates whether this tariff version permits retroactive billing corrections for transactions that occurred before the effective date. Critical for billing system processing rules.',
    `retroactive_period_days` STRING COMMENT 'Maximum number of days prior to the effective date for which retroactive billing adjustments are permitted. Null if retroactive billing is not allowed.',
    `stakeholder_feedback_summary` STRING COMMENT 'Summary of stakeholder comments, objections, and feedback received during consultation period. Documents key concerns and how they were addressed in the final version.',
    `submission_date` DATE COMMENT 'Date when this tariff version was formally submitted for regulatory approval or internal authorization.',
    `superseded_date` DATE COMMENT 'Actual date when this tariff version was replaced by a subsequent version. May differ from planned expiry_date if emergency changes were implemented.',
    `version_name` STRING COMMENT 'Descriptive name or title for this tariff version (e.g., Q1 2024 Rate Adjustment, Annual Tariff Update 2024, Emergency Fuel Surcharge Amendment).',
    `version_number` STRING COMMENT 'Sequential version number for the tariff schedule (e.g., 1.0, 1.1, 2.0). Follows semantic versioning convention where major changes increment the integer and minor amendments increment the decimal.. Valid values are `^[0-9]+.[0-9]+$`',
    `version_status` STRING COMMENT 'Current lifecycle status of the tariff version. Tracks progression from draft through approval, publication, activation, and eventual supersession or withdrawal. [ENUM-REF-CANDIDATE: draft|pending_approval|approved|published|active|superseded|withdrawn|archived — 8 candidates stripped; promote to reference product]',
    `version_type` STRING COMMENT 'Classification of the version change type. Distinguishes between initial publication, routine amendments, major revisions, emergency adjustments, regulatory-mandated changes, and annual updates.. Valid values are `initial|amendment|revision|emergency|regulatory|annual`',
    `withdrawal_date` DATE COMMENT 'Date when this tariff version was formally withdrawn. Null for versions that were never withdrawn.',
    `withdrawal_reason` STRING COMMENT 'Explanation for why this tariff version was withdrawn before or after its effective date. Documents regulatory objections, legal challenges, or business decisions to retract the version.',
    `created_by` STRING COMMENT 'Username or identifier of the system user who created this tariff version record. Supports audit trail and accountability.',
    CONSTRAINT pk_tariff_version PRIMARY KEY(`tariff_version_id`)
) COMMENT 'Version control record for port tariff schedules, capturing the full history of tariff revisions, amendments, and regulatory approvals. Each record represents a specific version of a tariff schedule with its publication date, effective date, superseded date, change summary, regulatory filing reference, approval authority, and publication channel (gazette, EDI, PCS). Enables full tariff audit trail and supports retroactive billing corrections.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` (
    `tariff_filing_id` BIGINT COMMENT 'Unique identifier for the tariff filing record. Primary key for the tariff filing entity.',
    `compliance_audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Tariff filings subject to regulatory audits for compliance with published rates and anti-competitive practices. Regulatory oversight process by port authorities and competition regulators.',
    `port_tariff_id` BIGINT COMMENT 'Reference to the port tariff schedule being filed with the regulatory authority.',
    `primary_superseded_by_filing_id` BIGINT COMMENT 'Reference to the subsequent tariff filing that supersedes this filing, creating a version history chain.',
    `employee_id` BIGINT COMMENT 'Identifier of the user who created the initial tariff filing record.',
    `tariff_filing_employee_id` BIGINT COMMENT 'Identifier of the port authority user who submitted the tariff filing to the regulator.',
    `tariff_filing_modified_by_user_employee_id` BIGINT COMMENT 'Identifier of the user who last modified the tariff filing record.',
    `tariff_filing_withdrawn_by_user_employee_id` BIGINT COMMENT 'Identifier of the port authority user who initiated the withdrawal of the tariff filing.',
    `tariff_superseded_filing_id` BIGINT COMMENT 'Self-referencing FK on filing (superseded_filing_id)',
    `approval_date` DATE COMMENT 'Date when the regulatory authority formally approved the tariff filing, granting permission for the tariff to take effect.',
    `approval_status` STRING COMMENT 'Final decision status from the regulatory authority on the tariff filing, indicating approval, conditional approval, rejection, or withdrawal.. Valid values are `pending|approved|approved_with_conditions|rejected|withdrawn`',
    `approval_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the regulatory authority approved the tariff filing, including time zone information.',
    `approved_by_authority_officer` STRING COMMENT 'Name and title of the regulatory authority officer who signed off on the tariff filing approval.',
    `audit_trail_reference` STRING COMMENT 'Reference identifier to the complete audit trail of all actions, reviews, and decisions related to this tariff filing.',
    `conditions_imposed` STRING COMMENT 'Specific conditions, restrictions, or requirements imposed by the regulatory authority as part of the tariff approval.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the tariff filing record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for monetary amounts in the tariff filing.. Valid values are `^[A-Z]{3}$`',
    `document_reference` STRING COMMENT 'Reference identifier or file path to the official tariff filing document submitted to the regulatory authority.',
    `effective_date_granted` DATE COMMENT 'Date granted by the regulatory authority when the approved tariff is authorized to take effect and be applied to port services.',
    `estimated_revenue_impact_amount` DECIMAL(18,2) COMMENT 'Projected annual revenue impact of the proposed tariff changes, used in regulatory impact assessment.',
    `expiry_date_granted` DATE COMMENT 'Date when the approved tariff expires and must be renewed or refiled, as specified by the regulatory authority.',
    `filing_status` STRING COMMENT 'Current status of the tariff filing in the regulatory approval lifecycle, from draft preparation through final approval or rejection. [ENUM-REF-CANDIDATE: draft|submitted|under_review|public_consultation|approved|rejected|withdrawn — 7 candidates stripped; promote to reference product]',
    `filing_type` STRING COMMENT 'Classification of the tariff filing indicating whether it is a new tariff, amendment to existing tariff, full revision, withdrawal, or emergency filing.. Valid values are `new_tariff|tariff_amendment|tariff_revision|tariff_withdrawal|emergency_filing`',
    `gazette_publication_date` DATE COMMENT 'Date when the approved tariff was published in the official government gazette or public registry, making it legally effective.',
    `gazette_reference_number` STRING COMMENT 'Official reference number or citation of the gazette publication where the approved tariff was published.',
    `impact_assessment_completed_flag` BOOLEAN COMMENT 'Indicates whether a regulatory impact assessment was completed and submitted as part of the tariff filing.',
    `legal_review_completed_flag` BOOLEAN COMMENT 'Indicates whether internal legal review was completed before submitting the tariff filing to the regulatory authority.',
    `legal_review_date` DATE COMMENT 'Date when the internal legal review of the tariff filing was completed and approved for submission.',
    `legal_reviewer_name` STRING COMMENT 'Name of the legal counsel or compliance officer who reviewed the tariff filing for regulatory compliance.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the tariff filing record was last modified or updated.',
    `notes` STRING COMMENT 'Additional notes, comments, or observations related to the tariff filing process, regulatory interactions, or special circumstances.',
    `notice_period_days` STRING COMMENT 'Number of days advance notice required between approval and effective date, allowing stakeholders to prepare for tariff changes.',
    `public_comment_count` STRING COMMENT 'Total number of public comments or submissions received during the consultation period from stakeholders.',
    `public_consultation_end_date` DATE COMMENT 'Date when the public consultation period closes and no further stakeholder comments will be accepted.',
    `public_consultation_required_flag` BOOLEAN COMMENT 'Indicates whether the tariff filing requires a public consultation period for stakeholder feedback before approval.',
    `public_consultation_start_date` DATE COMMENT 'Date when the public consultation period begins, allowing stakeholders to submit comments on the proposed tariff.',
    `reference_number` STRING COMMENT 'Official reference number assigned by the port regulator or maritime authority upon submission of the tariff filing.',
    `regulatory_authority` STRING COMMENT 'Name of the port regulator or maritime authority responsible for reviewing and approving the tariff filing.',
    `regulatory_authority_contact` STRING COMMENT 'Contact information for the regulatory authority case officer or department handling the tariff filing.',
    `rejection_reason` STRING COMMENT 'Detailed explanation provided by the regulatory authority for rejecting the tariff filing, including specific deficiencies or non-compliance issues.',
    `stakeholder_feedback_summary` STRING COMMENT 'Summary of key themes, concerns, and recommendations raised by stakeholders during the public consultation period.',
    `submission_date` DATE COMMENT 'Date when the tariff filing was formally submitted to the port regulator or maritime authority for review and approval.',
    `submission_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the tariff filing was submitted to the regulatory authority, including time zone information.',
    `supporting_documentation_reference` STRING COMMENT 'Reference to supporting documents submitted with the filing, such as cost justifications, impact assessments, or stakeholder consultation records.',
    `withdrawal_date` DATE COMMENT 'Date when the tariff filing was withdrawn by the port authority before regulatory approval was granted.',
    `withdrawal_reason` STRING COMMENT 'Explanation for why the tariff filing was withdrawn, such as business decision change, stakeholder opposition, or regulatory feedback.',
    CONSTRAINT pk_tariff_filing PRIMARY KEY(`tariff_filing_id`)
) COMMENT 'Regulatory filing and gazette publication record for port tariff schedules. Captures the submission to the port regulator or maritime authority, filing reference number, gazette publication date, public comment period, approval status, conditions imposed, and effective date granted. Tracks the full regulatory lifecycle from draft submission through public consultation to final approval. Required for compliance with port pricing regulations and enables audit of tariff legitimacy.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ADD CONSTRAINT `fk_tariff_port_tariff_superseded_by_tariff_port_tariff_id` FOREIGN KEY (`superseded_by_tariff_port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_demurrage_schedule_id` FOREIGN KEY (`demurrage_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule`(`demurrage_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_detention_schedule_id` FOREIGN KEY (`detention_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`detention_schedule`(`detention_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_mooring_tariff_id` FOREIGN KEY (`mooring_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff`(`mooring_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_pilotage_tariff_id` FOREIGN KEY (`pilotage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff`(`pilotage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_port_dues_schedule_id` FOREIGN KEY (`port_dues_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule`(`port_dues_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_storage_tariff_id` FOREIGN KEY (`storage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`storage_tariff`(`storage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_thc_schedule_id` FOREIGN KEY (`thc_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`thc_schedule`(`thc_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_towage_tariff_id` FOREIGN KEY (`towage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`towage_tariff`(`towage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_wharfage_schedule_id` FOREIGN KEY (`wharfage_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule`(`wharfage_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_superseded_by_rate_card_id` FOREIGN KEY (`superseded_by_rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ADD CONSTRAINT `fk_tariff_rate_card_line_bunker_adjustment_id` FOREIGN KEY (`bunker_adjustment_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment`(`bunker_adjustment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ADD CONSTRAINT `fk_tariff_rate_card_line_currency_adjustment_id` FOREIGN KEY (`currency_adjustment_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment`(`currency_adjustment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ADD CONSTRAINT `fk_tariff_rate_card_line_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ADD CONSTRAINT `fk_tariff_rate_card_line_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ADD CONSTRAINT `fk_tariff_thc_schedule_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ADD CONSTRAINT `fk_tariff_thc_schedule_supersedes_schedule_thc_schedule_id` FOREIGN KEY (`supersedes_schedule_thc_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`thc_schedule`(`thc_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ADD CONSTRAINT `fk_tariff_wharfage_schedule_superseded_by_schedule_wharfage_schedule_id` FOREIGN KEY (`superseded_by_schedule_wharfage_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule`(`wharfage_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ADD CONSTRAINT `fk_tariff_pilotage_tariff_superseded_by_tariff_pilotage_tariff_id` FOREIGN KEY (`superseded_by_tariff_pilotage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff`(`pilotage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ADD CONSTRAINT `fk_tariff_storage_tariff_superseded_by_tariff_storage_tariff_id` FOREIGN KEY (`superseded_by_tariff_storage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`storage_tariff`(`storage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ADD CONSTRAINT `fk_tariff_demurrage_schedule_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ADD CONSTRAINT `fk_tariff_detention_schedule_superseded_by_schedule_detention_schedule_id` FOREIGN KEY (`superseded_by_schedule_detention_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`detention_schedule`(`detention_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ADD CONSTRAINT `fk_tariff_surcharge_rule_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ADD CONSTRAINT `fk_tariff_surcharge_rule_superseded_by_rule_surcharge_rule_id` FOREIGN KEY (`superseded_by_rule_surcharge_rule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule`(`surcharge_rule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ADD CONSTRAINT `fk_tariff_discount_scheme_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ADD CONSTRAINT `fk_tariff_sla_rate_card_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ADD CONSTRAINT `fk_tariff_exception_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ADD CONSTRAINT `fk_tariff_exception_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ADD CONSTRAINT `fk_tariff_pricing_rule_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ADD CONSTRAINT `fk_tariff_pricing_rule_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ADD CONSTRAINT `fk_tariff_pricing_rule_superseded_by_rule_pricing_rule_id` FOREIGN KEY (`superseded_by_rule_pricing_rule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`pricing_rule`(`pricing_rule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ADD CONSTRAINT `fk_tariff_free_time_allowance_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ADD CONSTRAINT `fk_tariff_free_time_allowance_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ADD CONSTRAINT `fk_tariff_free_time_allowance_superseded_by_allowance_free_time_allowance_id` FOREIGN KEY (`superseded_by_allowance_free_time_allowance_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance`(`free_time_allowance_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ADD CONSTRAINT `fk_tariff_towage_tariff_superseded_by_tariff_towage_tariff_id` FOREIGN KEY (`superseded_by_tariff_towage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`towage_tariff`(`towage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ADD CONSTRAINT `fk_tariff_mooring_tariff_superseded_by_tariff_mooring_tariff_id` FOREIGN KEY (`superseded_by_tariff_mooring_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff`(`mooring_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_superseded_by_schedule_port_dues_schedule_id` FOREIGN KEY (`superseded_by_schedule_port_dues_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule`(`port_dues_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ADD CONSTRAINT `fk_tariff_applicability_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ADD CONSTRAINT `fk_tariff_applicability_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ADD CONSTRAINT `fk_tariff_applicability_superseded_by_rule_applicability_id` FOREIGN KEY (`superseded_by_rule_applicability_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`applicability`(`applicability_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ADD CONSTRAINT `fk_tariff_currency_adjustment_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ADD CONSTRAINT `fk_tariff_currency_adjustment_superseded_by_caf_currency_adjustment_id` FOREIGN KEY (`superseded_by_caf_currency_adjustment_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment`(`currency_adjustment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ADD CONSTRAINT `fk_tariff_bunker_adjustment_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ADD CONSTRAINT `fk_tariff_bunker_adjustment_superseded_by_baf_bunker_adjustment_id` FOREIGN KEY (`superseded_by_baf_bunker_adjustment_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment`(`bunker_adjustment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ADD CONSTRAINT `fk_tariff_negotiation_counter_negotiation_id` FOREIGN KEY (`counter_negotiation_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`negotiation`(`negotiation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ADD CONSTRAINT `fk_tariff_negotiation_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ADD CONSTRAINT `fk_tariff_tariff_version_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ADD CONSTRAINT `fk_tariff_tariff_version_primary_superseded_by_version_id` FOREIGN KEY (`primary_superseded_by_version_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`tariff_version`(`tariff_version_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ADD CONSTRAINT `fk_tariff_tariff_filing_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ADD CONSTRAINT `fk_tariff_tariff_filing_primary_superseded_by_filing_id` FOREIGN KEY (`primary_superseded_by_filing_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`tariff_filing`(`tariff_filing_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ADD CONSTRAINT `fk_tariff_tariff_filing_tariff_superseded_filing_id` FOREIGN KEY (`tariff_superseded_filing_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`tariff_filing`(`tariff_filing_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`tariff` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_shipping_ports_v1`.`tariff` SET TAGS ('dbx_domain' = 'tariff');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` SET TAGS ('dbx_subdomain' = 'rate_schedules');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `superseded_by_tariff_port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Tariff ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `trade_restriction_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Restriction Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `un_locode_id` SET TAGS ('dbx_business_glossary_term' = 'Un Locode Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `applicable_cargo_types` SET TAGS ('dbx_business_glossary_term' = 'Applicable Cargo Types');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `applicable_container_types` SET TAGS ('dbx_business_glossary_term' = 'Applicable Container Types');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `applicable_movement_types` SET TAGS ('dbx_business_glossary_term' = 'Applicable Movement Types');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `applicable_terminal_zones` SET TAGS ('dbx_business_glossary_term' = 'Applicable Terminal Zones');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `applicable_trade_lanes` SET TAGS ('dbx_business_glossary_term' = 'Applicable Trade Lanes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `applicable_vessel_categories` SET TAGS ('dbx_business_glossary_term' = 'Applicable Vessel Categories');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `approval_authority` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `approval_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Approval Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `base_rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Base Rate Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `charge_type` SET TAGS ('dbx_business_glossary_term' = 'Charge Type Discriminator');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `discount_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Discount Eligible Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `dwt_band_max` SET TAGS ('dbx_business_glossary_term' = 'Deadweight Tonnage (DWT) Band Maximum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `dwt_band_min` SET TAGS ('dbx_business_glossary_term' = 'Deadweight Tonnage (DWT) Band Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `escalation_structure` SET TAGS ('dbx_business_glossary_term' = 'Escalation Structure');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `escalation_structure` SET TAGS ('dbx_value_regex' = 'FLAT|TIERED|PROGRESSIVE');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `free_time_days` SET TAGS ('dbx_business_glossary_term' = 'Free Time (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `grt_band_max` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) Band Maximum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `grt_band_min` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) Band Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `last_modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `loa_band_max_meters` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) Band Maximum (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `loa_band_min_meters` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) Band Minimum (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `maximum_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `minimum_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Tariff Schedule Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `public_tariff_flag` SET TAGS ('dbx_business_glossary_term' = 'Public Tariff Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `publication_date` SET TAGS ('dbx_business_glossary_term' = 'Publication Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `rate_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Rate Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `regulatory_filing_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Filing Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `sla_linked_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Linked Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `tariff_description` SET TAGS ('dbx_business_glossary_term' = 'Tariff Schedule Description');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `tariff_schedule_code` SET TAGS ('dbx_business_glossary_term' = 'Tariff Schedule Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `tariff_schedule_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `tariff_schedule_name` SET TAGS ('dbx_business_glossary_term' = 'Tariff Schedule Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `tariff_status` SET TAGS ('dbx_business_glossary_term' = 'Tariff Schedule Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` SET TAGS ('dbx_subdomain' = 'rate_schedules');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `item_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Item Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `charge_event_id` SET TAGS ('dbx_business_glossary_term' = 'Charge Event Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `demurrage_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Demurrage Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `detention_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Detention Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `mooring_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Mooring Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `pilotage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `port_dues_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Port Dues Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Schedule Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `service_code_id` SET TAGS ('dbx_business_glossary_term' = 'Service Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `storage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `thc_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Thc Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `towage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Towage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `wharfage_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Wharfage Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `charge_basis` SET TAGS ('dbx_business_glossary_term' = 'Charge Basis');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `charge_category` SET TAGS ('dbx_business_glossary_term' = 'Charge Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `charge_code` SET TAGS ('dbx_business_glossary_term' = 'Charge Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `charge_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `charge_description` SET TAGS ('dbx_business_glossary_term' = 'Charge Description');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `charge_name` SET TAGS ('dbx_business_glossary_term' = 'Charge Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `container_size_applicability` SET TAGS ('dbx_business_glossary_term' = 'Container Size Applicability');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `container_size_applicability` SET TAGS ('dbx_value_regex' = '20ft|40ft|45ft|all');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `container_type_applicability` SET TAGS ('dbx_business_glossary_term' = 'Container Type Applicability');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `dangerous_goods_flag` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `escalation_tier_1_days` SET TAGS ('dbx_business_glossary_term' = 'Escalation Tier 1 Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `escalation_tier_1_rate` SET TAGS ('dbx_business_glossary_term' = 'Escalation Tier 1 Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `escalation_tier_2_days` SET TAGS ('dbx_business_glossary_term' = 'Escalation Tier 2 Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `escalation_tier_2_rate` SET TAGS ('dbx_business_glossary_term' = 'Escalation Tier 2 Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `escalation_tier_3_days` SET TAGS ('dbx_business_glossary_term' = 'Escalation Tier 3 Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `escalation_tier_3_rate` SET TAGS ('dbx_business_glossary_term' = 'Escalation Tier 3 Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `fcl_lcl_applicability` SET TAGS ('dbx_business_glossary_term' = 'Full Container Load (FCL) / Less than Container Load (LCL) Applicability');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `fcl_lcl_applicability` SET TAGS ('dbx_value_regex' = 'FCL|LCL|both');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `free_time_days` SET TAGS ('dbx_business_glossary_term' = 'Free Time Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `import_export_direction` SET TAGS ('dbx_business_glossary_term' = 'Import Export Direction');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `import_export_direction` SET TAGS ('dbx_value_regex' = 'import|export|transshipment|all');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `item_status` SET TAGS ('dbx_business_glossary_term' = 'Tariff Item Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `item_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|superseded');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `maximum_charge` SET TAGS ('dbx_business_glossary_term' = 'Maximum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `minimum_charge` SET TAGS ('dbx_business_glossary_term' = 'Minimum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Rate Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `rate_band_amount_1` SET TAGS ('dbx_business_glossary_term' = 'Rate Band Amount 1');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `rate_band_amount_2` SET TAGS ('dbx_business_glossary_term' = 'Rate Band Amount 2');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `rate_band_amount_3` SET TAGS ('dbx_business_glossary_term' = 'Rate Band Amount 3');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `rate_band_threshold_1` SET TAGS ('dbx_business_glossary_term' = 'Rate Band Threshold 1');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `rate_band_threshold_2` SET TAGS ('dbx_business_glossary_term' = 'Rate Band Threshold 2');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `rate_band_threshold_3` SET TAGS ('dbx_business_glossary_term' = 'Rate Band Threshold 3');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `rounding_precision` SET TAGS ('dbx_business_glossary_term' = 'Rounding Precision');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `rounding_rule` SET TAGS ('dbx_business_glossary_term' = 'Rounding Rule');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `rounding_rule` SET TAGS ('dbx_value_regex' = 'round_up|round_down|round_nearest|no_rounding');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `sla_service_level` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Service Level');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `sla_service_level` SET TAGS ('dbx_value_regex' = 'standard|express|premium');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `tiered_pricing_flag` SET TAGS ('dbx_business_glossary_term' = 'Tiered Pricing Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `trade_lane_applicability` SET TAGS ('dbx_business_glossary_term' = 'Trade Lane Applicability');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `vessel_type_applicability` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Applicability');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` SET TAGS ('dbx_subdomain' = 'rate_schedules');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Account Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `customs_broker_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Customer Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `superseded_by_rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Rate Card Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto Renewal Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_business_glossary_term' = 'Billing Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_value_regex' = 'per_transaction|daily|weekly|monthly|quarterly');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `committed_volume_teu` SET TAGS ('dbx_business_glossary_term' = 'Committed Volume Twenty-foot Equivalent Unit (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `committed_volume_teu` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `crane_productivity_target_moves_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Crane Productivity Target Moves Per Hour');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `customer_segment` SET TAGS ('dbx_business_glossary_term' = 'Customer Segment');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `customer_segment` SET TAGS ('dbx_value_regex' = 'tier_1|tier_2|tier_3|vip|standard|sme');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `escalation_clause` SET TAGS ('dbx_business_glossary_term' = 'Escalation Clause');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `gate_processing_time_target_minutes` SET TAGS ('dbx_business_glossary_term' = 'Gate Processing Time Target Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `measurement_period` SET TAGS ('dbx_business_glossary_term' = 'Measurement Period');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `measurement_period` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|quarterly|per_call');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `minimum_commitment_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Commitment Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `minimum_commitment_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `rate_card_name` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Notice Period Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `penalty_clause_description` SET TAGS ('dbx_business_glossary_term' = 'Penalty Clause Description');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `premium_clause_description` SET TAGS ('dbx_business_glossary_term' = 'Premium Clause Description');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `premium_percentage` SET TAGS ('dbx_business_glossary_term' = 'Premium Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `rate_card_number` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `rate_card_number` SET TAGS ('dbx_value_regex' = '^RC-[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `rate_card_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `rate_card_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `rate_card_type` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `rate_card_type` SET TAGS ('dbx_value_regex' = 'standard|sla_linked|promotional|spot|contract');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'gold|silver|bronze|platinum|standard');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `trade_lane` SET TAGS ('dbx_business_glossary_term' = 'Trade Lane');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Version');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `version` SET TAGS ('dbx_value_regex' = '^v?[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `vessel_turnaround_time_target_hours` SET TAGS ('dbx_business_glossary_term' = 'Vessel Turnaround Time Target Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` SET TAGS ('dbx_subdomain' = 'rate_schedules');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `rate_card_line_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Line Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `bunker_adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Bunker Adjustment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `currency_adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Currency Adjustment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `item_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Item Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `baf_applicable_flag` SET TAGS ('dbx_business_glossary_term' = 'Bunker Adjustment Factor (BAF) Applicable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_business_glossary_term' = 'Billing Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_value_regex' = 'per_event|daily|weekly|monthly|quarterly|annual');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `caf_applicable_flag` SET TAGS ('dbx_business_glossary_term' = 'Currency Adjustment Factor (CAF) Applicable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `free_time_days` SET TAGS ('dbx_business_glossary_term' = 'Free Time Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `line_sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `line_status` SET TAGS ('dbx_business_glossary_term' = 'Line Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `line_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|superseded|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `maximum_quantity` SET TAGS ('dbx_business_glossary_term' = 'Maximum Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `minimum_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `override_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Override Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `override_reason_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `override_reason_description` SET TAGS ('dbx_business_glossary_term' = 'Override Reason Description');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `penalty_rate` SET TAGS ('dbx_business_glossary_term' = 'Penalty Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `service_category` SET TAGS ('dbx_business_glossary_term' = 'Service Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `service_description` SET TAGS ('dbx_business_glossary_term' = 'Service Description');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `sla_target_hours` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Target Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `surcharge_applicable_flag` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Applicable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `tax_applicable_flag` SET TAGS ('dbx_business_glossary_term' = 'Tax Applicable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `tax_rate_percentage` SET TAGS ('dbx_business_glossary_term' = 'Tax Rate Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `terminal_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `tier_threshold_lower` SET TAGS ('dbx_business_glossary_term' = 'Tier Threshold Lower Bound');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `tier_threshold_upper` SET TAGS ('dbx_business_glossary_term' = 'Tier Threshold Upper Bound');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `unit_rate` SET TAGS ('dbx_business_glossary_term' = 'Unit Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `vessel_size_category` SET TAGS ('dbx_business_glossary_term' = 'Vessel Size Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `vessel_size_category` SET TAGS ('dbx_value_regex' = 'feeder|panamax|post_panamax|new_panamax|ultra_large|all');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` SET TAGS ('dbx_subdomain' = 'rate_schedules');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `thc_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Handling Charge (THC) Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `supersedes_schedule_thc_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Supersedes Terminal Handling Charge (THC) Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|approved|rejected|suspended|archived');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `base_rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Base Terminal Handling Charge (THC) Rate Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `cargo_category` SET TAGS ('dbx_business_glossary_term' = 'Cargo Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `cargo_category` SET TAGS ('dbx_value_regex' = 'fcl|lcl|roro|lolo|breakbulk|bulk');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `container_size_teu` SET TAGS ('dbx_business_glossary_term' = 'Container Size in Twenty-foot Equivalent Units (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `container_type` SET TAGS ('dbx_business_glossary_term' = 'Container Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `container_type` SET TAGS ('dbx_value_regex' = '20ft|40ft|40ft_hc|45ft_hc|reefer|open_top');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `customer_segment` SET TAGS ('dbx_business_glossary_term' = 'Customer Segment');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `dangerous_goods_surcharge` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Surcharge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `discount_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Discount Eligible Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `filing_date` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Filing Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `maximum_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `minimum_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Record Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `movement_type` SET TAGS ('dbx_business_glossary_term' = 'Movement Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `movement_type` SET TAGS ('dbx_value_regex' = 'import|export|transshipment|coastal|empty_repositioning');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Schedule Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `oversize_surcharge` SET TAGS ('dbx_business_glossary_term' = 'Oversize Cargo Surcharge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `peak_season_surcharge` SET TAGS ('dbx_business_glossary_term' = 'Peak Season Surcharge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `published_date` SET TAGS ('dbx_business_glossary_term' = 'Published Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `published_flag` SET TAGS ('dbx_business_glossary_term' = 'Published Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `rate_unit` SET TAGS ('dbx_business_glossary_term' = 'Rate Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `rate_unit` SET TAGS ('dbx_value_regex' = 'per_container|per_teu|per_feu|per_move|per_ton');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `reefer_surcharge` SET TAGS ('dbx_business_glossary_term' = 'Reefer Container Surcharge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `regulatory_filing_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Filing Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `schedule_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Handling Charge (THC) Schedule Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `schedule_code` SET TAGS ('dbx_value_regex' = '^THC-[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `schedule_name` SET TAGS ('dbx_business_glossary_term' = 'Terminal Handling Charge (THC) Schedule Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `service_level` SET TAGS ('dbx_business_glossary_term' = 'Service Level');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `service_level` SET TAGS ('dbx_value_regex' = 'standard|express|priority|economy');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `trade_lane` SET TAGS ('dbx_business_glossary_term' = 'Trade Lane');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Schedule Version Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` SET TAGS ('dbx_subdomain' = 'rate_schedules');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `wharfage_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Wharfage Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `superseded_by_schedule_wharfage_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `approval_authority` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `approval_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Approval Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `baf_applicable_flag` SET TAGS ('dbx_business_glossary_term' = 'Bunker Adjustment Factor (BAF) Applicable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `caf_applicable_flag` SET TAGS ('dbx_business_glossary_term' = 'Currency Adjustment Factor (CAF) Applicable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `dangerous_goods_flag` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `exemption_condition` SET TAGS ('dbx_business_glossary_term' = 'Exemption Condition');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `exemption_flag` SET TAGS ('dbx_business_glossary_term' = 'Exemption Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `minimum_charge` SET TAGS ('dbx_business_glossary_term' = 'Minimum Wharfage Charge');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Tariff Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `oversized_cargo_flag` SET TAGS ('dbx_business_glossary_term' = 'Oversized Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `publication_date` SET TAGS ('dbx_business_glossary_term' = 'Publication Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `rate_per_unit` SET TAGS ('dbx_business_glossary_term' = 'Rate Per Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `refrigerated_cargo_flag` SET TAGS ('dbx_business_glossary_term' = 'Refrigerated Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `sla_service_level` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Service Level');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `sla_service_level` SET TAGS ('dbx_value_regex' = 'standard|express|premium');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `surcharge_percentage` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `tariff_code` SET TAGS ('dbx_business_glossary_term' = 'Wharfage (WHR) Tariff Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `tariff_code` SET TAGS ('dbx_value_regex' = '^WHR-[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `tariff_name` SET TAGS ('dbx_business_glossary_term' = 'Tariff Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `tariff_status` SET TAGS ('dbx_business_glossary_term' = 'Tariff Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `tariff_status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|active|suspended|superseded|expired');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `tariff_version` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `tariff_version` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}.[0-9]{1,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `trade_direction` SET TAGS ('dbx_business_glossary_term' = 'Trade Direction');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `trade_direction` SET TAGS ('dbx_value_regex' = 'import|export|coastal|transshipment');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'tonne|cbm|teu|feu|unit|revenue_tonne');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `vessel_type` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `volume_break_lower_limit` SET TAGS ('dbx_business_glossary_term' = 'Volume Break Lower Limit');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `volume_break_upper_limit` SET TAGS ('dbx_business_glossary_term' = 'Volume Break Upper Limit');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `weight_break_lower_limit` SET TAGS ('dbx_business_glossary_term' = 'Weight Break Lower Limit');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `weight_break_upper_limit` SET TAGS ('dbx_business_glossary_term' = 'Weight Break Upper Limit');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` SET TAGS ('dbx_subdomain' = 'rate_schedules');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `pilotage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Tariff ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `superseded_by_tariff_pilotage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Tariff ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `base_pilotage_fee` SET TAGS ('dbx_business_glossary_term' = 'Base Pilotage Fee');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_business_glossary_term' = 'Billing Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_value_regex' = 'per_service|monthly|quarterly');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `cancellation_fee` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Fee');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `cancellation_notice_hours` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Notice Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `dangerous_goods_surcharge` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Surcharge');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `discount_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Discount Eligible Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `distance_based_flag` SET TAGS ('dbx_business_glossary_term' = 'Distance Based Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `dwt_band_max_tons` SET TAGS ('dbx_business_glossary_term' = 'Deadweight Tonnage (DWT) Band Maximum Tons');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `dwt_band_min_tons` SET TAGS ('dbx_business_glossary_term' = 'Deadweight Tonnage (DWT) Band Minimum Tons');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `extraordinary_conditions_surcharge` SET TAGS ('dbx_business_glossary_term' = 'Extraordinary Conditions Surcharge');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `grt_band_max_tons` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) Band Maximum Tons');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `grt_band_min_tons` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) Band Minimum Tons');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `loa_band_max_meters` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) Band Maximum Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `loa_band_min_meters` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) Band Minimum Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `maximum_charge` SET TAGS ('dbx_business_glossary_term' = 'Maximum Charge');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `minimum_charge` SET TAGS ('dbx_business_glossary_term' = 'Minimum Charge');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Tariff Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `pilotage_tariff_status` SET TAGS ('dbx_business_glossary_term' = 'Tariff Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `pilotage_tariff_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|pending_approval|superseded');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `pilotage_type` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `pilotage_type` SET TAGS ('dbx_value_regex' = 'harbour|coastal|river|shifting|berthing|unberthing');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `rate_per_nautical_mile` SET TAGS ('dbx_business_glossary_term' = 'Rate Per Nautical Mile');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `regulatory_approval_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `service_category` SET TAGS ('dbx_business_glossary_term' = 'Service Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `service_category` SET TAGS ('dbx_value_regex' = 'compulsory|voluntary|extraordinary');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `sla_response_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Response Time Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `tariff_code` SET TAGS ('dbx_business_glossary_term' = 'Tariff Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `tariff_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `tariff_name` SET TAGS ('dbx_business_glossary_term' = 'Tariff Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `tariff_version` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `tariff_version` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}.[0-9]{1,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `tax_applicable_flag` SET TAGS ('dbx_business_glossary_term' = 'Tax Applicable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `time_of_day_category` SET TAGS ('dbx_business_glossary_term' = 'Time of Day Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `time_of_day_category` SET TAGS ('dbx_value_regex' = 'day|night|weekend|public_holiday');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ALTER COLUMN `waiting_time_surcharge_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Waiting Time Surcharge Per Hour');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` SET TAGS ('dbx_subdomain' = 'rate_schedules');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `storage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Tariff ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `superseded_by_tariff_storage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Tariff ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_business_glossary_term' = 'Billing Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|on_exit');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `cargo_type` SET TAGS ('dbx_value_regex' = 'general|bulk|breakbulk|roro|project|imdg');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `container_status` SET TAGS ('dbx_business_glossary_term' = 'Container Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `container_status` SET TAGS ('dbx_value_regex' = 'import|export|transshipment|empty|laden');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `customer_tier` SET TAGS ('dbx_business_glossary_term' = 'Customer Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `customer_tier` SET TAGS ('dbx_value_regex' = 'premium|standard|basic|spot');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `demurrage_conversion_day` SET TAGS ('dbx_business_glossary_term' = 'Demurrage (DMG) Conversion Day');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `demurrage_linkage_flag` SET TAGS ('dbx_business_glossary_term' = 'Demurrage (DMG) Linkage Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `free_storage_days` SET TAGS ('dbx_business_glossary_term' = 'Free Storage Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `grace_period_hours` SET TAGS ('dbx_business_glossary_term' = 'Grace Period Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `maximum_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `minimum_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Tariff Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `public_holiday_charge_flag` SET TAGS ('dbx_business_glossary_term' = 'Public Holiday Charge Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `rate_band_1_daily_rate` SET TAGS ('dbx_business_glossary_term' = 'Rate Band 1 Daily Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `rate_band_1_end_day` SET TAGS ('dbx_business_glossary_term' = 'Rate Band 1 End Day');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `rate_band_1_start_day` SET TAGS ('dbx_business_glossary_term' = 'Rate Band 1 Start Day');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `rate_band_2_daily_rate` SET TAGS ('dbx_business_glossary_term' = 'Rate Band 2 Daily Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `rate_band_2_end_day` SET TAGS ('dbx_business_glossary_term' = 'Rate Band 2 End Day');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `rate_band_2_start_day` SET TAGS ('dbx_business_glossary_term' = 'Rate Band 2 Start Day');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `rate_band_3_daily_rate` SET TAGS ('dbx_business_glossary_term' = 'Rate Band 3 Daily Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `rate_band_3_end_day` SET TAGS ('dbx_business_glossary_term' = 'Rate Band 3 End Day');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `rate_band_3_start_day` SET TAGS ('dbx_business_glossary_term' = 'Rate Band 3 Start Day');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `rate_unit` SET TAGS ('dbx_business_glossary_term' = 'Rate Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `rate_unit` SET TAGS ('dbx_value_regex' = 'per_teu|per_feu|per_container|per_ton|per_cbm');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `tariff_code` SET TAGS ('dbx_business_glossary_term' = 'Tariff Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `tariff_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `tariff_description` SET TAGS ('dbx_business_glossary_term' = 'Tariff Description');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `tariff_name` SET TAGS ('dbx_business_glossary_term' = 'Tariff Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `tariff_status` SET TAGS ('dbx_business_glossary_term' = 'Tariff Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `tariff_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|superseded|archived');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `tariff_version` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `tariff_version` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `tax_applicable_flag` SET TAGS ('dbx_business_glossary_term' = 'Tax Applicable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `weekend_charge_flag` SET TAGS ('dbx_business_glossary_term' = 'Weekend Charge Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` SET TAGS ('dbx_subdomain' = 'rate_schedules');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `demurrage_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Demurrage (DMG) Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `calculation_method` SET TAGS ('dbx_business_glossary_term' = 'Calculation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `calculation_method` SET TAGS ('dbx_value_regex' = 'calendar_days|working_days|business_days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `cargo_type` SET TAGS ('dbx_value_regex' = 'FCL|LCL|breakbulk|bulk|roro|ALL');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `customer_tier` SET TAGS ('dbx_business_glossary_term' = 'Customer Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `customer_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `demurrage_schedule_status` SET TAGS ('dbx_business_glossary_term' = 'Demurrage (DMG) Schedule Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `demurrage_schedule_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|archived');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `dispute_resolution_terms` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `free_time_days` SET TAGS ('dbx_business_glossary_term' = 'Free Time Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `grace_period_hours` SET TAGS ('dbx_business_glossary_term' = 'Grace Period Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `holiday_exclusion_flag` SET TAGS ('dbx_business_glossary_term' = 'Holiday Exclusion Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `maximum_demurrage_cap` SET TAGS ('dbx_business_glossary_term' = 'Maximum Demurrage (DMG) Cap');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Schedule Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `prorated_calculation_flag` SET TAGS ('dbx_business_glossary_term' = 'Prorated Calculation Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `rate_tier_1_amount` SET TAGS ('dbx_business_glossary_term' = 'Rate Tier 1 Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `rate_tier_1_days` SET TAGS ('dbx_business_glossary_term' = 'Rate Tier 1 Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `rate_tier_2_amount` SET TAGS ('dbx_business_glossary_term' = 'Rate Tier 2 Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `rate_tier_2_days` SET TAGS ('dbx_business_glossary_term' = 'Rate Tier 2 Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `rate_tier_3_amount` SET TAGS ('dbx_business_glossary_term' = 'Rate Tier 3 Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `rate_tier_3_days` SET TAGS ('dbx_business_glossary_term' = 'Rate Tier 3 Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `schedule_code` SET TAGS ('dbx_business_glossary_term' = 'Demurrage (DMG) Schedule Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `schedule_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `schedule_name` SET TAGS ('dbx_business_glossary_term' = 'Demurrage (DMG) Schedule Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `schedule_type` SET TAGS ('dbx_business_glossary_term' = 'Demurrage (DMG) Schedule Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `schedule_type` SET TAGS ('dbx_value_regex' = 'container|vessel|cargo|equipment');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `sla_reference_code` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Reference Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `tariff_publication_reference` SET TAGS ('dbx_business_glossary_term' = 'Tariff Publication Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `trade_lane` SET TAGS ('dbx_business_glossary_term' = 'Trade Lane');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `waiver_authority_level` SET TAGS ('dbx_business_glossary_term' = 'Waiver Authority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `waiver_authority_level` SET TAGS ('dbx_value_regex' = 'terminal_manager|commercial_director|ceo|none');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ALTER COLUMN `weekend_exclusion_flag` SET TAGS ('dbx_business_glossary_term' = 'Weekend Exclusion Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` SET TAGS ('dbx_subdomain' = 'rate_schedules');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `detention_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Detention (DET) Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `superseded_by_schedule_detention_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_business_glossary_term' = 'Billing Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|per_occurrence');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `calculation_method` SET TAGS ('dbx_business_glossary_term' = 'Detention Calculation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `calculation_method` SET TAGS ('dbx_value_regex' = 'calendar_days|working_days|business_days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `cargo_type` SET TAGS ('dbx_value_regex' = 'FCL|LCL|breakbulk|RoRo|bulk|dangerous_goods');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `customer_tier` SET TAGS ('dbx_business_glossary_term' = 'Customer Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `customer_tier` SET TAGS ('dbx_value_regex' = 'premium|standard|occasional|spot');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `detention_schedule_status` SET TAGS ('dbx_business_glossary_term' = 'Schedule Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `detention_schedule_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|superseded');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `free_time_days` SET TAGS ('dbx_business_glossary_term' = 'Free Time Allowance (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `grace_period_hours` SET TAGS ('dbx_business_glossary_term' = 'Grace Period (Hours)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `holiday_charge_applicable` SET TAGS ('dbx_business_glossary_term' = 'Holiday Charge Applicable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `maximum_detention_cap` SET TAGS ('dbx_business_glossary_term' = 'Maximum Detention Cap Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Schedule Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `proration_rule` SET TAGS ('dbx_business_glossary_term' = 'Proration Rule');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `proration_rule` SET TAGS ('dbx_value_regex' = 'full_day|hourly_proration|half_day_rounding');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `published_date` SET TAGS ('dbx_business_glossary_term' = 'Published Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `rate_tier_1_amount` SET TAGS ('dbx_business_glossary_term' = 'Rate Tier 1 Daily Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `rate_tier_1_days` SET TAGS ('dbx_business_glossary_term' = 'Rate Tier 1 Duration (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `rate_tier_2_amount` SET TAGS ('dbx_business_glossary_term' = 'Rate Tier 2 Daily Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `rate_tier_2_days` SET TAGS ('dbx_business_glossary_term' = 'Rate Tier 2 Duration (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `rate_tier_3_amount` SET TAGS ('dbx_business_glossary_term' = 'Rate Tier 3 Daily Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `rate_tier_3_days` SET TAGS ('dbx_business_glossary_term' = 'Rate Tier 3 Duration (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `schedule_code` SET TAGS ('dbx_business_glossary_term' = 'Detention Schedule Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `schedule_code` SET TAGS ('dbx_value_regex' = '^DET-[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `schedule_name` SET TAGS ('dbx_business_glossary_term' = 'Detention Schedule Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `service_line` SET TAGS ('dbx_business_glossary_term' = 'Shipping Service Line');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `trade_direction` SET TAGS ('dbx_business_glossary_term' = 'Trade Direction');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `trade_direction` SET TAGS ('dbx_value_regex' = 'import|export|transshipment|empty_repositioning');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Schedule Version Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `waiver_eligible` SET TAGS ('dbx_business_glossary_term' = 'Waiver Eligible Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ALTER COLUMN `weekend_charge_applicable` SET TAGS ('dbx_business_glossary_term' = 'Weekend Charge Applicable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` SET TAGS ('dbx_subdomain' = 'pricing_adjustments');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `surcharge_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Rule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `superseded_by_rule_surcharge_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Rule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `applicability_conditions` SET TAGS ('dbx_business_glossary_term' = 'Applicability Conditions');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_business_glossary_term' = 'Billing Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_value_regex' = 'PER_TRANSACTION|MONTHLY|QUARTERLY|ANNUALLY');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `calculation_base` SET TAGS ('dbx_business_glossary_term' = 'Calculation Base');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `calculation_base` SET TAGS ('dbx_value_regex' = 'FREIGHT|THC|BASE_TARIFF|TOTAL_CHARGES|CARGO_VALUE');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `calculation_method` SET TAGS ('dbx_business_glossary_term' = 'Calculation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `calculation_method` SET TAGS ('dbx_value_regex' = 'FLAT_FEE|PERCENTAGE_OF_BASE|PER_UNIT|TIERED|INDEX_LINKED');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `calculation_priority` SET TAGS ('dbx_business_glossary_term' = 'Calculation Priority Sequence');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `cargo_type_applicability` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type Applicability');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `compounding_allowed` SET TAGS ('dbx_business_glossary_term' = 'Compounding Allowed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `currency_pair` SET TAGS ('dbx_business_glossary_term' = 'Currency Pair');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `currency_pair` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}/[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `exemption_criteria` SET TAGS ('dbx_business_glossary_term' = 'Exemption Criteria');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `index_reference_name` SET TAGS ('dbx_business_glossary_term' = 'Index Reference Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `index_reference_url` SET TAGS ('dbx_business_glossary_term' = 'Index Reference URL');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `maximum_charge` SET TAGS ('dbx_business_glossary_term' = 'Maximum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `minimum_charge` SET TAGS ('dbx_business_glossary_term' = 'Minimum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Internal Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Notice Period Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `proration_method` SET TAGS ('dbx_business_glossary_term' = 'Proration Method');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `proration_method` SET TAGS ('dbx_value_regex' = 'NONE|DAILY|MONTHLY|PROPORTIONAL');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `publication_authority` SET TAGS ('dbx_business_glossary_term' = 'Publication Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `published_date` SET TAGS ('dbx_business_glossary_term' = 'Published Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Rate Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `rate_percentage` SET TAGS ('dbx_business_glossary_term' = 'Rate Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `regulatory_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `rule_code` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Rule Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `rule_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `service_type_applicability` SET TAGS ('dbx_business_glossary_term' = 'Service Type Applicability');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `surcharge_name` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `surcharge_type` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `trade_lane_scope` SET TAGS ('dbx_business_glossary_term' = 'Trade Lane Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `vessel_type_applicability` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Applicability');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` SET TAGS ('dbx_subdomain' = 'pricing_adjustments');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `discount_scheme_id` SET TAGS ('dbx_business_glossary_term' = 'Discount Scheme ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Scheme Owner Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `applicable_charge_codes` SET TAGS ('dbx_business_glossary_term' = 'Applicable Charge Codes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `approval_authority` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `approval_reference` SET TAGS ('dbx_business_glossary_term' = 'Approval Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `auto_apply_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto Apply Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `billing_system_code` SET TAGS ('dbx_business_glossary_term' = 'Billing System Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `cargo_type_restriction` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type Restriction');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `combinable_with_other_discounts` SET TAGS ('dbx_business_glossary_term' = 'Combinable With Other Discounts Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `customer_tier_eligibility` SET TAGS ('dbx_business_glossary_term' = 'Customer Tier Eligibility');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `customer_type_eligibility` SET TAGS ('dbx_business_glossary_term' = 'Customer Type Eligibility');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `discount_category` SET TAGS ('dbx_business_glossary_term' = 'Discount Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `discount_category` SET TAGS ('dbx_value_regex' = 'promotional|contractual|volume|loyalty|seasonal|strategic');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `discount_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Discount Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `discount_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `discount_type` SET TAGS ('dbx_business_glossary_term' = 'Discount Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `discount_type` SET TAGS ('dbx_value_regex' = 'percentage|flat_rate|free_days|tiered|volume_based|loyalty_based');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `discount_value` SET TAGS ('dbx_business_glossary_term' = 'Discount Value');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `maximum_discount_cap` SET TAGS ('dbx_business_glossary_term' = 'Maximum Discount Cap');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `minimum_charge_threshold` SET TAGS ('dbx_business_glossary_term' = 'Minimum Charge Threshold');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Record Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Discount Scheme Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `priority_rank` SET TAGS ('dbx_business_glossary_term' = 'Discount Priority Rank');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `promotional_campaign_code` SET TAGS ('dbx_business_glossary_term' = 'Promotional Campaign Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `requires_customer_request` SET TAGS ('dbx_business_glossary_term' = 'Requires Customer Request Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `retroactive_application_allowed` SET TAGS ('dbx_business_glossary_term' = 'Retroactive Application Allowed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `scheme_code` SET TAGS ('dbx_business_glossary_term' = 'Discount Scheme Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `scheme_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `scheme_description` SET TAGS ('dbx_business_glossary_term' = 'Discount Scheme Description');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `scheme_name` SET TAGS ('dbx_business_glossary_term' = 'Discount Scheme Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `scheme_status` SET TAGS ('dbx_business_glossary_term' = 'Discount Scheme Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `scheme_status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|active|suspended|expired|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `sla_linked_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Linked Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `sla_performance_metric` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Performance Metric');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `terminal_restriction` SET TAGS ('dbx_business_glossary_term' = 'Terminal Restriction');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `threshold_period` SET TAGS ('dbx_business_glossary_term' = 'Threshold Measurement Period');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `threshold_period` SET TAGS ('dbx_value_regex' = 'per_call|monthly|quarterly|annually|contract_term');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `threshold_type` SET TAGS ('dbx_business_glossary_term' = 'Threshold Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `threshold_type` SET TAGS ('dbx_value_regex' = 'teu_volume|call_frequency|cargo_tonnage|revenue_value|container_count|none');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `threshold_unit` SET TAGS ('dbx_business_glossary_term' = 'Threshold Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `threshold_value` SET TAGS ('dbx_business_glossary_term' = 'Threshold Value');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `vessel_type_restriction` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Restriction');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` SET TAGS ('dbx_subdomain' = 'pricing_adjustments');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `sla_rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Rate Card ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Service Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Rate Card ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `applicable_customer_segment` SET TAGS ('dbx_business_glossary_term' = 'Applicable Customer Segment');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approved Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto Renewal Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `base_rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Base Rate Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `berth_allocation_response_time_target_hours` SET TAGS ('dbx_business_glossary_term' = 'Berth Allocation Response Time Target (Hours)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_business_glossary_term' = 'Billing Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_value_regex' = 'Per Transaction|Weekly|Bi-Weekly|Monthly|Quarterly');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `crane_productivity_target_moves_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Crane Productivity Target (Moves Per Hour)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `discount_eligibility_flag` SET TAGS ('dbx_business_glossary_term' = 'Discount Eligibility Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `dispute_resolution_process` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Process');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `escalation_clause` SET TAGS ('dbx_business_glossary_term' = 'Escalation Clause');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `escalation_frequency` SET TAGS ('dbx_business_glossary_term' = 'Escalation Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `escalation_frequency` SET TAGS ('dbx_value_regex' = 'Monthly|Quarterly|Semi-Annual|Annual|None');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `escalation_index_type` SET TAGS ('dbx_business_glossary_term' = 'Escalation Index Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `escalation_index_type` SET TAGS ('dbx_value_regex' = 'CPI|Fuel Index|Currency Exchange|Fixed Percentage|None');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `force_majeure_clause` SET TAGS ('dbx_business_glossary_term' = 'Force Majeure Clause');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `gate_processing_time_target_minutes` SET TAGS ('dbx_business_glossary_term' = 'Gate Processing Time Target (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_business_glossary_term' = 'Geographic Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `maximum_volume_cap` SET TAGS ('dbx_business_glossary_term' = 'Maximum Volume Cap');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `measurement_period` SET TAGS ('dbx_business_glossary_term' = 'Measurement Period');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `measurement_period` SET TAGS ('dbx_value_regex' = 'Per Transaction|Daily|Weekly|Monthly|Quarterly|Annual');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `minimum_volume_commitment` SET TAGS ('dbx_business_glossary_term' = 'Minimum Volume Commitment');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Notice Period (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `payment_terms_days` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `penalty_percentage` SET TAGS ('dbx_business_glossary_term' = 'Penalty Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `performance_reporting_frequency` SET TAGS ('dbx_business_glossary_term' = 'Performance Reporting Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `performance_reporting_frequency` SET TAGS ('dbx_value_regex' = 'Real-Time|Daily|Weekly|Monthly|Quarterly');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `premium_percentage` SET TAGS ('dbx_business_glossary_term' = 'Premium Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `rate_card_code` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `rate_card_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `rate_card_name` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `rate_card_status` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `rate_card_status` SET TAGS ('dbx_value_regex' = 'Draft|Active|Suspended|Expired|Superseded');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `rate_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Rate Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `rate_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `rate_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Rate Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `service_category` SET TAGS ('dbx_business_glossary_term' = 'Service Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `service_exclusions` SET TAGS ('dbx_business_glossary_term' = 'Service Exclusions');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'Gold|Silver|Bronze|Platinum|Standard|Premium');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ALTER COLUMN `vessel_turnaround_time_target_hours` SET TAGS ('dbx_business_glossary_term' = 'Vessel Turnaround Time Target (Hours)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` SET TAGS ('dbx_subdomain' = 'pricing_adjustments');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `exception_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Exception Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `import_export_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Import Export Permit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `item_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Item Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Infrastructure Project Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `quaternary_exception_revoked_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Revoked By User Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `quaternary_exception_revoked_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `quaternary_exception_revoked_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Consignment Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `tertiary_exception_modified_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `tertiary_exception_modified_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `tertiary_exception_modified_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `application_scope` SET TAGS ('dbx_business_glossary_term' = 'Application Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `application_scope` SET TAGS ('dbx_value_regex' = 'single_transaction|vessel_call|customer_agreement|cargo_type|trade_lane|time_period');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `approval_authority` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `audit_trail_reference` SET TAGS ('dbx_business_glossary_term' = 'Audit Trail Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `conditional_clause` SET TAGS ('dbx_business_glossary_term' = 'Conditional Clause');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `exception_number` SET TAGS ('dbx_business_glossary_term' = 'Exception Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `exception_status` SET TAGS ('dbx_business_glossary_term' = 'Exception Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `exception_type` SET TAGS ('dbx_business_glossary_term' = 'Exception Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `free_days_granted` SET TAGS ('dbx_business_glossary_term' = 'Granted Free Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `free_days_standard` SET TAGS ('dbx_business_glossary_term' = 'Standard Free Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `justification` SET TAGS ('dbx_business_glossary_term' = 'Exception Justification');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Exception Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Exception Rate Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `revenue_commitment_amount` SET TAGS ('dbx_business_glossary_term' = 'Revenue Commitment Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `revocation_date` SET TAGS ('dbx_business_glossary_term' = 'Revocation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `revocation_reason` SET TAGS ('dbx_business_glossary_term' = 'Revocation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `standard_rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Standard Rate Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `trade_lane` SET TAGS ('dbx_business_glossary_term' = 'Trade Lane');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `validity_period_days` SET TAGS ('dbx_business_glossary_term' = 'Validity Period Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `volume_commitment_teu` SET TAGS ('dbx_business_glossary_term' = 'Volume Commitment Twenty-foot Equivalent Unit (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ALTER COLUMN `waiver_amount` SET TAGS ('dbx_business_glossary_term' = 'Waiver Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` SET TAGS ('dbx_subdomain' = 'pricing_adjustments');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `pricing_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Pricing Rule Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Rate Card Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Customer Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Tariff Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `superseded_by_rule_pricing_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Pricing Rule Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trade_restriction_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Restriction Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `approval_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Approval Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `auto_apply_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto Apply Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `conflict_resolution_strategy` SET TAGS ('dbx_business_glossary_term' = 'Conflict Resolution Strategy');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `conflict_resolution_strategy` SET TAGS ('dbx_value_regex' = 'highest_priority|lowest_charge|highest_charge|most_specific|customer_favorable');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `free_time_days` SET TAGS ('dbx_business_glossary_term' = 'Free Time Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `maximum_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `minimum_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Pricing Rule Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `priority_order` SET TAGS ('dbx_business_glossary_term' = 'Priority Order');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `rule_code` SET TAGS ('dbx_business_glossary_term' = 'Pricing Rule Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `rule_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{4,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `rule_description` SET TAGS ('dbx_business_glossary_term' = 'Pricing Rule Description');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `rule_expression` SET TAGS ('dbx_business_glossary_term' = 'Pricing Rule Expression');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `rule_name` SET TAGS ('dbx_business_glossary_term' = 'Pricing Rule Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `rule_status` SET TAGS ('dbx_business_glossary_term' = 'Pricing Rule Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `rule_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|superseded');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `rule_type` SET TAGS ('dbx_business_glossary_term' = 'Pricing Rule Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `sla_linked_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Linked Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `surcharge_percentage` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trigger_cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Trigger Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trigger_cargo_weight_max_kg` SET TAGS ('dbx_business_glossary_term' = 'Trigger Cargo Weight Maximum (Kilograms)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trigger_cargo_weight_min_kg` SET TAGS ('dbx_business_glossary_term' = 'Trigger Cargo Weight Minimum (Kilograms)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trigger_container_type` SET TAGS ('dbx_business_glossary_term' = 'Trigger Container Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trigger_customer_segment` SET TAGS ('dbx_business_glossary_term' = 'Trigger Customer Segment');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trigger_grt_max` SET TAGS ('dbx_business_glossary_term' = 'Trigger Gross Registered Tonnage (GRT) Maximum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trigger_grt_min` SET TAGS ('dbx_business_glossary_term' = 'Trigger Gross Registered Tonnage (GRT) Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trigger_loa_max_meters` SET TAGS ('dbx_business_glossary_term' = 'Trigger Length Overall (LOA) Maximum (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trigger_loa_min_meters` SET TAGS ('dbx_business_glossary_term' = 'Trigger Length Overall (LOA) Minimum (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trigger_service_type` SET TAGS ('dbx_business_glossary_term' = 'Trigger Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trigger_trade_direction` SET TAGS ('dbx_business_glossary_term' = 'Trigger Trade Direction');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trigger_trade_direction` SET TAGS ('dbx_value_regex' = 'import|export|transshipment|coastal|empty_repositioning');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trigger_trade_lane` SET TAGS ('dbx_business_glossary_term' = 'Trigger Trade Lane');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trigger_vessel_class` SET TAGS ('dbx_business_glossary_term' = 'Trigger Vessel Class');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trigger_volume_max_teu` SET TAGS ('dbx_business_glossary_term' = 'Trigger Volume Maximum (Twenty-foot Equivalent Unit - TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ALTER COLUMN `trigger_volume_min_teu` SET TAGS ('dbx_business_glossary_term' = 'Trigger Volume Minimum (Twenty-foot Equivalent Unit - TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` SET TAGS ('dbx_subdomain' = 'pricing_adjustments');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `free_time_allowance_id` SET TAGS ('dbx_business_glossary_term' = 'Free Time Allowance Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `superseded_by_allowance_free_time_allowance_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Allowance ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `allowance_code` SET TAGS ('dbx_business_glossary_term' = 'Free Time Allowance Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `allowance_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `allowance_name` SET TAGS ('dbx_business_glossary_term' = 'Free Time Allowance Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `applicable_charge_type` SET TAGS ('dbx_business_glossary_term' = 'Applicable Charge Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `applicable_charge_type` SET TAGS ('dbx_value_regex' = 'storage|demurrage|detention|wharfage|thc');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `auto_apply_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto Apply Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `calculation_basis` SET TAGS ('dbx_business_glossary_term' = 'Calculation Basis');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `calculation_basis` SET TAGS ('dbx_value_regex' = 'calendar_days|working_days|business_days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `container_type` SET TAGS ('dbx_business_glossary_term' = 'Container Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `customer_tier` SET TAGS ('dbx_business_glossary_term' = 'Customer Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `customer_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard|all_tiers');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `dangerous_goods_flag` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `end_trigger_event` SET TAGS ('dbx_business_glossary_term' = 'End Trigger Event');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `end_trigger_event` SET TAGS ('dbx_value_regex' = 'gate_out|vessel_loading|container_pickup|expiry_of_free_days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `free_days` SET TAGS ('dbx_business_glossary_term' = 'Free Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `free_time_allowance_status` SET TAGS ('dbx_business_glossary_term' = 'Free Time Allowance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `free_time_allowance_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|superseded');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `free_time_type` SET TAGS ('dbx_business_glossary_term' = 'Free Time Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `free_time_type` SET TAGS ('dbx_value_regex' = 'import_free_days|export_free_days|transshipment_free_days|equipment_free_days|storage_free_days|demurrage_free_days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `holiday_exclusion_flag` SET TAGS ('dbx_business_glossary_term' = 'Holiday Exclusion Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `maximum_volume_teu` SET TAGS ('dbx_business_glossary_term' = 'Maximum Volume TEU (Twenty-foot Equivalent Unit)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `minimum_volume_teu` SET TAGS ('dbx_business_glossary_term' = 'Minimum Volume TEU (Twenty-foot Equivalent Unit)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `priority_order` SET TAGS ('dbx_business_glossary_term' = 'Priority Order');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `reefer_cargo_flag` SET TAGS ('dbx_business_glossary_term' = 'Reefer Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `start_trigger_event` SET TAGS ('dbx_business_glossary_term' = 'Start Trigger Event');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `start_trigger_event` SET TAGS ('dbx_value_regex' = 'vessel_discharge|gate_in|customs_release|delivery_order_issue|container_available|berth_departure');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `terminal_zone` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `trade_lane` SET TAGS ('dbx_business_glossary_term' = 'Trade Lane');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `vessel_category` SET TAGS ('dbx_business_glossary_term' = 'Vessel Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `vessel_category` SET TAGS ('dbx_value_regex' = 'feeder|panamax|post_panamax|ultra_large|all_categories');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `weekend_exclusion_flag` SET TAGS ('dbx_business_glossary_term' = 'Weekend Exclusion Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` SET TAGS ('dbx_subdomain' = 'rate_schedules');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `towage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Towage Tariff Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `superseded_by_tariff_towage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Towage Tariff Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `approval_authority` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `approval_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Approval Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `base_towage_fee_amount` SET TAGS ('dbx_business_glossary_term' = 'Base Towage Fee Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `cancellation_fee_amount` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Fee Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `cancellation_notice_period_hours` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Notice Period in Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `cargo_type_restriction` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type Restriction');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Record Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `discount_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Discount Eligible Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `dwt_band_max` SET TAGS ('dbx_business_glossary_term' = 'Deadweight Tonnage (DWT) Band Maximum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `dwt_band_min` SET TAGS ('dbx_business_glossary_term' = 'Deadweight Tonnage (DWT) Band Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Towage Tariff Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Towage Tariff Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `escalation_clause` SET TAGS ('dbx_business_glossary_term' = 'Escalation Clause');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `extraordinary_conditions_surcharge_pct` SET TAGS ('dbx_business_glossary_term' = 'Extraordinary Conditions Surcharge Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `free_standby_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Free Standby Time in Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `grt_band_max` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) Band Maximum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `grt_band_min` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) Band Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `loa_band_max_meters` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) Band Maximum in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `loa_band_min_meters` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) Band Minimum in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `maximum_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `minimum_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Record Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Towage Tariff Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `number_of_tugs_required` SET TAGS ('dbx_business_glossary_term' = 'Number of Tugs Required');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `operation_type` SET TAGS ('dbx_business_glossary_term' = 'Towage Operation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `operation_type` SET TAGS ('dbx_value_regex' = 'berthing|unberthing|shifting|emergency|escort|standby');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `publication_date` SET TAGS ('dbx_business_glossary_term' = 'Publication Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `rate_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Rate Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `rate_unit_of_measure` SET TAGS ('dbx_value_regex' = 'per_operation|per_hour|per_tug|per_grt|per_dwt');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `sla_linked_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Linked Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `standby_time_rate_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Standby Time Rate Per Hour');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `tariff_code` SET TAGS ('dbx_business_glossary_term' = 'Towage Tariff Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `tariff_code` SET TAGS ('dbx_value_regex' = '^TOW-[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `tariff_name` SET TAGS ('dbx_business_glossary_term' = 'Towage Tariff Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `tariff_status` SET TAGS ('dbx_business_glossary_term' = 'Towage Tariff Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `tariff_version` SET TAGS ('dbx_business_glossary_term' = 'Towage Tariff Version');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `tariff_version` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}.[0-9]{1,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `time_of_day_category` SET TAGS ('dbx_business_glossary_term' = 'Time of Day Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `time_of_day_category` SET TAGS ('dbx_value_regex' = 'standard_hours|after_hours|night|weekend|public_holiday');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `tug_bollard_pull_min_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Tug Bollard Pull Minimum in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ALTER COLUMN `vessel_type_category` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` SET TAGS ('dbx_subdomain' = 'rate_schedules');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `mooring_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Mooring Tariff ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `superseded_by_tariff_mooring_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Tariff ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `tertiary_mooring_modified_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `tertiary_mooring_modified_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `tertiary_mooring_modified_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `base_mooring_fee` SET TAGS ('dbx_business_glossary_term' = 'Base Mooring Fee');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `cancellation_fee` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Fee');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `cancellation_notice_hours` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Notice Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `customer_tier` SET TAGS ('dbx_business_glossary_term' = 'Customer Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `customer_tier` SET TAGS ('dbx_value_regex' = 'standard|preferred|premium|contract');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `discount_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Discount Eligible Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `escalation_clause` SET TAGS ('dbx_business_glossary_term' = 'Escalation Clause');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `free_waiting_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Free Waiting Time Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `grt_band_max` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) Band Maximum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `grt_band_min` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) Band Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `loa_band_max_meters` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) Band Maximum Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `loa_band_min_meters` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) Band Minimum Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `maximum_charge_cap` SET TAGS ('dbx_business_glossary_term' = 'Maximum Charge Cap');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `minimum_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `mooring_gang_count` SET TAGS ('dbx_business_glossary_term' = 'Mooring Gang Count');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `mooring_type` SET TAGS ('dbx_business_glossary_term' = 'Mooring Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `mooring_type` SET TAGS ('dbx_value_regex' = 'conventional|buoy|single_point|multi_buoy|dolphin');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `public_tariff_flag` SET TAGS ('dbx_business_glossary_term' = 'Public Tariff Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `publication_date` SET TAGS ('dbx_business_glossary_term' = 'Publication Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `rate_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Rate Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `rate_unit_of_measure` SET TAGS ('dbx_value_regex' = 'per_operation|per_gang|per_hour|per_line');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `regulatory_filing_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Filing Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'mooring|unmooring|combined');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `sla_linked_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Linked Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `sla_response_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Response Time Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `special_conditions` SET TAGS ('dbx_business_glossary_term' = 'Special Conditions');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `tariff_code` SET TAGS ('dbx_business_glossary_term' = 'Tariff Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `tariff_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `tariff_name` SET TAGS ('dbx_business_glossary_term' = 'Tariff Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `tariff_status` SET TAGS ('dbx_business_glossary_term' = 'Tariff Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `tariff_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|superseded');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `tariff_version` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `tariff_version` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}.[0-9]{1,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `time_of_day_category` SET TAGS ('dbx_business_glossary_term' = 'Time of Day Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `time_of_day_category` SET TAGS ('dbx_value_regex' = 'day|night|weekend|holiday');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `trade_lane` SET TAGS ('dbx_business_glossary_term' = 'Trade Lane');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `vessel_category` SET TAGS ('dbx_business_glossary_term' = 'Vessel Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ALTER COLUMN `waiting_time_surcharge_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Waiting Time Surcharge Per Hour');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` SET TAGS ('dbx_subdomain' = 'rate_schedules');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `port_dues_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Port Dues Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `flag_state_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Flag State Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `superseded_by_schedule_port_dues_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `base_rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Base Rate Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `call_frequency_discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Call Frequency Discount Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `call_frequency_tier` SET TAGS ('dbx_business_glossary_term' = 'Call Frequency Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `call_frequency_tier` SET TAGS ('dbx_value_regex' = 'first_call|regular|frequent|premium');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `dangerous_goods_surcharge_percentage` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Surcharge Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `dues_type` SET TAGS ('dbx_business_glossary_term' = 'Port Dues Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `dues_type` SET TAGS ('dbx_value_regex' = 'light_dues|conservancy_dues|port_entry_fee|anchorage_dues|navigation_dues|pilotage_dues');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `environmental_levy_percentage` SET TAGS ('dbx_business_glossary_term' = 'Environmental Levy Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `exemption_criteria` SET TAGS ('dbx_business_glossary_term' = 'Exemption Criteria Description');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `exemption_flag` SET TAGS ('dbx_business_glossary_term' = 'Exemption Eligibility Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `grt_band_max` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) Band Maximum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `grt_band_min` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) Band Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `late_payment_penalty_percentage` SET TAGS ('dbx_business_glossary_term' = 'Late Payment Penalty Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `loa_band_max_meters` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) Band Maximum in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `loa_band_min_meters` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) Band Minimum in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `maximum_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `measurement_period_days` SET TAGS ('dbx_business_glossary_term' = 'Measurement Period in Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `minimum_calls_per_period` SET TAGS ('dbx_business_glossary_term' = 'Minimum Calls Per Period');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `minimum_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modification Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Schedule Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `nrt_band_max` SET TAGS ('dbx_business_glossary_term' = 'Net Registered Tonnage (NRT) Band Maximum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `nrt_band_min` SET TAGS ('dbx_business_glossary_term' = 'Net Registered Tonnage (NRT) Band Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `payment_terms_days` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms in Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `port_dues_schedule_status` SET TAGS ('dbx_business_glossary_term' = 'Schedule Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `port_dues_schedule_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|superseded|withdrawn');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `publication_date` SET TAGS ('dbx_business_glossary_term' = 'Public Tariff Publication Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `rate_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Rate Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `rate_unit_of_measure` SET TAGS ('dbx_value_regex' = 'per_grt|per_nrt|per_call|per_meter_loa|per_day|flat_fee');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `regulatory_approval_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `regulatory_authority` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `schedule_code` SET TAGS ('dbx_business_glossary_term' = 'Port Dues Schedule Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `schedule_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `schedule_name` SET TAGS ('dbx_business_glossary_term' = 'Port Dues Schedule Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `security_levy_percentage` SET TAGS ('dbx_business_glossary_term' = 'Security Levy Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `trade_type` SET TAGS ('dbx_business_glossary_term' = 'Trade Type Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `trade_type` SET TAGS ('dbx_value_regex' = 'international|coastal|domestic|cabotage|transshipment');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `vessel_type` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` SET TAGS ('dbx_subdomain' = 'pricing_adjustments');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `applicability_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Applicability ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `un_locode_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Un Locode Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Customer ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `superseded_by_rule_applicability_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Rule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `tertiary_applicability_modified_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `tertiary_applicability_modified_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `tertiary_applicability_modified_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `applicability_status` SET TAGS ('dbx_business_glossary_term' = 'Applicability Rule Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `applicability_status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|active|suspended|expired|superseded');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `approval_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Approval Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `auto_apply_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto Apply Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `conflict_resolution_order` SET TAGS ('dbx_business_glossary_term' = 'Conflict Resolution Order');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `container_size_teu` SET TAGS ('dbx_business_glossary_term' = 'Container Size Twenty-foot Equivalent Unit (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `container_type` SET TAGS ('dbx_business_glossary_term' = 'Container Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `dangerous_goods_class` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Class');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `dangerous_goods_class` SET TAGS ('dbx_value_regex' = '^(class_[1-9]|non_dg|all_classes)$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `exclusion_flag` SET TAGS ('dbx_business_glossary_term' = 'Exclusion Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `grt_max` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) Maximum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `grt_min` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `loa_max_meters` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) Maximum Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `loa_min_meters` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) Minimum Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `load_status` SET TAGS ('dbx_business_glossary_term' = 'Load Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `load_status` SET TAGS ('dbx_value_regex' = 'fcl|lcl|empty|all_statuses');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `maximum_volume_teu` SET TAGS ('dbx_business_glossary_term' = 'Maximum Volume Twenty-foot Equivalent Unit (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `minimum_volume_teu` SET TAGS ('dbx_business_glossary_term' = 'Minimum Volume Twenty-foot Equivalent Unit (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `movement_type` SET TAGS ('dbx_business_glossary_term' = 'Movement Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `movement_type` SET TAGS ('dbx_value_regex' = 'import|export|transshipment|empty_repositioning|all_movements');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `port_of_destination` SET TAGS ('dbx_business_glossary_term' = 'Port of Destination (POD)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `port_of_destination` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `rule_code` SET TAGS ('dbx_business_glossary_term' = 'Applicability Rule Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `rule_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `rule_name` SET TAGS ('dbx_business_glossary_term' = 'Applicability Rule Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `rule_priority` SET TAGS ('dbx_business_glossary_term' = 'Rule Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'premium|standard|basic|all_tiers');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `terminal_zone` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `trade_lane` SET TAGS ('dbx_business_glossary_term' = 'Trade Lane');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `vessel_size_category` SET TAGS ('dbx_business_glossary_term' = 'Vessel Size Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `vessel_size_category` SET TAGS ('dbx_value_regex' = 'feeder|panamax|post_panamax|new_panamax|ultra_large|all_sizes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ALTER COLUMN `vessel_type` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` SET TAGS ('dbx_subdomain' = 'pricing_adjustments');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `currency_adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Currency Adjustment Factor (CAF) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `superseded_by_caf_currency_adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Currency Adjustment Factor (CAF) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `tertiary_currency_modified_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `tertiary_currency_modified_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `tertiary_currency_modified_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `adjustment_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `adjustment_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|withdrawn');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `auto_apply_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto Apply Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `base_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Base Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `base_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `billing_system_code` SET TAGS ('dbx_business_glossary_term' = 'Billing System Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `caf_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Adjustment Factor (CAF) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `caf_code` SET TAGS ('dbx_value_regex' = '^CAF-[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `caf_name` SET TAGS ('dbx_business_glossary_term' = 'Currency Adjustment Factor (CAF) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `caf_percentage` SET TAGS ('dbx_business_glossary_term' = 'Currency Adjustment Factor (CAF) Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `calculation_basis` SET TAGS ('dbx_business_glossary_term' = 'Currency Adjustment Factor (CAF) Calculation Basis');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `calculation_basis` SET TAGS ('dbx_value_regex' = 'freight_charge|thc_charge|total_charge|base_tariff');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `cargo_type_scope` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `currency_adjustment_status` SET TAGS ('dbx_business_glossary_term' = 'Currency Adjustment Factor (CAF) Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `currency_adjustment_status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|active|suspended|expired|superseded');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `current_exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Current Exchange Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `customer_tier_scope` SET TAGS ('dbx_business_glossary_term' = 'Customer Tier Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `dispute_resolution_terms` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `exchange_rate_date` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `exchange_rate_reference` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `maximum_caf_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Currency Adjustment Factor (CAF) Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `minimum_caf_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Currency Adjustment Factor (CAF) Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Notice Period Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `publication_date` SET TAGS ('dbx_business_glossary_term' = 'Publication Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `publication_reference` SET TAGS ('dbx_business_glossary_term' = 'Publication Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `reference_exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Reference Exchange Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `regulatory_approval_date` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `regulatory_filing_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Filing Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `regulatory_filing_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Filing Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `service_type_scope` SET TAGS ('dbx_business_glossary_term' = 'Service Type Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `trade_lane_scope` SET TAGS ('dbx_business_glossary_term' = 'Trade Lane Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ALTER COLUMN `vessel_category_scope` SET TAGS ('dbx_business_glossary_term' = 'Vessel Category Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` SET TAGS ('dbx_subdomain' = 'pricing_adjustments');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `bunker_adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Bunker Adjustment Factor (BAF) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `superseded_by_baf_bunker_adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Bunker Adjustment Factor (BAF) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `applicable_service_types` SET TAGS ('dbx_business_glossary_term' = 'Applicable Service Types');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `approval_authority` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `approval_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Approval Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `baf_code` SET TAGS ('dbx_business_glossary_term' = 'Bunker Adjustment Factor (BAF) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `baf_code` SET TAGS ('dbx_value_regex' = '^BAF-[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `baf_name` SET TAGS ('dbx_business_glossary_term' = 'Bunker Adjustment Factor (BAF) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `baf_rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Bunker Adjustment Factor (BAF) Rate Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `baf_type` SET TAGS ('dbx_business_glossary_term' = 'Bunker Adjustment Factor (BAF) Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `baf_type` SET TAGS ('dbx_value_regex' = 'standard|emergency|seasonal|trade_lane_specific|vessel_specific|temporary');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `bunker_adjustment_status` SET TAGS ('dbx_business_glossary_term' = 'Bunker Adjustment Factor (BAF) Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `calculation_method` SET TAGS ('dbx_business_glossary_term' = 'Calculation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `calculation_method` SET TAGS ('dbx_value_regex' = 'flat_per_teu|flat_per_feu|percentage_of_base|tiered|formula_based');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `cargo_type_applicability` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type Applicability');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `container_type_applicability` SET TAGS ('dbx_business_glossary_term' = 'Container Type Applicability');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `customer_tier_eligibility` SET TAGS ('dbx_business_glossary_term' = 'Customer Tier Eligibility');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `dwt_band_max` SET TAGS ('dbx_business_glossary_term' = 'Deadweight Tonnage (DWT) Band Maximum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `dwt_band_min` SET TAGS ('dbx_business_glossary_term' = 'Deadweight Tonnage (DWT) Band Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `exemption_conditions` SET TAGS ('dbx_business_glossary_term' = 'Exemption Conditions');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `fuel_index_reference` SET TAGS ('dbx_business_glossary_term' = 'Fuel Index Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `fuel_index_value` SET TAGS ('dbx_business_glossary_term' = 'Fuel Index Value');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `grt_band_max` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) Band Maximum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `grt_band_min` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT) Band Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `loa_band_max_meters` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) Band Maximum Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `loa_band_min_meters` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) Band Minimum Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `maximum_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `minimum_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Minimum Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `publication_authority` SET TAGS ('dbx_business_glossary_term' = 'Publication Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `publication_date` SET TAGS ('dbx_business_glossary_term' = 'Publication Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `rate_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Rate Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `regulatory_filing_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Filing Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `regulatory_filing_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Filing Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `review_frequency` SET TAGS ('dbx_business_glossary_term' = 'Review Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `review_frequency` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annual|annual|event_driven|continuous');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `trade_lane_scope` SET TAGS ('dbx_business_glossary_term' = 'Trade Lane Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `vessel_size_category` SET TAGS ('dbx_business_glossary_term' = 'Vessel Size Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ALTER COLUMN `vessel_type_applicability` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Applicability');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` SET TAGS ('dbx_subdomain' = 'commercial_negotiation');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `negotiation_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Negotiation Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `counter_negotiation_id` SET TAGS ('dbx_business_glossary_term' = 'Counter Negotiation Id');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `counter_negotiation_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Resulting Rate Card Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `tertiary_negotiation_modified_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `tertiary_negotiation_modified_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `tertiary_negotiation_modified_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `approval_authority_level` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `approval_authority_level` SET TAGS ('dbx_value_regex' = 'commercial_manager|head_of_commercial|cfo|ceo|board');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `approval_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Approval Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto Renewal Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `commercial_justification` SET TAGS ('dbx_business_glossary_term' = 'Commercial Justification');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `commitment_period_months` SET TAGS ('dbx_business_glossary_term' = 'Commitment Period in Months');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `competitor_benchmark_rate` SET TAGS ('dbx_business_glossary_term' = 'Competitor Benchmark Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `competitor_benchmark_rate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Level');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_value_regex' = 'public|internal|confidential|highly_confidential');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `container_type` SET TAGS ('dbx_business_glossary_term' = 'Container Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `container_type` SET TAGS ('dbx_value_regex' = 'standard|reefer|tank|flat_rack|open_top|high_cube');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `counter_offer_rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Counter Offer Rate Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `customer_segment` SET TAGS ('dbx_business_glossary_term' = 'Customer Segment');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `customer_segment` SET TAGS ('dbx_value_regex' = 'tier_1|tier_2|tier_3|strategic|transactional|spot');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `escalation_clause` SET TAGS ('dbx_business_glossary_term' = 'Escalation Clause');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `final_agreed_rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Final Agreed Rate Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `initiated_date` SET TAGS ('dbx_business_glossary_term' = 'Negotiation Initiated Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `negotiation_status` SET TAGS ('dbx_business_glossary_term' = 'Negotiation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `negotiation_type` SET TAGS ('dbx_business_glossary_term' = 'Negotiation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Negotiation Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Notice Period in Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `payment_terms_days` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms in Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `penalty_clause_description` SET TAGS ('dbx_business_glossary_term' = 'Penalty Clause Description');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `premium_percentage` SET TAGS ('dbx_business_glossary_term' = 'Premium Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `proposed_rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Proposed Rate Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `rate_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Rate Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `reference_number` SET TAGS ('dbx_business_glossary_term' = 'Negotiation Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `revenue_commitment_amount` SET TAGS ('dbx_business_glossary_term' = 'Revenue Commitment Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `risk_assessment` SET TAGS ('dbx_business_glossary_term' = 'Risk Assessment');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `risk_assessment` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `round` SET TAGS ('dbx_business_glossary_term' = 'Negotiation Round Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'standard|premium|platinum|express');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `termination_clause` SET TAGS ('dbx_business_glossary_term' = 'Termination Clause');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `trade_lane` SET TAGS ('dbx_business_glossary_term' = 'Trade Lane');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ALTER COLUMN `volume_commitment_teu` SET TAGS ('dbx_business_glossary_term' = 'Volume Commitment Twenty-foot Equivalent Unit (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` SET TAGS ('dbx_subdomain' = 'commercial_negotiation');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `tariff_version_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Schedule Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `primary_superseded_by_version_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Tariff Version Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `approval_authority` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Approval Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `approval_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Approval Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `change_category` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Change Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `change_category` SET TAGS ('dbx_value_regex' = 'rate_increase|rate_decrease|new_service|service_removal|policy_change|correction');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `change_summary` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Change Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `consultation_end_date` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Consultation End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `consultation_start_date` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Consultation Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `document_reference` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Document Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `draft_date` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Draft Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `effective_time` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Effective Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `estimated_revenue_impact_amount` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Estimated Revenue Impact Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `estimated_revenue_impact_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `impact_assessment_completed` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Impact Assessment Completed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `legal_review_completed` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Legal Review Completed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `legal_reviewer_name` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Legal Reviewer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Notice Period Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `public_consultation_required` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Public Consultation Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `publication_channel` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Publication Channel');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `publication_date` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Publication Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `regulatory_filing_date` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Regulatory Filing Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `regulatory_filing_reference` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Regulatory Filing Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `regulatory_filing_required` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Regulatory Filing Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `retroactive_billing_allowed` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Retroactive Billing Allowed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `retroactive_period_days` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Retroactive Period Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `stakeholder_feedback_summary` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Stakeholder Feedback Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Submission Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `superseded_date` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Superseded Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `version_name` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `version_status` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `version_type` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `version_type` SET TAGS ('dbx_value_regex' = 'initial|amendment|revision|emergency|regulatory|annual');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `withdrawal_date` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Withdrawal Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `withdrawal_reason` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Withdrawal Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_version` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Tariff Version Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` SET TAGS ('dbx_subdomain' = 'commercial_negotiation');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `tariff_filing_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Filing Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `compliance_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Audit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `primary_superseded_by_filing_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Filing Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `tariff_filing_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Submitted By User Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `tariff_filing_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `tariff_filing_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `tariff_filing_modified_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `tariff_filing_modified_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `tariff_filing_modified_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `tariff_filing_withdrawn_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Withdrawn By User Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `tariff_filing_withdrawn_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `tariff_filing_withdrawn_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `tariff_superseded_filing_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded Filing Id');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `tariff_superseded_filing_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|approved_with_conditions|rejected|withdrawn');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `approved_by_authority_officer` SET TAGS ('dbx_business_glossary_term' = 'Approved By Authority Officer');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `approved_by_authority_officer` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `audit_trail_reference` SET TAGS ('dbx_business_glossary_term' = 'Audit Trail Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `conditions_imposed` SET TAGS ('dbx_business_glossary_term' = 'Conditions Imposed');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `document_reference` SET TAGS ('dbx_business_glossary_term' = 'Filing Document Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `effective_date_granted` SET TAGS ('dbx_business_glossary_term' = 'Effective Date Granted');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `estimated_revenue_impact_amount` SET TAGS ('dbx_business_glossary_term' = 'Estimated Revenue Impact Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `estimated_revenue_impact_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `expiry_date_granted` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date Granted');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `filing_status` SET TAGS ('dbx_business_glossary_term' = 'Filing Status');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `filing_type` SET TAGS ('dbx_business_glossary_term' = 'Filing Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `filing_type` SET TAGS ('dbx_value_regex' = 'new_tariff|tariff_amendment|tariff_revision|tariff_withdrawal|emergency_filing');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `gazette_publication_date` SET TAGS ('dbx_business_glossary_term' = 'Gazette Publication Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `gazette_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Gazette Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `impact_assessment_completed_flag` SET TAGS ('dbx_business_glossary_term' = 'Impact Assessment Completed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `legal_review_completed_flag` SET TAGS ('dbx_business_glossary_term' = 'Legal Review Completed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `legal_review_date` SET TAGS ('dbx_business_glossary_term' = 'Legal Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `legal_reviewer_name` SET TAGS ('dbx_business_glossary_term' = 'Legal Reviewer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `legal_reviewer_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Notice Period Days');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `public_comment_count` SET TAGS ('dbx_business_glossary_term' = 'Public Comment Count');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `public_consultation_end_date` SET TAGS ('dbx_business_glossary_term' = 'Public Consultation End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `public_consultation_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Public Consultation Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `public_consultation_start_date` SET TAGS ('dbx_business_glossary_term' = 'Public Consultation Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `reference_number` SET TAGS ('dbx_business_glossary_term' = 'Filing Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `regulatory_authority` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `regulatory_authority_contact` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Authority Contact');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `regulatory_authority_contact` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `stakeholder_feedback_summary` SET TAGS ('dbx_business_glossary_term' = 'Stakeholder Feedback Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'Submission Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Submission Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `supporting_documentation_reference` SET TAGS ('dbx_business_glossary_term' = 'Supporting Documentation Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `withdrawal_date` SET TAGS ('dbx_business_glossary_term' = 'Withdrawal Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ALTER COLUMN `withdrawal_reason` SET TAGS ('dbx_business_glossary_term' = 'Withdrawal Reason');
