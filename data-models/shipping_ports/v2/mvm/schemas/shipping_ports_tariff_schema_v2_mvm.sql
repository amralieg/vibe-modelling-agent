-- Schema for Domain: tariff | Business: Shipping_Ports | Version: v2_mvm
-- Generated on: 2026-07-13 10:24:18

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`tariff` COMMENT 'Owns the complete port services pricing catalog including THC (Terminal Handling Charges), wharfage (WHR), pilotage fees, demurrage (DMG), detention (DET), PIL, BAF, CAF, storage tariffs, and SLA-linked service rate cards. Covers rate cards, pricing rules, discount structures, and tariff schedules. SSOT for all commercial pricing and tariff definitions.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` (
    `port_tariff_id` BIGINT COMMENT 'Unique identifier for the port tariff schedule record. Primary key.',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Port tariffs must reference trade restrictions to exclude embargoed goods, sanctioned parties from standard tariff application. Regulatory compliance requirement for port authorities.',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: Port tariffs require national regulatory approval (approval_authority, regulatory_filing_required_flag). Country context determines jurisdiction, regulatory framework, currency regulations, and intern',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Port tariff schedules are published by a specific port authority for a specific port. Port-level tariff management, regulatory filing, and tariff book publication all require linking the tariff schedu',
    `superseded_by_tariff_port_tariff_id` BIGINT COMMENT 'Reference to the port_tariff_id of the newer tariff schedule that replaces this one. Null if this is the current active schedule.',
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
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: When tariff_item charge_category is mooring, this FK links to the mooring tariff defining line-handling service charges. Resolves mooring_tariff silo.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: When tariff_item charge_category is towage, this FK links to the towage tariff defining tug assistance charges by vessel size and operation type. Resolves towage_tariff silo.',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Tariff line items apply to specific cargo commodities (cargo_type_applicability). HS code classification determines applicable charges, handling requirements, and regulatory compliance. Critical for t',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: Tariff items apply commodity-specific charges based on HS codes (dangerous goods surcharges, refrigerated cargo handling fees). Core charge calculation process distinct from wharfage.',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: When tariff_item charge_category is detention (DET), this FK links to the detention schedule defining equipment detention charges. Resolves detention_schedule silo.',
    `port_dues_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.port_dues_schedule. Business justification: When tariff_item charge_category is port dues, this FK links to the port dues schedule defining statutory vessel call charges. Resolves port_dues_schedule silo.',
    `port_gate_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port_gate. Business justification: Gate processing charges (OCR scanning fees, weighbridge fees, gate appointment fees) are distinct tariff items in port operations linked to specific port gates. Gate-level charge items enable accurate',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: When tariff_item charge_category is pilotage, this FK links to the pilotage tariff defining vessel-based pilotage fees. Resolves pilotage_tariff silo.',
    `port_tariff_id` BIGINT COMMENT 'Reference to the parent tariff schedule that contains this tariff item. Links the item to its governing rate card or pricing schedule.',
    `storage_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.storage_tariff. Business justification: When tariff_item charge_category is storage, this FK links to the storage tariff defining progressive daily storage rates by container type and zone. Resolves storage_tariff silo.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: When tariff_item charge_category is demurrage (DMG), this FK links to the demurrage schedule defining tiered daily rates after free time expires. Resolves demurrage_schedule silo.',
    `thc_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.thc_schedule. Business justification: tariff_item defines a billable charge within port_tariff. When the charge_category is THC (Terminal Handling Charge), this FK links to the detailed THC schedule that defines the rate structure by cont',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Charge applicability determination during vessel call billing requires structured vessel type scoping at the tariff item level. vessel_type_applicability plain text on item is a denormalized field. ',
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
    CONSTRAINT pk_item PRIMARY KEY(`item_id`)
) COMMENT 'Individual line-item charge definition within a port tariff schedule. Represents a single billable service rate (e.g., THC per TEU by container type, wharfage per GRT by cargo category, pilotage per LOA band by zone, storage per day per TEU by escalation tier, towage per GRT band by operation type). Captures the charge code, unit of measure (TEU, FEU, GRT, LOA, CBM, tonne, day, move, gang), charge basis, rate amount, minimum charge, maximum charge, rounding rules, vessel/cargo/trade applicability conditions, and rate band thresholds for tiered pricing. Forms the atomic pricing unit referenced by rate cards, pricing rules, and the billing engine.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` (
    `rate_card_id` BIGINT COMMENT 'Unique identifier for the rate card. Primary key.',
    `customs_broker_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_broker. Business justification: Negotiated rate cards for customs brokers who are high-volume port service users. Real commercial relationship in maritime logistics for freight forwarding services.',
    `discount_scheme_id` BIGINT COMMENT 'Foreign key linking to tariff.discount_scheme. Business justification: A rate card is frequently associated with a specific commercial discount scheme (volume-based, loyalty, or promotional). discount_scheme already links to port_tariff and port_location. Adding discount',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Negotiated rate cards are customer-specific contracts with shipping lines. Shipping lines are major port customers with volume commitments, SLA requirements, and preferential pricing. Essential for co',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Rate cards are negotiated pricing instruments implementing commercial agreements. Every rate card in port operations is governed by a master agreement defining commercial terms, parties, payment condi',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Commercial rate cards in port operations are negotiated per port between the port authority and shipping lines or terminal operators. Port-level rate card management, contract reporting, and commercia',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Major customer rate cards require assigned account managers who own the commercial relationship, negotiate terms, monitor volume commitments, and handle escalations. This is standard practice in marit',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: A rate card is a negotiated or published pricing instrument anchored to a master port tariff schedule. Linking rate_card to port_tariff establishes the authoritative base tariff from which the rate ca',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the specific customer or shipping line to which this rate card applies. Null if rate card is segment-based rather than customer-specific.',
    `receivable_account_id` BIGINT COMMENT 'Foreign key linking to billing.receivable_account. Business justification: A rate card is negotiated with a customer whose billing is managed through a receivable account. Credit limit enforcement during rate card activation and billing frequency alignment require this link.',
    `superseded_by_rate_card_id` BIGINT COMMENT 'Reference to the newer rate card that replaces this one. Null if this rate card is still current or has not been superseded.',
    `terminal_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal. Business justification: Rate cards are commercial agreements negotiated per terminal (multi-terminal ports have separate rate cards). Contract management, billing, and customer account systems must link rate cards to specifi',
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
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: rate_card_line has caf_applicable_flag indicating Currency Adjustment Factor applies, but no FK to the specific CAF record. Adding this FK links the line to the applicable currency_adjustment (CAF) re',
    `discount_scheme_id` BIGINT COMMENT 'Foreign key linking to tariff.discount_scheme. Business justification: rate_card_line has a discount_percentage column but no FK to the discount_scheme that governs it. Adding discount_scheme_id normalizes the line-level discount reference — a rate_card_line can referenc',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: Rate card lines for controlled or preferential-tariff goods are negotiated at HS code level under trade agreements. Port commercial teams need HS-code-specific pricing in customer rate agreements to a',
    `item_id` BIGINT COMMENT 'Foreign key linking to tariff.tariff_item. Business justification: rate_card_line currently has tariff_item_code (STRING) for business reference, but needs a proper FK to tariff_item to link negotiated rates to the master tariff item definition. This enables joining ',
    `port_location_id` BIGINT COMMENT 'Identifier of the user or role who approved this rate card line, particularly for overrides or exceptions. Supports audit and compliance requirements.',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.bunker_adjustment. Business justification: rate_card_line has baf_applicable_flag indicating Bunker Adjustment Factor applies, but no FK to the specific BAF record. Adding this FK links the line to the applicable bunker_adjustment (BAF) record',
    `rate_card_id` BIGINT COMMENT 'Reference to the parent rate card that contains this line item. Links this pricing line to the overall commercial rate card agreement.',
    `surcharge_rule_id` BIGINT COMMENT 'Foreign key linking to tariff.surcharge_rule. Business justification: rate_card_line has a surcharge_applicable_flag (boolean) indicating a surcharge applies, but no FK to the specific surcharge_rule governing it. Adding surcharge_rule_id normalizes this relationship — ',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Rate card lines specify terminal-zone-specific pricing (e.g., dedicated terminal rates vs. common user terminal rates). terminal_code is a denormalized plain-text reference to terminal_zone. Replacing',
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
    `tier_threshold_lower` DECIMAL(18,2) COMMENT 'Lower bound of the quantity tier for tiered pricing. When quantity falls within this tier, the specified unit rate applies. Null for flat-rate pricing.',
    `tier_threshold_upper` DECIMAL(18,2) COMMENT 'Upper bound of the quantity tier for tiered pricing. When quantity falls within this tier, the specified unit rate applies. Null for flat-rate pricing or open-ended top tier.',
    `unit_of_measure` STRING COMMENT 'The unit of measure for which the unit rate applies. Common values include TEU (Twenty-foot Equivalent Unit), FEU (Forty-foot Equivalent Unit), TON (metric ton or deadweight tonnage), CBM (Cubic Meter), MOVE (container move), HOUR (hourly rate), DAY (daily rate), CALL (per vessel call), UNIT (per equipment unit), CONTAINER (per container), SHIPMENT (per shipment). [ENUM-REF-CANDIDATE: TEU|FEU|TON|CBM|MOVE|HOUR|DAY|CALL|UNIT|CONTAINER|SHIPMENT — 11 candidates stripped; promote to reference product]',
    `unit_rate` DECIMAL(18,2) COMMENT 'The negotiated rate per unit of measure for this tariff item. Represents the base price before any quantity-based discounts or surcharges.',
    `vessel_size_category` STRING COMMENT 'Vessel size category to which this rate applies, used for vessel-related charges such as pilotage, towage, or berth fees. Values include feeder (small feeder vessels), panamax (Panamax class), post_panamax (Post-Panamax), new_panamax (New Panamax), ultra_large (Ultra Large Container Vessels), all (applies to all vessel sizes). Null if not vessel-specific.. Valid values are `feeder|panamax|post_panamax|new_panamax|ultra_large|all`',
    CONSTRAINT pk_rate_card_line PRIMARY KEY(`rate_card_line_id`)
) COMMENT 'Individual pricing line within a rate card, specifying the negotiated rate for a specific tariff item, service, or charge code. Captures the unit rate, unit of measure, minimum quantity, maximum quantity, tiered pricing thresholds, surcharge applicability (BAF, CAF), and override reason. Enables granular rate management at the charge-code level within a commercial rate card.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` (
    `thc_schedule_id` BIGINT COMMENT 'Unique identifier for the THC schedule record. Primary key.',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: THC rate determination during container handling billing is primarily structured by container type (20ft dry, 40ft HC, reefer, OOG). container_type plain text on thc_schedule is a denormalized field',
    `port_tariff_id` BIGINT COMMENT 'add column port_tariff_id (BIGINT) with FK to tariff.port_tariff.port_tariff_id - THC schedules are governed by the overarching port tariff',
    `supersedes_schedule_thc_schedule_id` BIGINT COMMENT 'Reference to the previous THC schedule ID that this schedule replaces or supersedes. Null if this is the initial version.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: THC (Terminal Handling Charges) vary by terminal zone. Currently thc_schedule has terminal_zone as a string code. Adding FK to infrastructure.terminal_zone provides referential integrity and enables j',
    `approval_status` STRING COMMENT 'Current approval status of the THC schedule in the tariff management workflow. Only approved schedules are active for billing.. Valid values are `draft|pending_approval|approved|rejected|suspended|archived`',
    `approved_by` STRING COMMENT 'Username or identifier of the tariff manager or authorized person who approved this schedule.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this THC schedule was approved. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `base_rate_amount` DECIMAL(18,2) COMMENT 'Base THC rate amount per container or TEU before any adjustments, surcharges, or discounts. Expressed in the schedule currency.',
    `cargo_category` STRING COMMENT 'Category of cargo handled. FCL (Full Container Load), LCL (Less than Container Load), RoRo (Roll-on Roll-off), LoLo (Lift-on Lift-off), breakbulk, or bulk cargo.. Valid values are `fcl|lcl|roro|lolo|breakbulk|bulk`',
    `container_size_teu` DECIMAL(18,2) COMMENT 'Container size expressed in TEU for standardized capacity and billing calculations. 20ft = 1.0 TEU, 40ft = 2.0 TEU, 45ft = 2.25 TEU.',
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
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to masterdata.imdg_class. Business justification: DG wharfage surcharge applicability determination requires structured IMDG class linkage. imdg_class plain text on wharfage_schedule is a denormalized field. Wharfage schedules for dangerous goods a',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: wharfage_schedule is a specific tariff sub-schedule (WHR charges on cargo passing over the wharf) that should be anchored to a master port_tariff record. thc_schedule already has port_tariff_id; wharf',
    `superseded_by_schedule_wharfage_schedule_id` BIGINT COMMENT 'Reference to the wharfage_schedule_id that supersedes this tariff entry. Populated when a new version replaces this schedule.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Wharfage charges apply to cargo handled through specific terminal zones. Complements existing berth FK by adding cargo handling location. Required for zone-specific wharfage billing in cargo operation',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Wharfage rate applicability varies by vessel type in port tariff structures. vessel_type plain text on wharfage_schedule is a denormalized field. Structured FK enables automated wharfage schedule se',
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
    `volume_break_lower_limit` DECIMAL(18,2) COMMENT 'Lower volume threshold (in CBM - Cubic Meters) for tiered wharfage pricing. Cargo volume at or above this limit qualifies for this rate tier.',
    `volume_break_upper_limit` DECIMAL(18,2) COMMENT 'Upper volume threshold (in CBM - Cubic Meters) for tiered wharfage pricing. Cargo volume below this limit qualifies for this rate tier. Null indicates no upper limit.',
    `weight_break_lower_limit` DECIMAL(18,2) COMMENT 'Lower weight threshold (in tonnes) for tiered wharfage pricing. Cargo weight at or above this limit qualifies for this rate tier.',
    `weight_break_upper_limit` DECIMAL(18,2) COMMENT 'Upper weight threshold (in tonnes) for tiered wharfage pricing. Cargo weight below this limit qualifies for this rate tier. Null indicates no upper limit.',
    CONSTRAINT pk_wharfage_schedule PRIMARY KEY(`wharfage_schedule_id`)
) COMMENT 'Wharfage (WHR) tariff schedule defining port dues levied on cargo passing over the wharf. Captures wharfage rates by cargo type, HS Code category, unit of measure (tonne, CBM, TEU), vessel type, trade direction (import/export/coastal), and berth zone. Includes minimum wharfage thresholds, exemption conditions (e.g., transshipment cargo), and regulatory approval references. Feeds directly into the billing domain for WHR charge generation.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` (
    `storage_tariff_id` BIGINT COMMENT 'Unique identifier for the storage tariff schedule record. Primary key.',
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to masterdata.imdg_class. Business justification: DG storage tariff determination and billing requires structured IMDG class linkage. imdg_class plain text on storage_tariff is a denormalized field. Dangerous goods storage rates are differentiated ',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Storage rates differentiate by container size/type (container_size_type attribute). Links to ISO container specifications for accurate TEU calculation, yard space allocation, and standardized billing.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Storage tariffs vary by zone security classification (public yard vs. restricted customs zone vs. high-security dangerous goods area). Warehouse billing systems link tariff schedules to zones to deter',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: storage_tariff defines container and cargo storage charges and is a specific tariff sub-schedule that should reference the master port_tariff. Currently storage_tariff has no port_tariff_id FK, creati',
    `superseded_by_tariff_storage_tariff_id` BIGINT COMMENT 'Reference to the storage tariff ID that replaces this tariff schedule, enabling version lineage tracking. Null if current version.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Container storage charges are zone-specific based on zone type, ground slot capacity, reefer availability, and hazmat approval. Direct operational link for storage billing. Replaces denormalized stora',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Warehouse storage tariffs depend on facility type, temperature control, bonded status, and floor load capacity. Natural link for cargo storage billing in CFS and bonded warehouse operations. Essential',
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

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` (
    `surcharge_rule_id` BIGINT COMMENT 'Unique identifier for the surcharge rule record. Primary key.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Channel-specific surcharges (canal transit surcharges, channel maintenance levies, VTS surcharges) are a named charge type in port operations. Linking surcharge rules to the specific navigation channe',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: Dangerous goods, dual-use, and controlled cargo surcharges are defined at HS code level. Port tariff teams create surcharge rules scoped to specific HS codes (e.g., IMDG class surcharges, dual-use goo',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: ISPS security surcharge rules are triggered by the security level declared in an ISPS facility record. Port tariff teams define surcharge rules that activate at ISPS Level 2/3; linking to the facility',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Surcharge rules (BAF, CAF, peak season, security levies) are port-specific in maritime operations. Port authorities publish and manage surcharge rules per port. Port-level surcharge rule management, r',
    `port_tariff_id` BIGINT COMMENT 'add column port_tariff_id (BIGINT) with FK to tariff.port_tariff.port_tariff_id - surcharge rules modify base tariffs and must reference the applicable tariff',
    `superseded_by_rule_surcharge_rule_id` BIGINT COMMENT 'Reference to the surcharge_rule_id that supersedes this rule. Null if this is the current active version. Enables navigation through rule version history.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Terminal-zone-specific surcharges (reefer zone surcharges, hazmat zone handling surcharges, peak zone congestion surcharges) are real operational charge types. Linking surcharge rules to terminal_zone',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Surcharge applicability determination (BAF, CAF, peak season) during invoice generation requires structured vessel type scoping. vessel_type_applicability is a denormalized text field; a proper FK e',
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
    CONSTRAINT pk_surcharge_rule PRIMARY KEY(`surcharge_rule_id`)
) COMMENT 'Unified definition of all applicable surcharges and adjustment factors layered on top of base tariff rates, maintained as versioned time-series records. Covers BAF (Bunker Adjustment Factor) with fuel index references (Platts, MOPS, Singapore), calculation method (flat per TEU or percentage), and trade lane scope; CAF (Currency Adjustment Factor) with currency pair, percentage, and calculation base (percentage of freight or THC); PIL (Port Infrastructure Levy); ISPS security surcharge; peak season surcharge; hazardous cargo (IMDG) surcharge; OOG (out-of-gauge) surcharge; cold ironing surcharge; and any other periodic or conditional surcharge. Each record defines the surcharge type discriminator, calculation method (flat fee, percentage of base, per unit), rate amount or percentage, applicable index reference, effective period, trade lane scope, vessel type applicability, publication authority, and applicability conditions. New surcharge types are added as new rows — no schema changes required. Enables historical surcharge reconstruction for billing disputes and audit.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` (
    `discount_scheme_id` BIGINT COMMENT 'Unique identifier for the discount scheme. Primary key.',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Volume discount schemes and loyalty programs in port operations are port-specific commercial instruments. Port-level discount scheme management, approval workflows, and commercial performance reportin',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Discount schemes require designated owners with approval authority to evaluate customer requests, verify eligibility criteria, authorize exceptions, monitor scheme utilization, and conduct periodic re',
    `port_tariff_id` BIGINT COMMENT 'add column port_tariff_id (BIGINT) with FK to tariff.port_tariff.port_tariff_id - discount schemes must reference which port tariff they apply against',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Discount eligibility determination during billing requires structured vessel type restriction. vessel_type_restriction plain text on discount_scheme is a denormalized field. Ports offer vessel-type-',
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
    `threshold_period` STRING COMMENT 'Time period over which the threshold is measured and evaluated: per vessel call, monthly, quarterly, annually, or over the entire contract term.. Valid values are `per_call|monthly|quarterly|annually|contract_term`',
    `threshold_type` STRING COMMENT 'Type of qualifying threshold that must be met to earn the discount: TEU (Twenty-foot Equivalent Unit) volume, vessel call frequency, cargo tonnage, revenue value, container count, or none for unconditional discounts.. Valid values are `teu_volume|call_frequency|cargo_tonnage|revenue_value|container_count|none`',
    `threshold_unit` STRING COMMENT 'Unit of measure for the threshold value: TEU (Twenty-foot Equivalent Unit), FEU (Forty-foot Equivalent Unit), vessel calls, metric tonnes (MT), cubic meters (CBM), container count, or currency. [ENUM-REF-CANDIDATE: TEU|FEU|calls|tonnes|MT|CBM|containers|USD|EUR — 9 candidates stripped; promote to reference product]',
    `threshold_value` DECIMAL(18,2) COMMENT 'Numeric threshold value that must be met or exceeded to qualify for the discount. Interpretation depends on threshold_type (e.g., 1000 TEU, 12 calls, 50000 tonnes).',
    `created_by` STRING COMMENT 'User ID or name of the person who created this discount scheme record. Required for governance and accountability.',
    CONSTRAINT pk_discount_scheme PRIMARY KEY(`discount_scheme_id`)
) COMMENT 'Commercial discount scheme defining volume-based, loyalty-based, or promotional discounts applicable to port service charges. Captures discount scheme name, discount type (percentage, flat rate, free days), applicable tariff items or charge codes, qualifying thresholds (TEU volume, call frequency, cargo tonnage), customer tier eligibility, effective period, and approval authority. Enables the port to offer competitive pricing to high-volume shipping lines and cargo owners.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` (
    `port_dues_schedule_id` BIGINT COMMENT 'Unique identifier for the port dues schedule record. Primary key for this entity.',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Anchorage dues are standard maritime charges for vessels at anchorage. Dues vary by anchorage area designation, security zone, and holding duration. Essential for anchorage-specific billing in vessel ',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Port dues often calculated based on berth utilization, berth depth, and LOA capacity. Regulatory filings and tariff schedules reference specific berths for dues calculation. Required for berth-specifi',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Channel transit dues are a distinct dues type in port operations — vessels pay dues specific to the navigation channel used. Channel-specific dues schedules enable accurate billing for channel transit',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: Port dues are national-level charges subject to country-specific regulations, international maritime conventions (SOLAS, MARPOL), and trade agreements. Country context determines regulatory framework,',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Port dues schedules include ISPS security levies tied to facility security level. Real cost recovery mechanism for maritime security compliance mandated by SOLAS.',
    `flag_state_id` BIGINT COMMENT 'Foreign key linking to masterdata.flag_state. Business justification: Port dues often have flag state differentials (flag_state attribute). Bilateral maritime agreements, reciprocity arrangements, and flag state performance affect rates. Links to flag state master for t',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Port dues schedules are issued by a port authority for a specific port. Regulatory reporting, dues calculation, and port authority revenue management all require linking dues schedules to the port ent',
    `port_location_id` BIGINT COMMENT 'Identifier of the user who created this port dues schedule record in the system. Required for audit trail and accountability.',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: port_dues_schedule defines statutory vessel call charges and is a specific tariff sub-schedule that should reference the master port_tariff. Currently port_dues_schedule has no port_tariff_id FK. Esta',
    `superseded_by_schedule_port_dues_schedule_id` BIGINT COMMENT 'Reference to the port dues schedule that replaces this schedule. Nullable for current active schedules. Maintains version history and audit trail for regulatory compliance.',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Port dues calculation is fundamentally structured by vessel type (tanker, container, bulk, RoRo). vessel_type plain text on port_dues_schedule is a denormalized field. Every port dues billing proces',
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
    CONSTRAINT pk_port_dues_schedule PRIMARY KEY(`port_dues_schedule_id`)
) COMMENT 'Port dues (port call charges) schedule defining the statutory charges levied on vessels calling at the port. Captures dues type (light dues, conservancy dues, port entry fee, anchorage dues), vessel classification (GRT band, vessel type, flag state), trade type (international, coastal, domestic), call frequency discounts, and regulatory authority reference. Distinct from cargo-based wharfage; port dues are vessel-based charges payable by the shipowner or agent per vessel call.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` (
    `item_surcharge_applicability_id` BIGINT COMMENT 'Unique identifier for this item-surcharge applicability record. Primary key.',
    `item_id` BIGINT COMMENT 'Foreign key linking to the base tariff item to which the surcharge rule applies',
    `surcharge_rule_id` BIGINT COMMENT 'Foreign key linking to the surcharge rule that applies to the tariff item',
    `applicability_conditions` STRING COMMENT 'Specific conditions under which this surcharge applies to this tariff item (e.g., applies only to reefer containers for THC charges, applies to hazmat cargo only for wharfage). This is relationship-specific because the same surcharge may have different applicability conditions for different charge types.',
    `approved_by` STRING COMMENT 'Name or identifier of the tariff administrator who approved this applicability rule for publication',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this applicability rule was approved',
    `calculation_priority` STRING COMMENT 'Numeric priority order for applying this surcharge to this specific tariff item when multiple surcharges are stacked. Lower numbers are applied first. This is relationship-specific because the same surcharge may have different priorities when applied to different charge types.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this applicability rule was first created in the system',
    `effective_from_date` DATE COMMENT 'Date from which this surcharge applicability rule becomes active for this specific item-surcharge combination. This is relationship-specific because a surcharge may be applied to different charge items at different times during a phased rollout.',
    `effective_to_date` DATE COMMENT 'Date until which this surcharge applicability rule remains active for this specific item-surcharge combination. Null indicates indefinite applicability. This is relationship-specific to support phased removal of surcharges from different charge types.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this applicability rule was last modified',
    `override_flag` BOOLEAN COMMENT 'Indicates whether this applicability rule overrides default surcharge application logic for this specific item-surcharge combination. Used when a surcharge that normally applies to a charge category is explicitly excluded for a specific item, or vice versa.',
    CONSTRAINT pk_item_surcharge_applicability PRIMARY KEY(`item_surcharge_applicability_id`)
) COMMENT 'This association product represents the formal applicability rules between base tariff items and surcharge rules in port tariff administration. It captures which surcharges (BAF, CAF, ISPS, peak season, etc.) apply to which base charge items, with specific calculation priorities, effective periods, and override conditions for each combination. Each record links one tariff item to one surcharge rule with attributes that govern how the surcharge is applied to that specific charge type. This is a formally managed business concept in maritime tariff publishing, where port authorities explicitly define and version surcharge applicability matrices.. Existence Justification: In port tariff administration, surcharge applicability is a formally managed business concept where port authorities explicitly define which surcharges (BAF, CAF, ISPS, peak season) apply to which base tariff items. A single tariff item (e.g., THC per TEU) can have multiple surcharges applied to it simultaneously (BAF + CAF + ISPS), and a single surcharge rule (e.g., BAF) applies to multiple different charge types (THC, wharfage, pilotage, storage). The relationship itself carries business data including calculation priority (order of application), applicability conditions (specific to each item-surcharge pair), and effective dates (surcharges are rolled out to different charge types at different times).';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ADD CONSTRAINT `fk_tariff_port_tariff_superseded_by_tariff_port_tariff_id` FOREIGN KEY (`superseded_by_tariff_port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_port_dues_schedule_id` FOREIGN KEY (`port_dues_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule`(`port_dues_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_storage_tariff_id` FOREIGN KEY (`storage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`storage_tariff`(`storage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_thc_schedule_id` FOREIGN KEY (`thc_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`thc_schedule`(`thc_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_wharfage_schedule_id` FOREIGN KEY (`wharfage_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule`(`wharfage_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_discount_scheme_id` FOREIGN KEY (`discount_scheme_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`discount_scheme`(`discount_scheme_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_superseded_by_rate_card_id` FOREIGN KEY (`superseded_by_rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ADD CONSTRAINT `fk_tariff_rate_card_line_discount_scheme_id` FOREIGN KEY (`discount_scheme_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`discount_scheme`(`discount_scheme_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ADD CONSTRAINT `fk_tariff_rate_card_line_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ADD CONSTRAINT `fk_tariff_rate_card_line_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ADD CONSTRAINT `fk_tariff_rate_card_line_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ADD CONSTRAINT `fk_tariff_rate_card_line_surcharge_rule_id` FOREIGN KEY (`surcharge_rule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule`(`surcharge_rule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ADD CONSTRAINT `fk_tariff_thc_schedule_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ADD CONSTRAINT `fk_tariff_thc_schedule_supersedes_schedule_thc_schedule_id` FOREIGN KEY (`supersedes_schedule_thc_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`thc_schedule`(`thc_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ADD CONSTRAINT `fk_tariff_wharfage_schedule_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ADD CONSTRAINT `fk_tariff_wharfage_schedule_superseded_by_schedule_wharfage_schedule_id` FOREIGN KEY (`superseded_by_schedule_wharfage_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule`(`wharfage_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ADD CONSTRAINT `fk_tariff_storage_tariff_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ADD CONSTRAINT `fk_tariff_storage_tariff_superseded_by_tariff_storage_tariff_id` FOREIGN KEY (`superseded_by_tariff_storage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`storage_tariff`(`storage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ADD CONSTRAINT `fk_tariff_surcharge_rule_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ADD CONSTRAINT `fk_tariff_surcharge_rule_superseded_by_rule_surcharge_rule_id` FOREIGN KEY (`superseded_by_rule_surcharge_rule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule`(`surcharge_rule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ADD CONSTRAINT `fk_tariff_discount_scheme_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_superseded_by_schedule_port_dues_schedule_id` FOREIGN KEY (`superseded_by_schedule_port_dues_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule`(`port_dues_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` ADD CONSTRAINT `fk_tariff_item_surcharge_applicability_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` ADD CONSTRAINT `fk_tariff_item_surcharge_applicability_surcharge_rule_id` FOREIGN KEY (`surcharge_rule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule`(`surcharge_rule_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`tariff` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_shipping_ports_v1`.`tariff` SET TAGS ('dbx_domain' = 'tariff');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` SET TAGS ('dbx_subdomain' = 'schedule_management');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Restriction Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ALTER COLUMN `superseded_by_tariff_port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Tariff ID');
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
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` SET TAGS ('dbx_subdomain' = 'schedule_management');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `item_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Item Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Mooring Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Towage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Detention Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `port_dues_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Port Dues Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Schedule Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `storage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Demurrage Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `thc_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Thc Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` SET TAGS ('dbx_subdomain' = 'pricing_agreements');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `customs_broker_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `discount_scheme_id` SET TAGS ('dbx_business_glossary_term' = 'Discount Scheme Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Account Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Customer Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `receivable_account_id` SET TAGS ('dbx_business_glossary_term' = 'Receivable Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `superseded_by_rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Rate Card Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ALTER COLUMN `terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` SET TAGS ('dbx_subdomain' = 'pricing_agreements');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `rate_card_line_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Line Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Currency Adjustment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `discount_scheme_id` SET TAGS ('dbx_business_glossary_term' = 'Discount Scheme Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `item_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Item Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Bunker Adjustment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `surcharge_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Rule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `tier_threshold_lower` SET TAGS ('dbx_business_glossary_term' = 'Tier Threshold Lower Bound');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `tier_threshold_upper` SET TAGS ('dbx_business_glossary_term' = 'Tier Threshold Upper Bound');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `unit_rate` SET TAGS ('dbx_business_glossary_term' = 'Unit Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `vessel_size_category` SET TAGS ('dbx_business_glossary_term' = 'Vessel Size Category');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ALTER COLUMN `vessel_size_category` SET TAGS ('dbx_value_regex' = 'feeder|panamax|post_panamax|new_panamax|ultra_large|all');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` SET TAGS ('dbx_subdomain' = 'schedule_management');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `thc_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Handling Charge (THC) Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Container Type Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` SET TAGS ('dbx_subdomain' = 'schedule_management');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `wharfage_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Wharfage Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Imdg Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `superseded_by_schedule_wharfage_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `volume_break_lower_limit` SET TAGS ('dbx_business_glossary_term' = 'Volume Break Lower Limit');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `volume_break_upper_limit` SET TAGS ('dbx_business_glossary_term' = 'Volume Break Upper Limit');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `weight_break_lower_limit` SET TAGS ('dbx_business_glossary_term' = 'Weight Break Lower Limit');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ALTER COLUMN `weight_break_upper_limit` SET TAGS ('dbx_business_glossary_term' = 'Weight Break Upper Limit');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` SET TAGS ('dbx_subdomain' = 'schedule_management');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `storage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Tariff ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Imdg Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `superseded_by_tariff_storage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Tariff ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` SET TAGS ('dbx_subdomain' = 'pricing_agreements');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `surcharge_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Rule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `superseded_by_rule_surcharge_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Rule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` SET TAGS ('dbx_subdomain' = 'pricing_agreements');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `discount_scheme_id` SET TAGS ('dbx_business_glossary_term' = 'Discount Scheme ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Scheme Owner Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `threshold_period` SET TAGS ('dbx_business_glossary_term' = 'Threshold Measurement Period');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `threshold_period` SET TAGS ('dbx_value_regex' = 'per_call|monthly|quarterly|annually|contract_term');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `threshold_type` SET TAGS ('dbx_business_glossary_term' = 'Threshold Type');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `threshold_type` SET TAGS ('dbx_value_regex' = 'teu_volume|call_frequency|cargo_tonnage|revenue_value|container_count|none');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `threshold_unit` SET TAGS ('dbx_business_glossary_term' = 'Threshold Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `threshold_value` SET TAGS ('dbx_business_glossary_term' = 'Threshold Value');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` SET TAGS ('dbx_subdomain' = 'schedule_management');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `port_dues_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Port Dues Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `flag_state_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Flag State Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `superseded_by_schedule_port_dues_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Schedule ID');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` SET TAGS ('dbx_subdomain' = 'pricing_agreements');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` SET TAGS ('dbx_association_edges' = 'tariff.item,tariff.surcharge_rule');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` ALTER COLUMN `item_surcharge_applicability_id` SET TAGS ('dbx_business_glossary_term' = 'Item Surcharge Applicability Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` ALTER COLUMN `item_id` SET TAGS ('dbx_business_glossary_term' = 'Item Surcharge Applicability - Item Id');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` ALTER COLUMN `surcharge_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Item Surcharge Applicability - Surcharge Rule Id');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` ALTER COLUMN `applicability_conditions` SET TAGS ('dbx_business_glossary_term' = 'Applicability Conditions');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` ALTER COLUMN `calculation_priority` SET TAGS ('dbx_business_glossary_term' = 'Calculation Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item_surcharge_applicability` ALTER COLUMN `override_flag` SET TAGS ('dbx_business_glossary_term' = 'Override Flag');
