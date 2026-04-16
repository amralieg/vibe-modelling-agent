-- Schema for Domain: logistics | Business:  | Version: v1_mvm
-- Generated on: 2026-04-16 09:51:30

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`logistics` COMMENT 'Manages inbound and outbound freight, transportation planning, carrier selection and management, freight optimization, TMS-driven route optimization, shipment tracking, customs/trade compliance documentation, and delivery performance across global distribution networks.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`shipment_item` (
    `shipment_item_id` BIGINT COMMENT 'Unique surrogate identifier for each shipment item line record in the silver layer lakehouse. Serves as the primary key for item-level traceability across the logistics domain.',
    `batch_id` BIGINT COMMENT 'Foreign key linking to production.batch. Business justification: Shipment items must reference production batches for traceability, quality control, and recall management. Critical for regulated industries (pharma, food, automotive) to track which batch was shipped',
    `cost_allocation_id` BIGINT COMMENT 'Foreign key linking to finance.cost_allocation. Business justification: Freight costs per shipment item must be allocated to the correct cost center or profit center. Controlling teams use this link to distribute logistics costs accurately across business units.',
    `delivery_id` BIGINT COMMENT 'Foreign key linking to logistics.delivery. Business justification: shipment_item records the physical goods dispatched in an outbound delivery. delivery is the outbound delivery document confirming physical dispatch. Linking shipment_item to delivery via delivery_id ',
    `engineering_bom_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_bom. Business justification: For kit shipments or configured products, the shipment item references the engineering BOM to ensure all required components are included in the shipment. Used in kitting and configure-to-order manufa',
    `freight_order_id` BIGINT COMMENT 'Foreign key linking to logistics.freight_order. Business justification: shipment_item is the line-level detail record for each SKU or material within a shipment. freight_order is the operational carrier execution document. Without this FK, shipment items are orphaned from',
    `lot_batch_id` BIGINT COMMENT 'Foreign key linking to inventory.lot_batch. Business justification: Manufacturing requires lot traceability for quality control and recalls. Each shipped item must track which production batch it came from for compliance and traceability.',
    `packaging_id` BIGINT COMMENT 'Foreign key linking to logistics.packaging. Business justification: shipment_item.packaging_type is a denormalized reference to the packaging master. Adding packaging_id FK normalizes this to the packaging master record, enabling packaging configuration lookups. packa',
    `product_configuration_id` BIGINT COMMENT 'Foreign key linking to product.product_configuration. Business justification: Each shipment item ships a specific configured product variant. Warehouse and shipping teams reference the exact product configuration to validate correct item, dimensions, and handling requirements d',
    `product_variant_id` BIGINT COMMENT 'Foreign key linking to engineering.product_variant. Business justification: Every shipment item corresponds to a specific product variant being shipped. Logistics teams reference the engineering product variant to confirm correct part number, configuration, and revision are b',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.po_line_item. Business justification: A shipment item physically moves a specific PO line item quantity. Logistics planners and procurement teams track which PO lines are in transit to confirm delivery progress and update open order quant',
    `serialized_unit_id` BIGINT COMMENT 'Foreign key linking to inventory.serialized_unit. Business justification: High-value industrial equipment and automation systems require serial-level tracking. Logistics must record which specific serialized unit was shipped for warranty and service management.',
    `spare_parts_request_id` BIGINT COMMENT 'Foreign key linking to service.spare_parts_request. Business justification: When a service technician raises a spare parts request, logistics fulfills it by creating shipment items. The warehouse/logistics team uses this link daily to pick, pack, and ship parts against open s',
    `stock_position_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_position. Business justification: Shipment items must reference the exact stock position being picked and shipped. Warehouse operations use this to decrement inventory from specific locations during order fulfillment.',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: Shipment items must reference the products unit of measure to correctly count, weigh, and document quantities on shipping documents, packing lists, and customs declarations. Logistics teams use this ',
    `actual_delivery_date` DATE COMMENT 'Date on which this shipment item was physically delivered and confirmed at the customer or destination location. Used to calculate on-time delivery performance against promised delivery date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating where the material was manufactured or substantially transformed. Required for customs declarations, preferential tariff determination, and trade compliance under CE Marking and REACH/RoHS regulations.. Valid values are `^[A-Z]{3}$`',
    `customs_value` DECIMAL(18,2) COMMENT 'Declared monetary value of this shipment item for customs purposes, used to calculate import duties and taxes. Must align with the transaction value per WTO Customs Valuation Agreement.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `customs_value_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the customs declared value (e.g., USD, EUR, GBP). Required for accurate duty calculation and customs declaration filing.. Valid values are `^[A-Z]{3}$`',
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
    `unit_price` DECIMAL(18,2) COMMENT 'Selling price per unit of measure for this shipment item as invoiced to the customer. Used for commercial invoice preparation, revenue recognition, and customs valuation.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `unit_price_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the unit price (e.g., USD, EUR). Supports multi-currency operations across global distribution networks.. Valid values are `^[A-Z]{3}$`',
    `volume_m3` DECIMAL(18,2) COMMENT 'Volumetric measurement of the shipped item in cubic meters. Used for freight space planning, dimensional weight calculation, and container load optimization.. Valid values are `^[0-9]+(.[0-9]{1,6})?$`',
    CONSTRAINT pk_shipment_item PRIMARY KEY(`shipment_item_id`)
) COMMENT 'Line-level detail for each SKU or material included within a shipment. Records part number, quantity shipped, unit of measure, net/gross weight, package count, hazardous classification (REACH/RoHS flags), country of origin, and customs tariff code (HS code). Enables item-level traceability from sales order line to physical delivery.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`carrier` (
    `carrier_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for each approved freight carrier or logistics service provider (LSP) record in the master data.',
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
    `address_id` BIGINT COMMENT 'Foreign key linking to customer.address. Business justification: Freight orders for industrial equipment shipments must reference the customer delivery address to coordinate carrier pickup and drop-off. Freight coordinators use this to validate destination before d',
    `carrier_id` BIGINT COMMENT 'FK to logistics.carrier',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier_service. Business justification: Freight orders are placed for a specific carrier service (LTL, FTL, express, etc.). Adding carrier_service_id FK normalizes the service reference to the carrier_service master, enabling service-level ',
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: Freight orders must be assigned to a controlling area to enable cost tracking and internal reporting. Controlling teams use this to aggregate logistics spend within defined organizational boundaries.',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: Freight order costs must be posted to the correct fiscal period for period-end closing. Finance controllers use this link to ensure logistics costs are accrued and reported in the right accounting per',
    `fulfillment_plan_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_plan. Business justification: Freight orders are created to execute the transportation leg of a fulfillment plan. Logistics coordinators tie freight orders to fulfillment plans to ensure transport capacity is aligned with committe',
    `location_id` BIGINT COMMENT 'Foreign key linking to logistics.location. Business justification: freight_order currently stores origin_location_code as a denormalized STRING. The logistics.location master table is the authoritative source for all physical locations in the network. Adding origin_l',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: A freight order is created to transport goods procured via a purchase order. Logistics coordinators reference the originating PO when booking freight to ensure correct quantities, destinations, and su',
    `route_id` BIGINT COMMENT 'Foreign key linking to logistics.route. Business justification: Freight orders execute along a defined transportation route/lane. Adding route_id FK normalizes the lane reference. origin_location_code and destination_location_code are retained as execution-specifi',
    `tooling_equipment_id` BIGINT COMMENT 'Foreign key linking to engineering.tooling_equipment. Business justification: Industrial manufacturers frequently ship tooling and equipment between plants or to customer sites. The freight order references the specific tooling equipment record to track asset movement, ensure p',
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
    `location_id` BIGINT COMMENT 'Foreign key linking to logistics.location. Business justification: transport_plan is the TMS-generated plan consolidating shipment demands. It currently stores origin_region and origin_country_code as STRING fields for planning purposes. Adding origin_location_id FK ',
    `carrier_id` BIGINT COMMENT 'FK to logistics.carrier',
    `route_id` BIGINT COMMENT 'Foreign key linking to logistics.route. Business justification: Transport plans are built around specific transportation lanes/routes. Adding route_id FK links the TMS plan to the route master, enabling route-level planning analytics and optimization tracking. ori',
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
    `service_level` STRING COMMENT 'Contracted or planned service level for the transport plan, defining the speed and priority of freight movement. Linked to Service Level Agreement (SLA) commitments with customers or internal stakeholders.. Valid values are `standard|express|economy|priority|deferred`',
    `status` STRING COMMENT 'Current lifecycle status of the transport plan. draft indicates initial TMS-generated plan pending review; confirmed indicates planner approval; in_execution indicates active shipment movement; executed indicates all loads delivered; cancelled indicates plan voided; on_hold indicates temporarily suspended.. Valid values are `draft|confirmed|in_execution|executed|cancelled|on_hold`',
    `tms_plan_reference` STRING COMMENT 'External reference identifier assigned by the source Transportation Management System (TMS) to this transport plan. Used for cross-system reconciliation between the TMS and the lakehouse Silver Layer.',
    `transport_mode` STRING COMMENT 'Primary mode of transportation used in this plan (e.g., road, rail, air, ocean, intermodal). Drives carrier selection, lead time estimation, and CO2 emissions calculation.. Valid values are `road|rail|air|ocean|intermodal|courier`',
    CONSTRAINT pk_transport_plan PRIMARY KEY(`transport_plan_id`)
) COMMENT 'TMS-generated transportation plan that consolidates shipment demands into optimized load plans and route assignments. Captures planning horizon, optimization objective (cost, time, CO2), total planned loads, planned carrier mix, planned freight spend, and plan status (draft, confirmed, executed). Supports MRP II-aligned distribution requirements planning (DRP) and freight budget management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`route` (
    `route_id` BIGINT COMMENT 'Unique system-generated identifier for a transportation route or lane definition within the Transportation Management System (TMS). Serves as the primary key for all route-related data.',
    `location_id` BIGINT COMMENT 'Foreign key linking to logistics.logistics_location. Business justification: Route origin is a physical logistics network location. Adding origin_logistics_location_id FK normalizes the origin reference to the logistics_location master. origin_location_code is retained as a co',
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
    `ar_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ar_invoice. Business justification: Outbound deliveries to customers trigger AR invoices. Finance and logistics teams link delivery confirmation to the AR invoice to validate goods-issue-based billing and support revenue recognition pro',
    `carrier_id` BIGINT COMMENT 'FK to logistics.carrier',
    `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: Deliveries need receiving contact for appointment scheduling, delivery confirmation, and issue escalation. Last-mile delivery teams use this for every customer delivery.',
    `freight_order_id` BIGINT COMMENT 'Foreign key linking to logistics.freight_order. Business justification: delivery is the outbound delivery document confirming physical dispatch of goods. freight_order is the operational carrier execution order. A delivery is executed under a freight order — linking them ',
    `fulfillment_plan_id` BIGINT COMMENT 'Foreign key linking to order.fulfillment_plan. Business justification: Deliveries are executed against a fulfillment plan that coordinates multi-line, multi-shipment orders. Logistics planners reference this link daily to ensure each delivery aligns with the committed fu',
    `production_confirmation_id` BIGINT COMMENT 'Foreign key linking to production.production_confirmation. Business justification: Outbound deliveries of finished goods are initiated only after production confirmation. Warehouse and logistics teams reference the production confirmation to validate goods are ready for shipment — a',
    `route_id` BIGINT COMMENT 'FK to logistics.route',
    `schedule_line_id` BIGINT COMMENT 'Foreign key linking to order.schedule_line. Business justification: In manufacturing, deliveries are executed against confirmed schedule lines (ATP-confirmed delivery dates and quantities). Order fulfillment teams use this link to confirm which schedule line commitmen',
    `spare_parts_request_id` BIGINT COMMENT 'Foreign key linking to service.spare_parts_request. Business justification: A delivery is the physical fulfillment of a spare parts request raised by the service team. Logistics coordinators track which delivery closes which spare parts request to confirm parts reached the fi',
    `warranty_policy_id` BIGINT COMMENT 'Foreign key linking to product.warranty_policy. Business justification: Outbound delivery documents for industrial equipment must reference the applicable warranty policy to include warranty certificates in shipment documentation. Customer service and logistics teams use ',
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

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` (
    `inbound_delivery_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for the inbound delivery record in the Databricks Silver Layer. Serves as the primary key for all downstream joins and lineage tracking.',
    `ap_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ap_invoice. Business justification: Three-way matching in manufacturing requires linking inbound goods receipt to the supplier AP invoice. AP teams use this daily to confirm delivery before releasing payment to suppliers.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier. Business justification: Inbound deliveries are executed by a carrier. inbound_delivery.carrier_name is a denormalized reference to the carrier master. Adding carrier_id FK enforces referential integrity and enables carrier p',
    `freight_order_id` BIGINT COMMENT 'Foreign key linking to logistics.freight_order. Business justification: logistics_inbound_delivery tracks receipt of purchased materials from suppliers. The inbound delivery is physically executed under a freight order issued to the inbound carrier. Linking logistics_inbo',
    `goods_receipt_id` BIGINT COMMENT 'Foreign key linking to procurement.goods_receipt. Business justification: An inbound delivery in logistics is the physical execution of a goods receipt in procurement. Warehouse teams reconcile the two daily — the inbound delivery record must reference the procurement goods',
    `planned_order_id` BIGINT COMMENT 'Foreign key linking to production.planned_order. Business justification: Inbound deliveries of raw materials or components are triggered by planned production orders. Supply chain planners link inbound deliveries to planned orders daily to confirm material availability and',
    `plant_id` BIGINT COMMENT 'Foreign key linking to product.product_plant. Business justification: Inbound deliveries are received at a specific plant where the product is stocked or manufactured. Goods receipt teams use the product-plant assignment to validate correct receiving location, trigger i',
    `product_variant_id` BIGINT COMMENT 'Foreign key linking to engineering.product_variant. Business justification: Inbound deliveries of purchased components or raw materials must be matched to the engineering product variant to validate correct part receipt against the BOM. Goods receipt teams use this link to co',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Every inbound delivery is physically fulfilling a specific purchase order. Receiving teams scan the PO number on arrival to match deliveries to open orders — this link is used in every inbound goods p',
    `location_id` BIGINT COMMENT 'Foreign key linking to logistics.logistics_location. Business justification: Inbound deliveries are received at a specific logistics location (plant, warehouse, distribution center). Adding receiving_logistics_location_id FK links the inbound delivery to the logistics_location',
    `returns_order_id` BIGINT COMMENT 'Foreign key linking to order.returns_order. Business justification: Inbound deliveries process customer returns - receiving department matches incoming goods to authorized return orders for inspection and restocking.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Inbound deliveries must specify the target storage location for putaway. Warehouse receiving teams use this link to direct forklift operators to the correct bin/zone and to pre-allocate storage capaci',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: An inbound delivery originates from a specific supplier. Receiving teams and procurement analysts use the supplier reference on inbound deliveries to track on-time delivery performance and reconcile a',
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
    CONSTRAINT pk_inbound_delivery PRIMARY KEY(`inbound_delivery_id`)
) COMMENT 'Inbound delivery document tracking the receipt of purchased materials, components, or MRO goods from suppliers. Records expected arrival date, actual GRN date, supplier reference, purchase order reference, receiving location, quantity received vs. ordered, and discrepancy flags. Feeds SAP MM GRN processing and inventory replenishment in Infor WMS.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`tracking_event` (
    `tracking_event_id` BIGINT COMMENT 'Unique system-generated identifier for each shipment tracking event record in the logistics domain.',
    `carrier_id` BIGINT COMMENT 'Reference to the carrier or freight provider responsible for the shipment at the time of this event. Enables carrier performance benchmarking and SLA compliance tracking.',
    `delivery_id` BIGINT COMMENT 'Foreign key linking to logistics.delivery. Business justification: tracking_event tracks the progress of shipments through the delivery lifecycle. delivery is the outbound delivery document. Linking tracking_event to delivery via delivery_id enables retrieval of all ',
    `location_id` BIGINT COMMENT 'Foreign key linking to logistics.logistics_location. Business justification: Tracking events occur at specific logistics network locations. Adding logistics_location_id FK normalizes the event location reference. location_name, city, state_province, and country_code are presen',
    `stock_transfer_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_transfer. Business justification: Tracking events for inter-facility transfers must reference the originating stock transfer order. Logistics and inventory teams use this to automatically update transfer status (in-transit, arrived) a',
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
    `currency_exchange_rate_id` BIGINT COMMENT 'Foreign key linking to finance.currency_exchange_rate. Business justification: International freight rates are quoted in foreign currencies. Finance-controlled exchange rates must be applied consistently to freight cost calculations for accurate cost reporting and cross-border s',
    `freight_contract_id` BIGINT COMMENT 'Foreign key linking to logistics.freight_contract. Business justification: Freight rates are defined within freight contracts. freight_rate.contract_number is a denormalized reference to the freight_contract master. Adding freight_contract_id FK normalizes this relationship.',
    `route_id` BIGINT COMMENT 'Foreign key linking to logistics.route. Business justification: freight_rate defines contracted and spot rates for specific transportation lanes. route is the master definition of a transportation lane between origin and destination. Linking freight_rate to route ',
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
    `account_hierarchy_id` BIGINT COMMENT 'Foreign key linking to customer.account_hierarchy. Business justification: Freight invoices in manufacturing are billed to the correct legal entity within a customer group. Finance teams use account hierarchy to ensure freight costs are charged to the right subsidiary or par',
    `ap_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ap_invoice. Business justification: Freight invoices from carriers are recorded as accounts payable. Finance processes these for payment approval, GL posting, and vendor payment execution daily.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier. Business justification: Freight invoices are issued by carriers. freight_invoice.carrier_scac_code and carrier_name are denormalized references to the carrier master. Adding carrier_id FK enforces referential integrity and e',
    `freight_contract_id` BIGINT COMMENT 'Foreign key linking to logistics.freight_contract. Business justification: Freight invoices are billed against contracted rates defined in freight contracts. Adding freight_contract_id FK links the invoice to the governing contract, enabling contract compliance verification ',
    `freight_order_id` BIGINT COMMENT 'Foreign key linking to logistics.freight_order. Business justification: Freight invoices are issued for the execution of freight orders. Adding freight_order_id FK links the invoice to the operational freight order, enabling invoice-to-order matching and payment reconcili',
    `journal_entry_id` BIGINT COMMENT 'Foreign key linking to finance.journal_entry. Business justification: When a freight invoice is posted, a corresponding journal entry records the liability and expense. Finance teams use this link to trace freight cost postings back to source logistics documents for aud',
    `profitability_segment_id` BIGINT COMMENT 'Foreign key linking to finance.profitability_segment. Business justification: Freight costs are assigned to profitability segments to enable margin analysis by product line or customer. CO-PA reporting in manufacturing requires logistics costs mapped to profitability segments f',
    `tax_code_id` BIGINT COMMENT 'Foreign key linking to finance.tax_code. Business justification: Freight invoices carry applicable tax codes (VAT, GST) that must reference the finance tax master. Tax compliance teams use this link to ensure correct tax calculation and reporting on logistics costs',
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

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`packaging` (
    `packaging_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for each packaging configuration record in the logistics master data.',
    `hazardous_substance_id` BIGINT COMMENT 'Foreign key linking to product.hazardous_substance. Business justification: Packaging specifications for industrial automation components must reference hazardous substance classifications to comply with IATA/IMDG/ADR regulations. Logistics teams use this to select compliant ',
    `product_variant_id` BIGINT COMMENT 'Foreign key linking to engineering.product_variant. Business justification: Packaging specifications are defined per product variant — dimensions, weight, and handling requirements differ by variant. Packaging engineers and logistics planners reference the product variant to ',
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

