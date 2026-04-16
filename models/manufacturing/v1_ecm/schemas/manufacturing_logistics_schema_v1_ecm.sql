-- Schema for Domain: logistics | Business: Manufacturing | Version: v1_ecm
-- Generated on: 2026-04-16 07:42:35

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`logistics` COMMENT 'Manages inbound and outbound freight, transportation planning, carrier selection and management, freight optimization, TMS-driven route optimization, shipment tracking, customs/trade compliance documentation, and delivery performance across global distribution networks.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`shipment_item` (
    `shipment_item_id` BIGINT COMMENT 'Unique surrogate identifier for each shipment item line record in the silver layer lakehouse. Serves as the primary key for item-level traceability across the logistics domain.',
    `batch_id` BIGINT COMMENT 'Foreign key linking to production.batch. Business justification: Shipment items must reference production batches for traceability, quality control, and recall management. Critical for regulated industries (pharma, food, automotive) to track which batch was shipped',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Shipment items must reference the specific engineered component being transported. Logistics teams use this daily to verify correct parts are shipped, handle dimensions/weight for freight planning, an',
    `lot_batch_id` BIGINT COMMENT 'Foreign key linking to inventory.lot_batch. Business justification: Manufacturing requires lot traceability for quality control and recalls. Each shipped item must track which production batch it came from for compliance and traceability.',
    `packaging_id` BIGINT COMMENT 'Foreign key linking to logistics.packaging. Business justification: shipment_item.packaging_type is a denormalized reference to the packaging master. Adding packaging_id FK normalizes this to the packaging master record, enabling packaging configuration lookups. packa',
    `serialized_unit_id` BIGINT COMMENT 'Foreign key linking to inventory.serialized_unit. Business justification: High-value industrial equipment and automation systems require serial-level tracking. Logistics must record which specific serialized unit was shipped for warranty and service management.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: shipment_item is a line-level child record of shipment. shipment_item.shipment_number is a denormalized string reference to the parent shipment. Replacing with shipment_id FK enforces referential inte',
    `stock_position_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_position. Business justification: Shipment items must reference the exact stock position being picked and shipped. Warehouse operations use this to decrement inventory from specific locations during order fulfillment.',
    `actual_delivery_date` DATE COMMENT 'Date on which this shipment item was physically delivered and confirmed at the customer or destination location. Used to calculate on-time delivery performance against promised delivery date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating where the material was manufactured or substantially transformed. Required for customs declarations, preferential tariff determination, and trade compliance under CE Marking and REACH/RoHS regulations.. Valid values are `^[A-Z]{3}$`',
    `customs_value` DECIMAL(18,2) COMMENT 'Declared monetary value of this shipment item for customs purposes, used to calculate import duties and taxes. Must align with the transaction value per WTO Customs Valuation Agreement.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `customs_value_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the customs declared value (e.g., USD, EUR, GBP). Required for accurate duty calculation and customs declaration filing.. Valid values are `^[A-Z]{3}$`',
    `delivery_document_number` STRING COMMENT 'SAP S/4HANA outbound delivery document number (Lieferschein) associated with this shipment item. Used for goods issue posting and proof-of-delivery reconciliation.',
    `export_control_classification` STRING COMMENT 'Export Control Classification Number (ECCN) or EAR99 designation assigned to this item under the US Export Administration Regulations. Determines whether an export license is required for shipment to specific countries.. Valid values are `EAR99|ECCN [A-Z][0-9][A-Z][0-9]{3}|NLR|AT|NS|MT|CB|CC|EI|RS|SL|SS|FC|UN|AT`',
    `goods_issue_date` DATE COMMENT 'Date on which goods were officially issued from the warehouse and ownership/risk transferred per the applicable Incoterms. Triggers revenue recognition and inventory reduction in SAP S/4HANA.. Valid values are `^d{4}-d{2}-d{2}$`',
    `gross_weight_kg` DECIMAL(18,2) COMMENT 'Total gross weight of the shipped item including all packaging materials in kilograms. Required for freight billing, carrier manifests, and customs documentation.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `hazmat_class` STRING COMMENT 'UN/DOT hazardous material classification class for this shipment item (e.g., Class 3 for flammable liquids, Class 8 for corrosives). Required on shipping manifests and dangerous goods declarations.. Valid values are `1|1.1|1.2|1.3|1.4|1.5|1.6|2.1|2.2|2.3|3|4.1|4.2|4.3|5.1|5.2|6.1|6.2|7|8|9`',
    `hs_code` STRING COMMENT 'Customs tariff classification code under the World Customs Organization Harmonized System. Mandatory for customs declarations, import/export duty calculation, and trade compliance reporting across global distribution networks.. Valid values are `^[0-9]{6,10}$`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the division of costs, risks, and responsibilities between seller and buyer for this shipment item. Governs title transfer and insurance obligations.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `is_hazardous` BOOLEAN COMMENT 'Indicates whether this shipment item contains hazardous materials requiring special handling, labeling, and transport documentation under IMDG, IATA DGR, or ADR regulations.. Valid values are `true|false`',
    `is_reach_compliant` BOOLEAN COMMENT 'Indicates whether this shipment item complies with EU REACH (Registration, Evaluation, Authorisation and Restriction of Chemicals) Regulation (EC) No 1907/2006. Required for export to EU markets and customer compliance declarations.. Valid values are `true|false`',
    `is_rohs_compliant` BOOLEAN COMMENT 'Indicates whether this shipment item complies with EU RoHS (Restriction of Hazardous Substances) Directive 2011/65/EU, restricting use of specific hazardous materials in electrical and electronic equipment.. Valid values are `true|false`',
    `item_status` STRING COMMENT 'Current processing status of this shipment item line across the outbound logistics lifecycle, from warehouse picking through final delivery confirmation.. Valid values are `PLANNED|PICKED|PACKED|GOODS_ISSUED|IN_TRANSIT|DELIVERED|PARTIALLY_DELIVERED|RETURNED|CANCELLED`',
    `line_number` STRING COMMENT 'Sequential line number identifying the position of this item within the parent shipment. Used to distinguish multiple SKUs or materials packed within the same shipment.. Valid values are `^[1-9][0-9]*$`',
    `material_description` STRING COMMENT 'Short descriptive name of the material or product being shipped as defined in the SAP material master. Used for shipping documentation, customs declarations, and customer-facing delivery notes.',
    `material_number` STRING COMMENT 'SAP S/4HANA material master number (MATNR) identifying the specific material or component being shipped. Core identifier for inventory and supply chain traceability.',
    `net_weight_kg` DECIMAL(18,2) COMMENT 'Net weight of the shipped item in kilograms, excluding packaging materials. Used for freight cost calculation, customs declarations, and carrier weight compliance.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `package_count` STRING COMMENT 'Number of individual packages or handling units comprising this shipment item line. Used for carrier manifest preparation, receiving verification, and proof-of-delivery confirmation.. Valid values are `^[1-9][0-9]*$`',
    `plant_code` STRING COMMENT 'SAP S/4HANA plant code identifying the manufacturing or distribution facility from which this item was shipped. Used for inventory valuation, cost allocation, and regional compliance reporting.',
    `promised_delivery_date` DATE COMMENT 'Committed delivery date for this shipment item as confirmed to the customer via Available-to-Promise (ATP) or Capable-to-Promise (CTP) check in SAP S/4HANA. Used for on-time delivery KPI measurement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `quantity_ordered` DECIMAL(18,2) COMMENT 'Original quantity requested on the sales order line for this material. Used to calculate fulfillment rate and identify short-shipments or over-shipments.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `quantity_shipped` DECIMAL(18,2) COMMENT 'Actual quantity of the material dispatched in this shipment item line. Compared against ordered quantity to identify partial shipments and calculate fulfillment rates.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `sales_order_line_number` STRING COMMENT 'Line item number on the originating sales order corresponding to this shipment item. Supports item-level order-to-delivery reconciliation.. Valid values are `^[1-9][0-9]*$`',
    `sales_order_number` STRING COMMENT 'Reference to the originating sales order number from SAP S/4HANA SD. Enables traceability from physical delivery back to the customer order.',
    `sku_code` STRING COMMENT 'Stock Keeping Unit code representing the specific product variant being shipped, including packaging and configuration. Used for warehouse picking, inventory management, and order fulfillment.',
    `special_handling_instructions` STRING COMMENT 'Free-text field capturing any special handling, stacking, orientation, or fragility instructions for this shipment item. Communicated to carriers and warehouse staff to prevent damage in transit.',
    `storage_location` STRING COMMENT 'SAP S/4HANA or Infor WMS storage location code from which the material was picked and issued for this shipment. Supports warehouse inventory reconciliation and goods issue posting.',
    `temperature_requirement` STRING COMMENT 'Temperature handling requirement for this shipment item during transport and storage. Relevant for temperature-sensitive materials such as chemicals, adhesives, or electronic components requiring controlled environments.. Valid values are `AMBIENT|CHILLED|FROZEN|CONTROLLED_ROOM_TEMP|DEEP_FROZEN`',
    `un_number` STRING COMMENT 'United Nations four-digit identification number for hazardous substances and articles (e.g., UN1950 for aerosols). Mandatory on dangerous goods shipping documents and labels.. Valid values are `^UN[0-9]{4}$`',
    `unit_of_measure` STRING COMMENT 'Unit of measure in which the shipped quantity is expressed (e.g., EA for each, KG for kilogram, PAL for pallet). Aligned with SAP base unit of measure and GS1 UOM standards.. Valid values are `EA|KG|LB|M|M2|M3|L|PC|SET|BOX|PAL|ROL|MTR|TON`',
    `unit_price` DECIMAL(18,2) COMMENT 'Selling price per unit of measure for this shipment item as invoiced to the customer. Used for commercial invoice preparation, revenue recognition, and customs valuation.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `unit_price_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the unit price (e.g., USD, EUR). Supports multi-currency operations across global distribution networks.. Valid values are `^[A-Z]{3}$`',
    `volume_m3` DECIMAL(18,2) COMMENT 'Volumetric measurement of the shipped item in cubic meters. Used for freight space planning, dimensional weight calculation, and container load optimization.. Valid values are `^[0-9]+(.[0-9]{1,6})?$`',
    CONSTRAINT pk_shipment_item PRIMARY KEY(`shipment_item_id`)
) COMMENT 'Line-level detail for each SKU or material included within a shipment. Records part number, quantity shipped, unit of measure, net/gross weight, package count, hazardous classification (REACH/RoHS flags), country of origin, and customs tariff code (HS code). Enables item-level traceability from sales order line to physical delivery.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`carrier` (
    `carrier_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for each approved freight carrier or logistics service provider (LSP) record in the master data.',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: Carriers are vendors with legal entity status for AP processing, tax reporting, and payment execution. Finance validates legal entity data for compliance.',
    `api_integration_type` STRING COMMENT 'Type of digital integration method used to exchange shipment data with the carriers systems. Determines TMS connectivity configuration and automation capability.. Valid values are `rest_api|soap_api|edi|flat_file|portal_only|none`',
    `approved_date` DATE COMMENT 'Date on which the carrier was formally approved and added to the approved carrier list (ACL) following qualification review, insurance verification, and compliance checks.. Valid values are `^d{4}-d{2}-d{2}$`',
    `cargo_liability_limit` DECIMAL(18,2) COMMENT 'Maximum monetary value (in contract currency) the carrier is liable for in the event of cargo loss or damage, as specified in the insurance certificate and transportation contract.. Valid values are `^d+(.d{1,2})?$`',
    `claims_ratio` DECIMAL(18,2) COMMENT 'Percentage of shipments resulting in a freight damage or loss claim over the trailing 12-month period. Used in carrier performance evaluation and risk assessment.. Valid values are `^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$`',
    `code` STRING COMMENT 'Internal alphanumeric code assigned to the carrier within the enterprise TMS and ERP systems for cross-system referencing and freight audit.. Valid values are `^[A-Z0-9]{2,10}$`',
    `contract_end_date` DATE COMMENT 'Expiration date of the current transportation services contract. Triggers contract renewal workflows and restricts carrier use in TMS after expiry.. Valid values are `^d{4}-d{2}-d{2}$`',
    `contract_reference` STRING COMMENT 'Reference number or identifier of the master transportation services agreement or rate contract governing the carrier relationship. Links to the contract management system for rate and SLA validation.',
    `contract_start_date` DATE COMMENT 'Effective start date of the current transportation services contract with the carrier. Used for contract validity checks during freight booking and audit.. Valid values are `^d{4}-d{2}-d{2}$`',
    `country_of_registration` STRING COMMENT 'ISO 3166-1 alpha-3 country code where the carrier is legally registered and incorporated. Used for trade compliance, customs documentation, and regulatory verification.. Valid values are `^[A-Z]{3}$`',
    `customs_broker_license` STRING COMMENT 'License number issued by the relevant customs authority (e.g., CBP in the US) if the carrier also provides customs brokerage services. Supports trade compliance documentation for cross-border shipments.',
    `dot_number` STRING COMMENT 'USDOT-issued unique identifier required for commercial motor carriers operating in interstate commerce in the United States. Used for safety compliance verification and freight audit.. Valid values are `^[0-9]{6,8}$`',
    `duns_number` STRING COMMENT 'Dun & Bradstreet-assigned 9-digit Data Universal Numbering System (DUNS) number uniquely identifying the carriers business entity. Used for supplier onboarding, credit checks, and SAP Ariba supplier management.. Valid values are `^[0-9]{9}$`',
    `edi_capable` BOOLEAN COMMENT 'Indicates whether the carrier supports Electronic Data Interchange (EDI) for automated shipment tendering, status updates (214), and freight invoice exchange (210). Drives TMS integration configuration.. Valid values are `true|false`',
    `edi_qualifier` STRING COMMENT 'EDI interchange ID qualifier code used to identify the carrier in ANSI X12 EDI transactions (e.g., 02 for SCAC). Required for TMS EDI integration setup.',
    `geographic_coverage` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes or region descriptors representing the carriers operational service territory. Used in TMS lane-to-carrier matching.',
    `hazmat_certified` BOOLEAN COMMENT 'Indicates whether the carrier is certified and authorized to transport hazardous materials (HAZMAT) in compliance with applicable regulations. Required for shipments of chemicals, batteries, and industrial components.. Valid values are `true|false`',
    `headquarters_city` STRING COMMENT 'City where the carriers principal place of business is located. Used for geographic coverage analysis and carrier proximity assessments.',
    `headquarters_country` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the carriers principal place of business. May differ from country of registration for multinational carriers.. Valid values are `^[A-Z]{3}$`',
    `iata_code` STRING COMMENT 'Two or three character IATA-assigned airline or air freight carrier code used for air freight bookings, airway bill generation, and global air cargo tracking.. Valid values are `^[A-Z0-9]{2,3}$`',
    `insurance_certificate_number` STRING COMMENT 'Reference number of the carriers current certificate of insurance (COI) covering cargo liability, general liability, and auto liability. Required for carrier approval and compliance audits.',
    `insurance_expiry_date` DATE COMMENT 'Expiration date of the carriers insurance certificate. Automated alerts are triggered before expiry to ensure continuous coverage and prevent use of uninsured carriers.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_review_date` DATE COMMENT 'Date of the most recent periodic carrier qualification review covering performance, compliance, insurance, and financial stability. Supports ISO 9001 supplier re-evaluation requirements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `legal_name` STRING COMMENT 'Full legal registered business name of the freight carrier or logistics service provider as it appears on contracts, invoices, and regulatory filings.',
    `liability_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the cargo liability limit amount (e.g., USD, EUR, GBP). Supports multi-currency freight audit and claims processing.. Valid values are `^[A-Z]{3}$`',
    `mc_number` STRING COMMENT 'FMCSA-issued Motor Carrier (MC) operating authority number required for for-hire carriers transporting regulated commodities in interstate commerce. Validates carriers legal right to operate.. Valid values are `^MC-?[0-9]{6,8}$`',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic carrier qualification review. Triggers automated review workflow initiation in the supplier management system.. Valid values are `^d{4}-d{2}-d{2}$`',
    `on_time_delivery_rate` DECIMAL(18,2) COMMENT 'Percentage of shipments delivered on or before the committed delivery date over the trailing 12-month period. Key performance indicator (KPI) for carrier scorecard and performance tier assignment.. Valid values are `^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$`',
    `performance_tier` STRING COMMENT 'Carrier classification tier based on historical delivery performance, compliance scores, and strategic relationship value. Drives carrier selection priority in TMS route optimization and RFQ processes.. Valid values are `preferred|approved|conditional|probationary|disqualified`',
    `primary_contact_email` STRING COMMENT 'Business email address of the primary carrier account contact. Used for shipment notifications, rate negotiations, and operational communications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `primary_contact_name` STRING COMMENT 'Full name of the primary business contact at the carrier organization responsible for account management, escalations, and contract negotiations.',
    `primary_contact_phone` STRING COMMENT 'Business phone number of the primary carrier account contact. Used for urgent shipment escalations and operational coordination.. Valid values are `^+?[0-9s-().]{7,20}$`',
    `safety_rating` STRING COMMENT 'Official safety fitness rating assigned by the FMCSA (Federal Motor Carrier Safety Administration) for road carriers. Used in carrier qualification and compliance screening.. Valid values are `satisfactory|conditional|unsatisfactory|not_rated`',
    `scac_code` STRING COMMENT 'Unique 2–4 letter Standard Carrier Alpha Code (SCAC) assigned by the National Motor Freight Traffic Association (NMFTA) to identify the carrier in EDI transactions, freight bills, and TMS route planning.. Valid values are `^[A-Z]{2,4}$`',
    `service_modes` STRING COMMENT 'Comma-separated list of specific service offerings provided by the carrier (e.g., FTL, LTL, FCL, LCL, express, standard, white-glove, temperature-controlled). Supports TMS service-level matching.',
    `status` STRING COMMENT 'Current operational status of the carrier master record. Controls whether the carrier is available for TMS route planning, freight booking, and purchase order assignment.. Valid values are `active|inactive|suspended|pending_approval|blacklisted|under_review`',
    `tracking_url_template` STRING COMMENT 'URL template with a placeholder (e.g., {tracking_number}) for the carriers online shipment tracking portal. Used to generate direct tracking links in order management and customer service systems.',
    `trade_name` STRING COMMENT 'Operating or trade name (Doing Business As) of the carrier, which may differ from the legal name and is used in day-to-day communications and TMS displays.',
    `transport_mode` STRING COMMENT 'Primary transportation mode(s) offered by the carrier. Used in TMS route optimization and carrier selection for shipment planning across global distribution networks.. Valid values are `road|rail|air|ocean|intermodal|courier|pipeline`',
    `type` STRING COMMENT 'Classification of the carriers business model indicating whether they own transportation assets or act as an intermediary. Drives contract terms, liability rules, and TMS routing logic.. Valid values are `asset_based|non_asset_based|freight_broker|3pl|4pl|nvocc|freight_forwarder|postal_courier|intermodal`',
    CONSTRAINT pk_carrier PRIMARY KEY(`carrier_id`)
) COMMENT 'Master record for all approved freight carriers and logistics service providers (LSPs) used across road, rail, air, and ocean modes. Stores carrier SCAC code, IATA/IATA code, DOT/MC number, carrier type, service modes offered, insurance certificate details, contract reference, performance tier, and active/inactive status. SSOT for carrier identity used in TMS route planning and freight audit.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`carrier_service` (
    `carrier_service_id` BIGINT COMMENT 'Unique system-generated identifier for a carrier service offering within the Transportation Management System (TMS). Serves as the primary key for all carrier service records.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier. Business justification: carrier_service defines the specific service offerings of a carrier. carrier_service.carrier_scac_code and carrier_name are denormalized references to the carrier master. Adding carrier_id FK enforces',
    `applicable_surcharge_types` STRING COMMENT 'Comma-separated list of surcharge categories applicable to this carrier service (e.g., fuel_surcharge,residential_delivery,address_correction,peak_season,oversize,remote_area). Used in total freight cost estimation and rate shopping.',
    `contract_reference` STRING COMMENT 'Reference number or identifier of the negotiated carrier contract or rate agreement under which this service is offered. Links to the commercial agreement governing pricing and service terms. Classified as confidential due to commercial sensitivity.',
    `customs_clearance_included` BOOLEAN COMMENT 'Indicates whether customs clearance and brokerage services are included as part of this carrier service offering for cross-border shipments. Impacts landed cost calculation and trade compliance workflows.. Valid values are `true|false`',
    `cutoff_time` STRING COMMENT 'Latest time of day (HH:MM in 24-hour format) by which a shipment must be tendered to the carrier at the origin facility to qualify for the stated transit time commitment. Used in order cut-off scheduling.. Valid values are `^([01]d|2[0-3]):[0-5]d$`',
    `cutoff_timezone` STRING COMMENT 'IANA time zone identifier (e.g., America/Chicago, Europe/Berlin) applicable to the carrier cut-off time. Required for accurate scheduling across global distribution centers.',
    `delivery_days` STRING COMMENT 'Comma-separated list of days of the week on which the carrier performs delivery under this service (e.g., MON,TUE,WED,THU,FRI,SAT). Used in delivery date commitment and customer promise calculations.',
    `destination_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the destination country covered by this carrier service lane. Defines the geographic delivery scope for TMS carrier selection.. Valid values are `^[A-Z]{3}$`',
    `destination_region` STRING COMMENT 'Geographic region or zone within the destination country covered by this service (e.g., state, province, postal zone, or carrier-defined zone code). Used for granular lane-level rate shopping and delivery planning.',
    `dim_weight_factor` DECIMAL(18,2) COMMENT 'Carrier-specific dimensional weight divisor (DIM factor) used to calculate billable weight from volumetric dimensions (Length × Width × Height / DIM factor). Common values: 5000 (cm³/kg) for air, 4000 for express parcel. Used in freight cost estimation.. Valid values are `^[0-9]+(.[0-9]+)?$`',
    `effective_date` DATE COMMENT 'Date from which this carrier service offering becomes active and available for TMS carrier selection and rate shopping. Used in time-bound service lane management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date after which this carrier service offering is no longer valid for carrier selection. Null indicates an open-ended service with no defined expiration. Used in contract renewal management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `fuel_surcharge_basis` STRING COMMENT 'Method by which the fuel surcharge is calculated for this carrier service (percentage of base rate, flat fee per shipment, flat fee per kg, or linked to a published fuel index). Used in freight cost modeling and budgeting.. Valid values are `percentage_of_base_rate|flat_per_shipment|flat_per_kg|index_linked`',
    `hazmat_capable` BOOLEAN COMMENT 'Indicates whether the carrier service is certified and authorized to transport hazardous materials (HAZMAT) in compliance with applicable regulations (IATA DGR, IMDG, DOT 49 CFR). Used in dangerous goods shipment routing.. Valid values are `true|false`',
    `incoterms_supported` STRING COMMENT 'Comma-separated list of Incoterms 2020 trade terms supported by this carrier service (e.g., EXW,FCA,CPT,CIP,DAP,DDP). Defines the risk and cost transfer points applicable to shipments using this service.',
    `last_reviewed_date` DATE COMMENT 'Date on which this carrier service record was last reviewed and validated by the logistics or procurement team. Supports carrier master data governance and periodic contract review cycles.. Valid values are `^d{4}-d{2}-d{2}$`',
    `liability_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the carrier liability limit amount (e.g., USD, EUR, GBP). Required for multi-currency global operations.. Valid values are `^[A-Z]{3}$`',
    `liability_limit_amount` DECIMAL(18,2) COMMENT 'Maximum monetary value (in the liability currency) for which the carrier accepts liability for loss or damage per shipment under this service. Used in cargo insurance decisions and claims management.. Valid values are `^[0-9]+(.[0-9]+)?$`',
    `max_length_cm` DECIMAL(18,2) COMMENT 'Maximum allowable length in centimeters for a single piece or shipment under this carrier service. Used in dimensional compliance checks during TMS carrier selection.. Valid values are `^[0-9]+(.[0-9]+)?$`',
    `max_weight_kg` DECIMAL(18,2) COMMENT 'Maximum gross weight in kilograms that the carrier accepts per shipment or per piece under this service. Shipments exceeding this limit require alternative service selection or special handling.. Valid values are `^[0-9]+(.[0-9]+)?$`',
    `on_time_delivery_target_pct` DECIMAL(18,2) COMMENT 'Contractually committed or carrier-published on-time delivery performance target percentage for this service (e.g., 98.5%). Used as the SLA benchmark for carrier performance scorecarding and KPI reporting.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `origin_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the origin country covered by this carrier service lane. Defines the geographic scope of the service for TMS lane matching.. Valid values are `^[A-Z]{3}$`',
    `origin_region` STRING COMMENT 'Geographic region or zone within the origin country covered by this service (e.g., state, province, postal zone, or carrier-defined zone code). Used for granular lane-level rate shopping.',
    `pickup_days` STRING COMMENT 'Comma-separated list of days of the week on which the carrier offers pickup under this service (e.g., MON,TUE,WED,THU,FRI). Used in shipment scheduling and order fulfillment planning.',
    `proof_of_delivery_type` STRING COMMENT 'Type of proof of delivery (POD) provided by the carrier upon successful delivery (electronic signature, paper POD, photo confirmation, or none). Used in dispute resolution and accounts receivable processes.. Valid values are `electronic|paper|signature_required|photo|none`',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when this carrier service record was first created in the system. Used for data lineage, audit trail, and Silver layer ingestion tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this carrier service record. Used for change tracking, data freshness monitoring, and incremental Silver layer processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `service_code` STRING COMMENT 'Standardized alphanumeric code uniquely identifying the carrier service offering (e.g., UPS_GROUND, FEDEX_EXPRESS, DHL_LTL). Used in TMS rate shopping and carrier selection logic.. Valid values are `^[A-Z0-9_-]{2,30}$`',
    `service_level` STRING COMMENT 'Speed and priority tier of the carrier service offering (e.g., standard, economy, express, priority, overnight, same-day). Used in SLA (Service Level Agreement) matching and order fulfillment planning.. Valid values are `standard|economy|express|priority|overnight|same_day|deferred`',
    `service_name` STRING COMMENT 'Full descriptive name of the carrier service offering as defined by the carrier (e.g., UPS Ground, FedEx Priority Overnight, DHL Express Worldwide). Used in user-facing TMS screens and reporting.',
    `service_type` STRING COMMENT 'Classification of the transportation service mode. LTL (Less Than Truckload), FTL (Full Truckload), ocean FCL (Full Container Load), ocean LCL (Less than Container Load), air freight, intermodal, or parcel/express. Drives TMS carrier selection and rate shopping logic.. Valid values are `LTL|FTL|parcel|express_parcel|ocean_FCL|ocean_LCL|air_freight|intermodal|rail|courier|last_mile`',
    `status` STRING COMMENT 'Current operational status of the carrier service record. Active services are available for TMS carrier selection; inactive or suspended services are excluded from rate shopping.. Valid values are `active|inactive|suspended|pending_approval|discontinued`',
    `temperature_controlled` BOOLEAN COMMENT 'Indicates whether this carrier service provides temperature-controlled (cold chain) transportation. Relevant for shipments of temperature-sensitive industrial components, chemicals, or materials.. Valid values are `true|false`',
    `tracking_capability` STRING COMMENT 'Level of shipment tracking visibility provided by the carrier for this service (real-time GPS, milestone-based event updates, end-to-end tracking, or no tracking). Used in customer service and delivery performance monitoring.. Valid values are `real_time|milestone|end_to_end|none`',
    `transit_time_basis` STRING COMMENT 'Specifies whether the transit time commitment is measured in business days (excluding weekends and public holidays) or calendar days. Critical for accurate delivery date calculation.. Valid values are `business_days|calendar_days`',
    `transit_time_days_max` STRING COMMENT 'Maximum number of business or calendar days committed by the carrier for delivery from origin to destination under this service. Represents the upper bound of the transit time commitment window.. Valid values are `^[0-9]+$`',
    `transit_time_days_min` STRING COMMENT 'Minimum number of business or calendar days committed by the carrier for delivery from origin to destination under this service. Used in Available-to-Promise (ATP) and delivery date calculations.. Valid values are `^[0-9]+$`',
    `transport_mode` STRING COMMENT 'Primary mode of transportation used to deliver the service (road, ocean, air, rail, intermodal, courier). Used for logistics planning, carbon footprint reporting, and regulatory compliance.. Valid values are `road|ocean|air|rail|intermodal|courier`',
    CONSTRAINT pk_carrier_service PRIMARY KEY(`carrier_service_id`)
) COMMENT 'Defines the specific service offerings provided by each carrier, such as LTL, FTL, express parcel, ocean FCL/LCL, air freight, and intermodal. Captures service code, transit time commitments, service lane coverage (origin-destination pairs), cut-off times, dimensional weight rules, and applicable surcharge types. Used in TMS carrier selection and rate shopping.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`freight_order` (
    `freight_order_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for the freight order record in the lakehouse silver layer. Serves as the primary key for all downstream joins and references.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Freight orders reference customer accounts for billing, special handling instructions, and customer-specific carrier preferences. Transportation planners use this for every freight booking.',
    `carrier_id` BIGINT COMMENT 'FK to logistics.carrier',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier_service. Business justification: Freight orders are placed for a specific carrier service (LTL, FTL, express, etc.). Adding carrier_service_id FK normalizes the service reference to the carrier_service master, enabling service-level ',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Freight orders are charged to requesting departments cost centers for budget control and expense authorization before shipment execution.',
    `production_plant_id` BIGINT COMMENT 'Foreign key linking to production.production_plant. Business justification: Freight orders originate from production plants shipping finished goods. Transportation planners need plant details for pickup scheduling, capacity planning, and freight cost allocation by manufacturi',
    `route_id` BIGINT COMMENT 'Foreign key linking to logistics.route. Business justification: Freight orders execute along a defined transportation route/lane. Adding route_id FK normalizes the lane reference. origin_location_code and destination_location_code are retained as execution-specifi',
    `sales_opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Freight orders for large industrial equipment (turbines, motors, control systems) are initiated from specific sales opportunities. Logistics planning begins during opportunity stage for complex instal',
    `transport_plan_id` BIGINT COMMENT 'Foreign key linking to logistics.transport_plan. Business justification: Freight orders are generated from TMS transport plans. Adding transport_plan_id to freight_order establishes the plan→execution relationship, enabling plan fulfillment tracking and variance analysis b',
    `actual_delivery_timestamp` TIMESTAMP COMMENT 'Actual date and time at which the freight was delivered to the destination. Used to calculate on-time delivery (OTD) performance, transit time actuals, and SLA compliance against planned delivery windows.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `actual_pickup_timestamp` TIMESTAMP COMMENT 'Actual date and time at which the carrier collected the freight from the origin location. Used to calculate pickup punctuality, carrier on-time performance, and transit time actuals.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `bill_of_lading_number` STRING COMMENT 'Unique identifier of the Bill of Lading (BOL) or Air Waybill (AWB) issued for the freight order. Serves as the primary transport document, title of goods, and carrier receipt. Required for customs, insurance, and payment terms.',
    `carrier_booking_reference` STRING COMMENT 'Carrier-assigned booking or reservation reference number confirming the carriers acceptance of the freight order. Used for shipment tracking, carrier portal access, and proof of booking.',
    `carrier_name` STRING COMMENT 'Legal or trade name of the transportation carrier assigned to execute the freight order. Used for carrier performance reporting, invoice reconciliation, and compliance documentation.',
    `confirmed_freight_cost` DECIMAL(18,2) COMMENT 'Carrier-confirmed or invoiced freight cost for the order after execution. Used for freight invoice reconciliation, actual vs. estimated variance analysis, and COGS allocation.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time at which the freight order was initially created in the TMS. Used for order aging analysis, SLA compliance measurement, and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which freight costs are denominated. Supports multi-currency operations for global freight procurement and financial reporting.. Valid values are `^[A-Z]{3}$`',
    `customs_declaration_number` STRING COMMENT 'Official customs declaration or entry number assigned by customs authorities for cross-border freight movements. Required for import/export compliance, duty payment tracking, and trade audit trails.',
    `destination_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the freight order destination. Required for import customs declarations, duty calculation, trade compliance screening, and restricted party checks.. Valid values are `^[A-Z]{3}$`',
    `destination_location_code` STRING COMMENT 'Standardized code identifying the delivery or destination location for the freight order, such as a customer site, distribution center, or port. Used for route planning, delivery scheduling, and carrier assignment.',
    `estimated_freight_cost` DECIMAL(18,2) COMMENT 'Pre-execution estimated freight cost for the order as calculated by the TMS rate engine or carrier quote. Used for freight budget planning, cost allocation, and purchase order approval workflows.',
    `export_license_number` STRING COMMENT 'Government-issued export license number authorizing the shipment of controlled goods across international borders. Required for dual-use goods, defense articles, and technology subject to export control regulations.',
    `gross_weight_kg` DECIMAL(18,2) COMMENT 'Total gross weight of all freight items included in the freight order, expressed in kilograms. Used for carrier rate calculation, vehicle load planning, weight compliance checks, and customs declarations.',
    `hazmat_flag` BOOLEAN COMMENT 'Indicates whether the freight order contains hazardous materials (Hazmat) requiring special handling, documentation, and regulatory compliance. Triggers ADR/IATA DGR/IMDG documentation requirements and carrier hazmat certification checks.. Valid values are `true|false`',
    `hazmat_un_number` STRING COMMENT 'United Nations (UN) four-digit number identifying the specific hazardous substance or article in the freight order. Required on shipping documents, labels, and placards for regulatory compliance when hazmat_flag is true.. Valid values are `^UN[0-9]{4}$`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms) code defining the allocation of costs, risks, and responsibilities between shipper and consignee for the freight movement. Governs insurance, customs clearance, and freight cost ownership.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `incoterms_location` STRING COMMENT 'Named place, port, or location associated with the Incoterms code, specifying the exact point of risk and cost transfer between shipper and consignee as required by Incoterms 2020.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the freight order record. Used for change tracking, data freshness monitoring, and incremental data pipeline processing in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `loading_meters` DECIMAL(18,2) COMMENT 'Linear loading meters (LDM) required on a trailer or vehicle for the freight order. Standard European road freight capacity unit used for LTL/FTL determination, carrier rate calculation, and load planning.',
    `number` STRING COMMENT 'Business-facing alphanumeric identifier for the freight order as assigned by the Transportation Management System (TMS). Used for carrier communication, shipment tracking, and cross-system reference.. Valid values are `^FO-[0-9]{4}-[0-9]{8}$`',
    `order_type` STRING COMMENT 'Classification of the freight order by direction and operational purpose. Distinguishes inbound supplier deliveries, outbound customer shipments, interplant transfers, customer returns, cross-dock movements, and direct drop shipments.. Valid values are `inbound|outbound|interplant|return|cross_dock|drop_shipment`',
    `origin_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the freight order origin location. Required for customs declarations, export licensing, trade compliance screening, and freight cost determination.. Valid values are `^[A-Z]{3}$`',
    `origin_location_code` STRING COMMENT 'Standardized code identifying the pickup or origin location for the freight order, such as a plant, warehouse, supplier site, or port. Used for route optimization, carrier assignment, and freight cost calculation.',
    `package_count` STRING COMMENT 'Total number of individual packages, pallets, or handling units included in the freight order. Used for carrier booking, loading verification, proof of delivery reconciliation, and customs packing list.. Valid values are `^[0-9]+$`',
    `planned_delivery_date` DATE COMMENT 'Scheduled calendar date on which the freight is expected to arrive at the destination. Used for customer delivery commitments, Available to Promise (ATP) calculations, and delivery performance measurement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_delivery_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone) at which the freight is scheduled to arrive at the destination. Supports time-window delivery commitments, receiving dock scheduling, and SLA compliance tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `planned_pickup_date` DATE COMMENT 'Scheduled calendar date on which the carrier is expected to collect the freight from the origin location. Used for production scheduling, warehouse outbound planning, and carrier appointment management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_pickup_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone) at which the carrier is scheduled to collect the freight. Enables dock scheduling, labor planning, and carrier appointment window management at the origin facility.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `pro_number` STRING COMMENT 'Carrier-assigned Progressive (PRO) number used to track LTL (Less-than-Truckload) shipments through the carriers network. Standard identifier for freight tracking, claims, and invoice matching in North American road freight.',
    `required_temp_max_c` DECIMAL(18,2) COMMENT 'Maximum allowable temperature in degrees Celsius for temperature-controlled freight during transport. Used to specify cold chain upper limits for carrier compliance and monitoring alert thresholds.',
    `required_temp_min_c` DECIMAL(18,2) COMMENT 'Minimum allowable temperature in degrees Celsius for temperature-controlled freight during transport. Used to specify cold chain requirements for carrier compliance and monitoring alert thresholds.',
    `service_level` STRING COMMENT 'Contracted service level defining the speed and priority of freight execution. Determines carrier selection, cost tier, and delivery commitment windows aligned with customer SLA agreements.. Valid values are `standard|express|overnight|economy|same_day|deferred|priority`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which the freight order originated. Supports data lineage tracking, reconciliation, and multi-system integration governance in the lakehouse silver layer.. Valid values are `SAP_TM|SAP_SD|INFOR_WMS|MANUAL|EDI`',
    `special_handling_instructions` STRING COMMENT 'Free-text field capturing specific handling requirements for the freight order, such as fragile goods, top-load only, no stacking, liftgate required, or white-glove delivery. Communicated to the carrier for execution compliance.',
    `status` STRING COMMENT 'Current lifecycle status of the freight order, tracking progression from initial creation through carrier confirmation, active transport execution, and final delivery or cancellation.. Valid values are `draft|submitted|confirmed|in_transit|delivered|cancelled|on_hold|rejected`',
    `temperature_controlled_flag` BOOLEAN COMMENT 'Indicates whether the freight order requires temperature-controlled transport (cold chain or heated). Triggers selection of refrigerated or temperature-controlled vehicles and monitoring requirements.. Valid values are `true|false`',
    `transport_mode` STRING COMMENT 'Primary mode of transportation used for executing the freight order. Drives carrier selection, rate determination, transit time estimation, and customs documentation requirements.. Valid values are `road|rail|air|ocean|multimodal|courier|parcel`',
    `volume_m3` DECIMAL(18,2) COMMENT 'Total cubic volume of all freight items in the freight order, expressed in cubic meters. Used for vehicle capacity planning, dimensional weight calculation, and container/trailer utilization optimization.',
    CONSTRAINT pk_freight_order PRIMARY KEY(`freight_order_id`)
) COMMENT 'Operational freight order issued to a carrier for execution of one or more shipments. Represents the contractual transport instruction including pickup/delivery windows, load instructions, special handling requirements, freight cost estimate, confirmed freight charges, and carrier booking reference. Maps to SAP TM Freight Order and is the primary operational document for carrier execution.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`transport_plan` (
    `transport_plan_id` BIGINT COMMENT 'Unique system-generated identifier for the Transportation Management System (TMS) transport plan record in the Silver Layer lakehouse.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Transport plans are created by logistics planners. Manufacturing tracks plan creators for accountability, performance metrics, and continuous improvement initiatives.',
    `application_id` BIGINT COMMENT 'Foreign key linking to technology.application. Business justification: Transport plans are created in TMS or advanced planning systems. Operations teams reference the source application for plan modifications, execution handoffs, and system-specific constraints.',
    `route_id` BIGINT COMMENT 'Foreign key linking to logistics.route. Business justification: Transport plans are built around specific transportation lanes/routes. Adding route_id FK links the TMS plan to the route master, enabling route-level planning analytics and optimization tracking. ori',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Transport plans schedule multi-stop routes for order deliveries - route optimization considers order delivery windows, priorities, and customer locations.',
    `cancellation_reason` STRING COMMENT 'Business reason provided when a transport plan is cancelled or placed on hold (e.g., demand_cancelled, carrier_unavailable, route_blocked, regulatory_hold). Populated only when status is cancelled or on_hold.',
    `confirmed_timestamp` TIMESTAMP COMMENT 'Date and time when the transport plan was formally confirmed by the logistics planner, transitioning from draft to confirmed status. Used for planning cycle time analysis.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the transport plan record was initially created in the TMS. Used for audit trail, planning cycle analysis, and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the planned freight spend and cost values in this transport plan (e.g., USD, EUR, GBP). Supports multi-currency global operations.. Valid values are `^[A-Z]{3}$`',
    `customs_required` BOOLEAN COMMENT 'Indicates whether customs clearance documentation and procedures are required for freight movements in this transport plan. True for cross-border international shipments.. Valid values are `true|false`',
    `destination_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the primary country of freight destination for this transport plan. Used for import/export compliance and duty calculation.. Valid values are `^[A-Z]{3}$`',
    `destination_region` STRING COMMENT 'Geographic region or logistics zone to which freight is destined in this transport plan. Used for delivery performance reporting and freight cost allocation by region.',
    `drp_run_reference` STRING COMMENT 'Reference identifier of the MRP II Distribution Requirements Planning (DRP) run that generated the shipment demands consolidated into this transport plan. Provides traceability from demand signal to transport execution.',
    `freight_budget_code` STRING COMMENT 'Reference code linking this transport plan to the corresponding freight budget line item in the financial planning system. Enables freight spend tracking against approved OPEX budgets.',
    `hazmat_included` BOOLEAN COMMENT 'Indicates whether any freight loads in this transport plan contain hazardous materials (HAZMAT) requiring special handling, documentation, and regulatory compliance.. Valid values are `true|false`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the transfer of risk, cost responsibility, and delivery obligations between shipper and receiver for freight in this plan.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the transport plan record. Used for change tracking, version control, and incremental data pipeline processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `notes` STRING COMMENT 'Free-text field for logistics planners to capture additional context, special instructions, or exceptions related to the transport plan (e.g., peak season constraints, customer-specific requirements).',
    `optimization_objective` STRING COMMENT 'Primary optimization criterion used by the TMS route optimization engine when generating the transport plan. Drives carrier selection, load consolidation, and route assignment decisions.. Valid values are `cost|time|co2_emissions|balanced`',
    `origin_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the primary country of freight origin for this transport plan. Used for customs and trade compliance documentation.. Valid values are `^[A-Z]{3}$`',
    `origin_region` STRING COMMENT 'Geographic region or logistics zone from which freight originates in this transport plan (e.g., EMEA, APAC, AMER). Used for regional freight budget allocation and carrier lane management.',
    `plan_name` STRING COMMENT 'Descriptive name or label assigned to the transport plan for easy identification in planning dashboards and reporting (e.g., Q3-EMEA-Outbound-Week42).',
    `plan_number` STRING COMMENT 'Human-readable business reference number for the transport plan, used for cross-system communication, carrier coordination, and freight audit. Typically generated by the TMS (e.g., SAP TM or equivalent).. Valid values are `^TP-[0-9]{4}-[0-9]{6}$`',
    `plan_type` STRING COMMENT 'Classification of the transport plan by freight direction and operational mode. Supports Distribution Requirements Planning (DRP) and MRP II-aligned logistics execution.. Valid values are `inbound|outbound|interplant|cross_dock|return`',
    `plan_version` STRING COMMENT 'Incremental version number of the transport plan, incremented each time the plan is revised or re-optimized. Supports plan change tracking and audit trail requirements.. Valid values are `^[1-9][0-9]*$`',
    `planned_carrier_count` STRING COMMENT 'Number of distinct carriers (logistics service providers) included in the planned carrier mix for this transport plan. Supports carrier diversification analysis and risk management.. Valid values are `^[0-9]+$`',
    `planned_co2_emissions_kg` DECIMAL(18,2) COMMENT 'Estimated CO2 equivalent emissions in kilograms for all freight movements in this transport plan, calculated by the TMS optimization engine. Supports sustainability reporting and carbon footprint management.',
    `planned_delivery_date` DATE COMMENT 'Planned date on which freight loads in this transport plan are scheduled to arrive at the destination. Used for customer delivery commitments, SLA compliance, and order fulfillment tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_departure_date` DATE COMMENT 'Planned date on which freight loads in this transport plan are scheduled to depart from the origin location. Used for production scheduling alignment and Available-to-Promise (ATP) calculations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_freight_spend` DECIMAL(18,2) COMMENT 'Total planned freight cost in the plan currency for all loads and carriers in this transport plan. Used for freight budget management, cost-to-serve analysis, and OPEX reporting.',
    `planned_load_count` STRING COMMENT 'Total number of freight loads (shipment units, trucks, containers, or pallets) consolidated and planned within this transport plan. Key metric for capacity planning and freight budget management.. Valid values are `^[0-9]+$`',
    `planned_shipment_count` STRING COMMENT 'Total number of individual shipment demands (orders, deliveries, or transfer orders) consolidated into this transport plan. Distinct from load count as multiple shipments may be consolidated into a single load.. Valid values are `^[0-9]+$`',
    `planned_volume_m3` DECIMAL(18,2) COMMENT 'Total planned freight volume in cubic meters for all loads in this transport plan. Used for container/truck utilization optimization and freight cost estimation.',
    `planned_weight_kg` DECIMAL(18,2) COMMENT 'Total planned gross weight in kilograms of all freight included in this transport plan. Used for carrier capacity validation, freight cost calculation, and load optimization.',
    `planning_horizon_end_date` DATE COMMENT 'End date of the planning window covered by this transport plan. Defines the latest shipment delivery date included in the plan.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planning_horizon_start_date` DATE COMMENT 'Start date of the planning window covered by this transport plan. Defines the earliest shipment pickup or departure date included in the plan, aligned with MRP II Distribution Requirements Planning (DRP) cycles.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planning_organization` STRING COMMENT 'Organizational unit (e.g., logistics planning center, distribution hub, or plant code) responsible for creating and managing this transport plan. Supports multi-entity global operations.',
    `primary_carrier_name` STRING COMMENT 'Name of the primary or lead carrier assigned to execute the majority of freight loads in this transport plan. Used for carrier performance tracking and SLA management.',
    `service_level` STRING COMMENT 'Contracted or planned service level for the transport plan, defining the speed and priority of freight movement. Linked to Service Level Agreement (SLA) commitments with customers or internal stakeholders.. Valid values are `standard|express|economy|priority|deferred`',
    `status` STRING COMMENT 'Current lifecycle status of the transport plan. draft indicates initial TMS-generated plan pending review; confirmed indicates planner approval; in_execution indicates active shipment movement; executed indicates all loads delivered; cancelled indicates plan voided; on_hold indicates temporarily suspended.. Valid values are `draft|confirmed|in_execution|executed|cancelled|on_hold`',
    `tms_plan_reference` STRING COMMENT 'External reference identifier assigned by the source Transportation Management System (TMS) to this transport plan. Used for cross-system reconciliation between the TMS and the lakehouse Silver Layer.',
    `transport_mode` STRING COMMENT 'Primary mode of transportation used in this plan (e.g., road, rail, air, ocean, intermodal). Drives carrier selection, lead time estimation, and CO2 emissions calculation.. Valid values are `road|rail|air|ocean|intermodal|courier`',
    CONSTRAINT pk_transport_plan PRIMARY KEY(`transport_plan_id`)
) COMMENT 'TMS-generated transportation plan that consolidates shipment demands into optimized load plans and route assignments. Captures planning horizon, optimization objective (cost, time, CO2), total planned loads, planned carrier mix, planned freight spend, and plan status (draft, confirmed, executed). Supports MRP II-aligned distribution requirements planning (DRP) and freight budget management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`route` (
    `route_id` BIGINT COMMENT 'Unique system-generated identifier for a transportation route or lane definition within the Transportation Management System (TMS). Serves as the primary key for all route-related data.',
    `application_id` BIGINT COMMENT 'Foreign key linking to technology.application. Business justification: Routes are generated by route optimization applications (Descartes, Ortec, Blue Yonder). Transportation planners need to know which system created the route for troubleshooting and optimization analys',
    `location_id` BIGINT COMMENT 'Foreign key linking to logistics.logistics_location. Business justification: Route origin is a physical logistics network location. Adding origin_logistics_location_id FK normalizes the origin reference to the logistics_location master. origin_location_code is retained as a co',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Routes are planned by logistics coordinators. Manufacturing operations track which employee planned routes for optimization analysis and performance evaluation.',
    `transport_zone_id` BIGINT COMMENT 'Foreign key linking to logistics.transport_zone. Business justification: Routes operate within defined transport zones used for freight pricing and carrier coverage. Adding transport_zone_id FK links the route to the geographic zone master, enabling zone-based rate lookups',
    `border_crossing_count` STRING COMMENT 'Number of international border crossings on this route. Used to assess customs complexity, transit documentation requirements, and potential delay risk.. Valid values are `^[0-9]{1,3}$`',
    `co2_emission_factor_kg_per_km` DECIMAL(18,2) COMMENT 'Carbon dioxide (CO2) emission factor for this route expressed in kilograms of CO2 per kilometer, based on transport mode and carrier fleet data. Used for environmental reporting, carbon footprint calculation, and ISO 14001 / ESG compliance.. Valid values are `^[0-9]{1,4}(.[0-9]{1,6})?$`',
    `code` STRING COMMENT 'Business-facing alphanumeric code uniquely identifying the transportation route or lane, used in TMS, ERP, and operational communications (e.g., USCHI-DEHAM-SEA).. Valid values are `^[A-Z0-9_-]{3,30}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the route record was first created in the system. Used for data lineage, audit trail, and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the standard freight cost and rate agreements for this route are denominated (e.g., USD, EUR, CNY).. Valid values are `^[A-Z]{3}$`',
    `customs_required` BOOLEAN COMMENT 'Indicates whether customs clearance documentation and procedures are required for shipments on this route (e.g., cross-border international routes). Drives trade compliance workflow activation.. Valid values are `true|false`',
    `cutoff_time` STRING COMMENT 'Latest time of day (HH:MM, 24-hour format) by which a shipment must be tendered to the carrier to meet the scheduled departure on this route. Critical for order fulfillment and warehouse operations.. Valid values are `^([01][0-9]|2[0-3]):[0-5][0-9]$`',
    `departure_days` STRING COMMENT 'Comma-separated list of days of the week on which departures are scheduled on this route (e.g., MON,WED,FRI). Used for shipment scheduling and Available to Promise (ATP) calculations.',
    `description` STRING COMMENT 'Detailed narrative description of the route, including any special handling requirements, routing constraints, or operational notes relevant to logistics planners.',
    `destination_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code for the country where the route terminates. Used for import customs declarations, trade compliance, and duty calculations.. Valid values are `^[A-Z]{3}$`',
    `destination_location_code` STRING COMMENT 'Standardized code identifying the arrival point of the route (e.g., customer delivery point, distribution center, port code, or UN/LOCODE). Represents where freight is delivered.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `distance_km` DECIMAL(18,2) COMMENT 'Total distance of the route measured in kilometers. Used for freight cost calculation, carbon emission estimation, and TMS route optimization.. Valid values are `^[0-9]{1,7}(.[0-9]{1,3})?$`',
    `distance_miles` DECIMAL(18,2) COMMENT 'Total distance of the route measured in miles. Provided for regions using imperial measurement (e.g., USA, UK) and for carrier rate agreements denominated in miles.. Valid values are `^[0-9]{1,7}(.[0-9]{1,3})?$`',
    `effective_date` DATE COMMENT 'Date from which this route definition becomes valid and available for shipment assignment. Used for time-bound route management and seasonal lane activation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date after which this route definition is no longer valid for shipment assignment. Used for contract-bound lanes, seasonal routes, and regulatory compliance periods.. Valid values are `^d{4}-d{2}-d{2}$`',
    `frequency` STRING COMMENT 'Operational frequency at which shipments are dispatched on this route. Used for production planning, inventory replenishment scheduling, and carrier capacity booking.. Valid values are `daily|weekly|bi_weekly|monthly|on_demand|scheduled`',
    `hazmat_permitted` BOOLEAN COMMENT 'Indicates whether the transport of hazardous materials (HAZMAT) is permitted on this route. Governs compliance with dangerous goods regulations and carrier restrictions.. Valid values are `true|false`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms) code defining the responsibilities of buyers and sellers for delivery of goods on this route, including risk transfer and cost allocation points.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the route record. Used for change tracking, data freshness monitoring, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `max_volume_m3` DECIMAL(18,2) COMMENT 'Maximum allowable shipment volume in cubic meters for a single consignment on this route, based on carrier capacity and vehicle/vessel constraints.. Valid values are `^[0-9]{1,9}(.[0-9]{1,3})?$`',
    `max_weight_kg` DECIMAL(18,2) COMMENT 'Maximum allowable shipment weight in kilograms for a single consignment on this route, based on carrier capacity, regulatory limits, and infrastructure constraints.. Valid values are `^[0-9]{1,9}(.[0-9]{1,3})?$`',
    `maximum_transit_days` STRING COMMENT 'Maximum number of calendar days allowed for transit on this route before a shipment is considered delayed. Used for SLA (Service Level Agreement) breach monitoring and carrier performance management.. Valid values are `^[0-9]{1,4}$`',
    `minimum_transit_days` STRING COMMENT 'Minimum number of calendar days achievable for transit on this route under optimal conditions. Used for express service planning and Available to Promise (ATP) calculations.. Valid values are `^[0-9]{1,4}$`',
    `name` STRING COMMENT 'Descriptive human-readable name for the transportation route, typically combining origin and destination location names and transport mode (e.g., Chicago to Hamburg – Ocean Freight).',
    `origin_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code for the country where the route originates. Used for customs, trade compliance, and regulatory reporting.. Valid values are `^[A-Z]{3}$`',
    `origin_location_code` STRING COMMENT 'Standardized code identifying the departure point of the route (e.g., plant code, warehouse code, port code, or UN/LOCODE). Represents where freight originates.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `preferred_carrier_code` STRING COMMENT 'Code identifying the primary/preferred carrier assigned to this route based on carrier selection criteria such as cost, reliability, and service level. Used by TMS for automatic carrier assignment.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `region_code` STRING COMMENT 'Code identifying the geographic logistics region or trade lane cluster to which this route belongs (e.g., EMEA, APAC, AMER). Used for regional freight management and reporting.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `secondary_carrier_code` STRING COMMENT 'Code identifying the backup or secondary carrier for this route, used when the preferred carrier is unavailable or capacity-constrained. Supports carrier diversification and business continuity.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `service_type` STRING COMMENT 'Level of service associated with this route, defining speed and priority of delivery. Used for SLA (Service Level Agreement) assignment and freight rate differentiation.. Valid values are `standard|express|economy|priority|deferred|same_day|next_day`',
    `standard_freight_cost` DECIMAL(18,2) COMMENT 'Standard or benchmark freight cost for a full shipment on this route, expressed in the routes base currency. Used for freight budget planning, cost allocation, and carrier rate benchmarking.. Valid values are `^[0-9]{1,14}(.[0-9]{1,4})?$`',
    `standard_transit_days` STRING COMMENT 'Standard number of calendar days expected for freight to travel from origin to destination on this route under normal operating conditions. Used for delivery date calculation and SLA (Service Level Agreement) commitments.. Valid values are `^[0-9]{1,4}$`',
    `status` STRING COMMENT 'Current operational status of the route. Active routes are available for shipment assignment; inactive routes are not currently in use; suspended routes are temporarily halted; under_review routes are being evaluated for modification; discontinued routes have been permanently retired.. Valid values are `active|inactive|suspended|under_review|discontinued`',
    `temperature_controlled` BOOLEAN COMMENT 'Indicates whether this route requires temperature-controlled (cold chain) transportation. Relevant for chemical, pharmaceutical, or sensitive industrial components requiring specific temperature ranges.. Valid values are `true|false`',
    `tms_route_code` STRING COMMENT 'External route identifier as recorded in the source Transportation Management System (TMS), used for cross-system reconciliation and data lineage tracing.. Valid values are `^[A-Z0-9_-]{1,50}$`',
    `toll_applicable` BOOLEAN COMMENT 'Indicates whether road tolls, port fees, canal dues, or other infrastructure usage charges apply on this route. Used for accurate freight cost estimation and carrier invoice validation.. Valid values are `true|false`',
    `transit_hub_code` STRING COMMENT 'Code identifying the intermediate consolidation or transshipment hub used on hub-and-spoke or relay routes. Applicable when route_type is hub_and_spoke or relay.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `transport_mode` STRING COMMENT 'Primary mode of transportation used on this route. Drives carrier selection, freight rate assignment, transit time estimation, and TMS routing logic.. Valid values are `road|rail|ocean|air|intermodal|multimodal|courier|pipeline`',
    `type` STRING COMMENT 'Classification of the routes structural pattern. Direct indicates point-to-point movement; hub_and_spoke involves a consolidation hub; multimodal uses multiple transport modes; milk_run involves multiple pickup/delivery stops; cross_dock involves transshipment without storage.. Valid values are `direct|hub_and_spoke|multimodal|relay|milk_run|cross_dock`',
    CONSTRAINT pk_route PRIMARY KEY(`route_id`)
) COMMENT 'Master definition of a transportation lane or route between an origin location and a destination location. Stores origin/destination location codes, transport mode, distance (km/miles), standard transit days, preferred carrier, route type (direct, hub-and-spoke, multimodal), and active status. Used as the reference backbone for TMS route optimization and freight rate assignment.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`route_stop` (
    `route_stop_id` BIGINT COMMENT 'Unique system-generated identifier for each individual stop or waypoint within a transportation route. Serves as the primary key for the route_stop entity.',
    `address_id` BIGINT COMMENT 'Foreign key linking to customer.address. Business justification: Route stops reference customer addresses for GPS routing, delivery sequencing, and geofencing. Route optimization systems use this for daily route planning and execution.',
    `location_id` BIGINT COMMENT 'Foreign key linking to logistics.logistics_location. Business justification: Each route stop corresponds to a physical logistics location. Adding logistics_location_id FK normalizes the stop location reference. location_name, address_line_1, city, state_province, postal_code, ',
    `route_id` BIGINT COMMENT 'Foreign key linking to logistics.route. Business justification: route_stop is a child record of route, representing individual waypoints within a multi-leg route. Adding route_id FK establishes the parent→child relationship. Stop-specific address and timing fields',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Actual date and time the carrier arrived at this stop, captured via TMS event, driver mobile app, or geofence trigger. Used for on-time arrival performance tracking and carrier SLA measurement.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `actual_departure_timestamp` TIMESTAMP COMMENT 'Actual date and time the carrier departed from this stop. Used to calculate actual dwell time, identify detention events, and measure stop-level execution performance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `actual_dwell_time_minutes` STRING COMMENT 'Actual duration in minutes the carrier remained at this stop, derived from actual arrival and departure timestamps. Used to identify detention, inefficiencies, and carrier performance deviations.. Valid values are `^[0-9]+$`',
    `actual_load_quantity` DECIMAL(18,2) COMMENT 'Actual quantity of goods loaded onto the vehicle at this stop, as confirmed by the driver, warehouse staff, or WMS. Compared against planned load quantity to identify discrepancies.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `actual_unload_quantity` DECIMAL(18,2) COMMENT 'Actual quantity of goods unloaded from the vehicle at this stop, as confirmed by the receiver or WMS. Used for proof-of-delivery validation and discrepancy management.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `appointment_reference` STRING COMMENT 'Reference number for the dock or facility appointment scheduled for this stop. Links the route stop to the appointment management system for dock scheduling and carrier check-in.',
    `arrival_variance_minutes` STRING COMMENT 'Difference in minutes between actual and planned arrival timestamps. Positive values indicate late arrival; negative values indicate early arrival. Key metric for on-time delivery (OTD) performance reporting.. Valid values are `^-?[0-9]+$`',
    `customs_clearance_required` BOOLEAN COMMENT 'Indicates whether customs clearance activities are required at this stop. True for border crossings, customs offices, or bonded warehouse stops. Triggers customs documentation workflow.. Valid values are `true|false`',
    `customs_declaration_number` STRING COMMENT 'Official customs declaration or entry number issued by the customs authority for goods processed at this stop. Required for cross-border shipments and trade compliance audit trails.',
    `dock_door_number` STRING COMMENT 'Identifier of the specific dock door or bay assigned to this stop at the facility. Used for dock scheduling, yard management, and operational coordination between TMS and WMS.',
    `geofence_arrival_timestamp` TIMESTAMP COMMENT 'Timestamp when the vehicle entered the geofenced boundary of the stop location, as detected by the telematics or IIoT platform. Provides an objective, system-generated arrival signal independent of driver input.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `geofence_departure_timestamp` TIMESTAMP COMMENT 'Timestamp when the vehicle exited the geofenced boundary of the stop location, as detected by the telematics or IIoT platform. Used to validate actual dwell time and departure confirmation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `is_first_stop` BOOLEAN COMMENT 'Indicates whether this stop is the origin or first stop of the route. Used to distinguish route origin from intermediate stops in multi-leg route analysis and reporting.. Valid values are `true|false`',
    `is_last_stop` BOOLEAN COMMENT 'Indicates whether this stop is the final destination or last stop of the route. Used to identify route completion events and trigger final delivery confirmation workflows.. Valid values are `true|false`',
    `is_time_window_met` BOOLEAN COMMENT 'Indicates whether the carrier arrived within the agreed delivery or pickup time window at this stop. True if actual arrival falls within the time window; False if outside. Used for SLA compliance reporting.. Valid values are `true|false`',
    `location_code` STRING COMMENT 'Standardized business identifier for the physical location of this stop, such as a warehouse, plant, customer site, port, or customs facility. Aligns with the enterprise location master in SAP S/4HANA.. Valid values are `^[A-Z0-9_-]{2,30}$`',
    `location_type` STRING COMMENT 'Classification of the stop location by facility type. Drives operational rules, dwell time expectations, and compliance requirements applicable at the stop.. Valid values are `plant|warehouse|distribution_center|customer_site|port|airport|rail_terminal|customs_office|cross_dock_facility|supplier_site|service_center`',
    `planned_arrival_timestamp` TIMESTAMP COMMENT 'Scheduled date and time the carrier is expected to arrive at this stop, as defined in the Transportation Management System (TMS) route plan. Baseline for on-time performance measurement.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `planned_departure_timestamp` TIMESTAMP COMMENT 'Scheduled date and time the carrier is expected to depart from this stop, as defined in the TMS route plan. Used to calculate planned dwell time and downstream stop arrival windows.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `planned_dwell_time_minutes` STRING COMMENT 'Planned duration in minutes the carrier is expected to remain at this stop for loading, unloading, or other activities. Used for route scheduling and carrier appointment management.. Valid values are `^[0-9]+$`',
    `planned_load_quantity` DECIMAL(18,2) COMMENT 'Planned quantity of goods to be loaded onto the vehicle at this stop, expressed in the unit of measure defined at the shipment level. Applicable for pickup and cross-dock stop types.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `planned_unload_quantity` DECIMAL(18,2) COMMENT 'Planned quantity of goods to be unloaded from the vehicle at this stop. Applicable for delivery and cross-dock stop types. Used for dock resource planning and shipment verification.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `proof_of_delivery_number` STRING COMMENT 'Reference number for the proof of delivery document captured at this stop upon successful goods handover. Used for invoice verification, dispute resolution, and customer confirmation.',
    `quantity_unit_of_measure` STRING COMMENT 'Unit of measure applicable to planned and actual load/unload quantities at this stop (e.g., EA for each, KG for kilograms, PLT for pallets). Ensures consistent quantity interpretation across stops.. Valid values are `EA|KG|LB|MT|L|GAL|M3|FT3|PLT|CTN|PKG`',
    `receiver_name` STRING COMMENT 'Name of the individual or entity who received or handed over goods at this stop, as recorded on the proof of delivery. Used for delivery confirmation and dispute resolution.',
    `source_system_code` STRING COMMENT 'Identifier of the originating operational system from which this route stop record was sourced (e.g., SAP TM, Infor WMS). Supports data lineage tracking and multi-system reconciliation in the lakehouse.',
    `special_handling_code` STRING COMMENT 'Code indicating any special handling requirements applicable to goods at this stop, such as hazardous materials (HAZMAT), temperature-controlled, or high-value cargo. Drives compliance and operational procedures.. Valid values are `NONE|HAZMAT|TEMPERATURE_CONTROLLED|FRAGILE|OVERSIZED|HIGH_VALUE|BONDED|PERISHABLE|LIVE_ANIMALS|PHARMACEUTICAL`',
    `stop_distance_km` DECIMAL(18,2) COMMENT 'Distance in kilometers from the previous stop (or route origin for the first stop) to this stop. Used for freight cost allocation, carrier rate calculation, and route optimization analysis.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `stop_exception_code` STRING COMMENT 'Standardized code identifying any exception or deviation that occurred at this stop. Used for root cause analysis, carrier performance management, and CAPA (Corrective and Preventive Action) processes.. Valid values are `NONE|LATE_ARRIVAL|EARLY_ARRIVAL|MISSED_STOP|REFUSED_DELIVERY|PARTIAL_DELIVERY|DAMAGED_GOODS|ACCESS_DENIED|WEATHER_DELAY|TRAFFIC_DELAY|MECHANICAL_BREAKDOWN|CUSTOMS_HOLD|OTHER`',
    `stop_exception_notes` STRING COMMENT 'Free-text description providing additional context for any exception or deviation recorded at this stop. Supplements the exception code with operational details for investigation and resolution.',
    `stop_sequence_number` STRING COMMENT 'Ordinal position of this stop within the overall route, starting from 1. Determines the order in which the carrier visits locations along the route. Used for milk-run and multi-leg route planning.. Valid values are `^[0-9]+$`',
    `stop_status` STRING COMMENT 'Current operational status of the stop within the route execution lifecycle. Tracks progression from planned through arrival, completion, or exception states such as delay, skip, or cancellation.. Valid values are `planned|in_transit|arrived|completed|skipped|delayed|cancelled`',
    `stop_type` STRING COMMENT 'Classification of the purpose of this stop within the route. Determines operational activities performed at the stop, such as loading (pickup), unloading (delivery), cross-docking, customs clearance, or driver rest.. Valid values are `pickup|delivery|cross_dock|customs|consolidation|deconsolidation|fuel|rest|inspection|return`',
    `time_window_end_timestamp` TIMESTAMP COMMENT 'Latest acceptable arrival time at this stop as agreed with the customer or facility. Defines the closing of the delivery or pickup appointment window. Arrivals after this time are flagged as SLA breaches.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `time_window_start_timestamp` TIMESTAMP COMMENT 'Earliest acceptable arrival time at this stop as agreed with the customer or facility. Defines the opening of the delivery or pickup appointment window for dock scheduling.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    CONSTRAINT pk_route_stop PRIMARY KEY(`route_stop_id`)
) COMMENT 'Individual stop or waypoint within a multi-leg or milk-run route. Records stop sequence, location code, planned arrival/departure timestamps, dwell time, stop type (pickup, delivery, cross-dock, customs), and actual arrival/departure for on-time performance tracking. Enables granular visibility into multi-stop freight movements.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`delivery` (
    `delivery_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each outbound delivery record in the logistics domain. Serves as the primary key for the delivery data product and is used for cross-system linkage.',
    `address_id` BIGINT COMMENT 'Foreign key linking to customer.address. Business justification: Deliveries require precise customer address for routing, proof of delivery, and customer location validation. Warehouse management systems use this for every outbound shipment.',
    `carrier_id` BIGINT COMMENT 'FK to logistics.carrier',
    `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: Deliveries need receiving contact for appointment scheduling, delivery confirmation, and issue escalation. Last-mile delivery teams use this for every customer delivery.',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to logistics.customs_declaration. Business justification: Cross-border deliveries require a customs declaration. delivery.customs_declaration_number is a denormalized reference. Adding customs_declaration_id FK normalizes this to the customs_declaration mast',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Each delivery is executed by a specific employee. Manufacturing operations track who performed the delivery for proof-of-delivery, performance metrics, and labor cost allocation.',
    `pick_task_id` BIGINT COMMENT 'Foreign key linking to inventory.pick_task. Business justification: Outbound deliveries are fulfilled through pick tasks that retrieve inventory from storage. Distribution centers link deliveries to picking operations to track fulfillment execution.',
    `route_id` BIGINT COMMENT 'FK to logistics.route',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Deliveries require ship-to customer identification for routing, delivery confirmation, and customer notification. Distribution centers use this for every outbound delivery execution.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: A delivery document is the outbound dispatch confirmation for a shipment. delivery.shipment_number is a denormalized string reference. Replacing with shipment_id FK enforces referential integrity. shi',
    `warehouse_id` BIGINT COMMENT 'FK to inventory.warehouse',
    `actual_delivery_date` DATE COMMENT 'The date on which goods were physically delivered to and received by the recipient. Used to calculate on-time delivery (OTD) performance against the planned delivery date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `actual_ship_date` DATE COMMENT 'The actual date on which goods were physically dispatched from the shipping point. Captured at goods issue posting and used for carrier performance and lead time analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the outbound delivery document was created in the source system. Used for lead time analysis, process cycle time measurement, and audit trail compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `export_license_number` STRING COMMENT 'Reference number of the export license issued by the relevant government authority for controlled goods or dual-use items. Required for compliance with export control regulations for industrial automation and electrification products.',
    `freight_terms` STRING COMMENT 'Terms defining who bears the freight cost for this delivery — whether the shipper prepays, the consignee pays on collection, or a third party is billed. Impacts accounts payable and customer invoicing.. Valid values are `prepaid|collect|third_party|prepaid_and_add`',
    `goods_issue_date` DATE COMMENT 'The accounting date on which the goods issue was posted in the ERP system, triggering inventory reduction and revenue recognition. Critical for financial period-end closing and COGS recognition.. Valid values are `^d{4}-d{2}-d{2}$`',
    `goods_issue_timestamp` TIMESTAMP COMMENT 'Precise date and time when the goods issue was posted in the ERP system. Provides sub-day precision for operational reporting, shift-level analysis, and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `hazmat_indicator` BOOLEAN COMMENT 'Flag indicating whether the delivery contains hazardous materials subject to special handling, labeling, and transport regulations. Triggers hazmat documentation requirements and carrier restrictions.. Valid values are `true|false`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the responsibilities of buyer and seller for delivery, risk transfer, insurance, and freight costs. Governs liability and cost allocation for the shipment.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `incoterms_location` STRING COMMENT 'Named place or port associated with the Incoterms code, specifying the exact location where risk and cost transfer between seller and buyer (e.g., Port of Hamburg for FOB, Customer Warehouse for DDP).',
    `last_changed_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the delivery document in the source system. Used for change detection in data integration pipelines and audit trail maintenance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `number` STRING COMMENT 'Business-facing alphanumeric identifier for the outbound delivery document as assigned by the source system (SAP SD). Used for tracking, communication with carriers, and customer-facing references.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `over_ship_quantity` DECIMAL(18,2) COMMENT 'Quantity of goods shipped in excess of the ordered quantity. Requires customer approval or return authorization and may trigger credit memo processing.. Valid values are `^d{1,15}(.d{1,3})?$`',
    `overall_goods_movement_status` STRING COMMENT 'Aggregate goods movement status across all line items in the delivery, indicating whether goods issue has been fully posted, partially posted, or not yet started. Derived from SAP SD header-level goods movement status.. Valid values are `not_started|partial|complete`',
    `packing_list_number` STRING COMMENT 'Reference number of the packing list document associated with this delivery, detailing the contents, quantities, and packaging of shipped goods. Required for customs clearance and receiving verification.. Valid values are `^[A-Z0-9-]{1,30}$`',
    `packing_status` STRING COMMENT 'Status of the packing process for this delivery, indicating whether goods have been fully, partially, or not yet packed into handling units or shipping containers.. Valid values are `not_started|partial|complete`',
    `picking_status` STRING COMMENT 'Status of the warehouse picking process for this delivery, indicating whether warehouse staff have fully, partially, or not yet picked the goods from storage locations.. Valid values are `not_started|partial|complete`',
    `planned_delivery_date` DATE COMMENT 'The originally scheduled date on which goods are expected to be delivered to the recipient. Used for on-time delivery performance measurement and customer commitment tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_ship_date` DATE COMMENT 'The scheduled date on which goods are planned to be dispatched from the shipping point. Used for transportation planning, carrier booking, and warehouse workload scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `pod_date` DATE COMMENT 'The date on which proof of delivery was confirmed by the recipient or carrier, indicating that goods were received at the destination. Triggers billing and revenue recognition in POD-based billing scenarios.. Valid values are `^d{4}-d{2}-d{2}$`',
    `pod_reference` STRING COMMENT 'Reference number or identifier for the proof-of-delivery document, such as a carrier-issued POD number, electronic signature reference, or consignment note number. Used for dispute resolution and audit.. Valid values are `^[A-Z0-9-_]{1,50}$`',
    `priority_level` STRING COMMENT 'Business priority classification assigned to the delivery, influencing warehouse picking sequence, carrier selection, and transportation mode. Critical deliveries may be linked to production line stoppage prevention.. Valid values are `standard|express|urgent|critical`',
    `ship_from_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the origin location from which goods are shipped. Required for customs declarations, trade compliance, and export control screening.. Valid values are `^[A-Z]{3}$`',
    `ship_to_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the destination country to which goods are being delivered. Used for import duty calculation, trade compliance, and export control classification.. Valid values are `^[A-Z]{3}$`',
    `shipping_point` STRING COMMENT 'SAP organizational unit representing the physical location (plant, warehouse, or dock) from which the delivery is dispatched. Determines the shipping calendar, transportation zone, and warehouse management assignment.. Valid values are `^[A-Z0-9]{1,10}$`',
    `short_ship_quantity` DECIMAL(18,2) COMMENT 'Quantity of goods that was ordered but not shipped due to stock shortages, picking errors, or capacity constraints. A non-zero value triggers back-order processing and customer notification.. Valid values are `^d{1,15}(.d{1,3})?$`',
    `source_system_code` STRING COMMENT 'Identifier of the operational source system from which this delivery record originated (e.g., SAP S/4HANA system ID or client). Supports multi-system landscapes and data lineage traceability in the lakehouse.. Valid values are `^[A-Z0-9-_]{1,20}$`',
    `status` STRING COMMENT 'Current processing status of the outbound delivery document, tracking the lifecycle from creation through goods issue posting, transit, and final proof-of-delivery confirmation.. Valid values are `created|picking_in_progress|picked|packing_in_progress|packed|goods_issue_posted|in_transit|delivered|pod_confirmed|cancelled|short_shipped|over_shipped`',
    `total_delivery_quantity` DECIMAL(18,2) COMMENT 'Total quantity of all line items included in this delivery document, expressed in the base unit of measure. Used for fulfillment rate calculation and short-ship/over-ship variance analysis.. Valid values are `^d{1,15}(.d{1,3})?$`',
    `total_gross_weight_kg` DECIMAL(18,2) COMMENT 'Total gross weight of all items in the delivery including packaging, expressed in kilograms. Used for freight cost calculation, carrier capacity planning, and customs declarations.. Valid values are `^d{1,15}(.d{1,3})?$`',
    `total_net_weight_kg` DECIMAL(18,2) COMMENT 'Total net weight of all items in the delivery excluding packaging, expressed in kilograms. Used for customs valuation, product compliance declarations, and REACH/RoHS reporting.. Valid values are `^d{1,15}(.d{1,3})?$`',
    `total_volume_m3` DECIMAL(18,2) COMMENT 'Total volumetric measurement of all items in the delivery expressed in cubic meters. Used for truck load planning, container utilization, and freight cost calculation based on dimensional weight.. Valid values are `^d{1,14}(.d{1,4})?$`',
    `tracking_number` STRING COMMENT 'Carrier-issued tracking number (e.g., waybill number, bill of lading number, or parcel tracking ID) used to monitor shipment progress through the carriers tracking system.',
    `transport_mode` STRING COMMENT 'Mode of transportation used for the delivery, such as road (truck), rail, air freight, sea freight, or multimodal. Drives freight cost calculation, transit time estimation, and carbon emissions reporting.. Valid values are `road|rail|air|sea|multimodal|courier|intermodal`',
    `type` STRING COMMENT 'Classification of the delivery indicating whether it is an outbound shipment to a customer, an interplant transfer between manufacturing sites, a replenishment to a distribution center, a return delivery, or a subcontractor delivery.. Valid values are `outbound_customer|interplant_transfer|distribution_center|return_delivery|subcontractor`',
    `un_number` STRING COMMENT 'United Nations four-digit number identifying the hazardous substance or article in the delivery, as defined by the UN Committee of Experts on the Transport of Dangerous Goods. Required when hazmat_indicator is true.. Valid values are `^UNd{4}$`',
    CONSTRAINT pk_delivery PRIMARY KEY(`delivery_id`)
) COMMENT 'Outbound delivery document confirming physical dispatch of goods to a customer, distribution center, or interplant transfer destination. Captures delivery date, actual ship date, proof-of-delivery (POD) reference, delivery status, goods issue posting date, packing list reference, and any short-ship or over-ship variances. SSOT for delivery confirmation linked to SAP SD outbound delivery.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` (
    `logistics_inbound_delivery_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for the inbound delivery record in the Databricks Silver Layer. Serves as the primary key for all downstream joins and lineage tracking.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier. Business justification: Inbound deliveries are executed by a carrier. inbound_delivery.carrier_name is a denormalized reference to the carrier master. Adding carrier_id FK enforces referential integrity and enables carrier p',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Inbound delivery costs (receiving, inspection, putaway) are charged to receiving departments cost center for operational expense tracking and warehouse cost management.',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to logistics.customs_declaration. Business justification: Cross-border inbound deliveries require a customs declaration. inbound_delivery.customs_declaration_number is a denormalized reference. Adding customs_declaration_id FK normalizes this to the customs_',
    `lab_resource_id` BIGINT COMMENT 'Foreign key linking to research.lab_resource. Business justification: Lab equipment and specialized testing instruments require inbound delivery tracking for calibration equipment, test materials, and capital equipment installations. Critical for R&D operations continui',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Inbound delivery fulfills purchase order - normalize by replacing purchase_order_number text with FK',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Inbound delivery from supplier - normalize by replacing supplier_number and supplier_name with FK',
    `production_plant_id` BIGINT COMMENT 'Foreign key linking to production.production_plant. Business justification: Inbound deliveries of raw materials and components arrive at specific production plants. Receiving docks, material handlers, and production planners use this to route incoming materials correctly.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Inbound deliveries must be received and verified by warehouse employees. Manufacturing tracks who received materials for quality control, inventory accuracy, and accountability.',
    `location_id` BIGINT COMMENT 'Foreign key linking to logistics.logistics_location. Business justification: Inbound deliveries are received at a specific logistics location (plant, warehouse, distribution center). Adding receiving_logistics_location_id FK links the inbound delivery to the logistics_location',
    `returns_order_id` BIGINT COMMENT 'Foreign key linking to order.returns_order. Business justification: Inbound deliveries process customer returns - receiving department matches incoming goods to authorized return orders for inspection and restocking.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Inbound deliveries track supplier accounts (suppliers are accounts in manufacturing). Receiving departments use this for vendor performance tracking, ASN matching, and quality issue resolution.',
    `actual_delivery_date` DATE COMMENT 'Date on which the supplier physically delivered the goods to the receiving dock. Compared against expected delivery date to calculate on-time delivery performance KPIs.. Valid values are `^d{4}-d{2}-d{2}$`',
    `batch_number` STRING COMMENT 'Supplier or internal batch/lot number assigned to the received material for traceability purposes. Mandatory for regulated materials, hazardous substances (REACH/RoHS), and quality inspection under ISO 9001.',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the received goods were manufactured or substantially transformed. Required for customs declarations, import duty calculation, and REACH/RoHS compliance reporting.. Valid values are `^[A-Z]{3}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the net price and delivery value are denominated. Supports multi-currency financial reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `delivery_number` STRING COMMENT 'Business-facing document number assigned to the inbound delivery, sourced from SAP S/4HANA MM (transaction VL32N / MIGO) or Infor WMS. Used for cross-system reconciliation and supplier communication.. Valid values are `^[A-Z0-9-]{1,35}$`',
    `delivery_type` STRING COMMENT 'Classification of the inbound delivery by its business scenario. Determines processing rules, inventory posting logic, and financial accounting treatment in SAP S/4HANA.. Valid values are `STANDARD|RETURN|SUBCONTRACTING|CONSIGNMENT|INTERCOMPANY|THIRD_PARTY`',
    `delivery_value` DECIMAL(18,2) COMMENT 'Total monetary value of the received goods (received quantity × net price) in the transaction currency. Used for GRN valuation, inventory accounting, and accounts payable accrual.. Valid values are `^d+(.d{1,2})?$`',
    `discrepancy_flag` BOOLEAN COMMENT 'Indicates whether a quantity, quality, or documentation discrepancy was identified during the receiving process. Triggers Non-Conformance Report (NCR) creation and supplier corrective action workflows.. Valid values are `true|false`',
    `discrepancy_type` STRING COMMENT 'Classification of the discrepancy identified during receiving. Drives routing to the appropriate resolution workflow (e.g., supplier return, NCR, CAPA) and supports supplier performance analytics.. Valid values are `QUANTITY_SHORTAGE|QUANTITY_OVERAGE|DAMAGED_GOODS|WRONG_MATERIAL|DOCUMENTATION_MISSING|QUALITY_REJECTION|NONE`',
    `expected_delivery_date` DATE COMMENT 'Planned date on which the supplier is expected to deliver the goods to the receiving facility, as confirmed on the Purchase Order. Used for on-time delivery performance measurement and production scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `goods_receipt_timestamp` TIMESTAMP COMMENT 'Precise date and time when the goods were physically received and scanned at the receiving dock in Infor WMS. Supports lead time analysis, dock scheduling, and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `grn_number` STRING COMMENT 'Goods Receipt Note (GRN) document number generated in SAP S/4HANA MM upon physical receipt and posting of the inbound delivery. Triggers inventory replenishment and accounts payable processing.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `grn_posting_date` DATE COMMENT 'Accounting date on which the Goods Receipt Note (GRN) was posted in SAP S/4HANA MM, triggering inventory valuation and accounts payable accrual. Critical for period-end financial close.. Valid values are `^d{4}-d{2}-d{2}$`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the transfer of risk, cost, and responsibility between supplier and buyer for this delivery. Determines freight cost ownership and customs obligation.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `material_description` STRING COMMENT 'Short description of the material or component being received, as defined in the SAP material master. Provides human-readable context for receiving staff and reporting consumers.',
    `material_number` STRING COMMENT 'SAP S/4HANA material master number identifying the specific material, component, or MRO item being received. Aligns with Bill of Materials (BOM) and inventory management records.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `material_type` STRING COMMENT 'Classification of the received material by its role in the manufacturing process. Drives inventory valuation, storage location assignment, and downstream MRP/MES processing.. Valid values are `RAW_MATERIAL|COMPONENT|SEMI_FINISHED|FINISHED_GOOD|MRO|PACKAGING|SPARE_PART`',
    `net_price` DECIMAL(18,2) COMMENT 'Agreed net purchase price per unit of measure as specified on the Purchase Order, used for GRN valuation and accounts payable invoice matching. Sensitive commercial data.. Valid values are `^d+(.d{1,4})?$`',
    `open_quantity` DECIMAL(18,2) COMMENT 'Remaining quantity yet to be received against the Purchase Order line, calculated as ordered quantity minus received quantity. Drives follow-up actions with suppliers and MRP shortage alerts.. Valid values are `^d+(.d{1,4})?$`',
    `ordered_quantity` DECIMAL(18,2) COMMENT 'Quantity of the material ordered on the originating Purchase Order line item. Baseline for receipt-to-order variance calculation and discrepancy flagging.. Valid values are `^d+(.d{1,4})?$`',
    `quality_inspection_required` BOOLEAN COMMENT 'Indicates whether the received material requires a quality inspection lot to be created in SAP S/4HANA QM before the goods can be released to unrestricted stock. Driven by material master QM settings and AQL sampling plans.. Valid values are `true|false`',
    `quality_inspection_status` STRING COMMENT 'Current status of the quality inspection lot associated with this inbound delivery in SAP S/4HANA QM. Determines whether received stock can be transferred to unrestricted inventory or must be quarantined.. Valid values are `NOT_REQUIRED|PENDING|IN_PROGRESS|PASSED|FAILED|CONDITIONALLY_RELEASED`',
    `received_quantity` DECIMAL(18,2) COMMENT 'Actual quantity of the material physically received and confirmed at the receiving dock, as recorded in Infor WMS and posted in SAP S/4HANA MM GRN. Used for inventory replenishment and discrepancy analysis.. Valid values are `^d+(.d{1,4})?$`',
    `serial_number_range` STRING COMMENT 'Range or list of serial numbers for serialized components received in this delivery (e.g., SN001-SN050). Supports asset lifecycle tracking in Maximo EAM and warranty management.',
    `status` STRING COMMENT 'Current processing status of the inbound delivery across its lifecycle from planned arrival through GRN posting. Drives workflow routing in SAP MM and Infor WMS.. Valid values are `PLANNED|IN_TRANSIT|ARRIVED|PARTIALLY_RECEIVED|FULLY_RECEIVED|CANCELLED|ON_HOLD|DISCREPANCY_REVIEW`',
    `storage_location` STRING COMMENT 'SAP S/4HANA storage location or Infor WMS bin/zone where the received goods are physically placed. Drives putaway instructions and inventory balance updates.. Valid values are `^[A-Z0-9]{1,4}$`',
    `supplier_delivery_note` STRING COMMENT 'Supplier-provided delivery note or packing slip reference number accompanying the physical shipment. Used for supplier reconciliation, discrepancy resolution, and audit trail.',
    `tracking_number` STRING COMMENT 'Carrier-assigned shipment tracking number or waybill number enabling real-time shipment visibility and proof-of-delivery confirmation. Supports logistics KPI reporting and exception management.',
    `unit_of_measure` STRING COMMENT 'Unit of measure in which the ordered and received quantities are expressed, aligned with the SAP material master base unit. Ensures consistent quantity reporting across procurement and inventory systems.. Valid values are `EA|KG|LB|M|M2|M3|L|PC|BOX|PALLET|ROLL|SET`',
    `warehouse_number` STRING COMMENT 'Infor WMS or SAP WM warehouse number identifying the physical warehouse facility receiving the delivery. Enables warehouse-level operational and capacity reporting.. Valid values are `^[A-Z0-9]{1,3}$`',
    CONSTRAINT pk_logistics_inbound_delivery PRIMARY KEY(`logistics_inbound_delivery_id`)
) COMMENT 'Inbound delivery document tracking the receipt of purchased materials, components, or MRO goods from suppliers. Records expected arrival date, actual GRN date, supplier reference, purchase order reference, receiving location, quantity received vs. ordered, and discrepancy flags. Feeds SAP MM GRN processing and inventory replenishment in Infor WMS.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`tracking_event` (
    `tracking_event_id` BIGINT COMMENT 'Unique system-generated identifier for each shipment tracking event record in the logistics domain.',
    `carrier_id` BIGINT COMMENT 'Reference to the carrier or freight provider responsible for the shipment at the time of this event. Enables carrier performance benchmarking and SLA compliance tracking.',
    `location_id` BIGINT COMMENT 'Foreign key linking to logistics.logistics_location. Business justification: Tracking events occur at specific logistics network locations. Adding logistics_location_id FK normalizes the event location reference. location_name, city, state_province, and country_code are presen',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Manual tracking events are recorded by warehouse or logistics employees. Manufacturing tracks who recorded events for audit trails and operational accountability.',
    `shipment_id` BIGINT COMMENT 'Reference to the parent shipment record to which this tracking event belongs, enabling end-to-end shipment visibility.',
    `ot_system_id` BIGINT COMMENT 'Foreign key linking to technology.ot_system. Business justification: Tracking events originate from OT systems like RFID readers, barcode scanners, GPS devices, and warehouse automation controllers. Critical for tracing event source and data quality validation.',
    `actual_delivery_timestamp` TIMESTAMP COMMENT 'Exact date and time the shipment was confirmed as delivered, as reported by the carrier or captured via proof-of-delivery scan. Populated only for events of type delivered. Core input for OTIF performance measurement.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `carrier_event_code` STRING COMMENT 'The carriers proprietary status or event code transmitted via EDI or API feed (e.g., X1, D1, OFD). Used for carrier-specific event interpretation and reconciliation with TMS records.',
    `carrier_event_description` STRING COMMENT 'Human-readable description of the carrier event code as provided by the carriers EDI or API feed. Supplements the standardized event type with carrier-specific detail.',
    `carrier_name` STRING COMMENT 'Name of the carrier or freight provider that reported this tracking event. Retained for denormalized reporting and carrier performance dashboards.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the tracking event record was first ingested and created in the Silver layer. Used for data latency monitoring and SLA compliance of tracking feed integrations.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customs_reference_number` STRING COMMENT 'Official customs declaration or entry reference number assigned by the customs authority for cross-border shipments. Required for trade compliance documentation and regulatory audit trails.',
    `customs_status` STRING COMMENT 'Current customs clearance status of the shipment at the time of this event. Critical for cross-border trade compliance, import/export documentation management, and REACH/RoHS regulatory adherence.. Valid values are `not_applicable|pending|under_review|cleared|held|rejected`',
    `dwell_time_minutes` STRING COMMENT 'Duration in minutes the shipment remained stationary at the event location before the next movement. Used for terminal efficiency analysis, detention charge management, and bottleneck identification.',
    `estimated_delivery_date` DATE COMMENT 'Carrier-provided or TMS-calculated estimated delivery date updated at the time of this tracking event. Used for OTIF measurement, customer promise management, and ATP/CTP calculations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `event_source` STRING COMMENT 'Identifies the originating system or feed that generated the tracking event, such as carrier EDI, TMS, GPS telematics, IIoT sensor, or manual entry. Supports data lineage and source reliability analysis.. Valid values are `carrier_edi|tms|gps_telematics|iiot_sensor|manual|api_integration|wms`',
    `event_timestamp` TIMESTAMP COMMENT 'The exact date and time at which the tracking event occurred, as reported by the carrier, IIoT telematics, GPS device, or TMS integration. Used for transit time analysis and OTIF measurement.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `event_timezone` STRING COMMENT 'IANA timezone identifier for the location where the event occurred (e.g., America/Chicago, Europe/Berlin). Enables accurate local-time reporting across global distribution networks.',
    `event_type` STRING COMMENT 'Categorizes the nature of the shipment milestone or status change event, such as departed, in-transit, customs-cleared, out-for-delivery, delivered, or exception. Drives OTIF performance measurement and shipment visibility dashboards.. Valid values are `departed|in_transit|arrived|customs_cleared|out_for_delivery|delivered|exception|returned|attempted_delivery|held|cancelled`',
    `exception_code` STRING COMMENT 'Standardized code classifying the type of shipment exception when is_exception is true. Used for root cause analysis, CAPA processes, and carrier performance management.. Valid values are `delay|damage|lost|refused|weather_hold|customs_hold|address_issue|attempted_delivery|carrier_delay|mechanical_failure|other`',
    `exception_description` STRING COMMENT 'Free-text description of the shipment exception providing additional context beyond the exception code, such as specific damage details, delay reason, or customs hold explanation.',
    `is_exception` BOOLEAN COMMENT 'Boolean flag indicating whether this tracking event represents a shipment exception (e.g., delay, damage, lost, refused delivery). Triggers exception management workflows and customer notifications.. Valid values are `true|false`',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate (WGS84 decimal degrees) of the event location as captured by GPS telematics or IIoT device. Enables real-time map visualization and geofence-based alerting.. Valid values are `^-?(90(.0+)?|[1-8]?d(.d+)?)$`',
    `location_code` STRING COMMENT 'Standardized location identifier where the event occurred, such as a UN/LOCODE port code, facility code, or carrier hub code (e.g., USORD for Chicago OHare). Used for network analysis and lane performance reporting.',
    `location_type` STRING COMMENT 'Classifies the type of location where the event occurred, enabling network topology analysis and identification of bottlenecks in the distribution network.. Valid values are `origin|destination|transit_hub|port|customs_facility|carrier_depot|customer_site|warehouse|airport|rail_terminal`',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate (WGS84 decimal degrees) of the event location as captured by GPS telematics or IIoT device. Enables real-time map visualization and geofence-based alerting.. Valid values are `^-?(180(.0+)?|1[0-7]d(.d+)?|[1-9]?d(.d+)?)$`',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the tracking event record in the Silver layer, such as exception enrichment or status correction. Supports change data capture and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `pod_reference` STRING COMMENT 'Reference number or document identifier for the proof-of-delivery (POD) record associated with a delivered event. Used for freight audit, claims processing, and customer dispute resolution.',
    `pro_number` STRING COMMENT 'Progressive (PRO) number assigned by the carrier for LTL (Less-Than-Truckload) shipments. Used for freight bill matching, claims processing, and carrier reconciliation.',
    `raw_payload_reference` STRING COMMENT 'Reference key or identifier pointing to the original raw EDI, API, or telematics message stored in the Bronze layer. Supports data lineage, reprocessing, and audit trail requirements.',
    `sequence_number` STRING COMMENT 'Ordinal sequence number of this tracking event within the shipments event history, starting from 1. Enables chronological ordering of events and detection of out-of-sequence EDI transmissions.',
    `signed_by` STRING COMMENT 'Name or identifier of the person who signed for the delivery at the destination, as captured in the proof-of-delivery (POD) record. Used for delivery confirmation and dispute resolution.',
    `status` STRING COMMENT 'Lifecycle status of the tracking event record in the Silver layer. Superseded indicates a later event has replaced this one; duplicate flags EDI retransmissions. Supports data quality management and deduplication.. Valid values are `active|superseded|cancelled|duplicate`',
    `temperature_c` DECIMAL(18,2) COMMENT 'Ambient or cargo temperature in degrees Celsius recorded by IIoT telematics or cold-chain sensors at the time of the event. Used for cold-chain compliance monitoring and quality assurance of temperature-sensitive goods.',
    `tracking_number` STRING COMMENT 'Carrier-assigned tracking number or waybill number associated with the shipment at the time of this event. Used for carrier portal lookups and customer-facing shipment visibility.',
    `transport_mode` STRING COMMENT 'Mode of transportation active at the time of this tracking event (e.g., road, rail, air, ocean, intermodal). Drives freight cost analysis, carbon footprint reporting, and modal performance benchmarking.. Valid values are `road|rail|air|ocean|intermodal|courier|pipeline`',
    `vehicle_code` STRING COMMENT 'Identifier of the vehicle, vessel, aircraft, or rail car transporting the shipment at the time of this event (e.g., truck license plate, IMO vessel number, flight number). Supports asset tracking and incident investigation.',
    CONSTRAINT pk_tracking_event PRIMARY KEY(`tracking_event_id`)
) COMMENT 'Real-time and milestone-based shipment tracking events captured from carrier EDI feeds, IIoT telematics, GPS, and TMS integrations. Records event type (departed, in-transit, customs-cleared, out-for-delivery, delivered, exception), event timestamp, location (GPS coordinates or location code), carrier event code, and exception description. Enables end-to-end shipment visibility and OTIF performance measurement.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`freight_rate` (
    `freight_rate_id` BIGINT COMMENT 'Unique system-generated identifier for each freight rate record in the Transportation Management System (TMS). Serves as the primary key for all freight rate lookups, cost estimation, and freight audit processes.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier. Business justification: Freight rates are negotiated with specific carriers. freight_rate.carrier_code and carrier_name are denormalized references to the carrier master. Adding carrier_id FK enforces referential integrity a',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier_service. Business justification: Freight rates are defined for specific carrier service offerings (LTL, FTL, express, etc.). Adding carrier_service_id FK normalizes the service reference to the carrier_service master, enabling servic',
    `category_id` BIGINT COMMENT 'Foreign key linking to product.product_category. Business justification: Freight rates vary by product category due to handling requirements, density, and risk. Logistics pricing teams use this to calculate accurate shipping costs.',
    `freight_contract_id` BIGINT COMMENT 'Foreign key linking to logistics.freight_contract. Business justification: Freight rates are defined within freight contracts. freight_rate.contract_number is a denormalized reference to the freight_contract master. Adding freight_contract_id FK normalizes this relationship.',
    `transport_zone_id` BIGINT COMMENT 'Foreign key linking to logistics.transport_zone. Business justification: Freight rates are defined for specific origin transport zones. Adding origin_transport_zone_id FK links the rate to the origin zone master, enabling zone-based rate lookups. origin_region and origin_c',
    `approved_by` STRING COMMENT 'Name or identifier of the authorized approver who validated and approved this freight rate for use in TMS freight cost estimation. Supports internal controls, audit trail requirements, and procurement governance.',
    `approved_date` DATE COMMENT 'The date on which this freight rate was formally approved for operational use. Provides audit trail for rate governance and supports freight audit processes requiring proof of rate authorization.. Valid values are `^d{4}-d{2}-d{2}$`',
    `commodity_code` STRING COMMENT 'Standardized commodity classification code (NMFC for domestic road freight or HS/HTS code for international shipments) associated with this rate. Used for customs/trade compliance documentation, rate lookup, and freight classification audits.. Valid values are `^[0-9]{4,10}$`',
    `commodity_type` STRING COMMENT 'Classification of the goods or commodity type to which this rate applies. Freight rates often vary by commodity due to density, handling requirements, or hazardous material classification. Aligns with NMFC commodity codes for road freight or HS codes for international shipments.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the freight rate amount is denominated (e.g., USD, EUR, GBP, CNY). Essential for multi-currency freight cost management across global distribution networks and financial reporting under IFRS/GAAP.. Valid values are `^[A-Z]{3}$`',
    `destination_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code for the shipment destination location of the freight lane. Defines the geographic endpoint of the rate lane for global distribution network management and customs/trade compliance.. Valid values are `^[A-Z]{3}$`',
    `destination_region` STRING COMMENT 'Geographic region, zone, or postal code range for the shipment destination. Used in zone-based rate structures for TMS freight cost estimation and delivery performance analysis across global distribution networks.',
    `effective_date` DATE COMMENT 'The date from which this freight rate becomes valid and applicable for shipment cost estimation and carrier invoicing. Used in TMS rate selection to ensure only currently valid rates are applied to shipments.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'The date after which this freight rate is no longer valid. Used in TMS rate selection to exclude expired rates and trigger rate renewal workflows. Supports contract lifecycle management and freight audit date-range validation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `fuel_index_reference` STRING COMMENT 'Name or identifier of the fuel price index used to calculate or adjust the fuel surcharge component of this rate (e.g., DOE Weekly Retail On-Highway Diesel, IATA Jet Fuel Monitor, Platts Bunker Index). Ensures transparent and auditable fuel cost pass-through in carrier contracts.',
    `fuel_surcharge_pct` DECIMAL(18,2) COMMENT 'Fuel surcharge rate expressed as a percentage of the base freight rate. Applied dynamically based on fuel index benchmarks (e.g., DOE diesel index). Used in TMS freight cost estimation when rate_type is base_rate to calculate the total all-in freight cost.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `hazmat_eligible` BOOLEAN COMMENT 'Indicates whether this freight rate applies to shipments containing hazardous materials (Hazmat). Hazmat shipments require special handling, documentation, and regulatory compliance under DOT, IATA DGR, and IMDG regulations. Used in TMS carrier selection and compliance screening.. Valid values are `true|false`',
    `incoterm_code` STRING COMMENT 'International Commercial Terms (Incoterms) code defining the division of costs, risks, and responsibilities between buyer and seller for the shipment covered by this rate. Determines which party bears the freight cost and at what point risk transfers. Critical for customs/trade compliance documentation.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `lane_description` STRING COMMENT 'Human-readable description of the freight lane covered by this rate, typically expressed as origin-to-destination (e.g., Chicago IL to Frankfurt DE - Road/Ocean Intermodal). Used in carrier negotiations, TMS configuration, and freight cost reporting.',
    `maximum_charge` DECIMAL(18,2) COMMENT 'The maximum freight charge cap applicable for a shipment on this lane. Protects shippers from excessive charges on large shipments. Used in TMS freight cost estimation to apply ceiling pricing when calculated charges exceed this threshold.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `minimum_charge` DECIMAL(18,2) COMMENT 'The minimum freight charge applicable for a shipment on this lane regardless of weight, volume, or quantity. Ensures carrier cost recovery for small shipments. Used in TMS freight cost estimation to apply floor pricing when calculated charges fall below this threshold.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `negotiated_by` STRING COMMENT 'Name or identifier of the procurement/logistics team member or department responsible for negotiating this freight rate with the carrier. Used for accountability tracking in carrier management and contract lifecycle management.',
    `origin_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code for the shipment origin location of the freight lane. Defines the geographic starting point of the rate lane for global distribution network management and customs/trade compliance.. Valid values are `^[A-Z]{3}$`',
    `origin_region` STRING COMMENT 'Geographic region, zone, or postal code range for the shipment origin. Used in zone-based rate structures where rates vary by geographic zone rather than specific point-to-point lanes. Supports TMS freight cost estimation for regional distribution.',
    `rate_amount` DECIMAL(18,2) COMMENT 'The contracted or spot freight rate value expressed per the defined rate basis (e.g., rate per kg, per pallet, per container, per mile). Core financial field used in TMS freight cost estimation, carrier invoice validation, and freight audit. Stored with 4 decimal precision to support per-unit micro-rates.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `rate_basis` STRING COMMENT 'The unit of measure upon which the freight rate is applied. Determines how the rate is multiplied against shipment characteristics to calculate total freight cost. Critical for TMS freight cost estimation and carrier invoice validation during freight audit.. Valid values are `per_kg|per_lb|per_pallet|per_container|per_mile|per_km|per_cbm|per_shipment|per_piece|per_cwt|flat_rate|per_teu|per_feu`',
    `rate_number` STRING COMMENT 'Business-facing alphanumeric identifier for the freight rate record, used in TMS freight cost estimation, freight audit, and carrier negotiations. Typically references the rate tariff or contract schedule number.. Valid values are `^FR-[A-Z0-9]{4,20}$`',
    `rate_source` STRING COMMENT 'Indicates the origin or basis of the freight rate. Contract rates are pre-negotiated with carriers; spot rates are obtained for individual shipments; benchmark rates are used for market comparison; tariff rates are published carrier schedules. Drives rate selection logic in TMS.. Valid values are `contract|spot|benchmark|tariff|index|negotiated|spot_quote`',
    `rate_type` STRING COMMENT 'Classification of the freight rate component. Base rate is the primary transportation charge; fuel surcharge adjusts for fuel cost fluctuations; accessorial covers special handling services; other types cover specific operational scenarios. Used in TMS freight cost estimation and freight audit.. Valid values are `base_rate|fuel_surcharge|accessorial|peak_surcharge|hazmat_surcharge|oversize_surcharge|residential_delivery|liftgate|inside_delivery|detention|demurrage`',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when this freight rate record was first created in the system. Used for data lineage, audit trail, and Silver Layer ingestion tracking in the Databricks Lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this freight rate record. Used for change tracking, incremental data loading in the Databricks Lakehouse Silver Layer, and freight audit trail maintenance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `service_level` STRING COMMENT 'The carrier service level or transit time commitment associated with this rate. Differentiates between speed-of-delivery tiers (e.g., express vs. economy) and shipment consolidation types (e.g., Full Truck Load vs. Less-than-Truck Load). Used in TMS carrier selection and SLA compliance.. Valid values are `standard|express|overnight|same_day|economy|deferred|priority|ltl|ftl|fcl|lcl|next_day_air|second_day_air`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this freight rate record originated (e.g., SAP S/4HANA SD-TM, Infor TMS, SAP Ariba, carrier portal). Supports data lineage tracking in the Databricks Lakehouse Silver Layer and freight audit traceability.. Valid values are `SAP_S4HANA|INFOR_TMS|SAP_ARIBA|MANUAL|CARRIER_PORTAL|BENCHMARK_FEED`',
    `status` STRING COMMENT 'Current lifecycle status of the freight rate record. Active rates are available for TMS freight cost estimation; expired rates are retained for historical freight audit; superseded rates have been replaced by newer versions; pending_approval rates are awaiting authorization.. Valid values are `active|inactive|expired|pending_approval|superseded|draft`',
    `tariff_number` STRING COMMENT 'Published carrier tariff or rate schedule number from which this rate is derived. Used for tariff-based rate validation during freight audit and regulatory compliance with published rate requirements (e.g., FMC tariff filing for ocean freight).',
    `temperature_controlled` BOOLEAN COMMENT 'Indicates whether this freight rate applies to temperature-controlled (cold chain) shipments requiring refrigerated or heated transport equipment. Relevant for industrial manufacturing products with temperature-sensitive components or chemicals.. Valid values are `true|false`',
    `transit_days` STRING COMMENT 'Contracted or standard number of calendar or business days for transit from origin to destination under this rate and service level. Used in TMS delivery date calculation, SLA compliance monitoring, and customer order promising (Available to Promise / ATP).. Valid values are `^[0-9]{1,3}$`',
    `transport_mode` STRING COMMENT 'The mode of transportation to which this freight rate applies. Determines the applicable carrier pool, regulatory requirements, and rate structure. Used in TMS route optimization and carrier selection.. Valid values are `road|rail|ocean|air|intermodal|courier|parcel|barge|pipeline`',
    `weight_break_max_kg` DECIMAL(18,2) COMMENT 'Maximum shipment weight in kilograms for which this rate applies. Defines the upper bound of the weight break tier in tiered rate structures. Used in TMS rate selection logic to match shipment weight to the correct rate tier.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `weight_break_min_kg` DECIMAL(18,2) COMMENT 'Minimum shipment weight in kilograms for which this rate applies. Defines the lower bound of the weight break tier in tiered rate structures. Used in TMS rate selection logic to match shipment weight to the correct rate tier.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    CONSTRAINT pk_freight_rate PRIMARY KEY(`freight_rate_id`)
) COMMENT 'Contracted and spot freight rate records negotiated with carriers for specific lanes, service levels, and commodity types. Stores rate type (base rate, fuel surcharge, accessorial), rate basis (per kg, per pallet, per container, per mile), currency, effective/expiry dates, minimum charge, and rate source (contract, spot, benchmark). Used in TMS freight cost estimation and freight audit.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` (
    `freight_invoice_id` BIGINT COMMENT 'Unique surrogate identifier for the freight invoice record in the lakehouse silver layer. Serves as the primary key for all downstream joins and lineage tracking.',
    `ap_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ap_invoice. Business justification: Freight invoices from carriers are recorded as accounts payable. Finance processes these for payment approval, GL posting, and vendor payment execution daily.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Freight invoices must reference bill-to customer account for freight charge allocation and payment processing. Accounts receivable uses this for every freight billing cycle.',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Freight invoices from carriers are recorded in billing system. Logistics tracks which billing invoice corresponds to each freight invoice for payment processing and reconciliation.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier. Business justification: Freight invoices are issued by carriers. freight_invoice.carrier_scac_code and carrier_name are denormalized references to the carrier master. Adding carrier_id FK enforces referential integrity and e',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Freight costs must be allocated to specific cost centers for departmental expense tracking and budget management. Controllers use this for monthly variance analysis.',
    `freight_contract_id` BIGINT COMMENT 'Foreign key linking to logistics.freight_contract. Business justification: Freight invoices are billed against contracted rates defined in freight contracts. Adding freight_contract_id FK links the invoice to the governing contract, enabling contract compliance verification ',
    `freight_order_id` BIGINT COMMENT 'Foreign key linking to logistics.freight_order. Business justification: Freight invoices are issued for the execution of freight orders. Adding freight_order_id FK links the invoice to the operational freight order, enabling invoice-to-order matching and payment reconcili',
    `application_id` BIGINT COMMENT 'Foreign key linking to technology.application. Business justification: Freight invoices are processed through freight audit/payment applications (Cass, AFS, nVision). Finance and logistics teams use this to track which system handles invoice validation and payment.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Freight invoice references purchase order - normalize by replacing purchase_order_number text with FK',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Freight invoices allocate transportation costs to sales orders - enables freight cost recovery, margin analysis, and customer billing for shipping charges.',
    `accessorial_amount` DECIMAL(18,2) COMMENT 'Total accessorial charges billed on this invoice, including but not limited to liftgate, residential delivery, inside delivery, detention, redelivery, and hazmat handling fees. Subject to contracted accessorial rate validation.. Valid values are `^-?d+(.d{1,4})?$`',
    `approved_amount` DECIMAL(18,2) COMMENT 'Amount approved for payment after freight audit, dispute resolution, and any adjustments. May differ from invoiced_amount if overcharges, duplicate charges, or unauthorized accessorials are identified and disputed.. Valid values are `^-?d+(.d{1,4})?$`',
    `audit_exception_code` STRING COMMENT 'Standardized exception code identifying the reason for a freight audit failure or discrepancy (e.g., RATE_MISMATCH, DUPLICATE_INVOICE, UNAUTHORIZED_ACCESSORIAL, WEIGHT_DISCREPANCY). Used for dispute management and carrier performance tracking.',
    `audit_status` STRING COMMENT 'Status of the freight audit process for this invoice, indicating whether the invoice has been validated against contracted rates, shipment data, and accessorial entitlements. Distinct from payment status.. Valid values are `pending|in_progress|passed|failed|exception|waived`',
    `base_freight_amount` DECIMAL(18,2) COMMENT 'Line-level base freight charge billed by the carrier, excluding surcharges and accessorials. Derived from contracted rate applied to shipment weight, volume, or distance. Used for rate audit and cost benchmarking.. Valid values are `^-?d+(.d{1,4})?$`',
    `bill_of_lading_number` STRING COMMENT 'Bill of Lading (BOL) number associated with the shipment being billed on this invoice. Used to cross-reference the freight invoice against the shipment record and proof of delivery for audit validation.',
    `billing_period_end_date` DATE COMMENT 'End date of the transportation service period covered by this invoice. Used in conjunction with billing_period_start_date to define the scope of services billed.. Valid values are `^d{4}-d{2}-d{2}$`',
    `billing_period_start_date` DATE COMMENT 'Start date of the transportation service period covered by this invoice. Relevant for consolidated or periodic billing arrangements with carriers.. Valid values are `^d{4}-d{2}-d{2}$`',
    `carrier_reference_number` STRING COMMENT 'Carriers internal reference or pro number associated with the shipment or freight movement being billed. Used to cross-reference the invoice against the carriers own records and the TMS shipment record.',
    `carrier_tax_number` STRING COMMENT 'Tax identification number (e.g., EIN, VAT registration number) of the carrier. Required for tax compliance, 1099 reporting, and accounts payable vendor master validation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the freight invoice record was first created in the lakehouse silver layer. Used for data lineage, audit trail, and processing cycle time measurement.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `destination_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the shipment destination location. Used for trade lane analysis, import duty applicability, and freight cost allocation by geography.. Valid values are `^[A-Z]{3}$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Contractual discount or rebate applied by the carrier on this invoice (e.g., volume discount, early payment discount). Reduces the net payable amount and must be validated against the carrier contract terms.. Valid values are `^-?d+(.d{1,4})?$`',
    `dispute_reason` STRING COMMENT 'Free-text or coded description of the reason for disputing the freight invoice (e.g., rate overcharge, duplicate billing, service failure, unauthorized accessorial). Populated when audit_status is failed or status is disputed.',
    `dispute_resolution_date` DATE COMMENT 'Date on which the freight invoice dispute was resolved between the company and the carrier. Used to measure dispute cycle time and carrier responsiveness KPIs.. Valid values are `^d{4}-d{2}-d{2}$`',
    `due_date` DATE COMMENT 'Date by which payment must be made to the carrier to comply with contracted payment terms and avoid late payment penalties or interest charges.. Valid values are `^d{4}-d{2}-d{2}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Exchange rate applied to convert the invoice currency to the companys functional reporting currency at the time of invoice processing. Required for multi-currency financial consolidation and IFRS/GAAP compliance.. Valid values are `^d+(.d{1,6})?$`',
    `fuel_surcharge_amount` DECIMAL(18,2) COMMENT 'Fuel surcharge billed by the carrier, typically calculated as a percentage of the base freight charge based on the applicable fuel index (e.g., DOE diesel index). Subject to contracted fuel surcharge table validation.. Valid values are `^-?d+(.d{1,4})?$`',
    `functional_currency_code` STRING COMMENT 'ISO 4217 currency code of the companys functional reporting currency (e.g., USD) to which the invoice amount is converted for financial consolidation and IFRS/GAAP reporting.. Valid values are `^[A-Z]{3}$`',
    `gl_account_code` STRING COMMENT 'General Ledger (GL) account code to which the freight cost is posted in the financial system. Enables freight cost allocation to the correct P&L line (e.g., inbound freight, outbound freight, intercompany freight).',
    `invoice_type` STRING COMMENT 'Classification of the freight invoice by billing type. Distinguishes standard per-shipment invoices from consolidated periodic invoices, credit/debit adjustments, and corrected re-bills.. Valid values are `standard|consolidated|credit_memo|debit_memo|corrected|supplemental`',
    `invoiced_amount` DECIMAL(18,2) COMMENT 'Total gross amount billed by the carrier on this invoice in the invoice currency, inclusive of all charges (base freight, fuel surcharge, accessorials, taxes). The primary amount subject to freight audit and payment approval.. Valid values are `^-?d+(.d{1,4})?$`',
    `invoiced_amount_functional` DECIMAL(18,2) COMMENT 'Total invoiced amount converted to the companys functional reporting currency using the exchange_rate. Used for financial consolidation, cost center allocation, and management reporting.. Valid values are `^-?d+(.d{1,4})?$`',
    `is_intercompany` BOOLEAN COMMENT 'Indicates whether this freight invoice represents an intercompany charge between legal entities within the same corporate group. Drives intercompany elimination in financial consolidation and transfer pricing compliance.. Valid values are `true|false`',
    `origin_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the shipment origin location. Used for trade lane analysis, customs compliance validation, and freight cost allocation by geography.. Valid values are `^[A-Z]{3}$`',
    `payment_date` DATE COMMENT 'Actual date the invoice was paid to the carrier. Populated upon payment confirmation from the accounts payable system. Used for cash flow reporting and on-time payment KPI tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `payment_method` STRING COMMENT 'Method used or designated for payment of this freight invoice (e.g., ACH, wire transfer, check, virtual card). Drives accounts payable processing workflow and bank reconciliation.. Valid values are `ach|wire_transfer|check|credit_card|virtual_card|netting`',
    `payment_reference` STRING COMMENT 'Payment transaction reference number (e.g., ACH trace number, check number, wire reference) generated upon payment execution. Used for bank reconciliation and payment confirmation to the carrier.',
    `payment_terms_code` STRING COMMENT 'Contracted payment terms code applicable to this invoice (e.g., NET30, NET45, 2/10NET30). Determines the payment due date and any early payment discount eligibility.',
    `pro_number` STRING COMMENT 'Carrier-assigned Progressive (PRO) number used to track the freight shipment through the carriers network. Serves as the carriers primary shipment identifier and is referenced on the freight invoice for audit matching.',
    `received_date` DATE COMMENT 'Date the freight invoice was received by the accounts payable or freight audit team. Used to calculate days-to-pay and to track invoice processing cycle time.. Valid values are `^d{4}-d{2}-d{2}$`',
    `service_level` STRING COMMENT 'Contracted service level or transit time commitment under which the freight was shipped. Used to validate that the billed service level matches the contracted rate and shipment requirements.. Valid values are `standard|expedited|overnight|two_day|ltl|ftl|deferred|economy`',
    `status` STRING COMMENT 'Current processing status of the freight invoice through the freight audit and payment lifecycle. Drives workflow routing, approval actions, and financial accrual decisions.. Valid values are `received|under_audit|disputed|approved|rejected|paid|partially_paid|cancelled|on_hold`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax charges included in the freight invoice (e.g., VAT, GST, sales tax on transportation services). Required for tax input credit recovery and compliance with local tax regulations.. Valid values are `^-?d+(.d{1,4})?$`',
    `transport_mode` STRING COMMENT 'Mode of transportation used for the freight movement being billed. Drives rate validation logic, accessorial applicability, and freight cost allocation by mode in financial reporting.. Valid values are `road|rail|ocean|air|intermodal|courier|parcel`',
    CONSTRAINT pk_freight_invoice PRIMARY KEY(`freight_invoice_id`)
) COMMENT 'Carrier-issued freight invoice submitted for payment of transportation services rendered. Captures invoice number, carrier reference, invoice date, billing period, total invoiced amount, currency, line-level charge breakdown (base freight, fuel surcharge, accessorials), and payment status. Subject to freight audit and match against contracted freight rates before approval for payment.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`freight_audit` (
    `freight_audit_id` BIGINT COMMENT 'Unique system-generated identifier for each freight audit record in the lakehouse silver layer.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Freight audits require assignment to specific employees for review and approval. Finance and logistics departments track auditor identity for compliance and accountability.',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Freight audits verify carrier invoices before payment. Manufacturing companies audit freight charges against billing invoices to catch overcharges and ensure accurate freight cost accounting.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier. Business justification: Freight audits are performed against carrier invoices. freight_audit.carrier_name and carrier_scac_code are denormalized references to the carrier master. Adding carrier_id FK enforces referential int',
    `freight_invoice_id` BIGINT COMMENT 'Foreign key linking to logistics.freight_invoice. Business justification: Freight audits compare carrier-invoiced charges against contracted rates. Each audit record corresponds to a specific freight invoice. Adding freight_invoice_id FK enforces this relationship. carrier_',
    `freight_rate_id` BIGINT COMMENT 'Foreign key linking to logistics.freight_rate. Business justification: Freight audits compare invoiced charges against contracted freight rates. freight_audit.rate_contract_number is a denormalized reference to the rate/contract. Adding freight_rate_id FK normalizes this',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Freight audit adjustments post to specific GL accounts for expense corrections and accrual adjustments. Controllers use this for month-end close reconciliation.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Freight audits are performed for specific shipments. freight_audit.shipment_number is a denormalized string reference. Adding shipment_id FK enforces referential integrity and enables shipment-level a',
    `accessorial_charges_approved` DECIMAL(18,2) COMMENT 'Total accessorial charges approved for payment after audit review, reflecting only those accessorial charges that are contractually authorized and correctly applied.',
    `accessorial_charges_invoiced` DECIMAL(18,2) COMMENT 'Total accessorial charges (e.g., fuel surcharge, detention, liftgate, residential delivery) billed by the carrier on the invoice, audited separately from base freight charges.',
    `approved_amount` DECIMAL(18,2) COMMENT 'Final approved payment amount for the freight invoice after audit review, reflecting any adjustments, deductions, or corrections applied during the audit process.',
    `approved_by` STRING COMMENT 'Name or identifier of the approver who authorized the final approved payment amount, providing an audit trail for financial controls and segregation of duties.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the freight invoice was approved for payment by the authorized approver, used for payment processing and audit trail.',
    `audit_date` DATE COMMENT 'Calendar date on which the freight audit was initiated or the carrier invoice was received and entered into the audit process.',
    `audit_number` STRING COMMENT 'Business-facing unique reference number for the freight audit record, used for cross-system tracking and communication with carriers and finance teams.. Valid values are `^FA-[0-9]{4}-[0-9]{6}$`',
    `audit_status` STRING COMMENT 'Current processing status of the freight audit record, tracking its lifecycle from initial receipt through resolution.. Valid values are `pending|in_review|approved|disputed|rejected|closed|on_hold`',
    `audit_type` STRING COMMENT 'Classification of the audit as pre-payment (before carrier payment is released) or post-payment (after payment, for recovery), or other audit trigger types.. Valid values are `pre_payment|post_payment|spot_check|carrier_initiated|compliance_review`',
    `audited_by` STRING COMMENT 'Name or identifier of the freight auditor (internal analyst or third-party audit firm) who performed the audit review of this invoice.',
    `audited_timestamp` TIMESTAMP COMMENT 'Date and time when the freight audit review was completed and the audit findings were recorded, providing an audit trail for compliance and process performance measurement.',
    `bill_of_lading_number` STRING COMMENT 'Bill of Lading number associated with the shipment being audited, serving as the primary transport document reference for freight billing verification.',
    `carrier_invoice_date` DATE COMMENT 'Date printed on the carriers invoice document, used for payment terms calculation and aging analysis.',
    `contracted_amount` DECIMAL(18,2) COMMENT 'Expected freight charge amount calculated based on the contracted rate agreement with the carrier for the applicable trade lane, service level, and shipment characteristics.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the freight audit record was first created in the system, used for audit trail, SLA measurement, and process performance tracking.',
    `credit_memo_number` STRING COMMENT 'Reference number of the credit memo issued by the carrier to correct an overcharge identified during the audit, used for accounts payable reconciliation.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the carrier invoice was issued (e.g., USD, EUR, CNY), used for multi-currency reconciliation and FX conversion.. Valid values are `^[A-Z]{3}$`',
    `destination_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the shipment destination, used for trade lane analysis, customs compliance, and applicable rate determination.. Valid values are `^[A-Z]{3}$`',
    `dispute_raised_date` DATE COMMENT 'Date on which the formal dispute was raised with the carrier, used to track dispute aging and compliance with contractual dispute filing deadlines.',
    `dispute_reference_number` STRING COMMENT 'Unique reference number assigned to the formal dispute case raised against the carrier, used for tracking dispute resolution progress and correspondence.',
    `dispute_resolution_date` DATE COMMENT 'Date on which the freight invoice dispute was formally resolved, either through carrier credit, adjusted payment, or mutual agreement.',
    `fuel_surcharge_invoiced` DECIMAL(18,2) COMMENT 'Fuel surcharge amount billed by the carrier on the invoice, audited against the contracted fuel surcharge schedule or index-based formula.',
    `invoiced_amount` DECIMAL(18,2) COMMENT 'Total freight charge amount as billed by the carrier on the invoice, before any audit adjustments. This is the amount under review in the audit process.',
    `is_disputed` BOOLEAN COMMENT 'Indicates whether a formal dispute has been raised against the carrier for this invoice, triggering the dispute resolution workflow and carrier notification process.. Valid values are `true|false`',
    `is_duplicate_invoice` BOOLEAN COMMENT 'Indicates whether the carrier invoice has been identified as a duplicate of a previously processed invoice for the same shipment, triggering automatic rejection.. Valid values are `true|false`',
    `origin_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the shipment origin location, used for trade lane analysis and applicable rate determination.. Valid values are `^[A-Z]{3}$`',
    `payment_due_date` DATE COMMENT 'Date by which the approved freight invoice amount must be paid to the carrier per contracted payment terms, used for cash flow planning and early payment discount management.',
    `payment_status` STRING COMMENT 'Current payment status of the audited freight invoice, indicating whether the approved amount has been disbursed to the carrier.. Valid values are `unpaid|partially_paid|paid|on_hold|cancelled|overpaid`',
    `pro_number` STRING COMMENT 'Carrier-assigned Progressive (PRO) number used to track the shipment within the carriers system, essential for matching invoices to shipment records during audit.',
    `purchase_order_number` STRING COMMENT 'Purchase Order number associated with the freight transaction, used to validate that freight charges are linked to an authorized procurement event.',
    `resolution_outcome` STRING COMMENT 'Final outcome of the freight audit and any associated dispute, indicating how the billing discrepancy was resolved (e.g., carrier issued credit, invoice accepted, written off).. Valid values are `accepted_as_invoiced|partial_credit|full_credit|carrier_corrected|written_off|escalated|no_action`',
    `service_level` STRING COMMENT 'Contracted service level for the shipment (e.g., LTL, FTL, expedited), which determines the applicable contracted rate used in the audit comparison.. Valid values are `standard|expedited|overnight|two_day|ltl|ftl|deferred|economy`',
    `transport_mode` STRING COMMENT 'Mode of transportation used for the shipment being audited (e.g., road, rail, ocean, air), which determines applicable rate structures and tariff rules.. Valid values are `road|rail|ocean|air|intermodal|courier|parcel`',
    `variance_amount` DECIMAL(18,2) COMMENT 'Monetary difference between the carrier-invoiced amount and the contracted amount (invoiced_amount minus contracted_amount). Positive value indicates overcharge; negative indicates undercharge.',
    `variance_percentage` DECIMAL(18,2) COMMENT 'Variance amount expressed as a percentage of the contracted amount, used to assess materiality of billing discrepancies and trigger dispute thresholds.',
    `variance_reason_code` STRING COMMENT 'Standardized code categorizing the root cause of the billing variance identified during the audit, used for trend analysis and carrier performance management.. Valid values are `rate_discrepancy|weight_discrepancy|accessorial_charge|duplicate_invoice|incorrect_service_level|fuel_surcharge_error|dimensional_weight_error|address_correction|detention_charge|other`',
    `variance_reason_description` STRING COMMENT 'Free-text narrative providing additional detail on the variance reason, supplementing the standardized reason code with specific findings from the audit review.',
    CONSTRAINT pk_freight_audit PRIMARY KEY(`freight_audit_id`)
) COMMENT 'Freight audit record comparing carrier-invoiced charges against contracted freight rates and shipment actuals to identify billing discrepancies, overcharges, and duplicate invoices. Records audit status, variance amount, variance reason code, dispute flag, approved amount, and resolution outcome. Supports freight cost control and carrier compliance management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` (
    `customs_declaration_id` BIGINT COMMENT 'Unique surrogate identifier for the customs declaration record in the lakehouse silver layer.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Customs declarations require accurate component descriptions, HS codes, and country of origin from engineering master data. Customs brokers use this for every international shipment to calculate dutie',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Customs duties and fees are allocated to importing departments cost center for landed cost calculation and budget accountability.',
    `export_classification_id` BIGINT COMMENT 'Foreign key linking to compliance.export_classification. Business justification: Customs declarations require export classification codes for cross-border shipments. Customs teams reference this daily to ensure proper regulatory classification and prevent export violations.',
    `application_id` BIGINT COMMENT 'Foreign key linking to technology.application. Business justification: Customs declarations are filed through specialized applications (Amber Road, Descartes, e2open). Compliance teams track which system submitted declarations for audit trails and regulatory reporting.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Customs declarations must be prepared by certified employees. International manufacturing operations track who prepared documents for regulatory compliance and legal accountability.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: International shipments require customs declarations linked to POs for valuation, duty calculation, and import compliance - customs brokers use this for clearance documentation daily.',
    `product_regulatory_certification_id` BIGINT COMMENT 'Foreign key linking to product.regulatory_certification. Business justification: Customs declarations reference product certifications required for cross-border shipments. Customs brokers use this to clear goods through international borders and avoid delays.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Customs declarations reference sales orders for export compliance - required for international shipments to declare goods, value, and trade terms.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Customs declarations are filed for specific cross-border shipments. Adding shipment_id FK links the declaration to the shipment master, enabling trade compliance tracking at the shipment level. No shi',
    `amendment_reason` STRING COMMENT 'Free-text description of the reason for amending a previously submitted customs declaration. Required when status is amended to maintain audit trail and regulatory compliance documentation.',
    `ce_marking_required` BOOLEAN COMMENT 'Indicates whether the declared goods require CE Marking for entry into the European Economic Area (EEA), confirming conformity with applicable EU health, safety, and environmental protection standards.. Valid values are `true|false`',
    `clearance_date` DATE COMMENT 'Date on which the customs authority officially released the shipment, confirming all duties, taxes, and compliance requirements have been satisfied. Critical for delivery performance measurement and landed cost accounting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `clearance_timestamp` TIMESTAMP COMMENT 'Precise date and time when customs clearance was granted. Supports SLA measurement, dwell time analysis, and logistics scheduling downstream of customs release.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `compliance_status` STRING COMMENT 'Overall trade compliance status of the customs declaration, reflecting the outcome of regulatory checks including export controls, sanctions screening, REACH/RoHS, and CE Marking requirements.. Valid values are `compliant|non_compliant|pending_review|conditionally_compliant|exempted`',
    `country_of_export_code` STRING COMMENT 'ISO 3166-1 alpha-3 code for the country from which goods are being exported. Required for export licensing, trade statistics, and origin verification.. Valid values are `^[A-Z]{3}$`',
    `country_of_import_code` STRING COMMENT 'ISO 3166-1 alpha-3 code for the country into which goods are being imported. Used for duty rate determination, trade compliance, and regulatory reporting.. Valid values are `^[A-Z]{3}$`',
    `country_of_origin_code` STRING COMMENT 'ISO 3166-1 alpha-3 code for the country where the goods were manufactured or substantially transformed. Determines applicable duty rates, preferential trade agreement eligibility, and anti-dumping measures.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the customs declaration record was first created in the system. Supports audit trail, data lineage, and regulatory record-keeping requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customs_broker_name` STRING COMMENT 'Name of the licensed customs broker or freight forwarder responsible for preparing and filing the customs declaration. Supports vendor management, performance tracking, and audit accountability.',
    `customs_broker_reference` STRING COMMENT 'Reference number assigned by the licensed customs broker or freight forwarder managing the declaration filing on behalf of the company. Used for broker invoice reconciliation and communication.',
    `customs_procedure_code` STRING COMMENT 'Customs Procedure Code (CPC) or Customs Regime Code identifying the specific customs procedure under which goods are declared (e.g., 40 00 for release for free circulation, 10 00 for permanent export). Determines applicable customs rules and obligations.',
    `declaration_number` STRING COMMENT 'Official customs entry or declaration number assigned by the customs authority or filing system upon submission. Used as the primary business reference for tracking and correspondence with customs authorities.',
    `declaration_type` STRING COMMENT 'Indicates whether the declaration is for an import, export, transit, re-import, re-export, or temporary movement of goods across a customs border.. Valid values are `import|export|transit|re-import|re-export|temporary_import|temporary_export`',
    `declared_value` DECIMAL(18,2) COMMENT 'Total declared customs value of the goods as stated on the declaration, used as the basis for ad valorem duty and tax calculation. Typically represents the transaction value per WCO Customs Valuation Agreement (GATT Article VII).',
    `declared_value_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the declared customs value (e.g., USD, EUR, GBP). Required for currency conversion to the customs authoritys local currency for duty assessment.. Valid values are `^[A-Z]{3}$`',
    `duty_amount` DECIMAL(18,2) COMMENT 'Total customs duty assessed or paid on the declaration, calculated based on the applicable tariff rate applied to the declared value or specific quantity. A key component of landed cost.',
    `duty_currency` STRING COMMENT 'ISO 4217 three-letter currency code in which duty and tax amounts are assessed and paid to the customs authority. Typically the local currency of the importing country.. Valid values are `^[A-Z]{3}$`',
    `duty_rate_percent` DECIMAL(18,2) COMMENT 'The ad valorem duty rate (as a percentage) applied to the declared value to calculate the customs duty amount. Reflects the applicable tariff schedule rate after any preferential trade agreement reductions.',
    `entry_number` STRING COMMENT 'Formal customs entry number assigned by the importing or exporting countrys customs authority upon acceptance of the declaration. Distinct from the internal declaration number; used for official government correspondence and audit trails.',
    `export_control_classification` STRING COMMENT 'Export Control Classification Number (ECCN) or equivalent classification code assigned to the goods under applicable export control regulations. Determines whether an export license is required. Critical for dual-use goods and defense-related industrial equipment.',
    `export_license_number` STRING COMMENT 'Government-issued export license number authorizing the export of controlled goods. Required for goods subject to export control regulations (EAR, ITAR, EU Dual-Use). Null if no license required.',
    `exporter_of_record` STRING COMMENT 'Legal entity name designated as the Exporter of Record (EOR) responsible for the export declaration, export licensing compliance, and adherence to export control regulations.',
    `filing_date` DATE COMMENT 'Date on which the customs declaration was formally filed with the customs authority. Used for compliance tracking, duty calculation, and regulatory deadline management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `gross_weight_kg` DECIMAL(18,2) COMMENT 'Total gross weight of the declared goods in kilograms, including packaging. Required field on customs declarations for duty calculation, transport documentation, and statistical reporting.',
    `hs_code` STRING COMMENT 'Primary Harmonized System (HS) tariff classification code for the declared goods, as defined by the WCO Harmonized Commodity Description and Coding System. Determines applicable duty rates, trade restrictions, and statistical reporting. For multi-line declarations, this represents the primary or header-level HS code.. Valid values are `^d{6,10}$`',
    `importer_of_record` STRING COMMENT 'Legal entity name designated as the Importer of Record (IOR) responsible for ensuring the imported goods comply with all applicable laws and regulations and for paying applicable duties and taxes.',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the allocation of costs, risks, and responsibilities between buyer and seller for the shipment. Influences customs valuation method and duty liability.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `is_reach_compliant` BOOLEAN COMMENT 'Indicates whether the declared goods comply with EU REACH (Registration, Evaluation, Authorisation and Restriction of Chemicals) regulation requirements. Mandatory for chemical substances and articles containing substances of very high concern (SVHC) imported into the EU.. Valid values are `true|false`',
    `is_rohs_compliant` BOOLEAN COMMENT 'Indicates whether the declared goods comply with EU RoHS (Restriction of Hazardous Substances) Directive requirements, restricting the use of specific hazardous materials in electrical and electronic equipment.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the customs declaration record. Used for change tracking, incremental data processing in the lakehouse, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `net_weight_kg` DECIMAL(18,2) COMMENT 'Net weight of the declared goods in kilograms, excluding packaging. Used for specific duty calculations (per-unit-weight tariffs), trade statistics, and regulatory reporting.',
    `package_count` STRING COMMENT 'Total number of packages or pieces included in the customs declaration. Required for customs manifest reconciliation and physical inspection verification.',
    `port_of_entry_code` STRING COMMENT 'UN/LOCODE or customs authority port code identifying the port, airport, or border crossing where goods enter the importing country and where the customs declaration is processed.',
    `port_of_exit_code` STRING COMMENT 'UN/LOCODE or customs authority port code identifying the port, airport, or border crossing from which goods depart the exporting country.',
    `preferential_origin` BOOLEAN COMMENT 'Indicates whether the goods qualify for preferential tariff treatment under a Free Trade Agreement (FTA) or preferential trade arrangement, resulting in reduced or zero duty rates.. Valid values are `true|false`',
    `status` STRING COMMENT 'Current processing status of the customs declaration, tracking its lifecycle from initial draft through submission, customs review, and final clearance or rejection.. Valid values are `draft|submitted|under_review|held|released|cleared|rejected|cancelled|amended`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total import taxes assessed or paid on the declaration, including VAT, GST, excise duties, and other applicable taxes levied at the border. Distinct from customs duty.',
    `trade_agreement_code` STRING COMMENT 'Code identifying the Free Trade Agreement (FTA) or preferential trade arrangement under which preferential duty rates are claimed (e.g., USMCA, EU-UK TCA, CPTPP, RCEP). Required when preferential_origin is true.',
    `transport_mode` STRING COMMENT 'Mode of transport used to carry the goods across the customs border, as declared on the customs entry. Aligns with WCO and UN transport mode codes. Affects applicable customs procedures and documentation requirements.. Valid values are `sea|air|road|rail|multimodal|pipeline|postal|fixed_transport_installation`',
    `valuation_method` STRING COMMENT 'WCO-defined method used to determine the customs value of the declared goods. Transaction value (Method 1) is the primary method; alternative methods are applied in sequence when transaction value cannot be used.. Valid values are `transaction_value|identical_goods|similar_goods|deductive|computed|fallback`',
    CONSTRAINT pk_customs_declaration PRIMARY KEY(`customs_declaration_id`)
) COMMENT 'Trade compliance document filed with customs authorities for cross-border shipments. Records declaration type (import/export), customs entry number, HS tariff codes, declared value, country of origin, Incoterms, duty and tax amounts, customs broker reference, filing date, clearance date, and compliance status. Supports REACH/RoHS, CE Marking, and export control regulatory obligations.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`trade_document` (
    `trade_document_id` BIGINT COMMENT 'Unique surrogate identifier for each trade document record in the logistics data product. Serves as the primary key for all cross-border freight documentation.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Trade documents like commercial invoices and certificates of origin must reference specific catalog items. Export compliance teams use this for accurate customs documentation.',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to logistics.customs_declaration. Business justification: Trade documents are associated with customs declarations for cross-border shipments. trade_document.customs_declaration_number is a denormalized reference. Adding customs_declaration_id FK normalizes ',
    `engineering_regulatory_certification_id` BIGINT COMMENT 'Foreign key linking to engineering.regulatory_certification. Business justification: Trade documents must reference engineering regulatory certifications (CE, UL, RoHS) for cross-border shipments. Export compliance teams verify certifications daily to ensure products meet destination ',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Trade documents (bill of lading, packing lists) reference sales orders - required for international shipping documentation and customs clearance.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Trade documents (bills of lading, certificates of origin, etc.) are associated with specific shipments. trade_document.shipment_number is a denormalized string reference. Adding shipment_id FK enforce',
    `acceptance_date` DATE COMMENT 'Date on which the trade document was formally accepted or approved by the customs authority or receiving party. Marks the completion of the regulatory review process.. Valid values are `^d{4}-d{2}-d{2}$`',
    `attachment_format` STRING COMMENT 'File format of the digital attachment associated with the trade document (e.g., PDF for scanned documents, XML for electronic trade documents, EDI for structured data exchange).. Valid values are `PDF|TIFF|XML|EDI|JPEG|PNG|DOCX`',
    `attachment_reference` STRING COMMENT 'Reference path, URL, or document management system identifier pointing to the digital copy or scanned image of the trade document stored in the enterprise content management or document repository.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when the trade document record was first created in the system. Used for audit trail, data lineage, and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customs_office_code` STRING COMMENT 'Official code identifying the customs office or port of entry/exit where the trade document was lodged or processed. Used for customs clearance tracking and regulatory reporting.',
    `dangerous_goods_class` STRING COMMENT 'UN dangerous goods hazard class assigned to the goods (e.g., Class 3 Flammable Liquids, Class 8 Corrosives). Required on dangerous goods declarations for transport compliance.. Valid values are `1|2|3|4|5|6|7|8|9`',
    `declared_value` DECIMAL(18,2) COMMENT 'Monetary value of the goods as declared on the trade document for customs valuation purposes. Used to calculate import duties, taxes, and insurance premiums.',
    `declared_value_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the declared customs value amount on the trade document (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `destination_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the destination country for the goods covered by this trade document. Determines import regulations, duties, and compliance requirements.. Valid values are `^[A-Z]{3}$`',
    `document_number` STRING COMMENT 'Official document number assigned by the issuing authority or internal system (e.g., BOL number, AWB number, invoice number, export license number). Used for tracking and cross-referencing across systems.',
    `document_type` STRING COMMENT 'Classification of the trade document by its business function in the cross-border freight process. Determines the regulatory and operational handling requirements for the document.. Valid values are `commercial_invoice|packing_list|bill_of_lading|airway_bill|certificate_of_origin|export_license|import_license|customs_declaration|dangerous_goods_declaration|phytosanitary_certificate|insurance_certificate|inspection_certificate|letter_of_credit|delivery_order|freight_invoice|proof_of_delivery`',
    `document_version` STRING COMMENT 'Version or revision identifier of the trade document, used when amendments or corrections are issued. Enables tracking of document history and ensures the most current version is used.',
    `electronic_submission_indicator` BOOLEAN COMMENT 'Flag indicating whether the trade document was submitted electronically to customs authorities via an electronic data interchange (EDI) or customs portal, as opposed to paper submission.. Valid values are `true|false`',
    `expiry_date` DATE COMMENT 'Calendar date after which the trade document is no longer valid for regulatory or commercial purposes. Applicable to export licenses, letters of credit, phytosanitary certificates, and similar time-bound documents.. Valid values are `^d{4}-d{2}-d{2}$`',
    `export_control_classification` STRING COMMENT 'Export Control Classification Number (ECCN) or equivalent classification code assigned to the goods, indicating whether an export license is required under applicable export control regulations.',
    `export_license_number` STRING COMMENT 'Official export license number issued by the relevant government authority authorizing the export of controlled goods. Required for dual-use items, defense articles, and sanctioned country shipments.',
    `free_trade_agreement_code` STRING COMMENT 'Code identifying the specific free trade agreement under which preferential tariff treatment is claimed (e.g., USMCA, EU-UK TCA, CPTPP). Used for duty reduction and customs clearance.',
    `gross_weight_kg` DECIMAL(18,2) COMMENT 'Total gross weight of the goods covered by the trade document, expressed in kilograms. Required for freight calculation, customs declaration, and dangerous goods documentation.',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the responsibilities of buyer and seller for delivery, risk transfer, and cost allocation as documented in the trade document.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `is_dangerous_goods` BOOLEAN COMMENT 'Flag indicating whether the trade document covers dangerous goods (hazardous materials) requiring special handling, labeling, and regulatory documentation under IATA DGR or IMDG Code.. Valid values are `true|false`',
    `is_reach_compliant` BOOLEAN COMMENT 'Flag indicating whether the goods covered by this trade document comply with EU REACH (Registration, Evaluation, Authorization and Restriction of Chemicals) regulation requirements.. Valid values are `true|false`',
    `is_rohs_compliant` BOOLEAN COMMENT 'Flag indicating whether the goods covered by this trade document comply with EU RoHS (Restriction of Hazardous Substances) directive requirements for electrical and electronic equipment.. Valid values are `true|false`',
    `issue_date` DATE COMMENT 'Calendar date on which the trade document was officially issued or created by the issuing authority. Used for validity period calculation and regulatory compliance verification.. Valid values are `^d{4}-d{2}-d{2}$`',
    `issuing_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the trade document was issued. Critical for determining applicable trade regulations and compliance requirements.. Valid values are `^[A-Z]{3}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the trade document record. Supports change tracking, audit compliance, and data freshness monitoring in the Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `letter_of_credit_number` STRING COMMENT 'Reference number of the letter of credit (LC) associated with the trade transaction. Required for documentary credit transactions where payment is contingent on presentation of compliant trade documents.',
    `net_weight_kg` DECIMAL(18,2) COMMENT 'Net weight of the goods excluding packaging, expressed in kilograms. Used for customs valuation, duty calculation, and trade statistics reporting.',
    `origin_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the country of origin of the goods covered by this trade document. Used for tariff determination, preferential trade agreements, and certificate of origin validation.. Valid values are `^[A-Z]{3}$`',
    `package_count` STRING COMMENT 'Total number of packages, cartons, or handling units covered by the trade document. Required for packing list verification and customs declaration.',
    `preferential_origin` BOOLEAN COMMENT 'Flag indicating whether the goods qualify for preferential tariff treatment under a free trade agreement (FTA) or preferential trade arrangement, as evidenced by the certificate of origin.. Valid values are `true|false`',
    `rejection_reason` STRING COMMENT 'Description of the reason provided by the customs authority or reviewing party for rejecting or returning the trade document. Used for corrective action and resubmission.',
    `status` STRING COMMENT 'Current lifecycle status of the trade document, tracking its progression from initial creation through regulatory acceptance or rejection.. Valid values are `draft|pending_approval|approved|submitted|accepted|rejected|expired|cancelled|superseded|archived`',
    `submission_date` DATE COMMENT 'Date on which the trade document was submitted to the relevant customs authority or regulatory body for processing and acceptance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `transport_mode` STRING COMMENT 'Mode of transportation associated with the trade document, determining the applicable document type (e.g., Bill of Lading for sea, Airway Bill for air). Aligns with IATA and IMO classifications.. Valid values are `sea|air|road|rail|multimodal|courier|inland_waterway`',
    `un_number` STRING COMMENT 'United Nations four-digit identification number assigned to dangerous goods for international transport. Required on dangerous goods declarations and shipping documents.. Valid values are `^UNd{4}$`',
    CONSTRAINT pk_trade_document PRIMARY KEY(`trade_document_id`)
) COMMENT 'Repository of trade and shipping documentation associated with cross-border freight movements, including commercial invoices, packing lists, certificates of origin, bills of lading (BOL), airway bills (AWB), export licenses, and dangerous goods declarations. Stores document type, document number, issuing authority, issue date, expiry date, and digital attachment reference.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`packaging` (
    `packaging_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for each packaging configuration record in the logistics master data.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Packaging specifications are designed for specific components based on engineering dimensions, weight, and fragility requirements. Packaging engineers reference component specs daily to design appropr',
    `line_id` BIGINT COMMENT 'Foreign key linking to production.production_line. Business justification: Packaging operations occur on or adjacent to production lines. Packaging specifications, line speed, and material requirements are tied to specific production lines for operational coordination and ef',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Packaging specifications are defined per SKU to ensure proper protection during transport. Logistics planners reference this to determine container requirements and shipping costs.',
    `category` STRING COMMENT 'High-level classification of the packaging unit type used in freight operations. Drives load planning rules, dimensional weight calculations, and carrier compatibility checks.. Valid values are `pallet|carton|crate|drum|ibc|iso_container|bag|tote|spool|tube|envelope|other`',
    `code` STRING COMMENT 'Business-assigned alphanumeric code uniquely identifying the packaging type or configuration, used in TMS, WMS, and load planning systems for reference and lookup.. Valid values are `^[A-Z0-9_-]{2,30}$`',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating where the packaging unit is manufactured. Used in customs documentation, trade compliance, and import/export declarations.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the packaging master record was first created in the system. Used for data lineage, audit trail, and compliance with data governance policies.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `deposit_amount` DECIMAL(18,2) COMMENT 'Deposit value charged per returnable packaging unit to incentivize return. Applicable when is_returnable is true. Used in accounts receivable, reverse logistics, and deposit reconciliation.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `deposit_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the returnable packaging deposit amount. Supports multi-currency deposit management across global operations.. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Detailed free-text description of the packaging configuration, including material composition, construction notes, and intended use cases for freight operations.',
    `dimensional_weight_factor` DECIMAL(18,2) COMMENT 'Carrier-specific volumetric divisor used to calculate dimensional (chargeable) weight from package volume. Typically 5000 for air freight (IATA) or 4000/3000 for road/ocean. Used in freight cost estimation.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `effective_date` DATE COMMENT 'Date from which this packaging configuration is valid and available for use in freight operations. Used to manage packaging master data versioning and lifecycle transitions.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date after which this packaging configuration is no longer valid for use in new freight operations. Used to retire obsolete packaging types and enforce compliance with updated standards.. Valid values are `^d{4}-d{2}-d{2}$`',
    `ghs_pictogram_code` STRING COMMENT 'GHS hazard pictogram code(s) required on the packaging label for chemical or hazardous content (e.g., GHS01, GHS06). Applicable for HAZMAT-compatible packaging types.',
    `gross_volume_m3` DECIMAL(18,2) COMMENT 'Total external cubic volume of the packaging unit in cubic meters, calculated from external L×W×H dimensions. Used in load planning, vehicle utilization, and freight billing.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `hazmat_un_certification` STRING COMMENT 'UN certification code assigned to this packaging type for hazardous materials transport (e.g., 1A1/Y1.8/150). Required for HAZMAT shipments under IATA, IMDG, and ADR regulations.',
    `height_mm` DECIMAL(18,2) COMMENT 'External height dimension of the packaging unit in millimeters. Used in dimensional weight calculation, load planning, stacking analysis, and carrier compliance checks.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `internal_volume_m3` DECIMAL(18,2) COMMENT 'Usable internal cubic volume of the packaging unit in cubic meters. Used in volumetric capacity planning, load optimization, and dimensional weight calculations.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `is_hazmat_compatible` BOOLEAN COMMENT 'Indicates whether this packaging type is certified and approved for use with hazardous materials. Drives carrier selection, documentation requirements, and regulatory compliance checks.. Valid values are `true|false`',
    `is_reach_compliant` BOOLEAN COMMENT 'Indicates whether the packaging material and construction comply with EU REACH regulation (Registration, Evaluation, Authorisation and Restriction of Chemicals). Required for EU market access.. Valid values are `true|false`',
    `is_returnable` BOOLEAN COMMENT 'Indicates whether the packaging unit is returnable (reusable) or disposable (single-use). Drives reverse logistics processes, deposit tracking, and sustainability reporting.. Valid values are `true|false`',
    `is_rohs_compliant` BOOLEAN COMMENT 'Indicates whether the packaging material complies with the EU Restriction of Hazardous Substances (RoHS) directive, restricting use of specific hazardous materials in electrical/electronic packaging.. Valid values are `true|false`',
    `is_stackable` BOOLEAN COMMENT 'Indicates whether this packaging type can be stacked on top of other units during storage or transport. Drives load planning stacking rules and warehouse slotting logic.. Valid values are `true|false`',
    `is_temperature_controlled` BOOLEAN COMMENT 'Indicates whether this packaging type provides temperature control or insulation capability for cold chain or temperature-sensitive freight.. Valid values are `true|false`',
    `iso_container_type_code` STRING COMMENT 'Four-character ISO 6346 container type and size code (e.g., 22G1 for 20ft general purpose dry container). Applicable only for ISO container packaging types used in ocean and intermodal freight.. Valid values are `^[A-Z0-9]{4}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the packaging master record. Used for change tracking, data synchronization between TMS/WMS systems, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `length_mm` DECIMAL(18,2) COMMENT 'External length dimension of the packaging unit in millimeters. Used in dimensional weight calculation, load planning, and carrier compliance checks.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `material_composition` STRING COMMENT 'Primary material from which the packaging unit is constructed. Used in sustainability reporting, REACH/RoHS compliance checks, customs documentation, and recycling classification.. Valid values are `wood|cardboard|corrugated_paper|plastic_hdpe|plastic_ldpe|plastic_pp|steel|aluminum|composite|foam|fabric|other`',
    `max_gross_weight_kg` DECIMAL(18,2) COMMENT 'Maximum allowable total weight (tare + payload) of the packaging unit in kilograms. Used for carrier compliance, vehicle load limits, and structural safety validation.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `max_payload_kg` DECIMAL(18,2) COMMENT 'Maximum allowable net content weight in kilograms that the packaging unit can safely carry. Used in load planning to prevent overloading and ensure structural integrity.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `max_stack_layers` STRING COMMENT 'Maximum number of identical packaging units that can be safely stacked vertically. Applicable when is_stackable is true. Used in warehouse slotting and load planning.. Valid values are `^[0-9]+$`',
    `name` STRING COMMENT 'Descriptive name of the packaging type (e.g., Euro Pallet 1200x800, 20ft ISO Dry Container, Corrugated Carton Type A), used in operational and reporting contexts.',
    `status` STRING COMMENT 'Current lifecycle status of the packaging configuration record. Controls whether the packaging type is available for use in new shipments and load plans.. Valid values are `active|inactive|obsolete|under_review`',
    `supplier_code` STRING COMMENT 'Reference code of the primary supplier or manufacturer of this packaging type, as registered in SAP Ariba or SAP MM vendor master. Used for procurement and supplier performance tracking.. Valid values are `^[A-Z0-9_-]{2,30}$`',
    `tare_weight_kg` DECIMAL(18,2) COMMENT 'Empty weight of the packaging unit in kilograms, excluding any contents. Used to calculate gross weight from net weight and for freight cost computation.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `temperature_max_c` DECIMAL(18,2) COMMENT 'Maximum temperature in degrees Celsius that this packaging can maintain or withstand. Applicable for temperature-controlled packaging types used in cold chain logistics.. Valid values are `^-?[0-9]+(.[0-9]{1,2})?$`',
    `temperature_min_c` DECIMAL(18,2) COMMENT 'Minimum temperature in degrees Celsius that this packaging can maintain or withstand. Applicable for temperature-controlled packaging types used in cold chain logistics.. Valid values are `^-?[0-9]+(.[0-9]{1,2})?$`',
    `transport_mode_compatibility` STRING COMMENT 'Transport modes for which this packaging type is approved and certified. Used in carrier selection, route planning, and compliance validation within the TMS.. Valid values are `air|ocean|road|rail|multimodal|all`',
    `type` STRING COMMENT 'Indicates the packaging hierarchy level: primary (direct product contact), secondary (grouped units), tertiary (shipping/transport unit). Used in packaging compliance and load planning.. Valid values are `primary|secondary|tertiary|transport`',
    `unit_cost` DECIMAL(18,2) COMMENT 'Standard procurement cost per packaging unit in the defined currency. Used in freight cost allocation, packaging spend analysis, and total landed cost calculations.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `unit_cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the packaging unit cost (e.g., USD, EUR, CNY). Supports multi-currency operations across global distribution networks.. Valid values are `^[A-Z]{3}$`',
    `width_mm` DECIMAL(18,2) COMMENT 'External width dimension of the packaging unit in millimeters. Used in dimensional weight calculation, load planning, and carrier compliance checks.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    CONSTRAINT pk_packaging PRIMARY KEY(`packaging_id`)
) COMMENT 'Master record for packaging configurations and container types used in freight operations, including pallets, cartons, crates, drums, IBCs, and ISO containers. Stores packaging type code, dimensions (L×W×H), tare weight, max payload, stackability flag, hazmat compatibility, returnable/disposable flag, and unit cost. Used in load planning, dimensional weight calculation, and packaging compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`load_unit` (
    `load_unit_id` BIGINT COMMENT 'Unique surrogate identifier for the physical load unit (handling unit) record in the lakehouse silver layer. Serves as the primary key for all downstream joins and lineage tracking.',
    `carrier_id` BIGINT COMMENT 'FK to logistics.carrier',
    `delivery_id` BIGINT COMMENT 'Foreign key linking to logistics.delivery. Business justification: Load units are associated with outbound delivery documents. load_unit.delivery_document_number is a denormalized string reference. Adding delivery_id FK normalizes this relationship. delivery_document',
    `handling_unit_id` BIGINT COMMENT 'Foreign key linking to inventory.handling_unit. Business justification: Load units represent physical groupings of handling units for transport optimization. Freight planning consolidates multiple handling units into load units for carrier assignment.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Load units are physically assembled by warehouse employees. Manufacturing tracks who loaded units for quality control, labor costing, and productivity measurement.',
    `packaging_id` BIGINT COMMENT 'Foreign key linking to logistics.packaging. Business justification: Load units are built using specific packaging configurations. load_unit.packaging_type and packaging_material_code are denormalized references to the packaging master. Adding packaging_id FK normalize',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Load units (pallets, containers) are built for specific shipments. load_unit.shipment_number is a denormalized string reference. Adding shipment_id FK enforces referential integrity and enables shipme',
    `contents_description` STRING COMMENT 'Free-text summary description of the goods packed within this load unit. Used on shipping labels, customs declarations, and carrier documentation when a detailed item manifest is not required.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this load unit record was first created in the WMS system. Used for audit trail, data lineage, and operational reporting on packing lead times.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `declared_value` DECIMAL(18,2) COMMENT 'Declared customs value of the goods packed within this load unit, used for customs duty calculation, cargo insurance, and export/import documentation. Expressed in the currency specified by declared_value_currency.. Valid values are `^[0-9]{1,15}(.[0-9]{1,2})?$`',
    `declared_value_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the declared customs value of this load unit (e.g., USD, EUR, GBP). Required for multi-currency customs and trade compliance reporting.. Valid values are `^[A-Z]{3}$`',
    `goods_issue_date` DATE COMMENT 'Date on which goods issue was posted in SAP for the delivery associated with this load unit, transferring inventory ownership from the plant to the carrier. Critical for revenue recognition and inventory accounting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `gross_weight_kg` DECIMAL(18,2) COMMENT 'Total gross weight of the load unit including packaging materials and all packed contents, expressed in kilograms. Used for freight cost calculation, carrier weight limits, and customs declarations.. Valid values are `^[0-9]{1,9}(.[0-9]{1,3})?$`',
    `handling_unit_number` STRING COMMENT 'Business-facing handling unit number assigned by the Warehouse Management System (Infor WMS) at the time of packing. Used to track the physical load unit across warehouse operations and freight execution.. Valid values are `^HU-[A-Z0-9]{6,20}$`',
    `height_cm` DECIMAL(18,2) COMMENT 'Outer height dimension of the load unit in centimeters. Used for volumetric weight calculation, stacking constraint validation, and truck/container load planning.. Valid values are `^[0-9]{1,7}(.[0-9]{1,2})?$`',
    `is_hazmat` BOOLEAN COMMENT 'Indicates whether this load unit contains hazardous materials (HAZMAT) requiring special handling, labeling, and documentation per IMDG, IATA DGR, or ADR regulations.. Valid values are `true|false`',
    `is_sealed` BOOLEAN COMMENT 'Indicates whether the load unit has been physically sealed with a tamper-evident seal. A sealed status prevents further packing modifications and triggers customs documentation workflows.. Valid values are `true|false`',
    `is_temperature_controlled` BOOLEAN COMMENT 'Indicates whether this load unit requires temperature-controlled transport and storage (cold chain). Triggers reefer equipment selection and temperature monitoring requirements in TMS.. Valid values are `true|false`',
    `item_count` STRING COMMENT 'Total number of individual line items (SKUs or material numbers) packed within this load unit. Used for packing completeness validation, customs declaration, and receiving verification at destination.. Valid values are `^[0-9]{1,6}$`',
    `label_printed` BOOLEAN COMMENT 'Indicates whether the GS1 logistics label (including SSCC barcode) has been successfully printed and applied to this load unit. A prerequisite for carrier handover and shipment confirmation.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this load unit record was last updated in the source system. Used for incremental data extraction, change data capture (CDC), and audit trail maintenance in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `length_cm` DECIMAL(18,2) COMMENT 'Outer length dimension of the load unit in centimeters. Used for volumetric weight calculation, truck/container load planning, and warehouse slotting.. Valid values are `^[0-9]{1,7}(.[0-9]{1,2})?$`',
    `loading_timestamp` TIMESTAMP COMMENT 'Date and time when this load unit was physically loaded onto the carrier vehicle or container. Marks the transition from warehouse custody to carrier custody and triggers goods issue in SAP.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `max_stack_weight_kg` DECIMAL(18,2) COMMENT 'Maximum allowable weight in kilograms that may be placed on top of this load unit during stacking. Used to enforce structural integrity constraints in warehouse and transport load planning.. Valid values are `^[0-9]{1,7}(.[0-9]{1,3})?$`',
    `net_weight_kg` DECIMAL(18,2) COMMENT 'Net weight of the packed goods within the load unit, excluding packaging materials, expressed in kilograms. Required for customs declarations, export documentation, and trade compliance reporting.. Valid values are `^[0-9]{1,9}(.[0-9]{1,3})?$`',
    `packing_station_code` STRING COMMENT 'Identifier of the warehouse packing station or work center where this load unit was assembled and packed. Used for labor tracking, throughput analysis, and quality traceability.',
    `packing_timestamp` TIMESTAMP COMMENT 'Date and time when packing of this load unit was completed and the status transitioned to packed in the WMS. Used for warehouse throughput analysis and shipment readiness tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `plant_code` STRING COMMENT 'SAP plant code representing the manufacturing or distribution facility from which this load unit originates. Used for inventory valuation, goods issue posting, and regulatory compliance reporting.. Valid values are `^[A-Z0-9]{4}$`',
    `pro_number` STRING COMMENT 'Carrier-assigned Progressive (PRO) number for this load unit, used for LTL (Less-than-Truckload) shipment tracking and freight bill matching. Assigned by the carrier at pickup.',
    `required_temperature_max_c` DECIMAL(18,2) COMMENT 'Maximum allowable temperature in degrees Celsius for this load unit during transport and storage. Applicable only when is_temperature_controlled is true. Used for carrier SLA enforcement and cold chain compliance.. Valid values are `^-?[0-9]{1,3}(.[0-9]{1,2})?$`',
    `required_temperature_min_c` DECIMAL(18,2) COMMENT 'Minimum allowable temperature in degrees Celsius for this load unit during transport and storage. Applicable only when is_temperature_controlled is true. Used for carrier SLA enforcement and cold chain compliance.. Valid values are `^-?[0-9]{1,3}(.[0-9]{1,2})?$`',
    `seal_number` STRING COMMENT 'Tamper-evident seal number affixed to the load unit (container or trailer) after packing is complete. Required for customs clearance, security compliance, and proof of cargo integrity at destination.',
    `special_handling_code` STRING COMMENT 'Standardized code indicating special handling requirements for this load unit during transport and storage (e.g., fragile, keep dry, this side up). Printed on the load unit label and communicated to carriers.. Valid values are `fragile|keep_dry|this_side_up|do_not_freeze|keep_refrigerated|handle_with_care|no_stack|other`',
    `sscc_barcode` STRING COMMENT '18-digit GS1 Serial Shipping Container Code (SSCC) barcode printed on the load unit label. Globally unique identifier used for EDI shipment notifications (ASN), carrier scanning, and customs documentation.. Valid values are `^[0-9]{18}$`',
    `stacking_allowed` BOOLEAN COMMENT 'Indicates whether this load unit may be stacked on top of or beneath other load units during storage and transport. Drives warehouse slotting rules and carrier load planning constraints.. Valid values are `true|false`',
    `status` STRING COMMENT 'Current lifecycle status of the load unit from creation through packing, labeling, sealing, loading onto carrier, transit, and final delivery or return. Drives operational workflows in WMS and TMS.. Valid values are `created|in_packing|packed|labeled|sealed|loaded|in_transit|delivered|returned|cancelled`',
    `tare_weight_kg` DECIMAL(18,2) COMMENT 'Weight of the empty packaging material (pallet, container, carton) without contents, expressed in kilograms. Calculated as gross weight minus net weight; used for carrier billing reconciliation.. Valid values are `^[0-9]{1,7}(.[0-9]{1,3})?$`',
    `tms_load_code` STRING COMMENT 'Reference identifier for the freight load or shipment record in the Transportation Management System (TMS) to which this load unit is assigned. Bridges Infor WMS packing operations with TMS freight execution.',
    `total_quantity` DECIMAL(18,2) COMMENT 'Aggregate quantity of all units packed within this load unit across all line items. Used for shipment completeness checks, inventory reconciliation, and carrier documentation.. Valid values are `^[0-9]{1,11}(.[0-9]{1,3})?$`',
    `volume_m3` DECIMAL(18,2) COMMENT 'Total outer volume of the load unit in cubic meters, derived from length × width × height. Used for freight rate calculation (volumetric weight), container utilization, and load planning optimization.. Valid values are `^[0-9]{1,6}(.[0-9]{1,4})?$`',
    `warehouse_number` STRING COMMENT 'SAP/WMS warehouse complex number where this load unit was packed and staged for outbound shipment. Supports multi-site operations across global distribution centers.',
    `width_cm` DECIMAL(18,2) COMMENT 'Outer width dimension of the load unit in centimeters. Used for volumetric weight calculation, truck/container load planning, and warehouse slotting.. Valid values are `^[0-9]{1,7}(.[0-9]{1,2})?$`',
    CONSTRAINT pk_load_unit PRIMARY KEY(`load_unit_id`)
) COMMENT 'Physical load unit (handling unit) built for a specific shipment, representing a pallet, container, or package that has been packed and labeled for transport. Records handling unit number, packaging type, gross weight, dimensions, seal number, SSCC barcode, contents summary, and packing status. Bridges warehouse packing operations (Infor WMS) with TMS freight execution.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` (
    `carrier_performance_id` BIGINT COMMENT 'Unique surrogate identifier for each carrier performance scorecard record in the Databricks Silver Layer.',
    `carrier_id` BIGINT COMMENT 'FK to logistics.carrier',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier_service. Business justification: Carrier performance scorecards measure performance at the service level (LTL, FTL, express, etc.). Adding carrier_service_id FK links the scorecard to the specific carrier service being measured, enab',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Carrier performance evaluations are conducted by logistics managers. Manufacturing tracks who performed evaluations for vendor management and procurement decisions.',
    `freight_contract_id` BIGINT COMMENT 'Foreign key linking to logistics.freight_contract. Business justification: Carrier performance is measured against contracted SLA targets defined in freight contracts. Adding freight_contract_id FK links the scorecard to the governing contract, enabling SLA compliance tracki',
    `avg_transit_time_days` DECIMAL(18,2) COMMENT 'Average actual transit time in days from pickup to delivery for all shipments handled by the carrier on this lane during the scorecard period.',
    `co2_per_tonne_km` DECIMAL(18,2) COMMENT 'Carbon dioxide (CO2) emissions intensity of the carrier expressed in kilograms of CO2 per tonne-kilometre for the evaluated service lane and period. Key sustainability KPI for carrier rationalization and ESG reporting.',
    `contracted_transit_time_days` DECIMAL(18,2) COMMENT 'Contractually agreed standard transit time in days for the carrier on this service lane, as defined in the carrier SLA or rate agreement.',
    `corrective_action_required` BOOLEAN COMMENT 'Indicates whether a formal corrective action plan (CAPA) has been required from the carrier as a result of performance deficiencies identified in this scorecard period.. Valid values are `true|false`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the carrier performance scorecard record was created in the system, used for data lineage and audit trail purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary values (freight spend, damage claim value) reported in this scorecard record.. Valid values are `^[A-Z]{3}$`',
    `damage_claim_rate_percent` DECIMAL(18,2) COMMENT 'Percentage of shipments resulting in a freight damage claim during the scorecard period, calculated as (damage claims / total shipments) × 100. Key quality indicator for carrier selection.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `damage_claim_value` DECIMAL(18,2) COMMENT 'Total monetary value of freight damage claims filed against the carrier during the scorecard period, in the reporting currency. Used for financial impact assessment and carrier cost-of-quality analysis.',
    `damage_claims` STRING COMMENT 'Number of freight damage claims filed against the carrier during the scorecard period. Numerator for damage claim rate calculation.. Valid values are `^[0-9]+$`',
    `destination_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code for the destination end of the evaluated service lane.. Valid values are `^[A-Z]{3}$`',
    `edi_compliance_percent` DECIMAL(18,2) COMMENT 'Percentage of required EDI (Electronic Data Interchange) transactions (e.g., 214 shipment status, 210 freight invoice, 990 response) submitted accurately and on time by the carrier during the scorecard period.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `in_full_shipments` STRING COMMENT 'Number of shipments delivered with complete quantity as ordered during the scorecard period. Used as the numerator for in-full delivery rate calculation.. Valid values are `^[0-9]+$`',
    `invoice_accuracy_percent` DECIMAL(18,2) COMMENT 'Percentage of carrier invoices that matched the contracted rate without discrepancy during the scorecard period. Measures billing accuracy and administrative compliance.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `invoice_disputes` STRING COMMENT 'Number of carrier invoices disputed due to billing errors, rate discrepancies, or unauthorized charges during the scorecard period.. Valid values are `^[0-9]+$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the carrier performance scorecard record, supporting audit trail and change tracking requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `on_time_shipments` STRING COMMENT 'Number of shipments delivered on or before the committed delivery date during the scorecard period. Used as the numerator for on-time delivery rate calculation.. Valid values are `^[0-9]+$`',
    `origin_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code for the origin end of the evaluated service lane.. Valid values are `^[A-Z]{3}$`',
    `otif_actual_percent` DECIMAL(18,2) COMMENT 'Actual OTIF (On-Time In-Full) rate achieved by the carrier during the scorecard period, calculated as (OTIF shipments / total shipments) × 100. Core KPI for carrier qualification reviews.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `otif_shipments` STRING COMMENT 'Number of shipments delivered both on-time and in-full during the scorecard period. Numerator for the OTIF (On-Time In-Full) rate, the primary carrier delivery performance KPI.. Valid values are `^[0-9]+$`',
    `otif_target_percent` DECIMAL(18,2) COMMENT 'Contractually agreed OTIF (On-Time In-Full) target percentage for this carrier and service lane, as defined in the carrier SLA agreement. Used for SLA compliance assessment.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `overall_score` DECIMAL(18,2) COMMENT 'Composite weighted performance score (0–100) assigned to the carrier for the scorecard period, aggregating OTIF, transit time compliance, damage claim rate, invoice accuracy, EDI compliance, and sustainability metrics per the carrier scoring methodology.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `performance_rating` STRING COMMENT 'Categorical performance rating assigned to the carrier based on the overall score, used to drive carrier qualification decisions, preferred carrier lists, and strategic carrier rationalization.. Valid values are `preferred|approved|conditional|probation|disqualified`',
    `period_end_date` DATE COMMENT 'End date of the performance measurement period covered by this scorecard record.. Valid values are `^d{4}-d{2}-d{2}$`',
    `period_start_date` DATE COMMENT 'Start date of the performance measurement period covered by this scorecard record.. Valid values are `^d{4}-d{2}-d{2}$`',
    `pickup_compliance_percent` DECIMAL(18,2) COMMENT 'Percentage of shipments picked up by the carrier within the agreed pickup window during the scorecard period. Measures carrier reliability at origin.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `review_date` DATE COMMENT 'Date on which the carrier performance scorecard was formally reviewed and approved by the responsible logistics manager.. Valid values are `^d{4}-d{2}-d{2}$`',
    `review_status` STRING COMMENT 'Current workflow status of the carrier performance scorecard, tracking its lifecycle from initial draft through carrier review, approval, and closure.. Valid values are `draft|pending_review|reviewed|approved|disputed|closed`',
    `reviewed_by` STRING COMMENT 'Name or employee identifier of the logistics manager or carrier relationship owner who reviewed and approved this scorecard.',
    `scorecard_number` STRING COMMENT 'Business-facing unique reference number for the carrier performance scorecard record, used in carrier qualification reviews and SLA enforcement communications.. Valid values are `^CP-[0-9]{4}-[0-9]{2}-[A-Z0-9]{6}$`',
    `scorecard_period_type` STRING COMMENT 'Frequency granularity of the carrier performance scorecard (e.g., monthly, quarterly, annual), determining the review cycle for carrier qualification and SLA enforcement.. Valid values are `weekly|monthly|quarterly|annual`',
    `service_lane_code` STRING COMMENT 'Identifier for the specific origin-destination trade lane or service corridor for which this carrier performance scorecard is generated, enabling lane-level carrier rationalization.',
    `service_type` STRING COMMENT 'Type of freight service provided by the carrier on the evaluated lane (e.g., Full Truckload (FTL), Less-than-Truckload (LTL), Full Container Load (FCL), Less-than-Container Load (LCL), express).. Valid values are `FTL|LTL|FCL|LCL|express|standard|economy|dedicated|spot`',
    `sla_breach_flag` BOOLEAN COMMENT 'Indicates whether the carrier breached one or more contractual SLA (Service Level Agreement) thresholds during the scorecard period. Triggers SLA enforcement and corrective action workflows.. Valid values are `true|false`',
    `tender_acceptance_percent` DECIMAL(18,2) COMMENT 'Percentage of shipment tenders accepted by the carrier without rejection or re-tender during the scorecard period. Low acceptance rates indicate capacity reliability issues.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `total_freight_spend` DECIMAL(18,2) COMMENT 'Total freight cost paid to the carrier for all shipments on the evaluated service lane during the scorecard period, in the reporting currency. Used for spend analytics and carrier rationalization decisions.',
    `total_shipments` STRING COMMENT 'Total number of shipments tendered to the carrier on the evaluated service lane during the scorecard period. Serves as the denominator for all rate-based KPI calculations.. Valid values are `^[0-9]+$`',
    `transit_time_compliance_percent` DECIMAL(18,2) COMMENT 'Percentage of shipments where actual transit time met or was within the contracted transit time threshold during the scorecard period. Measures carrier adherence to committed lead times.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `transport_mode` STRING COMMENT 'Mode of transportation used by the carrier on the evaluated service lane (e.g., road, rail, ocean, air, intermodal).. Valid values are `road|rail|ocean|air|intermodal|courier|parcel`',
    CONSTRAINT pk_carrier_performance PRIMARY KEY(`carrier_performance_id`)
) COMMENT 'Periodic carrier performance scorecard capturing OTIF (On-Time In-Full) rate, transit time compliance, damage claim rate, invoice accuracy rate, EDI compliance rate, and sustainability metrics (CO2 per tonne-km) for each carrier and service lane. Supports carrier qualification reviews, SLA enforcement, and strategic carrier rationalization decisions.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` (
    `delivery_performance_id` BIGINT COMMENT 'Unique surrogate identifier for each delivery performance record in the Silver Layer lakehouse. Serves as the primary key for this entity.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier. Business justification: Delivery performance is tracked by carrier. delivery_performance.carrier_name and carrier_scac_code are denormalized references to the carrier master. Adding carrier_id FK enforces referential integri',
    `delivery_id` BIGINT COMMENT 'Foreign key linking to logistics.delivery. Business justification: Delivery performance records are linked to specific delivery documents. delivery_performance.delivery_document_number is a denormalized string reference. Adding delivery_id FK normalizes this relation',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Delivery performance tracks sales order fulfillment - normalize by replacing sales_order_number text with FK',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Delivery performance records measure OTIF compliance at the shipment level. delivery_performance.shipment_number is a denormalized string reference. Adding shipment_id FK enforces referential integrit',
    `actual_delivery_date` DATE COMMENT 'The date on which the shipment was physically delivered and confirmed at the customers ship-to location. Sourced from proof of delivery (POD) confirmation or carrier tracking event.. Valid values are `^d{4}-d{2}-d{2}$`',
    `actual_delivery_timestamp` TIMESTAMP COMMENT 'Precise timestamp of delivery confirmation including time and timezone offset. Used for time-window SLA compliance analysis and carrier performance measurement.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `capa_reference` STRING COMMENT 'Reference identifier for the CAPA (Corrective and Preventive Action) record raised in the QMS in response to this OTIF failure. Supports quality management traceability and ISO 9001 compliance.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the delivery performance record was first created in the Silver Layer. Used for data lineage, audit trail, and SLA reporting cycle management.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `customer_impact_severity` STRING COMMENT 'Assessed severity of the delivery failures impact on the customers operations. Drives escalation priority in Salesforce Service Cloud and determines whether a formal CAPA or NCR must be raised. Levels: critical (production line stoppage), high (significant disruption), medium (moderate impact), low (minor inconvenience), none (no impact).. Valid values are `critical|high|medium|low|none`',
    `customer_name` STRING COMMENT 'Legal name of the customer account receiving the delivery. Included for reporting and escalation context. Classified as confidential as it represents business-sensitive commercial relationship data.',
    `customer_number` STRING COMMENT 'The unique customer account number from SAP S/4HANA (sold-to party). Used to aggregate OTIF performance at the customer level for SLA reporting and Salesforce CRM escalation workflows.',
    `days_early_late` STRING COMMENT 'Signed integer representing the variance in calendar days between actual delivery date and promised delivery date. Negative values indicate early delivery; positive values indicate late delivery. Zero indicates on-time delivery. Core metric for OTIF trend analysis.',
    `delivered_quantity` DECIMAL(18,2) COMMENT 'The actual quantity of the material delivered and confirmed at the customers location. Used as the numerator for in-full compliance calculation.',
    `destination_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the delivery destination. Supports cross-border OTIF analysis, customs compliance tracking, and regional performance benchmarking.. Valid values are `^[A-Z]{3}$`',
    `escalation_case_number` STRING COMMENT 'Salesforce Service Cloud case number created for customer escalation resulting from this OTIF failure. Links delivery performance records to customer service workflows for resolution tracking.',
    `fill_rate_pct` DECIMAL(18,2) COMMENT 'The percentage of ordered quantity that was actually delivered (delivered_quantity / ordered_quantity * 100). Stored as a raw business metric from the source system to support in-full compliance determination without requiring recalculation.. Valid values are `^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$`',
    `in_full_threshold_pct` DECIMAL(18,2) COMMENT 'The minimum fill rate percentage required to classify a delivery as in-full per the customer SLA agreement. Typically 100% but may vary by customer contract (e.g., 95% for bulk materials).. Valid values are `^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the point of risk transfer and delivery responsibility between seller and buyer. Determines which party is accountable for OTIF compliance at each delivery milestone.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `is_in_full` BOOLEAN COMMENT 'Boolean flag indicating whether the full ordered quantity was delivered. True = in-full; False = short shipment. Evaluated against the in-full threshold defined in the customer SLA agreement. Core component of the OTIF KPI.. Valid values are `true|false`',
    `is_on_time` BOOLEAN COMMENT 'Boolean flag indicating whether the shipment was delivered on or before the promised delivery date. True = on-time; False = late. Core component of the OTIF (On-Time In-Full) KPI.. Valid values are `true|false`',
    `is_otif` BOOLEAN COMMENT 'Composite boolean flag indicating whether the delivery was both on-time AND in-full. True = OTIF compliant; False = OTIF failure. Primary KPI for SLA reporting, customer service escalation, and supply chain performance dashboards.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the delivery performance record. Supports incremental data processing in the Databricks Lakehouse Silver Layer and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `material_number` STRING COMMENT 'SAP material master number for the product being delivered. Enables product-level OTIF analysis and identification of materials with chronic delivery failures.',
    `measurement_period` STRING COMMENT 'The reporting period (YYYY-MM) in which this delivery performance record is counted for SLA and OTIF KPI reporting. Enables monthly and quarterly performance aggregation without recalculation.. Valid values are `^d{4}-(0[1-9]|1[0-2])$`',
    `on_time_tolerance_days` STRING COMMENT 'The number of calendar days of early or late delivery that is still considered on-time per the customer SLA agreement. Enables flexible OTIF calculation for customers with grace period provisions.',
    `ordered_quantity` DECIMAL(18,2) COMMENT 'The total quantity of the material ordered by the customer on the sales order line. Used as the denominator for in-full compliance calculation.',
    `otif_failure_reason_category` STRING COMMENT 'Categorized root cause for OTIF non-compliance. Used for structured root cause analysis (RCA), CAPA initiation, and trend reporting to identify systemic delivery failure drivers. Aligned with CAPA process in QMS.. Valid values are `carrier_delay|customs_hold|production_delay|weather|warehouse_delay|supplier_delay|demand_spike|system_error|other`',
    `otif_failure_reason_detail` STRING COMMENT 'Free-text narrative providing additional detail on the root cause of OTIF failure beyond the category. Supports escalation workflows and customer communication in Salesforce Service Cloud.',
    `plant_code` STRING COMMENT 'SAP plant code representing the manufacturing or distribution facility from which the delivery originated. Used to identify plant-level delivery performance trends.',
    `promised_delivery_date` DATE COMMENT 'The customer-committed delivery date as confirmed on the sales order. This is the contractual baseline against which on-time delivery compliance is measured for OTIF and SLA reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `proof_of_delivery_reference` STRING COMMENT 'Reference number or document identifier for the proof of delivery (POD) confirming physical receipt at the customers location. Required for OTIF confirmation and dispute resolution.',
    `quantity_unit_of_measure` STRING COMMENT 'The unit of measure for ordered and delivered quantities (e.g., EA, KG, M, PC, PAL). Ensures consistent quantity comparison for in-full compliance determination.',
    `record_number` STRING COMMENT 'Business-facing unique identifier for the delivery performance record, used in SLA reporting, customer service escalations, and cross-system referencing. Typically sourced from SAP S/4HANA SD module.. Valid values are `^DP-[0-9]{4}-[0-9]{8}$`',
    `requested_delivery_date` DATE COMMENT 'The original delivery date requested by the customer at order placement, before any ATP/CTP confirmation. Enables analysis of the gap between customer expectations and committed dates.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sales_order_line_number` STRING COMMENT 'The specific line item number within the sales order being measured for delivery performance. Enables line-level OTIF analysis.',
    `ship_to_location_code` STRING COMMENT 'The SAP ship-to party location code identifying the physical delivery destination. Used for geographic OTIF analysis and regional SLA compliance reporting.',
    `sla_agreement_reference` STRING COMMENT 'Reference identifier for the customer SLA agreement governing this deliverys performance commitments. Links the performance record to the contractual obligations being measured.',
    `status` STRING COMMENT 'Current processing status of the delivery performance record. Pending = awaiting POD confirmation; Confirmed = POD received and OTIF determined; Disputed = customer has raised a dispute on the OTIF outcome; Closed = dispute resolved or record finalized; Cancelled = order cancelled before delivery.. Valid values are `pending|confirmed|disputed|closed|cancelled`',
    `transport_mode` STRING COMMENT 'The mode of transportation used for the delivery. Enables OTIF performance analysis segmented by transport mode to identify mode-specific delivery challenges.. Valid values are `road|rail|air|ocean|intermodal|courier|parcel`',
    CONSTRAINT pk_delivery_performance PRIMARY KEY(`delivery_performance_id`)
) COMMENT 'Order-level and shipment-level delivery performance record measuring OTIF compliance against customer-committed delivery dates. Captures promised delivery date, actual delivery date, on-time flag, in-full flag, OTIF flag, root cause category for failures (carrier delay, customs hold, production delay, weather), and customer impact severity. Feeds SLA reporting and customer service escalation workflows.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`freight_claim` (
    `freight_claim_id` BIGINT COMMENT 'Unique system-generated identifier for the freight claim record in the lakehouse silver layer.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Freight claims must identify the customer account filing the claim for damaged/lost goods. Claims departments use this for customer communication, resolution tracking, and credit processing.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier. Business justification: Freight claims are filed against specific carriers. freight_claim.carrier_name and carrier_scac_code are denormalized references to the carrier master. Adding carrier_id FK enforces referential integr',
    `compliance_audit_finding_id` BIGINT COMMENT 'Foreign key linking to compliance.audit_finding. Business justification: Freight claims identified during compliance audits (overcharges, contract violations) link to audit findings. Finance and logistics teams track these to recover costs and address carrier compliance is',
    `credit_note_id` BIGINT COMMENT 'Foreign key linking to billing.credit_note. Business justification: Freight claims for damaged/lost goods result in credit notes. When carriers accept liability, billing issues credit notes that logistics references for claim resolution tracking.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: When equipment is damaged during transport, freight claims reference the specific asset for valuation, insurance processing, and asset condition tracking in the asset management system.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Freight claims are filed by specific employees in logistics or quality departments. Manufacturing tracks who initiated claims for process improvement and accountability.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Freight claims for damaged goods or overcharges post recoveries to specific GL accounts. Finance tracks claim recoveries as contra-expense or other income.',
    `request_id` BIGINT COMMENT 'Foreign key linking to service.service_request. Business justification: Damaged shipments of industrial equipment trigger service requests for repair or replacement. Logistics and service teams collaborate on freight claims requiring field technician assessment and remedi',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Freight claims are filed for specific shipments where loss, damage, or delay occurred. freight_claim.shipment_number is a denormalized string reference. Adding shipment_id FK enforces referential inte',
    `spare_part_id` BIGINT COMMENT 'Foreign key linking to asset.spare_part. Business justification: Damaged or lost spare parts in transit generate freight claims. Claims reference the specific part for cost recovery, inventory adjustment, and replacement procurement.',
    `bill_of_lading_number` STRING COMMENT 'Bill of lading number associated with the shipment involved in the claim. The BOL is the primary legal document establishing carrier liability and is required for claim filing.',
    `carrier_acknowledgment_date` DATE COMMENT 'Date on which the carrier formally acknowledged receipt of the freight claim filing. Regulatory requirement under 49 CFR Part 370 mandates acknowledgment within 30 days.. Valid values are `^d{4}-d{2}-d{2}$`',
    `carrier_decision_due_date` DATE COMMENT 'Regulatory deadline by which the carrier must pay, deny, or make a settlement offer on the freight claim. Under 49 CFR Part 370, carriers must resolve claims within 120 days of receipt.. Valid values are `^d{4}-d{2}-d{2}$`',
    `claim_number` STRING COMMENT 'Business-facing unique reference number assigned to the freight claim at the time of filing, used for tracking and correspondence with carriers and insurers.. Valid values are `^FC-[0-9]{4}-[0-9]{6}$`',
    `claim_type` STRING COMMENT 'Classification of the freight claim based on the nature of the incident: loss (cargo not delivered), damage (cargo physically damaged), shortage (partial delivery), delay (late delivery), overcharge (billing discrepancy), or other types.. Valid values are `loss|damage|shortage|delay|concealed_damage|overcharge|refused_shipment|contamination`',
    `claimant_reference` STRING COMMENT 'Internal reference number or cost center code used by the claimant organization to track the freight claim for internal accounting and cost recovery purposes.',
    `claimed_amount` DECIMAL(18,2) COMMENT 'Total monetary amount claimed against the carrier for the loss, damage, shortage, or delay, including the value of goods, freight charges, and consequential costs where applicable.',
    `claimed_amount_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the claimed amount (e.g., USD, EUR, GBP), supporting multi-currency operations across global distribution networks.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the freight claim record was first created in the system, used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `damaged_item_description` STRING COMMENT 'Detailed description of the freight items that were lost, damaged, or short-shipped, including product names, part numbers, and nature of damage.',
    `damaged_quantity` DECIMAL(18,2) COMMENT 'Quantity of items that were lost, damaged, or short-shipped as stated in the freight claim.',
    `declared_value` DECIMAL(18,2) COMMENT 'Value of the shipment as declared on the bill of lading, which establishes the maximum carrier liability limit for the claim.',
    `declared_value_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the declared shipment value.. Valid values are `^[A-Z]{3}$`',
    `denial_reason` STRING COMMENT 'Reason provided by the carrier for denying the freight claim. Carrier liability defenses under Carmack Amendment include act of God, shipper fault, inherent vice, public authority, and act of public enemy.. Valid values are `act_of_god|shipper_fault|improper_packaging|inherent_vice|public_authority|carrier_not_liable|insufficient_documentation|statute_of_limitations|other`',
    `destination_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the shipment destination, used for jurisdictional determination and customs/trade compliance context.. Valid values are `^[A-Z]{3}$`',
    `discovery_date` DATE COMMENT 'Date on which the damage, loss, or shortage was first discovered, which may differ from the incident date (e.g., concealed damage found upon unpacking after delivery).. Valid values are `^d{4}-d{2}-d{2}$`',
    `dispute_status` STRING COMMENT 'Current status of any dispute raised against the carriers settlement offer or denial, tracking escalation through negotiation, arbitration, or litigation.. Valid values are `not_disputed|in_dispute|escalated_to_legal|arbitration|litigation|resolved`',
    `filed_date` DATE COMMENT 'Calendar date on which the freight claim was formally filed against the carrier. Critical for statutory filing deadline compliance (typically 9 months for loss/damage under Carmack Amendment).. Valid values are `^d{4}-d{2}-d{2}$`',
    `filing_deadline_date` DATE COMMENT 'Statutory or contractual deadline by which the freight claim must be filed to preserve legal rights against the carrier. Typically 9 months from delivery under Carmack Amendment for domestic US shipments.. Valid values are `^d{4}-d{2}-d{2}$`',
    `final_settlement_amount` DECIMAL(18,2) COMMENT 'Agreed final monetary amount paid by the carrier to resolve the freight claim. Populated upon claim closure; used for carrier liability recovery reporting and insurance reconciliation.',
    `final_settlement_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the final settlement amount, supporting multi-currency financial reconciliation.. Valid values are `^[A-Z]{3}$`',
    `incident_date` DATE COMMENT 'Date on which the loss, damage, shortage, or delay event occurred or was discovered during transit or at delivery.. Valid values are `^d{4}-d{2}-d{2}$`',
    `inspection_date` DATE COMMENT 'Date on which the carrier or its appointed inspector conducted the physical inspection of the damaged freight.. Valid values are `^d{4}-d{2}-d{2}$`',
    `inspection_required` BOOLEAN COMMENT 'Indicates whether the carrier has requested a physical inspection of the damaged freight as part of the claim investigation process.. Valid values are `true|false`',
    `insurance_claim_number` STRING COMMENT 'Reference number of the corresponding cargo insurance claim filed with the insurer, if the freight claim is also covered under a cargo insurance policy.',
    `insurance_recovery_amount` DECIMAL(18,2) COMMENT 'Amount recovered from the cargo insurer for the loss or damage, separate from the carrier settlement. Used for net loss calculation and insurance reporting.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the freight claim record, supporting audit trail requirements and change tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `material_number` STRING COMMENT 'SAP material number identifying the specific product or component involved in the freight claim, enabling linkage to inventory and product master data.',
    `notes` STRING COMMENT 'Free-text field for additional notes, correspondence summaries, or contextual information relevant to the freight claim that does not fit structured fields.',
    `origin_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the shipment origin location, used for jurisdictional determination of applicable freight claim regulations.. Valid values are `^[A-Z]{3}$`',
    `pro_number` STRING COMMENT 'Carrier-assigned Progressive (PRO) number used to track the freight shipment within the carriers system. Required for claim identification and carrier correspondence.',
    `quantity_unit_of_measure` STRING COMMENT 'Unit of measure for the damaged or lost quantity (e.g., EA for each, KG for kilograms, PLT for pallets).. Valid values are `EA|KG|LB|MT|PC|BOX|PLT|CTN|L|M|M2|M3`',
    `settlement_date` DATE COMMENT 'Date on which the final settlement payment was received or the claim was formally resolved and closed.. Valid values are `^d{4}-d{2}-d{2}$`',
    `settlement_offer_amount` DECIMAL(18,2) COMMENT 'Monetary amount offered by the carrier as settlement for the freight claim. May be less than the claimed amount, triggering dispute or negotiation.',
    `settlement_offer_date` DATE COMMENT 'Date on which the carrier formally presented the settlement offer to the claimant.. Valid values are `^d{4}-d{2}-d{2}$`',
    `status` STRING COMMENT 'Current lifecycle status of the freight claim, tracking progression from initial filing through resolution or denial.. Valid values are `draft|filed|acknowledged|under_review|settlement_offered|disputed|settled|closed|withdrawn|denied`',
    `supporting_documents_flag` BOOLEAN COMMENT 'Indicates whether all required supporting documentation (e.g., BOL, delivery receipt, inspection report, photos, invoices) has been attached to the freight claim filing.. Valid values are `true|false`',
    `transport_mode` STRING COMMENT 'Mode of transportation used for the shipment involved in the claim, which determines applicable liability limits and regulatory framework.. Valid values are `road|rail|ocean|air|intermodal|courier`',
    CONSTRAINT pk_freight_claim PRIMARY KEY(`freight_claim_id`)
) COMMENT 'Formal claim filed against a carrier for loss, damage, shortage, or delay of freight in transit. Records claim type, claim date, shipment reference, damaged item details, claimed amount, carrier acknowledgment date, settlement offer, dispute status, and final settlement amount. Supports freight claims management, carrier liability recovery, and insurance reporting.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`transport_zone` (
    `transport_zone_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for each transport zone record in the lakehouse silver layer.',
    `applicable_surcharge_types` STRING COMMENT 'Comma-separated list of freight surcharge types applicable within this zone (e.g., fuel_surcharge, remote_area_surcharge, peak_season_surcharge, customs_clearance_fee, toll_surcharge). Used in TMS freight cost calculation and carrier invoice validation.',
    `co2_emission_factor_kg_per_km` DECIMAL(18,2) COMMENT 'Carbon dioxide emission factor in kilograms per kilometer applicable to freight movements within this zone. Used in freight carbon footprint calculations, sustainability reporting, and green logistics optimization in TMS route planning.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `continent_code` STRING COMMENT 'Two-letter continent code indicating the primary continental region covered by this transport zone, used for high-level freight network segmentation and global logistics reporting.. Valid values are `AF|AN|AS|EU|NA|OC|SA`',
    `country_codes_covered` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes covered by this transport zone. Supports multi-country zone definitions used in international freight pricing and customs territory mapping.. Valid values are `^([A-Z]{3})(,[A-Z]{3})*$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this transport zone record was first created in the system of record. Used for audit trail, data lineage, and master data governance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code used for freight rate quotation and billing within this transport zone. Ensures consistent multi-currency freight cost management across global distribution networks.. Valid values are `^[A-Z]{3}$`',
    `customs_territory_code` STRING COMMENT 'Code identifying the customs territory or customs union associated with this zone (e.g., EU Customs Union, USMCA territory, ASEAN FTA zone). Drives customs declaration requirements, duty rate applicability, and trade compliance checks in TMS.',
    `data_source_system` STRING COMMENT 'Identifies the operational system of record from which this transport zone record was sourced (e.g., SAP S/4HANA SD, TMS, manual entry). Supports data lineage tracking and master data reconciliation in the lakehouse.. Valid values are `SAP_S4HANA|TMS|MANUAL|ARIBA|OTHER`',
    `description` STRING COMMENT 'Extended narrative description of the transport zone, including geographic scope, coverage rationale, and any special operational notes relevant to freight planning.',
    `effective_date` DATE COMMENT 'The date from which this transport zone definition becomes active and valid for use in TMS rate determination, route planning, and trade compliance checks. Supports temporal validity management of zone master data.. Valid values are `^d{4}-d{2}-d{2}$`',
    `erp_zone_code` STRING COMMENT 'The transport zone code as configured in the ERP system (SAP S/4HANA SD module, table TVKBZ). Used for cross-system reconciliation between TMS freight rate determination and ERP sales order/delivery processing.',
    `expiry_date` DATE COMMENT 'The date after which this transport zone definition is no longer valid for operational use. Expired zones are retained for historical audit and freight cost reconciliation purposes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `freight_rate_basis` STRING COMMENT 'The pricing basis used for freight rate determination within this zone. Defines how carrier charges are calculated — by weight, volumetric weight, distance, flat rate per shipment, per unit, or zone-to-zone matrix pricing.. Valid values are `weight|volume|distance|flat_rate|per_unit|revenue_based|zone_to_zone`',
    `geographic_scope` STRING COMMENT 'Defines the geographic granularity of the transport zone — whether it spans a global network, a continent, one or more countries, a sub-national region, a state/province, a postal code band, or a custom-defined area.. Valid values are `global|continental|country|multi_country|regional|state_province|postal_zone|city|custom`',
    `incoterms_applicability` STRING COMMENT 'Comma-separated list of Incoterms 2020 rules (e.g., DAP, DDP, FCA, EXW) that are applicable or commonly used for shipments within or to/from this transport zone, supporting freight cost allocation and risk transfer point determination.',
    `is_cross_border` BOOLEAN COMMENT 'Indicates whether freight movements within or through this zone involve crossing international borders, triggering customs declaration requirements, export/import documentation, and trade compliance checks.. Valid values are `true|false`',
    `is_free_trade_zone` BOOLEAN COMMENT 'Indicates whether this transport zone encompasses or overlaps with a designated Free Trade Zone (FTZ) or Special Economic Zone (SEZ), which may affect duty suspension, bonded warehouse eligibility, and customs documentation requirements.. Valid values are `true|false`',
    `is_hazmat_permitted` BOOLEAN COMMENT 'Indicates whether the transport of hazardous materials (HAZMAT) is permitted within this zone. Drives TMS routing restrictions and carrier selection filters for shipments containing dangerous goods.. Valid values are `true|false`',
    `is_temperature_controlled` BOOLEAN COMMENT 'Indicates whether this zone requires or supports temperature-controlled freight services (cold chain logistics). Used to filter carrier services and apply cold chain surcharges in TMS rate determination.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent update to this transport zone record. Used for change tracking, incremental data pipeline processing, and master data governance audit trails.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_reviewed_date` DATE COMMENT 'The date on which this transport zone definition was last reviewed and validated by the logistics master data team. Supports periodic zone review cycles required for freight rate accuracy and regulatory compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `max_transit_days` STRING COMMENT 'The maximum allowable transit days for freight movements within this zone before a shipment is considered delayed. Used in exception management, SLA breach alerting, and carrier performance monitoring.. Valid values are `^[0-9]+$`',
    `name` STRING COMMENT 'Human-readable descriptive name of the transport zone, used in TMS user interfaces, freight rate cards, and logistics reporting.',
    `owning_logistics_org` STRING COMMENT 'The internal logistics organization or business unit responsible for maintaining and governing this transport zone definition (e.g., Global Freight Management, EMEA Logistics, North America Distribution). Used for master data ownership and change governance.',
    `postal_code_range_end` STRING COMMENT 'Ending postal/ZIP code of the range defining this transport zones geographic boundary. Together with postal_code_range_start, defines the complete postal band for zone-based freight rate lookup.',
    `postal_code_range_start` STRING COMMENT 'Starting postal/ZIP code of the range defining this transport zones geographic boundary when zone granularity is at postal code level. Used in last-mile freight pricing and carrier service area definitions.',
    `primary_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 code of the primary country associated with this transport zone. For multi-country zones, this represents the anchor or dominant country for rate determination and regulatory regime assignment.. Valid values are `^[A-Z]{3}$`',
    `region_code` STRING COMMENT 'Internal logistics region code (e.g., EMEA, APAC, AMER, LATAM, MEA) used to group transport zones into macro-regions for freight budget allocation, carrier contract management, and executive reporting.',
    `regulatory_regime` STRING COMMENT 'The applicable trade or customs regulatory framework governing freight movements within or through this zone. Determines duty rates, documentation requirements, and trade compliance obligations for shipments crossing zone boundaries.. Valid values are `eu_customs_union|usmca|asean_fta|mercosur|gcc|sadc|cptpp|bilateral|national|other`',
    `service_level_options` STRING COMMENT 'Comma-separated list of freight service levels available within this zone (e.g., standard, express, overnight, economy, same_day). Used in TMS service level selection and SLA-driven route planning.',
    `standard_transit_days` STRING COMMENT 'The standard number of transit days expected for freight movements within or to/from this zone under normal service conditions. Used as a baseline for delivery date calculation and on-time delivery performance measurement.. Valid values are `^[0-9]+$`',
    `state_province_codes` STRING COMMENT 'Comma-separated list of ISO 3166-2 state or province codes covered by this zone when geographic scope is at sub-national level. Used for domestic freight pricing zones and state-level tax jurisdiction mapping.',
    `status` STRING COMMENT 'Current lifecycle status of the transport zone record. Active zones are used in live TMS rate determination and route planning. Inactive or deprecated zones are retained for historical reference and audit purposes.. Valid values are `active|inactive|draft|under_review|deprecated`',
    `tms_zone_code` STRING COMMENT 'The native zone identifier as stored in the Transportation Management System (e.g., SAP TM or third-party TMS). Used for system integration, data reconciliation, and traceability between the lakehouse silver layer and the operational TMS.',
    `transport_modes_supported` STRING COMMENT 'Comma-separated list of transport modes available within this zone (e.g., road, rail, air, ocean, intermodal, courier). Used in TMS route optimization and carrier service matching to filter applicable zones by mode.',
    `zone_category` STRING COMMENT 'Indicates whether the zone is used as an origin zone, destination zone, bidirectional origin-destination zone, transit/intermediate zone, or hub zone in freight rate and route planning.. Valid values are `origin|destination|origin_destination|transit|hub`',
    `zone_code` STRING COMMENT 'Business-facing alphanumeric code uniquely identifying the transport zone, used in TMS rate tables, route planning, and carrier service assignments. Corresponds to the zone key in SAP S/4HANA SD transportation zone configuration.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `zone_type` STRING COMMENT 'Classification of the zones primary business purpose. Freight pricing zones drive TMS rate determination; customs territory zones support trade compliance checks; sales territory zones align with commercial coverage; carrier service area zones define carrier network reach; tax jurisdiction zones support VAT/duty calculations.. Valid values are `freight_pricing|customs_territory|sales_territory|carrier_service_area|tax_jurisdiction|regulatory_compliance|incoterms_zone`',
    CONSTRAINT pk_transport_zone PRIMARY KEY(`transport_zone_id`)
) COMMENT 'Geographic zone master used to define freight pricing regions, carrier service coverage areas, and customs territory boundaries. Stores zone code, zone name, zone type (freight pricing, customs, sales territory), country/region coverage, and applicable regulatory regime. Used in TMS rate determination, route planning, and trade compliance zone checks.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`location` (
    `location_id` BIGINT COMMENT 'Unique surrogate identifier for each logistics network location record in the silver layer master data.',
    `ot_system_id` BIGINT COMMENT 'Foreign key linking to technology.ot_system. Business justification: Logistics locations (warehouses, cross-docks) have dedicated WMS/WCS operational technology systems. IT and operations need this link for system maintenance, integration mapping, and incident manageme',
    `transport_zone_id` BIGINT COMMENT 'Foreign key linking to logistics.transport_zone. Business justification: Logistics locations belong to transport zones used for freight pricing and carrier coverage. Adding transport_zone_id FK links each location to its governing transport zone, enabling zone-based rate l',
    `address_line_1` STRING COMMENT 'Primary street address of the logistics location, including street number and street name. Used for carrier pickup/delivery instructions and customs documentation.',
    `address_line_2` STRING COMMENT 'Secondary address detail such as suite, building, floor, or unit number for the logistics location.',
    `city` STRING COMMENT 'City or municipality in which the logistics location is situated. Used in route planning, carrier zone determination, and regulatory reporting.',
    `code` STRING COMMENT 'Business-assigned alphanumeric code uniquely identifying the logistics location across all operational systems (SAP S/4HANA, Infor WMS, TMS). Used as the cross-system reference key for origin_location_code and destination_location_code in shipment and route records.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code for the country in which the logistics location is physically situated. Drives customs, trade compliance, and incoterms applicability.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the logistics location master record was first created in the system. Supports data lineage, audit trail requirements, and master data governance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customs_bond_expiry_date` DATE COMMENT 'Expiration date of the customs bond or bonded warehouse license. Triggers renewal workflows to ensure uninterrupted bonded storage operations and trade compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `customs_bond_number` STRING COMMENT 'Official customs bond or warehouse license number issued by the relevant customs authority for bonded warehouse locations. Required for customs compliance documentation and audit trails.',
    `dock_count` STRING COMMENT 'Total number of loading/unloading dock doors available at the logistics location. Used in capacity planning, appointment slot management, and freight order scheduling within TMS and WMS.. Valid values are `^[0-9]+$`',
    `effective_date` DATE COMMENT 'Date from which this logistics location record is valid and active in the logistics network. Supports temporal validity management for network planning and historical analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date after which this logistics location record is no longer valid or active in the logistics network. Used to manage temporary locations, lease expirations, and network restructuring events.. Valid values are `^d{4}-d{2}-d{2}$`',
    `ftz_zone_number` STRING COMMENT 'Official FTZ or SEZ designation number assigned by the relevant trade authority for locations within a free trade zone. Used in customs and export control documentation.',
    `iata_airport_code` STRING COMMENT 'Three-letter IATA airport code for logistics locations that are air freight terminals or co-located with airports. Used in air freight routing, carrier service selection, and customs documentation.. Valid values are `^[A-Z]{3}$`',
    `inbound_dock_count` STRING COMMENT 'Number of dock doors designated exclusively for inbound freight receiving operations. Supports inbound appointment scheduling and GRN (Goods Receipt Note) throughput planning.. Valid values are `^[0-9]+$`',
    `is_customs_bonded` BOOLEAN COMMENT 'Indicates whether the logistics location is a licensed customs bonded warehouse authorized to store imported goods before customs duties are paid. Critical for trade compliance routing and customs declaration management.. Valid values are `true|false`',
    `is_free_trade_zone` BOOLEAN COMMENT 'Indicates whether the logistics location is situated within a designated Free Trade Zone (FTZ) or Special Economic Zone (SEZ). Affects duty deferral, tariff treatment, and export control compliance.. Valid values are `true|false`',
    `is_hazmat_certified` BOOLEAN COMMENT 'Indicates whether the logistics location is certified and equipped to handle, store, or process hazardous materials (HAZMAT) in compliance with applicable regulations. Drives routing logic for hazmat shipments.. Valid values are `true|false`',
    `is_temperature_controlled` BOOLEAN COMMENT 'Indicates whether the logistics location has temperature-controlled storage or handling capabilities (cold chain, frozen, or climate-controlled). Required for routing temperature-sensitive products.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the logistics location master record. Used for change tracking, data synchronization across TMS/WMS systems, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate (WGS 84 decimal degrees) of the logistics location. Used for geofencing in shipment tracking, distance calculations, and IIoT asset monitoring via Siemens MindSphere.. Valid values are `^-?(90(.0+)?|[1-8]?d(.d+)?)$`',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate (WGS 84 decimal degrees) of the logistics location. Used in conjunction with latitude for geofencing, route optimization, and real-time tracking event correlation.. Valid values are `^-?(180(.0+)?|1[0-7]d(.d+)?|[1-9]?d(.d+)?)$`',
    `max_weight_capacity_kg` DECIMAL(18,2) COMMENT 'Maximum total weight in kilograms that the logistics location can handle or store at any given time. Used in freight order feasibility checks and load planning.. Valid values are `^[0-9]+(.[0-9]+)?$`',
    `name` STRING COMMENT 'Full descriptive name of the logistics location (e.g., Chicago Distribution Center, Hamburg Port of Entry). Used in reporting, carrier communications, and shipment documentation.',
    `operating_days` STRING COMMENT 'Comma-separated list of days of the week the location is operational (e.g., MON,TUE,WED,THU,FRI). Used by TMS to validate delivery windows and avoid scheduling shipments on non-operating days.',
    `operating_hours_end` STRING COMMENT 'Standard daily closing time of the logistics location in HH:MM (24-hour) format, expressed in the locations local timezone. Defines the latest permissible arrival or departure time for freight operations.. Valid values are `^([01]d|2[0-3]):[0-5]d$`',
    `operating_hours_start` STRING COMMENT 'Standard daily opening time of the logistics location in HH:MM (24-hour) format, expressed in the locations local timezone. Used for appointment scheduling, carrier pickup windows, and TMS cutoff enforcement.. Valid values are `^([01]d|2[0-3]):[0-5]d$`',
    `outbound_dock_count` STRING COMMENT 'Number of dock doors designated exclusively for outbound freight dispatch operations. Supports outbound shipment scheduling and carrier pickup coordination.. Valid values are `^[0-9]+$`',
    `plant_code` STRING COMMENT 'SAP S/4HANA plant code associated with this logistics location when the location corresponds to a manufacturing plant or distribution center managed in SAP. Enables cross-reference between logistics network master data and SAP MM/PP/WM modules.. Valid values are `^[A-Z0-9]{1,10}$`',
    `postal_code` STRING COMMENT 'ZIP or postal code of the logistics location. Used by TMS for freight zone calculation, carrier rate lookup, and last-mile routing.',
    `region_code` STRING COMMENT 'Internal logistics region or zone code (e.g., EMEA, APAC, AMER, LATAM) assigned to the location for freight planning, carrier contract scoping, and transport plan organization.',
    `state_province` STRING COMMENT 'State, province, or administrative region of the logistics location. Required for domestic freight zone mapping and tax/regulatory jurisdiction determination.',
    `status` STRING COMMENT 'Current operational status of the logistics location. Inactive or decommissioned locations are excluded from TMS route optimization and carrier assignment.. Valid values are `active|inactive|under_construction|temporarily_closed|decommissioned`',
    `storage_capacity_m3` DECIMAL(18,2) COMMENT 'Total volumetric storage capacity of the logistics location in cubic meters. Used for inventory planning, warehouse utilization reporting, and network capacity optimization.. Valid values are `^[0-9]+(.[0-9]+)?$`',
    `temp_max_c` DECIMAL(18,2) COMMENT 'Maximum temperature in degrees Celsius that the locations temperature-controlled storage can maintain. Used alongside temp_min_c to validate cold chain compatibility for inbound and outbound shipments.. Valid values are `^-?[0-9]+(.[0-9]+)?$`',
    `temp_min_c` DECIMAL(18,2) COMMENT 'Minimum temperature in degrees Celsius that the locations temperature-controlled storage can maintain. Used to validate suitability for cold chain shipments with specific temperature requirements.. Valid values are `^-?[0-9]+(.[0-9]+)?$`',
    `timezone` STRING COMMENT 'IANA timezone identifier for the logistics location (e.g., America/Chicago, Europe/Berlin). Used to correctly interpret operating hours, appointment windows, and shipment cutoff times in TMS scheduling.',
    `type` STRING COMMENT 'Classification of the logistics node by its functional role in the supply chain network. Drives routing logic, dock assignment, customs handling, and TMS optimization rules.. Valid values are `manufacturing_plant|distribution_center|cross_dock|customer_delivery_point|supplier_pickup_point|port_of_entry|customs_bonded_warehouse|freight_terminal|consolidation_hub|last_mile_depot`',
    `un_locode` STRING COMMENT 'UN/LOCODE (United Nations Code for Trade and Transport Locations) for the logistics location. Internationally recognized code used in customs declarations, bills of lading, and cross-border trade documentation.. Valid values are `^[A-Z]{2}[A-Z0-9]{3}$`',
    `warehouse_number` STRING COMMENT 'SAP S/4HANA or Infor WMS warehouse number assigned to this logistics location for warehouse management operations. Links the logistics network node to its WMS configuration for inventory and dock management.',
    CONSTRAINT pk_location PRIMARY KEY(`location_id`)
) COMMENT 'Master record for all physical locations participating in the logistics network, including manufacturing plants, distribution centers, cross-dock facilities, customer delivery points, supplier pickup points, ports of entry, and customs bonded warehouses. Stores location code, location type, address, GPS coordinates, operating hours, dock capacity, and customs bonded status. SSOT for logistics network node identity.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` (
    `dangerous_goods_declaration_id` BIGINT COMMENT 'Unique system-generated identifier for the dangerous goods declaration record in the lakehouse silver layer.',
    `certificate_id` BIGINT COMMENT 'Foreign key linking to quality.quality_certificate. Business justification: Dangerous goods shipments require quality certificates (SDS, material composition certs) for regulatory compliance. Logistics teams attach quality certificates to DG declarations for customs and carri',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Dangerous goods require handling by certified employees. Manufacturing safety regulations mandate tracking which certified employee prepared and approved hazmat declarations.',
    `chemical_substance_id` BIGINT COMMENT 'Foreign key linking to hse.chemical_substance. Business justification: Dangerous goods declarations must identify specific chemical substances being transported for regulatory compliance (DOT, IATA, ADR). Required for proper classification, labeling, and emergency respon',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: Service contracts for industrial systems may include hazardous materials (batteries, chemicals, refrigerants) requiring dangerous goods compliance for spare parts shipments and equipment returns throu',
    `freight_order_id` BIGINT COMMENT 'Foreign key linking to logistics.freight_order. Business justification: Dangerous goods declarations are associated with the freight order executing the hazmat shipment. dangerous_goods_declaration.freight_order_number is a denormalized string reference. Adding freight_or',
    `hazardous_substance_id` BIGINT COMMENT 'Foreign key linking to product.hazardous_substance. Business justification: Dangerous goods declarations must reference the specific hazardous substance for regulatory compliance. Shipping teams use this to generate required documentation and ensure carrier compliance.',
    `material_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.material_specification. Business justification: Dangerous goods declarations require precise material specifications from engineering to determine hazard classifications, UN numbers, and shipping restrictions. Compliance teams reference material sp',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Dangerous goods shipments must comply with specific regulations (IATA, DOT, ADR). Logistics teams reference regulatory requirements to ensure proper handling, labeling, and documentation for hazmat tr',
    `sds_id` BIGINT COMMENT 'Foreign key linking to hse.sds. Business justification: Dangerous goods shipments legally require Safety Data Sheets. Logistics personnel must access SDS for proper handling, emergency response, and carrier compliance verification before transport.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Dangerous goods declarations are required for shipments containing hazardous materials. dangerous_goods_declaration.shipment_number is a denormalized string reference. Adding shipment_id FK enforces r',
    `spare_part_id` BIGINT COMMENT 'Foreign key linking to asset.spare_part. Business justification: Hazardous spare parts (chemicals, batteries, pressurized items) require dangerous goods declarations for shipping. Logistics references the spare part for proper classification, labeling, and regulato',
    `additional_handling_instructions` STRING COMMENT 'Free-text field for any additional handling, stowage, or segregation instructions not captured by standard fields, such as temperature requirements, segregation from other cargo, or special loading instructions.',
    `certification_date` DATE COMMENT 'Date on which the dangerous goods declaration was signed and certified by the authorized shipper representative. Establishes the legal validity period of the document.. Valid values are `^d{4}-d{2}-d{2}$`',
    `certifier_name` STRING COMMENT 'Full name of the authorized person who signed and certified the dangerous goods declaration, confirming that the contents are fully and accurately described and are in proper condition for transport.',
    `certifier_title` STRING COMMENT 'Job title or role of the person who certified the dangerous goods declaration (e.g., Dangerous Goods Safety Advisor, Logistics Manager). Supports accountability and regulatory audit trails.',
    `consignee_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the consignees destination country, used for import compliance, customs documentation, and regulatory jurisdiction determination.. Valid values are `^[A-Z]{3}$`',
    `consignee_name` STRING COMMENT 'Full legal name of the consignee (recipient) of the dangerous goods shipment, as required on the declaration for regulatory traceability and delivery verification.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the dangerous goods declaration record was first created in the system, in ISO 8601 format with timezone offset. Used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `declaration_number` STRING COMMENT 'Unique business document number assigned to the dangerous goods declaration, used for tracking and cross-referencing with shipment and freight order documents.. Valid values are `^DGD-[A-Z0-9]{4}-[0-9]{8}-[0-9]{4}$`',
    `destination_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the destination country for the dangerous goods shipment, used for import compliance, customs documentation, and applicable regulatory regime determination.. Valid values are `^[A-Z]{3}$`',
    `document_date` DATE COMMENT 'Date the dangerous goods declaration document was prepared and issued, which may differ from the certification date. Used for document version control and regulatory validity tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `emergency_contact_name` STRING COMMENT 'Name of the 24-hour emergency response contact person or organization (e.g., CHEMTREC, CANUTEC) to be contacted in case of an incident involving the dangerous goods during transport.',
    `emergency_contact_phone` STRING COMMENT '24-hour emergency telephone number for the emergency response contact, mandatory on all dangerous goods declarations. Must be staffed at all times during transport.. Valid values are `^+?[0-9s-()]{7,20}$`',
    `emergency_response_guide_number` STRING COMMENT 'Emergency Response Guide number from the DOT/Transport Canada ERG, directing first responders to the appropriate emergency action guide for the hazardous material.. Valid values are `^[0-9]{3}$`',
    `expiry_date` DATE COMMENT 'Date after which the dangerous goods declaration is no longer valid for transport use. Certain regulatory regimes impose validity periods; expired declarations must be reissued before shipment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `flash_point_c` DECIMAL(18,2) COMMENT 'Flash point of the substance in degrees Celsius, required for Class 3 flammable liquids and certain Class 6.1 and Class 8 substances. Determines packing group assignment and transport restrictions.',
    `handling_labels` STRING COMMENT 'Required hazard labels and handling marks to be affixed to packages (e.g., flammable liquid label, corrosive label, orientation arrows, THIS SIDE UP). Pipe-separated list of applicable label codes.',
    `is_environmentally_hazardous` BOOLEAN COMMENT 'Indicates whether the substance meets the criteria for an environmentally hazardous substance (EHS) under ADR/IMDG, requiring the EHS mark and additional handling precautions.. Valid values are `true|false`',
    `is_marine_pollutant` BOOLEAN COMMENT 'Indicates whether the substance is classified as a marine pollutant under IMDG Code, requiring the marine pollutant mark on packages and additional documentation for sea transport.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the dangerous goods declaration record, used for change tracking, audit compliance, and data freshness monitoring.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `origin_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country from which the dangerous goods shipment originates, used for export control classification and regulatory regime determination.. Valid values are `^[A-Z]{3}$`',
    `package_count` STRING COMMENT 'Total number of packages containing dangerous goods covered by this declaration. Each package must be individually marked and labeled per applicable regulations.. Valid values are `^[1-9][0-9]*$`',
    `packaging_specification_number` STRING COMMENT 'UN certification specification number of the packaging used, confirming the packaging has been tested and approved for the specific dangerous goods. Required for regulatory compliance verification.',
    `packaging_type` STRING COMMENT 'Type of packaging used for the dangerous goods (e.g., 1A1 steel drum, 4G fibreboard box, 6HA1 composite packaging). Must be UN-certified packaging appropriate for the hazard class and packing group.',
    `proper_shipping_name` STRING COMMENT 'The official regulatory name for the hazardous material as listed in the applicable dangerous goods regulations (e.g., FLAMMABLE LIQUID, N.O.S.). Must match the UN Dangerous Goods List exactly.',
    `quantity_gross` DECIMAL(18,2) COMMENT 'Total gross quantity of dangerous goods including packaging weight, expressed in the unit of measure specified. Required for transport documentation and weight/balance calculations.',
    `quantity_net` DECIMAL(18,2) COMMENT 'Net quantity of dangerous goods per package (excluding packaging weight), expressed in the unit of measure specified. Used to determine quantity limits for passenger/cargo aircraft or road transport.',
    `quantity_type` STRING COMMENT 'Classification of the shipment quantity relative to regulatory thresholds: excepted quantity (minimal quantities with reduced requirements), limited quantity (reduced packaging/labeling requirements), or fully regulated (full DG requirements apply).. Valid values are `excepted_quantity|limited_quantity|fully_regulated`',
    `quantity_unit_of_measure` STRING COMMENT 'Unit of measure for the net and gross quantity values declared (e.g., kg for solids, L for liquids). Must align with the applicable regulatory requirements for the hazard class.. Valid values are `kg|L|mL|g|mg|m3|pieces`',
    `radioactive_index` DECIMAL(18,2) COMMENT 'Transport Index (TI) for Class 7 radioactive materials, representing the maximum radiation level in millisieverts per hour at one meter from the package surface. Required only for Class 7 shipments.',
    `reach_compliant` BOOLEAN COMMENT 'Indicates whether the dangerous goods substance has been assessed and confirmed compliant with EU REACH (Registration, Evaluation, Authorisation and Restriction of Chemicals) regulation requirements.. Valid values are `true|false`',
    `regulatory_regime` STRING COMMENT 'The applicable international or national dangerous goods transport regulation governing this declaration: IATA (air), IMDG (sea), ADR (road Europe), DOT (US domestic), RID (rail), or ICAO Technical Instructions.. Valid values are `IATA|IMDG|ADR|DOT|RID|ICAO|IATA_IMDG|ADR_RID|MULTI`',
    `rohs_compliant` BOOLEAN COMMENT 'Indicates whether the dangerous goods item complies with EU RoHS (Restriction of Hazardous Substances) Directive 2011/65/EU, restricting use of specific hazardous materials in electrical and electronic equipment.. Valid values are `true|false`',
    `shipper_address` STRING COMMENT 'Full address of the shipper (consignor) as required on the dangerous goods declaration, including street, city, country. Used for regulatory traceability and incident response.',
    `shipper_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the shippers country of origin, used for export control, customs compliance, and regulatory jurisdiction determination.. Valid values are `^[A-Z]{3}$`',
    `shipper_name` STRING COMMENT 'Full legal name of the shipper (consignor) responsible for preparing and certifying the dangerous goods declaration. The shipper certifies that the goods are properly classified, packaged, marked, and labeled.',
    `special_provisions` STRING COMMENT 'Applicable special provision codes from the dangerous goods regulations that modify the standard requirements for this substance (e.g., IATA SP A1, A2; IMDG SP 274; ADR SP 188). Multiple codes may be listed.',
    `status` STRING COMMENT 'Current lifecycle status of the dangerous goods declaration document, from initial draft through regulatory acceptance or rejection.. Valid values are `draft|submitted|accepted|rejected|cancelled|superseded`',
    `subsidiary_hazard_class` STRING COMMENT 'Secondary hazard class(es) for substances presenting more than one hazard, required on the declaration when the subsidiary risk label must be applied (e.g., a flammable toxic liquid may have Class 3 primary and Class 6.1 subsidiary).',
    `technical_name` STRING COMMENT 'The recognized chemical name or biological/microbiological name of the substance when the proper shipping name is an N.O.S. (Not Otherwise Specified) entry, required by IATA and IMDG regulations.',
    `transport_mode` STRING COMMENT 'Mode of transport for which this dangerous goods declaration is prepared, determining the applicable regulatory framework and packaging/labeling requirements.. Valid values are `air|sea|road|rail|multimodal`',
    CONSTRAINT pk_dangerous_goods_declaration PRIMARY KEY(`dangerous_goods_declaration_id`)
) COMMENT 'Dangerous goods (DG) declaration document required for shipments containing hazardous materials classified under IATA, IMDG, ADR, or DOT regulations. Records UN number, proper shipping name, hazard class, packing group, net/gross quantity, emergency contact, shipper certification, and applicable regulatory regime. Ensures compliance with REACH, RoHS, and international DG transport regulations.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`freight_contract` (
    `freight_contract_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for the freight contract record in the lakehouse silver layer.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Freight contracts are negotiated with specific customer accounts for volume commitments and rate agreements. Logistics procurement teams use this for contract compliance and rate application.',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: Freight contracts are signed by specific legal entities for liability and payment obligations. Legal and procurement teams require this for contract governance.',
    `approved_by` STRING COMMENT 'Name or employee ID of the authorized approver who signed off on the freight contract terms on behalf of the manufacturing organization.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time at which the freight contract was formally approved by the authorized approver, establishing the audit trail for contract governance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the freight contract includes an automatic renewal clause that extends the contract term without explicit renegotiation if not cancelled before the renewal date.. Valid values are `true|false`',
    `carrier_code` STRING COMMENT 'Internal carrier identifier or SCAC (Standard Carrier Alpha Code) of the primary carrier or Logistics Service Provider (LSP) party to this freight contract.',
    `carrier_legal_name` STRING COMMENT 'Full legal registered name of the carrier or Logistics Service Provider (LSP) as it appears on the signed contract document.',
    `contract_number` STRING COMMENT 'Business-facing unique contract reference number assigned by the TMS or procurement system (SAP Ariba / SAP S/4HANA MM) to identify the freight contract across all operational systems.. Valid values are `^FC-[A-Z0-9]{4,20}$`',
    `contract_owner` STRING COMMENT 'Name or employee ID of the internal logistics or procurement manager responsible for negotiating, managing, and renewing this freight contract.',
    `contract_type` STRING COMMENT 'Classification of the freight contract by commercial structure: spot (single-shipment rate), annual (12-month negotiated), multi-year (2+ year term), master (umbrella agreement with sub-agreements), framework (rate schedule without volume commitment), lane-specific, dedicated (dedicated fleet/capacity), or intermodal.. Valid values are `spot|annual|multi_year|master|framework|lane_specific|dedicated|intermodal`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp recording when the freight contract record was first created in the source system (SAP Ariba or SAP S/4HANA MM).. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which all freight rates, charges, and financial obligations under this contract are denominated (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `customs_brokerage_included` BOOLEAN COMMENT 'Indicates whether customs brokerage and trade compliance services are included within the scope of this freight contract or must be procured separately.. Valid values are `true|false`',
    `destination_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the primary destination country or region covered by this freight contract.. Valid values are `^[A-Z]{3}$`',
    `effective_date` DATE COMMENT 'Date on which the freight contract becomes commercially effective and rates/terms are applicable for shipment execution.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date on which the freight contract expires and rates/terms are no longer valid unless renewed or extended.. Valid values are `^d{4}-d{2}-d{2}$`',
    `fuel_surcharge_basis` STRING COMMENT 'Defines how fuel surcharges are handled under this contract: included in base rate, excluded (billed separately), linked to a published fuel index, fixed percentage, or negotiated periodically.. Valid values are `included|excluded|index_linked|fixed_pct|negotiated`',
    `geographic_scope` STRING COMMENT 'Geographic coverage of the freight contract: domestic (single country), regional (multi-country within a continent), international (cross-border), or global (worldwide).. Valid values are `domestic|regional|international|global`',
    `hazmat_permitted` BOOLEAN COMMENT 'Indicates whether the carrier is authorized and contractually permitted to transport hazardous materials (HAZMAT) under this agreement, subject to applicable regulatory certifications.. Valid values are `true|false`',
    `incoterms_code` STRING COMMENT 'ICC INCOTERMS 2020 code defining the allocation of costs, risks, and responsibilities between shipper and carrier/buyer under this freight contract.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `insurance_minimum_coverage` DECIMAL(18,2) COMMENT 'Minimum cargo insurance coverage amount the carrier must maintain, denominated in the contract currency. Verified during carrier onboarding and annual review.',
    `insurance_required_flag` BOOLEAN COMMENT 'Indicates whether the carrier is contractually required to maintain cargo insurance coverage for shipments executed under this agreement.. Valid values are `true|false`',
    `invoicing_frequency` STRING COMMENT 'Agreed frequency at which the carrier submits freight invoices to the shipper under this contract (per shipment, weekly, bi-weekly, monthly, or quarterly).. Valid values are `per_shipment|weekly|bi_weekly|monthly|quarterly`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent update to the freight contract record, supporting change tracking and data lineage in the lakehouse silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `liability_limit_amount` DECIMAL(18,2) COMMENT 'Maximum monetary liability the carrier accepts for loss, damage, or delay of freight under this contract, denominated in the contract currency.',
    `maximum_volume_cap` DECIMAL(18,2) COMMENT 'Maximum freight volume the carrier is contractually obligated to accept under this agreement. Volumes above this cap may require spot procurement or separate negotiation.',
    `minimum_volume_commitment` DECIMAL(18,2) COMMENT 'Contractually obligated minimum freight volume (in the unit specified by volume_commitment_uom) that the shipper must tender to the carrier over the contract period. Failure to meet this may trigger shortfall penalties.',
    `origin_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the primary origin country or region covered by this freight contract.. Valid values are `^[A-Z]{3}$`',
    `payment_terms` STRING COMMENT 'Contractually agreed payment terms defining when freight invoices must be settled (e.g., Net 30 = payment due 30 days from invoice date).. Valid values are `net_15|net_30|net_45|net_60|net_90|immediate|prepaid|cod`',
    `rate_escalation_clause` STRING COMMENT 'Type of rate escalation mechanism embedded in the contract: none (fixed rates), CPI-indexed (Consumer Price Index), fuel-indexed (linked to fuel surcharge index), annual percentage increase, or negotiated at renewal.. Valid values are `none|fixed|cpi_indexed|fuel_indexed|annual_percentage|negotiated`',
    `rate_escalation_pct` DECIMAL(18,2) COMMENT 'Annual percentage rate by which contracted freight rates escalate under a fixed or annual-percentage escalation clause. Expressed as a decimal percentage (e.g., 3.50 = 3.50%).',
    `renewal_date` DATE COMMENT 'Date by which the contract must be reviewed and renewed to avoid lapse. Used for proactive contract management and carrier renegotiation planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `renewal_notice_days` STRING COMMENT 'Number of calendar days prior to expiry by which either party must provide written notice of intent to renew or terminate the contract.. Valid values are `^[0-9]+$`',
    `service_level` STRING COMMENT 'Contracted service level tier defining the speed and priority of freight movement under this agreement (e.g., standard, express, priority, dedicated).. Valid values are `standard|express|economy|priority|deferred|next_day|same_day|dedicated`',
    `signed_date` DATE COMMENT 'Date on which both parties executed and signed the freight contract, establishing legal enforceability.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sla_on_time_delivery_target_pct` DECIMAL(18,2) COMMENT 'Contractually committed on-time delivery performance target expressed as a percentage (e.g., 95.00 = 95%). Carrier must meet or exceed this threshold to avoid SLA penalty clauses.',
    `sla_penalty_amount` DECIMAL(18,2) COMMENT 'Monetary value of the SLA penalty per occurrence or per day of non-performance, denominated in the contract currency. Applicable when sla_penalty_clause is fixed_amount or credit_per_day.',
    `sla_penalty_clause` STRING COMMENT 'Type of financial penalty applied when the carrier fails to meet the contracted SLA: none, credit per day of delay, percentage of invoice value, fixed monetary amount, or service credit.. Valid values are `none|credit_per_day|percentage_of_invoice|fixed_amount|service_credit`',
    `status` STRING COMMENT 'Current lifecycle status of the freight contract, from initial drafting through approval, active execution, and eventual expiry or termination.. Valid values are `draft|under_review|pending_approval|active|suspended|expired|terminated|cancelled`',
    `temperature_controlled` BOOLEAN COMMENT 'Indicates whether this freight contract covers temperature-controlled (cold chain) shipments requiring refrigerated or heated transport equipment.. Valid values are `true|false`',
    `transport_mode` STRING COMMENT 'Primary mode of transportation covered by this freight contract (road, rail, ocean, air, intermodal, courier, barge, or pipeline).. Valid values are `road|rail|ocean|air|intermodal|courier|barge|pipeline`',
    `volume_commitment_uom` STRING COMMENT 'Unit of measure for the minimum volume commitment (e.g., shipments, kg, metric tons, TEU for ocean containers, pallets, cubic meters, or loads).. Valid values are `shipments|kg|tons|TEU|FEU|pallets|cbm|loads`',
    CONSTRAINT pk_freight_contract PRIMARY KEY(`freight_contract_id`)
) COMMENT 'Master freight contract negotiated with a carrier or LSP defining the commercial terms, rate structures, service commitments, SLA penalties, volume commitments, and contract duration. Stores contract number, contract type (spot, annual, multi-year), effective/expiry dates, minimum volume commitment, rate escalation clauses, and contract status. Distinct from individual freight rates — this is the governing commercial agreement.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` (
    `shipment_exception_id` BIGINT COMMENT 'Unique system-generated identifier for each shipment exception record within the logistics domain.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Shipment exceptions require customer account reference for notification, resolution coordination, and service level tracking. Customer service teams use this for exception management and escalation.',
    `quality_notification_id` BIGINT COMMENT 'Foreign key linking to quality.quality_notification. Business justification: Shipment exceptions occur when quality notifications place holds on material. Logistics cannot ship products under quality hold - quality notifications block shipments until clearance.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Shipment exceptions are identified and reported by logistics employees. Manufacturing operations track who reported issues for process improvement and incident management.',
    `actual_delay_days` DECIMAL(18,2) COMMENT 'Actual number of calendar days by which the shipment delivery was delayed due to this exception, calculated upon resolution for performance reporting.. Valid values are `^d{1,3}(.d{1,2})?$`',
    `capa_reference_number` STRING COMMENT 'Reference number linking this exception to a formal CAPA record in the Quality Management System, enabling traceability between logistics exceptions and quality improvement actions.',
    `carrier_name` STRING COMMENT 'Name of the carrier involved in the shipment at the time of the exception, used for carrier performance management and claims processing.',
    `carrier_scac_code` STRING COMMENT 'Standard Carrier Alpha Code (SCAC) uniquely identifying the carrier involved in the exception, used for EDI communications and carrier performance reporting.. Valid values are `^[A-Z]{2,4}$`',
    `claim_reference_number` STRING COMMENT 'Reference number for any freight claim, insurance claim, or carrier liability claim raised as a result of this exception (e.g., damage or loss events).',
    `corrective_action_code` STRING COMMENT 'Standardized code for the corrective action taken to resolve the exception and restore normal shipment execution.. Valid values are `reroute|expedite|reorder|carrier_replacement|customs_intervention|temperature_recovery|damage_claim|documentation_resubmission|customer_notification|hold_and_inspect|no_action_required|other`',
    `corrective_action_description` STRING COMMENT 'Detailed description of the corrective action taken, including steps executed, parties involved, and outcome achieved.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the shipment exception record was created in the system, used for audit trail and data lineage purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customer_notification_timestamp` TIMESTAMP COMMENT 'Date and time when the customer was formally notified of the exception, used to measure notification response time against SLA commitments.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customs_hold_reference` STRING COMMENT 'Official reference number issued by the customs authority for a customs hold exception, used for tracking clearance status and regulatory correspondence.',
    `detection_source` STRING COMMENT 'System or channel through which the exception was first detected, supporting root cause analysis and process improvement initiatives.. Valid values are `tms_automated|carrier_edi|iiot_sensor|customer_complaint|manual_entry|customs_authority|carrier_portal|tracking_event`',
    `detection_timestamp` TIMESTAMP COMMENT 'Date and time when the exception was first detected or reported, used to calculate response time and measure SLA compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `escalation_level` STRING COMMENT 'Current escalation tier of the exception, indicating whether it has been elevated beyond standard handling to supervisory, management, or executive levels.. Valid values are `none|level_1|level_2|level_3|executive`',
    `escalation_timestamp` TIMESTAMP COMMENT 'Date and time when the exception was escalated to a higher management tier, used to track escalation response times and workflow compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `estimated_delay_days` DECIMAL(18,2) COMMENT 'Estimated number of calendar days by which the shipment delivery will be delayed as a result of this exception, used for customer notification and delivery rescheduling.. Valid values are `^d{1,3}(.d{1,2})?$`',
    `exception_code` STRING COMMENT 'Standardized alphanumeric code identifying the specific exception condition, aligned with TMS exception code libraries and carrier EDI exception codes.. Valid values are `^[A-Z]{2,4}-[0-9]{3}$`',
    `exception_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the exception occurred, supporting geographic analysis and regulatory compliance reporting.. Valid values are `^[A-Z]{3}$`',
    `exception_description` STRING COMMENT 'Free-text narrative describing the exception event in detail, including circumstances, observed conditions, and initial impact assessment.',
    `exception_location_code` STRING COMMENT 'Standardized location code (port, warehouse, customs facility, transit hub) where the exception event occurred or was detected.',
    `exception_number` STRING COMMENT 'Human-readable business reference number for the shipment exception, used in communications, workflows, and reporting.. Valid values are `^EXC-[0-9]{4}-[0-9]{6}$`',
    `exception_type` STRING COMMENT 'Classification of the exception category describing the nature of the deviation from planned shipment execution (e.g., delay, customs hold, temperature excursion, damage).. Valid values are `delay|route_diversion|customs_hold|carrier_rejection|temperature_excursion|damage|lost|short_shipment|documentation_error|address_error|capacity_constraint|border_closure|natural_disaster|security_incident|other`',
    `financial_impact_amount` DECIMAL(18,2) COMMENT 'Estimated or actual monetary cost of the exception including expediting fees, penalty charges, re-routing costs, and customer compensation, expressed in the transaction currency.. Valid values are `^-?d{1,15}(.d{1,2})?$`',
    `financial_impact_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the financial impact amount recorded against this exception.. Valid values are `^[A-Z]{3}$`',
    `freight_order_number` STRING COMMENT 'Reference to the freight order associated with this exception, enabling linkage to carrier booking and execution details.',
    `is_customer_notified` BOOLEAN COMMENT 'Indicates whether the customer has been formally notified of the shipment exception and revised delivery expectations, supporting customer service SLA compliance.. Valid values are `true|false`',
    `is_sla_breached` BOOLEAN COMMENT 'Indicates whether the exception response or resolution exceeded the contractual SLA deadline, triggering escalation and penalty review processes.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the shipment exception record, supporting audit trail, change tracking, and incremental data processing in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `occurrence_timestamp` TIMESTAMP COMMENT 'Date and time when the exception event actually occurred in the physical world, which may precede the detection timestamp in cases of delayed reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `resolution_timestamp` TIMESTAMP COMMENT 'Date and time when the exception was fully resolved and the shipment returned to normal execution or was formally closed.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `responsible_party` STRING COMMENT 'Party identified as responsible for causing or failing to prevent the exception, used for claims management, carrier performance scoring, and root cause analysis.. Valid values are `carrier|customs_authority|shipper|consignee|freight_forwarder|warehouse|internal_logistics|supplier|third_party|unknown`',
    `revised_delivery_date` DATE COMMENT 'Updated expected delivery date issued after the exception was raised, communicated to the customer and used for order management rescheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `root_cause_code` STRING COMMENT 'Standardized code identifying the root cause of the exception following investigation, supporting CAPA processes and systemic improvement initiatives.. Valid values are `carrier_error|documentation_error|customs_regulation|weather_event|infrastructure_failure|supplier_delay|system_error|capacity_shortage|security_event|human_error|regulatory_change|unknown`',
    `root_cause_description` STRING COMMENT 'Detailed narrative of the identified root cause following investigation, providing context beyond the root cause code for CAPA documentation.',
    `severity` STRING COMMENT 'Business-defined severity level of the exception indicating its impact on delivery commitments, customer satisfaction, and operational continuity.. Valid values are `critical|high|medium|low`',
    `shipment_number` STRING COMMENT 'Reference to the parent shipment against which this exception was raised, linking the exception to the originating shipment record.',
    `sla_response_deadline` TIMESTAMP COMMENT 'Contractual or operational deadline by which the exception must be acknowledged and actioned, derived from the applicable SLA agreement for the shipment.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `status` STRING COMMENT 'Current lifecycle status of the shipment exception record, driving workflow routing and exception management dashboards.. Valid values are `open|in_progress|escalated|resolved|closed|cancelled`',
    `temperature_excursion_max_c` DECIMAL(18,2) COMMENT 'Maximum recorded temperature in degrees Celsius during a temperature excursion exception, used to assess product integrity and determine disposition actions.. Valid values are `^-?d{1,3}(.d{1,2})?$`',
    `temperature_excursion_min_c` DECIMAL(18,2) COMMENT 'Minimum recorded temperature in degrees Celsius during a temperature excursion exception, used to assess product integrity and regulatory compliance for temperature-sensitive goods.. Valid values are `^-?d{1,3}(.d{1,2})?$`',
    `tracking_number` STRING COMMENT 'Carrier-assigned tracking number for the shipment at the time the exception was detected, used for carrier communication and investigation.',
    `transport_mode` STRING COMMENT 'Mode of transportation active at the time of the exception, used for mode-specific exception analysis and regulatory compliance.. Valid values are `road|rail|ocean|air|intermodal|courier|pipeline`',
    CONSTRAINT pk_shipment_exception PRIMARY KEY(`shipment_exception_id`)
) COMMENT 'Operational exception record raised when a shipment deviates from its planned execution — including delays, route diversions, customs holds, carrier rejections, temperature excursions (for sensitive goods), and damage events. Captures exception type, severity, detection timestamp, responsible party, corrective action taken, and resolution timestamp. Drives exception management workflows and root cause analysis.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` (
    `carrier_service_agreement_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each carrier service agreement record',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to the approved carrier providing transportation services for this contract',
    `service_contract_id` BIGINT COMMENT 'Foreign key linking to the maintenance service contract that requires carrier logistics support',
    `contract_rate` DECIMAL(18,2) COMMENT 'Negotiated transportation rate for this specific service contract-carrier relationship. May be per-shipment, per-mile, or per-weight depending on rate_type. Reflects volume discounts or contract-specific pricing.',
    `coverage_zone` STRING COMMENT 'Geographic coverage area or zone code defining where this carrier is authorized to provide transportation services for this service contract (e.g., EMEA-North, APAC-Southeast, US-Midwest). Reflects negotiated service territory.',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this carrier service agreement record was created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the contract_rate amount (e.g., USD, EUR, CNY).',
    `effective_date` DATE COMMENT 'The date on which this carrier service agreement becomes active and the negotiated terms take effect. Typically aligns with or follows the service_contract start_date.',
    `expiration_date` DATE COMMENT 'The date on which this carrier service agreement expires. May align with the service_contract end_date or be independently negotiated. Triggers renewal or renegotiation workflows.',
    `insurance_coverage_amount` DECIMAL(18,2) COMMENT 'Minimum insurance coverage amount required per shipment if insurance_required_flag is true. Expressed in currency_code.',
    `insurance_required_flag` BOOLEAN COMMENT 'Indicates whether additional cargo insurance beyond the carriers standard liability is required for shipments under this agreement, typically for high-value equipment.',
    `last_modified_by` STRING COMMENT 'User ID or system identifier of the person or process that last modified this agreement record.',
    `last_modified_date` TIMESTAMP COMMENT 'Timestamp of the most recent update to this carrier service agreement record.',
    `priority_rank` STRING COMMENT 'Numeric ranking indicating carrier preference order for this service contract when multiple carriers are available (1 = first choice). Used in TMS route optimization and carrier selection logic.',
    `rate_type` STRING COMMENT 'Unit of measure for the contract_rate (e.g., Per Shipment, Per Mile, Per Kilogram). Defines how transportation costs are calculated for this agreement.',
    `response_time_hours` DECIMAL(18,2) COMMENT 'Contractually committed maximum time in hours from pickup request to carrier dispatch for this service contract-carrier combination. May differ from the carriers general response time based on contract negotiations.',
    `service_level_agreement` STRING COMMENT 'The negotiated SLA tier for carrier transportation services specific to this service contract (e.g., Standard, Express, Emergency). Defines expected delivery speed and priority.',
    `status` STRING COMMENT 'Current lifecycle status of this carrier service agreement (Draft, Active, Suspended, Expired, Terminated). Controls whether the carrier can be selected for shipments related to this service contract.',
    `created_by` STRING COMMENT 'User ID or system identifier of the person or process that created this agreement record.',
    CONSTRAINT pk_carrier_service_agreement PRIMARY KEY(`carrier_service_agreement_id`)
) COMMENT 'This association product represents the Contract between service_contract and carrier. It captures the negotiated logistics service terms for equipment transportation related to maintenance contracts. Each record links one service_contract to one carrier with SLA terms, coverage zones, rates, and performance commitments that exist only in the context of this specific service contract-carrier relationship.. Existence Justification: In industrial manufacturing operations, maintenance service contracts frequently require logistics support from multiple carriers for equipment delivery, spare parts transportation, and equipment return for depot repair. Each service contract can engage multiple carriers based on geographic coverage, equipment type, and service urgency. Conversely, carriers provide transportation services to multiple service contracts across different facilities and vendors. The business actively manages these carrier agreements with contract-specific SLAs, rates, coverage zones, and priority rankings that cannot be stored on either the service_contract or carrier entity alone.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` (
    `carrier_qualification_id` BIGINT COMMENT 'Unique surrogate identifier for each carrier qualification record',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to the carrier master record that has been qualified for this tooling type',
    `tooling_equipment_id` BIGINT COMMENT 'Foreign key linking to the tooling equipment master record that requires qualified transport',
    `approved_by` STRING COMMENT 'Name or employee ID of the logistics manager or quality engineer who approved this carrier qualification.',
    `approved_date` DATE COMMENT 'Date on which the carrier was formally approved to transport this tooling equipment type. Explicitly identified in detection phase relationship data.',
    `certification_status` STRING COMMENT 'Current status of the carrier qualification for this tooling type. Explicitly identified in detection phase relationship data. Drives whether carrier can be selected for transport orders.',
    `handling_certification` STRING COMMENT 'Type of specialized handling certification the carrier holds for this tooling category (e.g., Precision Tooling Handler, Climate-Controlled Transport, Hazmat Certified). Explicitly identified in detection phase relationship data.',
    `insurance_coverage` DECIMAL(18,2) COMMENT 'Minimum insurance coverage amount required for transporting this specific tooling equipment type. Explicitly identified in detection phase relationship data. May exceed carriers general cargo liability limit for high-value tooling.',
    `last_audit_date` DATE COMMENT 'Date of the most recent carrier audit or inspection for this tooling transport qualification.',
    `max_weight_capacity` DECIMAL(18,2) COMMENT 'Maximum weight in kilograms the carrier is qualified to transport for this tooling type. Explicitly identified in detection phase relationship data. Must meet or exceed the tooling_equipment.tool_weight_kg.',
    `notes` STRING COMMENT 'Free-text notes regarding special conditions, restrictions, or requirements for this carrier-tooling qualification.',
    `qualification_expiry_date` DATE COMMENT 'Date on which this carrier qualification expires and must be renewed. Triggers recertification workflows.',
    `special_equipment_required` STRING COMMENT 'Description of specialized transport equipment the carrier must provide for this tooling type (e.g., Air-ride suspension, Climate control, Vibration dampening). Explicitly identified in detection phase relationship data.',
    CONSTRAINT pk_carrier_qualification PRIMARY KEY(`carrier_qualification_id`)
) COMMENT 'This association product represents the qualification and approval of specific carriers to transport specific types of tooling equipment. It captures the certification requirements, insurance coverage, handling capabilities, and approval status that exist only in the context of a carrier being authorized to transport particular tooling assets. Each record links one tooling equipment type to one qualified carrier with relationship-specific attributes governing the transport authorization.. Existence Justification: In industrial manufacturing, high-value tooling equipment (dies, molds, precision fixtures) requires specialized carrier qualification before transport. One tooling equipment type can be approved for transport by multiple carriers (for geographic coverage, redundancy, and competitive bidding), and one carrier can be qualified to transport many different tooling types. The business actively manages these qualifications as a formal approval process with certifications, insurance requirements, and periodic audits.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` (
    `carrier_territory_coverage_id` BIGINT COMMENT 'Unique system-generated identifier for each carrier-territory coverage agreement record',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to the approved freight carrier providing delivery services to this territory',
    `service_territory_id` BIGINT COMMENT 'Foreign key to service.service_territory.service_territory_id',
    `territory_service_territory_id` BIGINT COMMENT 'Foreign key linking to the geographic service territory being covered by this carrier',
    `cost_per_delivery` DECIMAL(18,2) COMMENT 'Standard cost per delivery shipment for this carrier-territory combination used in freight cost planning and route optimization',
    `coverage_days` STRING COMMENT 'Comma-separated list of days of the week this carrier provides delivery service to this territory (e.g., MON,TUE,WED,THU,FRI)',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this carrier-territory coverage record was created in the system',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the cost_per_delivery amount',
    `effective_date` DATE COMMENT 'Date when this carrier-territory coverage agreement became active and available for dispatch routing',
    `expiration_date` DATE COMMENT 'Date when this carrier-territory coverage agreement expires or was terminated, null if currently active',
    `last_modified_date` TIMESTAMP COMMENT 'Timestamp when this carrier-territory coverage record was last updated',
    `max_weight_kg` DECIMAL(18,2) COMMENT 'Maximum shipment weight in kilograms this carrier can handle for deliveries to this territory based on vehicle and route constraints',
    `notes` STRING COMMENT 'Free-text notes capturing special handling requirements, restrictions, or operational considerations for this carrier-territory coverage',
    `priority_level` STRING COMMENT 'Priority ranking of this carrier for the territory indicating whether they are the primary, secondary, or backup carrier option for dispatch routing decisions',
    `service_type` STRING COMMENT 'Type of delivery service this carrier provides to this territory indicating the speed and handling requirements (standard, expedited, hazmat, etc.)',
    `sla_delivery_hours` DECIMAL(18,2) COMMENT 'Committed service level agreement delivery time in hours from pickup to delivery for shipments to this territory using this carrier, used in TMS route optimization',
    `status` STRING COMMENT 'Current operational status of this carrier-territory coverage agreement controlling whether it is available for dispatch routing',
    CONSTRAINT pk_carrier_territory_coverage PRIMARY KEY(`carrier_territory_coverage_id`)
) COMMENT 'This association product represents the service coverage contract between a freight carrier and a field service territory. It captures the operational agreement defining which carriers are authorized to deliver spare parts and equipment to customer sites within specific service territories, including service level commitments, delivery priorities, and cost structures. Each record links one carrier to one service territory with attributes that exist only in the context of this coverage relationship.. Existence Justification: In industrial manufacturing operations, logistics teams establish carrier coverage agreements per service territory to ensure reliable spare parts delivery to customer sites. Each service territory requires multiple carriers to handle different service types (expedited, standard, hazmat) and provide redundancy, while each carrier serves multiple territories with territory-specific SLAs and pricing. The business actively manages these coverage agreements as operational contracts with specific service levels, costs, and priorities.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` (
    `parts_inventory_position_id` BIGINT COMMENT 'Unique surrogate identifier for each parts inventory position record representing a specific part stocked at a specific location',
    `location_id` BIGINT COMMENT 'Foreign key linking to the logistics location where the spare part is stocked',
    `logistics_location_id` BIGINT COMMENT 'Foreign key to logistics.logistics_location identifying the warehouse or distribution center',
    `spare_parts_catalog_id` BIGINT COMMENT 'Foreign key to service.spare_parts_catalog identifying the aftermarket part being stocked',
    `effective_date` DATE COMMENT 'Date from which this stocking position became active at this location. Supports historical analysis of network stocking strategy changes.',
    `end_date` DATE COMMENT 'Date on which this stocking position was discontinued at this location. NULL for currently active positions.',
    `last_replenishment_date` DATE COMMENT 'Date of the most recent inbound replenishment receipt for this part at this location. Used for inventory aging analysis and replenishment cycle monitoring.',
    `lead_time_days` STRING COMMENT 'Location-specific replenishment lead time in days for this part at this location, accounting for supplier proximity, transportation mode, and customs clearance if applicable.',
    `reorder_point` DECIMAL(18,2) COMMENT 'Inventory threshold quantity that triggers replenishment action for this part at this location. Set based on demand patterns and service level targets.',
    `stock_quantity` DECIMAL(18,2) COMMENT 'Current on-hand inventory quantity of this spare part at this specific logistics location. Updated by inbound receipts and outbound shipments.',
    `stocking_status` STRING COMMENT 'Current stocking policy status for this part at this location. ACTIVE = actively stocked and replenished, INACTIVE = no longer stocked, PHASE_OUT = depleting without replenishment, SEASONAL = stocked only during specific periods.',
    `storage_zone` STRING COMMENT 'Physical storage zone or bin location assignment within the logistics location where this spare part is stored (e.g., A-12-03, HAZMAT-ZONE-2, TEMP-CONTROLLED-B).',
    CONSTRAINT pk_parts_inventory_position PRIMARY KEY(`parts_inventory_position_id`)
) COMMENT 'This association product represents the inventory stocking position between logistics locations and spare parts catalog items. It captures the operational inventory management data for each part at each location, including stock quantities, reorder thresholds, replenishment history, and storage assignments. Each record links one logistics location to one spare parts catalog item with attributes that exist only in the context of this stocking relationship.. Existence Justification: In industrial manufacturing aftermarket operations, spare parts are strategically stocked across multiple distribution centers and regional warehouses to optimize service levels and response times. Each logistics location stocks a subset of the parts catalog based on regional equipment install base, demand patterns, and service level agreements. Each spare part is typically stocked at multiple locations to ensure geographic coverage and redundancy. The business actively manages these stocking positions with location-specific inventory parameters.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` (
    `route_supplier_pickup_id` BIGINT COMMENT 'Unique system-generated identifier for this route-supplier pickup assignment record',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to the supplier being serviced on this route',
    `route_id` BIGINT COMMENT 'Foreign key linking to the transportation route on which this supplier is scheduled for pickup',
    `active_status` BOOLEAN COMMENT 'Indicates whether this route-supplier pickup assignment is currently active and operational. Inactive assignments represent historical or suspended pickup configurations.',
    `average_pickup_volume_m3` DECIMAL(18,2) COMMENT 'Average volume in cubic meters of materials picked up from this supplier on this route per pickup event. Used for route capacity planning and optimization.',
    `average_pickup_weight_kg` DECIMAL(18,2) COMMENT 'Average weight in kilograms of materials picked up from this supplier on this route per pickup event. Used for route capacity planning and carrier selection.',
    `collection_window_end` STRING COMMENT 'Latest time (HH:MM, 24-hour format) by which pickup must be completed at this supplier location on this route. Defines the closing of the collection window.',
    `collection_window_start` STRING COMMENT 'Earliest time (HH:MM, 24-hour format) at which pickup can occur at this supplier location on this route. Defines the opening of the collection window.',
    `consolidation_point` STRING COMMENT 'Code identifying the intermediate consolidation or cross-dock facility where materials from this supplier on this route are aggregated before final delivery. Used in hub-and-spoke milk-run operations.',
    `effective_end_date` DATE COMMENT 'Date on which this route-supplier pickup assignment ceased or will cease to be effective. Null indicates an open-ended assignment.',
    `effective_start_date` DATE COMMENT 'Date on which this route-supplier pickup assignment became or will become effective. Supports temporal tracking of route-supplier configurations.',
    `milk_run_sequence` STRING COMMENT 'Ordinal position of this supplier in the pickup sequence on this milk-run route. Determines the order in which the carrier visits suppliers to optimize distance and time.',
    `pickup_frequency` STRING COMMENT 'Operational frequency at which pickups are scheduled from this supplier on this route. Drives milk-run scheduling and capacity planning.',
    CONSTRAINT pk_route_supplier_pickup PRIMARY KEY(`route_supplier_pickup_id`)
) COMMENT 'This association product represents the operational assignment between inbound logistics routes and suppliers for milk-run and consolidation pickup operations. It captures the scheduled pickup configuration for each supplier on each route. Each record links one route to one supplier with attributes that define pickup timing, sequencing, and consolidation logistics that exist only in the context of this route-supplier pairing.. Existence Justification: In industrial manufacturing inbound logistics, milk-run and consolidation routes are designed to serve multiple suppliers on a single trip to optimize transportation costs and reduce empty miles. A single route visits multiple supplier locations in a defined sequence, and a single supplier can be serviced by multiple routes depending on product type, pickup frequency, or geographic coverage. The business actively manages route-supplier pickup assignments with specific operational parameters including pickup schedules, collection windows, sequencing, and consolidation points.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_packaging_id` FOREIGN KEY (`packaging_id`) REFERENCES `manufacturing_ecm`.`logistics`.`packaging`(`packaging_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ADD CONSTRAINT `fk_logistics_carrier_service_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_route_id` FOREIGN KEY (`route_id`) REFERENCES `manufacturing_ecm`.`logistics`.`route`(`route_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_transport_plan_id` FOREIGN KEY (`transport_plan_id`) REFERENCES `manufacturing_ecm`.`logistics`.`transport_plan`(`transport_plan_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ADD CONSTRAINT `fk_logistics_transport_plan_route_id` FOREIGN KEY (`route_id`) REFERENCES `manufacturing_ecm`.`logistics`.`route`(`route_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ADD CONSTRAINT `fk_logistics_route_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`logistics`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ADD CONSTRAINT `fk_logistics_route_transport_zone_id` FOREIGN KEY (`transport_zone_id`) REFERENCES `manufacturing_ecm`.`logistics`.`transport_zone`(`transport_zone_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ADD CONSTRAINT `fk_logistics_route_stop_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`logistics`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ADD CONSTRAINT `fk_logistics_route_stop_route_id` FOREIGN KEY (`route_id`) REFERENCES `manufacturing_ecm`.`logistics`.`route`(`route_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `manufacturing_ecm`.`logistics`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_route_id` FOREIGN KEY (`route_id`) REFERENCES `manufacturing_ecm`.`logistics`.`route`(`route_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ADD CONSTRAINT `fk_logistics_logistics_inbound_delivery_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ADD CONSTRAINT `fk_logistics_logistics_inbound_delivery_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `manufacturing_ecm`.`logistics`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ADD CONSTRAINT `fk_logistics_logistics_inbound_delivery_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`logistics`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ADD CONSTRAINT `fk_logistics_tracking_event_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ADD CONSTRAINT `fk_logistics_tracking_event_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`logistics`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ADD CONSTRAINT `fk_logistics_freight_rate_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ADD CONSTRAINT `fk_logistics_freight_rate_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ADD CONSTRAINT `fk_logistics_freight_rate_freight_contract_id` FOREIGN KEY (`freight_contract_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_contract`(`freight_contract_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ADD CONSTRAINT `fk_logistics_freight_rate_transport_zone_id` FOREIGN KEY (`transport_zone_id`) REFERENCES `manufacturing_ecm`.`logistics`.`transport_zone`(`transport_zone_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_freight_contract_id` FOREIGN KEY (`freight_contract_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_contract`(`freight_contract_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_freight_order_id` FOREIGN KEY (`freight_order_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_order`(`freight_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ADD CONSTRAINT `fk_logistics_freight_audit_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ADD CONSTRAINT `fk_logistics_freight_audit_freight_invoice_id` FOREIGN KEY (`freight_invoice_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_invoice`(`freight_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ADD CONSTRAINT `fk_logistics_freight_audit_freight_rate_id` FOREIGN KEY (`freight_rate_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_rate`(`freight_rate_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ADD CONSTRAINT `fk_logistics_trade_document_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `manufacturing_ecm`.`logistics`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ADD CONSTRAINT `fk_logistics_load_unit_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ADD CONSTRAINT `fk_logistics_load_unit_delivery_id` FOREIGN KEY (`delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`delivery`(`delivery_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ADD CONSTRAINT `fk_logistics_load_unit_packaging_id` FOREIGN KEY (`packaging_id`) REFERENCES `manufacturing_ecm`.`logistics`.`packaging`(`packaging_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ADD CONSTRAINT `fk_logistics_carrier_performance_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ADD CONSTRAINT `fk_logistics_carrier_performance_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ADD CONSTRAINT `fk_logistics_carrier_performance_freight_contract_id` FOREIGN KEY (`freight_contract_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_contract`(`freight_contract_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ADD CONSTRAINT `fk_logistics_delivery_performance_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ADD CONSTRAINT `fk_logistics_delivery_performance_delivery_id` FOREIGN KEY (`delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`delivery`(`delivery_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ADD CONSTRAINT `fk_logistics_freight_claim_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ADD CONSTRAINT `fk_logistics_location_transport_zone_id` FOREIGN KEY (`transport_zone_id`) REFERENCES `manufacturing_ecm`.`logistics`.`transport_zone`(`transport_zone_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_logistics_dangerous_goods_declaration_freight_order_id` FOREIGN KEY (`freight_order_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_order`(`freight_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ADD CONSTRAINT `fk_logistics_carrier_service_agreement_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` ADD CONSTRAINT `fk_logistics_carrier_qualification_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ADD CONSTRAINT `fk_logistics_carrier_territory_coverage_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` ADD CONSTRAINT `fk_logistics_parts_inventory_position_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`logistics`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` ADD CONSTRAINT `fk_logistics_parts_inventory_position_logistics_location_id` FOREIGN KEY (`logistics_location_id`) REFERENCES `manufacturing_ecm`.`logistics`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` ADD CONSTRAINT `fk_logistics_route_supplier_pickup_route_id` FOREIGN KEY (`route_id`) REFERENCES `manufacturing_ecm`.`logistics`.`route`(`route_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`logistics` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `manufacturing_ecm`.`logistics` SET TAGS ('dbx_domain' = 'logistics');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` SET TAGS ('dbx_subdomain' = 'freight_execution');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `shipment_item_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Item ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `batch_id` SET TAGS ('dbx_business_glossary_term' = 'Batch Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `lot_batch_id` SET TAGS ('dbx_business_glossary_term' = 'Lot Batch Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `packaging_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `serialized_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Serialized Unit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `stock_position_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Position Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin (COO)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `customs_value` SET TAGS ('dbx_business_glossary_term' = 'Customs Declared Value');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `customs_value` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `customs_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `customs_value_currency` SET TAGS ('dbx_business_glossary_term' = 'Customs Value Currency');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `customs_value_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `delivery_document_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Document Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification Number (ECCN)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_value_regex' = 'EAR99|ECCN [A-Z][0-9][A-Z][0-9]{3}|NLR|AT|NS|MT|CB|CC|EI|RS|SL|SS|FC|UN|AT');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `goods_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `goods_issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `hazmat_class` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (Hazmat) Class');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `hazmat_class` SET TAGS ('dbx_value_regex' = '1|1.1|1.2|1.3|1.4|1.5|1.6|2.1|2.2|2.3|3|4.1|4.2|4.3|5.1|5.2|6.1|6.2|7|8|9');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `hs_code` SET TAGS ('dbx_business_glossary_term' = 'Harmonized System (HS) Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `hs_code` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `is_hazardous` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `is_hazardous` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `is_reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'REACH Compliance Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `is_reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `is_rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'RoHS Compliance Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `is_rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `item_status` SET TAGS ('dbx_business_glossary_term' = 'Shipment Item Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `item_status` SET TAGS ('dbx_value_regex' = 'PLANNED|PICKED|PACKED|GOODS_ISSUED|IN_TRANSIT|DELIVERED|PARTIALLY_DELIVERED|RETURNED|CANCELLED');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Shipment Item Line Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `line_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `net_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Net Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `net_weight_kg` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `package_count` SET TAGS ('dbx_business_glossary_term' = 'Package Count');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `package_count` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `promised_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Promised Delivery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `promised_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `quantity_ordered` SET TAGS ('dbx_business_glossary_term' = 'Quantity Ordered');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `quantity_ordered` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `quantity_shipped` SET TAGS ('dbx_business_glossary_term' = 'Quantity Shipped');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `quantity_shipped` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `sales_order_line_number` SET TAGS ('dbx_business_glossary_term' = 'Sales Order (SO) Line Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `sales_order_line_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `sales_order_number` SET TAGS ('dbx_business_glossary_term' = 'Sales Order (SO) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `sku_code` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `special_handling_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Instructions');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `temperature_requirement` SET TAGS ('dbx_business_glossary_term' = 'Temperature Requirement');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `temperature_requirement` SET TAGS ('dbx_value_regex' = 'AMBIENT|CHILLED|FROZEN|CONTROLLED_ROOM_TEMP|DEEP_FROZEN');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'UN Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|LB|M|M2|M3|L|PC|SET|BOX|PAL|ROL|MTR|TON');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Unit Price');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `unit_price` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `unit_price_currency` SET TAGS ('dbx_business_glossary_term' = 'Unit Price Currency');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `unit_price_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Volume (m³)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `volume_m3` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `api_integration_type` SET TAGS ('dbx_business_glossary_term' = 'Carrier API Integration Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `api_integration_type` SET TAGS ('dbx_value_regex' = 'rest_api|soap_api|edi|flat_file|portal_only|none');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Carrier Approval Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `cargo_liability_limit` SET TAGS ('dbx_business_glossary_term' = 'Cargo Liability Limit');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `cargo_liability_limit` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `claims_ratio` SET TAGS ('dbx_business_glossary_term' = 'Freight Claims Ratio (%)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `claims_ratio` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Carrier Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract End Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Carrier Contract Reference Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Start Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `country_of_registration` SET TAGS ('dbx_business_glossary_term' = 'Country of Registration');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `country_of_registration` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `customs_broker_license` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker License Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `dot_number` SET TAGS ('dbx_business_glossary_term' = 'US Department of Transportation (DOT) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `dot_number` SET TAGS ('dbx_value_regex' = '^[0-9]{6,8}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `duns_number` SET TAGS ('dbx_business_glossary_term' = 'Data Universal Numbering System (DUNS) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `duns_number` SET TAGS ('dbx_value_regex' = '^[0-9]{9}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `edi_capable` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Capable Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `edi_capable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `edi_qualifier` SET TAGS ('dbx_business_glossary_term' = 'EDI Interchange Qualifier');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `geographic_coverage` SET TAGS ('dbx_business_glossary_term' = 'Geographic Coverage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `hazmat_certified` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Certified Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `hazmat_certified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `headquarters_city` SET TAGS ('dbx_business_glossary_term' = 'Headquarters City');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `headquarters_country` SET TAGS ('dbx_business_glossary_term' = 'Headquarters Country');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `headquarters_country` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `iata_code` SET TAGS ('dbx_business_glossary_term' = 'International Air Transport Association (IATA) Carrier Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `iata_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `insurance_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Insurance Certificate Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `insurance_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Insurance Certificate Expiry Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `insurance_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Carrier Review Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `last_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `legal_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Legal Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `liability_currency` SET TAGS ('dbx_business_glossary_term' = 'Liability Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `liability_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `mc_number` SET TAGS ('dbx_business_glossary_term' = 'Motor Carrier (MC) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `mc_number` SET TAGS ('dbx_value_regex' = '^MC-?[0-9]{6,8}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Review Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `on_time_delivery_rate` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery Rate (%)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `on_time_delivery_rate` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `performance_tier` SET TAGS ('dbx_business_glossary_term' = 'Carrier Performance Tier');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `performance_tier` SET TAGS ('dbx_value_regex' = 'preferred|approved|conditional|probationary|disqualified');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Email Address');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Phone Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_value_regex' = '^+?[0-9s-().]{7,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `safety_rating` SET TAGS ('dbx_business_glossary_term' = 'FMCSA Safety Rating');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `safety_rating` SET TAGS ('dbx_value_regex' = 'satisfactory|conditional|unsatisfactory|not_rated');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `scac_code` SET TAGS ('dbx_business_glossary_term' = 'Standard Carrier Alpha Code (SCAC)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `scac_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `service_modes` SET TAGS ('dbx_business_glossary_term' = 'Service Modes Offered');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Carrier Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|pending_approval|blacklisted|under_review');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `tracking_url_template` SET TAGS ('dbx_business_glossary_term' = 'Shipment Tracking URL Template');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `trade_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Trade Name (DBA)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|air|ocean|intermodal|courier|pipeline');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Carrier Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'asset_based|non_asset_based|freight_broker|3pl|4pl|nvocc|freight_forwarder|postal_courier|intermodal');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `applicable_surcharge_types` SET TAGS ('dbx_business_glossary_term' = 'Applicable Surcharge Types');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Carrier Contract Reference');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `contract_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `customs_clearance_included` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Included');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `customs_clearance_included` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `cutoff_time` SET TAGS ('dbx_business_glossary_term' = 'Carrier Cut-Off Time');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `cutoff_time` SET TAGS ('dbx_value_regex' = '^([01]d|2[0-3]):[0-5]d$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `cutoff_timezone` SET TAGS ('dbx_business_glossary_term' = 'Cut-Off Time Zone');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `delivery_days` SET TAGS ('dbx_business_glossary_term' = 'Carrier Delivery Days');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `destination_region` SET TAGS ('dbx_business_glossary_term' = 'Destination Region');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `dim_weight_factor` SET TAGS ('dbx_business_glossary_term' = 'Dimensional Weight Factor (DIM Factor)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `dim_weight_factor` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Service Effective Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Service Expiry Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `fuel_surcharge_basis` SET TAGS ('dbx_business_glossary_term' = 'Fuel Surcharge Basis');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `fuel_surcharge_basis` SET TAGS ('dbx_value_regex' = 'percentage_of_base_rate|flat_per_shipment|flat_per_kg|index_linked');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `hazmat_capable` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Capable');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `hazmat_capable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `incoterms_supported` SET TAGS ('dbx_business_glossary_term' = 'Supported Incoterms');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_business_glossary_term' = 'Last Reviewed Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `liability_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Liability Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `liability_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `liability_limit_amount` SET TAGS ('dbx_business_glossary_term' = 'Carrier Liability Limit Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `liability_limit_amount` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `max_length_cm` SET TAGS ('dbx_business_glossary_term' = 'Maximum Shipment Length (cm)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `max_length_cm` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `max_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Maximum Shipment Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `max_weight_kg` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `on_time_delivery_target_pct` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery Target Percentage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `on_time_delivery_target_pct` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `origin_region` SET TAGS ('dbx_business_glossary_term' = 'Origin Region');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `pickup_days` SET TAGS ('dbx_business_glossary_term' = 'Carrier Pickup Days');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `proof_of_delivery_type` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `proof_of_delivery_type` SET TAGS ('dbx_value_regex' = 'electronic|paper|signature_required|photo|none');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `service_code` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `service_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,30}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `service_level` SET TAGS ('dbx_business_glossary_term' = 'Service Level');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `service_level` SET TAGS ('dbx_value_regex' = 'standard|economy|express|priority|overnight|same_day|deferred');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `service_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'LTL|FTL|parcel|express_parcel|ocean_FCL|ocean_LCL|air_freight|intermodal|rail|courier|last_mile');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|pending_approval|discontinued');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `temperature_controlled` SET TAGS ('dbx_business_glossary_term' = 'Temperature Controlled Service');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `temperature_controlled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `tracking_capability` SET TAGS ('dbx_business_glossary_term' = 'Shipment Tracking Capability');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `tracking_capability` SET TAGS ('dbx_value_regex' = 'real_time|milestone|end_to_end|none');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `transit_time_basis` SET TAGS ('dbx_business_glossary_term' = 'Transit Time Basis');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `transit_time_basis` SET TAGS ('dbx_value_regex' = 'business_days|calendar_days');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `transit_time_days_max` SET TAGS ('dbx_business_glossary_term' = 'Maximum Transit Time (Days)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `transit_time_days_max` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `transit_time_days_min` SET TAGS ('dbx_business_glossary_term' = 'Minimum Transit Time (Days)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `transit_time_days_min` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|ocean|air|rail|intermodal|courier');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` SET TAGS ('dbx_subdomain' = 'freight_execution');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `freight_order_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Order ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `carrier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `production_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `route_id` SET TAGS ('dbx_business_glossary_term' = 'Route Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `sales_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `transport_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `actual_delivery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `actual_delivery_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `actual_pickup_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Pickup Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `actual_pickup_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `carrier_booking_reference` SET TAGS ('dbx_business_glossary_term' = 'Carrier Booking Reference');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `carrier_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `confirmed_freight_cost` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Freight Cost');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `confirmed_freight_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Freight Order Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `customs_declaration_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `destination_location_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Location Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `estimated_freight_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Freight Cost');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `estimated_freight_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `export_license_number` SET TAGS ('dbx_business_glossary_term' = 'Export License Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `hazmat_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (Hazmat) Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `hazmat_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `hazmat_un_number` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials UN Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `hazmat_un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Named Place or Port');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Freight Order Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `loading_meters` SET TAGS ('dbx_business_glossary_term' = 'Loading Meters (LDM)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Freight Order Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^FO-[0-9]{4}-[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `order_type` SET TAGS ('dbx_business_glossary_term' = 'Freight Order Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `order_type` SET TAGS ('dbx_value_regex' = 'inbound|outbound|interplant|return|cross_dock|drop_shipment');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `origin_location_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Location Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `package_count` SET TAGS ('dbx_business_glossary_term' = 'Package Count');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `package_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `planned_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Delivery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `planned_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `planned_delivery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Delivery Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `planned_delivery_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `planned_pickup_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Pickup Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `planned_pickup_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `planned_pickup_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Pickup Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `planned_pickup_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `pro_number` SET TAGS ('dbx_business_glossary_term' = 'Progressive (PRO) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `required_temp_max_c` SET TAGS ('dbx_business_glossary_term' = 'Required Maximum Temperature (°C)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `required_temp_min_c` SET TAGS ('dbx_business_glossary_term' = 'Required Minimum Temperature (°C)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `service_level` SET TAGS ('dbx_business_glossary_term' = 'Transport Service Level');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `service_level` SET TAGS ('dbx_value_regex' = 'standard|express|overnight|economy|same_day|deferred|priority');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_TM|SAP_SD|INFOR_WMS|MANUAL|EDI');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `special_handling_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Instructions');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Freight Order Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|confirmed|in_transit|delivered|cancelled|on_hold|rejected');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `temperature_controlled_flag` SET TAGS ('dbx_business_glossary_term' = 'Temperature Controlled Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `temperature_controlled_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|air|ocean|multimodal|courier|parcel');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Volume (m³)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` SET TAGS ('dbx_subdomain' = 'freight_execution');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `transport_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Plan ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `application_id` SET TAGS ('dbx_business_glossary_term' = 'Planning Application Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `route_id` SET TAGS ('dbx_business_glossary_term' = 'Route Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `confirmed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Plan Confirmed Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `confirmed_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Plan Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `customs_required` SET TAGS ('dbx_business_glossary_term' = 'Customs Required Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `customs_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `destination_region` SET TAGS ('dbx_business_glossary_term' = 'Destination Region');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `drp_run_reference` SET TAGS ('dbx_business_glossary_term' = 'Distribution Requirements Planning (DRP) Run Reference');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `freight_budget_code` SET TAGS ('dbx_business_glossary_term' = 'Freight Budget Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `hazmat_included` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Included Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `hazmat_included` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Transport Plan Notes');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `optimization_objective` SET TAGS ('dbx_business_glossary_term' = 'Optimization Objective');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `optimization_objective` SET TAGS ('dbx_value_regex' = 'cost|time|co2_emissions|balanced');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `origin_region` SET TAGS ('dbx_business_glossary_term' = 'Origin Region');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Transport Plan Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Transport Plan Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_value_regex' = '^TP-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Transport Plan Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'inbound|outbound|interplant|cross_dock|return');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `plan_version` SET TAGS ('dbx_business_glossary_term' = 'Transport Plan Version');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `plan_version` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planned_carrier_count` SET TAGS ('dbx_business_glossary_term' = 'Planned Carrier Count');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planned_carrier_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planned_co2_emissions_kg` SET TAGS ('dbx_business_glossary_term' = 'Planned CO2 Emissions (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planned_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Delivery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planned_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planned_departure_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Departure Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planned_departure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planned_freight_spend` SET TAGS ('dbx_business_glossary_term' = 'Planned Freight Spend');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planned_freight_spend` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planned_load_count` SET TAGS ('dbx_business_glossary_term' = 'Planned Load Count');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planned_load_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planned_shipment_count` SET TAGS ('dbx_business_glossary_term' = 'Planned Shipment Count');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planned_shipment_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planned_volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Planned Volume (m³)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planned_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Planned Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planning_horizon_end_date` SET TAGS ('dbx_business_glossary_term' = 'Planning Horizon End Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planning_horizon_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planning_horizon_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planning Horizon Start Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planning_horizon_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `planning_organization` SET TAGS ('dbx_business_glossary_term' = 'Planning Organization');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `primary_carrier_name` SET TAGS ('dbx_business_glossary_term' = 'Primary Carrier Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `service_level` SET TAGS ('dbx_business_glossary_term' = 'Service Level');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `service_level` SET TAGS ('dbx_value_regex' = 'standard|express|economy|priority|deferred');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Transport Plan Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|confirmed|in_execution|executed|cancelled|on_hold');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `tms_plan_reference` SET TAGS ('dbx_business_glossary_term' = 'Transportation Management System (TMS) Plan Reference');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|air|ocean|intermodal|courier');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` SET TAGS ('dbx_subdomain' = 'network_planning');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `route_id` SET TAGS ('dbx_business_glossary_term' = 'Route ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `application_id` SET TAGS ('dbx_business_glossary_term' = 'Optimization Application Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Logistics Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Planner Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `transport_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Zone Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `border_crossing_count` SET TAGS ('dbx_business_glossary_term' = 'Border Crossing Count');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `border_crossing_count` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `co2_emission_factor_kg_per_km` SET TAGS ('dbx_business_glossary_term' = 'CO2 Emission Factor (Kilograms per Kilometer)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `co2_emission_factor_kg_per_km` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Route Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `customs_required` SET TAGS ('dbx_business_glossary_term' = 'Customs Required Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `customs_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `cutoff_time` SET TAGS ('dbx_business_glossary_term' = 'Shipment Cutoff Time');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `cutoff_time` SET TAGS ('dbx_value_regex' = '^([01][0-9]|2[0-3]):[0-5][0-9]$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `departure_days` SET TAGS ('dbx_business_glossary_term' = 'Departure Days');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Route Description');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `destination_location_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Location Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `destination_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `distance_km` SET TAGS ('dbx_business_glossary_term' = 'Route Distance (Kilometers)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `distance_km` SET TAGS ('dbx_value_regex' = '^[0-9]{1,7}(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `distance_miles` SET TAGS ('dbx_business_glossary_term' = 'Route Distance (Miles)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `distance_miles` SET TAGS ('dbx_value_regex' = '^[0-9]{1,7}(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Route Effective Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Route Expiry Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `frequency` SET TAGS ('dbx_business_glossary_term' = 'Route Frequency');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `frequency` SET TAGS ('dbx_value_regex' = 'daily|weekly|bi_weekly|monthly|on_demand|scheduled');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `hazmat_permitted` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Permitted Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `hazmat_permitted` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `max_volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Maximum Payload Volume (Cubic Meters)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `max_volume_m3` SET TAGS ('dbx_value_regex' = '^[0-9]{1,9}(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `max_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Maximum Payload Weight (Kilograms)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `max_weight_kg` SET TAGS ('dbx_value_regex' = '^[0-9]{1,9}(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `maximum_transit_days` SET TAGS ('dbx_business_glossary_term' = 'Maximum Transit Days');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `maximum_transit_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `minimum_transit_days` SET TAGS ('dbx_business_glossary_term' = 'Minimum Transit Days');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `minimum_transit_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Route Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `origin_location_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Location Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `origin_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `preferred_carrier_code` SET TAGS ('dbx_business_glossary_term' = 'Preferred Carrier Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `preferred_carrier_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Logistics Region Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `secondary_carrier_code` SET TAGS ('dbx_business_glossary_term' = 'Secondary Carrier Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `secondary_carrier_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'standard|express|economy|priority|deferred|same_day|next_day');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `standard_freight_cost` SET TAGS ('dbx_business_glossary_term' = 'Standard Freight Cost');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `standard_freight_cost` SET TAGS ('dbx_value_regex' = '^[0-9]{1,14}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `standard_freight_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `standard_transit_days` SET TAGS ('dbx_business_glossary_term' = 'Standard Transit Days');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `standard_transit_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Route Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|under_review|discontinued');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `temperature_controlled` SET TAGS ('dbx_business_glossary_term' = 'Temperature Controlled Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `temperature_controlled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `tms_route_code` SET TAGS ('dbx_business_glossary_term' = 'Transportation Management System (TMS) Route ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `tms_route_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,50}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `toll_applicable` SET TAGS ('dbx_business_glossary_term' = 'Toll Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `toll_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `transit_hub_code` SET TAGS ('dbx_business_glossary_term' = 'Transit Hub Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `transit_hub_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|ocean|air|intermodal|multimodal|courier|pipeline');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Route Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'direct|hub_and_spoke|multimodal|relay|milk_run|cross_dock');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` SET TAGS ('dbx_subdomain' = 'network_planning');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `route_stop_id` SET TAGS ('dbx_business_glossary_term' = 'Route Stop Identifier');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `address_id` SET TAGS ('dbx_business_glossary_term' = 'Address Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `address_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `address_id` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Logistics Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `route_id` SET TAGS ('dbx_business_glossary_term' = 'Route Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `actual_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Departure Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `actual_departure_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `actual_dwell_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Actual Dwell Time (Minutes)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `actual_dwell_time_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `actual_load_quantity` SET TAGS ('dbx_business_glossary_term' = 'Actual Load Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `actual_load_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `actual_unload_quantity` SET TAGS ('dbx_business_glossary_term' = 'Actual Unload Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `actual_unload_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `appointment_reference` SET TAGS ('dbx_business_glossary_term' = 'Appointment Reference Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `arrival_variance_minutes` SET TAGS ('dbx_business_glossary_term' = 'Arrival Variance (Minutes)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `arrival_variance_minutes` SET TAGS ('dbx_value_regex' = '^-?[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `customs_clearance_required` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Required Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `customs_clearance_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `customs_declaration_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `dock_door_number` SET TAGS ('dbx_business_glossary_term' = 'Dock Door Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `geofence_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Geofence Arrival Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `geofence_arrival_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `geofence_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Geofence Departure Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `geofence_departure_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `is_first_stop` SET TAGS ('dbx_business_glossary_term' = 'First Stop Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `is_first_stop` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `is_last_stop` SET TAGS ('dbx_business_glossary_term' = 'Last Stop Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `is_last_stop` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `is_time_window_met` SET TAGS ('dbx_business_glossary_term' = 'Time Window Met Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `is_time_window_met` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `location_code` SET TAGS ('dbx_business_glossary_term' = 'Location Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,30}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `location_type` SET TAGS ('dbx_business_glossary_term' = 'Location Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `location_type` SET TAGS ('dbx_value_regex' = 'plant|warehouse|distribution_center|customer_site|port|airport|rail_terminal|customs_office|cross_dock_facility|supplier_site|service_center');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `planned_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Arrival Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `planned_arrival_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `planned_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Departure Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `planned_departure_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `planned_dwell_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Planned Dwell Time (Minutes)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `planned_dwell_time_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `planned_load_quantity` SET TAGS ('dbx_business_glossary_term' = 'Planned Load Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `planned_load_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `planned_unload_quantity` SET TAGS ('dbx_business_glossary_term' = 'Planned Unload Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `planned_unload_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `proof_of_delivery_number` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|LB|MT|L|GAL|M3|FT3|PLT|CTN|PKG');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `receiver_name` SET TAGS ('dbx_business_glossary_term' = 'Receiver Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `receiver_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Identifier');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `special_handling_code` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `special_handling_code` SET TAGS ('dbx_value_regex' = 'NONE|HAZMAT|TEMPERATURE_CONTROLLED|FRAGILE|OVERSIZED|HIGH_VALUE|BONDED|PERISHABLE|LIVE_ANIMALS|PHARMACEUTICAL');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `stop_distance_km` SET TAGS ('dbx_business_glossary_term' = 'Stop Distance (Kilometers)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `stop_distance_km` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `stop_exception_code` SET TAGS ('dbx_business_glossary_term' = 'Stop Exception Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `stop_exception_code` SET TAGS ('dbx_value_regex' = 'NONE|LATE_ARRIVAL|EARLY_ARRIVAL|MISSED_STOP|REFUSED_DELIVERY|PARTIAL_DELIVERY|DAMAGED_GOODS|ACCESS_DENIED|WEATHER_DELAY|TRAFFIC_DELAY|MECHANICAL_BREAKDOWN|CUSTOMS_HOLD|OTHER');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `stop_exception_notes` SET TAGS ('dbx_business_glossary_term' = 'Stop Exception Notes');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `stop_sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Stop Sequence Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `stop_sequence_number` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `stop_status` SET TAGS ('dbx_business_glossary_term' = 'Stop Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `stop_status` SET TAGS ('dbx_value_regex' = 'planned|in_transit|arrived|completed|skipped|delayed|cancelled');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `stop_type` SET TAGS ('dbx_business_glossary_term' = 'Stop Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `stop_type` SET TAGS ('dbx_value_regex' = 'pickup|delivery|cross_dock|customs|consolidation|deconsolidation|fuel|rest|inspection|return');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `time_window_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Delivery Time Window End Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `time_window_end_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `time_window_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Delivery Time Window Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ALTER COLUMN `time_window_start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` SET TAGS ('dbx_subdomain' = 'freight_execution');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `address_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `address_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `address_id` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `carrier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Contact Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `pick_task_id` SET TAGS ('dbx_business_glossary_term' = 'Pick Task Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `route_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Ship To Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `actual_ship_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Ship Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `actual_ship_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Delivery Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `export_license_number` SET TAGS ('dbx_business_glossary_term' = 'Export License Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `freight_terms` SET TAGS ('dbx_business_glossary_term' = 'Freight Terms');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `freight_terms` SET TAGS ('dbx_value_regex' = 'prepaid|collect|third_party|prepaid_and_add');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `goods_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue Posting Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `goods_issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `goods_issue_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `goods_issue_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `hazmat_indicator` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (Hazmat) Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `hazmat_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Location');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `last_changed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Changed Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `last_changed_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Document Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `over_ship_quantity` SET TAGS ('dbx_business_glossary_term' = 'Over-Ship Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `over_ship_quantity` SET TAGS ('dbx_value_regex' = '^d{1,15}(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `overall_goods_movement_status` SET TAGS ('dbx_business_glossary_term' = 'Overall Goods Movement Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `overall_goods_movement_status` SET TAGS ('dbx_value_regex' = 'not_started|partial|complete');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `packing_list_number` SET TAGS ('dbx_business_glossary_term' = 'Packing List Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `packing_list_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,30}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `packing_status` SET TAGS ('dbx_business_glossary_term' = 'Packing Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `packing_status` SET TAGS ('dbx_value_regex' = 'not_started|partial|complete');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `picking_status` SET TAGS ('dbx_business_glossary_term' = 'Picking Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `picking_status` SET TAGS ('dbx_value_regex' = 'not_started|partial|complete');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `planned_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Delivery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `planned_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `planned_ship_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Ship Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `planned_ship_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `pod_date` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `pod_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `pod_reference` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) Reference');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `pod_reference` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-_]{1,50}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Delivery Priority Level');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'standard|express|urgent|critical');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `ship_from_country_code` SET TAGS ('dbx_business_glossary_term' = 'Ship-From Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `ship_from_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `ship_to_country_code` SET TAGS ('dbx_business_glossary_term' = 'Ship-To Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `ship_to_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `shipping_point` SET TAGS ('dbx_business_glossary_term' = 'Shipping Point');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `shipping_point` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `short_ship_quantity` SET TAGS ('dbx_business_glossary_term' = 'Short-Ship Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `short_ship_quantity` SET TAGS ('dbx_value_regex' = '^d{1,15}(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Identifier');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `source_system_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-_]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Delivery Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'created|picking_in_progress|picked|packing_in_progress|packed|goods_issue_posted|in_transit|delivered|pod_confirmed|cancelled|short_shipped|over_shipped');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `total_delivery_quantity` SET TAGS ('dbx_business_glossary_term' = 'Total Delivery Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `total_delivery_quantity` SET TAGS ('dbx_value_regex' = '^d{1,15}(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `total_gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Total Gross Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `total_gross_weight_kg` SET TAGS ('dbx_value_regex' = '^d{1,15}(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `total_net_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Total Net Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `total_net_weight_kg` SET TAGS ('dbx_value_regex' = '^d{1,15}(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `total_volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Total Volume (m³)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `total_volume_m3` SET TAGS ('dbx_value_regex' = '^d{1,14}(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Carrier Tracking Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|air|sea|multimodal|courier|intermodal');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Delivery Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'outbound_customer|interplant_transfer|distribution_center|return_delivery|subcontractor');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'UN Dangerous Goods Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UNd{4}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` SET TAGS ('dbx_subdomain' = 'freight_execution');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `logistics_inbound_delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `lab_resource_id` SET TAGS ('dbx_business_glossary_term' = 'Lab Resource Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `production_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Receiving Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Receiving Logistics Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `returns_order_id` SET TAGS ('dbx_business_glossary_term' = 'Returns Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `delivery_number` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `delivery_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,35}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `delivery_type` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `delivery_type` SET TAGS ('dbx_value_regex' = 'STANDARD|RETURN|SUBCONTRACTING|CONSIGNMENT|INTERCOMPANY|THIRD_PARTY');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `delivery_value` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Value');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `delivery_value` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `delivery_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `discrepancy_flag` SET TAGS ('dbx_business_glossary_term' = 'Discrepancy Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `discrepancy_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `discrepancy_type` SET TAGS ('dbx_business_glossary_term' = 'Discrepancy Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `discrepancy_type` SET TAGS ('dbx_value_regex' = 'QUANTITY_SHORTAGE|QUANTITY_OVERAGE|DAMAGED_GOODS|WRONG_MATERIAL|DOCUMENTATION_MISSING|QUALITY_REJECTION|NONE');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `expected_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Expected Delivery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `expected_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `goods_receipt_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `goods_receipt_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `grn_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Note (GRN) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `grn_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `grn_posting_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Note (GRN) Posting Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `grn_posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `material_type` SET TAGS ('dbx_business_glossary_term' = 'Material Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `material_type` SET TAGS ('dbx_value_regex' = 'RAW_MATERIAL|COMPONENT|SEMI_FINISHED|FINISHED_GOOD|MRO|PACKAGING|SPARE_PART');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `net_price` SET TAGS ('dbx_business_glossary_term' = 'Net Price per Unit');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `net_price` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `net_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `open_quantity` SET TAGS ('dbx_business_glossary_term' = 'Open (Outstanding) Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `open_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `ordered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Ordered Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `ordered_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `quality_inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Required Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `quality_inspection_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `quality_inspection_status` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `quality_inspection_status` SET TAGS ('dbx_value_regex' = 'NOT_REQUIRED|PENDING|IN_PROGRESS|PASSED|FAILED|CONDITIONALLY_RELEASED');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `received_quantity` SET TAGS ('dbx_business_glossary_term' = 'Received Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `received_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `serial_number_range` SET TAGS ('dbx_business_glossary_term' = 'Serial Number Range');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'PLANNED|IN_TRANSIT|ARRIVED|PARTIALLY_RECEIVED|FULLY_RECEIVED|CANCELLED|ON_HOLD|DISCREPANCY_REVIEW');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `storage_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `supplier_delivery_note` SET TAGS ('dbx_business_glossary_term' = 'Supplier Delivery Note Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Shipment Tracking Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|LB|M|M2|M3|L|PC|BOX|PALLET|ROLL|SET');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `warehouse_number` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ALTER COLUMN `warehouse_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` SET TAGS ('dbx_subdomain' = 'freight_execution');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `tracking_event_id` SET TAGS ('dbx_business_glossary_term' = 'Tracking Event ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Logistics Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Recorded By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `ot_system_id` SET TAGS ('dbx_business_glossary_term' = 'Source Ot System Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `actual_delivery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `actual_delivery_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `carrier_event_code` SET TAGS ('dbx_business_glossary_term' = 'Carrier Event Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `carrier_event_description` SET TAGS ('dbx_business_glossary_term' = 'Carrier Event Description');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `carrier_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `customs_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Reference Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `customs_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `customs_status` SET TAGS ('dbx_value_regex' = 'not_applicable|pending|under_review|cleared|held|rejected');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `dwell_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Dwell Time (Minutes)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `estimated_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated Delivery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `estimated_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `event_source` SET TAGS ('dbx_business_glossary_term' = 'Event Source');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `event_source` SET TAGS ('dbx_value_regex' = 'carrier_edi|tms|gps_telematics|iiot_sensor|manual|api_integration|wms');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Event Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `event_timezone` SET TAGS ('dbx_business_glossary_term' = 'Event Timezone');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `event_type` SET TAGS ('dbx_business_glossary_term' = 'Tracking Event Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `event_type` SET TAGS ('dbx_value_regex' = 'departed|in_transit|arrived|customs_cleared|out_for_delivery|delivered|exception|returned|attempted_delivery|held|cancelled');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `exception_code` SET TAGS ('dbx_business_glossary_term' = 'Exception Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `exception_code` SET TAGS ('dbx_value_regex' = 'delay|damage|lost|refused|weather_hold|customs_hold|address_issue|attempted_delivery|carrier_delay|mechanical_failure|other');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `exception_description` SET TAGS ('dbx_business_glossary_term' = 'Exception Description');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `is_exception` SET TAGS ('dbx_business_glossary_term' = 'Exception Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `is_exception` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'GPS Latitude');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `latitude` SET TAGS ('dbx_value_regex' = '^-?(90(.0+)?|[1-8]?d(.d+)?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `location_code` SET TAGS ('dbx_business_glossary_term' = 'Location Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `location_type` SET TAGS ('dbx_business_glossary_term' = 'Location Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `location_type` SET TAGS ('dbx_value_regex' = 'origin|destination|transit_hub|port|customs_facility|carrier_depot|customer_site|warehouse|airport|rail_terminal');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'GPS Longitude');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `longitude` SET TAGS ('dbx_value_regex' = '^-?(180(.0+)?|1[0-7]d(.d+)?|[1-9]?d(.d+)?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `pod_reference` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) Reference');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `pro_number` SET TAGS ('dbx_business_glossary_term' = 'Progressive (PRO) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `raw_payload_reference` SET TAGS ('dbx_business_glossary_term' = 'Raw Payload Reference');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Event Sequence Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `signed_by` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery Signatory');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Record Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|superseded|cancelled|duplicate');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `temperature_c` SET TAGS ('dbx_business_glossary_term' = 'Ambient Temperature (Celsius)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Carrier Tracking Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|air|ocean|intermodal|courier|pipeline');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `vehicle_code` SET TAGS ('dbx_business_glossary_term' = 'Vehicle or Vessel ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `freight_rate_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Rate ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Product Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `freight_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `transport_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Transport Zone Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Rate Approved By');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Rate Approval Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `commodity_code` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code (NMFC / HS Code)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `commodity_code` SET TAGS ('dbx_value_regex' = '^[0-9]{4,10}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `commodity_type` SET TAGS ('dbx_business_glossary_term' = 'Commodity Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `destination_region` SET TAGS ('dbx_business_glossary_term' = 'Destination Region / Zone');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Rate Effective Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Rate Expiry Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `fuel_index_reference` SET TAGS ('dbx_business_glossary_term' = 'Fuel Index Reference');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `fuel_surcharge_pct` SET TAGS ('dbx_business_glossary_term' = 'Fuel Surcharge Percentage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `fuel_surcharge_pct` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `fuel_surcharge_pct` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `hazmat_eligible` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (Hazmat) Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `hazmat_eligible` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `incoterm_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `incoterm_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `lane_description` SET TAGS ('dbx_business_glossary_term' = 'Freight Lane Description');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `maximum_charge` SET TAGS ('dbx_business_glossary_term' = 'Maximum Freight Charge');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `maximum_charge` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `maximum_charge` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `minimum_charge` SET TAGS ('dbx_business_glossary_term' = 'Minimum Freight Charge');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `minimum_charge` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `minimum_charge` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `negotiated_by` SET TAGS ('dbx_business_glossary_term' = 'Rate Negotiated By');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `origin_region` SET TAGS ('dbx_business_glossary_term' = 'Origin Region / Zone');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Freight Rate Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `rate_amount` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `rate_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `rate_basis` SET TAGS ('dbx_business_glossary_term' = 'Freight Rate Basis (Unit of Measure)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `rate_basis` SET TAGS ('dbx_value_regex' = 'per_kg|per_lb|per_pallet|per_container|per_mile|per_km|per_cbm|per_shipment|per_piece|per_cwt|flat_rate|per_teu|per_feu');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `rate_number` SET TAGS ('dbx_business_glossary_term' = 'Freight Rate Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `rate_number` SET TAGS ('dbx_value_regex' = '^FR-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `rate_source` SET TAGS ('dbx_business_glossary_term' = 'Freight Rate Source');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `rate_source` SET TAGS ('dbx_value_regex' = 'contract|spot|benchmark|tariff|index|negotiated|spot_quote');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `rate_type` SET TAGS ('dbx_business_glossary_term' = 'Freight Rate Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `rate_type` SET TAGS ('dbx_value_regex' = 'base_rate|fuel_surcharge|accessorial|peak_surcharge|hazmat_surcharge|oversize_surcharge|residential_delivery|liftgate|inside_delivery|detention|demurrage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `service_level` SET TAGS ('dbx_business_glossary_term' = 'Freight Service Level');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `service_level` SET TAGS ('dbx_value_regex' = 'standard|express|overnight|same_day|economy|deferred|priority|ltl|ftl|fcl|lcl|next_day_air|second_day_air');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|INFOR_TMS|SAP_ARIBA|MANUAL|CARRIER_PORTAL|BENCHMARK_FEED');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Freight Rate Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|expired|pending_approval|superseded|draft');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `tariff_number` SET TAGS ('dbx_business_glossary_term' = 'Carrier Tariff Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `temperature_controlled` SET TAGS ('dbx_business_glossary_term' = 'Temperature Controlled Shipment Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `temperature_controlled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `transit_days` SET TAGS ('dbx_business_glossary_term' = 'Transit Days');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `transit_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transportation Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|ocean|air|intermodal|courier|parcel|barge|pipeline');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `weight_break_max_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight Break Maximum (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `weight_break_max_kg` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `weight_break_min_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight Break Minimum (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `weight_break_min_kg` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` SET TAGS ('dbx_subdomain' = 'financial_settlement');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `freight_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Invoice ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `ap_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ap Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Bill To Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `freight_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `freight_order_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `application_id` SET TAGS ('dbx_business_glossary_term' = 'Processing Application Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `accessorial_amount` SET TAGS ('dbx_business_glossary_term' = 'Accessorial Charges Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `accessorial_amount` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `accessorial_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `approved_amount` SET TAGS ('dbx_business_glossary_term' = 'Approved Payment Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `approved_amount` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `approved_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `audit_exception_code` SET TAGS ('dbx_business_glossary_term' = 'Freight Audit Exception Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `audit_status` SET TAGS ('dbx_business_glossary_term' = 'Freight Audit Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `audit_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|passed|failed|exception|waived');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `base_freight_amount` SET TAGS ('dbx_business_glossary_term' = 'Base Freight Charge Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `base_freight_amount` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `base_freight_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `billing_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Period End Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `billing_period_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `billing_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Period Start Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `billing_period_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `carrier_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Carrier Reference Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `carrier_tax_number` SET TAGS ('dbx_business_glossary_term' = 'Carrier Tax Identification Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `carrier_tax_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `dispute_resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `dispute_resolution_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Foreign Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_value_regex' = '^d+(.d{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `fuel_surcharge_amount` SET TAGS ('dbx_business_glossary_term' = 'Fuel Surcharge Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `fuel_surcharge_amount` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `fuel_surcharge_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `functional_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Functional Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `functional_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `invoice_type` SET TAGS ('dbx_business_glossary_term' = 'Invoice Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `invoice_type` SET TAGS ('dbx_value_regex' = 'standard|consolidated|credit_memo|debit_memo|corrected|supplemental');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `invoiced_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Invoiced Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `invoiced_amount` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `invoiced_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `invoiced_amount_functional` SET TAGS ('dbx_business_glossary_term' = 'Total Invoiced Amount in Functional Currency');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `invoiced_amount_functional` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `invoiced_amount_functional` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Invoice Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `is_intercompany` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `payment_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `payment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'ach|wire_transfer|check|credit_card|virtual_card|netting');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `payment_reference` SET TAGS ('dbx_business_glossary_term' = 'Payment Reference Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `pro_number` SET TAGS ('dbx_business_glossary_term' = 'Progressive (PRO) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `received_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Received Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `received_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `service_level` SET TAGS ('dbx_business_glossary_term' = 'Service Level');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `service_level` SET TAGS ('dbx_value_regex' = 'standard|expedited|overnight|two_day|ltl|ftl|deferred|economy');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'received|under_audit|disputed|approved|rejected|paid|partially_paid|cancelled|on_hold');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_value_regex' = '^-?d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|ocean|air|intermodal|courier|parcel');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` SET TAGS ('dbx_subdomain' = 'financial_settlement');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `freight_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Audit ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Auditor Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Invoice Billing Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `freight_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `freight_rate_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Rate Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `accessorial_charges_approved` SET TAGS ('dbx_business_glossary_term' = 'Accessorial Charges Approved');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `accessorial_charges_approved` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `accessorial_charges_invoiced` SET TAGS ('dbx_business_glossary_term' = 'Accessorial Charges Invoiced');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `accessorial_charges_invoiced` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `approved_amount` SET TAGS ('dbx_business_glossary_term' = 'Approved Freight Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `approved_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `audit_date` SET TAGS ('dbx_business_glossary_term' = 'Freight Audit Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `audit_number` SET TAGS ('dbx_business_glossary_term' = 'Freight Audit Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `audit_number` SET TAGS ('dbx_value_regex' = '^FA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `audit_status` SET TAGS ('dbx_business_glossary_term' = 'Freight Audit Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `audit_status` SET TAGS ('dbx_value_regex' = 'pending|in_review|approved|disputed|rejected|closed|on_hold');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `audit_type` SET TAGS ('dbx_business_glossary_term' = 'Freight Audit Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `audit_type` SET TAGS ('dbx_value_regex' = 'pre_payment|post_payment|spot_check|carrier_initiated|compliance_review');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `audited_by` SET TAGS ('dbx_business_glossary_term' = 'Audited By');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `audited_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Audit Completed Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `carrier_invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Carrier Invoice Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `contracted_amount` SET TAGS ('dbx_business_glossary_term' = 'Contracted Freight Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `contracted_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `credit_memo_number` SET TAGS ('dbx_business_glossary_term' = 'Carrier Credit Memo Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Invoice Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `dispute_raised_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Raised Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `dispute_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Freight Dispute Reference Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `dispute_resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `fuel_surcharge_invoiced` SET TAGS ('dbx_business_glossary_term' = 'Fuel Surcharge Invoiced');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `fuel_surcharge_invoiced` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `invoiced_amount` SET TAGS ('dbx_business_glossary_term' = 'Carrier Invoiced Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `invoiced_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `is_disputed` SET TAGS ('dbx_business_glossary_term' = 'Freight Invoice Dispute Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `is_disputed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `is_duplicate_invoice` SET TAGS ('dbx_business_glossary_term' = 'Duplicate Invoice Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `is_duplicate_invoice` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `payment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Freight Invoice Payment Due Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `payment_status` SET TAGS ('dbx_business_glossary_term' = 'Freight Invoice Payment Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `payment_status` SET TAGS ('dbx_value_regex' = 'unpaid|partially_paid|paid|on_hold|cancelled|overpaid');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `pro_number` SET TAGS ('dbx_business_glossary_term' = 'Progressive (PRO) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `resolution_outcome` SET TAGS ('dbx_business_glossary_term' = 'Freight Audit Resolution Outcome');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `resolution_outcome` SET TAGS ('dbx_value_regex' = 'accepted_as_invoiced|partial_credit|full_credit|carrier_corrected|written_off|escalated|no_action');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `service_level` SET TAGS ('dbx_business_glossary_term' = 'Freight Service Level');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `service_level` SET TAGS ('dbx_value_regex' = 'standard|expedited|overnight|two_day|ltl|ftl|deferred|economy');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|ocean|air|intermodal|courier|parcel');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `variance_amount` SET TAGS ('dbx_business_glossary_term' = 'Freight Audit Variance Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `variance_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `variance_percentage` SET TAGS ('dbx_business_glossary_term' = 'Freight Audit Variance Percentage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `variance_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Freight Audit Variance Reason Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `variance_reason_code` SET TAGS ('dbx_value_regex' = 'rate_discrepancy|weight_discrepancy|accessorial_charge|duplicate_invoice|incorrect_service_level|fuel_surcharge_error|dimensional_weight_error|address_correction|detention_charge|other');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ALTER COLUMN `variance_reason_description` SET TAGS ('dbx_business_glossary_term' = 'Freight Audit Variance Reason Description');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` SET TAGS ('dbx_subdomain' = 'trade_compliance');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `export_classification_id` SET TAGS ('dbx_business_glossary_term' = 'Export Classification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `application_id` SET TAGS ('dbx_business_glossary_term' = 'Filing Application Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Prepared By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `product_regulatory_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Certification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `amendment_reason` SET TAGS ('dbx_business_glossary_term' = 'Declaration Amendment Reason');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `ce_marking_required` SET TAGS ('dbx_business_glossary_term' = 'CE Marking Required Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `ce_marking_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `clearance_date` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `clearance_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `clearance_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `clearance_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Trade Compliance Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending_review|conditionally_compliant|exempted');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `country_of_export_code` SET TAGS ('dbx_business_glossary_term' = 'Country of Export Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `country_of_export_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `country_of_import_code` SET TAGS ('dbx_business_glossary_term' = 'Country of Import Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `country_of_import_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `country_of_origin_code` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `country_of_origin_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `customs_broker_name` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `customs_broker_reference` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Reference Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `customs_procedure_code` SET TAGS ('dbx_business_glossary_term' = 'Customs Procedure Code (CPC)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `declaration_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `declaration_type` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `declaration_type` SET TAGS ('dbx_value_regex' = 'import|export|transit|re-import|re-export|temporary_import|temporary_export');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `declared_value` SET TAGS ('dbx_business_glossary_term' = 'Customs Declared Value');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `declared_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `declared_value_currency` SET TAGS ('dbx_business_glossary_term' = 'Declared Value Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `declared_value_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `duty_amount` SET TAGS ('dbx_business_glossary_term' = 'Customs Duty Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `duty_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `duty_currency` SET TAGS ('dbx_business_glossary_term' = 'Duty and Tax Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `duty_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `duty_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Applied Customs Duty Rate Percentage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `entry_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Entry Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification Number (ECCN)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `export_license_number` SET TAGS ('dbx_business_glossary_term' = 'Export License Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `exporter_of_record` SET TAGS ('dbx_business_glossary_term' = 'Exporter of Record (EOR)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `filing_date` SET TAGS ('dbx_business_glossary_term' = 'Customs Filing Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `filing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `hs_code` SET TAGS ('dbx_business_glossary_term' = 'Harmonized System (HS) Tariff Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `hs_code` SET TAGS ('dbx_value_regex' = '^d{6,10}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `importer_of_record` SET TAGS ('dbx_business_glossary_term' = 'Importer of Record (IOR)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `is_reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'REACH Compliance Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `is_reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `is_rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'RoHS Compliance Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `is_rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `net_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Net Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `package_count` SET TAGS ('dbx_business_glossary_term' = 'Number of Packages');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `port_of_entry_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Entry Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `port_of_exit_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Exit Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `preferential_origin` SET TAGS ('dbx_business_glossary_term' = 'Preferential Origin Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `preferential_origin` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|held|released|cleared|rejected|cancelled|amended');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Customs Tax Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `trade_agreement_code` SET TAGS ('dbx_business_glossary_term' = 'Preferential Trade Agreement Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'sea|air|road|rail|multimodal|pipeline|postal|fixed_transport_installation');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `valuation_method` SET TAGS ('dbx_business_glossary_term' = 'Customs Valuation Method');
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ALTER COLUMN `valuation_method` SET TAGS ('dbx_value_regex' = 'transaction_value|identical_goods|similar_goods|deductive|computed|fallback');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` SET TAGS ('dbx_subdomain' = 'trade_compliance');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `trade_document_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Document ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `engineering_regulatory_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Certification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `acceptance_date` SET TAGS ('dbx_business_glossary_term' = 'Document Acceptance Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `acceptance_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `attachment_format` SET TAGS ('dbx_business_glossary_term' = 'Attachment File Format');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `attachment_format` SET TAGS ('dbx_value_regex' = 'PDF|TIFF|XML|EDI|JPEG|PNG|DOCX');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `attachment_reference` SET TAGS ('dbx_business_glossary_term' = 'Digital Attachment Reference');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `customs_office_code` SET TAGS ('dbx_business_glossary_term' = 'Customs Office Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `dangerous_goods_class` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Class');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `dangerous_goods_class` SET TAGS ('dbx_value_regex' = '1|2|3|4|5|6|7|8|9');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `declared_value` SET TAGS ('dbx_business_glossary_term' = 'Declared Customs Value');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `declared_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `declared_value_currency` SET TAGS ('dbx_business_glossary_term' = 'Declared Value Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `declared_value_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Trade Document Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Trade Document Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `document_type` SET TAGS ('dbx_value_regex' = 'commercial_invoice|packing_list|bill_of_lading|airway_bill|certificate_of_origin|export_license|import_license|customs_declaration|dangerous_goods_declaration|phytosanitary_certificate|insurance_certificate|inspection_certificate|letter_of_credit|...');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `document_version` SET TAGS ('dbx_business_glossary_term' = 'Document Version');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `electronic_submission_indicator` SET TAGS ('dbx_business_glossary_term' = 'Electronic Submission Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `electronic_submission_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Document Expiry Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification Number (ECCN)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `export_license_number` SET TAGS ('dbx_business_glossary_term' = 'Export License Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `free_trade_agreement_code` SET TAGS ('dbx_business_glossary_term' = 'Free Trade Agreement (FTA) Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `is_dangerous_goods` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `is_dangerous_goods` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `is_reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'REACH Compliance Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `is_reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `is_rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'RoHS Compliance Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `is_rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Document Issue Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `issuing_country_code` SET TAGS ('dbx_business_glossary_term' = 'Issuing Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `issuing_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `letter_of_credit_number` SET TAGS ('dbx_business_glossary_term' = 'Letter of Credit (LC) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `net_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Net Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `package_count` SET TAGS ('dbx_business_glossary_term' = 'Package Count');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `preferential_origin` SET TAGS ('dbx_business_glossary_term' = 'Preferential Origin Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `preferential_origin` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Document Rejection Reason');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Trade Document Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|approved|submitted|accepted|rejected|expired|cancelled|superseded|archived');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'Document Submission Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `submission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'sea|air|road|rail|multimodal|courier|inland_waterway');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'UN Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UNd{4}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` SET TAGS ('dbx_subdomain' = 'network_planning');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `packaging_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Packaging Category');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'pallet|carton|crate|drum|ibc|iso_container|bag|tote|spool|tube|envelope|other');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Packaging Type Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,30}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `deposit_amount` SET TAGS ('dbx_business_glossary_term' = 'Returnable Packaging Deposit Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `deposit_amount` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `deposit_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `deposit_currency` SET TAGS ('dbx_business_glossary_term' = 'Returnable Packaging Deposit Currency');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `deposit_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Packaging Description');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `dimensional_weight_factor` SET TAGS ('dbx_business_glossary_term' = 'Dimensional Weight Factor');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `dimensional_weight_factor` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `ghs_pictogram_code` SET TAGS ('dbx_business_glossary_term' = 'Globally Harmonized System (GHS) Pictogram Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `gross_volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Gross External Volume (m³)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `gross_volume_m3` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `hazmat_un_certification` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) UN Certification Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `height_mm` SET TAGS ('dbx_business_glossary_term' = 'Height (mm)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `height_mm` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `internal_volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Internal Volume (m³)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `internal_volume_m3` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `is_hazmat_compatible` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Compatible Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `is_hazmat_compatible` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `is_reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'REACH Compliance Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `is_reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `is_returnable` SET TAGS ('dbx_business_glossary_term' = 'Returnable Packaging Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `is_returnable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `is_rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'RoHS Compliance Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `is_rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `is_stackable` SET TAGS ('dbx_business_glossary_term' = 'Stackable Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `is_stackable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `is_temperature_controlled` SET TAGS ('dbx_business_glossary_term' = 'Temperature Controlled Packaging Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `is_temperature_controlled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `iso_container_type_code` SET TAGS ('dbx_business_glossary_term' = 'ISO Container Type Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `iso_container_type_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `length_mm` SET TAGS ('dbx_business_glossary_term' = 'Length (mm)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `length_mm` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `material_composition` SET TAGS ('dbx_business_glossary_term' = 'Packaging Material Composition');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `material_composition` SET TAGS ('dbx_value_regex' = 'wood|cardboard|corrugated_paper|plastic_hdpe|plastic_ldpe|plastic_pp|steel|aluminum|composite|foam|fabric|other');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `max_gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Maximum Gross Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `max_gross_weight_kg` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `max_payload_kg` SET TAGS ('dbx_business_glossary_term' = 'Maximum Payload Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `max_payload_kg` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `max_stack_layers` SET TAGS ('dbx_business_glossary_term' = 'Maximum Stack Layers');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `max_stack_layers` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Packaging Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Packaging Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|obsolete|under_review');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Packaging Supplier Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `supplier_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,30}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `tare_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Tare Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `tare_weight_kg` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `temperature_max_c` SET TAGS ('dbx_business_glossary_term' = 'Maximum Temperature Threshold (°C)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `temperature_max_c` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `temperature_min_c` SET TAGS ('dbx_business_glossary_term' = 'Minimum Temperature Threshold (°C)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `temperature_min_c` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `transport_mode_compatibility` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode Compatibility');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `transport_mode_compatibility` SET TAGS ('dbx_value_regex' = 'air|ocean|road|rail|multimodal|all');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Packaging Type Level');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'primary|secondary|tertiary|transport');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `unit_cost` SET TAGS ('dbx_business_glossary_term' = 'Packaging Unit Cost');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `unit_cost` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `unit_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `unit_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Packaging Unit Cost Currency');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `unit_cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `width_mm` SET TAGS ('dbx_business_glossary_term' = 'Width (mm)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `width_mm` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` SET TAGS ('dbx_subdomain' = 'freight_execution');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `load_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Load Unit ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `carrier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `handling_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Handling Unit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Loaded By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `packaging_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `contents_description` SET TAGS ('dbx_business_glossary_term' = 'Contents Description');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `declared_value` SET TAGS ('dbx_business_glossary_term' = 'Declared Value');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `declared_value` SET TAGS ('dbx_value_regex' = '^[0-9]{1,15}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `declared_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `declared_value_currency` SET TAGS ('dbx_business_glossary_term' = 'Declared Value Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `declared_value_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `goods_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Issue Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `goods_issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_value_regex' = '^[0-9]{1,9}(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `handling_unit_number` SET TAGS ('dbx_business_glossary_term' = 'Handling Unit (HU) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `handling_unit_number` SET TAGS ('dbx_value_regex' = '^HU-[A-Z0-9]{6,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `height_cm` SET TAGS ('dbx_business_glossary_term' = 'Height (cm)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `height_cm` SET TAGS ('dbx_value_regex' = '^[0-9]{1,7}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `is_hazmat` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `is_hazmat` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `is_sealed` SET TAGS ('dbx_business_glossary_term' = 'Is Sealed Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `is_sealed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `is_temperature_controlled` SET TAGS ('dbx_business_glossary_term' = 'Temperature Controlled Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `is_temperature_controlled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `item_count` SET TAGS ('dbx_business_glossary_term' = 'Item Count');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `item_count` SET TAGS ('dbx_value_regex' = '^[0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `label_printed` SET TAGS ('dbx_business_glossary_term' = 'Label Printed Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `label_printed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `length_cm` SET TAGS ('dbx_business_glossary_term' = 'Length (cm)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `length_cm` SET TAGS ('dbx_value_regex' = '^[0-9]{1,7}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `loading_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Loading Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `loading_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `max_stack_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Maximum Stack Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `max_stack_weight_kg` SET TAGS ('dbx_value_regex' = '^[0-9]{1,7}(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `net_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Net Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `net_weight_kg` SET TAGS ('dbx_value_regex' = '^[0-9]{1,9}(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `packing_station_code` SET TAGS ('dbx_business_glossary_term' = 'Packing Station Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `packing_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Packing Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `packing_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `pro_number` SET TAGS ('dbx_business_glossary_term' = 'Progressive (PRO) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `required_temperature_max_c` SET TAGS ('dbx_business_glossary_term' = 'Required Maximum Temperature (°C)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `required_temperature_max_c` SET TAGS ('dbx_value_regex' = '^-?[0-9]{1,3}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `required_temperature_min_c` SET TAGS ('dbx_business_glossary_term' = 'Required Minimum Temperature (°C)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `required_temperature_min_c` SET TAGS ('dbx_value_regex' = '^-?[0-9]{1,3}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Seal Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `special_handling_code` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `special_handling_code` SET TAGS ('dbx_value_regex' = 'fragile|keep_dry|this_side_up|do_not_freeze|keep_refrigerated|handle_with_care|no_stack|other');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `sscc_barcode` SET TAGS ('dbx_business_glossary_term' = 'Serial Shipping Container Code (SSCC) Barcode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `sscc_barcode` SET TAGS ('dbx_value_regex' = '^[0-9]{18}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `stacking_allowed` SET TAGS ('dbx_business_glossary_term' = 'Stacking Allowed Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `stacking_allowed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Load Unit Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'created|in_packing|packed|labeled|sealed|loaded|in_transit|delivered|returned|cancelled');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `tare_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Tare Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `tare_weight_kg` SET TAGS ('dbx_value_regex' = '^[0-9]{1,7}(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `tms_load_code` SET TAGS ('dbx_business_glossary_term' = 'Transportation Management System (TMS) Load ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `total_quantity` SET TAGS ('dbx_business_glossary_term' = 'Total Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `total_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]{1,11}(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Volume (m³)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `volume_m3` SET TAGS ('dbx_value_regex' = '^[0-9]{1,6}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `warehouse_number` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `width_cm` SET TAGS ('dbx_business_glossary_term' = 'Width (cm)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ALTER COLUMN `width_cm` SET TAGS ('dbx_value_regex' = '^[0-9]{1,7}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `carrier_performance_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Performance ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `carrier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Evaluated By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `freight_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `avg_transit_time_days` SET TAGS ('dbx_business_glossary_term' = 'Average Transit Time (Days)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `co2_per_tonne_km` SET TAGS ('dbx_business_glossary_term' = 'CO2 Emissions per Tonne-Kilometre (CO2/tonne-km)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `contracted_transit_time_days` SET TAGS ('dbx_business_glossary_term' = 'Contracted Transit Time (Days)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Required Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `damage_claim_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Damage Claim Rate Percentage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `damage_claim_rate_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `damage_claim_value` SET TAGS ('dbx_business_glossary_term' = 'Damage Claim Value');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `damage_claims` SET TAGS ('dbx_business_glossary_term' = 'Damage Claims Count');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `damage_claims` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `edi_compliance_percent` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Compliance Rate Percentage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `edi_compliance_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `in_full_shipments` SET TAGS ('dbx_business_glossary_term' = 'In-Full Shipments');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `in_full_shipments` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `invoice_accuracy_percent` SET TAGS ('dbx_business_glossary_term' = 'Invoice Accuracy Rate Percentage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `invoice_accuracy_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `invoice_disputes` SET TAGS ('dbx_business_glossary_term' = 'Invoice Disputes Count');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `invoice_disputes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `on_time_shipments` SET TAGS ('dbx_business_glossary_term' = 'On-Time Shipments');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `on_time_shipments` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `otif_actual_percent` SET TAGS ('dbx_business_glossary_term' = 'On-Time In-Full (OTIF) Actual Percentage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `otif_actual_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `otif_shipments` SET TAGS ('dbx_business_glossary_term' = 'On-Time In-Full (OTIF) Shipments');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `otif_shipments` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `otif_target_percent` SET TAGS ('dbx_business_glossary_term' = 'On-Time In-Full (OTIF) Target Percentage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `otif_target_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `overall_score` SET TAGS ('dbx_business_glossary_term' = 'Overall Carrier Performance Score');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `overall_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `performance_rating` SET TAGS ('dbx_business_glossary_term' = 'Carrier Performance Rating');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `performance_rating` SET TAGS ('dbx_value_regex' = 'preferred|approved|conditional|probation|disqualified');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Scorecard Period End Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `period_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Scorecard Period Start Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `period_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `pickup_compliance_percent` SET TAGS ('dbx_business_glossary_term' = 'Pickup Compliance Rate Percentage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `pickup_compliance_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `review_date` SET TAGS ('dbx_business_glossary_term' = 'Scorecard Review Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `review_status` SET TAGS ('dbx_business_glossary_term' = 'Scorecard Review Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `review_status` SET TAGS ('dbx_value_regex' = 'draft|pending_review|reviewed|approved|disputed|closed');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `reviewed_by` SET TAGS ('dbx_business_glossary_term' = 'Reviewed By');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `scorecard_number` SET TAGS ('dbx_business_glossary_term' = 'Carrier Performance Scorecard Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `scorecard_number` SET TAGS ('dbx_value_regex' = '^CP-[0-9]{4}-[0-9]{2}-[A-Z0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `scorecard_period_type` SET TAGS ('dbx_business_glossary_term' = 'Scorecard Period Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `scorecard_period_type` SET TAGS ('dbx_value_regex' = 'weekly|monthly|quarterly|annual');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `service_lane_code` SET TAGS ('dbx_business_glossary_term' = 'Service Lane Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'FTL|LTL|FCL|LCL|express|standard|economy|dedicated|spot');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `tender_acceptance_percent` SET TAGS ('dbx_business_glossary_term' = 'Tender Acceptance Rate Percentage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `tender_acceptance_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `total_freight_spend` SET TAGS ('dbx_business_glossary_term' = 'Total Freight Spend');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `total_freight_spend` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `total_shipments` SET TAGS ('dbx_business_glossary_term' = 'Total Shipments');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `total_shipments` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `transit_time_compliance_percent` SET TAGS ('dbx_business_glossary_term' = 'Transit Time Compliance Percentage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `transit_time_compliance_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|ocean|air|intermodal|courier|parcel');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` SET TAGS ('dbx_subdomain' = 'freight_execution');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `delivery_performance_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Performance ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `actual_delivery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `actual_delivery_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `capa_reference` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `customer_impact_severity` SET TAGS ('dbx_business_glossary_term' = 'Customer Impact Severity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `customer_impact_severity` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|none');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `customer_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `customer_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `customer_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `days_early_late` SET TAGS ('dbx_business_glossary_term' = 'Days Early or Late');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `delivered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Delivered Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `escalation_case_number` SET TAGS ('dbx_business_glossary_term' = 'Escalation Case Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `fill_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Fill Rate Percentage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `fill_rate_pct` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `in_full_threshold_pct` SET TAGS ('dbx_business_glossary_term' = 'In-Full Threshold Percentage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `in_full_threshold_pct` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `is_in_full` SET TAGS ('dbx_business_glossary_term' = 'In-Full Delivery Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `is_in_full` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `is_on_time` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `is_on_time` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `is_otif` SET TAGS ('dbx_business_glossary_term' = 'On-Time In-Full (OTIF) Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `is_otif` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `measurement_period` SET TAGS ('dbx_business_glossary_term' = 'Measurement Period');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `measurement_period` SET TAGS ('dbx_value_regex' = '^d{4}-(0[1-9]|1[0-2])$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `on_time_tolerance_days` SET TAGS ('dbx_business_glossary_term' = 'On-Time Tolerance Days');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `ordered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Ordered Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `otif_failure_reason_category` SET TAGS ('dbx_business_glossary_term' = 'OTIF Failure Root Cause Category');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `otif_failure_reason_category` SET TAGS ('dbx_value_regex' = 'carrier_delay|customs_hold|production_delay|weather|warehouse_delay|supplier_delay|demand_spike|system_error|other');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `otif_failure_reason_detail` SET TAGS ('dbx_business_glossary_term' = 'OTIF Failure Root Cause Detail');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `promised_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Promised Delivery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `promised_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `proof_of_delivery_reference` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) Reference');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `record_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Performance Record Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `record_number` SET TAGS ('dbx_value_regex' = '^DP-[0-9]{4}-[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `sales_order_line_number` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Line Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `ship_to_location_code` SET TAGS ('dbx_business_glossary_term' = 'Ship-To Location Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `sla_agreement_reference` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Reference');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Delivery Performance Record Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'pending|confirmed|disputed|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|air|ocean|intermodal|courier|parcel');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` SET TAGS ('dbx_subdomain' = 'financial_settlement');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `freight_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Claim ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `compliance_audit_finding_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `credit_note_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Note Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Filed By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `request_id` SET TAGS ('dbx_business_glossary_term' = 'Service Request Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `spare_part_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `carrier_acknowledgment_date` SET TAGS ('dbx_business_glossary_term' = 'Carrier Acknowledgment Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `carrier_acknowledgment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `carrier_decision_due_date` SET TAGS ('dbx_business_glossary_term' = 'Carrier Decision Due Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `carrier_decision_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `claim_number` SET TAGS ('dbx_business_glossary_term' = 'Freight Claim Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `claim_number` SET TAGS ('dbx_value_regex' = '^FC-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `claim_type` SET TAGS ('dbx_business_glossary_term' = 'Freight Claim Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `claim_type` SET TAGS ('dbx_value_regex' = 'loss|damage|shortage|delay|concealed_damage|overcharge|refused_shipment|contamination');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `claimant_reference` SET TAGS ('dbx_business_glossary_term' = 'Claimant Internal Reference');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `claimed_amount` SET TAGS ('dbx_business_glossary_term' = 'Claimed Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `claimed_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `claimed_amount_currency` SET TAGS ('dbx_business_glossary_term' = 'Claimed Amount Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `claimed_amount_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `damaged_item_description` SET TAGS ('dbx_business_glossary_term' = 'Damaged Item Description');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `damaged_quantity` SET TAGS ('dbx_business_glossary_term' = 'Damaged/Lost Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `declared_value` SET TAGS ('dbx_business_glossary_term' = 'Declared Shipment Value');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `declared_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `declared_value_currency` SET TAGS ('dbx_business_glossary_term' = 'Declared Value Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `declared_value_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `denial_reason` SET TAGS ('dbx_business_glossary_term' = 'Claim Denial Reason');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `denial_reason` SET TAGS ('dbx_value_regex' = 'act_of_god|shipper_fault|improper_packaging|inherent_vice|public_authority|carrier_not_liable|insufficient_documentation|statute_of_limitations|other');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `discovery_date` SET TAGS ('dbx_business_glossary_term' = 'Damage Discovery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `discovery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `dispute_status` SET TAGS ('dbx_business_glossary_term' = 'Dispute Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `dispute_status` SET TAGS ('dbx_value_regex' = 'not_disputed|in_dispute|escalated_to_legal|arbitration|litigation|resolved');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `filed_date` SET TAGS ('dbx_business_glossary_term' = 'Claim Filed Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `filed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `filing_deadline_date` SET TAGS ('dbx_business_glossary_term' = 'Claim Filing Deadline Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `filing_deadline_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `final_settlement_amount` SET TAGS ('dbx_business_glossary_term' = 'Final Settlement Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `final_settlement_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `final_settlement_currency` SET TAGS ('dbx_business_glossary_term' = 'Final Settlement Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `final_settlement_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `incident_date` SET TAGS ('dbx_business_glossary_term' = 'Incident Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `incident_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Carrier Inspection Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `inspection_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Carrier Inspection Required Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `inspection_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `insurance_claim_number` SET TAGS ('dbx_business_glossary_term' = 'Insurance Claim Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `insurance_recovery_amount` SET TAGS ('dbx_business_glossary_term' = 'Insurance Recovery Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `insurance_recovery_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Claim Notes');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `pro_number` SET TAGS ('dbx_business_glossary_term' = 'Progressive (PRO) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|LB|MT|PC|BOX|PLT|CTN|L|M|M2|M3');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `settlement_date` SET TAGS ('dbx_business_glossary_term' = 'Settlement Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `settlement_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `settlement_offer_amount` SET TAGS ('dbx_business_glossary_term' = 'Settlement Offer Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `settlement_offer_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `settlement_offer_date` SET TAGS ('dbx_business_glossary_term' = 'Settlement Offer Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `settlement_offer_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Freight Claim Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|filed|acknowledged|under_review|settlement_offered|disputed|settled|closed|withdrawn|denied');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `supporting_documents_flag` SET TAGS ('dbx_business_glossary_term' = 'Supporting Documents Attached Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `supporting_documents_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|ocean|air|intermodal|courier');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` SET TAGS ('dbx_subdomain' = 'network_planning');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `transport_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Zone ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `applicable_surcharge_types` SET TAGS ('dbx_business_glossary_term' = 'Applicable Surcharge Types');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `co2_emission_factor_kg_per_km` SET TAGS ('dbx_business_glossary_term' = 'CO2 Emission Factor (kg per km)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `co2_emission_factor_kg_per_km` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `continent_code` SET TAGS ('dbx_business_glossary_term' = 'Continent Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `continent_code` SET TAGS ('dbx_value_regex' = 'AF|AN|AS|EU|NA|OC|SA');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `country_codes_covered` SET TAGS ('dbx_business_glossary_term' = 'Countries Covered');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `country_codes_covered` SET TAGS ('dbx_value_regex' = '^([A-Z]{3})(,[A-Z]{3})*$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `customs_territory_code` SET TAGS ('dbx_business_glossary_term' = 'Customs Territory Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `data_source_system` SET TAGS ('dbx_business_glossary_term' = 'Data Source System');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `data_source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|TMS|MANUAL|ARIBA|OTHER');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Transport Zone Description');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `erp_zone_code` SET TAGS ('dbx_business_glossary_term' = 'Enterprise Resource Planning (ERP) Zone Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `freight_rate_basis` SET TAGS ('dbx_business_glossary_term' = 'Freight Rate Basis');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `freight_rate_basis` SET TAGS ('dbx_value_regex' = 'weight|volume|distance|flat_rate|per_unit|revenue_based|zone_to_zone');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_business_glossary_term' = 'Geographic Scope');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_value_regex' = 'global|continental|country|multi_country|regional|state_province|postal_zone|city|custom');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `incoterms_applicability` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Applicability');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `is_cross_border` SET TAGS ('dbx_business_glossary_term' = 'Cross-Border Zone Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `is_cross_border` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `is_free_trade_zone` SET TAGS ('dbx_business_glossary_term' = 'Free Trade Zone (FTZ) Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `is_free_trade_zone` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `is_hazmat_permitted` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Permitted Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `is_hazmat_permitted` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `is_temperature_controlled` SET TAGS ('dbx_business_glossary_term' = 'Temperature-Controlled Zone Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `is_temperature_controlled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_business_glossary_term' = 'Last Reviewed Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `max_transit_days` SET TAGS ('dbx_business_glossary_term' = 'Maximum Transit Days');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `max_transit_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Transport Zone Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `owning_logistics_org` SET TAGS ('dbx_business_glossary_term' = 'Owning Logistics Organization');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `postal_code_range_end` SET TAGS ('dbx_business_glossary_term' = 'Postal Code Range End');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `postal_code_range_end` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `postal_code_range_end` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `postal_code_range_start` SET TAGS ('dbx_business_glossary_term' = 'Postal Code Range Start');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `postal_code_range_start` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `postal_code_range_start` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `primary_country_code` SET TAGS ('dbx_business_glossary_term' = 'Primary Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `primary_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `regulatory_regime` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Regime');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `regulatory_regime` SET TAGS ('dbx_value_regex' = 'eu_customs_union|usmca|asean_fta|mercosur|gcc|sadc|cptpp|bilateral|national|other');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `service_level_options` SET TAGS ('dbx_business_glossary_term' = 'Service Level Options');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `standard_transit_days` SET TAGS ('dbx_business_glossary_term' = 'Standard Transit Days');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `standard_transit_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `state_province_codes` SET TAGS ('dbx_business_glossary_term' = 'State / Province Codes Covered');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Transport Zone Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|draft|under_review|deprecated');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `tms_zone_code` SET TAGS ('dbx_business_glossary_term' = 'Transportation Management System (TMS) Zone ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `transport_modes_supported` SET TAGS ('dbx_business_glossary_term' = 'Transport Modes Supported');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `zone_category` SET TAGS ('dbx_business_glossary_term' = 'Transport Zone Category');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `zone_category` SET TAGS ('dbx_value_regex' = 'origin|destination|origin_destination|transit|hub');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `zone_code` SET TAGS ('dbx_business_glossary_term' = 'Transport Zone Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `zone_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `zone_type` SET TAGS ('dbx_business_glossary_term' = 'Transport Zone Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_zone` ALTER COLUMN `zone_type` SET TAGS ('dbx_value_regex' = 'freight_pricing|customs_territory|sales_territory|carrier_service_area|tax_jurisdiction|regulatory_compliance|incoterms_zone');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` SET TAGS ('dbx_subdomain' = 'network_planning');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` SET TAGS ('dbx_original_name' = 'logistics_location');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Logistics Location ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `ot_system_id` SET TAGS ('dbx_business_glossary_term' = 'Location Ot System Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `transport_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Zone Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `address_line_1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `address_line_1` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `address_line_1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `address_line_2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `address_line_2` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `address_line_2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Location Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `customs_bond_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Customs Bond Expiry Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `customs_bond_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `customs_bond_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Bond Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `dock_count` SET TAGS ('dbx_business_glossary_term' = 'Dock Door Count');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `dock_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `ftz_zone_number` SET TAGS ('dbx_business_glossary_term' = 'Free Trade Zone (FTZ) Zone Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `iata_airport_code` SET TAGS ('dbx_business_glossary_term' = 'International Air Transport Association (IATA) Airport Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `iata_airport_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `inbound_dock_count` SET TAGS ('dbx_business_glossary_term' = 'Inbound Dock Door Count');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `inbound_dock_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `is_customs_bonded` SET TAGS ('dbx_business_glossary_term' = 'Customs Bonded Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `is_customs_bonded` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `is_free_trade_zone` SET TAGS ('dbx_business_glossary_term' = 'Free Trade Zone (FTZ) Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `is_free_trade_zone` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `is_hazmat_certified` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Certified Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `is_hazmat_certified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `is_temperature_controlled` SET TAGS ('dbx_business_glossary_term' = 'Temperature Controlled Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `is_temperature_controlled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'GPS Latitude');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `latitude` SET TAGS ('dbx_value_regex' = '^-?(90(.0+)?|[1-8]?d(.d+)?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'GPS Longitude');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `longitude` SET TAGS ('dbx_value_regex' = '^-?(180(.0+)?|1[0-7]d(.d+)?|[1-9]?d(.d+)?)$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `max_weight_capacity_kg` SET TAGS ('dbx_business_glossary_term' = 'Maximum Weight Capacity (Kilograms)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `max_weight_capacity_kg` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Location Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `operating_days` SET TAGS ('dbx_business_glossary_term' = 'Operating Days');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `operating_hours_end` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours End Time');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `operating_hours_end` SET TAGS ('dbx_value_regex' = '^([01]d|2[0-3]):[0-5]d$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `operating_hours_start` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours Start Time');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `operating_hours_start` SET TAGS ('dbx_value_regex' = '^([01]d|2[0-3]):[0-5]d$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `outbound_dock_count` SET TAGS ('dbx_business_glossary_term' = 'Outbound Dock Door Count');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `outbound_dock_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'SAP Plant Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `postal_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Logistics Region Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State or Province');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Location Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|under_construction|temporarily_closed|decommissioned');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `storage_capacity_m3` SET TAGS ('dbx_business_glossary_term' = 'Storage Capacity (Cubic Meters)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `storage_capacity_m3` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `temp_max_c` SET TAGS ('dbx_business_glossary_term' = 'Maximum Temperature Capability (Celsius)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `temp_max_c` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `temp_min_c` SET TAGS ('dbx_business_glossary_term' = 'Minimum Temperature Capability (Celsius)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `temp_min_c` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `timezone` SET TAGS ('dbx_business_glossary_term' = 'Location Timezone');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Location Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'manufacturing_plant|distribution_center|cross_dock|customer_delivery_point|supplier_pickup_point|port_of_entry|customs_bonded_warehouse|freight_terminal|consolidation_hub|last_mile_depot');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `un_locode` SET TAGS ('dbx_business_glossary_term' = 'United Nations Location Code (UN/LOCODE)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `un_locode` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}[A-Z0-9]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ALTER COLUMN `warehouse_number` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` SET TAGS ('dbx_subdomain' = 'trade_compliance');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `dangerous_goods_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods (DG) Declaration ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `certificate_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Certificate Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Certified Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `chemical_substance_id` SET TAGS ('dbx_business_glossary_term' = 'Chemical Substance Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `freight_order_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `hazardous_substance_id` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Substance Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `material_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Material Specification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `sds_id` SET TAGS ('dbx_business_glossary_term' = 'Sds Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `spare_part_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `additional_handling_instructions` SET TAGS ('dbx_business_glossary_term' = 'Additional Handling Instructions');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `certification_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `certification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `certifier_name` SET TAGS ('dbx_business_glossary_term' = 'Certifier Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `certifier_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `certifier_title` SET TAGS ('dbx_business_glossary_term' = 'Certifier Title');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `consignee_country_code` SET TAGS ('dbx_business_glossary_term' = 'Consignee Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `consignee_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `consignee_name` SET TAGS ('dbx_business_glossary_term' = 'Consignee Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `consignee_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `declaration_number` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Declaration Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `declaration_number` SET TAGS ('dbx_value_regex' = '^DGD-[A-Z0-9]{4}-[0-9]{8}-[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `document_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Phone Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_value_regex' = '^+?[0-9s-()]{7,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `emergency_response_guide_number` SET TAGS ('dbx_business_glossary_term' = 'Emergency Response Guide (ERG) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `emergency_response_guide_number` SET TAGS ('dbx_value_regex' = '^[0-9]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Declaration Expiry Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `flash_point_c` SET TAGS ('dbx_business_glossary_term' = 'Flash Point (°C)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `handling_labels` SET TAGS ('dbx_business_glossary_term' = 'Handling Labels');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `is_environmentally_hazardous` SET TAGS ('dbx_business_glossary_term' = 'Environmentally Hazardous Substance Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `is_environmentally_hazardous` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `is_marine_pollutant` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollutant Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `is_marine_pollutant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `package_count` SET TAGS ('dbx_business_glossary_term' = 'Package Count');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `package_count` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `packaging_specification_number` SET TAGS ('dbx_business_glossary_term' = 'Packaging Specification Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `packaging_type` SET TAGS ('dbx_business_glossary_term' = 'Packaging Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `proper_shipping_name` SET TAGS ('dbx_business_glossary_term' = 'Proper Shipping Name (PSN)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `quantity_gross` SET TAGS ('dbx_business_glossary_term' = 'Gross Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `quantity_net` SET TAGS ('dbx_business_glossary_term' = 'Net Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `quantity_type` SET TAGS ('dbx_business_glossary_term' = 'Quantity Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `quantity_type` SET TAGS ('dbx_value_regex' = 'excepted_quantity|limited_quantity|fully_regulated');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `quantity_unit_of_measure` SET TAGS ('dbx_value_regex' = 'kg|L|mL|g|mg|m3|pieces');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `radioactive_index` SET TAGS ('dbx_business_glossary_term' = 'Radioactive Transport Index (TI)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'REACH Compliance Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `regulatory_regime` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Regime');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `regulatory_regime` SET TAGS ('dbx_value_regex' = 'IATA|IMDG|ADR|DOT|RID|ICAO|IATA_IMDG|ADR_RID|MULTI');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'RoHS Compliance Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `shipper_address` SET TAGS ('dbx_business_glossary_term' = 'Shipper Address');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `shipper_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `shipper_country_code` SET TAGS ('dbx_business_glossary_term' = 'Shipper Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `shipper_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `shipper_name` SET TAGS ('dbx_business_glossary_term' = 'Shipper Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `shipper_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `special_provisions` SET TAGS ('dbx_business_glossary_term' = 'Special Provisions');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Declaration Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|accepted|rejected|cancelled|superseded');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `subsidiary_hazard_class` SET TAGS ('dbx_business_glossary_term' = 'Subsidiary Hazard Class');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `technical_name` SET TAGS ('dbx_business_glossary_term' = 'Technical Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'air|sea|road|rail|multimodal');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `freight_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Contract ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Contract Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto-Renewal Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `carrier_code` SET TAGS ('dbx_business_glossary_term' = 'Carrier Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `carrier_legal_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Legal Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Freight Contract Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `contract_number` SET TAGS ('dbx_value_regex' = '^FC-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `contract_owner` SET TAGS ('dbx_business_glossary_term' = 'Contract Owner');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_business_glossary_term' = 'Freight Contract Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_value_regex' = 'spot|annual|multi_year|master|framework|lane_specific|dedicated|intermodal');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Contract Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `customs_brokerage_included` SET TAGS ('dbx_business_glossary_term' = 'Customs Brokerage Included Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `customs_brokerage_included` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Effective Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Expiry Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `fuel_surcharge_basis` SET TAGS ('dbx_business_glossary_term' = 'Fuel Surcharge Basis');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `fuel_surcharge_basis` SET TAGS ('dbx_value_regex' = 'included|excluded|index_linked|fixed_pct|negotiated');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_business_glossary_term' = 'Geographic Scope');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_value_regex' = 'domestic|regional|international|global');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `hazmat_permitted` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Permitted Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `hazmat_permitted` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'International Commercial Terms (INCOTERMS) Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `insurance_minimum_coverage` SET TAGS ('dbx_business_glossary_term' = 'Minimum Insurance Coverage Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `insurance_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Insurance Required Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `insurance_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `invoicing_frequency` SET TAGS ('dbx_business_glossary_term' = 'Invoicing Frequency');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `invoicing_frequency` SET TAGS ('dbx_value_regex' = 'per_shipment|weekly|bi_weekly|monthly|quarterly');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `liability_limit_amount` SET TAGS ('dbx_business_glossary_term' = 'Carrier Liability Limit Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `maximum_volume_cap` SET TAGS ('dbx_business_glossary_term' = 'Maximum Volume Cap');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `minimum_volume_commitment` SET TAGS ('dbx_business_glossary_term' = 'Minimum Volume Commitment');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = 'net_15|net_30|net_45|net_60|net_90|immediate|prepaid|cod');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `rate_escalation_clause` SET TAGS ('dbx_business_glossary_term' = 'Rate Escalation Clause');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `rate_escalation_clause` SET TAGS ('dbx_value_regex' = 'none|fixed|cpi_indexed|fuel_indexed|annual_percentage|negotiated');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `rate_escalation_pct` SET TAGS ('dbx_business_glossary_term' = 'Rate Escalation Percentage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `renewal_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Renewal Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `renewal_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `renewal_notice_days` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notice Period (Days)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `renewal_notice_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `service_level` SET TAGS ('dbx_business_glossary_term' = 'Service Level');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `service_level` SET TAGS ('dbx_value_regex' = 'standard|express|economy|priority|deferred|next_day|same_day|dedicated');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `signed_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Signed Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `signed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `sla_on_time_delivery_target_pct` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) On-Time Delivery Target Percentage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `sla_penalty_amount` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Penalty Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `sla_penalty_clause` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Penalty Clause Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `sla_penalty_clause` SET TAGS ('dbx_value_regex' = 'none|credit_per_day|percentage_of_invoice|fixed_amount|service_credit');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Freight Contract Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|under_review|pending_approval|active|suspended|expired|terminated|cancelled');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `temperature_controlled` SET TAGS ('dbx_business_glossary_term' = 'Temperature Controlled Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `temperature_controlled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|ocean|air|intermodal|courier|barge|pipeline');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `volume_commitment_uom` SET TAGS ('dbx_business_glossary_term' = 'Volume Commitment Unit of Measure (UOM)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `volume_commitment_uom` SET TAGS ('dbx_value_regex' = 'shipments|kg|tons|TEU|FEU|pallets|cbm|loads');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` SET TAGS ('dbx_subdomain' = 'freight_execution');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `shipment_exception_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Exception ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `quality_notification_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Notification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reported By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `actual_delay_days` SET TAGS ('dbx_business_glossary_term' = 'Actual Delay Days');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `actual_delay_days` SET TAGS ('dbx_value_regex' = '^d{1,3}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `capa_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `carrier_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Name');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `carrier_scac_code` SET TAGS ('dbx_business_glossary_term' = 'Carrier Standard Carrier Alpha Code (SCAC)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `carrier_scac_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `claim_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Claim Reference Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `corrective_action_code` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `corrective_action_code` SET TAGS ('dbx_value_regex' = 'reroute|expedite|reorder|carrier_replacement|customs_intervention|temperature_recovery|damage_claim|documentation_resubmission|customer_notification|hold_and_inspect|no_action_required|other');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `corrective_action_description` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Description');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `customer_notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `customer_notification_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `customs_hold_reference` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Reference Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `detection_source` SET TAGS ('dbx_business_glossary_term' = 'Exception Detection Source');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `detection_source` SET TAGS ('dbx_value_regex' = 'tms_automated|carrier_edi|iiot_sensor|customer_complaint|manual_entry|customs_authority|carrier_portal|tracking_event');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `detection_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Exception Detection Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `detection_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `escalation_level` SET TAGS ('dbx_business_glossary_term' = 'Escalation Level');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `escalation_level` SET TAGS ('dbx_value_regex' = 'none|level_1|level_2|level_3|executive');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `escalation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Escalation Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `escalation_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `estimated_delay_days` SET TAGS ('dbx_business_glossary_term' = 'Estimated Delay Days');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `estimated_delay_days` SET TAGS ('dbx_value_regex' = '^d{1,3}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `exception_code` SET TAGS ('dbx_business_glossary_term' = 'Exception Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `exception_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}-[0-9]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `exception_country_code` SET TAGS ('dbx_business_glossary_term' = 'Exception Country Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `exception_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `exception_description` SET TAGS ('dbx_business_glossary_term' = 'Exception Description');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `exception_location_code` SET TAGS ('dbx_business_glossary_term' = 'Exception Location Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `exception_number` SET TAGS ('dbx_business_glossary_term' = 'Exception Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `exception_number` SET TAGS ('dbx_value_regex' = '^EXC-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `exception_type` SET TAGS ('dbx_business_glossary_term' = 'Exception Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `exception_type` SET TAGS ('dbx_value_regex' = 'delay|route_diversion|customs_hold|carrier_rejection|temperature_excursion|damage|lost|short_shipment|documentation_error|address_error|capacity_constraint|border_closure|natural_disaster|security_incident|other');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `financial_impact_amount` SET TAGS ('dbx_business_glossary_term' = 'Financial Impact Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `financial_impact_amount` SET TAGS ('dbx_value_regex' = '^-?d{1,15}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `financial_impact_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `financial_impact_currency` SET TAGS ('dbx_business_glossary_term' = 'Financial Impact Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `financial_impact_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `freight_order_number` SET TAGS ('dbx_business_glossary_term' = 'Freight Order Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `is_customer_notified` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `is_customer_notified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `is_sla_breached` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach Indicator');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `is_sla_breached` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `occurrence_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Exception Occurrence Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `occurrence_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `resolution_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Exception Resolution Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `resolution_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `responsible_party` SET TAGS ('dbx_business_glossary_term' = 'Responsible Party');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `responsible_party` SET TAGS ('dbx_value_regex' = 'carrier|customs_authority|shipper|consignee|freight_forwarder|warehouse|internal_logistics|supplier|third_party|unknown');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `revised_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Revised Delivery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `revised_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `root_cause_code` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `root_cause_code` SET TAGS ('dbx_value_regex' = 'carrier_error|documentation_error|customs_regulation|weather_event|infrastructure_failure|supplier_delay|system_error|capacity_shortage|security_event|human_error|regulatory_change|unknown');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `root_cause_description` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Description');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `severity` SET TAGS ('dbx_business_glossary_term' = 'Exception Severity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `severity` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `shipment_number` SET TAGS ('dbx_business_glossary_term' = 'Shipment Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `sla_response_deadline` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Response Deadline');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `sla_response_deadline` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Exception Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|in_progress|escalated|resolved|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `temperature_excursion_max_c` SET TAGS ('dbx_business_glossary_term' = 'Temperature Excursion Maximum (Celsius)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `temperature_excursion_max_c` SET TAGS ('dbx_value_regex' = '^-?d{1,3}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `temperature_excursion_min_c` SET TAGS ('dbx_business_glossary_term' = 'Temperature Excursion Minimum (Celsius)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `temperature_excursion_min_c` SET TAGS ('dbx_value_regex' = '^-?d{1,3}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Carrier Tracking Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|ocean|air|intermodal|courier|pipeline');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` SET TAGS ('dbx_association_edges' = 'asset.service_contract,logistics.carrier');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `carrier_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Agreement ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Agreement - Carrier Id');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `service_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Agreement - Service Contract Id');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `contract_rate` SET TAGS ('dbx_business_glossary_term' = 'Contract Rate');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `coverage_zone` SET TAGS ('dbx_business_glossary_term' = 'Coverage Zone');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Created Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `insurance_coverage_amount` SET TAGS ('dbx_business_glossary_term' = 'Insurance Coverage Amount');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `insurance_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Insurance Required Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `last_modified_date` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `priority_rank` SET TAGS ('dbx_business_glossary_term' = 'Priority Rank');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `rate_type` SET TAGS ('dbx_business_glossary_term' = 'Rate Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `response_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Response Time Hours');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `service_level_agreement` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Agreement Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` SET TAGS ('dbx_association_edges' = 'engineering.tooling_equipment,logistics.carrier');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` ALTER COLUMN `carrier_qualification_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Qualification Identifier');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Qualification - Carrier Id');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` ALTER COLUMN `tooling_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Qualification - Tooling Equipment Id');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approving Authority');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Qualification Approval Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` ALTER COLUMN `certification_status` SET TAGS ('dbx_business_glossary_term' = 'Certification Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` ALTER COLUMN `handling_certification` SET TAGS ('dbx_business_glossary_term' = 'Handling Certification Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` ALTER COLUMN `insurance_coverage` SET TAGS ('dbx_business_glossary_term' = 'Tooling-Specific Insurance Coverage');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Last Audit Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` ALTER COLUMN `max_weight_capacity` SET TAGS ('dbx_business_glossary_term' = 'Maximum Weight Capacity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Qualification Notes');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` ALTER COLUMN `qualification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Qualification Expiry Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` ALTER COLUMN `special_equipment_required` SET TAGS ('dbx_business_glossary_term' = 'Special Equipment Requirements');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` SET TAGS ('dbx_association_edges' = 'logistics.carrier,service.service_territory');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `carrier_territory_coverage_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Territory Coverage Identifier');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Territory Coverage - Carrier Id');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `service_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Service Territory Identifier');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `territory_service_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Territory Coverage - Service Territory Id');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `cost_per_delivery` SET TAGS ('dbx_business_glossary_term' = 'Cost Per Delivery');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `coverage_days` SET TAGS ('dbx_business_glossary_term' = 'Coverage Days');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Record Created Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Coverage Effective Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Coverage Expiration Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `last_modified_date` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `max_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Maximum Weight Capacity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Coverage Notes');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Carrier Priority Level');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `sla_delivery_hours` SET TAGS ('dbx_business_glossary_term' = 'SLA Delivery Hours');
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Coverage Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` SET TAGS ('dbx_subdomain' = 'network_planning');
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` SET TAGS ('dbx_association_edges' = 'logistics.logistics_location,service.spare_parts_catalog');
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` ALTER COLUMN `parts_inventory_position_id` SET TAGS ('dbx_business_glossary_term' = 'Parts Inventory Position ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Parts Inventory Position - Logistics Location Id');
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` ALTER COLUMN `logistics_location_id` SET TAGS ('dbx_business_glossary_term' = 'Logistics Location ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` ALTER COLUMN `spare_parts_catalog_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Catalog ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'End Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` ALTER COLUMN `last_replenishment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Replenishment Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time Days');
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` ALTER COLUMN `reorder_point` SET TAGS ('dbx_business_glossary_term' = 'Reorder Point');
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` ALTER COLUMN `stock_quantity` SET TAGS ('dbx_business_glossary_term' = 'Stock Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` ALTER COLUMN `stocking_status` SET TAGS ('dbx_business_glossary_term' = 'Stocking Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` ALTER COLUMN `storage_zone` SET TAGS ('dbx_business_glossary_term' = 'Storage Zone');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` SET TAGS ('dbx_subdomain' = 'network_planning');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` SET TAGS ('dbx_association_edges' = 'logistics.route,procurement.supplier');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` ALTER COLUMN `route_supplier_pickup_id` SET TAGS ('dbx_business_glossary_term' = 'Route Supplier Pickup Identifier');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Route Supplier Pickup - Supplier Id');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` ALTER COLUMN `route_id` SET TAGS ('dbx_business_glossary_term' = 'Route Supplier Pickup - Route Id');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` ALTER COLUMN `active_status` SET TAGS ('dbx_business_glossary_term' = 'Active Status Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` ALTER COLUMN `average_pickup_volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Average Pickup Volume');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` ALTER COLUMN `average_pickup_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Average Pickup Weight');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` ALTER COLUMN `collection_window_end` SET TAGS ('dbx_business_glossary_term' = 'Collection Window End Time');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` ALTER COLUMN `collection_window_start` SET TAGS ('dbx_business_glossary_term' = 'Collection Window Start Time');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` ALTER COLUMN `consolidation_point` SET TAGS ('dbx_business_glossary_term' = 'Consolidation Point Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` ALTER COLUMN `milk_run_sequence` SET TAGS ('dbx_business_glossary_term' = 'Milk Run Sequence Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` ALTER COLUMN `pickup_frequency` SET TAGS ('dbx_business_glossary_term' = 'Pickup Frequency');