CREATE OR REPLACE TABLE `manufacturing_ecm`.`logistics`.`freight_contract` (
    `freight_contract_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for the freight contract record in the lakehouse silver layer.',
    `carrier_id` BIGINT COMMENT 'FK to logistics.carrier',
    `currency_exchange_rate_id` BIGINT COMMENT 'Foreign key linking to finance.currency_exchange_rate. Business justification: Carrier contracts negotiated in foreign currencies reference the finance exchange rate master to ensure consistent currency conversion for contract value reporting and budget planning.',
    `sales_org_id` BIGINT COMMENT 'Foreign key linking to product.sales_org. Business justification: Freight contracts in manufacturing are negotiated and owned by a specific sales organization responsible for that region or channel. Logistics procurement teams align freight contracts to sales orgs t',
    `approved_by` STRING COMMENT 'Name or employee ID of the authorized approver who signed off on the freight contract terms on behalf of the manufacturing organization.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time at which the freight contract was formally approved by the authorized approver, establishing the audit trail for contract governance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the freight contract includes an automatic renewal clause that extends the contract term without explicit renegotiation if not cancelled before the renewal date.. Valid values are `true|false`',
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

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_delivery_id` FOREIGN KEY (`delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`delivery`(`delivery_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_freight_order_id` FOREIGN KEY (`freight_order_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_order`(`freight_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_packaging_id` FOREIGN KEY (`packaging_id`) REFERENCES `manufacturing_ecm`.`logistics`.`packaging`(`packaging_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service` ADD CONSTRAINT `fk_logistics_carrier_service_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_route_id` FOREIGN KEY (`route_id`) REFERENCES `manufacturing_ecm`.`logistics`.`route`(`route_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_transport_plan_id` FOREIGN KEY (`transport_plan_id`) REFERENCES `manufacturing_ecm`.`logistics`.`transport_plan`(`transport_plan_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ADD CONSTRAINT `fk_logistics_transport_plan_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ADD CONSTRAINT `fk_logistics_transport_plan_route_id` FOREIGN KEY (`route_id`) REFERENCES `manufacturing_ecm`.`logistics`.`route`(`route_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ADD CONSTRAINT `fk_logistics_route_stop_route_id` FOREIGN KEY (`route_id`) REFERENCES `manufacturing_ecm`.`logistics`.`route`(`route_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_freight_order_id` FOREIGN KEY (`freight_order_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_order`(`freight_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_route_id` FOREIGN KEY (`route_id`) REFERENCES `manufacturing_ecm`.`logistics`.`route`(`route_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ADD CONSTRAINT `fk_logistics_inbound_delivery_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ADD CONSTRAINT `fk_logistics_inbound_delivery_freight_order_id` FOREIGN KEY (`freight_order_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_order`(`freight_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ADD CONSTRAINT `fk_logistics_tracking_event_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ADD CONSTRAINT `fk_logistics_tracking_event_delivery_id` FOREIGN KEY (`delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`delivery`(`delivery_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ADD CONSTRAINT `fk_logistics_freight_rate_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ADD CONSTRAINT `fk_logistics_freight_rate_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ADD CONSTRAINT `fk_logistics_freight_rate_freight_contract_id` FOREIGN KEY (`freight_contract_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_contract`(`freight_contract_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ADD CONSTRAINT `fk_logistics_freight_rate_route_id` FOREIGN KEY (`route_id`) REFERENCES `manufacturing_ecm`.`logistics`.`route`(`route_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_freight_contract_id` FOREIGN KEY (`freight_contract_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_contract`(`freight_contract_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_freight_order_id` FOREIGN KEY (`freight_order_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_order`(`freight_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ADD CONSTRAINT `fk_logistics_freight_contract_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`logistics` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `manufacturing_ecm`.`logistics` SET TAGS ('dbx_domain' = 'logistics');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` SET TAGS ('dbx_subdomain' = 'shipment_delivery');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `shipment_item_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Item ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `batch_id` SET TAGS ('dbx_business_glossary_term' = 'Batch Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `cost_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Allocation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `engineering_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Bom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `freight_order_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `lot_batch_id` SET TAGS ('dbx_business_glossary_term' = 'Lot Batch Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `packaging_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `product_configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Product Configuration Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `product_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Variant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Po Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `serialized_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Serialized Unit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `spare_parts_request_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Request Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `stock_position_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Position Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Uom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin (COO)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `customs_value` SET TAGS ('dbx_business_glossary_term' = 'Customs Declared Value');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `customs_value` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `customs_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `customs_value_currency` SET TAGS ('dbx_business_glossary_term' = 'Customs Value Currency');
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ALTER COLUMN `customs_value_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
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
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` SET TAGS ('dbx_subdomain' = 'transport_planning');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `freight_order_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Order ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `address_id` SET TAGS ('dbx_business_glossary_term' = 'Address Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `address_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `address_id` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `carrier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `fulfillment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `route_id` SET TAGS ('dbx_business_glossary_term' = 'Route Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ALTER COLUMN `tooling_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Tooling Equipment Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` SET TAGS ('dbx_subdomain' = 'transport_planning');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `transport_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Plan ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `carrier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `route_id` SET TAGS ('dbx_business_glossary_term' = 'Route Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `service_level` SET TAGS ('dbx_business_glossary_term' = 'Service Level');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `service_level` SET TAGS ('dbx_value_regex' = 'standard|express|economy|priority|deferred');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Transport Plan Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|confirmed|in_execution|executed|cancelled|on_hold');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `tms_plan_reference` SET TAGS ('dbx_business_glossary_term' = 'Transportation Management System (TMS) Plan Reference');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|air|ocean|intermodal|courier');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` SET TAGS ('dbx_subdomain' = 'transport_planning');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `route_id` SET TAGS ('dbx_business_glossary_term' = 'Route ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Logistics Location Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` SET TAGS ('dbx_subdomain' = 'transport_planning');
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
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` SET TAGS ('dbx_subdomain' = 'shipment_delivery');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `address_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `address_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `address_id` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `ar_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ar Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `carrier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Contact Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `freight_order_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `fulfillment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `production_confirmation_id` SET TAGS ('dbx_business_glossary_term' = 'Production Confirmation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `route_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `schedule_line_id` SET TAGS ('dbx_business_glossary_term' = 'Schedule Line Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `spare_parts_request_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Request Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ALTER COLUMN `warranty_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` SET TAGS ('dbx_subdomain' = 'shipment_delivery');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` SET TAGS ('dbx_original_name' = 'logistics_inbound_delivery');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `inbound_delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `ap_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ap Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `freight_order_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `planned_order_id` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `product_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Variant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Receiving Logistics Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `returns_order_id` SET TAGS ('dbx_business_glossary_term' = 'Returns Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `delivery_number` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `delivery_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,35}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `delivery_type` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `delivery_type` SET TAGS ('dbx_value_regex' = 'STANDARD|RETURN|SUBCONTRACTING|CONSIGNMENT|INTERCOMPANY|THIRD_PARTY');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `delivery_value` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Value');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `delivery_value` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `delivery_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `discrepancy_flag` SET TAGS ('dbx_business_glossary_term' = 'Discrepancy Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `discrepancy_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `discrepancy_type` SET TAGS ('dbx_business_glossary_term' = 'Discrepancy Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `discrepancy_type` SET TAGS ('dbx_value_regex' = 'QUANTITY_SHORTAGE|QUANTITY_OVERAGE|DAMAGED_GOODS|WRONG_MATERIAL|DOCUMENTATION_MISSING|QUALITY_REJECTION|NONE');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `expected_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Expected Delivery Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `expected_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `goods_receipt_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `goods_receipt_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `grn_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Note (GRN) Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `grn_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `grn_posting_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Note (GRN) Posting Date');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `grn_posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `material_type` SET TAGS ('dbx_business_glossary_term' = 'Material Type');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `material_type` SET TAGS ('dbx_value_regex' = 'RAW_MATERIAL|COMPONENT|SEMI_FINISHED|FINISHED_GOOD|MRO|PACKAGING|SPARE_PART');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `net_price` SET TAGS ('dbx_business_glossary_term' = 'Net Price per Unit');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `net_price` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `net_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `open_quantity` SET TAGS ('dbx_business_glossary_term' = 'Open (Outstanding) Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `open_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `ordered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Ordered Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `ordered_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `quality_inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Required Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `quality_inspection_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `quality_inspection_status` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `quality_inspection_status` SET TAGS ('dbx_value_regex' = 'NOT_REQUIRED|PENDING|IN_PROGRESS|PASSED|FAILED|CONDITIONALLY_RELEASED');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `received_quantity` SET TAGS ('dbx_business_glossary_term' = 'Received Quantity');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `received_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `serial_number_range` SET TAGS ('dbx_business_glossary_term' = 'Serial Number Range');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Inbound Delivery Status');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'PLANNED|IN_TRANSIT|ARRIVED|PARTIALLY_RECEIVED|FULLY_RECEIVED|CANCELLED|ON_HOLD|DISCREPANCY_REVIEW');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `storage_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `supplier_delivery_note` SET TAGS ('dbx_business_glossary_term' = 'Supplier Delivery Note Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Shipment Tracking Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|LB|M|M2|M3|L|PC|BOX|PALLET|ROLL|SET');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `warehouse_number` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Number');
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ALTER COLUMN `warehouse_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` SET TAGS ('dbx_subdomain' = 'shipment_delivery');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `tracking_event_id` SET TAGS ('dbx_business_glossary_term' = 'Tracking Event ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Logistics Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ALTER COLUMN `stock_transfer_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Transfer Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `currency_exchange_rate_id` SET TAGS ('dbx_business_glossary_term' = 'Currency Exchange Rate Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `freight_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ALTER COLUMN `route_id` SET TAGS ('dbx_business_glossary_term' = 'Route Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `freight_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Invoice ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `account_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Account Hierarchy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `ap_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ap Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `freight_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `freight_order_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `profitability_segment_id` SET TAGS ('dbx_business_glossary_term' = 'Profitability Segment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ALTER COLUMN `tax_code_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` SET TAGS ('dbx_subdomain' = 'shipment_delivery');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `packaging_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `hazardous_substance_id` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Substance Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ALTER COLUMN `product_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Variant Id (Foreign Key)');
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
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `freight_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Contract ID');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `carrier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `currency_exchange_rate_id` SET TAGS ('dbx_business_glossary_term' = 'Currency Exchange Rate Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `sales_org_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Org Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Contract Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto-Renewal Flag');
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_value_regex' = 'true|false');
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
